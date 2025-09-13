<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="vi" data-cpath="${pageContext.request.contextPath}">
<head>
  <meta charset="UTF-8">
  <title>Quản lý người dùng — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/cssremake/xe.css?v=1"><!-- tái dùng -->
</head>
<body class="ad-body">
<c:set var="cpath" value="${pageContext.request.contextPath}" />

<!-- ASIDE -->
<aside class="ad-aside">
  <div class="ad-brand"><a href="${cpath}/admin" class="ad-logo">Admin</a></div>
  <nav class="ad-menu">
    <a href="${cpath}/admin" class="ad-item">Dashboard</a>
    <a href="${cpath}/admin/xe" class="ad-item">Quản lý xe</a>
    <a href="${cpath}/admin/loaixe" class="ad-item">Loại xe</a>
    <a href="${cpath}/admin/users" class="ad-item is-active">Người dùng</a>
    <a href="${cpath}/home" class="ad-item">↩ Về trang chính</a>
  </nav>
</aside>

<!-- MAIN -->
<main class="ad-main">
  <header class="ad-topbar">
    <h1>Quản lý người dùng</h1>
    <div class="ad-actions">
      <a class="ad-btn" href="${cpath}/logout">Đăng xuất</a>
    </div>
  </header>

  <!-- BỘ LỌC -->
  <section class="ad-card">
    <header class="ad-card-head">
      <div class="ad-flex">
        <div>Tổng số <strong>${empty total ? (empty listUsers ? 0 : fn:length(listUsers)) : total}</strong> user</div>
      </div>

      <c:set var="sortParam" value="${empty param.sort ? 'new' : param.sort}" />
      <c:set var="roleParam" value="${param.role}" />
      <fmt:parseNumber var="sizeParamNum" value="${empty param.size ? 12 : param.size}" type="number" integerOnly="true"/>

      <form id="ad-users-form" class="ad-filters" method="get" action="${cpath}/admin/users">
        <input class="ad-input" type="text" name="q" value="${param.q}" placeholder="Tìm username, email, tên, SĐT, địa chỉ…">
        <select class="ad-select" name="role">
          <option value="">Tất cả vai trò</option>
          <option value="user"  <c:if test="${roleParam eq 'user'}">selected</c:if>>user</option>
          <option value="admin" <c:if test="${roleParam eq 'admin'}">selected</c:if>>admin</option>
        </select>
        <select class="ad-select" name="sort">
          <option value="new"       <c:if test="${sortParam eq 'new'}">selected</c:if>>Mới nhất</option>
          <option value="old"       <c:if test="${sortParam eq 'old'}">selected</c:if>>Cũ nhất</option>
          <option value="name_asc"  <c:if test="${sortParam eq 'name_asc'}">selected</c:if>>Tên A–Z</option>
          <option value="name_desc" <c:if test="${sortParam eq 'name_desc'}">selected</c:if>>Tên Z–A</option>
        </select>
        <select class="ad-select" name="size">
          <option value="12" <c:if test="${sizeParamNum == 12}">selected</c:if>>12/trang</option>
          <option value="24" <c:if test="${sizeParamNum == 24}">selected</c:if>>24/trang</option>
          <option value="48" <c:if test="${sizeParamNum == 48}">selected</c:if>>48/trang</option>
        </select>
        <button class="ad-btn ad-btn--ghost" type="submit">Lọc</button>
      </form>
    </header>

    <c:if test="${not empty flash}"><div class="ad-alert ad-alert--ok">${flash}</div></c:if>
    <c:if test="${not empty flash_err}"><div class="ad-alert ad-alert--err">${flash_err}</div></c:if>

    <!-- ＋ THÊM USER -->
    <details class="ad-card" style="margin-bottom:16px;">
      <summary class="ad-card-head"><strong>＋ Thêm user</strong></summary>
      <div class="ad-card-body">
        <form action="${cpath}/admin/users/add" method="post" class="ad-form">
          <div class="ad-grid-2">
            <label class="ad-field"><span>Username *</span><input class="ad-input" name="username" required /></label>
            <label class="ad-field"><span>Email *</span><input class="ad-input" type="email" name="email" required /></label>
            <label class="ad-field"><span>Họ tên *</span><input class="ad-input" name="fullname" required /></label>
            <label class="ad-field"><span>Mật khẩu *</span><input class="ad-input" type="password" name="password" required /></label>
            <label class="ad-field"><span>Điện thoại</span><input class="ad-input" name="phone" /></label>
            <label class="ad-field">
              <span>Vai trò *</span>
              <select class="ad-input" name="role" required>
                <option value="user">user</option>
                <option value="admin">admin</option>
              </select>
            </label>
            <label class="ad-field ad-col-2"><span>Địa chỉ</span><input class="ad-input" name="address" /></label>
          </div>
          <div class="ad-form-actions">
            <button class="ad-btn" type="submit">Lưu user</button>
            <button class="ad-btn ad-btn--ghost" type="reset">Xoá form</button>
          </div>
        </form>
      </div>
    </details>

    <!-- ✎ SỬA USER -->
    <details class="ad-card" id="editBox" style="margin-bottom:16px;">
      <summary class="ad-card-head"><strong>✎ Sửa user</strong></summary>
      <div class="ad-card-body">
        <form action="${cpath}/admin/users/update" method="post" class="ad-form" id="editForm">
          <input type="hidden" name="id" id="e-id"/>
          <div class="ad-grid-2">
            <label class="ad-field"><span>Username *</span><input class="ad-input" name="username" id="e-username" required /></label>
            <label class="ad-field"><span>Email *</span><input class="ad-input" type="email" name="email" id="e-email" required /></label>
            <label class="ad-field"><span>Họ tên *</span><input class="ad-input" name="fullname" id="e-fullname" required /></label>
            <label class="ad-field"><span>Mật khẩu (để trống nếu không đổi)</span><input class="ad-input" type="password" name="password" id="e-password" placeholder="Không nhập nếu giữ nguyên" /></label>
            <label class="ad-field"><span>Điện thoại</span><input class="ad-input" name="phone" id="e-phone"/></label>
            <label class="ad-field">
              <span>Vai trò *</span>
              <select class="ad-input" name="role" id="e-role" required>
                <option value="user">user</option>
                <option value="admin">admin</option>
              </select>
            </label>
            <label class="ad-field ad-col-2"><span>Địa chỉ</span><input class="ad-input" name="address" id="e-address"/></label>
          </div>
          <div class="ad-form-actions">
            <button class="ad-btn" type="submit">Cập nhật</button>
            <button class="ad-btn ad-btn--ghost" type="button" id="e-cancel">Đóng</button>
          </div>
        </form>
      </div>
    </details>

    <!-- BẢNG -->
    <div class="ad-table">
      <table>
        <thead>
          <tr>
            <th style="width:48px">#</th>
            <th style="width:160px">Username</th>
            <th>Email</th>
            <th style="width:180px">Họ tên</th>
            <th style="width:120px">Phone</th>
            <th style="width:100px">Role</th>
            <th>Địa chỉ</th>
            <th style="width:140px">Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty listUsers}">
              <tr><td colspan="8" class="ad-empty">Không có dữ liệu.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="u" items="${listUsers}">
                <tr>
                  <td>${u.id}</td>
                  <td>${u.username}</td>
                  <td>${u.email}</td>
                  <td>${u.fullname}</td>
                  <td><c:out value="${u.phone}" default="-"/></td>
                  <td><span class="ad-badge ${u.role eq 'admin' ? 'ad-badge--ok' : ''}">${u.role}</span></td>
                  <td><c:out value="${u.address}" default=""/></td>
                  <td>
                    <button type="button"
                            class="ad-link js-edit"
                            data-id="${u.id}"
                            data-username="${fn:escapeXml(u.username)}"
                            data-email="${fn:escapeXml(u.email)}"
                            data-fullname="${fn:escapeXml(u.fullname)}"
                            data-phone="${fn:escapeXml(u.phone)}"
                            data-role="${fn:escapeXml(u.role)}"
                            data-address="${fn:escapeXml(u.address)}">Sửa</button>

                    <form method="post" action="${cpath}/admin/users/delete" style="display:inline"
                          onsubmit="return confirm('Xóa user &quot;${fn:escapeXml(u.username)}&quot;?');">
                      <input type="hidden" name="id" value="${u.id}">
                      <button type="submit" class="ad-link" style="color:#ff6b6b">Xóa</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>

    <!-- PHÂN TRANG -->
    <c:if test="${not empty pages && pages > 1}">
      <nav class="ad-paging">
        <c:set var="cur" value="${empty page ? 1 : page}" />
        <c:forEach var="i" begin="1" end="${pages}">
          <a class="ad-page ${i == cur ? 'is-active' : ''}"
             href="${cpath}/admin/users?q=${fn:escapeXml(param.q)}&role=${param.role}&sort=${param.sort}&size=${param.size}&page=${i}">
            ${i}
          </a>
        </c:forEach>
      </nav>
    </c:if>
  </section>
