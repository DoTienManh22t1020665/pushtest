<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi" data-cpath="${cpath}">
<head>
  <meta charset="UTF-8">
  <title><c:out value="${empty pageTitle ? 'Admin' : pageTitle}"/></title>
  <link rel="stylesheet" href="${cpath}/assets/cssremake/admin.css?v=1">
</head>
<body class="ad-body">
  <aside class="ad-aside">
    <div class="ad-brand">
      <a href="${cpath}/admin" class="ad-logo">Admin</a>
    </div>
    <nav class="ad-menu">
      <a href="${cpath}/admin"         class="ad-item ${navActive=='dashboard' ? 'is-active' : ''}">Dashboard</a>
      <a href="${cpath}/admin/xe"      class="ad-item ${navActive=='xe'        ? 'is-active' : ''}">Quản lý xe</a>
      <a href="${cpath}/admin/loaixe"  class="ad-item ${navActive=='loaixe'    ? 'is-active' : ''}">Loại xe</a>
      <a href="${cpath}/admin/users"   class="ad-item ${navActive=='users'     ? 'is-active' : ''}">Người dùng</a>
      <a href="${cpath}/admin/favorites" class="ad-item ${navActive=='favorites' ? 'is-active' : ''}">Favorites</a>
      <a href="${cpath}/home" class="ad-item">↩ Về trang chính</a>
    </nav>
  </aside>

  <main class="ad-main">
    <header class="ad-topbar">
      <h1><c:out value="${empty pageTitle ? 'Admin' : pageTitle}"/></h1>
      <div class="ad-actions">
        <a class="ad-btn" href="${cpath}/logout">Đăng xuất</a>
      </div>
    </header>
