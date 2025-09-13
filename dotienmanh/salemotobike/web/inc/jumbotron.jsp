<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- HERO / JUMBOTRON -->
<!-- HERO SLIDER (tự chạy) -->
<section class="hb-slider" id="hero-slider"
         aria-roledescription="carousel"
         aria-label="Banner trang chủ"
         tabindex="0"
         data-autoplay="true" data-interval="5000">
  <div class="hb-slider-viewport">
    <div class="hb-slider-track">
      <!-- SLIDE 1 -->
      <a class="hb-slide" id="slide-1" href="<c:url value='/san-pham'/>" aria-label="Khám phá xe">
        <picture>
          <!-- TODO: đổi ảnh desktop -->
          <source media="(min-width: 992px)" srcset="<c:url value='/assets/images/jumbotron3.png'/>">
          <!-- TODO: đổi ảnh mobile -->
          <img src="<c:url value='/assets/images/jumbotron.png'/>" alt="" loading="eager" fetchpriority="high" width="1920" height="720">
        </picture>
      </a>

      <!-- SLIDE 2 -->
      <a class="hb-slide" id="slide-2" href="<c:url value='/khuyen-mai'/>" aria-label="Ưu đãi tháng này">
        <picture>
          <source media="(min-width: 992px)" srcset="<c:url value='/assets/images/jumbotron1.png'/>">
          <img src="<c:url value='/assets/img/banner2-mobile.jpg'/>" alt="" loading="lazy" width="1920" height="720">
        </picture>
      </a>

      <!-- SLIDE 3 -->
      <a class="hb-slide" id="slide-3" href="<c:url value='/he-thong-cua-hang'/>" aria-label="Tìm cửa hàng">
        <picture>
          <source media="(min-width: 992px)" srcset="<c:url value='/assets/images/jumbotron2.png'/>">
          <img src="<c:url value='/assets/img/banner3-mobile.jpg'/>" alt="" loading="lazy" width="1920" height="720">
        </picture>
      </a>

      <!-- (Tuỳ chọn) SLIDE 4 -->
      <a class="hb-slide" id="slide-4" href="<c:url value='/cong-nghe'/>" aria-label="Công nghệ">
        <picture>
          <source media="(min-width: 992px)" srcset="<c:url value='/assets/images/jumbotron.png'/>">
          <img src="<c:url value='/assets/img/banner4-mobile.jpg'/>" alt="" loading="lazy" width="1920" height="720">
        </picture>
      </a>
    </div>
  </div>

  <!-- Nút điều hướng -->
  <button class="hb-slider-prev" type="button" aria-label="Ảnh trước">
    <svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><path d="M15 4l-8 8 8 8" fill="none" stroke="currentColor" stroke-width="2"/></svg>
  </button>
  <button class="hb-slider-next" type="button" aria-label="Ảnh sau">
    <svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><path d="M9 4l8 8-8 8" fill="none" stroke="currentColor" stroke-width="2"/></svg>
  </button>

  <!-- Dots -->
  <div class="hb-slider-dots" role="tablist" aria-label="Chọn banner"></div>
</section>
        <div class="hb-space-sm" aria-hidden="true"></div>

        
        
        
        
        
        
        
