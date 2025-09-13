<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="cpath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${cpath}/assets/cssremake/listfav.css?v=4"/>

<!-- HERO lớn giống ảnh bạn gửi -->
<section class="fav-hero">
  <div class="fav-hero-row">
    <div>
      <h1 class="fav-title">Yêu thích của bạn</h1>
      <p class="fav-sub">Những mẫu xe bạn đã lưu lại.</p>
    </div>

    <div class="fav-total-chip" aria-live="polite" aria-atomic="true">
      <span class="dot"></span> Tổng số:
      <strong data-fav-total>${empty listFavXe ? 0 : fn:length(listFavXe)}</strong>
    </div>
  </div>

  <!-- Thanh công cụ -->
  <div class="fav-toolbar">
    <div class="fav-search" role="search">
      <svg width="16" height="16" viewBox="0 0 24 24" aria-hidden="true">
        <path d="M10 18a8 8 0 1 1 5.293-14.001A8 8 0 0 1 10 18Zm11 3-5.4-5.4"
              fill="none" stroke="#6b7280" stroke-width="2" stroke-linecap="round"/>
      </svg>
      <input type="search" placeholder="Tìm theo tên xe..." data-fav-search />
    </div>

    <select class="fav-select" data-fav-sort aria-label="Sắp xếp">
      <option value="default">Sắp xếp</option>
      <option value="az">Tên A → Z</option>
      <option value="price-asc">Giá tăng dần</option>
      <option value="price-desc">Giá giảm dần</option>
    </select>
  </div>
</section>

<!-- EMPTY rỗng hoàn toàn -->
<c:if test="${empty listFavXe}">
  <div class="fav-empty is-show">
    <p>Danh sách rỗng. Hãy nhấn ❤️ ở trang sản phẩm để thêm xe vào yêu thích.</p>
    <a class="btn btn-primary" href="${cpath}/xemtatca">Khám phá xe</a>
  </div>
</c:if>

<!-- EMPTY khi lọc/tìm không ra kết quả -->
<div class="fav-empty-filter">Không tìm thấy xe phù hợp với tiêu chí của bạn.</div>

<!-- GRID -->
<c:if test="${not empty listFavXe}">
  <div class="fav-grid">
    <c:forEach var="xe" items="${listFavXe}">
      <article class="fav-card"
               data-id="${xe.id}"
               data-name="${fn:toLowerCase(xe.tenxe)}"
               data-price="${xe.giaban}"
               data-loai="${xe.loaixe}">
        <a class="fav-thumb" href="${cpath}/xemchitiet?id=${xe.id}" title="${xe.tenxe}">
          <img src="${cpath}/assets/images/${empty xe.img ? xe.img1 : xe.img}"
               alt="${xe.tenxe}" loading="lazy" decoding="async"
               onerror="this.onerror=null;this.src='${cpath}/assets/images/placeholder.png';" />
        </a>

        <div class="fav-info">
          <h3 class="fav-name"><a href="${cpath}/xemchitiet?id=${xe.id}">${xe.tenxe}</a></h3>
          <div class="fav-price">
            <fmt:formatNumber value="${xe.giaban}" type="number" pattern="#,##0"/> ₫
          </div>
          <div class="fav-actions">
            <a class="btn btn-primary" href="${cpath}/xemchitiet?id=${xe.id}">Xem chi tiết</a>
            <button class="btn btn-ghost js-remove-fav" data-id="${xe.id}" type="button" title="Xóa khỏi yêu thích">Xóa</button>
          </div>
        </div>
      </article>
    </c:forEach>
  </div>
</c:if>

<!-- toast -->
<div class="fav-toast" style="display:none"></div>

<script defer src="${cpath}/assets/jsremake/favorite.js?v=4"></script>
