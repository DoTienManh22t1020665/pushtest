<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi" data-cpath="${pageContext.request.contextPath}">
<head>
  <meta charset="UTF-8" />
  <title><c:out value="${pageTitle != null ? pageTitle : 'Imotorbike'}"/></title>

  <!-- CSS chung -->
  <link rel="stylesheet" href="<c:url value='/assets/cssremake/css.css'/>">
  <link rel="stylesheet" href="<c:url value='/assets/cssremake/theme-orange.css'/>">

  <!-- JS chung -->
  <script>window.CPATH='${pageContext.request.contextPath}';</script>
  <script defer src="<c:url value='/assets/jsremake/navbar.js'/>"></script>
</head>
<body>
