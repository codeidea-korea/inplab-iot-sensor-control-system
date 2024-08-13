<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>알림창</title>
</head>
<body>
<script>
    try {
        localStorage.setItem('loginSuccess', false);
        localStorage.setItem('autoLogin', false);
    } catch(e) { }

    alert('로그인을 실패하였습니다.');
    location.href= '/';
</script>
</body>
</html>