/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Admin;

import DAO.products_DAO;
import Model.products;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Admin
 */
public class AdminProductServlet extends HttpServlet {

    private products_DAO dao = new products_DAO();

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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String method = request.getMethod();

        if (method.equalsIgnoreCase("POST")) {
            handlePostLogic(request, response);
        } else {
            handleGetLogic(request, response);
        }
        
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet test</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet test at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Logic xử lý các yêu cầu GET: Hiển thị danh sách, Form thêm/sửa, Xóa
     */
    private void handleGetLogic(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // 1. Mở form thêm mới
        if ("add".equals(action)) {
            request.setAttribute("categories", dao.getAllCategoryNames());
            request.getRequestDispatcher("/admin/product_form.jsp").forward(request, response);
            return;
        }

        // 2. Mở form chỉnh sửa
        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                products p = dao.getProductById(id);
                request.setAttribute("product", p);
                request.setAttribute("categories", dao.getAllCategoryNames());
                request.getRequestDispatcher("/admin/product_form.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect("AdminProductServlet");
            }
            return;
        }

        // 3. Xử lý xóa sản phẩm
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteProduct(id);
                response.sendRedirect(request.getContextPath() + "/AdminProductServlet?msg=deleted");
            } catch (Exception e) {
                response.sendRedirect("AdminProductServlet");
            }
            return;
        }

        // 4. Hiển thị danh sách mặc định (Search & Filter)
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

        List<products> productList;
        if ((keyword != null && !keyword.trim().isEmpty()) || (category != null && !category.trim().isEmpty())) {
            productList = dao.searchProducts(keyword != null ? keyword.trim() : "", category);
        } else {
            productList = dao.getAllProducts();
        }

        request.setAttribute("productList", productList);
        request.setAttribute("categories", dao.getAllCategoryNames());
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("catFilter", category != null ? category : "");

        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    /**
     * Logic xử lý các yêu cầu POST: Create và Update dựa trên products_DAO
     */
    private void handlePostLogic(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String idParam = request.getParameter("product_id");

            // Đọc dữ liệu từ form
            String name = request.getParameter("product_name");
            double price = Double.parseDouble(request.getParameter("price"));
            String desc = request.getParameter("description");
            String image = request.getParameter("image");
            int categoryId = Integer.parseInt(request.getParameter("category_id"));
            long quantity = Long.parseLong(request.getParameter("quantity"));
            int discountPrice = Integer.parseInt(request.getParameter("discount_price"));

            // Tạo đối tượng model
            products p = new products();
            p.setProduct_name(name);
            p.setPrice(price);
            p.setDescription(desc);
            p.setImage(image);
            p.setCategory_id(categoryId);
            p.setQuantity(quantity);
            p.setDiscount_price(discountPrice);

            String msg = "";
            if ("create".equals(action)) {
                // Sử dụng hàm addProduct của products_DAO
                boolean success = dao.addProduct(p);
                msg = success ? "add" : "error";
            } else if ("update".equals(action) && idParam != null) {
                p.setProduct_id(Integer.parseInt(idParam));
                // Sử dụng hàm updateProduct của products_DAO
                boolean success = dao.updateProduct(p);
                msg = success ? "updated" : "error";
            }

            response.sendRedirect(request.getContextPath() + "/AdminProductServlet?msg=" + msg);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi dữ liệu: " + e.getMessage());
            request.setAttribute("categories", dao.getAllCategoryNames());
            request.getRequestDispatcher("/admin/product_form.jsp").forward(request, response);
        }
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
        return "Admin";
    }// </editor-fold>

}