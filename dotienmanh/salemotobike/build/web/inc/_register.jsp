<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Register — Orange Theme Pro+</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/cssremake/register.css">
</head>
<body>

<div id="or-register"
     style="--or-left-image:url('<%=request.getContextPath()%>/assets/images/login.png'); --or-top-gap:72px;">
  <div class="or-stage">
    <div class="or-card">
      <aside class="or-left" aria-label="Register side image"></aside>

      <section class="or-right">
        <button class="or-close" type="button" aria-label="Close">×</button>
        <h3 class="or-heading">REGISTER</h3>

        <!-- Hiển thị lỗi tổng (nếu muốn) -->
        <c:if test="${not empty sessionScope.pass_err
                     or not empty sessionScope.email_err
                     or not empty sessionScope.phone_err}">
          <div class="or-alert">
            <c:if test="${not empty sessionScope.pass_err}"><div>${sessionScope.pass_err}</div></c:if>
            <c:if test="${not empty sessionScope.email_err}"><div>${sessionScope.email_err}</div></c:if>
            <c:if test="${not empty sessionScope.phone_err}"><div>${sessionScope.phone_err}</div></c:if>
          </div>
        </c:if>

        <!-- Lấy dữ liệu preserve -->
        <c:set var="pres" value="${sessionScope.reg_preserve}" />

        <form class="or-form" method="post" action="<%=request.getContextPath()%>/register" novalidate>
          <div class="or-grid">
            <!-- Row 1 -->
            <label class="or-field">
              <span class="or-label">Username</span>
              <div class="or-input-ico or-ico-user">
                <input class="or-input" type="text" name="username" placeholder="Username"
                       value="${pres.username}" required>
              </div>
              <small class="or-help"></small>
            </label>

            <label class="or-field">
              <span class="or-label">Phone</span>
              <div class="or-input-ico or-ico-phone">
                <input class="or-input" type="tel" name="phone" placeholder="Phone"
                       value="${pres.phone}" required>
              </div>
              <small class="or-help">
                <c:if test="${not empty sessionScope.phone_err}">${sessionScope.phone_err}</c:if>
              </small>
            </label>

            <!-- Row 2 -->
            <label class="or-field">
              <span class="or-label">Email</span>
              <div class="or-input-ico or-ico-mail">
                <input class="or-input" type="email" name="email" placeholder="Email"
                       value="${pres.email}" required>
              </div>
              <small class="or-help">
                <c:if test="${not empty sessionScope.email_err}">${sessionScope.email_err}</c:if>
              </small>
            </label>

            <label class="or-field">
              <span class="or-label">Full name</span>
              <div class="or-input-ico or-ico-id">
                <input class="or-input" type="text" name="fullname" placeholder="Full name"
                       value="${pres.fullname}" required>
              </div>
              <small class="or-help"></small>
            </label>

            <!-- Row 3 -->
            <label class="or-field">
              <span class="or-label">Password</span>
              <div class="or-pass-wrapper or-input-ico or-ico-lock">
                <input class="or-input" id="or-password" type="password" name="password" placeholder="Password" required>
                <button type="button" class="or-eye" aria-label="Show/Hide password"></button>
              </div>
              <small class="or-help">
                <c:if test="${not empty sessionScope.pass_err}">${sessionScope.pass_err}</c:if>
              </small>
            </label>

            <label class="or-field">
              <span class="or-label">Confirm password</span>
              <div class="or-pass-wrapper or-input-ico or-ico-lock">
                <input class="or-input" id="or-confirm" type="password" name="confirm" placeholder="Confirm password" required>
                <button type="button" class="or-eye or-eye-confirm" aria-label="Show/Hide confirm password"></button>
              </div>
              <small class="or-help"></small>
            </label>

            <!-- Row 4 -->
            <label class="or-field or-col-span-2">
              <span class="or-label">Address</span>
              <div class="or-input-ico or-ico-home">
                <input class="or-input" type="text" name="address" placeholder="Address"
                       value="${pres.address}" required>
              </div>
              <small class="or-help"></small>
            </label>

            <div class="or-col-span-2">
              <button class="or-btn" type="submit">
                <span class="or-btn-text">Create Account</span>
              </button>
            </div>

            <p class="or-foot or-col-span-2">
              Already have an account?
              <a class="or-link" href="<%=request.getContextPath()%>/login">Log in</a>
            </p>
          </div>
        </form>
      </section>
    </div>
  </div>
</div>

<!-- Sau khi render xong, dọn session errors & preserve để không “kẹt” -->
<c:remove var="pass_err" scope="session"/>
<c:remove var="email_err" scope="session"/>
<c:remove var="phone_err" scope="session"/>
<c:remove var="reg_preserve" scope="session"/>

<script src="<%=request.getContextPath()%>/assets/jsremake/register.js"></script>
</body>
</html>
