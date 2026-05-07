<%-- 
    Document   : cart
    Created on : Apr 13, 2026, 11:31:40 PM
    Author     : Admin
--%>

<%@page import="Model.products"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
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
    
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

    // cart: Map<product_id, [product, qty]>
    Map<Integer, Object[]> cart = (Map<Integer, Object[]>) session.getAttribute("cart");
    if (cart == null) cart = new LinkedHashMap<>();

    double subtotal = 0;
    for (Object[] entry : cart.values()) {
        products p = (products) entry[0];
        int qty = (int) entry[1];
        subtotal += p.getPrice() * qty;
    }
    double shipping = subtotal >= 500000 ? 0 : 30000;
    double total = subtotal + shipping;
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Decor Luxury</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/giohang.css">

</head>
<body>


<nav class="top-menu">
    <div class="left-nav">
        <a href="${pageContext.request.contextPath}/hienthi" class="logo-brand">
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

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/hienthi"><i class="fa-solid fa-house"></i> Trang chủ</a>
    <i class="fa-solid fa-chevron-right"></i>
    <span style="color:var(--olive-dark);font-weight:600;">Giỏ hàng</span>
</div>

<div class="cart-page">
    <div class="cart-page-title">
        <i class="fa-solid fa-basket-shopping"></i>
        Giỏ hàng của bạn
        <span style="font-size:15px;font-weight:400;color:var(--text-muted);">(<%= cart.size() %> sản phẩm)</span>
    </div>

    <div class="cart-layout">
        <!-- LEFT: Items -->
        <div class="cart-items-col">

            <% if(cart.isEmpty()) { %>
                <div class="empty-cart">
                    <i class="fa-solid fa-cart-xmark"></i>
                    <p>Giỏ hàng của bạn đang trống.<br>Hãy khám phá các sản phẩm nội thất của chúng tôi!</p>
                    <a class="btn-continue" href="${pageContext.request.contextPath}/hienthi">
                        <i class="fa-solid fa-arrow-left"></i> Tiếp tục mua sắm
                    </a>
                </div>
            <% } else { %>

                <div class="cart-actions">
                    <form action="${pageContext.request.contextPath}/ClearCart" method="post" style="display:inline;">
                        <button type="submit" class="btn-clear">
                            <i class="fa-solid fa-trash-can"></i> Xóa tất cả
                        </button>
                    </form>
                </div>

                <div class="cart-header">
                    <span>Sản phẩm</span>
                    <span>Đơn giá</span>
                    <span>Số lượng</span>
                    <span>Thành tiền</span>
                    <span></span>
                </div>

                <% for(Map.Entry<Integer, Object[]> entry : cart.entrySet()) {
                    products p = (products) entry.getValue()[0];
                    int qty = (int) entry.getValue()[1];
                    double lineTotal = p.getPrice() * qty;
                %>
                <div class="cart-item" id="item-<%= p.getProduct_id() %>">
                    <!-- Product -->
                    <div class="item-product">
                        <div class="item-img">
                            <img src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg" %>"
                                 alt="<%= p.getProduct_name() %>"
                                 onerror="this.src='https://placehold.co/80x80/f0f3ea/6b7c4a?text=SP'">
                        </div>
                        <div class="item-meta">
                            <div class="item-name"><%= p.getProduct_name() %></div>
                            <div class="item-cat"><i class="fa-solid fa-tag" style="font-size:10px;"></i> <%= p.getCategoryName() %></div>
                        </div>
                    </div>

                    <!-- Price -->
                    <div class="item-price"><%= currencyFormat.format(p.getPrice()) %></div>

                    <!-- Qty -->
                    <div class="cart-qty">
                        <button type="button" onclick="updateCartQty(<%= p.getProduct_id() %>, -1)">−</button>
                        <input type="number" value="<%= qty %>" min="1" max="99" id="qty-<%= p.getProduct_id() %>"
                               onchange="setCartQty(<%= p.getProduct_id() %>, this.value)">
                        <button type="button" onclick="updateCartQty(<%= p.getProduct_id() %>, 1)">+</button>
                    </div>

                    <!-- Line Total -->
                    <div class="item-total" id="total-<%= p.getProduct_id() %>"><%= currencyFormat.format(lineTotal) %></div>

                    <!-- Remove -->
                    <form action="${pageContext.request.contextPath}/RemoveFromCart" method="post">
                        <input type="hidden" name="productId" value="<%= p.getProduct_id() %>">
                        <button type="submit" class="btn-remove" title="Xóa sản phẩm">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </form>
                </div>
                <% } %>

                <div style="margin-top:16px;">
                    <a href="${pageContext.request.contextPath}/hienthi" style="display:inline-flex;align-items:center;gap:8px;color:var(--olive);font-family:'Montserrat',sans-serif;font-size:13px;font-weight:600;text-decoration:none;">
                        <i class="fa-solid fa-arrow-left"></i> Tiếp tục mua sắm
                    </a>
                </div>

            <% } %>
        </div>

        <!-- RIGHT: Summary -->
        <div class="summary-col">
            <div class="order-summary">
                <div class="summary-header">
                    <i class="fa-solid fa-receipt"></i> Tóm tắt đơn hàng
                </div>

                <div class="summary-body">
                    <div class="summary-row">
                        <span>Tạm tính (<%= cart.size() %> sản phẩm)</span>
                        <span id="subtotal-display"><%= currencyFormat.format(subtotal) %></span>
                    </div>
                    <div class="summary-row">
                        <span>Phí vận chuyển</span>
                        <% if(shipping == 0) { %>
                            <span style="color:var(--olive);"><i class="fa-solid fa-check"></i> Miễn phí</span>
                        <% } else { %>
                            <span><%= currencyFormat.format(shipping) %></span>
                        <% } %>
                    </div>
                    <div class="summary-row">
                        <span>Giảm giá</span>
                        <span style="color:#ef4444;">-0đ</span>
                    </div>
                    <% if(shipping > 0) { %>
                        <div class="shipping-note">
                            <i class="fa-solid fa-truck"></i>
                            Mua thêm <strong><%= currencyFormat.format(500000 - subtotal) %></strong> để được miễn phí vận chuyển!
                        </div>
                    <% } else { %>
                        <div class="shipping-note">
                            <i class="fa-solid fa-circle-check"></i> Bạn được miễn phí vận chuyển!
                        </div>
                    <% } %>
                    <div class="summary-divider"></div>
                    <div class="summary-total">
                        <span>Tổng cộng</span>
                        <span id="total-display"><%= currencyFormat.format(total) %></span>
                    </div>
                </div>

                <!-- Coupon -->
                <div class="coupon-section">
                    <div class="coupon-label"><i class="fa-solid fa-ticket"></i> Mã giảm giá</div>
                    <div class="coupon-row">
                        <input type="text" id="couponInput" placeholder="Nhập mã giảm giá...">
                        <button class="btn-coupon" onclick="applyCoupon()">Áp dụng</button>
                    </div>
                </div>

                <!-- Checkout -->
                <div class="checkout-section">
                    <% if(!cart.isEmpty()) { %>
                        <form action="${pageContext.request.contextPath}/checkout.jsp" method="post">
                            <button type="submit" class="btn-checkout">
                                <i class="fa-solid fa-shield-halved"></i>
                                Đặt hàng ngay
                            </button>
                        </form>
                    <% } else { %>
                        <button class="btn-checkout" disabled style="opacity:.5;cursor:not-allowed;">
                            <i class="fa-solid fa-cart-xmark"></i> Giỏ hàng trống
                        </button>
                    <% } %>
                    <div class="secure-note">
                        <i class="fa-solid fa-lock"></i> Thanh toán được mã hóa & bảo mật
                    </div>
                </div>

                <div class="payment-row">
                    <span>Hỗ trợ:</span>
                    <span class="pay-badge">VISA</span>
                    <span class="pay-badge">MOMO</span>
                    <span class="pay-badge">COD</span>
                    <span class="pay-badge">ATM</span>
                </div>
            </div>
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

 <!-- ================= MODAL LOGIN ================= -->

        <div id="loginModal" class="modal">
            <div class="modal-box">
                <span class="close" onclick="closeModal('loginModal')" style="color: #333">&times;</span>

                <h2>Đăng nhập</h2>
                
                <form action="login" method="post" >
                    <input type="text" name="username" placeholder="Tên đăng nhập"
                           value="<%= loginUsername != null ? loginUsername : "" %>" required>
                    <input type="password" name="password" placeholder="Mật khẩu" required>
                    <button type="submit" name="action" value="login" class="btn-submit">Đăng nhập</button>
                </form>

                <% if (loginError != null) { %>
                <div style="
                    background: #fff3f3;
                    border: 1px solid #f5c6cb;
                    color: #c0392b;
                    padding: 10px 14px;
                    border-radius: 8px;
                    font-size: 14px;
                    margin-top: 12px;
                    margin-bottom: 12px;
                    font-family: Montserrat, sans-serif;
                ">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:6px;"></i><%= loginError %>
                </div>
                <% } %>
                
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
                   value="<%= regUsername != null ? regUsername : "" %>" required>
            <input type="email" name="email" placeholder="Email"
                   value="<%= regEmail != null ? regEmail : "" %>" required>
            <input type="tel" name="phone" placeholder="Số điện thoại"
                   value="<%= regPhone != null ? regPhone : "" %>">

            <input type="password" name="password" placeholder="Mật khẩu" required>
            <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
            <button type="submit" name="action" value="register" class="btn-submit">Đăng ký</button>
        </form>

                <% if (registerError != null) { %>
                <div style="
                    background: #fff3f3;
                    border: 1px solid #f5c6cb;
                    color: #c0392b;
                    padding: 10px 14px;
                    border-radius: 8px;
                    font-size: 14px;
                    margin-top: 12px;
                    margin-bottom: 12px;
                    font-family: Montserrat, sans-serif;
                ">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:6px;"></i><%= registerError %>
                </div>
                <% } %>
        
                <p style="color: #333" >Đã có tài khoản?
                    <a href="#" onclick="switchModal('registerModal', 'loginModal')" style="color: #333">Đăng nhập</a>
                </p>
            </div>
        </div>


                    
                    
