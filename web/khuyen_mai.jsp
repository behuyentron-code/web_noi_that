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

    // Mảng tỉ lệ giảm demo – thêm cột discount_rate vào DB để dùng thực tế
    int[] discountRates = {10, 15, 20, 25, 30, 35, 40, 45, 50};
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nội Thất Hiện Đại - Khuyến Mãi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/khuyen_mai.css"
</head>
<body>

<header class="banner">
    DECOR LUXURY - NÂNG TẦM KHÔNG GIAN SỐNG
</header>

<nav class="top-menu">
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/hienthi">Trang Chủ</a>
        <a href="${pageContext.request.contextPath}/productDetail">Sản Phẩm</a>
        <a href="${pageContext.request.contextPath}/khuyen-mai"
           style="background:#f0f3ea;color:#4e5c34;">Khuyến Mãi</a>
        <a href="lienhe.jsp">Liên Hệ</a>
    </div>
    <div class="auth-buttons">
        <a href="cart.jsp" class="cart-btn">
            <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
            <span class="cart-count" id="cartCount">
                <%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %>
            </span>
        </a>
        <% if (user != null) { %>
            <span style="padding:0 12px;font-weight:600;color:#4e5c34;">Xin chào, <%= user %></span>
            <a href="logout.jsp">Đăng xuất</a>
        <% } else { %>
            <a href="#" class="btn-login"   onclick="openLogin()">Đăng Nhập</a>
            <a href="#" class="btn-register" onclick="openRegister()">Đăng Ký</a>
        <% } %>
    </div>
</nav>

<!-- ===== HERO ===== -->
<section class="promo-hero">
    <div class="hero-text">
        <div class="hero-eyebrow">
            <i class="fa-solid fa-fire"></i> Sự kiện khuyến mãi lớn nhất năm
        </div>
        <h1 class="hero-title">
            Giảm giá<br>đến <span>50%</span><br>toàn bộ sản phẩm
        </h1>
        <p class="hero-subtitle">
            Cơ hội vàng để sở hữu nội thất cao cấp với mức giá tốt nhất.
            Hàng trăm mẫu thiết kế hiện đại đang chờ bạn!
        </p>
        <a href="#san-pham" class="hero-cta">
            <i class="fa-solid fa-bolt"></i> Mua ngay hôm nay
        </a>
        <div class="hero-stats">
            <div>
                <span class="stat-num"><%= promoProducts != null ? promoProducts.size() : 0 %>+</span>
                <span class="stat-label">Sản phẩm giảm giá</span>
            </div>
            <div><span class="stat-num">50%</span><span class="stat-label">Giảm tối đa</span></div>
            <div><span class="stat-num">Free</span><span class="stat-label">Giao hàng toàn quốc</span></div>
        </div>
    </div>
    <div class="hero-countdown">
        <div class="countdown-label"><i class="fa-regular fa-clock"></i> Kết thúc sau</div>
        <div class="countdown-boxes">
            <div class="cd-box"><span class="cd-num" id="cd-days">00</span><span class="cd-unit">Ngày</span></div>
            <div class="cd-box"><span class="cd-num" id="cd-hours">00</span><span class="cd-unit">Giờ</span></div>
            <div class="cd-box"><span class="cd-num" id="cd-mins">00</span><span class="cd-unit">Phút</span></div>
            <div class="cd-box"><span class="cd-num" id="cd-secs">00</span><span class="cd-unit">Giây</span></div>
        </div>
    </div>
