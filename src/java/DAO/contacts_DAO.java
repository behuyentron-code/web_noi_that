package DAO;

import Model.contacts;
import Model.dbConnect;
import java.sql.*;
import java.util.*;

public class contacts_DAO {

    /**
     * User gửi tin nhắn liên hệ → INSERT vào DB
     * @return true nếu thành công
     */
    public boolean insert(String name, String email, String phone, String message) {
        String sql = "INSERT INTO contacts (name, email, phone, message) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new dbConnect().getConnect();
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, message);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[contacts_DAO] insert error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return false;
    }

    /**
     * Admin xem toàn bộ danh sách liên hệ, mới nhất lên đầu
     */
    public List<contacts> getAll() {
        List<contacts> list = new ArrayList<>();
        String sql = "SELECT * FROM contacts ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new dbConnect().getConnect();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                contacts c = new contacts(
                    rs.getInt("contact_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("message"),
                    rs.getDate("created_at")
                );
                list.add(c);
            }
        } catch (Exception e) {
            System.err.println("[contacts_DAO] getAll error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }

    public boolean update(int id, String name, String phone, String message) {
        String sql = "UPDATE contacts SET name = ?, phone = ?, message = ? WHERE contact_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new dbConnect().getConnect();
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, message);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[contacts_DAO] insert error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { 
                if (ps != null) ps.close(); 
            } catch (Exception e) {
                
            }
            
            try { 
                if (conn != null) 
                    conn.close(); 
            } catch (Exception e) {
            
            }
        }
        return false;
    }
    
    /**
     * Admin xóa liên hệ theo ID
     * @return true nếu xóa thành công
     */
    public boolean delete(int contact_id) {
        String sql = "DELETE FROM contacts WHERE contact_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new dbConnect().getConnect();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, contact_id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[contacts_DAO] delete error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return false;
    }
    
    public int countContactsByEmail(String email) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM contacts WHERE email = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
      
    public List<Map<String, Object>> getContactsByEmail(String email) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT contact_id, name, email, phone, message, created_at FROM contacts WHERE email = ? ORDER BY created_at DESC";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("contact_id", rs.getInt("contact_id"));
                map.put("name", rs.getString("name"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                map.put("message", rs.getString("message"));
                map.put("created_at", rs.getTimestamp("created_at"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
        public Map<String, Object> getContactById(int id) {
        Map<String, Object> contact = null;
        String sql = "SELECT contact_id, name, email, phone, message, created_at FROM contacts WHERE contact_id = ?";

        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    contact = new java.util.HashMap<>();
                    contact.put("contact_id", rs.getInt("contact_id"));
                    contact.put("name", rs.getString("name"));
                    contact.put("email", rs.getString("email"));
                    contact.put("phone", rs.getString("phone"));
                    contact.put("message", rs.getString("message"));
                    contact.put("created_at", rs.getTimestamp("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return contact;
    }
}