<div class="toast" id="toast">
    <i class="fa-solid fa-circle-check"></i>
    <span id="toast-msg">Đã cập nhật giỏ hàng!</span>
</div>

<script>
    // ===== QUẢN LÝ MODAL =====
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
            
function updateCartQty(productId, delta) {
    const input = document.getElementById('qty-' + productId);
    let val = parseInt(input.value) + delta;
    if (val < 1) val = 1;
    if (val > 99) val = 99;
    input.value = val;
    setCartQty(productId, val);
}

function setCartQty(productId, qty) {
    qty = Math.max(1, Math.min(99, parseInt(qty)));
    fetch('${pageContext.request.contextPath}/UpdateCart?productId=' + productId + '&qty=' + qty, { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            document.getElementById('cartCount').textContent = data.cartCount;
            showToast('Đã cập nhật số lượng!');
            // Reload để cập nhật tổng tiền
            setTimeout(() => location.reload(), 800);
        })
        .catch(() => {
            showToast('Đã cập nhật!');
            setTimeout(() => location.reload(), 800);
        });
}

function applyCoupon() {
    const code = document.getElementById('couponInput').value.trim().toUpperCase();
    const validCodes = { 'GIAM10': 10, 'DECOR20': 20, 'NHOM3': 15 };
    if (validCodes[code]) {
        showToast('Áp dụng mã ' + code + ' - giảm ' + validCodes[code] + '% thành công!');
    } else if (code === '') {
        showToast('Vui lòng nhập mã giảm giá!');
    } else {
        showToast('Mã giảm giá không hợp lệ!');
    }
}

function showToast(msg) {
    const t = document.getElementById('toast');
    document.getElementById('toast-msg').textContent = msg;
    t.classList.add('show');
    setTimeout(() => t.classList.remove('show'), 2800);
}
</script>
</body>
</html>
