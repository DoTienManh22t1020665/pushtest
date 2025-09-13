<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<c:set var="cpath" value="${pageContext.request.contextPath}" />

<c:choose>
  <c:when test="${empty xe}">
    <div class="page"><p>Không tìm thấy sản phẩm.</p></div>
  </c:when>
  <c:otherwise>

    <c:set var="hero"
           value="${not empty xe.img1 ? xe.img1
                 : (not empty xe.img2 ? xe.img2
                 : (not empty xe.img3 ? xe.img3
                 : (not empty xe.img4 ? xe.img4 : xe.img)))}"/>

    <link rel="stylesheet" href="${cpath}/assets/cssremake/xemchitiet.css?v=6"/>

    <!-- NEW: biến hiển thị cho nút yêu thích -->
    <c:set var="favActiveClass" value="${isFav ? ' is-active' : ''}"/>
    <c:set var="favPressed"     value="${isFav ? 'true' : 'false'}"/>
    <c:set var="favTitle"       value="${isFav ? 'Bỏ yêu thích' : 'Yêu thích'}"/>
    <c:set var="favText"        value="${favTitle}"/>

    <div class="page pd">
      <!-- Breadcrumb -->
      <nav class="pd-crumbs" aria-label="Breadcrumb">
        <a href="${cpath}/home">Trang chủ</a><span aria-hidden="true">›</span>
        <a href="${cpath}/xemtatca">Sản phẩm</a><span aria-hidden="true">›</span>
        <span class="current"><c:out value="${xe.tenxe}"/></span>
      </nav>

      <!-- Header -->
      <header class="pd-header">
        <h1 class="pd-title"><c:out value="${xe.tenxe}"/></h1>
        <span class="pd-chip">Mã: <strong><c:out value="${xe.id}"/></strong></span>
      </header>

      <!-- Content -->
      <section class="pd-body">
        <!-- LEFT: media -->
        <div class="pd-media" aria-label="Bộ sưu tập ảnh">
          <figure class="pd-hero" aria-live="polite">
            <img id="pd-hero"
                 src="${cpath}/assets/images/${hero}"
                 alt="${xe.tenxe}"
                 loading="eager"
                 onerror="this.onerror=null;this.src='${cpath}/assets/images/placeholder.png'"/>
            <button class="pd-zoom-btn" type="button" aria-label="Phóng to ảnh">
              <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <circle cx="11" cy="11" r="7"></circle><path d="m21 21-4.35-4.35"></path>
              </svg>
            </button>
          </figure>

          <div class="pd-mini" data-autoplay="true" data-interval="3500">
            <button class="pd-mini-prev" type="button" aria-label="Ảnh trước">
              <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
            </button>

            <div class="pd-mini-viewport">
              <div class="pd-mini-track">
                <c:if test="${not empty xe.img1}">
                  <button class="pd-mini-item is-active" data-full="${cpath}/assets/images/${xe.img1}">
                    <img src="${cpath}/assets/images/${xe.img1}" alt="Ảnh 1"/>
                  </button>
                </c:if>
                <c:if test="${not empty xe.img2}">
                  <button class="pd-mini-item" data-full="${cpath}/assets/images/${xe.img2}">
                    <img src="${cpath}/assets/images/${xe.img2}" alt="Ảnh 2"/>
                  </button>
                </c:if>
                <c:if test="${not empty xe.img3}">
                  <button class="pd-mini-item" data-full="${cpath}/assets/images/${xe.img3}">
                    <img src="${cpath}/assets/images/${xe.img3}" alt="Ảnh 3"/>
                  </button>
                </c:if>
                <c:if test="${not empty xe.img4}">
                  <button class="pd-mini-item" data-full="${cpath}/assets/images/${xe.img4}">
                    <img src="${cpath}/assets/images/${xe.img4}" alt="Ảnh 4"/>
                  </button>
                </c:if>
              </div>
            </div>

            <button class="pd-mini-next" type="button" aria-label="Ảnh tiếp">
              <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
            </button>
          </div>

          <div class="pd-mini-dots" role="tablist" aria-label="Chọn ảnh"></div>
        </div>

        <!-- RIGHT: info -->
        <aside class="pd-info">
          <div class="pd-card pd-price">
            <div class="pd-price-head">
              <div class="pd-price-label">Giá bán</div>
              <div class="pd-utility">
                <button class="pd-icbtn pd-share" type="button" aria-label="Chia sẻ">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-6"/><path d="M16 12a4 4 0 1 1-7.5-2.1"/><path d="M22 12l-4-4"/><path d="M22 12l-4 4"/></svg>
                </button>
                <button class="pd-icbtn pd-print" type="button" aria-label="In">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9V2h12v7"/><rect x="6" y="13" width="12" height="8" rx="2"/><path d="M6 17h12"/><path d="M6 13H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2h-2"/></svg>
                </button>
              </div>
            </div>

            <strong class="pd-price-number">
              <fmt:formatNumber value="${xe.giaban}" type="number" pattern="#,##0"/> ₫
            </strong>

            <div class="pd-actions">
              <a class="pd-btn pd-btn--cta" href="${cpath}/dat-lich-lai-thu?id=${xe.id}">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                <span>Đặt lịch lái thử</span>
              </a>
              <a class="pd-btn pd-btn--ghost" href="${cpath}/so-sanh/them?id=${xe.id}">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3h7v18H3zM14 9h7v12h-7z"/></svg>
                So sánh
              </a>

              <!-- NEW: nút Yêu thích cập nhật theo DB -->
              <button
                class="pd-btn pd-btn--ghost pd-fav${favActiveClass}"
                type="button"
                data-id="${xe.id}"
                aria-pressed="${favPressed}"
                title="${favTitle}">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.6l-1-1a5.5 5.5 0 1 0-7.8 7.8l1 1L12 22l7.8-8.6 1-1a5.5 5.5 0 0 0 0-7.8z"/>
                </svg>
                <span class="pd-fav-text">${favText}</span>
              </button>
            </div>
          </div>

          <!-- Accordion specs -->
          <div class="pd-accordion" role="tablist">
            <c:if test="${not empty xe.tinhnang}">
              <section class="pd-acc is-open">
                <button class="pd-acc-head" type="button" aria-expanded="true">
                  <span class="pd-acc-ico">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06A1.65 1.65 0 0 0 15 19.4a1.65 1.65 0 0 0-1 .6 1.65 1.65 0 0 0-.33 1.82 2 2 0 1 1-3.32 0A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1-.6 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.6 15a1.65 1.65 0 0 0-.6-1 1.65 1.65 0 0 0-1.82-.33 2 2 0 1 1 0-3.32A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0 .6-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.6a1.65 1.65 0 0 0 1-.6 1.65 1.65 0 0 0 .33-1.82 2 2 0 1 1 3.32 0 1.65 1.65 0 0 0 .33 1.82 1.65 1.65 0 0 0 1 .6 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9c.24.3.44.64.6 1a1.65 1.65 0 0 0 1.82.33 2 2 0 1 1 0 3.32 1.65 1.65 0 0 0-1.82.33 1.65 1.65 0 0 0-.6 1Z"/></svg>
                  </span>
                  <span>Tính năng</span>
                </button>
                <div class="pd-acc-panel"><p><c:out value="${xe.tinhnang}"/></p></div>
              </section>
            </c:if>

            <c:if test="${not empty xe.thietke}">
              <section class="pd-acc is-open">
                <button class="pd-acc-head" type="button" aria-expanded="true">
                  <span class="pd-acc-ico">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                  </span>
                  <span>Thiết kế</span>
                </button>
                <div class="pd-acc-panel"><p><c:out value="${xe.thietke}"/></p></div>
              </section>
            </c:if>

            <c:if test="${not empty xe.dongco}">
              <section class="pd-acc is-open">
                <button class="pd-acc-head" type="button" aria-expanded="true">
                  <span class="pd-acc-ico">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 9h16v6H4z"/><path d="M9 9V5h6v4"/><path d="M2 12h2M20 12h2M12 15v4"/></svg>
                  </span>
                  <span>Động cơ</span>
                </button>
                <div class="pd-acc-panel"><p><c:out value="${xe.dongco}"/></p></div>
              </section>
            </c:if>

            <c:if test="${not empty xe.tienichantoan}">
              <section class="pd-acc is-open">
                <button class="pd-acc-head" type="button" aria-expanded="true">
                  <span class="pd-acc-ico">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"/><path d="m9 12 2 2 4-4"/></svg>
                  </span>
                  <span>Tiện ích &amp; An toàn</span>
                </button>
                <div class="pd-acc-panel"><p><c:out value="${xe.tienichantoan}"/></p></div>
              </section>
            </c:if>
          </div>
        </aside>
      </section>
    </div>

    <!-- Top sticky bar -->
    <div class="pd-topbar" role="region" aria-label="Tóm tắt sản phẩm">
      <div class="pd-topbar__inner">
        <strong class="pd-topbar__title"><c:out value="${xe.tenxe}"/></strong>
        <span class="pd-topbar__price">
          <fmt:formatNumber value="${xe.giaban}" type="number" pattern="#,##0"/> ₫
        </span>
        <a class="pd-btn pd-btn--cta pd-topbar__cta" href="${cpath}/dat-lich-lai-thu?id=${xe.id}"><span>Đặt lịch</span></a>
      </div>
    </div>

    <!-- LIGHTBOX -->
    <div class="pd-lightbox" aria-hidden="true" hidden>
      <div class="pd-lb-backdrop"></div>
      <div class="pd-lb-stage" role="dialog" aria-modal="true" aria-label="Xem ảnh lớn">
        <button class="pd-lb-close" type="button" aria-label="Đóng">✕</button>
        <button class="pd-lb-prev"  type="button" aria-label="Ảnh trước">‹</button>
        <button class="pd-lb-next"  type="button" aria-label="Ảnh tiếp">›</button>
        <img class="pd-lb-img" alt="${xe.tenxe}"
             onerror="this.onerror=null;this.src='${cpath}/assets/images/placeholder.png'"/>
        <div class="pd-lb-sources" hidden>
          <c:if test="${not empty xe.img1}"><span data-src="${cpath}/assets/images/${xe.img1}"></span></c:if>
          <c:if test="${not empty xe.img2}"><span data-src="${cpath}/assets/images/${xe.img2}"></span></c:if>
          <c:if test="${not empty xe.img3}"><span data-src="${cpath}/assets/images/${xe.img3}"></span></c:if>
          <c:if test="${not empty xe.img4}"><span data-src="${cpath}/assets/images/${xe.img4}"></span></c:if>
          <span data-src="${cpath}/assets/images/${hero}"></span>
        </div>
      </div>
    </div>

    <!-- NEW: cấp CPath cho JS và nạp favorite.js -->
    <script>
      window.__PD_CONTEXT__ = { cpath: "${cpath}" };
      window.CPATH = "${cpath}";
    </script>
    <script src="${cpath}/assets/jsremake/xemchitiet.js?v=6" defer></script>
    <script src="${cpath}/assets/jsremake/favorite.js?v=1" defer></script>

  </c:otherwise>
</c:choose>
