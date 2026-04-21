/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Cart;


import Model.products;
import DAO.products_DAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
public class AddToCart extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8"); // Đặt lên đầu
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        String productIdParam = request.getParameter("productId");
        String qtyParam = request.getParameter("qty");

        // Kiểm tra tránh lỗi NullPointerException khi ép kiểu
        if (productIdParam == null) return; 

        int productId = Integer.parseInt(productIdParam);
        int qty = (qtyParam != null) ? Integer.parseInt(qtyParam) : 1;

        Map<Integer, Object[]> cart = (Map<Integer, Object[]>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
        }

        if (cart.containsKey(productId)) {
            Object[] entry = cart.get(productId);
            entry[1] = (int) entry[1] + qty;
        } else {
            products_DAO dao = new products_DAO();
            products p = dao.getProductById(productId);
            if (p != null) {
                cart.put(productId, new Object[]{p, qty});
            }
        }

        session.setAttribute("cart", cart);

//        int cartCount = cart.values().stream().mapToInt(e -> (int) e[1]).sum();

        // Thay thế dòng stream() bằng đoạn này:
        int cartCount = 0;
        for (Object[] entry : cart.values()) {
            cartCount += (int) entry[1];
        }
        session.setAttribute("cartCount", cartCount);

        // Chỉ dùng một khối duy nhất để xuất dữ liệu
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"cartCount\":" + cartCount + ",\"status\":\"ok\"}");
            out.flush();
        }
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddToCart</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddToCart at " + request.getContextPath () + "</h1>");
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
