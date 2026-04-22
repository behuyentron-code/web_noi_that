/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAO.users_DAO;

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

        users_DAO dao = new users_DAO();

        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);

            if (session != null) {
                session.invalidate();
            }

            response.sendRedirect("hienthi");
            return;
        }

        if ("login".equals(action)) {
            if (!dao.isUsernameExist(user)) {
                request.setAttribute("mess", "Bạn chưa có tài khoản!");
                request.setAttribute("username", user);

                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }

            // 🔐 kiểm tra mật khẩu
            String us = dao.checkLogin(user, pass);

            if (us == null) {
                request.setAttribute("mess", "Sai mật khẩu!");
                request.setAttribute("username", user);

                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("user", us);
                session.setMaxInactiveInterval(50000);

                response.sendRedirect("hienthi");
                return;
            }
        }

        if ("register".equals(action)) {
            if (dao.isUsernameExist(user)) {
                request.setAttribute("mess", "Username đã tồn tại!");
                request.getRequestDispatcher("Register.jsp")
                        .forward(request, response);
                return;
            }

            boolean success = dao.register(user, pass);

            if (success) {
                // đăng ký xong → login luôn
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                response.sendRedirect("hienthi");
            } else {
                request.setAttribute("mess", "Đăng ký thất bại!");
                request.getRequestDispatcher("Register.jsp")
                        .forward(request, response);
            }
        }
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
