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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="css\lienhe.css">
        <link rel="stylesheet" href="css\style.css">
    </head>
    
     <!-- ================= MODAL LOGIN ================= -->
    <%
    String user = (String) session.getAttribute("user");

    String loginError    = (String) session.getAttribute("loginError");
    String loginUsername = (String) session.getAttribute("loginUsername");
    if (loginError != null) {
        session.removeAttribute("loginError");
        session.removeAttribute("loginUsername");
    }

    String registerError  = (String) session.getAttribute("registerError");
    String regUsername    = (String) session.getAttribute("regUsername");
    String regEmail       = (String) session.getAttribute("regEmail");
    String regPhone       = (String) session.getAttribute("regPhone");
    String regAddress     = (String) session.getAttribute("regAddress");
    if (registerError != null) {
        session.removeAttribute("registerError");
        session.removeAttribute("regUsername");
        session.removeAttribute("regEmail");
        session.removeAttribute("regPhone");
        session.removeAttribute("regAddress");
    }
%>

    <body>
        <!-- Banner -->
        <header class="banner">
            DECOR LUXURY - NÂNG TẦM KHÔNG GIAN SỐNG
        </header>

<nav class="top-menu">
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/hienthi">Trang Chủ</a>
        
        <div class="dropdown">
            <a class="dropbtn">Sản Phẩm <i class="fas fa-chevron-down"></i></a>
                <div class="dropdown-content">
                    <% 
                        // Lấy lại list categories đã được gửi từ Servlet
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
                
        <a href="khuyen_mai.jsp">Khuyến Mãi</a> 
        <a href="${pageContext.request.contextPath}/ContactServlet">Liên hệ</a> 
    </div>
    
    <div class="auth-buttons">
        <a href="cart.jsp" class="cart-btn">
            <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
            <span class="cart-count" id="cartCount">
                <%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %>
            </span>
        </a>
        <% if(user != null){ %>
            <span style="margin-left:10px;font-family:'Montserrat',sans-serif;font-weight:600;">Xin chào, <%= user %></span>
            <a href="logout.jsp" class="btn-login">Đăng xuất</a>
        <% } else { %>
            <a href="#" class="btn-login" onclick="openLogin()">Đăng Nhập</a>
            <a href="#" class="btn-register" onclick="openRegister()">Đăng Ký</a>
        <% } %>
    </div>
</nav>

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
<%
    // Lấy categories từ request trước, nếu không có thì lấy từ session
    java.util.List<String> categories = (java.util.List<String>) request.getAttribute("categories");
    if (categories == null || categories.isEmpty()) {
        categories = (java.util.List<String>) session.getAttribute("categories");
    }
%>

<!-- LEFT MENU -->
    <aside class="left-menu">
        <h3>DANH MỤC</h3>
        <ul>
            <li onclick="location.href = '${pageContext.request.contextPath}/hienthi'">Tất Cả</li>
            <% 
                if (categories != null && !categories.isEmpty()) {
                    for (String cat : categories) {
            %>
                <li onclick="location.href = '${pageContext.request.contextPath}/hienthi?category=<%= cat %>'"><%= cat %></li>
            <% 
                    }
                } else {
            %>
                <li>Không có danh mục</li>
            <% } %>
        </ul>
    </aside>
    
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
            <button class="btn " onclick="showPhone()">CONTACT SUPPORT</button>
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
            <button class="btn" type="submit" style="background-color:#4e5c34; 
                    color:#fff;
                    padding:10px;
                    font-weight: bold;
                    font-size: 15px;
                    margin-top:25px;"
                    >GỬI</button>
            
        </form>
    </div>

</div>
</div>

<!-- Footer -->
<footer class="footer">
            <div>
                <h3>Nhóm 3</h3>
                <p>Lã Ngọc Huyền    | 29-08-2005 </p>
                <p>Trần Anh Đức     | 11-11-2005 </p>
                <p>Nguyễn Phi Long  | 14-06-2005 </p>
            </div>

            <div class="footer-logo">
                <img src="./images/logo.png">
            </div>

</footer>

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