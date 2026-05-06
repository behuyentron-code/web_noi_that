/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Admin;

import DAO.products_DAO;
import Model.products;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 *
 * @author Admin
 */
@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    products_DAO dao = new products_DAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet AdminProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminProductServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles HTTP GET logic: add, edit, delete, and list products.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private void handleGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.setAttribute("categories", dao.getAllCategoryNames());
            request.getRequestDispatcher("/admin/product_form.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            products p = dao.getProductById(id);
            request.setAttribute("product", p);
            request.setAttribute("categories", dao.getAllCategoryNames());
            request.getRequestDispatcher("/admin/product_form.jsp").forward(request, response);
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteProduct(id);
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        // ===== LOAD LIST =====
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

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

        request.setAttribute("productList", productList);
        request.setAttribute("categories", dao.getAllCategoryNames());
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("catFilter", category != null ? category : "");

        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    /**
     * Handles HTTP POST logic: create and update products.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private void handlePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String action = request.getParameter("action");

            String idParam = request.getParameter("product_id");
            String name = request.getParameter("product_name");
            double price = Double.parseDouble(request.getParameter("price"));
            String desc = request.getParameter("description");
            String image = request.getParameter("image");
            int categoryId = Integer.parseInt(request.getParameter("category_id"));

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

            response.sendRedirect(request.getContextPath() + "/admin/products");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi: " + e.getMessage());
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