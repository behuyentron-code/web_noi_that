///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package Controller;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import DAO.users_DAO;
//
///**
// *
// * @author TRAN ANH DUC
// */
//public class login extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String user = request.getParameter("username");
//        String pass = request.getParameter("password");
//        String action = request.getParameter("action");
//
//        users_DAO dao = new users_DAO();
//
//        if ("logout".equals(action)) {
//            HttpSession session = request.getSession(false);
//
//            if (session != null) {
//                session.invalidate();
//            }
//
//            response.sendRedirect("hienthi");
//            return;
//        }
//
//        if ("login".equals(action)) {
//            if (!dao.isUsernameExist(user)) {
//                request.setAttribute("mess", "Bạn chưa có tài khoản!");
//                request.setAttribute("username", user);
//
////                request.getRequestDispatcher("Login.jsp").forward(request, response);
//                HttpSession session = request.getSession();
//                session.setAttribute("loginError", "Bạn chưa có tài khoản!");
//                session.setAttribute("loginUsername", user);
//                response.sendRedirect("hienthi?openModal=login");
//                return;
//            }
//
//            // 🔐 kiểm tra mật khẩu
//            String us = dao.checkLogin(user, pass);
//
//            if (us == null) {
//                request.setAttribute("mess", "Sai mật khẩu!");
//                request.setAttribute("username", user);
//
////                request.getRequestDispatcher("Login.jsp").forward(request, response);
//
//                HttpSession session = request.getSession();
//                session.setAttribute("loginError", "Sai mật khẩu!");
//                session.setAttribute("loginUsername", user);
//                response.sendRedirect("hienthi?openModal=login");
//                return;
//            } else {
//                HttpSession session = request.getSession();
//                session.setAttribute("user", us);
//                session.setMaxInactiveInterval(50000);
//
//                response.sendRedirect("hienthi");
//                return;
//            }
//        }
//
//        if ("register".equals(action)) {
//            String confirmPass = request.getParameter("confirmPassword");
//            
//             // Kiểm tra mật khẩu nhập lại
//            if (confirmPass == null || !confirmPass.equals(pass)) {
//                HttpSession session = request.getSession();
//                session.setAttribute("registerError", "Mật khẩu nhập lại không khớp!");
//                session.setAttribute("registerUsername", user);
//                response.sendRedirect("hienthi?openModal=register");
//                return;
//            }
//            if (dao.isUsernameExist(user)) {
//                request.setAttribute("mess", "Username đã tồn tại!");
////                request.getRequestDispatcher("Register.jsp").forward(request, response);
//                
//                HttpSession session = request.getSession();
//                session.setAttribute("registerError", "Email đã tồn tại!");
//                session.setAttribute("registerUsername", user);
//                response.sendRedirect("hienthi?openModal=register");
//                return;
//            }
//
//            boolean success = dao.register(user, pass);
//
//            if (success) {
//                // đăng ký xong → login luôn
//                HttpSession session = request.getSession();
//                session.setAttribute("user", user);
//
//                response.sendRedirect("hienthi");
//            } else {
//                request.setAttribute("mess", "Đăng ký thất bại!");
////                request.getRequestDispatcher("Register.jsp").forward(request, response);
//
//                HttpSession session = request.getSession();
//                session.setAttribute("registerError", "Đăng ký thất bại!");
//                session.setAttribute("registerUsername", user);
//                response.sendRedirect("hienthi?openModal=register");
//                
//                
//            }
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
package Controller;

import DAO.users_DAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class login extends HttpServlet {

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

            HttpSession session = request.getSession();
            session.setAttribute("user", us);
            session.setMaxInactiveInterval(50000);
            response.sendRedirect("hienthi");
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
                response.sendRedirect("hienthi");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("registerError", "Đăng ký thất bại, vui lòng thử lại!");
                response.sendRedirect("hienthi?openModal=register");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }
}