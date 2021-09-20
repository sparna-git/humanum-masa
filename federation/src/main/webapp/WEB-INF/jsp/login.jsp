<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!-- setup the locale for the messages based on the language in the session -->
<fmt:setLocale value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}"/>
<fmt:setBundle basename="fr.humanum.openarchaeo.federation.i18n.OpenArchaeo"/>

<html>
<head>
<title><fmt:message key="window.app" /> | <fmt:message key="login.window.title" /></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Font Awesome -->
<link rel="stylesheet" href="<c:url value="/resources/fa/css/all.min.css" />">

<!-- Bootstrap + Material Design Bootstrap -->
<link rel="stylesheet" href="<c:url value="/resources/MDB-Free/css/bootstrap.min.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/MDB-Free/css/mdb.min.css" />">

<!-- App-specific CSS -->
<link rel="stylesheet" href="<c:url value="/resources/css/openarchaeo-federation.css" />" />

<!-- favicon, if any -->
<link rel="icon" type="image/png" href="<c:url value="/resources/favicon.png" />" />

<style>
.error {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	color: #a94442;
	background-color: #f2dede;
	border-color: #ebccd1;
	margin:auto;
	width:20%;
}

.msg {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	color: #31708f;
	background-color: #d9edf7;
	border-color: #bce8f1;
	width:20%;
	margin:auto;
	margin-top:50px;
	
}
body{
	text-align:center;
	margin:auto;
}

</style>
</head>

<body  onload='document.loginForm.username.focus();'>
	<jsp:include page="navbar.jsp">
		<jsp:param name="active" value="admin"/>
	</jsp:include>

		<c:if test="${not empty error}">
			<div class="error">${error}</div>
		</c:if>
		<c:if test="${not empty msg}">
			<div class="msg">${msg}</div><br>
		</c:if>
		
	  
	
		<form  style="margin:auto; width:20%;margin-top:150px;" name='loginForm' id="loginForm"
		  action="<c:url value="/j_spring_security_check" />" method='POST'>
		  <div class="form-group">
		   <br>
		    <label for="username">Email</label>
		    <input type='text' name='username' class="form-control" id="username">
		  </div>
		  <div class="form-group">
		    <label for="password">Mot de passe</label>
		    <input type="password" class="form-control" name='password' id="password">		    
		  </div>
		  <br>
		    <button type="submit" name="submit"  class="btn btn-default">Connexion</button>
		</form>
		
		<jsp:include page="footer.jsp" />
		
		<script src="<c:url value="/resources/MDB-Free/js/jquery-3.1.1.min.js" />"></script>
		<script src="<c:url value="/resources/MDB-Free/js/popper.min.js" />"></script>
		<script src="<c:url value="/resources/MDB-Free/js/bootstrap.min.js" />"></script>	
</body>
</html>