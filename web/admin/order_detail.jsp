<%-- 
    Document   : order_detail
    Created on : Apr 25, 2026, 12:14:54 AM
    Author     : Admin
--%>

<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.Object"%>
<%@page import="java.lang.String"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.NumberFormat, java.text.SimpleDateFormat" %>
<%
    Map<String,Object> order = (Map<String,Object>) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/admin/orders");
        return;
    }
    List<Map<String,Object>> items = (List<Map<String,Object>>) order.get("items");  
    
    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String currentStatus = order.get("status") != null ? (String) order.get("status") : "";

    String badgeClass;
    String statusLabel;
    switch (currentStatus) {
        case "pending":    badgeClass = "status-pending";    statusLabel = "Chờ xử lý";   break;
        case "processing": badgeClass = "status-processing"; statusLabel = "Đang xử lý";  break;
        case "shipped":    badgeClass = "status-shipped";    statusLabel = "Đã giao hàng";break;
        case "completed":  badgeClass = "status-completed";  statusLabel = "Hoàn thành";  break;
        case "cancelled":  badgeClass = "status-cancelled";  statusLabel = "Đã hủy";      break;
        default:           badgeClass = "";                  statusLabel = currentStatus;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết đơn hàng #<%= order.get("order_id") %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin.css">
    <style>
        /* Chỉ giữ lại những gì chưa có trong admin.css */
        .status-badge     { padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: bold; display: inline-block; }
        .status-pending   { background: #fef9e7; color: #f39c12; }
        .status-processing{ background: #e8f0fe; color: #2980b9; }
        .status-shipped   { background: #e8f8f5; color: #16a085; }
        .status-completed { background: #e9f7ef; color: #27ae60; }
        .status-cancelled { background: #fdeded; color: #e74c3c; }

        /* Card thông tin đơn hàng — dùng màu/font nhất quán với admin.css */
        .order-info-card {
            background: white;
            border-radius: 16px;
            padding: 24px 28px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .order-info-card p { margin: 10px 0; font-size: 14px; color: #2c2c2c; }
        .order-info-card strong { color: #2c2c2c; }

        /* Form update — tái dùng .filter-bar style của admin.css nhưng ko wrap trong div.filter-bar */
        .update-form {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            background: white;
            padding: 16px 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 28px;
        }
        .update-form select {
            padding: 10px 14px;
            border: 1px solid #d6ddc8;
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.2s;
            background: #fefefe;
        }
        .update-form select:focus {
            outline: none;
            border-color: #4e5c34;
            box-shadow: 0 0 0 3px rgba(78,92,52,0.1);
        }

        thead th { background: #f5f7f0; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        h3 { margin: 0 0 14px; font-size: 16px; color: #2c2c2c; }
    </style>
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">

        <div class="page-header">
            <h1><i class="fa-solid fa-receipt"></i> Đơn hàng #<%= order.get("order_id") %></h1>
            <%-- .btn dùng class từ admin.css --%>
            <a href="${pageContext.request.contextPath}/AdminOrderServlet" class="btn">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <%-- Thông tin đơn hàng --%>
        <div class="order-info-card">
            <p><strong>Khách hàng:</strong> <%= order.get("username") %></p>
            <p><strong>Email:</strong> <%= order.get("email") %></p>
            <p><strong>Số điện thoại:</strong> <%= order.get("phone") %></p>
            <p><strong>Địa chỉ giao hàng:</strong> <%= order.get("shipping_address") %></p>
            <p><strong>Phương thức thanh toán:</strong> <%= order.get("payment_method") %></p>
            <p><strong>Ngày đặt:</strong> <%= order.get("order_date") != null ? sdf.format(order.get("order_date")) : "" %></p>
            <p><strong>Tổng tiền:</strong> <span style="font-size:16px; color:#4e5c34;"><strong><%= fmt.format(order.get("total_price")) %></strong></span></p>
            <p><strong>Trạng thái:</strong> <span class="status-badge <%= badgeClass %>"><%= statusLabel %></span></p>
        </div>

        <%-- Form cập nhật trạng thái --%>
        <%-- action dùng context path đầy đủ, .btn .btn-primary từ admin.css --%>
        <form method="post" action="AdminOrderServlet" class="update-form">
            <input type="hidden" name="orderId" value="<%= order.get("order_id") %>">
            <label style="font-weight:600; font-size:14px;">Cập nhật trạng thái:</label>
            <select name="status">
                <option value="pending"    <%= "pending".equals(currentStatus)    ? "selected" : "" %>>Chờ xử lý</option>
                <option value="processing" <%= "processing".equals(currentStatus) ? "selected" : "" %>>Đang xử lý</option>
                <option value="shipped"    <%= "shipped".equals(currentStatus)    ? "selected" : "" %>>Đã giao hàng</option>
                <option value="completed"  <%= "completed".equals(currentStatus)  ? "selected" : "" %>>Hoàn thành</option>
                <option value="cancelled"  <%= "cancelled".equals(currentStatus)  ? "selected" : "" %>>Đã hủy</option>
            </select>
            <%-- .btn-primary từ admin.css (global, không cần trong form) --%>
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-check"></i> Cập nhật
            </button>
        </form>

        <%-- Danh sách sản phẩm — table, th, td từ admin.css --%>
        <h2><i class="fa-solid fa-box"></i> Chi tiết sản phẩm</h2>
        <table>
            <thead>
                <tr>
                    <th>Hình ảnh</th>
                    <th>Sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Đơn giá</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
            <% if (items.isEmpty()) { %>
                <tr><td colspan="5" style="text-align:center; padding:20px; color:#999;">Không có sản phẩm</td></tr>
            <% } else {
                for (Map<String,Object> item : items) {
                    int    qty      = item.get("quantity") != null ? (int)    item.get("quantity") : 0;
                    double price    = item.get("price")    != null ? (double) item.get("price")    : 0.0;
                    double subtotal = qty * price;
            %>
                <tr>
                    <td>
                        <img src="${pageContext.request.contextPath}/images/<%= item.get("image") %>"
                             width="60" style="border-radius:8px; object-fit:cover;">
                    </td>
                    <td><%= item.get("product_name") %></td>
                    <td><%= qty %></td>
                    <td><%= fmt.format(price) %></td>
                    <td><strong><%= fmt.format(subtotal) %></strong></td>
                </tr>
            <% } } %>
            </tbody>
        </table>

    </div>
</div>
</body>
</html>
