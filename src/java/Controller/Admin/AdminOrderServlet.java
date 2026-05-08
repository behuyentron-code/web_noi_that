/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Admin;

import DAO.orders_DAO;
import Model.dbConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class AdminOrderServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String method = request.getMethod();

        // XỬ LÝ PHƯƠNG THỨC POST (Cập nhật trạng thái / Hoàn kho)
        if (method.equalsIgnoreCase("POST")) {
            handlePostUpdate(request, response);
            return; 
        }

        // XỬ LÝ PHƯƠNG THỨC GET (Hiển thị danh sách / Chi tiết)
        orders_DAO dao = new orders_DAO();
        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Map<String, Object> order = dao.getOrderDetail(orderId);
            request.setAttribute("order", order);
            request.getRequestDispatcher("/admin/order_detail.jsp").forward(request, response);
        } else {
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            int page = 1;
            int recordsPerPage = 10;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            List<Map<String, Object>> orders = dao.getAllOrders(keyword, status, page, recordsPerPage);
            int totalRecords = dao.countOrders(keyword, status);
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            request.setAttribute("orders", orders);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);
            request.setAttribute("statusFilter", status);
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        }
    }

    /**
     * Hỗ trợ xử lý logic POST trong processRequest
     */
    private void handlePostUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
            try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");

            orders_DAO dao = new orders_DAO();

            // Gọi hàm xử lý Transaction từ DAO
            boolean isUpdated = dao.handleUpdateStatusWithTransaction(orderId, newStatus);

            if (isUpdated) {
                // Chuyển hướng về trang danh sách với thông báo thành công (tùy chọn)
                response.sendRedirect(request.getContextPath() + "/AdminOrderServlet");
            } else {
                response.getWriter().println("Cập nhật thất bại. Vui lòng kiểm tra lại ID đơn hàng.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn hàng không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi hệ thống: " + e.getMessage());
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
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

    /**
     * Handles the HTTP <code>POST</code> method.
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

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Order Management Servlet";
    }// </editor-fold>

}