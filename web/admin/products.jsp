<%-- 
    Document   : products
    Created on : Apr 25, 2026, 12:13:08 AM
    Author     : Admin
--%>


<%@ page import="java.text.NumberFormat, java.util.Locale, Model.products, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<products> list = (List<products>) request.getAttribute("productList");
    List<String> categories = (List<String>) request.getAttribute("categories"); // cần truyền từ servlet
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
    <body>

<%
    String msg = request.getParameter("msg");
%>

<div id="toast" class="toast">
    <i class="fa-solid fa-circle-check"></i>
    <span id="toast-msg"></span>
</div>

<style>
.toast {
    position: fixed;
    top: 20px;
    right: 20px;
    background: #4e5c34;
    color: white;
    padding: 12px 18px;
    border-radius: 8px;
    opacity: 0;
    transform: translateY(-20px);
    transition: 0.4s;
    z-index: 9999;
}
.toast.show {
    opacity: 1;
    transform: translateY(0);
}
</style>

        <div class="admin-wrapper">
            <jsp:include page="sidebar.jsp"/>
            <div class="admin-content">
                <div style="display:flex; justify-content:space-between; margin-bottom: 20px">
                    <h1><i class="fas fa-box"></i> Quản lý sản phẩm</h1>
                    <a href="?action=add" class="btn btn-primary">Thêm sản phẩm</a>
                </div>
                <!-- Bộ lọc -->
                <div class="filter-bar">
                    <form method="get" action="${pageContext.request.contextPath}/AdminProductServlet" style="display: flex; gap: 10px; flex-wrap: wrap;">
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
                    <thead><tr><th>ID</th><th>Tên</th><th>Giá</th><th>Danh mục</th><th>Ảnh</th><th>Thao tác</th></tr></thead>
                    <tbody>
                        <% if (list == null || list.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align:center; padding: 40px; color: #999;">
                                    <i class="fas fa-box-open" style="font-size: 2rem; margin-bottom: 10px; display:block;"></i>
                                    Không tìm thấy sản phẩm nào phù hợp.
                                </td>
                            </tr>
                        <% } else { %>
                            <% for(products p : list) { %>
                            <tr>
                                <td><%= p.getProduct_id() %></td>
                                <td><%= p.getProduct_name() %></td>
                                <td><%= fmt.format(p.getPrice()) %></td>
                                <td><%= p.getCategoryName() %></td>
                                <td><img src="${pageContext.request.contextPath}/images/<%= p.getImage() != null ? p.getImage() : "default.jpg" %>" 
                                         style="width:180px; height:100px; object-fit:cover; display:block; border-radius:8px;"></td>
                                <td>
                                    <a href="?action=edit&id=<%= p.getProduct_id() %>" class="btn btn-warning btn-sm">Sửa</a>
                                    <a href="?action=delete&id=<%= p.getProduct_id() %>" class="btn btn-danger btn-sm" 
                                       onclick="return confirm('Xóa?')">Xóa</a>
                                </td>
                            </tr>
                            <% } %>
                        <% } %>
                        </tbody>
                </table>
            </div>
        </div>
    </body>
    
    
    <script>
        const msg = "<%= msg %>";
        if (msg && msg !== "null") {
            const toast = document.getElementById("toast");

            let text = "";
            if (msg === "updated") text = "✅ Cập nhật thành công";
            if (msg === "deleted") text = "✅️ Xóa thành công";
            if (msg === "add") text = "✅ Thêm thành công";
            toast.innerText = text;
            toast.classList.add("show");

            setTimeout(() => {
                toast.classList.remove("show");
            }, 3000);
        }

    </script>
</html>