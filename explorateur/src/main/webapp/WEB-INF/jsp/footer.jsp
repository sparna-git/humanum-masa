<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<fmt:setLocale value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}"/>
<fmt:setBundle basename="fr.humanum.openarchaeo.explorateur.i18n.OpenArchaeo"/>
<c:set var="legalNotice" value="${requestScope['legalNotice']}" />

<footer id="footer" style="margin-top:30px;">
	<a href="http://huma-num.fr" target="_blank"><img src="<c:url value="/resources/img/logohumanum-web-grand-rvb-pt.png" />" alt="Huma-Num" style="height:40px;" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="https://masa.hypotheses.org/" target="_blank"><img src="<c:url value="/resources/img/logo_MASA_300x150.jpg" />" alt="MASA" style="height:40px;" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="https://lifat.univ-tours.fr/" target="_blank"><img src="<c:url value="/resources/img/LIFAT.jpg" />" alt="LIFAT" style="height:40px;" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="http://sparna.fr" target="_blank"><img src="<c:url value="/resources/img/Logo-SPARNA-rouge.png" />" alt="Sparna" style="height:20px;" /></a>&nbsp;&nbsp;|&nbsp;&nbsp;
	<a href="#" data-toggle="modal" data-target="#mentionLegalesModal"><fmt:message key="window.footer.legalNotice" /></a>
</footer>

<!-- Modal -->
<div class="modal fade" id="mentionLegalesModal" tabindex="-1" role="dialog" aria-labelledby="mentionLegalesModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="mentionLegalesModalTitle"><fmt:message key="window.footer.legalNotice" /></h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        ${legalNotice}
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>