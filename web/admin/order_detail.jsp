<%-- 
    Document   : order_detail
    Created on : Apr 25, 2026, 12:14:54 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.NumberFormat" %>
<%
    Map<String,Object> order = (Map<String,Object>) request.getAttribute("order");
    List<Map<String,Object>> items = (List<Map<String,Object>>) order.get("items");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết đơn hàng #<%= order.get("order_id") %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin.css">
</head>

    <body>
        <div class="admin-wrapper">
            <jsp:include page="sidebar.jsp"/>
            <div class="admin-content">
                <h1>Đơn hàng #<%= order.get("order_id") %></h1>
                <p><strong>Khách hàng:</strong> <%= order.get("username") %></p>
                <p><strong>Địa chỉ:</strong> <%= order.get("shipping_address") %></p>
                <p><strong>Thanh toán:</strong> <%= order.get("payment_method") %></p>
                <p><strong>Ngày đặt:</strong> <%= order.get("order_date") %></p>
                <p><strong>Trạng thái hiện tại:</strong> <%= order.get("status") %></p>
                <form method="post" action="${pageContext.request.contextPath}/admin/orders">
                    <input type="hidden" name="orderId" value="<%= order.get("order_id") %>">
                    <select name="status">
                        <option value="pending" <%= "pending".equals(order.get("status"))?"selected":"" %>>Chờ xử lý</option>
                        <option value="processing" <%= "processing".equals(order.get("status"))?"selected":"" %>>Đang xử lý</option>
                        <option value="shipped" <%= "shipped".equals(order.get("status"))?"selected":"" %>>Đã giao hàng</option>
                        <option value="completed" <%= "completed".equals(order.get("status"))?"selected":"" %>>Hoàn thành</option>
                        <option value="cancelled" <%= "cancelled".equals(order.get("status"))?"selected":"" %>>Đã hủy</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Cập nhật trạng thái</button>
                </form>
                <h3>Chi tiết sản phẩm</h3>
                <table>
                    <tr><th>Sản phẩm</th><th>Hình ảnh</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr>
                    <% for(Map<String,Object> item : items) { %>
                    <tr>
                        <td><%= item.get("product_name") %></td>
                        <td><img src="${pageContext.request.contextPath}/images/<%= item.get("image") %>" width="50"></td>
                        <td><%= item.get("quantity") %></td>
                        <td><%= fmt.format(item.get("price")) %></td>
                        <td><%= fmt.format((double)item.get("quantity") * (double)item.get("price")) %></td>
                    </tr>
                    <% } %>
                </table>
                <a href="orders" class="btn">Quay lại</a>
            </div>
        </div>
    </body>
</html>
