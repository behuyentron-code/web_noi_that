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
                <form action="loginServlet" method="post">

                    <label style="color: #ffffff">Email</label>
                    <input type="text" name="username" placeholder="Nhập email của bạn" required>

                    <label style="color: #ffffff">Mật khẩu</label>
                    <input type="password" name="password" placeholder="Nhập mật khẩu" required>

                    <div class="modal-actions">
                        <div class="modal-links">
                            <a href="register.jsp">Đăng ký</a>
                            <span>|</span>
                            <a href="#">Quên mật khẩu</a>
                        </div>

                        <div class="modal-btn-group">
                            <button class="btn-submit" type="submit" name="action" value="login">
                                Đăng nhập
                            </button>


                        </div>
                    </div>

                </form>

                <!-- SOCIAL -->
                <div class="modal-social">
                    <button class="social-btn fb">
                        <i class="fa-brands fa-facebook-f"></i>
                    </button>
                    <button class="social-btn gg">
                        <i class="fa-brands fa-google"></i>
                    </button>
                </div>

            </div>
        </div>

    </body>
</html>