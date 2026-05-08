<%-- 
    Document   : products
    Created on : Apr 25, 2026, 12:13:08 AM
    Author     : Admin
--%>

<%@ page import="java.text.NumberFormat, java.util.Locale, Model.products, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<products> list = (List<products>) request.getAttribute("productList");
    List<String> categories = (List<String>) request.getAttribute("categories");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

    String keyword = (String) request.getAttribute("keyword");
    String catFilter = (String) request.getAttribute("catFilter");
    if (keyword == null) keyword = "";
    if (catFilter == null) catFilter = "";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=keyboard_double_arrow_up" />

    <style>
        .toast {
            position: fixed; 
            top: 20px; right: 20px;
            background: #4e5c34; 
            color: white;
            padding: 12px 18px; 
            border-radius: 8px;
            opacity: 0; 
            transform: translateY(-20px);
            transition: 0.4s;
            z-index: 9999;
            display: flex; 
            align-items: center; 
            gap: 8px;
        }
        .toast.show { 
            opacity: 1; 
            transform: translateY(0);
        }

        /* Stock badge */
        .stock-badge {
            display: inline-flex; 
            align-items: center; 
            gap: 5px;
            padding: 4px 10px; 
            border-radius: 20px;
            font-size: 12px; 
            font-weight: 700;
        }
        .stock-ok   {
            background: #e8f5e9; color: #2e7d32;
        }
        .stock-low  { 
            background: #fff3e0; color: #e65100; 
        }
        .stock-out  { 
            background: #fce4ec; color: #c62828;
        }
    </style>
    
</head>
<body>

<%
    String msg = request.getParameter("msg");
%>

<div id="toast" class="toast">
    <i class="fa-solid fa-circle-check"></i><span id="toast-msg"></span>
</div>

<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">
        <div style="display:flex; justify-content:space-between; margin-bottom:20px;">
            <h1><i class="fas fa-box"></i> Quản lý sản phẩm</h1>
            <a href="?action=add" class="btn btn-primary">+ Thêm sản phẩm</a>
        </div>

        <!-- Bộ lọc -->
        <div class="filter-bar">
            <form method="get" action="${pageContext.request.contextPath}/AdminProductServlet"
                  style="display:flex; gap:10px; flex-wrap:wrap;">
                <input type="text" name="keyword" placeholder="Tìm theo tên sản phẩm" value="<%= keyword %>">
                <select name="category">
                    <option value="">Tất cả danh mục</option>
                    <% for (String c : categories) { %>
                        <option value="<%= c %>" <%= c.equals(catFilter) ? "selected" : "" %>><%= c %></option>
                    <% } %>
                </select>
                <button type="submit"><i class="fas fa-search"></i> Lọc</button>
                <a href="${pageContext.request.contextPath}/AdminProductServlet" class="btn-secondary">Tất cả</a>
            </form>
        </div>

        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Giảm giá</th>
                    <th>Tồn kho</th>
                    <th>Danh mục</th>
                    <th>Ảnh</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <% if (list == null || list.isEmpty()) { %>
                    <tr>
                        <td colspan="8" style="text-align:center; padding:40px; color:#999;">
                            <i class="fas fa-box-open" style="font-size:2rem; margin-bottom:10px; display:block;"></i>
                            Không tìm thấy sản phẩm nào phù hợp.
                        </td>
                    </tr>
                <% } else {
                    for (products p : list) {
                        int qty = p.getQuantity();
                        String badgeClass = qty == 0 ? "stock-out" : qty <= 5 ? "stock-low" : "stock-ok";
                        String badgeIcon  = qty == 0 ? "fa-circle-xmark" : qty <= 5 ? "fa-triangle-exclamation" : "fa-circle-check";
                        String badgeText  = qty == 0 ? "Hết hàng" : qty <= 5 ? "Sắp hết (" + qty + ")" : qty + " cái";
                %>
                <tr>
                    <td><%= p.getProduct_id() %></td>
                    <td><%= p.getProduct_name() %></td>
                    <td><%= fmt.format(p.getPrice()) %></td>
                    <td>
                        <% if (p.getDiscount_price() > 0) { %>
                            <span style="background:#fff0e0;color:#c4620a;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:700;">
                                -<%= p.getDiscount_price() %>%
                            </span>
                        <% } else { %>
                            <span style="color:#9ca3af;font-size:12px;">Không</span>
                        <% } %>
                    </td>
                    <td>
                        <span class="stock-badge <%= badgeClass %>">
                            <i class="fa-solid <%= badgeIcon %>"></i> <%= badgeText %>
                        </span>
                    </td>
                    <td><%= p.getCategoryName() %></td>
                    <td>
                        <img src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg" %>"
                             style="width:220px; height:175px; object-fit:cover; border-radius:8px;">
                    </td>
                    <td>
                        <a href="?action=edit&id=<%= p.getProduct_id() %>" class="btn btn-warning btn-sm">
                            Sửa
                        </a>
                        <a href="?action=delete&id=<%= p.getProduct_id() %>" class="btn btn-danger btn-sm"
                           onclick="return confirm('Xóa sản phẩm này?')">
                                Xóa
                        </a>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </div>

</div>
            
    <button class="scroll-top" id="scrollTopBtn" onclick="window.scrollTo({top:0, behavior:'smooth'})">
        <i  class="material-symbols-outlined">keyboard_double_arrow_up</i>
    </button>
<script>
    const msg = "<%= msg %>";
    if (msg && msg !== "null") {
        const toast = document.getElementById("toast");
        const toastMsg = document.getElementById("toast-msg");
        let text = "";
        if (msg === "updated") text = "Cập nhật thành công";
        if (msg === "deleted") text = "Xóa thành công";
        if (msg === "add")     text = "Thêm thành công";
        toastMsg.textContent = text;
        toast.classList.add("show");
        setTimeout(() => toast.classList.remove("show"), 3000);
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