</section>

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
            int rate = discountRates[idx % discountRates.length];
            double origPrice = p.getPrice() * 100.0 / (100.0 - rate);
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

    <!-- ===== VOUCHER ===== -->
    <h2 class="section-title" style="margin-top:50px;">
        <i class="fa-solid fa-ticket"></i> Mã Giảm Giá
    </h2>
    <div class="voucher-grid">

        <div class="voucher-card">
            <div class="voucher-left">
                <i class="fa-solid fa-couch voucher-icon"></i>
                <span class="voucher-pct">10%</span>
                <span class="voucher-off">Giảm</span>
            </div>
            <div class="voucher-right">
                <div class="voucher-title">Giảm 10% toàn bộ đơn hàng</div>
                <div class="voucher-cond">Áp dụng đơn từ 5.000.000đ · Không kết hợp KM khác</div>
                <div class="voucher-code-row">
                    <span class="voucher-code">DECOR10</span>
                    <button class="btn-copy" onclick="copyCode(this,'DECOR10')">Sao chép</button>
                </div>
                <div class="voucher-expiry"><i class="fa-regular fa-clock"></i> Hết hạn: 30/06/2026</div>
            </div>
        </div>

        <div class="voucher-card">
            <div class="voucher-left" style="background:linear-gradient(180deg,#c4620a,#e07830);">
                <i class="fa-solid fa-truck voucher-icon"></i>
                <span class="voucher-pct" style="font-size:14px;font-weight:900;">FREE</span>
                <span class="voucher-off">Ship</span>
            </div>
            <div class="voucher-right">
                <div class="voucher-title">Miễn phí vận chuyển toàn quốc</div>
                <div class="voucher-cond">Áp dụng tất cả đơn hàng · Giao trong 3–5 ngày</div>
                <div class="voucher-code-row">
                    <span class="voucher-code">FREESHIP</span>
                    <button class="btn-copy" onclick="copyCode(this,'FREESHIP')">Sao chép</button>
                </div>
                <div class="voucher-expiry"><i class="fa-regular fa-clock"></i> Hết hạn: 31/05/2026</div>
            </div>
        </div>

        <div class="voucher-card">
            <div class="voucher-left" style="background:linear-gradient(180deg,#1565c0,#1e88e5);">
                <i class="fa-solid fa-gift voucher-icon"></i>
                <span class="voucher-pct">500K</span>
                <span class="voucher-off">Giảm</span>
            </div>
            <div class="voucher-right">
                <div class="voucher-title">Giảm 500.000đ cho khách mới</div>
                <div class="voucher-cond">Chỉ áp dụng lần đầu · Đơn tối thiểu 3.000.000đ</div>
                <div class="voucher-code-row">
                    <span class="voucher-code">NEWBIE500</span>
                    <button class="btn-copy" onclick="copyCode(this,'NEWBIE500')">Sao chép</button>
                </div>
                <div class="voucher-expiry"><i class="fa-regular fa-clock"></i> Hết hạn: 15/05/2026</div>
            </div>
        </div>

        <div class="voucher-card">
            <div class="voucher-left" style="background:linear-gradient(180deg,#6a1b9a,#9c27b0);">
                <i class="fa-solid fa-bed voucher-icon"></i>
                <span class="voucher-pct">15%</span>
                <span class="voucher-off">Giảm</span>
            </div>
            <div class="voucher-right">
                <div class="voucher-title">Giảm 15% danh mục Phòng Ngủ</div>
                <div class="voucher-cond">Chỉ áp dụng Phòng Ngủ · Đơn từ 8.000.000đ</div>
                <div class="voucher-code-row">
                    <span class="voucher-code">SLEEP15</span>
                    <button class="btn-copy" onclick="copyCode(this,'SLEEP15')">Sao chép</button>
                </div>
                <div class="voucher-expiry"><i class="fa-regular fa-clock"></i> Hết hạn: 20/06/2026</div>
            </div>
        </div>

        <div class="voucher-card">
            <div class="voucher-left" style="background:linear-gradient(180deg,#2e7d32,#43a047);">
                <i class="fa-solid fa-utensils voucher-icon"></i>
                <span class="voucher-pct">20%</span>
                <span class="voucher-off">Giảm</span>
            </div>
            <div class="voucher-right">
                <div class="voucher-title">Giảm 20% bộ bàn ăn</div>
                <div class="voucher-cond">Áp dụng bộ bàn + ghế · Không giới hạn đơn</div>
                <div class="voucher-code-row">
                    <span class="voucher-code">DINE20</span>
                    <button class="btn-copy" onclick="copyCode(this,'DINE20')">Sao chép</button>
                </div>
                <div class="voucher-expiry"><i class="fa-regular fa-clock"></i> Hết hạn: 28/06/2026</div>
            </div>
        </div>

        <div class="voucher-card">
            <div class="voucher-left" style="background:linear-gradient(180deg,#b71c1c,#e53935);">
                <i class="fa-solid fa-crown voucher-icon"></i>
                <span class="voucher-pct">VIP</span>
                <span class="voucher-off">30%</span>
            </div>
            <div class="voucher-right">
                <div class="voucher-title">Ưu đãi VIP – Giảm 30%</div>
                <div class="voucher-cond">Chỉ dành cho thành viên VIP · Đơn từ 20.000.000đ</div>
                <div class="voucher-code-row">
                    <span class="voucher-code">VIP30</span>
                    <button class="btn-copy" onclick="copyCode(this,'VIP30')">Sao chép</button>
                </div>
                <div class="voucher-expiry"><i class="fa-regular fa-clock"></i> Hết hạn: 01/07/2026</div>
            </div>
        </div>

    </div><!-- /voucher-grid -->
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
        <h3>Nhóm 3</h3>
        <p>Lã Ngọc Huyền &nbsp;&nbsp;&nbsp;| 29-08-2005</p>
        <p>Trần Anh Đức &nbsp;&nbsp;&nbsp;&nbsp;| 11-11-2005</p>
        <p>Nguyễn Phi Long | 14-06-2005</p>
    </div>
    <div class="footer-logo"><img src="./images/logo.png" alt="Logo"></div>
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
// ===== COUNTDOWN =====
const deadline = new Date();
deadline.setDate(deadline.getDate() + 5);
deadline.setHours(deadline.getHours() + 12);
function updateCountdown() {
    const diff = deadline - new Date();
    if (diff <= 0) return;
    const d = Math.floor(diff / 86400000);
    const h = Math.floor((diff % 86400000) / 3600000);
    const m = Math.floor((diff % 3600000)  / 60000);
    const s = Math.floor((diff % 60000)    / 1000);
    document.getElementById('cd-days').textContent  = String(d).padStart(2,'0');
    document.getElementById('cd-hours').textContent = String(h).padStart(2,'0');
    document.getElementById('cd-mins').textContent  = String(m).padStart(2,'0');
    document.getElementById('cd-secs').textContent  = String(s).padStart(2,'0');
}
updateCountdown(); setInterval(updateCountdown, 1000);

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

// ===== COPY VOUCHER =====
function copyCode(btn, code) {
    navigator.clipboard.writeText(code).catch(() => {});
    btn.textContent = 'Đã sao chép!'; btn.classList.add('copied');
    showToast('✅ Đã sao chép mã: ' + code, false);
    setTimeout(() => { btn.textContent = 'Sao chép'; btn.classList.remove('copied'); }, 2500);
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
