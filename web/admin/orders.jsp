<%-- 
    Document   : orders
    Created on : Apr 25, 2026, 12:14:36 AM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.NumberFormat, java.text.SimpleDateFormat" %>
<%
    List<Map<String,Object>> orders = (List<Map<String,Object>>) request.getAttribute("orders");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    int currentPage = request.getAttribute("currentPage") != null ? (int) request.getAttribute("currentPage") : 1;
    int totalPages = request.getAttribute("totalPages") != null ? (int) request.getAttribute("totalPages") : 1;
    String keyword = request.getAttribute("keyword") != null ? (String) request.getAttribute("keyword") : "";
    String statusFilter = request.getAttribute("statusFilter") != null ? (String) request.getAttribute("statusFilter") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý đơn hàng - Decor Luxury Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .filter-bar { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; align-items: center; }
        .filter-bar input, .filter-bar select { padding: 8px 12px; border-radius: 8px; border: 1px solid #ddd; }
        .filter-bar button { background: #4e5c34; color: white; border: none; padding: 8px 16px; border-radius: 8px; cursor: pointer; }
        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; display: inline-block; }
        .status-pending { background: #fef9e7; color: #f39c12; }
        .status-processing { background: #e8f0fe; color: #2980b9; }
        .status-shipped { background: #e8f8f5; color: #16a085; }
        .status-completed { background: #e9f7ef; color: #27ae60; }
        .status-cancelled { background: #fdeded; color: #e74c3c; }
        .pagination { margin-top: 20px; display: flex; justify-content: center; gap: 8px; }
        .pagination a, .pagination span { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; text-decoration: none; color: #333; }
        .pagination .active { background: #4e5c34; color: white; border-color: #4e5c34; }
        .btn-sm { padding: 4px 10px; font-size: 12px; }
    </style>
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">
        <div style="display:flex; justify-content:space-between; margin-bottom: 20px">
            
            <h1><i class="fa-solid fa-truck"></i> Quản lý đơn hàng</h1>
        </div>
        <!-- Bộ lọc và tìm kiếm -->
        <div class="filter-bar">
            <form method="get" action="${pageContext.request.contextPath}/AdminOrderServlet" style="display: flex; gap: 10px; flex-wrap: wrap;">
                <input type="text" name="keyword" placeholder="Tìm theo mã đơn hoặc tên KH" value="<%= keyword %>">
                <select name="status">
                    <option value="all" <%= "all".equals(statusFilter) ? "selected" : "" %>>Tất cả trạng thái</option>
                    <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>Chờ xử lý</option>
                    <option value="processing" <%= "processing".equals(statusFilter) ? "selected" : "" %>>Đang xử lý</option>
                    <option value="shipped" <%= "shipped".equals(statusFilter) ? "selected" : "" %>>Đã giao hàng</option>
                    <option value="completed" <%= "completed".equals(statusFilter) ? "selected" : "" %>>Hoàn thành</option>
                    <option value="cancelled" <%= "cancelled".equals(statusFilter) ? "selected" : "" %>>Đã hủy</option>
                </select>
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Lọc</button>
                <a href="${pageContext.request.contextPath}/AdminOrderServlet" class="btn-secondary">Xóa lọc</a>
            </form>
        </div>

        <!-- Bảng đơn hàng -->
        <table class="data-table">
            <thead>
                <tr><th>Mã ĐH</th><th>Khách hàng</th><th>Ngày đặt</th><th>Tổng tiền</th><th>Trạng thái</th><th>Thao tác</th></tr>
            </thead>
            <tbody>
            <% if (orders == null || orders.isEmpty()) { %>
                <tr><td colspan="6" style="text-align: center;">Không có đơn hàng nào</td></tr>
            <% } else {
                for (Map<String,Object> o : orders) {
                    String status = (String) o.get("status");
                    String badgeClass = "";
                    switch (status) {
                        case "pending": badgeClass = "status-pending"; break;
                        case "processing": badgeClass = "status-processing"; break;
                        case "shipped": badgeClass = "status-shipped"; break;
                        case "completed": badgeClass = "status-completed"; break;
                        case "cancelled": badgeClass = "status-cancelled"; break;
                    }
            %>
            <tr>
                <td>#<%= o.get("order_id") %></td>
                <td><%= o.get("username") %></td>
                <td><%= sdf.format(o.get("order_date")) %></td>
                <td><strong><%= fmt.format(o.get("total_price")) %></strong></td>
                <td><span class="status-badge <%= badgeClass %>"><%= status.equals("pending") ? "Chờ xử lý" : status.equals("processing") ? "Đang xử lý" : status.equals("shipped") ? "Đã giao" : status.equals("completed") ? "Hoàn thành" : "Đã hủy" %></span></td>
                <td><a href="?action=detail&id=<%= o.get("order_id") %>" class="btn btn-primary btn-sm">Chi tiết</a></td>
            </tr>
            <% } } %>
            </tbody>
        </table>

        <!-- Phân trang -->
        <% if (totalPages > 1) { %>
        <div class="pagination">
            <% if (currentPage > 1) { %>
                <a href="?page=<%= currentPage-1 %>&keyword=<%= keyword %>&status=<%= statusFilter %>">« Trước</a>
            <% } %>
            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="?page=<%= i %>&keyword=<%= keyword %>&status=<%= statusFilter %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
            <% } %>
            <% if (currentPage < totalPages) { %>
                <a href="?page=<%= currentPage+1 %>&keyword=<%= keyword %>&status=<%= statusFilter %>">Sau »</a>
            <% } %>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
