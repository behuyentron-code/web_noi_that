<%@page import="Model.products"%>
<%@page import="DAO.products_DAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<%
    String user = (String) session.getAttribute("user");
    List<products> promoProducts = (List<products>) request.getAttribute("promoProducts");
    products featuredProduct     = (products) request.getAttribute("featuredProduct");
    List<String> categories      = (List<String>) request.getAttribute("categories");
    String selectedCategory      = (String) request.getAttribute("selectedCategory");

    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nội Thất Hiện Đại - Khuyến Mãi</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- ===== NAV ===== -->
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
            <form action="KhuyenMai" method="get">
                <input name="txtSearch" type="text" placeholder="Tìm kiếm..."
                       value="<%= (request.getParameter("txtSearch") == null) ? "" : request.getParameter("txtSearch") %>">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
        </div>

        <div class="auth-group">
            <a href="cart.jsp" class="icon-btn">
                <i class="fa-solid fa-cart-shopping"></i>
                <span class="badge" id="cartCount"><%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %></span>
            </a>

            <% if (user != null) { %>
                <% if ("admin".equals(session.getAttribute("role"))) { %>
                    <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="admin-link">
                        <i class="fa-solid fa-user-tie"></i> Quản trị
                    </a>
                <% } else { %>
                    <div class="icon-btn" style="cursor: default;">
                        <a href="ProfileServlet">
                            <i class="fa-solid fa-circle-user"></i>
                        </a>
                    </div>
                <% } %>
                <a href="login?action=logout" class="btn-pill outline">Đăng xuất</a>
            <% } else { %>
                <a href="#" class="btn-pill outline" onclick="openLogin()">Đăng nhập</a>
                <a href="#" class="btn-pill outline" onclick="openRegister()">Đăng ký</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- ===== MAIN LAYOUT (giống home_page) ===== -->
<div class="container">

    <!-- SIDEBAR DANH MỤC -->
    <aside class="left-menu new-sidebar">
        <h3>DANH MỤC</h3>
        <ul>
            <li onclick="location.href='${pageContext.request.contextPath}/KhuyenMai'"
                class="<%= (selectedCategory == null || selectedCategory.isEmpty()) ? "active-cat" : "" %>">
                Tất Cả
            </li>
            <%
                if (categories != null && !categories.isEmpty()) {
                    for (String cat : categories) {
                        boolean isActive = cat.equals(selectedCategory);
            %>
            <li onclick="location.href='${pageContext.request.contextPath}/KhuyenMai?category=<%= java.net.URLEncoder.encode(cat, "UTF-8") %>'"
                class="<%= isActive ? "active-cat" : "" %>">
                <%= cat %>
            </li>
            <%
                    }
                } else {
            %>
            <li>Không có danh mục</li>
            <% } %>
        </ul>
    </aside>

    <!-- NỘI DUNG CHÍNH -->
    <main class="content">
        <div class="content-header">
            <h2 class="section-title">
                <i class="fa-solid fa-tags" style="color:#4e5c34;margin-right:8px;"></i>
                <%
                    if (selectedCategory != null && !selectedCategory.isEmpty()) {
                        out.print("Khuyến mãi - " + selectedCategory);
                    } else {
                        out.print("Tất cả sản phẩm khuyến mãi");
                    }
                %>
                <span style="font-size:14px;font-weight:500;color:#6b7280;margin-left:12px;">
                    (<%= promoProducts != null ? promoProducts.size() : 0 %> sản phẩm)
                </span>
            </h2>
        </div>

        <div class="product-grid" id="productGrid">
            <%
                if (promoProducts == null || promoProducts.isEmpty()) {
            %>
            <p class="empty-state">Không có sản phẩm khuyến mãi nào trong danh mục này.</p>
            <%
                } else {
                    for (products p : promoProducts) {
                        long rate = p.getDiscount_price();
                        double origPrice = rate > 0
                            ? p.getPrice() * 100.0 / (100.0 - rate)
                            : p.getPrice();
                        String formattedPrice    = fmt.format(p.getPrice());
                        String formattedOrigPrice = fmt.format(Math.round(origPrice / 1000) * 1000);
            %>
            <div class="product-card">
                <div class="product-img">
                    <img src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg" %>"
                         alt="<%= p.getProduct_name() %>"
                         onerror="this.src='https://placehold.co/500x300?text=Nội+Thất'">
                    <% if (rate > 0) { %>
                    <span class="product-badge">-<%= rate %>%</span>
                    <% } %>
                </div>

                <div class="product-info">
                    <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:#6b7c4a;margin-bottom:4px;">
                        <%= p.getCategoryName() %>
                    </div>
                    <h4 class="product-name"><%= p.getProduct_name() %></h4>
                    <div class="product-price" style="text-align: right !important;">
                        <span style="font-size:17px;
                              font-weight:700;
                              color:red;"><%= formattedPrice %></span>
                        <% if (rate > 0) { %>
                        <span style="font-size:12px;color:#d1d5db;text-decoration:line-through;"><%= formattedOrigPrice %></span>
                        <% } %>
                        
                        <div class="product-actions">
                            <button class="btn-add-to-cart" onclick="addToCart(<%= p.getProduct_id()%>, '<%= p.getProduct_name()%>')">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                            </button>
                            <button class="btn-detail" onclick="location.href='${pageContext.request.contextPath}/ProductDetail?id=<%= p.getProduct_id()%>'">
                                Chi tiết
                            </button>
                        </div>
                
                    </div>
                </div>
            </div>
            <% } } %>
        </div>
    </main>
</div>

<!-- ===== TOAST ===== -->
<div id="toast" style="
    position:fixed;bottom:28px;right:28px;z-index:9999;
    background:#4e5c34;color:white;padding:14px 20px;border-radius:12px;
    font-family:'Montserrat',sans-serif;font-size:14px;font-weight:600;
    display:flex;align-items:center;gap:10px;
    box-shadow:0 8px 24px rgba(78,92,52,.35);
    opacity:0;transform:translateY(20px);
    transition:opacity .35s,transform .35s;pointer-events:none;">
    <i id="toast-icon" class="fa-solid fa-circle-check" style="font-size:18px;"></i>
    <span id="toast-msg">Đã thêm vào giỏ hàng!</span>
</div>

<!-- ===== FOOTER ===== -->
<footer class="footer">
    <div>
        <table>
            <tr><td><h3>Nhóm 3</h3></td></tr>
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

<!-- ===== MODAL LOGIN ===== -->
<div id="loginModal" class="modal">
    <div class="modal-box">
        <span class="close" onclick="closeModal('loginModal')">&times;</span>
        <h2>Đăng nhập</h2>
        <form action="loginServlet" method="post">
            <input type="text"     name="username" placeholder="Email" required>
            <input type="password" name="password" placeholder="Mật khẩu" required>
            <button type="submit" name="action" value="login">Đăng nhập</button>
        </form>
        <p style="color:#fff;margin-top:12px;">
            <a href="#" style="color:#fff">Quên mật khẩu</a> |
            <a href="#" onclick="switchModal('loginModal','registerModal')" style="color:#fff">Đăng ký</a>
        </p>
    </div>
</div>

<!-- ===== MODAL REGISTER ===== -->
<div id="registerModal" class="modal">
    <div class="modal-box">
        <span class="close" onclick="closeModal('registerModal')">&times;</span>
        <h2>Đăng ký</h2>
        <form action="loginServlet" method="post">
            <input type="text"     name="username"  placeholder="Email" required>
            <input type="password" name="password"  placeholder="Mật khẩu" required>
            <input type="password" name="password2" placeholder="Nhập lại mật khẩu" required>
            <button type="submit" name="action" value="register">Đăng ký</button>
        </form>
        <p style="color:#fff;margin-top:12px;">
            Đã có tài khoản?
            <a href="#" onclick="switchModal('registerModal','loginModal')" style="color:#fff">Đăng nhập</a>
        </p>
    </div>
</div>

<script>
// ===== TOAST =====
let _tt;
function showToast(msg, isError) {
    const t = document.getElementById('toast');
    document.getElementById('toast-icon').className = isError
        ? 'fa-solid fa-circle-xmark' : 'fa-solid fa-circle-check';
    t.style.background = isError ? '#b91c1c' : '#4e5c34';
    document.getElementById('toast-msg').textContent = msg;
    t.style.opacity = '1'; t.style.transform = 'translateY(0)';
    clearTimeout(_tt);
    _tt = setTimeout(() => { t.style.opacity = '0'; t.style.transform = 'translateY(20px)'; }, 2800);
}

// ===== CART =====
function addToCart(productId, productName) {
    fetch('<%=request.getContextPath()%>/AddToCart?productId=' + productId + '&qty=1')
    .then(res => res.json())
    .then(data => {
        document.getElementById('cartCount').textContent = data.cartCount;
        showToast('Đã thêm "' + productName + '" vào giỏ hàng!', false);
    })
    .catch(() => showToast('Không thể thêm vào giỏ, vui lòng thử lại!', true));
}

// ===== MODAL =====
const urlParams = new URLSearchParams(window.location.search);
if (urlParams.get("openModal") === "login")    openLogin();
if (urlParams.get("openModal") === "register") openRegister();

function openLogin()    { document.getElementById("loginModal").style.display    = "flex"; }
function openRegister() { document.getElementById("registerModal").style.display = "flex"; }
function closeModal(id) { document.getElementById(id).style.display = "none"; }
function switchModal(a, b) { closeModal(a); document.getElementById(b).style.display = "flex"; }
</script>

</body>
</html>
