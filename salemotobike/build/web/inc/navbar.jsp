<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="hb-header" role="banner">
  <div class="hb-container">
    <div class="hb-left">
      <a href="<c:url value='/home'/>" class="hb-logo" aria-label="Trang chủ Honda">
        <img src="<c:url value='/assets/icon/logo.png'/>" alt="Honda" />
      </a>
    </div>

    <button class="hb-burger" aria-label="Mở menu" aria-controls="hb-nav" aria-expanded="false">
      <span></span><span></span><span></span>
    </button>

    <nav id="hb-nav" class="hb-nav" role="navigation" aria-label="Chính">
      <ul class="hb-menu">
        <li class="has-mega">
          <button class="hb-link" aria-haspopup="true" aria-expanded="false">Sản phẩm</button>
          <div class="hb-mega" role="menu">
            <div class="hb-mega-grid">
              <!-- Cột 1: Tay ga -->
              <section class="hb-mega-col">
                <h3>Tay ga</h3>
                <ul>
                  <li><a href="xemchitiet?id=1">SH350i</a></li>
                  <li><a href="xemchitiet?id=2">SH160i/125i</a></li>
                  <li><a href="xemchitiet?id=5">Air Blade</a></li>
                  <li><a href="xemchitiet?id=8">Vision</a></li>
                </ul>
                <a class="hb-card" href="tayga">
                  <div class="hb-card-img">
                    <img src="<c:url value='/assets/images/xetayga.png'/>" alt="Tay ga">
                  </div>
                  <div class="hb-card-body">Khám phá dòng tay ga</div>
                </a>
              </section>

              <!-- Cột 2: Xe số -->
              <section class="hb-mega-col">
                <h3>Xe số</h3>
                <ul>
                  <li><a href="xemchitiet?id=11">Wave Alpha</a></li>
                  <li><a href="xemchitiet?id=12">Blade</a></li>
                  <li><a href="xemchitiet?id=14">Future</a></li>
                </ul>
                <a class="hb-card" href="xeso">
                  <div class="hb-card-img">
                    <img src="<c:url value='/assets/images/xeso.png'/>" alt="Xe số">
                  </div>
                  <div class="hb-card-body">Bền bỉ, tiết kiệm</div>
                </a>
              </section>

              <!-- Cột 3: Côn tay / Xe điện -->
              <section class="hb-mega-col">
                <h3>Côn tay &amp; Xe điện</h3>
                <ul>
                  <li><a href="xemchitiet?id=16">Winner X</a></li>
                  <li><a href="xemchitiet?id=17">ICON e</a></li>
                  <li><a href="xemchitiet?id=18">CUV e</a></li>
                </ul>
                <a class="hb-card" href="xedien">
                  <div class="hb-card-img">
                    <img src="<c:url value='/assets/images/xecontay.png'/>" alt="Côn tay & Mô tô">
                  </div>
                  <div class="hb-card-body">Hiệu năng & trải nghiệm</div>
                </a>
              </section>

              <!-- Cột 4: Khuyến mãi -->
              <section class="hb-mega-col">
                <h3>Khuyến mãi</h3>
                <p>Cập nhật ưu đãi mới nhất cho các dòng xe.</p>
                <a class="hb-promo" href="#">
                  <img src="<c:url value='/assets/images/khuyenmai.png'/>" alt="Khuyến mãi">
                </a>
              </section>
            </div>
          </div>
        </li>

        <li><a class="hb-link" href="#">Công nghệ</a></li>
        <li><a class="hb-link" href="#">Dịch vụ</a></li>
        <li><a class="hb-link" href="#">Tin tức</a></li>
        <li><a class="hb-link" href="#">Khuyến mãi</a></li>
      </ul>
    </nav>

    <div class="hb-right">
      <!-- LISTFAV -->
      <a href="<c:url value='/listfav'/>"
         class="hb-icon-btn hb-fav"
         aria-label="Danh sách yêu thích">
        <img src="<c:url value='/assets/icon/heart.png'/>" alt="" />
        <span class="hb-badge" data-fav-count
              <c:if test="${empty sessionScope.favCount || sessionScope.favCount == 0}">hidden</c:if>>
          <c:out value="${sessionScope.favCount != null ? sessionScope.favCount : 0}"/>
        </span>
      </a>

      <!-- SEARCH -->
      <form class="hb-search" role="search" action="<c:url value='/search'/>" method="get">
        <input type="search" name="q" placeholder="Tìm kiếm..." aria-label="Tìm kiếm">
        <button type="submit" aria-label="Tìm">
          <svg viewBox="0 0 24 24" width="20" height="20" aria-hidden="true">
            <path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0016 9.5 6.5 6.5 0 109.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"></path>
          </svg>
        </button>
      </form>

      <!-- LOGIN / USER -->
      <c:choose>
        <c:when test="${not empty sessionScope.user}">
          <div class="hb-user">
            <span class="hb-user-name">
              Hi,
              <c:out value="${empty sessionScope.user.username ? sessionScope.user.email : sessionScope.user.username}"/>
            </span>
            <a href="<c:url value='/logout'/>" class="hb-btn hb-btn--ghost" aria-label="Đăng xuất">Logout</a>
          </div>
        </c:when>
        <c:otherwise>
          <a href="<c:url value='/login'/>"
             class="hb-btn hb-btn--orange"
             aria-label="Đăng nhập">
            <svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
              <path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm0 2c-4.418 0-8 2.239-8 5v1h16v-1c0-2.761-3.582-5-8-5Z"/>
            </svg>
            <span class="hb-btn-label">Login</span>
          </a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- Overlay cho mobile -->
  <div class="hb-overlay" hidden></div>
</header>
