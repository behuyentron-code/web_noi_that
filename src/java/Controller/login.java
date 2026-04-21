/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author TRAN ANH DUC
 */
public class login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String user = request.getParameter("username");
    String pass = request.getParameter("password");
    String action = request.getParameter("action");

    HttpSession session = request.getSession();

    if ("login".equals(action)) {
        if ("admin".equals(user) && "123".equals(pass)) {
            // ✅ Đăng nhập đúng → lưu session, về trang chủ
            session.setAttribute("user", user);
            response.sendRedirect("hienthi");  // về servlet hienthi để load sản phẩm
            return;
        } else {
            // ❌ Đăng nhập sai → báo lỗi, mở lại modal
            session.setAttribute("loginError", "Sai tài khoản hoặc mật khẩu!");
            response.sendRedirect("hienthi?openModal=login");
            return;
        }
    }

    if ("register".equals(action)) {
        if (user != null && !user.trim().isEmpty()) {
            // ✅ Đăng ký thành công
            session.setAttribute("user", user);
            response.sendRedirect("hienthi");
            return;
        } else {
            session.setAttribute("loginError", "Thông tin đăng ký không hợp lệ!");
            response.sendRedirect("hienthi?openModal=register");
            return;
        }
    }

    response.sendRedirect("hienthi");
}

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
