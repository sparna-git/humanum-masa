<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!-- setup the locale for the messages based on the language in the session -->
<fmt:setLocale value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}"/>
<fmt:setBundle basename="fr.humanum.openarchaeo.explorateur.i18n.OpenArchaeo"/>

<html>
<head>
<title><fmt:message key="window.app" /> | <fmt:message key="explore.window.title" /></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">


<!-- Font Awesome -->
<link rel="stylesheet" href="<c:url value="/resources/fa/css/all.min.css" />">

<!-- Bootstrap + Material Design Bootstrap -->
<link rel="stylesheet" href="<c:url value="/resources/MDB-Free/css/bootstrap.min.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/MDB-Free/css/mdb.min.css" />">

<!-- App-specific CSS -->
<link rel="stylesheet" href="<c:url value="/resources/css/openarchaeo-explorateur.css" />" />

<!-- Vis.js -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.css">

<!-- Codemirror and SPARQL mode -->
<script src="<c:url value="/resources/codemirror/lib/codemirror.js" />"></script>
<link rel="stylesheet" href="<c:url value="/resources/codemirror/lib/codemirror.css" />">
<script src="<c:url value="/resources/codemirror/mode/sparql/sparql.js" />"></script>

<!-- SimSemSearch -->
<link rel="stylesheet" href="<c:url value="/resources/css/simsemsearch-min.css" />">

<!-- favicon, if any -->
<link rel="icon" type="image/png" href="resources/favicon.png" />

<!-- YASR / YASQE -->
<!-- <link -->
<!-- 	href='http://cdn.jsdelivr.net/g/yasqe@2.2(yasqe.min.css),yasr@2.4(yasr.min.css)' -->
<!-- 	rel='stylesheet' type='text/css' /> -->
<link href='https://cdn.jsdelivr.net/npm/yasgui-yasr@2.12.19/dist/yasr.min.css' rel='stylesheet' type='text/css'/>


