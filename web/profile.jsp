<%-- 
    Document   : profile
    Created on : 5 thg 5, 2026, 19:36:06
    Author     : TRANG ANH LAPTOP
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Thông tin cá nhân</title>
    <link rel="stylesheet" href="css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body style="background: #f4f7f1; margin: 0; padding: 0; min-height: 100vh;">

    <div class="banner" style="background-color: #4e5c34; color: white; padding: 30px; text-align: center;">
        HỒ SƠ CÁ NHÂN
    </div>

    <div class="container" style="display: flex; justify-content: center; gap: 20px; margin: 40px auto; max-width: 1100px; background: transparent; box-shadow: none;">
        
        <div class="left-menu" style="width: 250px; flex-shrink: 0; background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); align-self: flex-start;">
            <h3 style="margin: 0; padding: 20px; font-size: 18px; border-bottom: 1px solid #eee;">TÀI KHOẢN</h3>
            <ul style="list-style: none; padding: 10px 0;">
                <li style="padding: 12px 20px; background: #f0f3ea; color: #4e5c34; font-weight: bold;"><i class="fas fa-user-alt"></i> Thông tin cá nhân</li>
              
                <li style="padding: 12px 20px; cursor: pointer;" onclick="location.href='trangchu.jsp'"><i class="fas fa-sign-out-alt"></i> Quay lại chủ</li>
            </ul>
        </div>

        <div class="content" style="flex: 1; background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); margin-left: 0;">
            <div class="content-header" style="border-bottom: 2px solid #f0f3ea; margin-bottom: 20px; padding-bottom: 10px;">
                <h2 style="margin: 0; color: #2c2c2c; font-size: 22px;">Chi tiết tài khoản</h2>
            </div>

            <table class="spec-table" style="width: 100%; border-collapse: collapse;">
                <tr style="background: #fcfdfb;">
                    <td style="padding: 15px; font-weight: 600; color: #4e5c34; width: 30%;">Tên đăng nhập</td>
                    <td style="padding: 15px;">${username}</td>
                </tr>
                <tr>
                    <td style="padding: 15px; font-weight: 600; color: #4e5c34;">Email liên hệ</td>
                    <td style="padding: 15px;">${email != null ? email : 'Chưa cập nhật'}</td>
                </tr>
                <tr style="background: #fcfdfb;">
                    <td style="padding: 15px; font-weight: 600; color: #4e5c34;">Số điện thoại</td>
                    <td style="padding: 15px;">${phone != null ? phone : 'Chưa cập nhật'}</td>
                </tr>
                <tr>
                    <td style="padding: 15px; font-weight: 600; color: #4e5c34;">Trạng thái tài khoản</td>
                    <td style="padding: 15px;"><span class="badge badge-green" style="background: #e8f5e9; color: #2e7d32; padding: 5px 12px; border-radius: 20px; font-size: 12px;">Đang hoạt động</span></td>
                </tr>
            </table>

            <div style="margin-top: 30px; display: flex; gap: 15px;">
                <button class="btn-pill solid" style="cursor: pointer; padding: 10px 25px;">Cập nhật hồ sơ</button>
                <button class="btn-pill outline" style="cursor: pointer; padding: 10px 25px;" onclick="history.back()">Quay lại</button>
            </div>
        </div>
    </div>

    <div class="footer-modern" style="background: #2c3520; color: white; padding: 40px; margin-top: 50px;">
        <div style="max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-between;">
            <div>
                <div style="font-weight: bold; font-size: 20px;">ECOSHOP</div>
                <p style="font-size: 13px; opacity: 0.7;">Hệ thống cung cấp sản phẩm sạch cho gia đình bạn.</p>
            </div>
            <div style="font-size: 13px;">
                <a href="trangchu.jsp" style="color: #c8e06b; text-decoration: none;">Trang chủ</a> | 
                <a href="#" style="color: white; text-decoration: none; margin-left: 10px;">Sản phẩm</a>
            </div>
        </div>
    </div>

</body>
</html>