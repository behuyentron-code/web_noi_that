/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Cart;


import Model.dbConnect;
import Model.products;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Map;
/**
 *
 * @author Admin
 */
public class CheckoutServlet extends HttpServlet {
   
    /** 
     * Processes requestuests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param requestuest servlet requestuest
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("user");
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/hienthi?openModal=login");
            return;
        }

        Map<Integer, Object[]> cart = (Map<Integer, Object[]>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        // Lấy thông tin form
        String fullname = request.getParameter("fullname");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String paymentMethod = request.getParameter("paymentMethod");
        String note = request.getParameter("note");

        // Tính toán lại tổng tiền từ cart (tránh client sửa)
        double subtotal = 0;
        for (Object[] entry : cart.values()) {
            products p = (products) entry[0];
            int qty = (int) entry[1];
            subtotal += p.getPrice() * qty;
        }
        double shipping = subtotal >= 500000 ? 0 : 30000;
        double total = subtotal + shipping;

        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;

        try {
            System.out.println("=== fullname=" + fullname);
System.out.println("=== address=" + address);
System.out.println("=== phone=" + phone);
System.out.println("=== paymentMethod=" + paymentMethod);
            conn = new dbConnect().getConnect();
            conn.setAutoCommit(false); // bắt đầu transaction
            System.out.println("=== 1. DB connected: " + conn);

            // Lấy user_id từ username
            int userId = -1;
            psUser = conn.prepareStatement("SELECT user_id FROM users WHERE username = ?");
            psUser.setString(1, username);
            rs = psUser.executeQuery();
            if (rs.next()) userId = rs.getInt("user_id");
            rs.close(); psUser.close();
            
             System.out.println("=== 2. userId = " + userId);
            if (userId == -1) throw new Exception("Không tìm thấy người dùng");

            // Chèn vào bảng orders
            String sqlOrder = "INSERT INTO orders (user_id, shipping_address, payment_method, subtotal, total_price, status, order_date, name_receiver, phone_receiver) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                psOrder = conn.prepareStatement(sqlOrder, PreparedStatement.RETURN_GENERATED_KEYS);
                psOrder.setInt(1, userId);
                psOrder.setString(2, address);
                psOrder.setString(3, paymentMethod);
                psOrder.setDouble(4, subtotal);
                psOrder.setDouble(5, total);
                psOrder.setString(6, "pending");
                psOrder.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
                psOrder.setString(8, fullname);
                psOrder.setString(9, phone);
                psOrder.executeUpdate();
            
            rs = psOrder.getGeneratedKeys();
            int orderId = -1;
            if (rs.next()) orderId = rs.getInt(1);
            rs.close(); psOrder.close();

            if (orderId == -1) throw new Exception("Không tạo được đơn hàng");

            // Chèn chi tiết đơn hàng
            String sqlDetail = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            psDetail = conn.prepareStatement(sqlDetail);
            for (Map.Entry<Integer, Object[]> entry : cart.entrySet()) {
                int productId = entry.getKey();
                products p = (products) entry.getValue()[0];
                int qty = (int) entry.getValue()[1];
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, productId);
                psDetail.setInt(3, qty);
                psDetail.setDouble(4, p.getPrice());
                psDetail.addBatch();
            }
            psDetail.executeBatch();
            psDetail.close();

            // Xóa giỏ hàng trong session
            session.removeAttribute("cart");
            session.setAttribute("cartCount", 0);
            conn.commit(); // commit transaction

            // Chuyển đến trang thành công
            request.setAttribute("orderId", orderId);
            request.setAttribute("total", total);
            System.out.println("=== FORWARD to order_success.jsp | orderId=" + orderId + " | total=" + total);
            request.getRequestDispatcher("/order_success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            request.setAttribute("error", "Đặt hàng thất bại: " + e.getMessage());
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        } finally {
            try { 
                if (rs != null) rs.close(); 
            } catch (Exception e) {
                
            }
            
            try { 
                if (psUser != null) psUser.close(); 
            } catch (Exception e) {
                
            }
            
            try { 
                if (psOrder != null) psOrder.close(); 
            } catch (Exception e) {
            
            }
            
            try { 
                if (psDetail != null) psDetail.close(); 
            } catch (Exception e) {
                
            }
            
            try { 
                if (conn != null) conn.close(); 
            } catch (Exception e) {
                
            }
        }
    
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet CheckoutServlet</title>");  
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet CheckoutServlet at " + request.getContextPath () + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param requestuest servlet requestuest
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest requestuest, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(requestuest, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param requestuest servlet requestuest
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest requestuest, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(requestuest, response);
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
