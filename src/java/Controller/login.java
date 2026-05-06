/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import DAO.users_DAO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author Admin
 */
public class login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        users_DAO dao = new users_DAO();

        // ===== LOGOUT =====
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect("hienthi");
            return;
        }

        // ===== LOGIN =====
        if ("login".equals(action)) {
            String username = request.getParameter("username");
            String pass = request.getParameter("password");

            if (!dao.isUsernameExist(username)) {
                HttpSession session = request.getSession();
                session.setAttribute("loginError", "Tài khoản không tồn tại!");
                session.setAttribute("loginUsername", username);
                response.sendRedirect("hienthi?openModal=login");
                return;
            }

            String us = dao.checkLogin(username, pass);
            if (us == null) {
                HttpSession session = request.getSession();
                session.setAttribute("loginError", "Sai mật khẩu!");
                session.setAttribute("loginUsername", username);
                response.sendRedirect("hienthi?openModal=login");
                return;
            }
// ===== LOGIN thành công =====
            HttpSession session = request.getSession();
            session.setAttribute("user", us);
            session.setMaxInactiveInterval(50000);

            // Lấy role từ database
            String role = dao.getRole(us);
            session.setAttribute("role", role); 
            
            //Thông báo đăng nhập thành công
            session.setAttribute("loginSuccess", "Đăng nhập thành công! Chào mừng " + us + " 👋");
            // Điều hướng theo role
            if ("admin".equals(role)) {
                System.out.println("Redirect to: " + request.getContextPath() + "/AdminOrderServlet");
                response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
            } else {
                response.sendRedirect(request.getContextPath() + "/hienthi");
            }
            return;
        }

        // ===== REGISTER =====
        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String email    = request.getParameter("email");
            String phone    = request.getParameter("phone");
            String address  = request.getParameter("address");
            String pass     = request.getParameter("password");
            String confirm  = request.getParameter("confirmPassword");

            // Kiểm tra email đã nhập đúng định dạng chưa
            if (email == null || !email.contains("@") || !email.endsWith("@gmail.com")
                    || email.indexOf("@") == 0
                    || email.indexOf("@") != email.lastIndexOf("@")) {
                HttpSession session = request.getSession();
                session.setAttribute("registerError", "Email phải là Gmail hợp lệ!");
                session.setAttribute("regUsername", username);
                session.setAttribute("regEmail", email);
                session.setAttribute("regPhone", phone);
                session.setAttribute("regAddress", address);
                response.sendRedirect("hienthi?openModal=register");
                return;
            }

            // Kiểm tra mật khẩu nhập lại
            if (confirm == null || !confirm.equals(pass)) {
                HttpSession session = request.getSession();
                session.setAttribute("registerError", "Mật khẩu nhập lại không khớp!");
                session.setAttribute("regUsername", username);
                session.setAttribute("regEmail", email);
                session.setAttribute("regPhone", phone);
                session.setAttribute("regAddress", address);
                response.sendRedirect("hienthi?openModal=register");
                return;
            }

            // Kiểm tra username đã tồn tại
            if (dao.isUsernameExist(username)) {
                HttpSession session = request.getSession();
                session.setAttribute("registerError", "Tên đăng nhập đã tồn tại!");
                session.setAttribute("regUsername", username);
                session.setAttribute("regEmail", email);
                session.setAttribute("regPhone", phone);
                session.setAttribute("regAddress", address);
                response.sendRedirect("hienthi?openModal=register");
                return;
            }

            // Kiểm tra email đã tồn tại
            if (dao.isEmailExist(email)) {
                HttpSession session = request.getSession();
                session.setAttribute("registerError", "Email đã được sử dụng!");
                session.setAttribute("regUsername", username);
                session.setAttribute("regEmail", email);
                session.setAttribute("regPhone", phone);
                session.setAttribute("regAddress", address);
                response.sendRedirect("hienthi?openModal=register");
                return;
            }

            boolean success = dao.register(username, email, phone, address, pass);
            if (success) {
                HttpSession session = request.getSession();
                session.setAttribute("user", username);
                
                //Thông báo đăng ký thành công
                session.setAttribute("registerSuccess", "Đăng ký thành công! Chào mừng " + username + " 🎉");
                response.sendRedirect("hienthi");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("registerError", "Đăng ký thất bại, vui lòng thử lại!");
                response.sendRedirect("hienthi?openModal=register");
            }
        }

        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet login</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet login at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        return "Short description";
    }// </editor-fold>

}