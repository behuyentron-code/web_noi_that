/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Cart;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class UpdateCart extends HttpServlet {
   
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
//        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String productIdParam = request.getParameter("productId");
        String qtyParam       = request.getParameter("qty");

        if (productIdParam == null || qtyParam == null) {
            response.getWriter().write("{\"status\":\"error\",\"cartCount\":0}");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdParam);
            int qty       = Integer.parseInt(qtyParam);
            if (qty < 1) qty = 1;
            if (qty > 99) qty = 99;

            Map<Integer, Object[]> cart =
                (Map<Integer, Object[]>) session.getAttribute("cart");

            if (cart != null && cart.containsKey(productId)) {
                cart.get(productId)[1] = qty;
                session.setAttribute("cart", cart);
            }

            int cartCount = 0;
            if (cart != null) {
                for (Object[] entry : cart.values()) {
                    cartCount += (int) entry[1];
                }
            }
            session.setAttribute("cartCount", cartCount);

            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"ok\",\"cartCount\":" + cartCount + "}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"status\":\"error\",\"cartCount\":0}");
        }
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateCart</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateCart at " + request.getContextPath () + "</h1>");
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
