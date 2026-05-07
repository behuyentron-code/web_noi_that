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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/khuyen_mai.css">
</head>
<body>

<nav class="top-menu">s
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
                <a href="#" class="btn-pill outline" onclick="openRegister()">Đăng ký</a>
            <% } %>
        </div>
    </div>
</nav>


<!-- ===== MAIN ===== -->
<div class="promo-wrap">

    <!-- FEATURED DEAL (lấy từ DB qua Servlet) -->
    <% if (featuredProduct != null) {
        double oldPrice   = featuredProduct.getPrice() * 100.0 / 70.0;
        double savedAmt   = oldPrice - featuredProduct.getPrice();
    %>
    <h2 class="section-title" id="san-pham">
        <i class="fa-solid fa-star"></i> Deal Đặc Biệt Hôm Nay
    </h2>
    <div class="featured-deal">
        <span class="featured-ribbon">🔥 Hot Deal</span>
        <img class="deal-img"
             src="${pageContext.request.contextPath}/images/<%= featuredProduct.getImage() != null ? featuredProduct.getImage() : "default.jpg" %>"
             alt="<%= featuredProduct.getProduct_name() %>"
             onerror="this.src='https://placehold.co/700x320?text=No+Image'">
        <div class="deal-body">
            <div class="deal-tag"><i class="fa-solid fa-fire"></i> Ưu đãi 24h</div>
            <h2 class="deal-name"><%= featuredProduct.getProduct_name() %></h2>
            <p class="deal-desc">
                <%= featuredProduct.getDescription() != null
                    ? featuredProduct.getDescription()
                    : "Sản phẩm nội thất cao cấp, thiết kế hiện đại." %>
            </p>
            <div class="deal-price-row">
                <span class="deal-price-new"><%= fmt.format(featuredProduct.getPrice()) %></span>
                <span class="deal-price-old"><%= fmt.format(Math.round(oldPrice / 1000) * 1000) %></span>
                <span class="deal-save">Tiết kiệm <%= fmt.format(Math.round(savedAmt / 1000) * 1000) %></span>
            </div>
            <button class="btn-deal"
                    onclick="addToCart(<%= featuredProduct.getProduct_id() %>, '<%= featuredProduct.getProduct_name() %>')">
                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
            </button>
        </div>
    </div>
    <% } %>

    <!-- FILTER -->
    <div class="filter-bar">
        <div class="filter-tabs">
            <a href="${pageContext.request.contextPath}/khuyen-mai"
               class="filter-tab <%= (selectedCategory == null || selectedCategory.isEmpty()) ? "active" : "" %>">
                Tất cả
            </a>
            <%
            if (categories != null) {
                for (String cat : categories) {
                    boolean active = cat.equals(selectedCategory);
            %>
            <a href="${pageContext.request.contextPath}/khuyen-mai?category=<%= java.net.URLEncoder.encode(cat,"UTF-8") %>"
               class="filter-tab <%= active ? "active" : "" %>">
                <%= cat %>
            </a>
            <% } } %>
        </div>
        <div class="result-count">
            Hiển thị <strong><%= promoProducts != null ? promoProducts.size() : 0 %></strong> sản phẩm
        </div>
    </div>

    <!-- PRODUCT GRID -->
    <div class="promo-grid">
    <% if (promoProducts == null || promoProducts.isEmpty()) { %>
        <div class="empty-state">
            <i class="fa-solid fa-box-open"></i>
            <p style="font-size:16px;font-weight:600;color:#6b7280;">
                Không có sản phẩm khuyến mãi trong danh mục này.
            </p>
        </div>
    <% } else {
        int idx = 0;
        for (products p : promoProducts) {
            long rate = p.getDiscount_price();  // lấy từ DB
            double origPrice = rate > 0
                ? p.getPrice() * 100.0 / (100.0 - rate)
                : p.getPrice();
            int stock = p.getQuantity();
            idx++;
    %>
        <div class="promo-card">
            <img class="promo-card-img"
                 src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg" %>"
                 alt="<%= p.getProduct_name() %>"
                 onerror="this.src='https://placehold.co/500x210?text=No+Image'">
            <span class="discount-badge">-<%= rate %>%</span>
            <div class="promo-card-body">
                <div class="promo-card-cat"><%= p.getCategoryName() %></div>
                <div class="promo-card-name"><%= p.getProduct_name() %></div>
                <div class="promo-card-desc">
                    <%= p.getDescription() != null ? p.getDescription() : "Sản phẩm chất lượng cao" %>
                </div>
                <div class="promo-price-row">
                    <span class="price-new"><%= fmt.format(p.getPrice()) %></span>
                    <span class="price-old"><%= fmt.format(Math.round(origPrice / 1000) * 1000) %></span>
                </div>
                <div class="card-btn-row">
                    <button class="btn-cart"
                            onclick="addToCart(<%= p.getProduct_id() %>, '<%= p.getProduct_name() %>')">
                        <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                    </button>
                    <a href="${pageContext.request.contextPath}/ProductDetail?id=<%= p.getProduct_id() %>"
                       class="btn-detail" title="Xem chi tiết">
                        <i class="fa-solid fa-eye"></i>
                    </a>
                </div>
            </div>
        </div>
    <% } } %>
    </div><!-- /promo-grid -->

    
</div><!-- /promo-wrap -->

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
    _tt = setTimeout(() => { t.style.opacity='0'; t.style.transform='translateY(20px)'; }, 2800);
}

// ===== CART =====
function addToCart(productId, productName) {
    fetch('<%=request.getContextPath()%>/AddToCart?productId=' + productId + '&qty=1')
    .then(res => res.json())
    .then(data => {
        document.getElementById('cartCount').textContent = data.cartCount;
        showToast('Đã thêm "' + productName + '" vào giỏ hàng!', false);
    })
    .catch(() => showToast('Không thể thêm vào giỏ, thử lại sau!', true));
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
