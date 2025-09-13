<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="vi" data-cpath="${pageContext.request.contextPath}">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý xe — Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/cssremake/xe.css?v=1">
    </head>
    <body class="ad-body">
        <c:set var="cpath" value="${pageContext.request.contextPath}" />

        <!-- ASIDE -->
        <aside class="ad-aside">
            <div class="ad-brand"><a href="${cpath}/admin" class="ad-logo">Admin</a></div>
            <nav class="ad-menu">
                <a href="${cpath}/admin" class="ad-item">Dashboard</a>
                <a href="${cpath}/admin/xe" class="ad-item is-active">Quản lý xe</a>
                <a href="${cpath}/admin/loaixe" class="ad-item">Loại xe</a>
                <a href="${cpath}/admin/users" class="ad-item">Người dùng</a>
 
                <a href="${cpath}/home" class="ad-item">↩ Về trang chính</a>
            </nav>
        </aside>

        <!-- MAIN -->
        <main class="ad-main">
            <header class="ad-topbar">
                <h1>Quản lý xe</h1>
                <div class="ad-actions">
                    <a class="ad-btn" href="${cpath}/logout">Đăng xuất</a>
                </div>
            </header>

            <!-- BỘ LỌC / TÌM KIẾM -->
            <section class="ad-card">
               <header class="ad-card-head">
  <div class="ad-flex">
    <div>Tổng số <strong>${empty total ? (empty listXe ? 0 : fn:length(listXe)) : total}</strong> xe</div>
  </div>

  <!-- Chuẩn hoá tham số (không lặp lại) -->
  <fmt:parseNumber var="loaiParam" value="${param.loai}" type="number" integerOnly="true"/>
  <fmt:parseNumber var="sizeParamNum" value="${empty param.size ? 12 : param.size}" type="number" integerOnly="true"/>
  <c:set var="sortParam" value="${empty param.sort ? 'new' : param.sort}" />

  <!-- Bộ lọc -->
  <form id="ad-xe-form" class="ad-filters" method="get" action="${cpath}/admin/xe">
    <input class="ad-input" type="text" name="q" value="${param.q}" placeholder="Tìm tên, tính năng, thiết kế…">

    <!-- Loại -->
    <select class="ad-select" name="loai">
      <option value="">Tất cả loại</option>
      <c:forEach var="lx" items="${dsLoai}">
        <option value="${lx.idloaixe}"
                <c:if test="${loaiParam != null and loaiParam == lx.idloaixe}">selected</c:if>>
          ${lx.tenloaixe}
        </option>
      </c:forEach>
    </select>

    <!-- Sắp xếp -->
    <select class="ad-select" name="sort">
      <option value="new"  <c:if test="${sortParam eq 'new'}">selected</c:if>>Mới nhất</option>
      <option value="old"  <c:if test="${sortParam eq 'old'}">selected</c:if>>Cũ nhất</option>
      <option value="asc"  <c:if test="${sortParam eq 'asc'}">selected</c:if>>Giá tăng dần</option>
      <option value="desc" <c:if test="${sortParam eq 'desc'}">selected</c:if>>Giá giảm dần</option>
    </select>

    <!-- Kích thước trang -->
    <select class="ad-select" name="size">
      <option value="12" <c:if test="${sizeParamNum == 12}">selected</c:if>>12/trang</option>
      <option value="24" <c:if test="${sizeParamNum == 24}">selected</c:if>>24/trang</option>
      <option value="48" <c:if test="${sizeParamNum == 48}">selected</c:if>>48/trang</option>
    </select>

    <button class="ad-btn ad-btn--ghost" type="submit">Lọc</button>
  </form>
