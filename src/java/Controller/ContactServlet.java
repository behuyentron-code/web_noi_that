/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.products_DAO;
import Model.dbConnect;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
import java.util.List;
import static sun.jvm.hotspot.HelloWorld.e;

/**
 *
 * @author TRANG ANH LAPTOP
 */

public class ContactServlet extends HttpServlet {

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
        
       //Tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Lấy danh sách categories cho dropdown (luôn lấy)
        products_DAO dao = new products_DAO();
        List<String> categories = dao.getAllCategoryNames();
        request.setAttribute("categories", categories);

        // Lấy session kiểm tra đăng nhập
        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("user"); // tên đăng nhập

        // Nếu là GET -> chỉ hiển thị trang
        if (request.getMethod().equalsIgnoreCase("GET")) {
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }

        // ========== XỬ LÝ POST GỬI LIÊN HỆ ==========
        // Kiểm tra đăng nhập
        if (loggedUser == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để gửi liên hệ!");
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }

        // Lấy dữ liệu từ form
        String inputName = request.getParameter("name");
        String inputEmail = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        // Validate cơ bản
        if (inputName == null || inputName.trim().isEmpty() ||
            inputEmail == null || inputEmail.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng điền đầy đủ họ tên, email, số điện thoại và nội dung!");
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }

        // 1. Lấy thông tin đăng ký của user từ database
        String registeredEmail = null;
        String registeredName = null; // Trong bảng users, tên đăng nhập chính là username

        try (Connection conn = new dbConnect().getConnect()) {
            String sql = "SELECT username, email FROM users WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, loggedUser);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                registeredName = rs.getString("username");   // tên đăng nhập
                registeredEmail = rs.getString("email");
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi kiểm tra thông tin tài khoản!");
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }

        // 2. So sánh tên và email nhập với thông tin thật
        if (registeredName == null || registeredEmail == null) {
            request.setAttribute("error", "Không tìm thấy thông tin tài khoản của bạn!");
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }

        boolean nameMatch = inputName.trim().equals(registeredName);
        boolean emailMatch = inputEmail.trim().equals(registeredEmail);

        if (!nameMatch || !emailMatch) {
            String errMsg = "Tên hoặc email không trùng với lúc đăng ký.";
            request.setAttribute("error", errMsg);
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }

        // 3. Nếu khớp thì lưu vào bảng contacts
        try (Connection conn = new dbConnect().getConnect()) {
            String sql = "INSERT INTO contacts (name, email, phone, message) VALUES (?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, inputName);
            ps.setString(2, inputEmail);
            ps.setString(3, phone);
            ps.setString(4, message);
            int result = ps.executeUpdate();
            if (result > 0) {
                request.setAttribute("success", "Gửi liên hệ thành công! Chúng tôi sẽ phản hồi sớm.");
            } else {
                request.setAttribute("error", "Gửi thất bại, vui lòng thử lại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống, vui lòng thử lại sau!");
        
        // Nếu có lỗi, in ra lỗi thay vì chuyển hướng
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head><title>Lỗi</title></head>");
            out.println("<body>");
            out.println("<h1>Đã xảy ra lỗi khi gửi liên hệ!</h1>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</body>");
            out.println("</html>");
            }
        }
        request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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