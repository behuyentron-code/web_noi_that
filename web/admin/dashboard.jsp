<%-- 
    Document   : dashboard
    Created on : Apr 25, 2026, 12:08:51 AM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Decor Luxury</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">
        <h1>Dashboard</h1>
        <div class="stats-grid">
            <div class="stat-card"><i class="fa-solid fa-box"></i><span>Sản phẩm</span><strong>${totalProducts}</strong></div>
            <div class="stat-card"><i class="fa-solid fa-users"></i><span>Người dùng</span><strong>${totalUsers}</strong></div>
            <div class="stat-card"><i class="fa-solid fa-cart-shopping"></i><span>Đơn hàng</span><strong>${totalOrders}</strong></div>
            <div class="stat-card"><i class="fa-solid fa-dollar-sign"></i><span>Doanh thu</span><strong>${totalRevenue}₫</strong></div>
        </div>
    </div>
</div>
</body>
</html>
