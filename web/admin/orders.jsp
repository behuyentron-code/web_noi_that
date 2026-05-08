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
    int totalPages  = request.getAttribute("totalPages")  != null ? (int) request.getAttribute("totalPages")  : 1;
    String keyword      = request.getAttribute("keyword")      != null ? (String) request.getAttribute("keyword")      : "";
    String statusFilter = request.getAttribute("statusFilter") != null ? (String) request.getAttribute("statusFilter") : "";
    String keywordEncoded = java.net.URLEncoder.encode(keyword, "UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý đơn hàng - Decor Luxury Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin.css">
    <style>
        /* Chỉ giữ lại những gì chưa có trong admin.css */
        .status-badge     { 
            padding: 4px 10px;
            border-radius: 20px; 
            font-size: 12px; 
            font-weight: bold; 
            display: inline-block; 
        }
        .status-pending   { 
            background: #fef9e7;
            color: #f39c12; 
        }
        .status-processing{ 
            background: #e8f0fe; 
            color: #2980b9; 
        }
        .status-shipped   { 
            background: #e8f8f5; 
            color: #16a085; 
        }
        .status-completed { 
            background: #e9f7ef; 
            color: #27ae60; 
        }
        .status-cancelled { 
            background: #fdeded; 
            color: #e74c3c; 
        }

        .pagination { 
            margin-top: 20px; 
            display: flex; 
            justify-content: center;
            gap: 8px; 
            flex-wrap: wrap;
        }
        .pagination a { 
            padding: 8px 12px; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            text-decoration: none; 
            color: #333; 
            transition: background .2s;
        }
        .pagination a:hover {
            background: #e2e8d8;
        }
        .pagination a.active { 
            background: #4e5c34;
            color: white;
            border-color: #4e5c34;
        
        }

        .page-header { 
            display: flex; 
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px; 
        }
        
        .btn-sm { 
            padding: 5px 12px !important; 
            font-size: 12px !important;
        }
        thead th { 
            background: #f5f7f0; 
        }
    </style>
</head>
<body>
<div class="admin-wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="admin-content">

        <div class="page-header">
            <h1><i class="fa-solid fa-truck"></i> Quản lý đơn hàng</h1>
        </div>

        <%-- .filter-bar, button, .btn-secondary đã có sẵn trong admin.css --%>
        <div class="filter-bar">
            <form method="get" action="AdminOrderServlet">
                <input type="text" name="keyword"
                       placeholder="Tìm theo mã đơn hoặc tên KH"
                       value="<%= keyword %>">
                <select name="status">
                    <option value="all"        <%= "all".equals(statusFilter) || statusFilter.isEmpty() ? "selected" : "" %>>Tất cả trạng thái</option>
                    <option value="pending"    <%= "pending".equals(statusFilter)    ? "selected" : "" %>>Chờ xử lý</option>
                    <option value="processing" <%= "processing".equals(statusFilter) ? "selected" : "" %>>Đang xử lý</option>
                    <option value="shipped"    <%= "shipped".equals(statusFilter)    ? "selected" : "" %>>Đã giao hàng</option>
                    <option value="completed"  <%= "completed".equals(statusFilter)  ? "selected" : "" %>>Hoàn thành</option>
                    <option value="cancelled"  <%= "cancelled".equals(statusFilter)  ? "selected" : "" %>>Đã hủy</option>
                </select>
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Lọc</button>
                <a href="${pageContext.request.contextPath}/AdminOrderServlet" class="btn-secondary">Xóa lọc</a>
            </form>
        </div>

        <%-- table, th, td, .btn, .btn-primary, .btn-warning, .btn-danger đã có trong admin.css --%>
        <table>
            <thead>
                <tr>
                    <th>Mã ĐH</th>
                    <th>Khách hàng</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
            <% if (orders == null || orders.isEmpty()) { %>
                <tr>
                    <td colspan="6" style="text-align:center; padding:30px; color:#999;">
                        <i class="fa-solid fa-box-open"></i> Không có đơn hàng nào
                    </td>
                </tr>
            <% } else {
                for (Map<String,Object> o : orders) {
                    String st = o.get("status") != null ? (String) o.get("status") : "";
                    String badgeClass  = "status-" + st;
                    String statusLabel;
                    switch (st) {
                        case "pending":    statusLabel = "Chờ xử lý";  break;
                        case "processing": statusLabel = "Đang xử lý"; break;
                        case "shipped":    statusLabel = "Đã giao";     break;
                        case "completed":  statusLabel = "Hoàn thành"; break;
                        case "cancelled":  statusLabel = "Đã hủy";     break;
                        default:           statusLabel = st;
                    }
            %>
                <tr>
                    <td><strong>#<%= o.get("order_id") %></strong></td>
                    <td><%= o.get("username") %></td>
                    <td><%= o.get("order_date") != null ? sdf.format(o.get("order_date")) : "" %></td>
                    <td><strong><%= fmt.format(o.get("total_price")) %></strong></td>
                    <td><span class="status-badge <%= badgeClass %>"><%= statusLabel %></span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/AdminOrderServlet?action=detail&id=<%= o.get("order_id") %>"
                           class="btn btn-primary btn-sm">
                            <i class="fa-solid fa-eye"></i> Chi tiết
                        </a>
                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>

        <% if (totalPages > 1) { %>
        <div class="pagination">
            <% if (currentPage > 1) { %>
                <a href="${pageContext.request.contextPath}/AdminOrderServlet?page=<%= currentPage-1 %>&keyword=<%= keywordEncoded %>&status=<%= statusFilter %>">« Trước</a>
            <% } %>
            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="${pageContext.request.contextPath}/AdminOrderServlet?page=<%= i %>&keyword=<%= keywordEncoded %>&status=<%= statusFilter %>"
                   class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
            <% } %>
            <% if (currentPage < totalPages) { %>
                <a href="${pageContext.request.contextPath}/AdminOrderServlet?page=<%= currentPage+1 %>&keyword=<%= keywordEncoded %>&status=<%= statusFilter %>">Sau »</a>
            <% } %>
        </div>
        <% } %>

    </div>
</div>
</body>
</html>
