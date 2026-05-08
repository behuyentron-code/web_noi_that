/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Admin;

import DAO.products_DAO;
import DAO.users_DAO;
import Model.dbConnect;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.NumberFormat;
import java.util.Locale;

/**
 *
 * @author Admin
 */
public class AdminDashboardServlet extends HttpServlet {
   
    /** * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Khởi tạo các DAO
        products_DAO productDao = new products_DAO();
        users_DAO userDao = new users_DAO();
        
        // Lấy dữ liệu thống kê
        int totalProducts = productDao.getAllProducts().size();
        int totalUsers = userDao.getAllUsers(); // Yêu cầu method getAllUsers tồn tại trong users_DAO
        int totalOrders = 0;
        double totalRevenue = 0;

        // Truy vấn số lượng đơn hàng
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS count FROM orders");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalOrders = rs.getInt("count");
        } catch (Exception e) { 
            e.printStackTrace(); 
        }

        // Truy vấn tổng doanh thu (loại bỏ các đơn hàng bị hủy)
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement("SELECT SUM(total_price) AS revenue FROM orders WHERE status != 'cancelled'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalRevenue = rs.getDouble("revenue");
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        
        // Định dạng tiền tệ VNĐ
        NumberFormat fmt = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        String totalRevenueFormatted = fmt.format(totalRevenue);
        
        // Đẩy dữ liệu sang trang JSP
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenueFormatted", totalRevenueFormatted);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Dashboard Servlet for managing statistics";
    }// </editor-fold>

}