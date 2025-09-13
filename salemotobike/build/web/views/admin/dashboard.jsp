<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi" data-cpath="${pageContext.request.contextPath}">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/cssremake/admin.css?v=1">
</head>
<body class="ad-body">
  <c:set var="cpath" value="${pageContext.request.contextPath}" />
  <aside class="ad-aside">
    <div class="ad-brand">
      <a href="${cpath}/admin" class="ad-logo">Admin</a>
    </div>
    <nav class="ad-menu">
      <a href="${cpath}/admin" class="ad-item is-active">Dashboard</a>
      <a href="${cpath}/admin/xe" class="ad-item">Quản lý xe</a>
      <a href="${cpath}/admin/loaixe" class="ad-item">Loại xe</a>
      <a href="${cpath}/admin/users" class="ad-item">Người dùng</a>
      <a href="${cpath}/home" class="ad-item">↩ Về trang chính</a>
    </nav>
  </aside>

  <main class="ad-main">
    <header class="ad-topbar">
      <h1>Dashboard</h1>
      <div class="ad-actions">
        <a class="ad-btn" href="${cpath}/logout">Đăng xuất</a>
      </div>
    </header>

    <!-- KPIs -->
    <section class="ad-kpis">
      <article class="ad-kpi">
        <div class="ad-kpi-label">Tổng xe</div>
        <div class="ad-kpi-value"><c:out value="${totalXe}" /></div>
      </article>
      <article class="ad-kpi">
        <div class="ad-kpi-label">Tổng người dùng</div>
        <div class="ad-kpi-value"><c:out value="${totalUsers}" /></div>
      </article>
      <article class="ad-kpi">
        <div class="ad-kpi-label">Tổng favorites</div>
        <div class="ad-kpi-value"><c:out value="${totalFavs}" /></div>
      </article>
    </section>

    <div class="ad-grid">
      <!-- Top xe -->
      <section class="ad-card">
        <header class="ad-card-head">
          <h2>Top 5 xe được yêu thích</h2>
        </header>
        <div class="ad-table">
          <table>
            <thead>
              <tr>
                <th style="width:64px">Ảnh</th>
                <th>Tên xe</th>
                <th style="width:120px">Favorites</th>
                <th style="width:120px">Chi tiết</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty topXe}">
                  <tr><td colspan="4" class="ad-empty">Chưa có dữ liệu.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="r" items="${topXe}">
                    <tr>
                      <td>
                        <img class="ad-thumb"
                             src="${cpath}/assets/images/${r.img}"
                             alt="${r.tenxe}"
                             onerror="this.onerror=null;this.src='${cpath}/assets/images/placeholder.png'">
                      </td>
                      <td>${r.tenxe}</td>
                      <td><strong>${r.favs}</strong></td>
                      <td><a class="ad-link" href="${cpath}/xemchitiet?id=${r.id}">Xem</a></td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </section>

      <!-- Recent favorites -->
      <section class="ad-card">
        <header class="ad-card-head">
          <h2>Favorites mới nhất</h2>
        </header>
        <div class="ad-table">
          <table>
            <thead>
            <tr>
              <th>ID</th>
              <th>User</th>
              <th>Xe</th>
              <th>Thời gian</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${empty recentFav}">
                <tr><td colspan="4" class="ad-empty">Chưa có dữ liệu.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="r" items="${recentFav}">
                  <tr>
                    <td>#${r.id}</td>
                    <td>${r.userEmail}</td>
                    <td>
                      <a class="ad-link" href="${cpath}/xemchitiet?id=${r.xeId}">
                        ${r.tenxe}
                      </a>
                    </td>
                    <td>
                      <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </main>
</body>
</html>