</head>
<body>
	<jsp:include page="navbar.jsp">
		<jsp:param name="active" value="explorer"/>
	</jsp:include>

	<div class="container-fluid">
		<div class="row justify-content-center">
			<div class="col-sm-10">			
				<h1><fmt:message key="explore.title" /></h1>
			
				<input type="hidden" value="${sources}" name="sources" id="sources">
				
				
				<div class="card" id="simsemsearch-container">
				  <div class="card-body">
				    <div class="card-text">				    	
						<div id="simsemsearch"></div>
						<div id="simsemsearch-control">
							<div class="row no-gutters justify-content-end">
								<div class="col-sm-6">
									<div class="float-right">
										<button type="button" id="run" class="btn btn-primary"><fmt:message key="explore.run" /></button>
										&nbsp;<fmt:message key="explore.andDisplayResultAs" />&nbsp;
									</div>
								</div>
								<div class="col-sm-2">
										<select class="form-control form-control-lg" id="view">
											<option value="table" selected><fmt:message key="explore.output.table" /></option>
											<option value="leaflet"><fmt:message key="explore.output.leaflet" /></option>
											<option value="timeline"><fmt:message key="explore.output.timeline" /></option>
										</select>
								</div>
							</div>
						</div>
				    </div>
				  </div>
				</div>

				<input type="hidden" name="query" id="sparql" />
				<input type="hidden" name="rawExpandedSparql" id="rawExpandedSparql" />
				
				<div class="form-group">
					<div id="sparqlResultAlert"></div>					
					<div id="expandedQueryContainer">
						<textarea class="form-control" rows="15" readonly="readonly" name="expandedQuery" id="expandedQuery"></textarea>
					</div>
					<div id="loading" style="width:100%; text-align:center; display:none;" ><img src="<c:url value="/resources/img/Polar-1.5s-325px.gif" />" /></div>
					<div id="yasr"></div>
				</div>
			
			</div>
		</div>
	</div>
	
	<jsp:include page="footer.jsp" />

	<!-- <script src="<c:url value="/resources/MDB-Free/js/jquery-3.1.1.min.js" />"></script> -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.js"></script>
	<script src="<c:url value="/resources/js/jquery-3.3.1.min.js" />"></script>
	<script src="https://cdn.jsdelivr.net/npm/yasgui-yasr@2.12.19/dist/yasr.bundled.min.js"></script>
	
	<script src="<c:url value="/resources/MDB-Free/js/popper.min.js" />"></script>
	<script src="<c:url value="/resources/MDB-Free/js/bootstrap.min.js" />"></script>
 	<script src="<c:url value="/resources/js/timeline.js" />"></script>
 	
 	<!-- simsemsearch -->
 	<script src="<c:url value="/resources/js/simsemsearch-min.js" />"></script>

	<script type="text/javascript">
	
	 var yasr;
	 var editor;
	
	 function onStartExecute() {
		 // disable button
		 $( "#run" ).prop('disabled', true);
		 // reset alert message
		 $('#sparqlResultAlert').html('');
		 // reset yasr
		 $('#yasr').html('');
		 // display loading icon
		 $('#loading').toggle();
	 }
	 
	 function onSuccessExpandQuery(query) {
     	document.getElementById("rawExpandedSparql").value = query;
    	
    	// remove old CodeMirror
    	$('.CodeMirror').remove();
    	// set the value of the textarea
    	$('#expandedQuery').text(query);
    	// recreate CodeMirror
    	editor = CodeMirror.fromTextArea(document.getElementById("expandedQuery"), {
			  lineNumbers: true,
			  mode: "sparql"
		});
	 }
	 
	 function onSuccessExecuteQuery(response) {
		$('#sparqlResultAlert').html('<div class="alert alert-success" role="alert"><i class="fal fa-check"></i>&nbsp;<fmt:message key="explore.results.querySuccessful" /> - <small><a href="#" class="alert-link" id="toggleQueryButton"><fmt:message key="explore.results.viewSparql" /></a></small></div>');
       	$( "#toggleQueryButton" ).click(function() {
			 $('#expandedQueryContainer').toggle();
			 // refresh CodeMirror after toggle for proper display
			 editor.refresh();
		});
       	
       	yasr = YASR(
       			document.getElementById("yasr"),
       			{ 
       				// select the proper output
       				"output": $( "#view option:selected" ).val(),
       				// still allow to switch to other display
       				"drawOutputSelector": true,
       				// avoid persistency side-effects
					"persistency": { "prefix": false, "results": { "key": false }}
				},
				response
		);
       	
       	// re-enable execute button
       	$( "#run" ).prop('disabled', false);
       	// hide loading icon
       	$('#loading').toggle();
	 }
	 
	 function onErrorExecuteQuery(response) {
		$('#sparqlResultAlert').html('<div class="alert alert-danger" role="alert"><i class="fal fa-exclamation-triangle"></i>&nbsp;<fmt:message key="explore.results.queryError" /> <small><a href="#" class="alert-link" id="toggleQueryButton"><fmt:message key="explore.results.viewSparql" /></a></small><br /><br /><pre>'+response.responseText+'</pre></div>');
       	$( "#toggleQueryButton" ).click(function() {
			 $('#expandedQueryContainer').toggle();
			 // refresh CodeMirror after toggle for proper display
			 editor.refresh();
		});
     	// re-enable execute button
       	$( "#run" ).prop('disabled', false);
     	// hide loading
       	$('#loading').toggle();
	 }
	 
	 function execute() {
		 var sparql = $('#sparql').val();
		 onStartExecute();
		 
		 $.ajax({
	         url : 'expand',
	         type : 'POST', 
	         data : 'query=' + encodeURIComponent(sparql) + '&sources=${sources}&view='+($( "#view option:selected" ).val()), 
	         success: function(response) {
	        	var query = response.expandQuery;
	        	onSuccessExpandQuery(query);
	   			
	   			 $.ajax({
	   		         url : '/federation/sparql',
	   		         type : 'POST', 
	   		         data : 'query=' + encodeURIComponent(query) , 
	   		         success: onSuccessExecuteQuery,
	   		       	 error: onErrorExecuteQuery
	   		     });
	          }
	      });
	 }
	
	 
	
	 $( document ).ready(function() {
		 
		 // hide query expansion
		 $('#expandedQueryContainer').hide();
		 
		 // event on the execute button
		 $( "#run" ).click(function() {
			 execute();
		 });
		 
		 // YASR.plugins.table.defaults = { "mergeLabelsWithUris": true };
		 YASR.registerOutput("timeline",timelinePlugin);
// 		 yasr = YASR(document.getElementById("yasr"), 
// 			{
// 			 outputPlugins: ["error", "boolean", "rawResponse", "table", "pivot", "leaflet", "timeline"]
// 			}	 
// 		 );


		 $('#simsemsearch').SimSemSearchForm({
			pathSpecSearch: 'resources/config/spec-search.json',
			pathLanguages: 'resources/config/lang/',
			language: '${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}',
			addDistinct: true,
			autocomplete : {
				url: function(domain, property, range, key) {
					return '/federation/api/autocomplete?sources=${sources}&key='+key+'&domain='+encodeURIComponent(domain)+'&property='+encodeURIComponent(property)+'&range='+encodeURIComponent(range) ;
				}
			},
			list : {
				url: function(domain, property, range) {
					return '/federation/api/list?sources=${sources}&domain='+encodeURIComponent(domain)+'&property='+encodeURIComponent(property)+'&range='+encodeURIComponent(range) ;
				}
			},
			dates : {
				url: function(domain, property, range) {
					return '/federation/api/periods?lang=${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}' ;
				}
			},
			onQueryUpdated: function(queryString, queryJson) {
				// ici on récupère la requete Sparql grace au premier parametre de la fonction
				console.log(queryString) ;
				$('#sparql').val(queryString);
			}
		  });
		 
	 });
	  
	</script>
</body>
</html>