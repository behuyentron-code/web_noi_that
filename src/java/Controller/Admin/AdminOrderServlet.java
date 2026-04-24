/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Admin;

import Model.dbConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class AdminOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            Map<String, Object> order = getOrderDetail(orderId);
            req.setAttribute("order", order);
            req.getRequestDispatcher("/admin/order_detail.jsp").forward(req, resp);
        } else {
            // Lấy tham số tìm kiếm, lọc
            String keyword = req.getParameter("keyword");
            String status = req.getParameter("status");
            int page = 1;
            int recordsPerPage = 10;
            if (req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));

            List<Map<String, Object>> orders = getAllOrders(keyword, status, page, recordsPerPage);
            int totalRecords = countOrders(keyword, status);
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            req.setAttribute("orders", orders);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("keyword", keyword);
            req.setAttribute("statusFilter", status);
            req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("orderId"));
        String status = req.getParameter("status");
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement("UPDATE orders SET status = ? WHERE order_id = ?")) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }

    private List<Map<String, Object>> getAllOrders(String keyword, String status, int page, int recordsPerPage) {
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
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private int countOrders(String keyword, String status) {
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
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    private Map<String, Object> getOrderDetail(int orderId) {
        Map<String, Object> order = new HashMap<>();
        String sql = "SELECT o.*, u.username, u.email, u.phone FROM orders o JOIN users u ON o.user_id = u.user_id WHERE o.order_id = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order.put("order_id", rs.getInt("order_id"));
                order.put("username", rs.getString("username"));
                order.put("shipping_address", rs.getString("shipping_address"));
                order.put("payment_method", rs.getString("payment_method"));
                order.put("total_price", rs.getDouble("total_price"));
                order.put("status", rs.getString("status"));
                order.put("order_date", rs.getTimestamp("order_date"));
            }
            rs.close();
        } catch (Exception e) { e.printStackTrace(); }
        List<Map<String, Object>> items = new ArrayList<>();
        String sql2 = "SELECT od.*, p.product_name, p.image FROM order_details od JOIN products p ON od.product_id = p.product_id WHERE od.order_id = ?";
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(sql2)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("product_name", rs.getString("product_name"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("price", rs.getDouble("price"));
                item.put("image", rs.getString("image"));
                items.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        order.put("items", items);
        return order;
    }
}