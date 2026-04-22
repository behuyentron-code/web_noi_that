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
        <link rel="stylesheet" href="css\lienhe.css">
    </head>
    <body>
        <!-- Banner -->
<div class="banner">
    LIÊN HỆ
</div>


<div class="top-menu">
    <div>
        <a href="#">Trang chủ</a>
        <a href="#">Sản phẩm</a>
        <a href="#">Liên hệ</a>
    </div>

    <div class="auth-buttons">
        <a href="#" class="btn-login">Đăng nhập</a>
        <a href="#" class="btn-register">Đăng ký</a>
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
    <div class="contact-box-wrapper">

        <div class="contact-box">
            <div class="icon">💬</div>
            <h3>Nói chuyện với người bán hàng</h3>
            <p>Hãy liên hệ với chúng tôi qua số điện thoại</p>
            <button class="btn">01202340234</button>
        </div>

        <div class="contact-box">
            <div class="icon">💬</div>
            <h3>Liên hệ để được hỗ trợ</h3>
            <p id="support-text">Chúng tôi luôn sẵn sàng giúp bạn</p>
            <button class="btn" onclick="showPhone()">CONTACT SUPPORT</button>
        </div>

    </div>

    <!-- FORM -->
    <div class="form-box">
        <h2>Ask a question</h2>

        <form action="ContactServlet" method="post">
            <input type="text" name="name" placeholder="Họ và tên *">
            <input type="email" name="email" placeholder="Email">
            <input type="text" name="phone" placeholder="Số điện thoại">
           

<textarea name="message" placeholder="Nội dung"></textarea>
            <button type="submit">GỬI</button>
        </form>
    </div>

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

    if (text.innerText === "Chúng tôi luôn sẵn sàng giúp bạn") {
        text.innerText = "Hotline: 01202340234";
    } else {
        text.innerText = "Chúng tôi luôn sẵn sàng giúp bạn";
    }
}
</script>
    </body>
</html>
