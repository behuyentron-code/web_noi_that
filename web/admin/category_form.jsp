<%-- 
    Document   : category_form
    Created on : Apr 25, 2026, 2:05:29 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>

<%
    Map<String,Object> cat = (Map<String,Object>) request.getAttribute("category");
    boolean isEdit = (cat != null && !cat.isEmpty());
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Sửa" : "Thêm" %> danh mục</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">
        <h1><%= isEdit ? "Chỉnh sửa" : "Thêm mới" %> danh mục</h1>
        <form method="post">
            <% if (isEdit) { %>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="category_id" value="<%= cat.get("category_id") %>">
            <% } else { %>
                <input type="hidden" name="action" value="create">
            <% } %>
            <div><label>Tên danh mục</label><input type="text" name="category_name" value="<%= isEdit ? cat.get("category_name") : "" %>" required></div>
            <button type="submit" class="btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn">Hủy</a>
        </form>
    </div>
</div>
</body>
</html>
