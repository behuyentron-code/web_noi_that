package Controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


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
public class KhuyenMai extends HttpServlet {
   
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
                // Lấy tất cả sản phẩm khuyến mãi 
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
    

        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet KhuyenMai</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet KhuyenMai at " + request.getContextPath () + "</h1>");
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
