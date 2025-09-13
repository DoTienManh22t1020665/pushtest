
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- khoảng trống giữa Lý do và Footer -->
<div class="hb-space-after-reasons" aria-hidden="true"></div>

<!-- ===== FOOTER ===== -->

<footer class="hb-footer" role="contentinfo">
  <div class="hb-container">
    <div class="hb-ft-grid">
      <!-- COL 1: Thương hiệu -->
      <section class="hb-ft-brand">
        <a class="hb-ft-logo" href="<c:url value='/'/>" aria-label="Trang chủ">
          <!-- TODO: thay logo -->
          <img src="<c:url value='/assets/icon/logo.png'/>" alt="iMotorbike">
        </a>
        <p class="hb-ft-desc">Xe máy chính hãng • Giá minh bạch • Giao xe nhanh toàn quốc.</p>
        <div class="hb-ft-social" aria-label="Kết nối">
          <a href="#" aria-label="Facebook">
            <svg viewBox="0 0 24 24" width="18" height="18"><path fill="currentColor" d="M22 12a10 10 0 1 0-11.6 9.9v-7h-2.3V12h2.3V9.8c0-2.3 1.4-3.6 3.5-3.6.9 0 1.9.2 1.9.2v2.1H14c-1.1 0-1.5.7-1.5 1.4V12h2.6l-.4 2.9h-2.2v7A10 10 0 0 0 22 12"/></svg>
          </a>
          <a href="#" aria-label="YouTube">
            <svg viewBox="0 0 24 24" width="18" height="18"><path fill="currentColor" d="M23.5 7.1a3 3 0 0 0-2.1-2.1C19.3 4.5 12 4.5 12 4.5s-7.3 0-9.4.5A3 3 0 0 0 .5 7.1 31 31 0 0 0 0 12a31 31 0 0 0 .5 4.9 3 3 0 0 0 2.1 2.1c2.1.6 9.4.6 9.4.6s7.3 0 9.4-.6a3 3 0 0 0 2.1-2.1A31 31 0 0 0 24 12a31 31 0 0 0-.5-4.9ZM9.8 15.5v-7l6.2 3.5-6.2 3.5Z"/></svg>
          </a>
          <a href="#" aria-label="Zalo">
            <svg viewBox="0 0 24 24" width="18" height="18"><circle cx="12" cy="12" r="10" fill="currentColor" opacity=".12"/><path d="M7 8h7v2H9v1.1h5V12H9v1.1h5V14H7z" fill="currentColor"/></svg>
          </a>
        </div>
      </section>

      <!-- COL 2: Sản phẩm -->
      <nav class="hb-ft-col" aria-label="Sản phẩm">
        <h3 class="hb-ft-h3">Sản phẩm</h3>
        <ul class="hb-ft-list">
          <li><a href="<c:url value='/san-pham?type=tay-ga'/>">Tay ga</a></li>
          <li><a href="<c:url value='/san-pham?type=xe-so'/>">Xe số</a></li>
          <li><a href="<c:url value='/san-pham?type=con-tay'/>">Côn tay</a></li>
          <li><a href="<c:url value='/san-pham?type=xe-dien'/>">Xe điện</a></li>
          
        </ul>
      </nav>

      <!-- COL 3: Chính sách -->
      <nav class="hb-ft-col" aria-label="Chính sách">
        <h3 class="hb-ft-h3">Chính sách</h3>
        <ul class="hb-ft-list">
          <li><a href="<c:url value='/chinh-sach/bao-hanh'/>">Bảo hành</a></li>
          <li><a href="<c:url value='/chinh-sach/doi-tra'/>">Đổi trả</a></li>
          <li><a href="<c:url value='/chinh-sach/bao-mat'/>">Bảo mật</a></li>
          <li><a href="<c:url value='/chinh-sach/van-chuyen'/>">Vận chuyển</a></li>
        </ul>
      </nav>

      <!-- COL 4: Liên hệ -->
      <section class="hb-ft-col">
        <h3 class="hb-ft-h3">Liên hệ</h3>
        <ul class="hb-ft-list hb-ft-contact">
          <li>
            <svg viewBox="0 0 24 24" width="18" height="18"><path d="M6.6 10.8a15 15 0 0 0 6.6 6.6l2.2-2.2a1 1 0 0 1 1-.25c1.1.37 2.3.57 3.6.57a1 1 0 0 1 1 1V20a1 1 0 0 1-1 1A17 17 0 0 1 3 7a1 1 0 0 1 1-1h3.5a1 1 0 0 1 1 1c0 1.3.2 2.5.57 3.6a1 1 0 0 1-.27 1.02L6.6 10.8z" fill="currentColor"/></svg>
            <a href="tel:18001234">1800 1234</a>
          </li>
          <li>
            <svg viewBox="0 0 24 24" width="18" height="18"><path d="M4 6h16v12H4z" fill="none" stroke="currentColor" stroke-width="2"/><path d="M4 6l8 7 8-7" fill="none" stroke="currentColor" stroke-width="2"/></svg>
            <a href="mailto:support@imotorbike.vn">dotienmanhsupport@imotorbike.vn</a>
          </li>
          <li><span>08:30–20:00 (T2–CN)</span></li>
          <li><span>123 Đường Nguyễn Huệ, Quận Phú Xuân, Huế</span></li>
        </ul>
      </section>
    </div>

    <div class="hb-subfooter">
      <span>© 2025 iMotorbike. All rights reserved.</span>
      <div class="hb-legal">
        <a href="<c:url value='/dieu-khoan'/>">Điều khoản</a><span>•</span>
        <a href="<c:url value='/bao-mat'/>">Bảo mật</a>
      </div>
    </div>
  </div>
</footer>

<!-- Back to top -->
<button class="hb-backtop" type="button" aria-label="Lên đầu trang" hidden>
  <svg viewBox="0 0 24 24" width="18" height="18"><path d="M12 19V5M6 11l6-6 6 6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
</button>

<jsp:include page="/inc/_chatbox.jsp" />

</body>
</html>
