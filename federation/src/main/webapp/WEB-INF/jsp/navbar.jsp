<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!-- setup the locale for the messages based on the language in the session -->
<fmt:setLocale value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}"/>
<c:set var="data" value="${sessionScope['fr.humanum.openarchaeo.SessionData']}" />
<fmt:setBundle basename="fr.humanum.openarchaeo.federation.i18n.OpenArchaeo"/>

<!--Navbar-->
<nav class="navbar navbar-expand-lg navbar-light" id="globalnav">

    <!-- Navbar brand -->
    <a class="navbar-brand" href="/explorateur/home"><fmt:message key="navbar.brand" /></a>

    <!-- Collapse button -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
        aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>

    <!-- Collapsible content -->
    <div class="collapse navbar-collapse" id="navbarSupportedContent">

        <!-- Links -->
        <ul class="navbar-nav mr-auto">
            <li class="nav-item ${param.active == 'sparql' ? 'active' : ''}">
                <a class="nav-link" href="<c:url value="/sparql-form" />"><fmt:message key="navbar.sparql" />${param.active == 'sparql' ? '<span class="sr-only">(current)</span>' : ''}</a>
            </li>
            <li class="nav-item ${param.active == 'api' ? 'active' : ''}">
                <a class="nav-link" href="<c:url value="/api" />"><fmt:message key="navbar.api" />${param.active == 'api' ? '<span class="sr-only">(current)</span>' : ''}</a>
            </li>
            <!--
            <li class="nav-item ${param.active == 'admin' ? 'active' : ''}">
                <a class="nav-link" href="<c:url value="/admin" />"><fmt:message key="navbar.admin" />${param.active == 'admin' ? '<span class="sr-only">(current)</span>' : ''}</a>
            </li>
            -->
        </ul>
        <!-- Links -->
        
        <ul class="navbar-nav ml-auto nav-flex-icons">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="langMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <span style="font-size:1.25rem;"><i class="fal fa-globe-africa"></i></span>&nbsp;&nbsp;${data.userLocale.language}
            </a>
            <div class="dropdown-menu dropdown-menu-right dropdown-default" aria-labelledby="langMenuLink">
              <a class="dropdown-item" href="?lang=fr">fr</a>
              <a class="dropdown-item" href="?lang=en">en</a>
            </div>
          </li>
        </ul>

    </div>
    <!-- Collapsible content -->

	<ul class="nav navbar-nav navbar-right">
		<c:if test="${sessionScope.USER_DETAILS.name != null}">
			<li role="presentation"><a style="color:white;"><i
					class="glyphicon glyphicon-user"></i>&nbsp;${sessionScope.USER_DETAILS.name}</a>&nbsp;&nbsp;&nbsp;
			</li>

			<li role="presentation"><a href="login?logout" style="cursor:pointer; text-decoration: none; color:white;"><i class="fa fa-power-off"></i>&nbsp;Déconnexion</a></li>
		</c:if>
	</ul>

</nav>
<!--/.Navbar-->
                