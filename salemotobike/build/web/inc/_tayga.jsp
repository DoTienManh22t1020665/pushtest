<%-- tayga.jsp: Trang hiển thị danh sách xe tay ga dạng lưới --%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi" data-cpath="${pageContext.request.contextPath}">
  <head>
    <meta charset="UTF-8" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/cssremake/theme-orange.css?v=2" />
    <title>Xe tay ga</title>
    <%-- NOTE: thay đường dẫn nếu bạn đặt khác --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tayga.css" />
  </head>
  <body>
    <div class="page">
      <c:set var="cpath" value="${pageContext.request.contextPath}" />
      <c:set var="activeCat" value="${empty param.cat ? 'tayga' : param.cat}" />

      <header class="page-header">
        <div class="title-group">
          <h1>Xe tay ga</h1>
          <div class="meta">
            <span class="pill">Tổng số: <strong><c:out value="${fn:length(listXeTayGa)}"/></strong></span>
          </div>
        </div>

        <!-- Bộ chuyển danh mục (4 nút) -->
        <nav class="cat-switch" aria-label="Chuyển danh mục xe">
          <a class="catbtn ${activeCat=='tayga' ? 'is-active' : ''}"
             href="${cpath}/tayga"
             <c:if test="${activeCat=='tayga'}">aria-current="page"</c:if>>Tay ga</a>

          <a class="catbtn ${activeCat=='xeso' ? 'is-active' : ''}"
             href="${cpath}/xeso">Xe số</a>

          <a class="catbtn ${activeCat=='contay' ? 'is-active' : ''}"
             href="${cpath}/xecontay">Côn tay</a>

          <a class="catbtn ${activeCat=='xedien' ? 'is-active' : ''}"
             href="${cpath}/xedien">Xe điện</a>

          <a class="catbtn ${activeCat=='xemtatca' ? 'is-active' : ''}"
             href="${cpath}/xemtatca">Xem tất cả</a>
        </nav>
      </header>

      <c:choose>
        <c:when test="${not empty listXeTayGa}">
          <section class="products-grid">
            <c:forEach var="xe" items="${listXeTayGa}">
              <article class="product-card">
                <div class="badge-wrap">
                  <c:if test="${xe.xemoi}"><span class="badge-new">Mới</span></c:if>
                </div>

                <%-- ĐÁNH DẤU YÊU THÍCH DỰA VÀO sessionScope.favIds --%>
                <c:set var="isFav" value="false"/>
                <c:if test="${not empty sessionScope.favIds}">
                  <c:forEach var="fid" items="${sessionScope.favIds}">
                    <c:if test="${fid == xe.id}">
                      <c:set var="isFav" value="true"/>
                    </c:if>
                  </c:forEach>
                </c:if>

                <button class="fav-btn ${isFav ? 'is-active' : ''}"
                        data-id="${xe.id}"
                        aria-label="${isFav ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}"
                        aria-pressed="${isFav ? 'true' : 'false'}"
                        title="${isFav ? 'Bỏ yêu thích' : 'Yêu thích'}">
                  <!-- icon heart -->
                  <svg class="icon-heart" viewBox="0 0 24 24" width="20" height="20" aria-hidden="true">
                    <path d="M12 21s-6.7-4.35-9.33-7A6.5 6.5 0 1 1 12 5.09 6.5 6.5 0 1 1 21.33 14c-2.63 2.65-9.33 7-9.33 7z" fill="currentColor"/>
                  </svg>
                </button>

                <a class="thumb" href="${pageContext.request.contextPath}/xemchitiet?id=${xe.id}" title="${xe.tenxe}">
                  <img
                    src="${pageContext.request.contextPath}/assets/images/${xe.img}"
                    alt="${xe.tenxe}"
                    onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/placeholder.png';"
                    loading="lazy"
                  />
                </a>

                <div class="info">
                  <h3 class="name" title="${xe.tenxe}">${xe.tenxe}</h3>

                  <div class="price">
                    <fmt:formatNumber value="${xe.giaban}" type="number" pattern="#,##0"/> ₫
                  </div>

                  <c:if test="${not empty xe.tinhnang}">
                    <p class="desc">
                      <c:out value="${fn:length(xe.tinhnang) > 120 ? fn:substring(xe.tinhnang,0,117).concat('...') : xe.tinhnang}"/>
                    </p>
                  </c:if>

                  <div class="actions">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/xemchitiet?id=${xe.id}">Xem chi tiết</a>
                    <a class="btn btn-outline" href="${pageContext.request.contextPath}/so-sanh/them?id=${xe.id}">So sánh</a>
                  </div>
                </div>
              </article>
            </c:forEach>
          </section>
        </c:when>
        <c:otherwise>
          <div class="empty">
            Chưa có dữ liệu xe tay ga để hiển thị.
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <%-- JS: trang riêng + fav toggle (đọc cpath từ data-cpath của <html>) --%>
    <script src="${pageContext.request.contextPath}/assets/jsremake/tayga.js"></script>
    <script src="${pageContext.request.contextPath}/assets/jsremake/favorite.js"></script>
  </body>
</html>
