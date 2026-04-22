<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký</title>

        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>

    <body>

        <!-- ===== MODAL ĐĂNG KÝ ===== -->
        <div class="modal-overlay " id="registerModal">
            <div class="modal-box">

                <h2>Đăng Ký</h2>

                <!-- FORM THẬT -->
                <form action="loginServlet" method="post" onsubmit="return validateForm()">

                    <label>Email</label>
                    <input type="text" name="username" id="regEmail" placeholder="Nhập email của bạn" required>

                    <label>Mật khẩu</label>
                    <input type="password" name="password" id="regPass" placeholder="Tạo mật khẩu" required>

                    <label>Xác nhận mật khẩu</label>
                    <input type="password" id="regPassConfirm" placeholder="Nhập lại mật khẩu" required>

                    <div class="modal-actions">
                        <div class="modal-links">
                            <a href="Login.jsp">Đăng nhập</a>
                        </div>

                        <div class="modal-btn-group">
                            <button class="btn-submit" type="submit" name="action" value="register">
                                Đăng ký
                            </button>

                        </div>
                    </div>

                </form>


            </div>
        </div>

        <!-- VALIDATE JS -->
        <script>
            function validateForm() {
                const pass = document.getElementById("regPass").value;
                const confirm = document.getElementById("regPassConfirm").value;

                if (pass !== confirm) {
                    alert("Mật khẩu xác nhận không khớp!");
                    return false;
                }
                return true;
            }
        </script>

    </body>
</html>
