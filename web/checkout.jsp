<%-- 
    Document   : checkout
    Created on : Apr 24, 2026, 11:32:47 PM
    Author     : Admin
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Map"%>
<%@page import="Model.products"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("hienthi?openModal=login");
        return;
    }
    Map<Integer, Object[]> cart = (Map<Integer, Object[]>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }
    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    double subtotal = 0;
    for (Object[] entry : cart.values()) {
        products p = (products) entry[0];
        int qty = (int) entry[1];
        subtotal += p.getPrice() * qty;
    }
    double shipping = subtotal >= 500000 ? 0 : 30000;
    double total = subtotal + shipping;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - Decor Luxury</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="css/style.css">
    <style>
        .checkout-wrapper { max-width: 1200px; margin: 40px auto; padding: 0 20px; display: flex; gap: 30px; flex-wrap: wrap; }
        .checkout-form { flex: 2; background: white; padding: 25px; border-radius: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border: 1px solid #e2e8d8; }
        .order-summary { flex: 1.2; background: white; padding: 25px; border-radius: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border: 1px solid #e2e8d8; height: fit-content; }
        .form-group { margin-bottom: 20px; }
        label { font-weight: 600; display: block; margin-bottom: 8px; color: #2c2c2c; }
        input, select, textarea { width: 100%; padding: 12px; border: 1px solid #d6ddc8; border-radius: 10px; font-family: 'Montserrat', sans-serif; }
        .pay-method { display: flex; gap: 20px; margin-top: 10px; }
        .pay-method label { display: flex; align-items: center; gap: 8px; font-weight: normal; }
        .btn-place-order { background: #4e5c34; color: white; border: none; width: 100%; padding: 14px; border-radius: 40px; font-weight: bold; cursor: pointer; transition: 0.2s; margin-top: 20px; }
        .btn-place-order:hover { background: #6b7c4a; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; }
        .summary-total { font-size: 20px; font-weight: bold; border-top: 1px solid #ddd; padding-top: 15px; margin-top: 10px; }
        .cart-items-preview { max-height: 300px; overflow-y: auto; margin-bottom: 20px; }
        .preview-item { display: flex; gap: 12px; padding: 10px 0; border-bottom: 1px solid #f0f3ea; }
        .preview-item img { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; }
        .preview-info { flex: 1; font-size: 13px; }
        .preview-name { font-weight: 600; }
        h3 { margin-top: 0; color: #4e5c34; }
        hr { margin: 20px 0; }
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
    
    <div class="checkout-wrapper">
        <div class="checkout-form">
            <h3><i class="fa-solid fa-truck"></i> Thông tin giao hàng</h3>
            <form action="CheckoutServlet" method="post" id="checkoutForm">
                <div class="form-group">
                    <label>Họ tên người nhận *</label>
                    <input type="text" name="fullname" required value="<%= user %>">
                </div>
                <div class="form-group">
                    <label>Địa chỉ giao hàng *</label>
                    <textarea name="address" rows="2" required placeholder="Số nhà, đường, phường/xã, quận/huyện, thành phố"></textarea>
                </div>
                <div class="form-group">
                    <label>Số điện thoại *</label>
                    <input type="tel" name="phone" required>
                </div>
                <div class="form-group">
                    <label>Phương thức thanh toán</label>
                    <div class="pay-method">
                        <label><input type="radio" name="paymentMethod" value="COD" checked> Thanh toán khi nhận hàng (COD)</label>
                        <label><input type="radio" name="paymentMethod" value="BankTransfer"> Chuyển khoản ngân hàng</label>
                        <label><input type="radio" name="paymentMethod" value="Momo"> Ví MoMo</label>
                    </div>
                </div>
                <div class="form-group">
                    <label>Ghi chú (tùy chọn)</label>
                    <textarea name="note" rows="2" placeholder="Yêu cầu đặc biệt về giao hàng..."></textarea>
                </div>
                <button type="submit" class="btn-place-order"><i class="fa-solid fa-check-circle"></i> ĐẶT HÀNG NGAY</button>
            </form>
        </div>
        <div class="order-summary">
            <h3><i class="fa-solid fa-receipt"></i> Đơn hàng của bạn</h3>
            <div class="cart-items-preview">
                <% for (Map.Entry<Integer, Object[]> entry : cart.entrySet()) {
                    products p = (products) entry.getValue()[0];
                    int qty = (int) entry.getValue()[1];
                %>
                <div class="preview-item">
                    <img src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg" %>" onerror="this.src='https://placehold.co/50x50'">
                    <div class="preview-info">
                        <div class="preview-name"><%= p.getProduct_name() %></div>
                        <div><%= fmt.format(p.getPrice()) %> x <%= qty %></div>
                    </div>
                    <div><strong><%= fmt.format(p.getPrice() * qty) %></strong></div>
                </div>
                <% } %>
            </div>
            <div class="summary-row"><span>Tạm tính</span><span id="subtotal"><%= fmt.format(subtotal) %></span></div>
            <div class="summary-row"><span>Phí vận chuyển</span><span><% if(shipping==0){ %>Miễn phí<% }else{ %><%= fmt.format(shipping) %><% } %></span></div>
            <div class="summary-row"><span>Giảm giá</span><span>-0đ</span></div>
            <div class="summary-total"><span>Tổng cộng</span><span><%= fmt.format(total) %></span></div>
            <hr>
            <div class="secure-note"><i class="fa-solid fa-lock"></i> Thông tin của bạn được bảo mật tuyệt đối.</div>
        </div>
    </div>
    <footer class="footer"><!-- giống các trang --></footer>
    <script>
        // Đảm bảo người dùng đã đăng nhập (kiểm tra lại phía client nếu cần)
    </script>
</body>
</html>
