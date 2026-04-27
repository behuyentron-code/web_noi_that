<%-- 
    Document   : categories
    Created on : Apr 25, 2026, 2:05:14 AM
    Author     : Admin
--%>



<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.*"%>
<%
    List<Map<String,Object>> users = (List<Map<String,Object>>) request.getAttribute("users");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
    String keyword = request.getAttribute("keyword") != null ? (String) request.getAttribute("keyword") : "";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý người dùng</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <style>
            .filter-bar { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; align-items: center; }
            .filter-bar input { padding: 8px 12px; border-radius: 8px; border: 1px solid #ddd; }
            .filter-bar button { background: #4e5c34; color: white; border: none; padding: 8px 16px; border-radius: 8px; cursor: pointer; }
            .btn-sm { padding: 4px 10px; font-size: 12px; }
            .contact-link { color: #4e5c34; font-weight: bold; text-decoration: none; }
            .contact-link:hover { text-decoration: underline; }
        </style>
    </head>
    
    <body>
           <%
    String msg = request.getParameter("msg");
%>

<div id="toast" class="toast"></div>

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
                    <h1><i class="fas fa-users"></i> Quản lý người dùng</h1>

                </div>
                <div class="filter-bar">
                    <form method="get" style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <input type="text" name="keyword" placeholder="Tìm theo tên, email, số điện thoại" value="<%= keyword %>">
                        <button type="submit"><i class="fas fa-search"></i> Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/users?page=1" class="btn-secondary">Tất cả</a>
                    </form>
                </div>
                <table class="data-table">
                    <thead>
                        <tr><th>ID</th><th>Tên đăng nhập</th><th>Email</th><th>Điện thoại</th><th>Số liên hệ</th><th>Thao tác</th></tr>
                    </thead>
                    <tbody>
                    <% if (users == null || users.isEmpty()) { %>
                        <tr><td colspan="6">Không có người dùng nào</td></tr>
                    <% } else {
                        for (Map<String,Object> u : users) { %>
                        <tr>
                            <td><%= u.get("user_id") %></td>
                            <td><%= u.get("username") %></td>
                            <td><%= u.get("email") != null ? u.get("email") : "" %></td>
                            <td><%= u.get("phone") != null ? u.get("phone") : "" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/AdminContactServlet?email=<%= u.get("email") %>" class="contact-link">
                                    <%= u.get("contactCount") %> tin nhắn
                                </a>
                            </td>
                            <td>
                                <a href="?action=edit&id=<%= u.get("user_id") %>" class="btn btn-warning btn-sm">Sửa</a>
                                <a href="?action=delete&id=<%= u.get("user_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Xóa người dùng này?')">Xóa</a>
                            </td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                        <a href="?page=<%= currentPage-1 %>&keyword=<%= keyword %>">« Trước</a>
                    <% }
                    for (int i = 1; i <= totalPages; i++) { %>
                        <a href="?page=<%= i %>&keyword=<%= keyword %>" class="<%= i==currentPage?"active":"" %>"><%= i %></a>
                    <% }
                    if (currentPage < totalPages) { %>
                        <a href="?page=<%= currentPage+1 %>&keyword=<%= keyword %>">Sau »</a>
                    <% } %>
                </div>
                <% } %>
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

        toast.innerText = text;
        toast.classList.add("show");

        setTimeout(() => {
            toast.classList.remove("show");
        }, 3000);
    }
    
</script>
</html>