package Controller.Admin;

import DAO.products_DAO;
import Model.products;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    products_DAO dao = new products_DAO();

    protected void processRequest(HttpServletRequest req, HttpServletResponse resp, String method)
            throws ServletException, IOException {

        // ✅ FIX FONT (QUAN TRỌNG)
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

        if ("add".equals(action)) {
            req.setAttribute("categories", dao.getAllCategoryNames());
            req.getRequestDispatcher("/admin/product_form.jsp").forward(req, resp);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            products p = dao.getProductById(id);

            req.setAttribute("product", p);
            req.setAttribute("categories", dao.getAllCategoryNames());
            req.getRequestDispatcher("/admin/product_form.jsp").forward(req, resp);
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteProduct(id);
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }

        // ===== LOAD LIST =====
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");

        List<products> productList;

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasCategory = category != null && !category.trim().isEmpty();

        if (hasKeyword) {
            productList = dao.searchProducts(keyword.trim(),
                    hasCategory ? category.trim() : null);
        } else if (hasCategory) {
            productList = dao.getProductsByCategory(category.trim());
        } else {
            productList = dao.getAllProducts();
        }

        req.setAttribute("productList", productList);
        req.setAttribute("categories", dao.getAllCategoryNames());
        req.setAttribute("keyword", keyword != null ? keyword : "");
        req.setAttribute("catFilter", category != null ? category : "");

        req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
    }

    // ================= POST =================
    private void handlePost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String action = req.getParameter("action");

            String idParam = req.getParameter("product_id");
            String name = req.getParameter("product_name");
            double price = Double.parseDouble(req.getParameter("price"));
            String desc = req.getParameter("description");
            String image = req.getParameter("image");
            int categoryId = Integer.parseInt(req.getParameter("category_id"));

            // DEBUG
            System.out.println("=== POST ===");
            System.out.println("Action: " + action);
            System.out.println("Name: " + name);

            products p = new products();
            p.setProduct_name(name);
            p.setPrice(price);
            p.setDescription(desc);
            p.setImage(image);
            p.setCategory_id(categoryId);

            if ("create".equals(action)) {
                boolean ok = dao.addProduct(p);
                System.out.println("ADD RESULT: " + ok);
            } else if ("update".equals(action) && idParam != null) {
                p.setProduct_id(Integer.parseInt(idParam));
                boolean ok = dao.updateProduct(p);
                System.out.println("UPDATE RESULT: " + ok);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/products");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Lỗi: " + e.getMessage());
        }
    }

    // ================= OVERRIDE =================
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