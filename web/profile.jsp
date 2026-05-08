<%-- 
    Document   : profile
    Created on : 5 thg 5, 2026, 19:36:06
    Author     : TRANG ANH LAPTOP
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Thông tin cá nhân</title>
<!--    <link rel="stylesheet" href="css/profile.css">-->
    <link rel="stylesheet" href="css/style.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<%
    String user = (String) session.getAttribute("user");
%>
<body>
    <!-- Hồ sơ cá nhân cuả người dùng -->
    
    <nav class="top-menu">
            <div class="left-nav">
                <a href="${pageContext.request.contextPath}/home" class="logo-brand">
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

                <a href="${pageContext.request.contextPath}/KhuyenMai">Khuyến Mãi</a>
                <a href="${pageContext.request.contextPath}/ContactServlet">Liên Hệ</a>
            </div>

            <div class="right-nav">
                <div class="search-container">
                    <form action="hienthi" method="post">  
                        <input name="txtSearch" type="text" placeholder="Tìm kiếm..." 
                               value="<%= (request.getParameter("txtSearch")== null) ? "" : request.getParameter("txtSearch") %>">
                            <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                    </form>    
                </div>
                            
<!-- Hiển thị đăng ký/đăng nhập thành công -->
<%
    String loginSuccess   = (String) session.getAttribute("loginSuccess");
    if (loginSuccess != null) session.removeAttribute("loginSuccess");

    String registerSuccess = (String) session.getAttribute("registerSuccess");
    if (registerSuccess != null) session.removeAttribute("registerSuccess");
%>

<% if (loginSuccess != null || registerSuccess != null) { %>
<script>
    window.addEventListener('DOMContentLoaded', function () {
        <% if (loginSuccess != null) { %>
            showToast('<%= loginSuccess %>');
        <% } else { %>
            showToast('<%= registerSuccess %>');
        <% } %>
    });
</script>
<% } %>                     
                <div class="auth-group">
                    <a href="cart.jsp" class="icon-btn">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <span class="badge"><%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %></span>
                    </a>
   
                     <% if (user != null) { %>
                        <%-- Kiểm tra vai trò --%>
                        <% if ("admin".equals(session.getAttribute("role"))) { %>
                            <a href="AdminDashboardServlet" class="admin-link">
                                <i class="fa-solid fa-user-tie"></i> Quản trị
                            </a>
                        <% } else { %>
                            <%-- Chỉ hiện icon account cho User --%>
                            <div class="icon-btn" style="cursor: default;">
                                <a  href="${pageContext.request.contextPath}/ProfileServlet">
                                    <i class="fa-solid fa-circle-user"></i>
                                </a>
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
   
    <div class="container" style="display: flex; justify-content: center; gap: 20px; margin: 40px auto; max-width: 1100px; background: transparent; box-shadow: none;">
        
        <div class="left-menu" style="width: 250px; flex-shrink: 0; background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); align-self: flex-start;">
            <h3 style="margin: 0; padding: 20px; font-size: 18px; border-bottom: 1px solid #eee;">TÀI KHOẢN</h3>
            <ul style="list-style: none; padding: 10px 0;">
                <li style="padding: 12px 20px; background: #f0f3ea; color: #4e5c34; font-weight: bold;"><i class="fas fa-user-alt"></i> Thông tin cá nhân</li>
              
                <li style="padding: 12px 20px; cursor: pointer;" onclick="location.href='home'"><i class="fas fa-sign-out-alt"></i> Quay lại trang chủ</li>
            </ul>
        </div>

        <div class="content" style="flex: 1; background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); margin-left: 0;">
            <div class="content-header" style="border-bottom: 2px solid #f0f3ea; margin-bottom: 20px; padding-bottom: 10px;">
                <h2 style="margin: 0; color: #2c2c2c; font-size: 22px;">Chi tiết tài khoản</h2>
            </div>

            <table class="spec-table" style="width: 100%; border-collapse: collapse;">
                <tr style="background: #fcfdfb;">
                    <td style="padding: 15px; font-weight: 600; color: #4e5c34; width: 30%;">Tên đăng nhập</td>
                    <td style="padding: 15px;">${username}</td>
                </tr>
                <tr>
                    <td style="padding: 15px; font-weight: 600; color: #4e5c34;">Email liên hệ</td>
                    <td style="padding: 15px;">${userProfile.email != null ? userProfile.email : 'Chưa cập nhật'}</td>
                </tr>
                <tr style="background: #fcfdfb;">
                    <td style="padding: 15px; font-weight: 600; color: #4e5c34;">Số điện thoại</td>
                    <td style="padding: 15px;">${userProfile.phone != null ? userProfile.phone : 'Chưa cập nhật'}</td>
                </tr>
                <tr>
                    <td style="padding: 15px; font-weight: 600; color: #4e5c34;">Địa chỉ</td>
                    <td style="padding: 15px;">${userProfile.address != null ? userProfile.address : 'Chưa cập nhật'}</td>
                </tr>
            </table>

            <div style="margin-top: 30px; display: flex; gap: 15px;">
                <button class="btn-pill solid" style="cursor: pointer; padding: 10px 25px;" onclick="location.href='home'">Quay lại</button>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div>
            <table>
                <tr>
                    <td><h3>Nhóm 3</h3></td>
                </tr>
                <tr>
                    <td><p>Lã Ngọc Huyền</p></td>
                    <td><p> |  29-08-2005</p></td>
                </tr>

                <tr>
                    <td><p>Trần Anh Đức</p></td>
                    <td><p> |  11-11-2005</p></td>
                </tr>

                <tr>
                    <td><p>Nguyễn Phi Long</p></td>
                    <td><p> |  14-06-2005</p></td>
                </tr>
            </table>

        </div>
        <div class="footer-logo">
            <img src="images/logo.png">
        </div>
    </footer>
                
</body>
</html>