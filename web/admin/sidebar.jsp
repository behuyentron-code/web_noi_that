<%-- 
    Document   : sidebar
    Created on : Apr 25, 2026, 12:10:06 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <div class="admin-sidebar">
            <h3>DECOR LUXURY</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/AdminDashboardServlet"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminUserServlet"><i class="fas fa-users"></i> Người dùng</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminProductServlet"><i class="fas fa-box"></i> Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminCategoryServlet"><i class="fas fa-tags"></i> Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminOrderServlet"><i class="fa-solid fa-truck"></i> Đơn hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/hienthi"><i class="fa-solid fa-arrow-left"></i> Về trang chủ</a></li>
            </ul>
        </div>
    </body>
</html>
