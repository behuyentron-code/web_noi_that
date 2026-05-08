/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Cart;

import DAO.products_DAO;
import Model.dbConnect;
import Model.products;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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

    private products_DAO pDao = new products_DAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/hienthi?openModal=login");
            return;
        }

        // 2. Kiểm tra giỏ hàng
        Map<Integer, Object[]> cart = (Map<Integer, Object[]>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        handleCheckoutLogic(request, response, session, username, cart);
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

    private void handleCheckoutLogic(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, String username, Map<Integer, Object[]> cart)
            throws ServletException, IOException {

        // Lấy thông tin từ form
        String fullname = request.getParameter("fullname");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String paymentMethod = request.getParameter("paymentMethod");

        // Tính toán số tiền
        double subtotal = 0;
        for (Object[] entry : cart.values()) {
            products p = (products) entry[0];
            int qty = (int) entry[1];
            subtotal += p.getPrice() * qty;
        }
        double shipping = subtotal >= 500000 ? 0 : 30000;
        double total = subtotal + shipping;

        // SỬ DỤNG TRY-WITH-RESOURCES: Tự động đóng tài nguyên, không cần finally
        try (Connection conn = new dbConnect().getConnect()) {
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // --- BƯỚC 1: Lấy user_id ---
            int userId = -1;
            try (PreparedStatement psUser = conn.prepareStatement("SELECT user_id FROM users WHERE username = ?")) {
                psUser.setString(1, username);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) userId = rs.getInt("user_id");
                }
            }
            if (userId == -1) throw new Exception("Người dùng không tồn tại.");

            // --- BƯỚC 2: Trừ kho (Sử dụng hàm của products_DAO) ---
            for (Map.Entry<Integer, Object[]> entry : cart.entrySet()) {
                int productId = entry.getKey();
                int orderedQty = (int) entry.getValue()[1];
                products p = (products) entry.getValue()[0];

                if (!pDao.reduceQuantity(productId, orderedQty)) {
                    conn.rollback();
                    request.setAttribute("error", "Sản phẩm \"" + p.getProduct_name() + "\" không đủ hàng!");
                    request.getRequestDispatcher("/checkout.jsp").forward(request, response);
                    return;
                }
            }

            // --- BƯỚC 3: Tạo đơn hàng & Lấy ID ---
            int orderId = -1;
            String sqlOrder = "INSERT INTO orders (user_id, shipping_address, payment_method, subtotal, total_price, status, order_date, name_receiver, phone_receiver) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, PreparedStatement.RETURN_GENERATED_KEYS)) {
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

                try (ResultSet rsKeys = psOrder.getGeneratedKeys()) {
                    if (rsKeys.next()) orderId = rsKeys.getInt(1);
                }
            }

            // --- BƯỚC 4: Chèn chi tiết đơn hàng ---
            String sqlDetail = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                for (Object[] entry : cart.values()) {
                    products p = (products) entry[0];
                    int qty = (int) entry[1];
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, p.getProduct_id());
                    psDetail.setInt(3, qty);
                    psDetail.setDouble(4, p.getPrice());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            // --- BƯỚC 5: Kết thúc thành công ---
            conn.commit();
            session.removeAttribute("cart");
            session.setAttribute("cartCount", 0);

            request.setAttribute("orderId", orderId);
            request.setAttribute("total", total);
            request.getRequestDispatcher("/order_success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        return "Checkout Logic";
    }// </editor-fold>
}