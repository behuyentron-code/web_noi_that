/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
*/

package Controller.Admin;

import DAO.products_DAO;
import DAO.users_DAO;
import Model.dbConnect;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        products_DAO productDao = new products_DAO();
        users_DAO userDao = new users_DAO();
        int totalProducts = productDao.getAllProducts().size();
        int totalUsers = userDao.getAllUsers(); // cần thêm method getAllUsers
        int totalOrders = 0;
        double totalRevenue = 0;
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS count FROM orders");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalOrders = rs.getInt("count");
        } catch (Exception e) { e.printStackTrace(); }
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement("SELECT SUM(total_price) AS revenue FROM orders WHERE status != 'cancelled'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalRevenue = rs.getDouble("revenue");
        } catch (Exception e) { e.printStackTrace(); }
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalRevenue", totalRevenue);
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}