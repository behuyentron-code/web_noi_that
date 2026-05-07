/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Admin;

import DAO.categories_DAO;
import Model.users;
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
public class AdminCategoryServlet extends HttpServlet {
   
    private categories_DAO dao = new categories_DAO();
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    // ================= GET =================
    private void handleGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // ===== XÓA =====
        if ("delete".equals(action)) {
    int id = Integer.parseInt(request.getParameter("id"));

    if (dao.hasProducts(id)) {
        request.getSession().setAttribute("toast", "⚠️ Danh mục đang chứa sản phẩm, không thể xóa");
    } else {
        boolean ok = dao.deleteCategory(id);
        if (ok) {
            request.getSession().setAttribute("toast", "✅ Xóa thành công");
        } else {
            request.getSession().setAttribute("toast", "❌ Xóa thất bại");
        }
    }

    response.sendRedirect(request.getContextPath() + "/AdminCategoryServlet");
    return;
}

        // ===== EDIT =====
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Map<String, Object> cate = dao.getCategoryById(id);

            request.setAttribute("category", cate);
            request.getRequestDispatcher("/admin/category_form.jsp").forward(request, response);
            return;
        }

        // ===== ADD =====
        if ("add".equals(action)) {
            request.getRequestDispatcher("/admin/category_form.jsp").forward(request, response);
            return;
        }

        // ===== LIST + FILTER =====
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        int page = 1;
        int recordsPerPage = 10;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Map<String, Object>> list = dao.getAllCategories(keyword, page, recordsPerPage);
        int total = dao.countCategories(keyword);
        int totalPages = (int) Math.ceil((double) total / recordsPerPage);

        request.setAttribute("categories", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }

    // ================= POST =================
    private void handlePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("category_id");
        String name = request.getParameter("category_name");

        if ("create".equals(action)) {
            dao.addCategory(name);
            request.getSession().setAttribute("toast", "Thêm danh mục thành công");
        } else if ("update".equals(action) && idParam != null) {
            dao.updateCategory(Integer.parseInt(idParam), name);
            request.getSession().setAttribute("toast", "Cập nhật danh mục thành công");
        }

        response.sendRedirect(request.getContextPath() + "/AdminCategoryServlet");
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