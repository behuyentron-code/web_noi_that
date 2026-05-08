/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author Admin
 */

import Model.dbConnect;
import Model.products;
import java.sql.*;
import java.util.*;


public class products_DAO {

    private static final String BASE_SQL =
        "SELECT p.product_id, p.product_name, p.price, p.description, " +
        "       p.image, p.category_id, c.category_name, " +
        "       p.discount_price, p.quantity " +   
        "FROM products p " +
        "JOIN categories c ON p.category_id = c.category_id ";
 
    /** Lấy tất cả sản phẩm */
    public List<products> getAllProducts() {
        System.out.println("=== getAllProducts called ===");
        return query(BASE_SQL + "ORDER BY p.product_id ASC", null);
    }
 
    /** Lọc theo tên danh mục */
    public List<products> getProductsByCategory(String categoryName) {
        System.out.println("=== getProductsByCategory: " + categoryName + " ===");
        return query(BASE_SQL + "WHERE c.category_name = ? ORDER BY p.product_id ASC", categoryName);
    }
      
    public List<products> searchProducts(String keyword, String category) {
        List<products> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, c.category_name FROM products p " +
            "JOIN categories c ON p.category_id = c.category_id " +
            "WHERE p.product_name LIKE ?"
        );
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND c.category_name = ?");
        }

        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, "%" + keyword + "%");
            if (category != null && !category.trim().isEmpty()) {
                ps.setString(2, category.trim());
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products p = new products();
                p.setProduct_id(rs.getInt("product_id"));
                p.setProduct_name(rs.getString("product_name"));
                p.setPrice(rs.getDouble("price"));
                p.setDescription(rs.getString("description"));
                p.setImage(rs.getString("image"));
                p.setCategory_id(rs.getInt("category_id"));
                p.setCategoryName(rs.getString("category_name"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Lấy 1 sản phẩm theo ID (dùng cho trang chi tiết) */
    public products getProductById(int productId) {
        String sql = BASE_SQL + "WHERE p.product_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new dbConnect().getConnect();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new products(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getDouble("price"),
                    rs.getString("description"),
                    rs.getString("image"),
                    rs.getInt("category_id"),
                    rs.getString("category_name"),
                    rs.getLong("discount_price"),   
                    rs.getInt("quantity")
                );
            }
        } catch (Exception e) {
            System.err.println("[products_DAO] getProductById error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch(Exception e) {}
            try { if (ps != null) ps.close(); } catch(Exception e) {}
            try { if (conn != null) conn.close(); } catch(Exception e) {}
        }
        return null;
    }
    
    // Thêm sản phẩm mới
    public boolean addProduct(products p) {
        String sql = "INSERT INTO products (product_name, price, description, image, category_id, quantity, discount_price) VALUES (?, ?, ?, ?, ?, ?, ?)";        try (Connection conn = new dbConnect().getConnect();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getProduct_name());
            ps.setDouble(2, p.getPrice());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getImage());
            ps.setInt(5, p.getCategory_id());
            ps.setInt(6, p.getQuantity());
            ps.setLong(7, p.getDiscount_price());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật sản phẩm
    public boolean updateProduct(products p) {
        String sql = "UPDATE products SET product_name=?, price=?, description=?, image=?, category_id=?, quantity=?, discount_price=? WHERE product_id=?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getProduct_name());
            ps.setDouble(2, p.getPrice());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getImage());
            ps.setInt(5, p.getCategory_id());
            ps.setInt(6, p.getQuantity());        
            ps.setLong(7, p.getDiscount_price());  
            ps.setInt(8, p.getProduct_id());     
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa sản phẩm
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    

    // Lấy danh sách tất cả tên danh mục (cho menu)
    public List<String> getAllCategoryNames() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT category_name FROM categories ORDER BY category_id";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("category_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    
    
    private List<products> query(String sql, String param) {
        List<products> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = new dbConnect().getConnect();
            ps = conn.prepareStatement(sql);
 
            if (param != null) {
                ps.setString(1, param);
                System.out.println("Executing query with param: " + param);
            }
            
            System.out.println("SQL: " + sql);
            rs = ps.executeQuery();
 
            while (rs.next()) {
                products p = new products(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getDouble("price"),
                    rs.getString("description"),
                    rs.getString("image"),
                    rs.getInt("category_id"),
                    rs.getString("category_name"),
                    rs.getLong("discount_price"), 
                    rs.getInt("quantity")         
                );
                list.add(p);
                System.out.println("Loaded product: " + p.getProduct_name());
            }
            System.out.println("Total products loaded: " + list.size());
            
        } catch (SQLException e) {
            System.err.println("[ProductDAO] query SQL Error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception ex) {
            System.err.println("[ProductDAO] query Error: " + ex.getMessage());
            ex.printStackTrace();
        }
        return list;
    }

    
    
    
        /*
        * Lấy tất cả sản phẩm khuyến mãi (giá <= 2.000.000đ).
        * Bạn có thể thêm cột `is_promo` vào DB sau này và đổi điều kiện ở đây.
        */
      public List<products> getProductsOnSale() {
        String sql = BASE_SQL +
                "WHERE p.discount_price > 0 " +
                "ORDER BY p.price ASC";
        return query(sql, null);
      }
      
      
       /**
        * Lấy sản phẩm khuyến mãi theo danh mục.
        */
    public List<products> getProductsOnSaleByCategory(String categoryName) {
        String sql = BASE_SQL +
                "WHERE p.discount_price > 0 AND c.category_name = ? " +
                "ORDER BY p.price ASC";
        return query(sql, categoryName);
    }
      
    public boolean reduceQuantity(int productId, int qty) {
    String sql = "UPDATE products SET quantity = quantity - ? " +
                 "WHERE product_id = ? AND quantity >= ?";
    try (Connection con = new dbConnect().getConnect();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, qty);
        ps.setInt(2, productId);
        ps.setInt(3, qty); // điều kiện: chỉ trừ nếu còn đủ hàng
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
}
