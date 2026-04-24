package Controller.Admin;

import DAO.products_DAO;
import Model.products;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminProductServlet extends HttpServlet {
    products_DAO dao = new products_DAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        // Xử lý thêm/sửa/xóa
        if ("add".equals(action)) {
            req.setAttribute("categories", dao.getAllCategoryNames());
            req.getRequestDispatcher("/admin/product_form.jsp").forward(req, resp);
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            products p = dao.getProductById(id);
            req.setAttribute("product", p);
            req.setAttribute("categories", dao.getAllCategoryNames());
            req.getRequestDispatcher("/admin/product_form.jsp").forward(req, resp);
            return;
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteProduct(id);
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }

        // ---------- XỬ LÝ LỌC/TÌM KIẾM ----------
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");
        List<products> productList = null;

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasCategory = category != null && !category.trim().isEmpty();

        if (hasKeyword) {
            // Truyền cả category vào (có thể null nếu không chọn)
            productList = dao.searchProducts(keyword.trim(), hasCategory ? category.trim() : null);
        } else if (hasCategory) {
            productList = dao.getProductsByCategory(category.trim());
        } else {
            productList = dao.getAllProducts();
        }
        // Lấy danh sách categories cho dropdown và gán lại attribute
        List<String> categories = dao.getAllCategoryNames();
        
        req.setAttribute("productList", productList);
        req.setAttribute("categories", categories);
        req.setAttribute("keyword", keyword != null ? keyword : "");
        req.setAttribute("catFilter", category != null ? category : "");

        req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
        
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("product_id");
        String name = req.getParameter("product_name");
        double price = Double.parseDouble(req.getParameter("price"));
        String desc = req.getParameter("description");
        String image = req.getParameter("image");
        int categoryId = Integer.parseInt(req.getParameter("category_id"));

        products p = new products();
        p.setProduct_name(name);
        p.setPrice(price);
        p.setDescription(desc);
        p.setImage(image);
        p.setCategory_id(categoryId);

        if ("create".equals(action)) {
            dao.addProduct(p);
        } else if ("update".equals(action) && idParam != null) {
            p.setProduct_id(Integer.parseInt(idParam));
            dao.updateProduct(p);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }
}