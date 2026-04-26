<%-- 
    Document   : order_success
    Created on : Apr 24, 2026, 11:37:32 PM
    Author     : Admin
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer orderId = (Integer) request.getAttribute("orderId");
    Double total = (Double) request.getAttribute("total");
    if (orderId == null) response.sendRedirect("cart.jsp");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công - Decor Luxury</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="css/style.css">
    <style>
        .success-container { max-width: 600px; margin: 80px auto; text-align: center; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .success-icon { font-size: 80px; color: #4e5c34; margin-bottom: 20px; }
        h2 { color: #2c2c2c; }
        .order-info { background: #f0f3ea; padding: 15px; border-radius: 12px; margin: 30px 0; }
        .btn-continue { background: #4e5c34; color: white; padding: 12px 30px; border-radius: 40px; text-decoration: none; display: inline-block; margin-top: 20px; }
    </style>
</head>
<body>
    <header class="banner">DECOR LUXURY - NÂNG TẦM KHÔNG GIAN SỐNG</header>
    <div class="success-container">
        <div class="success-icon"><i class="fa-regular fa-circle-check"></i></div>
        <h2>CẢM ƠN BẠN ĐÃ ĐẶT HÀNG!</h2>
        <div class="order-info">
            <p><strong>Mã đơn hàng:</strong> #<%= orderId %></p>
            <p><strong>Tổng thanh toán:</strong> <%= fmt.format(total) %></p>
            <p><strong>Trạng thái:</strong> Chờ xác nhận</p>
        </div>
        <p>Chúng tôi sẽ liên hệ xác nhận đơn hàng trong thời gian sớm nhất.</p>
        <a href="${pageContext.request.contextPath}/hienthi" class="btn-continue"><i class="fa-solid fa-arrow-left"></i> Tiếp tục mua sắm</a>
    </div>
    <footer class="footer"><!-- giống các trang --></footer>
</body>
</html>