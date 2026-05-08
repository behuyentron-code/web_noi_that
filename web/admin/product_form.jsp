<%-- 
    Document   : product_form
    Created on : Apr 25, 2026, 12:13:43 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.products, java.util.List"%>

<%
    products p = (products) request.getAttribute("product");
    List<String> cats = (List<String>) request.getAttribute("categories");
    boolean isEdit = (p != null);
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= isEdit ? "Sửa" : "Thêm" %> sản phẩm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    </head>
    
    
    <body>
    <div class="admin-wrapper">
        <jsp:include page="sidebar.jsp"/>
        <div class="admin-content">
            <h1><%= isEdit ? "Chỉnh sửa sản phẩm" : "Thêm mới sản phẩm" %></h1>

            <form method="post" action="AdminProductServlet">
                <% if (isEdit) { %>
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="product_id" value="<%= p.getProduct_id() %>">
                <% } else { %>
                    <input type="hidden" name="action" value="create">
                <% } %>

                <div class="form-row">
                    <div>
                        <label>Tên sản phẩm</label>
                        <input type="text" name="product_name" value="<%= isEdit ? p.getProduct_name() : "" %>" required>
                    </div>
                    <div>
                        <label>Giá (VNĐ)</label>
                        <input type="number" name="price" value="<%= isEdit ? p.getPrice() : "" %>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div>
                        <label>Số lượng tồn kho</label>
                        <input type="number" name="quantity" min="0"
                               value="<%= isEdit ? p.getQuantity() : "0" %>" required
                               placeholder="Nhập số lượng tồn">
                    </div>
                    <div>
                        <label>Giảm giá (%)</label>
                        <input type="number" name="discount_price" min="0" max="99"
                               value="<%= isEdit ? p.getDiscount_price() : "0" %>"
                               placeholder="0 = không giảm giá">
                    </div>
                </div>

                <div>
                    <label>Mô tả</label>
                    <textarea name="description"><%= isEdit ? p.getDescription() : "" %></textarea>
                </div>

                <div class="form-row">
                    <div>
                        <label>Ảnh (tên file)</label>
                        <input type="text" name="image" value="<%= isEdit ? p.getImage() : "" %>" placeholder="vd: sanpham.jpg">
                    </div>
                    <div>
                        <label>Danh mục</label>
                        <select name="category_id">
                            <% for (int i = 0; i < cats.size(); i++) { 
                                String catName = cats.get(i);
                                int catId = i + 1;
                            %>
                                <option value="<%= catId %>" <%= (isEdit && p.getCategoryName() != null && p.getCategoryName().equals(catName)) ? "selected" : "" %>>
                                    <%= catName %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                </div>
 
                <button type="submit" class="btn-primary">Lưu sản phẩm</button>
                <a href="AdminProductServlet" class="btn">Hủy bỏ</a>
            </form>
        </div>
    </div>
    </body>
</html>
