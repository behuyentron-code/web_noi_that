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

/**
 *
 * @author Admin
 */

public class orders_DAO {

    // 1. Lấy danh sách đơn hàng (Chuyển sang public)
    public List<Map<String, Object>> getAllOrders(String keyword, String status, int page, int recordsPerPage) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT o.order_id, u.username, o.order_date, o.total_price, o.status " +
            "FROM orders o JOIN users u ON o.user_id = u.user_id WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR o.order_id LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        
        if (status != null && !status.trim().isEmpty() && !"all".equals(status)) {
            sql.append(" AND o.status = ?");
            params.add(status);
        }
        
        sql.append(" ORDER BY o.order_id DESC LIMIT ? OFFSET ?");
        params.add(recordsPerPage);
        params.add((page - 1) * recordsPerPage);

        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("order_id", rs.getInt("order_id"));
                map.put("username", rs.getString("username"));
                map.put("order_date", rs.getTimestamp("order_date"));
                map.put("total_price", rs.getDouble("total_price"));
                map.put("status", rs.getString("status"));
                list.add(map);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // 2. Đếm tổng số đơn hàng để phân trang (Chuyển sang public)
    public int countOrders(String keyword, String status) {
        int count = 0;
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM orders o JOIN users u ON o.user_id = u.user_id WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR o.order_id LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        
        if (status != null && !status.trim().isEmpty() && !"all".equals(status)) {
            sql.append(" AND o.status = ?");
            params.add(status);
        }
        
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return count;
    }

    // 3. Lấy chi tiết một đơn hàng (Chuyển sang public)
    public Map<String, Object> getOrderDetail(int orderId) {
        Map<String, Object> order = new HashMap<>();
        // Lấy thông tin đơn hàng và người mua
        String sql = "SELECT o.*, u.username, u.email, u.phone FROM orders o JOIN users u ON o.user_id = u.user_id WHERE o.order_id = ?";
        
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order.put("order_id", rs.getInt("order_id"));
                    order.put("username", rs.getString("username"));
                    order.put("email", rs.getString("email"));
                    order.put("phone", rs.getString("phone"));
                    order.put("shipping_address", rs.getString("shipping_address"));
                    order.put("payment_method", rs.getString("payment_method"));
                    order.put("total_price", rs.getDouble("total_price"));
                    order.put("status", rs.getString("status"));
                    order.put("order_date", rs.getTimestamp("order_date"));
                }
            }

            // Lấy danh sách sản phẩm trong đơn hàng đó (order_details)
            List<Map<String, Object>> items = new ArrayList<>();
            String sqlItems = "SELECT od.*, p.product_name, p.image FROM order_details od " +
                             "JOIN products p ON od.product_id = p.product_id WHERE od.order_id = ?";
            
            try (PreparedStatement psItems = conn.prepareStatement(sqlItems)) {
                psItems.setInt(1, orderId);
                try (ResultSet rsItems = psItems.executeQuery()) {
                    while (rsItems.next()) {
                        Map<String, Object> item = new HashMap<>();
                        item.put("product_name", rsItems.getString("product_name"));
                        item.put("quantity", rsItems.getInt("quantity"));
                        item.put("price", rsItems.getDouble("price"));
                        item.put("image", rsItems.getString("image"));
                        items.add(item);
                    }
                }
            }
            order.put("items", items);
            
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return order;
    }

    // 4. Cập nhật trạng thái đơn hàng (Thêm mới để Admin có thể duyệt đơn)
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    //xử lý việc cập nhật trạng thái và hoàn kho trong một giao dịch
    public boolean handleUpdateStatusWithTransaction(int orderId, String newStatus) {
        String sqlCurrent = "SELECT status FROM orders WHERE order_id = ? FOR UPDATE";
        String sqlDetails = "SELECT product_id, quantity FROM order_details WHERE order_id = ?";
        String sqlRestore = "UPDATE products SET quantity = quantity + ? WHERE product_id = ?";
        String sqlUpdate = "UPDATE orders SET status = ? WHERE order_id = ?";

        // Khởi tạo kết nối (Tự động đóng nhờ Try-with-resources)
        try (Connection conn = new dbConnect().getConnect()) {
            if (conn == null) return false;

            conn.setAutoCommit(false); // Bắt đầu Transaction

            try (PreparedStatement psGetStatus = conn.prepareStatement(sqlCurrent);
                 PreparedStatement psGetDetails = conn.prepareStatement(sqlDetails);
                 PreparedStatement psRestoreStock = conn.prepareStatement(sqlRestore);
                 PreparedStatement psUpdateStatus = conn.prepareStatement(sqlUpdate)) {

                // 1. Kiểm tra trạng thái hiện tại
                psGetStatus.setInt(1, orderId);
                String oldStatus = null;
                try (ResultSet rs = psGetStatus.executeQuery()) {
                    if (rs.next()) {
                        oldStatus = rs.getString("status");
                    }
                }

                // Nếu đơn hàng không tồn tại
                if (oldStatus == null) {
                    conn.rollback();
                    return false;
                }

                // 2. Logic hoàn kho: Chỉ thực hiện khi chuyển từ trạng thái khác sang 'cancelled'
                if ("cancelled".equals(newStatus) && !"cancelled".equals(oldStatus)) {
                    psGetDetails.setInt(1, orderId);
                    try (ResultSet rsDetails = psGetDetails.executeQuery()) {
                        while (rsDetails.next()) {
                            int productId = rsDetails.getInt("product_id");
                            int quantity = rsDetails.getInt("quantity");

                            psRestoreStock.setInt(1, quantity);
                            psRestoreStock.setInt(2, productId);
                            psRestoreStock.addBatch(); // Thêm vào batch để tối ưu hiệu suất
                        }
                    }
                    psRestoreStock.executeBatch(); // Chạy lệnh cập nhật kho hàng loạt
                }

                // 3. Cập nhật trạng thái đơn hàng
                psUpdateStatus.setString(1, newStatus);
                psUpdateStatus.setInt(2, orderId);
                int rowsAffected = psUpdateStatus.executeUpdate();

                if (rowsAffected > 0) {
                    conn.commit(); // Mọi thứ ổn, xác nhận thay đổi vào DB
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }

            } catch (SQLException e) {
                conn.rollback(); // Có lỗi SQL, hoàn tác mọi thay đổi
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}