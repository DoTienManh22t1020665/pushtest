<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- ===== DANH MỤC 5 Ô ===== -->
<section class="hb-section hb-cats5">
    <div class="hb-container">
        <ul class="hb-cat5-grid">
            <!-- Tay ga -->
            <li>
                <a class="hb-cat" href="<c:url value='/tayga'/>">
                    <!-- TODO: thay ảnh -->
                    <img src="<c:url value='/assets/images/xetayga.png'/>" alt="Tay ga">
                    <span>Tay ga</span>
                </a>
            </li>

            <!-- Xe số -->
            <li>
                <a class="hb-cat" href="<c:url value='/xeso'/>">
                    <img src="<c:url value='/assets/images/xeso.png'/>" alt="Xe số">
                    <span>Xe số</span>
                </a>
            </li>

            <!-- Côn tay -->
            <li>
                <a class="hb-cat" href="<c:url value='/xecontay'/>">
                    <img src="<c:url value='/assets/images/xecontay.png'/>" alt="Côn tay">
                    <span>Côn tay</span>
                </a>
            </li>

            <!-- Xe điện -->
            <li>
                <a class="hb-cat" href="<c:url value='/xedien'/>">
                    <img src="<c:url value='/assets/images/xedien.png'/>" alt="Xe điện">
                    <span>Xe điện</span>
                </a>
            </li>

            <!-- Xem tất cả -->
            <li>
                <a class="hb-cat hb-cat--all" href="<c:url value='/xemtatca'/>" aria-label="Xem tất cả sản phẩm">
                    <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true">
                    <path d="M5 12h12M13 6l6 6-6 6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <span>Xem tất cả</span>
                </a>
            </li>
        </ul>
    </div>
</section>

