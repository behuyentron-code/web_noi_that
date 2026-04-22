
<%@page import="Model.products"%>
<%@page import="DAO.products_DAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="jakarta.servlet.http.HttpSession"%>

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
%>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nội Thất Hiện Đại - Trang Chủ</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=account_circle" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
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
                <a href="#">Khuyến Mãi</a>
                <a href="lienhe.jsp">Liên hệ</a> 

            </div>

            <div class="auth-buttons">
                <a href="cart.jsp" class="cart-btn">
                    <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                    <span class="cart-count" id="cartCount">
                        <%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0%>
                    </span>
                </a>

                <% if (user != null) {%>
                <span class="material-symbols-rounded">account_circle</span>
                
                <a href="login?action=logout">Đăng xuất</a>
                <% } else { %>
                <a href="#" class="btn-login" onclick="openLogin()" >Đăng Nhập</a>
                <a href="#" class="btn-register" onclick="openRegister()">Đăng Ký</a>
                <% } %>

            </div>
        </nav>

        <div class="container">
            <aside class="left-menu">
                <h3>DANH MỤC</h3>
                <ul>
                    <li onclick="location.href = '${pageContext.request.contextPath}/hienthi'">Tất Cả</li>
                        <%
                            java.util.List<String> categories = (java.util.List<String>) request.getAttribute("categories");
                            if (categories != null && !categories.isEmpty()) {
                                for (String cat : categories) {
                        %>

                    <li onclick="location.href = '${pageContext.request.contextPath}/hienthi?category=<%= cat%>'"><%= cat%></li>

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
                <h2 style="margin-bottom: 20px; color: #333;">
                    <%
                        String selectedCategory = (String) request.getAttribute("selectedCategory");
                        if (selectedCategory != null && !selectedCategory.isEmpty()) {
                            out.print(selectedCategory);
                        } else {
                            out.print("Tất cả sản phẩm");
                        }
                    %>
                </h2>

                <div class="product-grid">
                    <%
                        java.util.List<products> productList = (java.util.List<products>) request.getAttribute("products");
                        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

                        if (productList == null || productList.isEmpty()) {
                    %>
                    <p style="color:#888; text-align:center; margin-top:40px;">Không có sản phẩm nào trong danh mục này.</p>
                    <%
                    } else {
                        for (products p : productList) {
                            String formattedPrice = currencyFormat.format(p.getPrice());
                    %>

                    <div class="product">
                        <img src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg"%>"
                             alt="<%= p.getProduct_name()%>"
                             onerror="this.src='https://placehold.co/500x300?text=<%= p.getProduct_name()%>'">
                        <h4><%= p.getProduct_name()%></h4>
                        <p class="product-desc"><%= p.getDescription() != null ? p.getDescription() : "Không có mô tả"%></p>
                        <p><%= formattedPrice%></p>
                        <button onclick="addToCart(<%= p.getProduct_id()%>, '<%= p.getProduct_name()%>')">
                            Thêm vào giỏ
                        </button>

                        <button onclick="location.href = '${pageContext.request.contextPath}/ProductDetail?id=<%= p.getProduct_id()%>'">Xem thêm</button>    

                    </div>

                    <%
                } %>
                </div>       
                <%
                    }
                %>

            </main>
        </div>

        <!-- ===== NÚT MỞ CHAT ===== -->
        <button onclick="toggleChat()" style="
                position: fixed; bottom: 28px; left: 28px; z-index: 9998;
                width: 56px; height: 56px; border-radius: 50%;
                background: #4e5c34; color: white; border: none;
                font-size: 22px; cursor: pointer;
                box-shadow: 0 6px 20px rgba(78,92,52,.4);
                display: flex; align-items: center; justify-content: center;
                transition: background .2s, transform .2s;
                " onmouseover="this.style.background = '#6b7c4a';this.style.transform = 'scale(1.08)'"
                onmouseout="this.style.background = '#4e5c34';this.style.transform = 'scale(1)'">
            <i class="fa-solid fa-comments"></i>
        </button>

        <!-- ===== CHATBOX SIDEBAR ===== -->
        <div id="chatSidebar" style="
             position: fixed; bottom: 96px; left: 28px; z-index: 9997;
             width: 340px; height: 480px;
             background: #fff; border-radius: 16px;
             box-shadow: 0 12px 40px rgba(0,0,0,.18);
             display: flex; flex-direction: column;
             overflow: hidden;
             transform: translateY(30px) scale(.95);
             opacity: 0; pointer-events: none;
             transition: opacity .3s, transform .3s;
             ">
            <!-- Header -->
            <div style="
                 background: #4e5c34; color: white;
                 padding: 14px 18px;
                 font-family: 'Montserrat', sans-serif;
                 font-size: 15px; font-weight: 700;
                 display: flex; align-items: center; gap: 10px;
                 ">
                <i class="fa-solid fa-robot"></i>
                Trợ lý DECOR LUXURY
                <span onclick="toggleChat()" style="margin-left:auto; cursor:pointer; font-size:18px; opacity:.8;">✕</span>
            </div>

            <!-- Messages -->
            <div id="chatMessages" style="
                 flex: 1; overflow-y: auto;
                 padding: 14px; display: flex; flex-direction: column; gap: 8px;
                 background: #f8f9fa;
                 font-family: 'Montserrat', sans-serif; font-size: 13px;
                 ">
                <p style="
                   background: #e8eddf; color: #2c2c2c;
                   padding: 10px 14px; border-radius: 12px 12px 12px 4px;
                   margin: 0; line-height: 1.5;
                   "><b>Bot:</b> Xin chào! 👋 Mình là trợ lý nội thất DECOR LUXURY. Bạn cần tư vấn gì không?</p>
            </div>

            <!-- Input -->
            <div style="
                 display: flex; gap: 8px;
                 padding: 12px; border-top: 1px solid #e2e8d8;
                 background: #fff;
                 ">
                <input id="chatInput" type="text"
                       placeholder="Nhập câu hỏi..."
                       onkeydown="if (event.key === 'Enter')
                                   sendMsg()"
                       style="
                       flex: 1; padding: 10px 14px;
                       border: 1px solid #d6ddc8; border-radius: 10px;
                       font-family: 'Montserrat', sans-serif; font-size: 13px;
                       outline: none;
                       ">
                <button onclick="sendMsg()" id="sendBtn" style="
                        padding: 10px 16px;
                        background: #4e5c34; color: white; border: none;
                        border-radius: 10px; cursor: pointer;
                        font-family: 'Montserrat', sans-serif;
                        font-size: 13px; font-weight: 700;
                        ">Gửi</button>
            </div>
        </div>

        <!-- ===== TOAST ===== -->
        <div id="toast" style="
             position: fixed; bottom: 28px; right: 28px; z-index: 9999;
             background: #4e5c34; color: white;
             padding: 14px 20px; border-radius: 12px;
             font-family: 'Montserrat', sans-serif; font-size: 14px; font-weight: 600;
             display: flex; align-items: center; gap: 10px;
             box-shadow: 0 8px 24px rgba(78,92,52,.35);
             opacity: 0; transform: translateY(20px);
             transition: opacity .35s, transform .35s;
             pointer-events: none;
             ">
            <i id="toast-icon" class="fa-solid fa-circle-check" style="font-size:18px; color:white;"></i>
            <span id="toast-msg">Đã thêm vào giỏ hàng!</span>
        </div>

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

        <!-- ================= MODAL LOGIN ================= -->
        <!--    <form action="loginServlet" method="post">

        <input type="text" name="username" placeholder="Email" required>
        <input type="password" name="password" placeholder="Mật khẩu" required>
        <button type="submit" name="action" value="login">Đăng nhập</button>
    </form>-->

        <div id="loginModal" class="modal">
            <div class="modal-box">
                <span class="close" onclick="closeModal('loginModal')" style="color: #333">&times;</span>

                <h2>Đăng nhập</h2>
                
                <form action="login" method="post">
                    <input type="text" name="username" placeholder="Tên đăng nhập"
                           value="<%= loginUsername != null ? loginUsername : "" %>" required>
                    <input type="password" name="password" placeholder="Mật khẩu" required>
                    <button type="submit" name="action" value="login">Đăng nhập</button>
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
            <button type="submit" name="action" value="register">Đăng ký</button>
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
                ">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right:6px;"></i><%= registerError %>
                </div>
                <% } %>
        
                <p style="color: #333" >Đã có tài khoản?
                    <a href="#" onclick="switchModal('registerModal', 'loginModal')" style="color: #333">Đăng nhập</a>
                </p>
            </div>
        </div>


        <script>
            function showToast(msg, isError) {
                const t = document.getElementById('toast');
                const ic = document.getElementById('toast-icon');
                const m = document.getElementById('toast-msg');
                ic.className = isError
                        ? 'fa-solid fa-circle-xmark'
                        : 'fa-solid fa-circle-check';
                ic.style.color = 'white';
                t.style.background = isError ? '#b91c1c' : '#4e5c34';
                m.textContent = msg;
                t.style.opacity = '1';
                t.style.transform = 'translateY(0)';
                clearTimeout(window._toastTimer);
                window._toastTimer = setTimeout(() => {
                    t.style.opacity = '0';
                    t.style.transform = 'translateY(20px)';
                }, 2800);
            }

            // ===== THÊM VÀO GIỎ =====
            function addToCart(productId, productName) {
                fetch('<%=request.getContextPath()%>/AddToCart?productId=' + productId + '&qty=1', {
                    method: 'GET'
                })
                        .then(res => res.json())
                        .then(data => {
                            document.getElementById('cartCount').textContent = data.cartCount;
                            showToast('Đã thêm "' + productName + '" vào giỏ hàng!', false);
                        })
                        .catch(() => {
                            showToast('Không thể thêm vào giỏ, vui lòng thử lại!', true);
                        });
            }

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

            // ===== CHATBOT =====
            function toggleChat() {
                let chat = document.getElementById("chatSidebar");
                let isOpen = chat.style.opacity === '1';
                if (isOpen) {
                    chat.style.opacity = '0';
                    chat.style.transform = 'translateY(30px) scale(.95)';
                    chat.style.pointerEvents = 'none';
                } else {
                    chat.style.opacity = '1';
                    chat.style.transform = 'translateY(0) scale(1)';
                    chat.style.pointerEvents = 'all';
                    document.getElementById("chatInput").focus();
                }
            }

            let isSending = false;

            function sendMsg() {
                let input = document.getElementById("chatInput");
                let btn = document.getElementById("sendBtn");
                let msg = input.value.trim();
                if (msg === "" || isSending)
                    return;

                addMessage("Bạn", msg);
                input.value = "";

                // Kiểm tra offline trước
                let localReply = botReply(msg);
                if (localReply) {
                    addMessage("Bot", localReply);
                    return;
                }

                isSending = true;
                btn.disabled = true;
                btn.innerText = "...";

                fetch("<%=request.getContextPath()%>/ChatServlet", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "message=" + encodeURIComponent(msg)
                })
                        .then(res => res.text())
                        .then(data => {
                            if (data.includes("429")) {
                                addMessage("Bot", "Hạn mức API đã hết, vui lòng thử lại sau 1 phút! ☕");
                            } else if (!data || data.includes("Error")) {
                                addMessage("Bot", "Xin lỗi, mình chưa tìm được thông tin phù hợp.");
                            } else {
                                addMessage("Bot", data);
                            }
                        })
                        .catch(() => addMessage("Bot", "Lỗi kết nối Server."))
                        .finally(() => {
                            setTimeout(() => {
                                isSending = false;
                                btn.disabled = false;
                                btn.innerText = "Gửi";
                            }, 3000);
                        });
            }

            function addMessage(sender, text) {
                if (!text)
                    return;
                let box = document.getElementById("chatMessages");
                let isBan = sender === "Bạn";
                box.innerHTML += `<p style="
                background:${isBan ? '#4e5c34' : '#e8eddf'};
                color:${isBan ? 'white' : '#2c2c2c'};
                padding:10px 14px;
                border-radius:${isBan ? '12px 12px 4px 12px' : '12px 12px 12px 4px'};
                margin:0; line-height:1.5;
                align-self:${isBan ? 'flex-end' : 'flex-start'};
                max-width:85%;
            "><b>${sender}:</b> ${text}</p>`;
                box.scrollTop = box.scrollHeight;
            }

            function botReply(msg) {
                msg = msg.toLowerCase();
                if (msg.includes("xin chào") || msg.includes("hello") || msg.includes("hi")) {
                    return "Xin chào 👋! Bạn muốn tìm sản phẩm nội thất gì?";
                }
                return null;
            }
        </script>