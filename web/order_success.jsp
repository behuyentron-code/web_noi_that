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
<!--    <header class="banner">DECOR LUXURY - NÂNG TẦM KHÔNG GIAN SỐNG</header>-->
    <nav class="top-menu">
        <div class="left-nav">
            <a href="${pageContext.request.contextPath}/hienthi" class="logo-brand">
                <i class="fa-solid fa-leaf"></i> Trang Chủ
            </a>
            <div class="dropdown">
                <a class="dropbtn">Sản phẩm <i class="fas fa-chevron-down"></i></a>
                <div class="dropdown-content">
                    <% 
                        java.util.List<String> navCats = (java.util.List<String>) request.getAttribute("categories");
                        if(navCats != null) {
                            for(String cat : navCats) {
                    %>
                        <a href="${pageContext.request.contextPath}/hienthi?category=<%= cat %>"><%= cat %></a>
                    <% 
                            }
                        } 
                    %>
                </div>
            </div>
            <a href="khuyen_mai.jsp">Khuyến mãi</a>
            <a href="${pageContext.request.contextPath}/ContactServlet">Liên Hệ</a>
        </div>

        <div class="right-nav">
            <div class="search-container">
                <input type="text" placeholder="Tìm kiếm...">
                <button><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>

            <div class="auth-group">
                <a href="cart.jsp" class="icon-btn">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <span class="badge"><%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %></span>
                </a>

                 <% if (user != null) { %>
                    <%-- Kiểm tra vai trò --%>
                    <% if ("admin".equals(session.getAttribute("role"))) { %>
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="admin-link">
                            <i class="fa-solid fa-user-tie"></i> Quản trị
                        </a>
                    <% } else { %>
                        <%-- Chỉ hiện icon account cho User, không dẫn link đi đâu cả --%>
                        <div class="icon-btn" style="cursor: default;">
                            <i class="fa-solid fa-circle-user"></i>
                        </div>
                    <% } %>

                    <a href="login?action=logout" class="btn-pill outline">Đăng xuất</a>

                <% } else { %>
                    <a href="#" class="btn-pill outline" onclick="openLogin()">Đăng nhập</a>
                    <a href="#" class="btn-pill solid" onclick="openRegister()">Đăng ký</a>
                <% } %>
            </div>
        </div>
    </nav>
    
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