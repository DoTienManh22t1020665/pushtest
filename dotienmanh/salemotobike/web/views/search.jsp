<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="vi" data-cpath="${pageContext.request.contextPath}">
    <head>
        <meta charset="UTF-8">
        <title>Kết quả tìm kiếm — ${fn:escapeXml(q)}</title>
        <!-- theme cam của bạn (nếu đã có) -->
        <link rel="stylesheet" href="<c:url value='/assets/cssremake/theme-orange.css'/>">
        <!-- style riêng cho trang search -->
        <link rel="stylesheet" href="<c:url value='/assets/cssremake/search.css?v=1'/>">
    </head>
    <body>
        <!-- Navbar -->
        <jsp:include page="/inc/header.jsp"/>
        <jsp:include page="/inc/navbar.jsp"/>


        <main class="sr-wrapper">
            <div class="sr-head">
                <h1>Kết quả cho “<em>${fn:escapeXml(q)}</em>”</h1>
                <div class="sr-sub">${total} sản phẩm</div>
            </div>

            <c:choose>
                <c:when test="${empty listXe}">
                    <p class="sr-empty">Không tìm thấy sản phẩm phù hợp.</p>
                </c:when>
                <c:otherwise>
                    <section class="sr-grid">
                        <c:forEach var="xe" items="${listXe}">
                            <c:set var="thumb" value="${empty xe.img ? (empty xe.img1 ? (empty xe.img2 ? (empty xe.img3 ? xe.img4 : xe.img3) : xe.img2) : xe.img1) : xe.img}" />

                            <article class="sr-card">
                                <!-- Media -->
                                <div class="sr-media">
                                    <c:if test="${xe.xemoi}">
                                        <span class="sr-badge">Mới</span>
                                    </c:if>

                                    <!-- Tim yêu thích (tận dụng class fav-btn/data-id như trang danh mục cũ) -->
                                    <!-- THAY cả dòng button bằng: -->
                                    <button type="button"
                                            class="sr-heart fav-btn"
                                            data-id="${xe.id}"
                                            aria-label="Yêu thích"></button>


                                    <a class="sr-thumb" href="<c:url value='/xemchitiet'/>?id=${xe.id}">
                                        <img src="<c:url value='/assets/images/${thumb}'/>"
                                             alt="${fn:escapeXml(xe.tenxe)}"
                                             loading="lazy"
                                             onerror="this.onerror=null;this.src='<c:url value="/assets/images/placeholder.png"/>'">
                                    </a>
                                </div>

                                <!-- Body -->
                                <div class="sr-body">
                                    <h3 class="sr-title">
                                        <a href="<c:url value='/xemchitiet'/>?id=${xe.id}">${xe.tenxe}</a>
                                    </h3>

                                    <div class="sr-price">
                                        <c:choose>
                                            <c:when test="${xe.giaban != null}">
                                                <fmt:formatNumber value="${xe.giaban}" type="number" pattern="#,##0"/> đ
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="sr-desc">
                                        <c:out value="${xe.tinhnang}" default=""/>


                                    </div>
                                </div>

                                <!-- Actions -->
                                <div class="sr-actions">
                                    <a class="sr-btn sr-btn--primary"
                                       href="<c:url value='/xemchitiet'/>?id=${xe.id}">Xem chi tiết</a>
                                    <a class="sr-btn sr-btn--ghost"
                                       href="<c:url value='/so-sanh/them'/>?id=${xe.id}">So sánh</a>
                                </div>
                            </article>

                        </c:forEach>
                    </section>

                    <c:if test="${pages > 1}">
                        <nav class="sr-paging">
                            <c:forEach var="i" begin="1" end="${pages}">
                                <a class="sr-page ${i == page ? 'is-active' : ''}"
                                   href="<c:url value='/search'/>?q=${fn:escapeXml(q)}&page=${i}&size=${size}${loai != null ? '&loai=' += loai : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </main>

        <script src="<c:url value='/assets/jsremake/search.js?v=1'/>"></script>


    </body>
</html>
