/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Admin;

import DAO.contacts_DAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class AdminContactServlet extends HttpServlet {
   
    private contacts_DAO dao = new contacts_DAO();
    
    // ================= GET =================
    private void handleGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // ===== XÓA =====
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String email = request.getParameter("email"); // để quay lại đúng danh sách

            boolean ok = dao.delete(id);
            if (ok) {
                request.getSession().setAttribute("toast", "✅ Xóa liên hệ thành công");
            } else {
                request.getSession().setAttribute("toast", "❌ Xóa liên hệ thất bại");
            }

            response.sendRedirect(request.getContextPath() + "/AdminContactServlet?email=" + email);
            return;
        }

        // ===== EDIT =====
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Map<String, Object> contact = dao.getContactById(id);

            request.setAttribute("contact", contact);
            request.getRequestDispatcher("/admin/contact_form.jsp").forward(request, response);
            return;
        }

        // ===== LIST (theo email) =====
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            // Nếu không có email, chuyển về trang danh sách users
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        List<Map<String, Object>> list = dao.getContactsByEmail(email);
        request.setAttribute("contacts", list);
        request.setAttribute("userEmail", email);

        request.getRequestDispatcher("/admin/contact_list.jsp").forward(request, response);
    }

    // ================= POST =================
    private void handlePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String email = request.getParameter("email"); // để redirect lại list

        if ("update".equals(action) && idParam != null) {
            int id = Integer.parseInt(idParam);
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String message = request.getParameter("message");

            boolean ok = dao.update(id, name, phone, message);
            if (ok) {
                request.getSession().setAttribute("toast", "✅ Cập nhật liên hệ thành công");
            } else {
                request.getSession().setAttribute("toast", "❌ Cập nhật thất bại");
            }
        }

        response.sendRedirect(request.getContextPath() + "/AdminContactServlet?email=" + email);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String method = request.getMethod();
        if ("POST".equals(method)) {
            handlePost(request, response);
        } else {
            handleGet(request, response);
        }
        
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminCategoryServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminCategoryServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Contact Servlet - quản lý liên hệ người dùng";
    }
}