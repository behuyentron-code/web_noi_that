/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.dbConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
public class users_DAO {
    /**
     * Kiểm tra đăng nhập.
     * @return username nếu đúng, null nếu sai
     */
    
    public String checkLogin(String username, String password) {
        String sql = "SELECT username FROM users WHERE username = ? AND password = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
 
            ps.setString(1, username);
            ps.setString(2, password);   // nếu sau này dùng hash thì thay ở đây
 
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("username");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(users_DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
 
    /**
     * Kiểm tra username đã tồn tại chưa.
     */
    public boolean isUsernameExist(String username) {
        String sql = "SELECT user_id FROM users WHERE username = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
 
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(users_DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
 
       public boolean isEmailExist(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception ex) {
            Logger.getLogger(users_DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
       
    /**
     * Đăng ký tài khoản mới.
     * @return true nếu thành công
     */
    public boolean register(String username, String email, String phone, String address, String password) {
        String sql = "INSERT INTO users (username, email, phone, address, password, role) VALUES (?, ?, ?, ?, ?, 'user')";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setString(5, password);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            Logger.getLogger(users_DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public Map<String, Object> getUserById(int id) {
        Map<String, Object> user = new HashMap<>();
        String sql = "SELECT user_id, username, email, phone, role FROM users WHERE user_id = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user.put("user_id", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("phone", rs.getString("phone"));
                user.put("role", rs.getString("role"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return user;
    }
    
      // Lấy user chỉ có role = 'user' (có phân trang, tìm kiếm)
    public List<Map<String, Object>> getAllUsersOnly(String keyword, int page, int recordsPerPage) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT user_id, username, email, phone FROM users WHERE role = 'user'");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR email LIKE ? OR phone LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        sql.append(" ORDER BY user_id DESC LIMIT ? OFFSET ?");
        params.add(recordsPerPage);
        params.add((page - 1) * recordsPerPage);

        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("user_id", rs.getInt("user_id"));
                map.put("username", rs.getString("username"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int countUsersOnly(String keyword) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE role = 'user'");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR email LIKE ? OR phone LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public void addUser(String username, String email, String phone, String password, String role) {
        String sql = "INSERT INTO users (username, email, phone, password, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password);
            ps.setString(5, role);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateUser(int id, String username, String email, String phone, String password) {
        String sql = "UPDATE users SET username=?, email=?, phone=?, password=? WHERE user_id=?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password);
            ps.setInt(5, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteUser(int id) {
        String sql = "DELETE FROM users WHERE user_id=?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    
    public String getRole(String username) {
        String role = "user";
        
        String sql = "SELECT role FROM users WHERE username = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) role = rs.getString("role");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return role;
    }
    
    public int getAllUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }
}