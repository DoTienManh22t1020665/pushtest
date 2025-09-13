<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi" data-cpath="${pageContext.request.contextPath}">
<head>
  <meta charset="UTF-8" />
  <title>Yêu thích của bạn</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/cssremake/theme-orange.css?v=2">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/cssremake/listfav.css?v=2">
</head>
<body>

  <!-- Include đúng thư mục /inc -->
  <jsp:include page="/inc/header.jsp"/>
  <jsp:include page="/inc/navbar.jsp"/>

    <!-- Nội dung danh sách -->
    <jsp:include page="/inc/_listfav.jsp"/>

  <jsp:include page="/inc/footer.jsp"/>

  <script>window.CPATH='${pageContext.request.contextPath}';</script>
  <script defer src="${pageContext.request.contextPath}/assets/jsremake/listfav.js?v=2"></script>
  <script src="<c:url value='/assets/jsremake/favorite.js'/>"></script>

</body>
</html>
