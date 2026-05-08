<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="Model.products"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Nội Thất Hiện Đại - Trang Chủ</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">

    <style>
    /* ===================== HERO ===================== */
    .hero {
        position: relative;
        width: 100%;
        min-height: 520px;
        background-image: url('images/image.png');
        background-size: cover;
        background-position: center 30%;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 60px 0;        /* ← BỎ padding ngang, dùng 0 Mất số 0 thì các chữ và hình tròn lệch về bên phải 1 tý*/
        overflow: hidden;
    }

    .hero::after {
        content: '';
        position: absolute;
        inset: 0;
        background: linear-gradient(
            135deg,
            rgba(78, 92, 52, 0.88) 0%,
            rgba(107, 124, 74, 0.80) 55%,
            rgba(138, 154, 98, 0.65) 100%
        );
        pointer-events: none;
        z-index: 0;
    }

    .hero::before {
        content: '';
        position: absolute;
        inset: 0;
        background-image: radial-gradient(circle, rgba(255,255,255,0.06) 1px, transparent 1px);
        background-size: 24px 24px;
        pointer-events: none;
        z-index: 1;
    }

    .hero .circle-deco {
        position: absolute;
        left: 50%; top: 50%;           /* ← căn giữa */
        transform: translate(-50%, -50%);
        width: 600px; height: 600px;
        border-radius: 50%;
        background: rgba(255,255,255,0.04);
        pointer-events: none;
        z-index: 1;
    }

    .hero .circle-deco2 {
        position: absolute;
        left: 50%; top: 50%;           /* ← căn giữa */
        transform: translate(-50%, -50%);
        width: 400px; height: 400px;
        border-radius: 50%;
        background: rgba(255,255,255,0.03);
        pointer-events: none;
        z-index: 1;
    }

    .hero .hero-left {
        position: relative;
        z-index: 2;
        /* XOÁ flex:1 */
        width: 100%;
        max-width: 900px;
        text-align: center;
        margin: 0 auto;              /* ← căn block giữa */
        padding: 0 40px;             /* ← padding ngang ở đây thay vì ở .hero */
    }

    .hero .event-badge {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        border: 1.5px solid rgba(255,255,255,0.5);
        border-radius: 20px;
        padding: 6px 16px;
        color: rgba(255,255,255,0.9) !important;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 2px;
        text-transform: uppercase;
        margin-bottom: 28px;
        font-family: "Montserrat", sans-serif;
        backdrop-filter: blur(4px);
        background: rgba(0,0,0,0.15);
    }

    .hero .event-badge::before {
        content: '🔥';
        font-size: 13px;
    }

    .hero .hero-title {
        font-family: "Montserrat", sans-serif;
        font-size: clamp(28px, 3.2vw, 52px);
        line-height: 1.2;
        color: #ffffff !important;
        margin: 0 0 20px 0;
        font-weight: 800;
        letter-spacing: 1px;
        /* XOÁ white-space nếu có */
        white-space: normal;
    }

    .hero .hero-title .highlight {
        color: #c8e060 !important;
        font-style: italic;
    }

    .hero .hero-desc {
        font-size: 15px;
        line-height: 1.7;
        color: rgba(255,255,255,0.85) !important;
        max-width: 520px;
        margin: 0 auto 32px auto;
        font-family: "Montserrat", sans-serif;
    }

    .hero .btn-buy {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 14px 36px;
        background: #ffffff;
        color: #4e5c34 !important;
        border: none;
        border-radius: 60px;
        font-family: "Montserrat", sans-serif;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.25s;
        box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        text-decoration: none;
    }

    .hero .btn-buy:hover {
        background: #c8e060;
        color: #2d4a10 !important;
        transform: translateY(-2px);
        box-shadow: 0 8px 28px rgba(0,0,0,0.25);
    }

    .hero .hero-stats {
        display: flex;
        gap: 60px;
        margin-top: 40px;
        justify-content: center;
        align-items: flex-start;
    }

    .hero .stat-item {
        text-align: center;
    }

    .hero .stat-item .stat-num {
        font-size: 24px;
        font-weight: 800;
        color: #c8e060 !important;
        margin-bottom: 4px;
        font-family: "Montserrat", sans-serif;
        display: block;
    }

    .hero .stat-item .stat-label {
        font-size: 12px;
        color: rgba(255,255,255,0.75) !important;
        font-family: "Montserrat", sans-serif;
        display: block;
    }

    @media (max-width: 768px) {
        .hero {
            min-height: 300px;
            padding: 40px 0;
        }
        .hero .hero-left {
            padding: 0 20px;
        }
        .hero .hero-title {
            font-size: 26px;
        }
        .hero .hero-stats {
            gap: 24px;
            flex-wrap: wrap;
        }
    }
</style>
</head>
<body>

<%
    String user = (String) session.getAttribute("user");

    String loginError    = (String) session.getAttribute("loginError");
    String loginUsername = (String) session.getAttribute("loginUsername");
    if (loginError != null) {
        session.removeAttribute("loginError");
        session.removeAttribute("loginUsername");
    }

    String registerError = (String) session.getAttribute("registerError");
    String regUsername   = (String) session.getAttribute("regUsername");
    String regEmail      = (String) session.getAttribute("regEmail");
    String regPhone      = (String) session.getAttribute("regPhone");
    String regAddress    = (String) session.getAttribute("regAddress");
    if (registerError != null) {
        session.removeAttribute("registerError");
        session.removeAttribute("regUsername");
        session.removeAttribute("regEmail");
        session.removeAttribute("regPhone");
    }
