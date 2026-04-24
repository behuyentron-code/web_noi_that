package Controller;

import DAO.users_DAO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import DAO.users_DAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
                session.setAttribute("loginError", "Bạn chưa có tài khoản!");
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
                session.setAttribute("registerError", "Mật khẩu không hợp lệ!");
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