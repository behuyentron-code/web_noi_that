<%-- 
    Document   : product_detail
    Created on : Apr 13, 2026, 11:31:24 PM
    Author     : Admin
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="Model.products"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <%
        String user = (String) session.getAttribute("user");
        products p = (products) request.getAttribute("product");
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    %>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= p != null ? p.getProduct_name() : "Chi tiết sản phẩm"%> - Decor Luxury</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=account_circle" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="css/style.css">
        <style>
            /* ===== BANNER ===== */


            /* ===== FOOTER ===== */

            @media (max-width: 800px) {
                .detail-wrapper {
                    flex-direction: column;
                    margin: 20px;
                }
                .detail-image-box {
                    flex: none;
                    width: 100%;
                }
                .action-row {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>

        <header class="banner">DECOR LUXURY - NÂNG TẦM KHÔNG GIAN SỐNG</header>

        <nav class="top-menu">
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/hienthi">Trang Chủ</a>
                <a href="${pageContext.request.contextPath}/hienthi">Sản Phẩm</a>
                <a href="#">Khuyến Mãi</a>
                <a href="#">Liên Hệ</a>
            </div>
            <div class="auth-buttons">
                <a href="cart.jsp" class="cart-btn">
                    <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                    <span class="cart-count" id="cartCount">
                        <%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0%>
                    </span>
                </a>
                <% if (user != null) {%>
               <span class="material-symbols-rounded" style="">account_circle</span>
                <a href="logout.jsp" class="btn-login">Đăng xuất</a>
                <% } else { %>
                <a href="#" class="btn-login" onclick="openLogin()">Đăng Nhập</a>
                <a href="#" class="btn-register" onclick="openRegister()">Đăng Ký</a>
                <% } %>
            </div>
        </nav>



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
                <% } %>

                <p style="color: #333" >Đã có tài khoản?
                    <a href="#" onclick="switchModal('registerModal', 'loginModal')" style="color: #333">Đăng nhập</a>
                </p>
            </div>
        </div>

        <!-- Breadcrumb -->
        <!--<div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/hienthi"><i class="fa-solid fa-house"></i> Trang chủ</a>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="${pageContext.request.contextPath}/hienthi">Sản phẩm</a>
        <% if (p != null) {%>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="${pageContext.request.contextPath}/hienthi?category=<%= p.getCategoryName()%>"><%= p.getCategoryName()%></a>
            <i class="fa-solid fa-chevron-right"></i>
            <span style="color:#4e5c34;font-weight:600;"><%= p.getProduct_name()%></span>
        <% } %>
    </div>-->

        <% if (p == null) { %>
        <div style="text-align:center;padding:80px;font-family:'Montserrat',sans-serif;color:#888;">
            <i class="fa-solid fa-box-open" style="font-size:48px;color:#d6ddc8;margin-bottom:16px;display:block;"></i>
            <p>Không tìm thấy sản phẩm.</p>
            <a href="${pageContext.request.contextPath}/hienthi" style="color:#6b7c4a;font-weight:600;">← Quay lại trang chủ</a>
        </div>
        <% } else {
            String formattedPrice = currencyFormat.format(p.getPrice());
        %>

        <!-- Detail Content -->
        <div class="detail-wrapper">

            <!-- LEFT: Image -->
            <div class="detail-image-box">
                <img src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg"%>"
                     alt="<%= p.getProduct_name()%>"
                     onerror="this.src='https://placehold.co/600x400/f0f3ea/6b7c4a?text=<%= java.net.URLEncoder.encode(p.getProduct_name(), "UTF-8")%>'">
                <div class="detail-badge-row">
                    <span class="badge badge-green"><i class="fa-solid fa-shield-halved"></i> Bảo hành 12 tháng</span>
                    <span class="badge badge-blue"><i class="fa-solid fa-truck"></i> Miễn phí vận chuyển</span>
                    <span class="badge badge-olive"><i class="fa-solid fa-rotate-left"></i> Đổi trả 7 ngày</span>
                </div>
            </div>

            <!-- RIGHT: Info -->
            <div class="detail-info">
                <div class="detail-category">
                    <i class="fa-solid fa-tag"></i> <%= p.getCategoryName()%>
                </div>
                <h1 class="detail-name"><%= p.getProduct_name()%></h1>
                <p class="detail-desc-short"><%= p.getDescription() != null ? p.getDescription() : "Sản phẩm nội thất chất lượng cao."%></p>

                <div class="detail-price-box">
                    <div class="price-label">Giá bán</div>
                    <div class="detail-price"><%= formattedPrice%></div>
                    <div class="price-note"><i class="fa-solid fa-circle-info"></i> Giá đã bao gồm VAT</div>
                </div>

                <!-- Quantity -->
                <div class="qty-section">
                    <div class="qty-label-text">Số lượng</div>
                    <div class="qty-control">
                        <button type="button" onclick="changeQty(-1)">−</button>
                        <input type="number" id="qty" value="1" min="1" max="99">
                        <button type="button" onclick="changeQty(1)">+</button>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="action-row">
                    <button class="btn-addcart" onclick="addToCart(<%= p.getProduct_id()%>, '<%= p.getProduct_name().replace("'", "")%>', <%= p.getPrice()%>)">
                        <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                    </button>
                    <button class="btn-buynow" onclick="buyNow(<%= p.getProduct_id()%>)">
                        <i class="fa-solid fa-bolt"></i> Mua ngay
                    </button>
                </div>

                <!-- Features -->
                <div class="features-row">
                    <div class="feature-item"><i class="fa-solid fa-medal"></i> Chất lượng đảm bảo</div>
                    <div class="feature-item"><i class="fa-solid fa-headset"></i> Hỗ trợ 24/7</div>
                    <div class="feature-item"><i class="fa-solid fa-star"></i> Đánh giá 4.8/5</div>
                    <div class="feature-item"><i class="fa-solid fa-lock"></i> Thanh toán an toàn</div>
                </div>
            </div>
        </div>

        <!-- Tabs: Mô tả / Thông số -->
        <div class="tabs-section">
            <div class="tabs-nav">
                <button class="tab-btn active" onclick="switchTab('desc')">Mô tả sản phẩm</button>
                <button class="tab-btn" onclick="switchTab('spec')">Thông số kỹ thuật</button>
                <button class="tab-btn" onclick="switchTab('policy')">Chính sách</button>
            </div>
            <div id="tab-desc" class="tab-panel active">
                <p><%= p.getProduct_name()%> là sản phẩm nội thất cao cấp thuộc danh mục <strong><%= p.getCategoryName()%></strong>,
                    được thiết kế tỉ mỉ nhằm mang lại không gian sống tiện nghi và thẩm mỹ.</p>
                <ul>
                    <li>Chất liệu cao cấp, bền đẹp theo thời gian</li>
                    <li>Thiết kế hiện đại, phù hợp nhiều phong cách nội thất</li>
                    <li>Dễ dàng lắp đặt và vệ sinh</li>
                    <li>Thân thiện môi trường, an toàn cho gia đình</li>
                </ul>
            </div>
            <div id="tab-spec" class="tab-panel">
                <table class="spec-table">
                    <tr><td>Tên sản phẩm</td><td><%= p.getProduct_name()%></td></tr>
                    <tr><td>Danh mục</td><td><%= p.getCategoryName()%></td></tr>
                    <tr><td>Mã sản phẩm</td><td>SP-<%= String.format("%04d", p.getProduct_id())%></td></tr>
                    <tr><td>Giá bán</td><td><%= formattedPrice%></td></tr>
                    <tr><td>Bảo hành</td><td>12 tháng</td></tr>
                    <tr><td>Xuất xứ</td><td>Việt Nam</td></tr>
                </table>
            </div>
            <div id="tab-policy" class="tab-panel">
                <ul>
                    <li><strong>Miễn phí vận chuyển</strong> toàn quốc cho đơn hàng từ 500.000đ</li>
                    <li><strong>Đổi trả trong 7 ngày</strong> nếu sản phẩm lỗi do nhà sản xuất</li>
                    <li><strong>Bảo hành 12 tháng</strong> chính hãng</li>
                    <li>Hỗ trợ <strong>trả góp 0%</strong> lãi suất qua thẻ tín dụng</li>
                </ul>
            </div>
        </div>

        <% }%>

        <footer class="footer">
            <div>
                <h3>Nhóm 3</h3>
                <p>Lã Ngọc Huyền    | 29-08-2005</p>
                <p>Trần Anh Đức     | 11-11-2005</p>
                <p>Nguyễn Phi Long  | 14-06-2005</p>
            </div>
            <div class="footer-logo">
                <img src="./images/logo.png">
            </div>
        </footer>

        <div class="toast" id="toast">
            <i class="fa-solid fa-circle-check"></i>
            <span id="toast-msg">Đã thêm vào giỏ hàng!</span>
        </div>

        <script>
            function changeQty(delta) {
                const input = document.getElementById('qty');
                let val = parseInt(input.value) + delta;
                if (val < 1)
                    val = 1;
                if (val > 99)
                    val = 99;
                input.value = val;
            }

            function addToCart(id, name, price) {
                const qty = parseInt(document.getElementById('qty').value);
                // Gọi servlet AddToCart
                fetch('${pageContext.request.contextPath}/AddToCart?productId=' + id + '&qty=' + qty, {method: 'POST'})
                        .then(res => res.json())
                        .then(data => {
                            document.getElementById('cartCount').textContent = data.cartCount;
                            showToast('Đã thêm ' + qty + ' sản phẩm vào giỏ hàng!');
                        })
                        .catch(() => {
                            // Fallback: cập nhật UI tạm thời
                            const cur = parseInt(document.getElementById('cartCount').textContent) || 0;
                            document.getElementById('cartCount').textContent = cur + qty;
                            showToast('Đã thêm ' + qty + ' × ' + name + ' vào giỏ!');
                        });
            }

            function buyNow(id) {
                addToCart(id, '', 0);
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/cart.jsp';
                }, 500);
            }

            function switchTab(tab) {
                document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
                document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                document.getElementById('tab-' + tab).classList.add('active');
                event.target.classList.add('active');
            }

            function showToast(msg) {
                const t = document.getElementById('toast');
                document.getElementById('toast-msg').textContent = msg;
                t.classList.add('show');
                setTimeout(() => t.classList.remove('show'), 2800);
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
