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
        <!-- Banner -->
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
                
        <a href="khuyen_mai.jsp">Khuyến Mãi</a> 
        <a href="${pageContext.request.contextPath}/ContactServlet">Liên hệ</a> 
    </div>
    
    <div class="auth-buttons">
        <a href="cart.jsp" class="cart-btn">
            <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
            <span class="cart-count" id="cartCount">
                <%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %>
            </span>
        </a>
        <% if(user != null){ %>
            <span style="margin-left:10px;font-family:'Montserrat',sans-serif;font-weight:600;">Xin chào, <%= user %></span>
            <a href="logout.jsp" class="btn-login">Đăng xuất</a>
        <% } else { %>
            <a href="#" class="btn-login" onclick="openLogin()">Đăng Nhập</a>
            <a href="#" class="btn-register" onclick="openRegister()">Đăng Ký</a>
        <% } %>
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
             position: fixed; bottom: auto; left: 100px;top: 100px; z-index: 9997;
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
                <span onclick="minimize()" style="margin-left:auto; cursor:pointer; font-size:18px; opacity:.8;">➖</span>
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

             
             <!-- Typing indicator (ẩn mặc định) -->
    <div id="typingIndicator" style="
        padding: 0 14px 6px; display:none; align-items:center; gap:6px;
        font-size:12px; color:#888;">
        <span style="
            display:inline-flex; gap:3px; align-items:center;">
            <span class="dot" style="width:6px;height:6px;border-radius:50%;background:#aaa;
                animation:bounce .9s infinite ease-in-out;"></span>
            <span class="dot" style="width:6px;height:6px;border-radius:50%;background:#aaa;
                animation:bounce .9s .2s infinite ease-in-out;"></span>
            <span class="dot" style="width:6px;height:6px;border-radius:50%;background:#aaa;
                animation:bounce .9s .4s infinite ease-in-out;"></span>
        </span>
        <span>Đang soạn tin...</span>
    </div>

    <!-- Quick replies -->
    <div id="quickReplies" style="padding:6px 14px; display:flex; gap:6px; flex-wrap:wrap;">
        <button onclick="quickSend('Sofa phòng khách')" class="quick-btn">🛋️ Sofa</button>
        <button onclick="quickSend('Giường ngủ')" class="quick-btn">🛏️ Giường</button>
        <button onclick="quickSend('Bàn làm việc')" class="quick-btn">🖥️ Bàn làm việc</button>
        <button onclick="quickSend('Sản phẩm rẻ nhất')" class="quick-btn">💰 Giá rẻ</button>
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
            // Ẩn quick replies sau khi đã chat
            if (document.getElementById("chatMessages").children.length > 3) {
                document.getElementById("quickReplies").style.display = 'none';
            }
        }
    }
     let isSending = false;
    
    function minimize(){
        const chat = document.getElementById("chatSidebar");
        const isOpen = chat.style.opacity === '1';
        if (isOpen) {
            chat.style.opacity = '0';
            chat.style.transform = 'translateY(30px) scale(.95)';
            chat.style.pointerEvents = 'none';
        }else{
           chat.style.opacity = '1';
            chat.style.transform = 'translateY(0) scale(1)';
            chat.style.pointerEvents = 'all';
            document.getElementById("chatInput").focus(); 
            if (document.getElementById("chatMessages").children.length > 3) {
                document.getElementById("quickReplies").style.display = 'none';
            }
        }
    }
        

   

    // ── Gửi tin nhắn quick reply ──
    function quickSend(text) {
        document.getElementById("chatInput").value = text;
        document.getElementById("quickReplies").style.display = 'none';
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

        fetch("<%=request.getContextPath()%>/ChatBot", {
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
    (function makeDraggable() {
    const chat = document.getElementById("chatSidebar");
    const header = chat.firstElementChild; // header

    let isDragging = false;
    let offsetX = 0, offsetY = 0;

    header.style.cursor = "move";

    header.addEventListener("mousedown", function (e) {
        isDragging = true;
        offsetX = e.clientX - chat.offsetLeft;
        offsetY = e.clientY - chat.offsetTop;
    });

    document.addEventListener("mousemove", function (e) {
        if (!isDragging) return;

        chat.style.left = (e.clientX - offsetX) + "px";
        chat.style.top  = (e.clientY - offsetY) + "px";

        chat.style.bottom = "auto"; // bỏ fixed bottom
    });

    document.addEventListener("mouseup", function () {
        isDragging = false;
    });
})();
        </script>
    </body>
</html>
