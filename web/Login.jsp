<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập</title>

        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>

    <body>

        <!-- ===== MODAL ĐĂNG NHẬP ===== -->
        <div class="modal-overlay" id="loginModal">
            <div class="modal-box">

                <h2>Đăng Nhập</h2>

                <!-- FORM THẬT -->
                <form action="loginServlet" method="post" style="color: #333">

                    <label>Email</label>
                    <input type="text" name="username" placeholder="Nhập email của bạn" required>

                    <label >Mật khẩu</label>
                    <input type="password" name="password" placeholder="Nhập mật khẩu" required>
                    
                    <p style="color:red">
                        ${mess}
                    </p>

                    <div class="modal-actions">
                        <div class="modal-links">
                            <a href="register.jsp">Đăng ký</a>
                            <span>|</span>
                            <a href="#">Chưa có tài khoản</a>
                        </div>

                        <div class="modal-btn-group">
                            <button class="btn-submit" type="submit" name="action" value="login">
                                Đăng nhập
                            </button>


                        </div>
                    </div>

                </form>

            </div>
        </div>

    </body>
</html>