%>

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
                    if (navCats != null) {
                        for (String cat : navCats) {
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
                <% if ("admin".equals(session.getAttribute("role"))) { %>
                    <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="admin-link">
                        <i class="fa-solid fa-user-tie"></i> Quản trị
                    </a>
                <% } else { %>
                    <div class="icon-btn" style="cursor:default;">
                        <a  href="ProfileServlet">
                            <i class="fa-solid fa-circle-user"></i>
                        </a>
                    </div>
                <% } %>
                <a href="login?action=logout" class="btn-pill outline">Đăng xuất</a>
            <% } else { %>
                <a href="#" class="btn-pill outline" onclick="openLogin()">Đăng nhập</a>
                <a href="#" class="btn-pill outline"  onclick="openRegister()">Đăng ký</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="circle-deco"></div>
    <div class="circle-deco2"></div>
    
    <div class="hero-left">
        <h1 class="hero-title">
            Chào mừng đến với <span class="highlight">DECOR LUXURY</span><br>
            Nâng tầm không gian sống
        </h1>
        
        <p class="hero-desc">
            
            Hàng trăm mẫu thiết kế hiện đại đang chờ bạn!
        </p>
        <a href="${pageContext.request.contextPath}/hienthi" class="btn-buy">
            ⚡ Khám phá tại đây
        </a>
        <div class="hero-stats">
            <div class="stat-item">
                <span class="stat-num" id="sale-count">0+</span>
                <span class="stat-label">Sản phẩm giảm giá</span>
            </div>
            <div class="stat-item">
                <span class="stat-num">50%</span>
                <span class="stat-label">Giảm tối đa</span>
            </div>
            <div class="stat-item">
                <span class="stat-num">Free</span>
                <span class="stat-label">Giao hàng toàn quốc</span>
            </div>
        </div>
    </div>
</section>

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

<!-- MODAL LOGIN -->
<div id="loginModal" class="modal">
    <div class="modal-box">
        <span class="close" onclick="closeModal('loginModal')">&times;</span>
        <h2>Đăng nhập</h2>
        <form action="login" method="post">
            <input type="text"     name="username" placeholder="Tên đăng nhập"
                   value="<%= loginUsername != null ? loginUsername : "" %>" required>
            <input type="password" name="password" placeholder="Mật khẩu" required>
            <button type="submit"  name="action" value="login" class="btn-submit">Đăng nhập</button>
        </form>
        <% if (loginError != null) { %>
            <div class="error-message">
                <i class="fa-solid fa-circle-exclamation"></i> <%= loginError %>
            </div>
        <% } %>
        <p>Chưa có tài khoản?
            <a href="#" onclick="switchModal('loginModal','registerModal')">Đăng ký</a>
        </p>
    </div>
</div>

<!-- MODAL REGISTER -->
<div id="registerModal" class="modal">
    <div class="modal-box">
        <span class="close" onclick="closeModal('registerModal')">&times;</span>
        <h2>Đăng ký</h2>
        <form action="login" method="post">
            <input type="text"     name="username"        placeholder="Tên đăng nhập"
                   value="<%= regUsername != null ? regUsername : "" %>" required>
            <input type="email"    name="email"           placeholder="Email"
                   value="<%= regEmail    != null ? regEmail    : "" %>" required>
            <input type="tel"      name="phone"           placeholder="Số điện thoại"
                   value="<%= regPhone    != null ? regPhone    : "" %>" required>
            <input type="text"     name="address"         placeholder="Địa chỉ"
                   value="<%= regAddress  != null ? regAddress  : "" %>" required>
            <input type="password" name="password"        placeholder="Mật khẩu" required>
            <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
            <button type="submit"  name="action" value="register" class="btn-submit">Đăng ký</button>
        </form>
        <% if (registerError != null) { %>
            <div class="error-message">
                <i class="fa-solid fa-circle-exclamation"></i> <%= registerError %>
            </div>
        <% } %>
        <p>Đã có tài khoản?
            <a href="#" onclick="switchModal('registerModal','loginModal')">Đăng nhập</a>
        </p>
    </div>
</div>

<script>
    function showToast(msg, isError = false) {
        const t    = document.getElementById('toast');
        const icon = t.querySelector('i');
        document.getElementById('toast-msg').textContent = msg;
        t.style.background = isError ? '#c0392b' : '#4e5c34';
        icon.className     = isError ? 'fa-solid fa-circle-xmark' : 'fa-solid fa-circle-check';
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 2800);
    }

    function addToCart(productId, productName) {
        fetch('<%= request.getContextPath() %>/AddToCart?productId=' + productId + '&qty=1')
        .then(res => {
            if (res.ok) {
                const badge = document.querySelector('.badge');
                if (badge) badge.textContent = parseInt(badge.textContent || 0) + 1;
                showToast('Đã thêm "' + productName + '" vào giỏ hàng!');
            } else {
                showToast('Không thể thêm vào giỏ, vui lòng thử lại!', true);
            }
        })
        .catch(() => showToast('Không thể thêm vào giỏ, vui lòng thử lại!', true));
    }

    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get("openModal") === "login")    openLogin();
    if (urlParams.get("openModal") === "register") openRegister();

    function openLogin()    { 
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