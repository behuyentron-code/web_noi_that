<%-- 
    Document   : lienhe
    Created on : 12 thg 4, 2026, 20:30:54
    Author     : TRANG ANH LAPTOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>liên hệ </title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <!-- Banner -->
<div class="banner">
    DECOR LUXURY - NÂNG TẦM KHÔNG GIAN SỐNG
</div>


<div class="top-menu">
    <div>
        <a href="#">Trang chủ</a>
        <a href="#">Khuyến mãi </a>
        <a href="#">Sản phẩm</a>
        <a href="#">Liên hệ</a>
    </div>
    <%
    String user = (String) session.getAttribute("user");
    %>
    <div class="auth-buttons">
            <a href="cart.jsp" class="cart-btn">
                <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                <span class="cart-count" id="cartCount">
                    <%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %>
                </span>
            </a>
                
           <% if(user != null){ %>
                <span style="color:white;">Xin chào, <%= user %></span>
                <a href="logout.jsp">Đăng xuất</a>
            <% } else { %>
                <a href="#" class="btn-login" onclick="openLogin()" >Đăng Nhập</a>
                <a href="#" class="btn-register" onclick="openRegister()">Đăng Ký</a>
            <% } %>
            
        </div>
</div>

<!-- Layout chính -->
<div class="container">

    <!-- LEFT MENU -->
    <div class="left-menu">
        <h3>Danh mục</h3>
        <ul>
            <li>Trang chủ</li>
            <li>Sản phẩm</li>
            <li>Liên hệ</li>
        </ul>
    </div>

    <!-- CONTENT -->
    <div class="content">

        <!-- 2 BOX -->
        <div class="box">
            <h3>Talk to sales</h3>
            <p>Interested in our hosting? Call us</p>
            <button class="btn">01202340234</button>
        </div>

        <div class="box">
    <h3>Contact support</h3>
    <p id="support-text">We’re here for you</p>
    <button class="btn" onclick="showPhone()">CONTACT SUPPORT</button>
     </div>

        <!-- FORM -->
        <h2>Ask a question</h2>

        <form action="ContactServlet" method="post">
            <input type="text" name="name" placeholder="Họ và tên" required><br><br>
    <input type="email" name="email" placeholder="Email"><br><br>
    <input type="text" name="phone" placeholder="Phone"><br><br>
    <textarea name="message" placeholder="Nội dung"></textarea><br><br>
    <button type="submit">GỬI</button><br><br>
     </form>

    </div>
</div>

<!-- Footer -->
<div class="footer">
    <div class="footer-info">
        <p>© 2026 - Website của bạn</p>
    </div>
</div>
<script>
    function showPhone() {
        let text = document.getElementById("support-text");

        if (text.innerText === "We’re here for you") {
            text.innerText = "Hotline: 01202340234";
        } else {
            text.innerText = "We’re here for you";
        }
    }
</script>
    </body>
</html>