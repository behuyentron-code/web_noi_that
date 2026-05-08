<%@page import="java.util.List"%>
<%@page import="Model.products"%>
<%@page import="DAO.products_DAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="javax.servlet.http.HttpSession"%>
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
    }
    
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nội Thất Hiện Đại - Sản Phẩm</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=keyboard_double_arrow_up" />
    

</head>
<body>

<!--<header class="banner">DECOR LUXURY - NÂNG TẦM KHÔNG GIAN SỐNG</header>-->


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
                            <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="admin-link">
                                <i class="fa-solid fa-user-tie"></i> Quản trị
                            </a>
                        <% } else { %>
                            <%-- Chỉ hiện icon account cho User--%>
                            <div class="icon-btn" style="cursor: default;">
                                <a  href="ProfileServlet">
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



<div class="container">
    <aside class="left-menu new-sidebar">
        <h3>DANH MỤC</h3>
        <ul>
            <li onclick="location.href='${pageContext.request.contextPath}/hienthi'">Tất Cả</li>
            <%
                List<String> categories = (List<String>) request.getAttribute("categories");
                if (categories != null && !categories.isEmpty()) {
                    for (String cat : categories) {
            %>
            <li onclick="location.href='${pageContext.request.contextPath}/hienthi?category=<%= cat %>'"><%= cat %></li>
            <%
                    }
                } else {
            %>
            <li>Không có danh mục</li>
            <%
                }
            %>
        </ul>
    </aside>

    <main class="content">
        <div class="content-header">
            <h2 class="section-title">
                <%
                    String selectedCategory = (String) request.getAttribute("selectedCategory");
                    if (selectedCategory != null && !selectedCategory.isEmpty()) {
                        out.print(selectedCategory);
                    } else {
                        out.print("Tất cả sản phẩm");
                    }
                %>
            </h2>
        </div>
        <div class="product-grid" id="productGrid">
            <%
                java.util.List<products> productList = (java.util.List<products>) request.getAttribute("products");
                NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

                if (productList == null || productList.isEmpty()) {
            %>
            <p class="empty-state">Không có sản phẩm nào trong danh mục này.</p>
            <%
                } else {
                    for (products p : productList) {
                        String formattedPrice = currencyFormat.format(p.getPrice());
            %>
            <div class="product-card">
                <div class="product-img">
                    <img src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg"%>"
                         alt="<%= p.getProduct_name()%>"
                         onerror="this.src='https://placehold.co/500x300?text=Nội+Thất'">

                    <%-- Hiển thị badge nếu có khuyến mãi --%>
                    <% if (p.getDiscount_price() > 0) { %>
                        <span class="product-badge">-<%= p.getDiscount_price() %>%</span>
                    <% } %>
                </div>

                <div class="product-info">
                    <h4 class="product-name"><%= p.getProduct_name()%></h4>

                    <div class="product-price" style="display:flex; justify-content:flex-end; align-items:baseline; gap:8px;">
                        <span style="font-size:17px; font-weight:700; color:<%= p.getDiscount_price() > 0 ? "red" : "#4e5c34" %>;">
                            <%= formattedPrice %>
                        </span>
                        <%-- Hiển thị giá gốc bị gạch nếu có khuyến mãi --%>
                        <% if (p.getDiscount_price() > 0) {
                            double origPrice = p.getPrice() * 100.0 / (100.0 - p.getDiscount_price());
                            String formattedOrig = currencyFormat.format(Math.round(origPrice / 1000) * 1000);
                        %>
                        <span style="font-size:12px; color:#d1d5db; text-decoration:line-through;">
                            <%= formattedOrig %>
                        </span>
                        <% } %>
                    </div>

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
            <%
                    }
                }
            %>
        </div>
    </main>
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

<!-- Chat & Toast -->
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

<div id="toast" class="toast"><i class="fa-solid fa-circle-check"></i><span id="toast-msg"></span></div>

<!-- MODAL LOGIN / REGISTER -->
<div id="loginModal" class="modal">
    <div class="modal-box">
        <span class="close" onclick="closeModal('loginModal')">&times;</span>
        <h2>Đăng nhập</h2>
        <form action="login" method="post">
            <input type="text" name="username" placeholder="Tên đăng nhập" value="<%= loginUsername != null ? loginUsername : "" %>" required>
            <input type="password" name="password" placeholder="Mật khẩu" required>
            <button type="submit" name="action" value="login" class="btn-submit">Đăng nhập</button>
        </form>
        <% if (loginError != null) { %>
            <div class="error-message"><i class="fa-solid fa-circle-exclamation"></i> <%= loginError %></div>
        <% } %>
        <p>Chưa có tài khoản? <a href="#" onclick="switchModal('loginModal', 'registerModal')">Đăng ký</a></p>
    </div>
</div>

<div id="registerModal" class="modal">
    <div class="modal-box">
        <span class="close" onclick="closeModal('registerModal')">&times;</span>
        <h2>Đăng ký</h2>
        <form action="login" method="post">
            <input type="text" name="username" placeholder="Tên đăng nhập" value="<%= regUsername != null ? regUsername : "" %>" required>
            <input type="email" name="email" placeholder="Email" value="<%= regEmail != null ? regEmail : "" %>" required>
            <input type="tel" name="phone" placeholder="Số điện thoại" value="<%= regPhone != null ? regPhone : "" %>"required>
            <input type="add" name="address" placeholder="Địa chỉ" value="<%= regAddress != null ? regAddress : "" %>" required>
            
            <input type="password" name="password" placeholder="Mật khẩu" required>
            <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
            <button type="submit" name="action" value="register" class="btn-submit">Đăng ký</button>
        </form>
        <% if (registerError != null) { %>
            <div class="error-message"><i class="fa-solid fa-circle-exclamation"></i> <%= registerError %></div>
        <% } %>
        <p>Đã có tài khoản? <a href="#" onclick="switchModal('registerModal', 'loginModal')">Đăng nhập</a></p>
    </div>
</div>

        <button class="scroll-top" id="scrollTopBtn" onclick="window.scrollTo({top:0, behavior:'smooth'})">
            <i  class="material-symbols-outlined">keyboard_double_arrow_up</i>
        </button>

    <script>
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

        function addToCart(productId, productName) {
            fetch('<%=request.getContextPath()%>/AddToCart?productId=' + productId + '&qty=1', {
                method: 'GET'
            })
            .then(res => {
                if (res.ok) {
                    const badge = document.querySelector('.badge');
                    if (badge) badge.textContent = parseInt(badge.textContent || 0) + 1;
                    showToast('Đã thêm "' + productName + '" vào giỏ hàng!', false);
                } else {
                    showToast('Không thể thêm vào giỏ, vui lòng thử lại!', true);
                }
            })
            .catch(() => showToast('Không thể thêm vào giỏ, vui lòng thử lại!', true));
        }

        // ===== MODAL =====
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get("openModal") === "login") openLogin();
        if (urlParams.get("openModal") === "register") openRegister();

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
    
    
    const scrollTopBtn = document.getElementById('scrollTopBtn');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            scrollTopBtn.classList.add('show');
        } else {
            scrollTopBtn.classList.remove('show');
        }
    });
    
    </script>
    
    </body>
</html>