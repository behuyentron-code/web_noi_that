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

    private static final String BASE_SQL
            = "SELECT p.product_id, p.product_name, p.price, p.description, "
            + "       p.image, p.category_id, c.category_name "
            + "FROM products p "
            + "JOIN categories c ON p.category_id = c.category_id ";

    /**
     * Lấy tất cả sản phẩm
     */
    public List<products> getAllProducts() {
        System.out.println("=== getAllProducts called ===");
        return query(BASE_SQL + "ORDER BY p.product_id ASC", null);
    }

    /**
     * Lọc theo tên danh mục
     */
    public List<products> getProductsByCategory(String categoryName) {
        System.out.println("=== getProductsByCategory: " + categoryName + " ===");
        return query(BASE_SQL + "WHERE c.category_name = ? ORDER BY p.product_id ASC", categoryName);
    }

    /**
     * Lấy 1 sản phẩm theo ID (dùng cho trang chi tiết)
     */
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
                        rs.getString("category_name")
                );
            }
        } catch (Exception e) {
            System.err.println("[products_DAO] getProductById error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
        return null;
    }

    /**
     * Lấy danh sách tên tất cả danh mục
     */
    public List<String> getAllCategoryNames() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT category_name FROM categories ORDER BY category_id ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new dbConnect().getConnect();
            System.out.println("Database connected successfully");

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("category_name"));
            }
            System.out.println("Categories found: " + list.size());

        } catch (SQLException e) {
            System.err.println("[ProductDAO] getAllCategoryNames SQL Error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception ex) {
            System.err.println("[ProductDAO] getAllCategoryNames Error: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
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
                        rs.getString("category_name")
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
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
        return list;
    }

    public String getAllForChatbot() {
        StringBuilder sb = new StringBuilder();

        List<products> list = getAllProducts();

        for (products p : list) {
            sb.append(p.getProduct_name())
                    .append(": ")
                    .append(p.getPrice())
                    .append("đ; ");
        }

        return sb.toString();
    }

}
