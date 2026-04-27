/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.dbConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class categories_DAO {
     public List<Map<String, Object>> getAllCategories(String keyword, int page, int recordsPerPage) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT category_id, category_name FROM categories WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND category_name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        sql.append(" ORDER BY category_id LIMIT ? OFFSET ?");
        params.add(recordsPerPage);
        params.add((page - 1) * recordsPerPage);

        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("category_id", rs.getInt("category_id"));
                map.put("category_name", rs.getString("category_name"));
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int countCategories(String keyword) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM categories WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND category_name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public Map<String, Object> getCategoryById(int id) {
        Map<String, Object> map = new HashMap<>();
        String sql = "SELECT category_id, category_name FROM categories WHERE category_id = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                map.put("category_id", rs.getInt("category_id"));
                map.put("category_name", rs.getString("category_name"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    public void addCategory(String name) {
        String sql = "INSERT INTO categories (category_name) VALUES (?)";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateCategory(int id, String name) {
        String sql = "UPDATE categories SET category_name = ? WHERE category_id = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

   public boolean deleteCategory(int id) {
    String sql = "DELETE FROM categories WHERE category_id = ?";
    try (Connection conn = new dbConnect().getConnect();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        return ps.executeUpdate() > 0; // ✅ check có xóa thật không
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
   
   public boolean hasProducts(int categoryId) {
    String sql = "SELECT COUNT(*) FROM products WHERE category_id = ?";
    try (Connection conn = new dbConnect().getConnect();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, categoryId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

}
