<%-- 
    Document   : categories
    Created on : Apr 25, 2026, 2:05:14 AM
    Author     : Admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%
    Map<String,Object> user = (Map<String,Object>) request.getAttribute("user");
    boolean isEdit = (user != null && !user.isEmpty());
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Sửa" : "Thêm" %> người dùng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">
        <h1><%= isEdit ? "Chỉnh sửa" : "Thêm mới" %> người dùng</h1>
        <form method="post" action="${pageContext.request.contextPath}/admin/users">
            <% if (isEdit) { %>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="user_id" value="<%= user.get("user_id") %>">
            <% } else { %>
                <input type="hidden" name="action" value="create">
            <% } %>
            <div><label>Tên đăng nhập</label><input type="text" name="username" value="<%= isEdit ? user.get("username") : "" %>" required></div>
            <div><label>Email</label><input type="email" name="email" value="<%= isEdit ? user.get("email") : "" %>"></div>
            <div><label>Số điện thoại</label><input type="tel" name="phone" value="<%= isEdit ? user.get("phone") : "" %>"></div>
            <div><label>Mật khẩu</label><input type="password" name="password" <% if(!isEdit) out.print("required"); %>></div>
            <!-- Đã bỏ phần chọn role -->
            <button type="submit" class="btn btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn">Hủy</a>
        </form>
    </div>
</div>
</body>
</html>