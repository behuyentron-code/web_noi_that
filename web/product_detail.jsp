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
            <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/chitietsp.css">
    </head>
    
    <body>
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
                        <a href="#" class="btn-pill solid" onclick="openRegister()">Đăng ký</a>
                    <% } %>
                </div>
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
                    <span class="detail-badge badge-green"><i class="fa-solid fa-shield-halved"></i> Bảo hành 12 tháng</span>
                    <span class="detail-badge badge-blue"><i class="fa-solid fa-truck"></i> Miễn phí vận chuyển</span>
                    <span class="detail-badge badge-olive"><i class="fa-solid fa-rotate-left"></i> Đổi trả 7 ngày</span>
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
                <p class="product-desc"><%= p.getDescription() != null ? p.getDescription() : "Không có mô tả"%></p>
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

       <!-- CHATBOT -->
        <button onclick="toggleChat()" class="chat-toggle"><i class="fa-solid fa-comments"></i></button>
            <div id="chatSidebar" class="chat-sidebar">
                <div class="chat-header">Trợ lý DECOR LUXURY 
                    <span onclick="toggleChat()">➖</span>
                    <span onclick="toggleChat()">✕</span>
                </div>

                <div id="chatMessages" class="chat-messages">
                    <p><b>Bot:</b> Xin chào! 👋 Mình là trợ lý nội thất. Bạn cần tư vấn gì không?</p>
                </div>
                <div id="typingIndicator" class="typing-indicator">Đang soạn tin...</div>
                <div id="quickReplies" class="quick-replies">
                    <button onclick="quickSend('Sofa phòng khách')">🛋️ Sofa</button>
                    <button onclick="quickSend('Giường ngủ')">🛏️ Giường</button>
                    <button onclick="quickSend('Bàn làm việc')">🖥️ Bàn</button>
                    <button onclick="quickSend('Sản phẩm rẻ nhất')">💰 Giá rẻ</button>
                </div>
                <div class="chat-input">
                    <input id="chatInput" type="text" placeholder="Nhập câu hỏi..." onkeypress="if(event.key==='Enter') sendMsg()">
                    <button id="sendBtn" onclick="sendMsg()">Gửi</button>
                </div>
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

            function addToCart(productId, productName) {
                fetch('<%=request.getContextPath()%>/AddToCart?productId=' + productId + '&qty=1', {
                    method: 'GET'
                })
                .then(res => {
                    if (res.ok) {
                        // Cập nhật badge giỏ hàng
                        const badge = document.querySelector('.badge');
                        if (badge) {
                            badge.textContent = parseInt(badge.textContent || 0) + 1;
                        }
                        showToast('Đã thêm "' + productName + '" vào giỏ hàng!', false);
                    } else {
                        showToast('Không thể thêm vào giỏ, vui lòng thử lại!', true);
                    }
                })
                .catch(() => {
                    showToast('Không thể thêm vào giỏ, vui lòng thử lại!', true);
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

            function showToast(msg, isError = false) {
                const t = document.getElementById('toast');
                const icon = t.querySelector('i');

                document.getElementById('toast-msg').textContent = msg;

                if (isError) {
                    t.style.background = '#c0392b';
                    icon.className = 'fa-solid fa-circle-xmark';
                } else {
                    t.style.background = '#4e5c34';
                    icon.className = 'fa-solid fa-circle-check';
                }

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
            
            
        function toggleChat() {
            const chat = document.getElementById("chatSidebar");
            const isOpen = chat.style.opacity === '1';
            if (isOpen) {
                chat.style.opacity = '0';
                chat.style.transform = 'translateY(30px) scale(.95)';
                chat.style.pointerEvents = 'none';
           
            localStorage.removeItem("chatHistory");
            document.getElementById("chatMessages").innerHTML = `
            <p style="
                   background: #e8eddf; color: #2c2c2c;
                   padding: 10px 14px; border-radius: 12px 12px 12px 4px;
                   margin: 0; line-height: 1.5;
                   "><b>Bot:</b> Xin chào! 👋 Mình là trợ lý nội thất DECOR LUXURY. Bạn cần tư vấn gì không?</p>
    `;
            } else {
                chat.style.opacity = '1';
                chat.style.transform = 'translateY(0) scale(1)';
                chat.style.pointerEvents = 'all';
                document.getElementById("chatInput").focus();
                 document.getElementById("quickReplies").style.display = 'flex';
            }
        }
        
        function minimize(){
            const chat = document.getElementById("chatSidebar");
            const isOpen = chat.style.opacity === '1';
            if (isOpen) {
               chat.style.opacity = '0';
               chat.style.transform = 'translateY(30px) scale(.95)';
               chat.style.pointerEvents = 'none';
           } else {
               chat.style.opacity = '1';
               chat.style.transform = 'translateY(0) scale(1)';
               chat.style.pointerEvents = 'all';
               document.getElementById("chatInput").focus();
               // Ẩn quick replies sau khi đã chat
               if (document.getElementById("chatMessages").children.length > 3) {
                   document.getElementById("quickReplies").style.display = 'none';
               }
           }
        }
        let isSending = false;

        // ── Gửi tin nhắn quick reply ──
        function quickSend(text) {
            document.getElementById("chatInput").value = text;
            document.getElementById("quickReplies").style.display = 'flex';
            sendMsg();
        }

        // ── Gửi tin nhắn ──
        function sendMsg() {
            const input  = document.getElementById("chatInput");
            const btn    = document.getElementById("sendBtn");
            const msg    = input.value.trim();

            if (!msg || isSending) return;

            // Hiện tin nhắn user
            addMessage("user", msg);
            input.value = "";

            // Kiểm tra local reply trước (không cần gọi server)
            const local = localReply(msg);
            if (local) {
                addMessage("bot", local);
                return;
            }

            // Gọi server
            isSending = true;
            btn.disabled = true;
            btn.style.opacity = '.5';
            showTyping(true);

            fetch("<%=request.getContextPath()%>/ChatServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
                body: "message=" + encodeURIComponent(msg)
            })
            .then(res => {
                if (!res.ok) {
                    showTyping(false);
                    addMessage("bot", "Lỗi server: " + res.status);
                    return;
                }
                return res.text();
            })
            .then(data => {
                showTyping(false);
                if (!data || data.trim() === "") {
                    addMessage("bot", "Xin lỗi, mình chưa tìm được thông tin phù hợp.");
                } else {
                    addMessage("bot", data);
                }
            })
            .catch(() => {
                showTyping(false);
                addMessage("bot", "🌐 Lỗi kết nối Server, vui lòng thử lại!");
            })
            .finally(() => {
                setTimeout(() => {
                    isSending = false;
                    btn.disabled = false;
                    btn.style.opacity = '1';
                }, 1500);
            });
        }

            // ── Hiện/ẩn typing indicator ──
            function showTyping(show) {
                const el = document.getElementById("typingIndicator");
                el.style.display = show ? 'flex' : 'none';
                if (show) {
                    const box = document.getElementById("chatMessages");
                    box.scrollTop = box.scrollHeight;
                }
            }

            // ── Thêm tin nhắn vào khung chat ──
            function addMessage(sender, text) {
            if (!text) return;
            const box = document.getElementById("chatMessages");
            const isUser = sender === "user";
            const div = document.createElement("div");
            div.style.cssText = `
                background: ${isUser ? 'linear-gradient(135deg,#4e5c34,#6b7c4a)' : '#fff'};
                color: ${isUser ? 'white' : '#2c2c2c'};
                padding: 10px 14px;
                border-radius: ${isUser ? '12px 12px 4px 12px' : '12px 12px 12px 4px'};
                align-self: ${isUser ? 'flex-end' : 'flex-start'};
                max-width: 85%; line-height: 1.6; font-size: 14px;
                box-shadow: 0 2px 8px rgba(0,0,0,.08);
                word-break: break-word;
            `;
            // Chuyển markdown link [text](url) -> HTML <a href="url">text</a>
            let formatted = text.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank" style="color:#4e5c34;text-decoration:underline;">$1</a>');
            // Chuyển **bold** -> <b>
            formatted = formatted.replace(/\*\*(.+?)\*\*/g, '<b>$1</b>');
            // Chuyển xuống dòng
            formatted = formatted.replace(/\n/g, '<br>');
            div.innerHTML = formatted;
            box.appendChild(div);
            box.scrollTop = box.scrollHeight;
        }

            // ── Local reply (không cần gọi API) ──
            function localReply(msg) {
                msg = msg.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g,"");
                if (/xin chao|hello|hi\b|chao/.test(msg)) {
                    return "Xin chào! 👋 Bạn cần tư vấn sản phẩm gì ạ?";
                }
                if (/cam on|thanks|thank/.test(msg)) {
                    return "Không có gì! Bạn cần thêm thông tin gì cứ hỏi nhé 😊";
                }
                return null;
            }


        </script>
    
    </body>
</html>