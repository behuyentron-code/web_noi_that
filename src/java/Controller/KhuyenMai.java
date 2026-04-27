package Controller;

import DAO.products_DAO;
import Model.products;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý trang Khuyến Mãi
 * URL: /khuyen-mai
 */
@WebServlet(name = "KhuyenMai", urlPatterns = {"/khuyen-mai"})
public class KhuyenMai extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        products_DAO dao = new products_DAO();

        try {
            // Danh mục cho left-menu (dùng chung với các trang khác)
            List<String> categories = dao.getAllCategoryNames();
            request.setAttribute("categories", categories);

            // Lọc category nếu người dùng click filter
            String categoryFilter = request.getParameter("category");

            List<products> promoList;
            if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                promoList = dao.getProductsOnSaleByCategory(categoryFilter.trim());
                request.setAttribute("selectedCategory", categoryFilter.trim());
            } else {
                // Lấy tất cả sản phẩm khuyến mãi (giá < 2.000.000đ làm ví dụ)
                promoList = dao.getProductsOnSale();
            }

            request.setAttribute("promoProducts", promoList);

            // Featured deal: sản phẩm đắt nhất trong danh sách KM
            if (promoList != null && !promoList.isEmpty()) {
                products featured = promoList.get(0);
                for (products p : promoList) {
                    if (p.getPrice() > featured.getPrice()) {
                        featured = p;
                    }
                }
                request.setAttribute("featuredProduct", featured);
            }

            request.getRequestDispatcher("/khuyen_mai.jsp").forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Lỗi tải trang khuyến mãi: " + ex.getMessage());
            request.getRequestDispatcher("/khuyen_mai.jsp").forward(request, response);
        }
    }

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
        return "Servlet trang Khuyến Mãi";
    }
}