</main>

<!-- JS: fill form Sửa + autosubmit filter -->
<script>
(function(){
  const editBox = document.getElementById('editBox');
  const form    = document.getElementById('editForm');
  if (editBox && form){
    const $ = sel => form.querySelector(sel);
    document.addEventListener('click', e=>{
      const btn = e.target.closest('.js-edit'); if(!btn) return;
      $('#e-id').value        = btn.dataset.id || '';
      $('#e-username').value  = btn.dataset.username || '';
      $('#e-email').value     = btn.dataset.email || '';
      $('#e-fullname').value  = btn.dataset.fullname || '';
      $('#e-phone').value     = btn.dataset.phone || '';
      $('#e-role').value      = btn.dataset.role || 'user';
      $('#e-address').value   = btn.dataset.address || '';
      $('#e-password').value  = '';
      editBox.setAttribute('open','');
      editBox.scrollIntoView({behavior:'smooth', block:'start'});
    });
    const btnCancel = document.getElementById('e-cancel');
    if(btnCancel) btnCancel.addEventListener('click', ()=> editBox.removeAttribute('open'));
  }

  const f = document.getElementById('ad-users-form');
  if(f){
    let t; const q = f.querySelector('input[name="q"]');
    if(q) q.addEventListener('input', ()=>{ clearTimeout(t); t=setTimeout(()=>f.submit(),400); });
    f.querySelectorAll('select').forEach(s => s.addEventListener('change', ()=>f.submit()));
  }
})();
</script>
</body>
</html>
