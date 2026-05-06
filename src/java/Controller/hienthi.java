/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import DAO.products_DAO;
import Model.products;
import DAO.products_DAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
public class hienthi extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {     
        response.setContentType("text/html;charset=UTF-8");
        
        request.setCharacterEncoding("UTF-8");

        products_DAO dao = new products_DAO();

        try {
            // 1. Luôn lấy danh mục để hiển thị menu bên trái
            List<String> categories = dao.getAllCategoryNames();
            request.setAttribute("categories", categories);

            // 2. Lấy tham số từ trình duyệt
            String category = request.getParameter("category");
            String txtSearch = request.getParameter("txtSearch");

            List<products> finalProductsList; // Dùng 1 biến duy nhất để chứa kết quả cuối cùng

            // 3. Logic ưu tiên: Tìm kiếm > Lọc theo Category > Lấy tất cả
            if (txtSearch != null && !txtSearch.trim().isEmpty()) {
                // Nếu có ô search: Ưu tiên tìm kiếm
                finalProductsList = dao.searchProducts(txtSearch, category);
                request.setAttribute("selectedCategory", "Kết quả tìm kiếm cho: " + txtSearch);
            } 
            else if (category != null && !category.trim().isEmpty()) {
                // Nếu không search nhưng có chọn Category
                finalProductsList = dao.getProductsByCategory(category.trim());
                request.setAttribute("selectedCategory", category.trim());
            } 
            else {
                // Trường hợp mặc định: Hiện tất cả
                finalProductsList = dao.getAllProducts();
                request.setAttribute("selectedCategory", "Tất cả sản phẩm");
            }

            // 4. Đẩy dữ liệu duy nhất sang JSP
            request.setAttribute("products", finalProductsList);

            // 5. Chuyển hướng (Forward)
            request.getRequestDispatcher("/home_page.jsp").forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/home_page.jsp").forward(request, response);
        }
        
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet hienthi</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet hienthi at " + request.getContextPath () + "</h1>");
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
