<%-- 
    Document   : contact_list
    Created on : Apr 25, 2026, 3:31:27 AM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    List<Map<String,Object>> contacts = (List<Map<String,Object>>) request.getAttribute("contacts");
    String userEmail = (String) request.getAttribute("userEmail");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách liên hệ - <%= userEmail %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin.css">
    <style>
        .message-content { max-width: 400px; white-space: pre-wrap; word-break: break-word; }
        .back-link { margin-bottom: 20px; display: inline-block; }
    </style>
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">
        <a href="${pageContext.request.contextPath}/AdminUserServlet" class="back-link btn-secondary">← Quay lại danh sách người dùng</a>
        <h1 style="margin-bottom:20px"><i class="fa-solid fa-envelope"></i> Liên hệ từ: <%= userEmail %></h1>
        <% if (contacts == null || contacts.isEmpty()) { %>
            <p>Không có liên hệ nào từ email này.</p>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr><th>ID</th><th>Họ tên</th><th>Điện thoại</th><th>Nội dung</th><th>Ngày gửi</th></tr>
                </thead>
                <tbody>
                <% for (Map<String,Object> c : contacts) { 
                    int contactId = (Integer) c.get("contact_id");
                %>
                    <tr>
                        <td><%= contactId %></td>
                        <td><%= c.get("name") != null ? c.get("name") : "" %></td>
                        <td><%= c.get("phone") != null ? c.get("phone") : "" %></td>
                        <td class="message-content"><%= c.get("message") != null ? c.get("message") : "" %></td>
                        <td><%= sdf.format(c.get("created_at")) %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/AdminContactServlet?action=edit&id=<%= contactId %>&email=<%= userEmail %>" 
   class="btn btn-warning btn-sm">Sửa</a>

<a href="${pageContext.request.contextPath}/AdminContactServlet?action=delete&id=<%= contactId %>&email=<%= userEmail %>" 
   class="btn btn-danger btn-sm" onclick="return confirm('Xóa?')">Xóa</a>
                            </div>
                         </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>
</body>
</html>
