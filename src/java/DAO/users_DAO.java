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
}
