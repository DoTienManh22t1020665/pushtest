<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Login — Orange Theme Pro+</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/cssremake/login.css">
    </head>
    <body>

        <!--
          ĐỔI ẢNH TRÁI:
          - Sửa biến --ob-left-image bên dưới thành ảnh của anh.
          - Nếu navbar fixed cao ~72px, dùng --ob-top-gap: 72px để không bị che.
        -->
        <div id="ob-login"
             style="
             --ob-left-image: url('<%=request.getContextPath()%>/assets/images/login.png');
             --ob-top-gap: 72px;">

            <div class="ob-stage">
                <div class="ob-card">
                    <!-- Trái: chỉ ảnh -->
                    <aside class="ob-left" aria-label="Login side image"></aside>

                    <!-- Phải: form -->
                    <section class="ob-right">
                        <button class="ob-close" type="button" aria-label="Close">×</button>

                        <h3 class="ob-heading">LOGIN</h3>
                        <c:if test="${not empty sessionScope.login_err}">
                            <div class="ob-alert ob-alert--error" role="alert" aria-live="polite">
                                <c:out value="${sessionScope.login_err}"/>
                            </div>
                            <!-- Hiển thị xong thì xoá để không lặp lại -->
                            <c:remove var="login_err" scope="session"/>
                        </c:if>


                        <!-- Nếu cần hiện lỗi server, có thể chèn <div class="ob-alert">...</div> tại đây -->

                        <form class="ob-form" method="post" action="<%=request.getContextPath()%>/login">

                            <!-- Email + icon -->
                            <label class="ob-field">
                                <span class="ob-label">Email</span>
                                <div class="ob-input-ico ob-ico-mail">
                                    <input class="ob-input" type="text" name="email" placeholder="Email" required>
                                </div>
                            </label>

                            <!-- Password + icon + eye -->
                            <label class="ob-field">
                                <span class="ob-label">Password</span>
                                <div class="ob-pass-wrapper ob-input-ico ob-ico-lock">
                                    <input class="ob-input" id="ob-password" type="password" name="password" placeholder="Password" required>
                                    <button type="button" class="ob-eye" aria-label="Show/Hide password"></button>
                                </div>
                            </label>

                            <div class="ob-row-between">
                                <a class="ob-link" href="<%=request.getContextPath()%>/forgot">Forgot password?</a>

                                <!-- Remember me (switch) -->
                                <label class="ob-switch">
                                    <input type="checkbox" id="ob-remember" name="remember" />
                                    <span class="ob-switch-ui"></span>
                                    <span class="ob-switch-text">Remember me</span>
                                </label>
                            </div>

                            <button class="ob-btn" type="submit">
                                <span class="ob-btn-text">Log In</span>
                            </button>

                            <p class="ob-foot">
                                Don't have an account?
                                <a class="ob-link" href="<%=request.getContextPath()%>/register">Register</a>
                            </p>
                        </form>
                    </section>
                </div>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/assets/jsremake/login.js"></script>
    </body>
</html>
