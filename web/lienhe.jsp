<%-- 
    Document   : lienhe
    Created on : 12 thg 4, 2026, 20:30:54
    Author     : TRANG ANH LAPTOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>liên hệ </title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        
        <link rel="stylesheet" href="css\lienhe.css">
        <link rel="stylesheet" href="css\style.css">

        <style>
                .quick-btn {
                    background: #f0f4e8; border: 1.5px solid #c8d5a8;
                    color: #4e5c34; border-radius: 20px;
                    padding: 4px 10px; font-size: 12px; cursor: pointer;
                    transition: background .2s;
                }
                .quick-btn:hover { background: #dce8c0; }
                
                @keyframes bounce {
                    0%,80%, 100% { transform: scale(0.6); opacity:.5; }
                    40%            { transform: scale(1.0); opacity:1; }
                }
                
                #chatMessages::-webkit-scrollbar { width: 4px; }
                #chatMessages::-webkit-scrollbar-thumb { background:#ccc; border-radius:4px; }
        </style>
    </head>
    
     <!-- ================= MODAL LOGIN ================= -->
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
                        <a href="#" class="btn-pill solid" onclick="openRegister()">Đăng ký</a>
                    <% } %>
                </div>
            </div>
        </nav>

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
                <% }%>

                <p style="color: #333" >Đã có tài khoản?
                    <a href="#" onclick="switchModal('registerModal', 'loginModal')" style="color: #333">Đăng nhập</a>
                </p>
            </div>
        </div>   
    

<!-- Layout chính -->
<div class="container">

    <!-- LEFT MENU -->
<%
    // Lấy categories từ request trước, nếu không có thì lấy từ session
    java.util.List<String> categories = (java.util.List<String>) request.getAttribute("categories");
    if (categories == null || categories.isEmpty()) {
        categories = (java.util.List<String>) session.getAttribute("categories");
    }
%>

<!-- LEFT MENU -->
    <aside class="left-menu">
        <h3>DANH MỤC</h3>
        <ul>
            <li onclick="location.href = '${pageContext.request.contextPath}/hienthi'">Tất Cả</li>
            <% 
                if (categories != null && !categories.isEmpty()) {
                    for (String cat : categories) {
            %>
                <li onclick="location.href = '${pageContext.request.contextPath}/hienthi?category=<%= cat %>'"><%= cat %></li>
            <% 
                    }
                } else {
            %>
                <li>Không có danh mục</li>
            <% } %>
        </ul>
    </aside>
    
    <!-- CONTENT -->
   <div class="content">

    <!-- 2 BOX -->
    <div class="contact-box-wrapper">

        <div class="contact-box">
            <div class="icon">💬</div>
            <h3>Nói chuyện với người bán hàng</h3>
            <p>Hãy liên hệ với chúng tôi qua số điện thoại</p>
            <button class="btn">01202340234</button>
        </div>

        <div class="contact-box">
            <div class="icon">💬</div>
            <h3>Liên hệ để được hỗ trợ</h3>
            <p id="support-text">Chúng tôi luôn sẵn sàng giúp bạn</p>
            <button class="btn " onclick="showPhone()">CONTACT SUPPORT</button>
        </div>

    </div>

    <!-- FORM -->
    <div class="form-box">
        <h2>Ask a question</h2>

        <form action="ContactServlet" method="post">
            <input type="text" name="name" placeholder="Họ và tên *">
            <input type="email" name="email" placeholder="Email">
            <input type="text" name="phone" placeholder="Số điện thoại">
           
            <textarea name="message" placeholder="Nội dung"></textarea>
            <button class="btn" type="submit" style="background-color:#4e5c34; 
                    color:#fff;
                    padding:10px;
                    font-weight: bold;
                    font-size: 15px;
                    margin-top:25px;"
                    >GỬI</button>
            
        </form>
    </div>

</div>
</div>

<!-- Footer -->
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
            function showPhone() {
                let text = document.getElementById("support-text");

                if (text.innerText === "We’re here for you") {
                    text.innerText = "Hotline: 01202340234";
                } else {
                    text.innerText = "We’re here for you";
                }
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
