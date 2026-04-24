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
        <link rel="stylesheet" href="<%= request.getContextPath()%>/style.css">
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


        <!-- ================= MODAL LOGIN ================= -->
        <%
            String registerError = (String) request.getAttribute("registerError");
            String loginUsername = (String) request.getAttribute("loginUsername");
            String loginError = (String) request.getAttribute("loginError");

            // REGISTER
            String regUsername = (String) request.getAttribute("regUsername");
            String regEmail = (String) request.getAttribute("regEmail");
            String regPhone = (String) request.getAttribute("regPhone");
        %>
        <div id="loginModal" class="modal">
            <div class="modal-box">
                <span class="close" onclick="closeModal('loginModal')" style="color: #333">&times;</span>

                <h2>Đăng nhập</h2>

                <form action="login" method="post" >
                    <input type="text" name="username" placeholder="Tên đăng nhập"
                           value="<%= loginUsername != null ? loginUsername : ""%>" required>
                    <input type="password" name="password" placeholder="Mật khẩu" required>
                    <button type="submit" name="action" value="login" class="btn-submit">Đăng nhập</button>
                </form>

                <% if (loginError != null) {%>
                <div style="
                     background: #fff3f3;
                     border: 1px solid #f5c6cb;
                     color: #c0392b;
                     padding: 10px 14px;
                     border-radius: 8px;
                     font-size: 14px;
                     margin-top: 12px;
                     margin-bottom: 12px;
                     ">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:6px;"></i><%= loginError%>
                </div>
                <% }%>

                <p style="color: #333">

                    <a style="color: #333">Chưa có tài khoản</a>
                    <span>|</span>
                    <a href="#" onclick="switchModal('loginModal', 'registerModal')" style="color: #333">Đăng ký</a>
                </p>


            </div>
        </div>

        <!-- ================= MODAL REGISTER ================= -->
        <div id="registerModal" class="modal">
            <div class="modal-box">
                <span class="close" onclick="closeModal('registerModal')" style="color: #333">&times;</span>

                <h2>Đăng ký</h2>

                <form action="login" method="post">
                    <input type="text" name="username" placeholder="Tên đăng nhập"
                           value="<%= regUsername != null ? regUsername : ""%>" required>
                    <input type="email" name="email" placeholder="Email"
                           value="<%= regEmail != null ? regEmail : ""%>" required>
                    <input type="tel" name="phone" placeholder="Số điện thoại"
                           value="<%= regPhone != null ? regPhone : ""%>">

                    <input type="password" name="password" placeholder="Mật khẩu" required>
                    <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                    <button type="submit" name="action" value="register" class="btn-submit">Đăng ký</button>
                </form>

                <% if (registerError != null) {%>
                <div style="
                     background: #fff3f3;
                     border: 1px solid #f5c6cb;
                     color: #c0392b;
                     padding: 10px 14px;
                     border-radius: 8px;
                     font-size: 14px;
                     margin-top: 12px;
                     margin-bottom: 12px;
                     ">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:6px;"></i><%= registerError%>
                </div>
                <% }%>

                <p style="color: #333" >Đã có tài khoản?
                    <a href="#" onclick="switchModal('registerModal', 'loginModal')" style="color: #333">Đăng nhập</a>
                </p>
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

            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get("openModal") === "login")
                openLogin();
            if (urlParams.get("openModal") === "register")
                openRegister();

            function openLogin() {
                document.getElementById("loginModal").style.display = "flex";
            }
            function openRegister() {
                document.getElementById("registerModal").style.display = "flex";
            }
            function closeModal(id) {
                document.getElementById(id).style.display = "none";
            }
            function switchModal(closeId, openId) {
                closeModal(closeId);
                document.getElementById(openId).style.display = "flex";
            }
        </script>
    </body>
</html>