</header>


                <c:if test="${not empty flash}">
                    <div class="ad-alert ad-alert--ok">${flash}</div>
                </c:if>
                <c:if test="${not empty flash_err}">
                    <div class="ad-alert ad-alert--err">${flash_err}</div>
                </c:if>

                <!-- THÊM XE -->
                <details class="ad-card" id="addBox" style="margin-bottom:16px;">
                    <summary class="ad-card-head"><strong>＋ Thêm xe</strong></summary>
                    <div class="ad-card-body">
                        <form action="${cpath}/admin/xe/add" method="post" class="ad-form">
                            <div class="ad-grid-2">
                                <label class="ad-field">
                                    <span>Tên xe *</span>
                                    <input class="ad-input" name="tenxe" required />
                                </label>
                                <label class="ad-field">
                                    <span>Giá bán (VND) *</span>
                                    <input class="ad-input" name="giaban" inputmode="numeric" required />
                                </label>

                                <label class="ad-field">
                                    <span>Loại xe *</span>
                                    <select class="ad-input" name="loaixe" required>
                                        <c:forEach var="lx" items="${dsLoai}">
                                            <option value="${lx.idloaixe}">${lx.tenloaixe}</option>
                                        </c:forEach>
                                    </select>
                                </label>
                                <label class="ad-field">
                                    <span>Ảnh chính (tên file/URL) *</span>
                                    <input class="ad-input" name="img" placeholder="vd: cbr150r.png" required />
                                </label>

                                <label class="ad-field"><span>Ảnh phụ 1</span><input class="ad-input" name="img1"/></label>
                                <label class="ad-field"><span>Ảnh phụ 2</span><input class="ad-input" name="img2"/></label>
                                <label class="ad-field"><span>Ảnh phụ 3</span><input class="ad-input" name="img3"/></label>
                                <label class="ad-field"><span>Ảnh phụ 4</span><input class="ad-input" name="img4"/></label>

                                <label class="ad-field ad-col-2">
                                    <span>Tính năng</span>
                                    <textarea class="ad-input" name="tinhnang" rows="2"></textarea>
                                </label>
                                <label class="ad-field ad-col-2">
                                    <span>Thiết kế</span>
                                    <textarea class="ad-input" name="thietke" rows="2"></textarea>
                                </label>
                                <label class="ad-field ad-col-2">
                                    <span>Động cơ</span>
                                    <textarea class="ad-input" name="dongco" rows="2"></textarea>
                                </label>
                                <label class="ad-field ad-col-2">
                                    <span>Tiện ích & an toàn</span>
                                    <textarea class="ad-input" name="tienichantoan" rows="2"></textarea>
                                </label>

                                <label class="ad-check">
                                    <input type="checkbox" name="xemoi" value="1" />
                                    <span>Mới?</span>
                                </label>
                            </div>

                            <div class="ad-form-actions">
                                <button class="ad-btn" type="submit">Lưu xe</button>
                                <button class="ad-btn ad-btn--ghost" type="reset">Xoá form</button>
                            </div>
                        </form>
                    </div>
                </details>

                <!-- SỬA XE -->
                <details class="ad-card" id="editBox" style="margin-bottom:16px;">
                    <summary class="ad-card-head"><strong>✎ Sửa xe</strong></summary>
                    <div class="ad-card-body">
                        <form action="${cpath}/admin/xe/update" method="post" class="ad-form" id="editForm">
                            <input type="hidden" name="id" id="e-id"/>

                            <div class="ad-grid-2">
                                <label class="ad-field">
                                    <span>Tên xe *</span>
                                    <input class="ad-input" name="tenxe" id="e-tenxe" required />
                                </label>

                                <label class="ad-field">
                                    <span>Giá bán (VND) *</span>
                                    <input class="ad-input" name="giaban" id="e-giaban" inputmode="numeric" required />
                                </label>

                                <label class="ad-field">
                                    <span>Loại xe *</span>
                                    <select class="ad-input" name="loaixe" id="e-loaixe" required>
                                        <c:forEach var="lx" items="${dsLoai}">
                                            <option value="${lx.idloaixe}">${lx.tenloaixe}</option>
                                        </c:forEach>
                                    </select>
                                </label>

                                <label class="ad-field">
                                    <span>Ảnh chính (tên file/URL) *</span>
                                    <input class="ad-input" name="img" id="e-img" required />
                                </label>

                                <label class="ad-field"><span>Ảnh phụ 1</span><input class="ad-input" name="img1" id="e-img1"/></label>
                                <label class="ad-field"><span>Ảnh phụ 2</span><input class="ad-input" name="img2" id="e-img2"/></label>
                                <label class="ad-field"><span>Ảnh phụ 3</span><input class="ad-input" name="img3" id="e-img3"/></label>
                                <label class="ad-field"><span>Ảnh phụ 4</span><input class="ad-input" name="img4" id="e-img4"/></label>

                                <label class="ad-field ad-col-2">
                                    <span>Tính năng</span>
                                    <textarea class="ad-input" name="tinhnang" id="e-tinhnang" rows="2"></textarea>
                                </label>
                                <label class="ad-field ad-col-2">
                                    <span>Thiết kế</span>
                                    <textarea class="ad-input" name="thietke" id="e-thietke" rows="2"></textarea>
                                </label>
                                <label class="ad-field ad-col-2">
                                    <span>Động cơ</span>
                                    <textarea class="ad-input" name="dongco" id="e-dongco" rows="2"></textarea>
                                </label>
                                <label class="ad-field ad-col-2">
                                    <span>Tiện ích & an toàn</span>
                                    <textarea class="ad-input" name="tienichantoan" id="e-tienichantoan" rows="2"></textarea>
                                </label>

                                <label class="ad-check">
                                    <input type="checkbox" name="xemoi" id="e-xemoi" value="1"/>
                                    <span>Mới?</span>
                                </label>
                            </div>

                            <div class="ad-form-actions">
                                <button class="ad-btn" type="submit">Cập nhật</button>
                                <button class="ad-btn ad-btn--ghost" type="button" id="e-cancel">Đóng</button>
                            </div>
                        </form>
                    </div>
                </details>

                <!-- BẢNG DỮ LIỆU -->
                <div class="ad-table">
                    <table>
                        <thead>
                            <tr>
                                <th style="width:64px">Ảnh</th>
                                <th>Tên xe</th>
                                <th style="width:160px">Giá bán</th>
                                <th style="width:160px">Loại</th>
                                <th style="width:100px">Mới?</th>
                                <th style="width:120px">Chi tiết</th>
                                <th style="width:160px">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty listXe}">
                                    <tr><td colspan="7" class="ad-empty">Không có dữ liệu.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="xe" items="${listXe}">
                                        <c:set var="thumb" value="${empty xe.img ? (empty xe.img1 ? (empty xe.img2 ? (empty xe.img3 ? xe.img4 : xe.img3) : xe.img2) : xe.img1) : xe.img}" />
                                        <tr>
                                            <td>
                                                <img class="ad-thumb"
                                                     src="${cpath}/assets/images/${thumb}"
                                                     alt="${xe.tenxe}"
                                                     onerror="this.onerror=null;this.src='${cpath}/assets/images/placeholder.png'">
                                            </td>
                                            <td>${xe.tenxe}</td>
                                            <td><fmt:formatNumber value="${xe.giaban}" type="number" pattern="#,##0"/> ₫</td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty mapLoai}">
                                                        <c:out value="${mapLoai[xe.loaixe]}"/>
                                                    </c:when>
                                                    <c:otherwise>${xe.loaixe}</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${xe.xemoi == true}"><span class="ad-badge ad-badge--ok">Mới</span></c:when>
                                                    <c:otherwise><span class="ad-badge">-</span></c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td><a class="ad-link" href="${cpath}/xemchitiet?id=${xe.id}">Xem</a></td>

                                            <td>
                                                <button type="button"
                                                        class="ad-link js-edit"
                                                        data-id="${xe.id}"
                                                        data-tenxe="${fn:escapeXml(xe.tenxe)}"
                                                        data-giaban="${xe.giaban}"
                                                        data-loaixe="${xe.loaixe}"
                                                        data-img="${fn:escapeXml(xe.img)}"
                                                        data-img1="${fn:escapeXml(xe.img1)}"
                                                        data-img2="${fn:escapeXml(xe.img2)}"
                                                        data-img3="${fn:escapeXml(xe.img3)}"
                                                        data-img4="${fn:escapeXml(xe.img4)}"
                                                        data-xemoi="${xe.xemoi ? '1' : '0'}">
                                                    Sửa
                                                </button>

                                                <form method="post" action="${cpath}/admin/xe/delete" style="display:inline"
                                                      onsubmit="return confirm('Xóa xe &quot;${fn:escapeXml(xe.tenxe)}&quot;?');">
                                                    <input type="hidden" name="id" value="${xe.id}">
                                                    <button type="submit" class="ad-link" style="color:#ff6b6b">Xóa</button>
                                                </form>

                                                <textarea hidden class="js-long" data-for="tinhnang">${fn:escapeXml(xe.tinhnang)}</textarea>
                                                <textarea hidden class="js-long" data-for="thietke">${fn:escapeXml(xe.thietke)}</textarea>
                                                <textarea hidden class="js-long" data-for="dongco">${fn:escapeXml(xe.dongco)}</textarea>
                                                <textarea hidden class="js-long" data-for="tienichantoan">${fn:escapeXml(xe.tienichantoan)}</textarea>
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
                               href="${cpath}/admin/xe?q=${fn:escapeXml(param.q)}&loai=${param.loai}&sort=${param.sort}&size=${param.size}&page=${i}">
                                ${i}
                            </a>
                        </c:forEach>
                    </nav>
                </c:if>
            </section>
        </main>

        <!-- JS fill form Sửa (giữ nguyên) -->
        <script>
            (function () {
                const editBox = document.getElementById('editBox');
                const form = document.getElementById('editForm');
                if (!editBox || !form)
                    return;
                const $ = (sel) => form.querySelector(sel);

                document.addEventListener('click', function (e) {
                    const btn = e.target.closest('.js-edit');
                    if (!btn)
                        return;
                    const row = btn.closest('tr');
                    $('#e-id').value = btn.dataset.id || '';
                    $('#e-tenxe').value = btn.dataset.tenxe || '';
                    $('#e-giaban').value = btn.dataset.giaban || '';
                    $('#e-loaixe').value = btn.dataset.loaixe || '';
                    $('#e-img').value = btn.dataset.img || '';
                    $('#e-img1').value = btn.dataset.img1 || '';
                    $('#e-img2').value = btn.dataset.img2 || '';
                    $('#e-img3').value = btn.dataset.img3 || '';
                    $('#e-img4').value = btn.dataset.img4 || '';
                    $('#e-xemoi').checked = (btn.dataset.xemoi === '1');

                    const getLong = (name) => {
                        const el = row.querySelector('.js-long[data-for="' + name + '"]');
                        return el ? el.textContent : '';
                    };
                    $('#e-tinhnang').value = getLong('tinhnang');
                    $('#e-thietke').value = getLong('thietke');
                    $('#e-dongco').value = getLong('dongco');
                    $('#e-tienichantoan').value = getLong('tienichantoan');

                    editBox.setAttribute('open', '');
                    editBox.scrollIntoView({behavior: 'smooth', block: 'start'});
                });

                const btnCancel = document.getElementById('e-cancel');
                if (btnCancel)
                    btnCancel.addEventListener('click', () => {
                        editBox.removeAttribute('open');
                    });
            })();
        </script>
        <script>
            (function () {
                const form = document.getElementById('ad-xe-form');
                if (!form)
                    return;
                let t;
                const q = form.querySelector('input[name="q"]');
                if (q)
                    q.addEventListener('input', () => {
                        clearTimeout(t);
                        t = setTimeout(() => form.submit(), 400);
                    });
                form.querySelectorAll('select').forEach(s => s.addEventListener('change', () => form.submit()));
            })();
        </script>

        <script src="${cpath}/assets/jsremake/admin-xe.js?v=1"></script>

    </body>
</html>
