<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<fmt:setLocale value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}"/>
<fmt:setBundle basename="fr.humanum.openarchaeo.federation.i18n.OpenArchaeo"/>

<footer id="footer" style="margin-top:30px;">
	<a href="#" data-toggle="modal" data-target="#mentionLegalesModal"><fmt:message key="window.footer.legalNotice" /></a>
</footer>

<!-- Modal -->
<div class="modal fade" id="mentionLegalesModal" tabindex="-1" role="dialog" aria-labelledby="mentionLegalesModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="mentionLegalesModalTitle"><fmt:message key="window.footer.legalNotice" /></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        ...
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>