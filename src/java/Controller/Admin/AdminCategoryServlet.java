/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Admin;

import DAO.categories_DAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import javax.servlet.annotation.WebServlet;

/**
 *
 * @author Admin
 */
@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

    categories_DAO dao = new categories_DAO();

    protected void processRequest(HttpServletRequest req, HttpServletResponse resp, String method)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        if ("POST".equals(method)) {
            handlePost(req, resp);
        } else {
            handleGet(req, resp);
        }
    }

    // ================= GET =================
    private void handleGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // ===== XÓA =====
        if ("delete".equals(action)) {
    int id = Integer.parseInt(req.getParameter("id"));

    if (dao.hasProducts(id)) {
        req.getSession().setAttribute("toast", "⚠️ Danh mục đang chứa sản phẩm, không thể xóa");
    } else {
        boolean ok = dao.deleteCategory(id);
        if (ok) {
            req.getSession().setAttribute("toast", "✅ Xóa thành công");
        } else {
            req.getSession().setAttribute("toast", "❌ Xóa thất bại");
        }
    }

    resp.sendRedirect(req.getContextPath() + "/admin/categories");
    return;
}
        
        

        // ===== EDIT =====
        if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Map<String, Object> cate = dao.getCategoryById(id);

            req.setAttribute("category", cate);
            req.getRequestDispatcher("/admin/category_form.jsp").forward(req, resp);
            return;
        }

        // ===== ADD =====
        if ("add".equals(action)) {
            req.getRequestDispatcher("/admin/category_form.jsp").forward(req, resp);
            return;
        }

        // ===== LIST + FILTER =====
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";

        int page = 1;
        int recordsPerPage = 10;
        if (req.getParameter("page") != null) {
            page = Integer.parseInt(req.getParameter("page"));
        }

        List<Map<String, Object>> list = dao.getAllCategories(keyword, page, recordsPerPage);
        int total = dao.countCategories(keyword);
        int totalPages = (int) Math.ceil((double) total / recordsPerPage);

        req.setAttribute("categories", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("keyword", keyword);

        req.getRequestDispatcher("/admin/categories.jsp").forward(req, resp);
    }

    // ================= POST =================
    private void handlePost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idParam = req.getParameter("category_id");
        String name = req.getParameter("category_name");

        if ("create".equals(action)) {
            dao.addCategory(name);
            req.getSession().setAttribute("toast", "Thêm danh mục thành công");
        } else if ("update".equals(action) && idParam != null) {
            dao.updateCategory(Integer.parseInt(idParam), name);
            req.getSession().setAttribute("toast", "Cập nhật danh mục thành công");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processRequest(req, resp, "GET");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processRequest(req, resp, "POST");
    }
}
