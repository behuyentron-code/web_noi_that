<%-- 
    Document   : categories
    Created on : Apr 25, 2026, 2:05:14 AM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,Object>> categories = (List<Map<String,Object>>) request.getAttribute("categories");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
    String keyword = request.getAttribute("keyword") != null ? (String) request.getAttribute("keyword") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý danh mục</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .filter-bar { margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">
        <div style="display:flex; justify-content:space-between; margin-bottom: 20px">
            <h1><i class="fas fa-tags"></i> Quản lý danh mục</h1>
            <a href="?action=add" class="btn btn-primary">Thêm danh mục</a>
        </div>
        <div class="filter-bar">
            <form method="get">
                <input type="text" name="keyword" placeholder="Tìm theo tên danh mục" value="<%= keyword %>">
                
                <button type="submit"><i class="fas fa-search"></i> Tìm</button>
                <a href="${pageContext.request.contextPath}/AdminCategoryServlet" class="btn-secondary">Xóa</a>
            </form>
        </div>
        <table class="data-table">
            <thead><tr><th>ID</th><th>Tên danh mục</th><th>Thao tác</th></tr></thead>
            <tbody>
            <% if (categories == null || categories.isEmpty()) { %>
                <tr><td colspan="3">Không có danh mục nào</td></tr>
            <% } else {
                for (Map<String,Object> c : categories) { %>
                <tr>
                    <td><%= c.get("category_id") %></td>
                    <td><%= c.get("category_name") %></td>
                    <td>
                        <a href="?action=edit&id=<%= c.get("category_id") %>" class="btn btn-warning btn-sm">Sửa</a>
                        <a href="?action=delete&id=<%= c.get("category_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Xóa danh mục này?')">Xóa</a>
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
</html>
