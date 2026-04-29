<%-- 
    Document   : contact_form
    Created on : Apr 29, 2026, 1:22:19 AM
    Author     : Admin
--%>

<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.Map"%>

<%
    Map<String, Object> contact = (Map<String, Object>) request.getAttribute("contact");
    if (contact == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    String email = (String) contact.get("email");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa liên hệ</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">
        <h1><i class="fa-solid fa-pen-to-square"></i> Sửa liên hệ</h1>
        
        <form action="${pageContext.request.contextPath}/AdminContactServlet" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= contact.get("contact_id") %>">
            <input type="hidden" name="email" value="<%= email %>">
            
            <div class="form-group">
                <label>Họ tên</label>
                <input type="text" name="name" value="<%= contact.get("name") != null ? contact.get("name") : "" %>" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" value="<%= email %>" disabled>

            </div>
            <div class="form-group">
                <label>Điện thoại</label>
                <input type="text" name="phone" value="<%= contact.get("phone") != null ? contact.get("phone") : "" %>">
            </div>
            <div class="form-group">
                <label>Nội dung</label>
                <textarea name="message" rows="5" required><%= contact.get("message") != null ? contact.get("message") : "" %></textarea>
            </div>
           
            <button type="submit" class="btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn">Hủy bỏ</a>
              
        </form>
    </div>
</div>
</body>
</html>
