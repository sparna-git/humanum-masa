<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!-- setup the locale for the messages based on the language in the session -->
<fmt:setLocale
	value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}" />
<fmt:setBundle
	basename="fr.humanum.openarchaeo.explorateur.i18n.OpenArchaeo" />

<c:set var="dataSource" value="${requestScope['singleSourceDefinition']}" />
<c:set var="uriSource" value="${requestScope['UriRequete']}" />
<c:set var="lang"
	value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}" />

<html xmlns:dct="http://purl.org/dc/terms/"
	  xmlns:dc="http://purl.org/dc/elements/1.1/"
	  xmlns:xsd="http://www.w3.org/2001/XMLSchema#">
<head>
<title><fmt:message key="window.app" /> | <fmt:message
		key="explore.window.title" /> <c:if test="${fn:length(data.sources) == 1}">${dataSource.getTitle(lang)}</c:if></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<!-- Bootstrap + Material Design Bootstrap -->
<link rel="stylesheet"
	href="<c:url value="/resources/MDB-Free/css/bootstrap.min.css" />" />
<link rel="stylesheet"
	href="<c:url value="/resources/MDB-Free/css/mdb.min.css" />">

<!-- datepicker -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/@chenfengyuan/datepicker@1.0.9/dist/datepicker.min.css">

<!-- Vis.js -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.css">

<!-- App-specific CSS -->
<link rel="stylesheet"
	href="<c:url value="/resources/css/openarchaeo-explorateur.css" />" />
<!-- Overwrite timeline CSS -->
<link rel="stylesheet"
	href="<c:url value="/resources/css/timeline.css" />" />

<!-- Codemirror and SPARQL mode -->
<script src="<c:url value="/resources/codemirror/lib/codemirror.js" />"></script>
<link rel="stylesheet"
	href="<c:url value="/resources/codemirror/lib/codemirror.css" />">
<script
	src="<c:url value="/resources/codemirror/mode/sparql/sparql.js" />"></script>

<!-- Sparnatural stylesheet -->
<link rel="stylesheet"
	href="<c:url value="/resources/css/sparnatural.css" />">

<!-- favicon, if any -->
<link rel="icon" type="image/png" href="resources/favicon.png" />

<!-- YASR / YASQE -->
<!-- <link -->
<!-- 	href='http://cdn.jsdelivr.net/g/yasqe@2.2(yasqe.min.css),yasr@2.4(yasr.min.css)' -->
<!-- 	rel='stylesheet' type='text/css' /> -->
<link
	href='https://cdn.jsdelivr.net/npm/yasgui-yasr@2.12.19/dist/yasr.min.css'
	rel='stylesheet' type='text/css' />

<!-- Font Awesome -->
<link rel="stylesheet"
	href="<c:url value="/resources/fa/css/all.min.css" />">

<c:if test="${fn:length(data.sources) == 1}">
	
	<link rel="dc:identifier" href="${uriSource}" />
	
	<meta property="dct:title" content="${dataSource.getTitle(lang)}" />
	<c:if test="${not empty dataSource.getShortDesc(lang)}">
		<meta property="dct:description" content="${dataSource.getShortDesc(lang)}" xml:lang="${lang}" />
	</c:if>
	
	
	<c:if test="${not empty dataSource.publisher}">
		<!-- publisher -->
		<meta property="dct:publisher" href="${dataSource.publisher}" />
	</c:if>
	
	
	<c:if test="${not empty dataSource.getStartDate(lang) and not empty dataSource.getEndDate(lang)}">
		<!-- temporal -->
		<meta property="dct:temporal" content="${dataSource.getStartDate(lang)}/${dataSource.getEndDate(lang)}"/>
	</c:if>
	
	
	<c:if test="${not empty dataSource.getIssuedAsString(lang)}">
		<!-- issued and modified date -->
		<meta property="dct:issued" content="${dataSource.getIssuedAsString(lang)}" datatype="xsd:date"/>
	</c:if>
	<c:if test="${not empty dataSource.getModifiedAsString(lang)}">
		<meta property="dct:modified" content="${dataSource.getModifiedAsString(lang)}" datatype="xsd:date"/>
	</c:if>
	
	
	<c:if test="${not empty dataSource.getContactAsString(lang)}">
		<!-- Contact Point -->
		<meta property="dct:publisher" href="${dataSource.getContactAsString(lang)}" />
	</c:if>
	
	
	<c:forEach items="${dataSource.getSpatial(lang)}" var="sourceSpatial" varStatus="i">
		<!-- Spatial -->
		<meta property="dct:spatial" content="${sourceSpatial}"/>
	</c:forEach>
	
	<c:forEach items="${dataSource.getKeywords(lang)}" var="sourceKeyword" varStatus="i">
		<!-- Subjects -->
		<meta property="dct:subject" content="${sourceKeyword}"/>
	</c:forEach>
	
	
	<c:if test="${not empty dataSource.getSourceAsString(lang)}">
		<!-- source -->
		<meta property="dct:source" href="${dataSource.getSourceAsString(lang)}"/>
	</c:if>
	
	<c:if test="${not empty dataSource.getConformsToAsString(lang)}">
		<!-- Conforms -->
		<meta property="dct:conformsTo" href="${dataSource.getConformsToAsString(lang)}"/>
	</c:if>
	
</c:if>

 <!--fin Isidore -->


</head>
<body>

	<jsp:include page="navbar.jsp">
		<jsp:param name="active" value="explorer" />
	</jsp:include>

	<div class="container-md mt-3 border">
		<div class="container-md mt-3 border" style="margin-left: 20px; margin-right: 20px;">
			

		<c:choose>
			<c:when test="${fn:length(data.sources) == 1}">
				<div class="row">
					<div class="col-md-12">
						<h1>
							<fmt:message key="explore.title" />
							${data.sourcesDisplayString}
						</h1>
						<p>
							<a href="<c:url value="/sourcesSelect" />"><small><i
									class="fal fa-angle-left"></i>&nbsp;<fmt:message
										key="explore.sources.change" /></small></a>
						</p>
					</div>
				</div>
			
				<div class="row">
					<div class="col-md-8">
						<div id="hiddenSources">
							<c:forEach items="${data.sources}" var="source" varStatus="i">
								<input type="hidden" value="${source.sourceString}"
									name="source" />										
							</c:forEach>
						</div>

						<!-- Sparnatural -->
						<div class="card" id="sparnatural-container">
							<div class="card-body">
								<div>
									<div id="sparnatural"></div>
									<div id="sparnatural-control" class="card-text">
										<div class="row no-gutters justify-content-end">
											<div class="col-4">
												<div class="float-right">
													<button type="button" id="run"
														class="btn  btn-amber disabled">
														<fmt:message key="explore.run" />
													</button>
													&nbsp;
													<fmt:message key="explore.andDisplayResultAs" />
													&nbsp;
												</div>
											</div>
											<div class="col-2">
												<select class="form-control form-control-lg" id="view">
													<option value="table" selected><fmt:message
															key="explore.output.table" /></option>
													<option value="leaflet"><fmt:message
															key="explore.output.leaflet" /></option>
													<option value="timeline"><fmt:message
															key="explore.output.timeline" /></option>
												</select>
											</div>
										</div>
										<div class="row no-gutters justify-content-end">
											<div class="col-2">
												<div class="collapse" id="federationWarning"
													style="color: red;">
													<i class="fal fa-exclamation-triangle"></i>&nbsp;
													<fmt:message key="explore.output.federatedWarning" />
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- fin Code Sparnatural -->

						<input type="hidden" name="query" id="sparql" /> <input
							type="hidden" name="rawExpandedSparql" id="rawExpandedSparql" />

						<div class="form-group">
							<div id="sparqlResultAlert"></div>
							<div id="expandedQueryContainer">
								<textarea class="form-control" rows="15" readonly="readonly"
									name="expandedQuery" id="expandedQuery"></textarea>
							</div>
							<div id="loading"
								style="width: 100%; text-align: center; display: none;">
								<img
									src="<c:url value="/resources/img/Polar-1.5s-325px.gif" />" />
							</div>
							<div id="yasr"></div>
						</div>
					</div>
					
					<div class="col-md-4">									
						<div class="card sourceLeftPanel">
							<div class="card-header sourceCardHeader"> 										
									<!--  1 : afficher les métadonnées de la source en JSP
											<h4 class="card-title" style="align-content: center;"> -->
											<h4 class="card-title">${dataSource.getTitle(lang)}</h4>													
											<%="<p><em>" %>${dataSource.getShortDesc(lang)}<%="</em></p>" %>
										</div>
										
										<div class="card-body">
											<c:if test="${dataSource.getSpatialAsString(lang) != null}">
												<strong><fmt:message key="sources.desc.spatial" />: </strong> ${dataSource.getSpatialAsString(lang)}<br>
											</c:if>								
											<c:choose>
												<c:when test="${dataSource.getStartDate(lang) != null && dataSource.getEndDate(lang) != null}">
													<strong><fmt:message key="sources.desc.temporal" />: </strong>${dataSource.getStartDate(lang)} <fmt:message key="sources.desc.temporal.to" /> ${dataSource.getEndDate(lang)}<br>
												</c:when>
												<c:when test="${dataSource.getStartDate(lang) != null && dataSource.getEndDate(lang) == null}">
													<strong><fmt:message key="sources.desc.temporal" />: </strong>${dataSource.getStartDate(lang)}<br>
												</c:when>
												<c:when test="${dataSource.getStartDate(lang) == null && dataSource.getEndDate(lang) != null}">
													<strong><fmt:message key="sources.desc.temporal" />: </strong>${dataSource.getEndDate(lang)}<br>
												</c:when>
											</c:choose>
											<c:if test="${dataSource.getKeywordAsString(lang) != null}">
												<strong><fmt:message key="sources.desc.keywords" />: </strong>${dataSource.getKeywordAsString(lang)}<br>
											</c:if>
											<c:if test="${dataSource.getSubjectAsString(lang) != null}">
												<strong><fmt:message key="sources.desc.dcterms_subject" />: </strong>${dataSource.getSubjectAsString(lang)}<br>
											</c:if>	
											<c:set var="contact" value="${fn:indexOf(dataSource.getContactAsString(lang),'mailto')}"/>										
											<c:if test="${contact == 0}">												
												<strong><fmt:message key="sources.desc.dcat_contactPoint" />: </strong><a href="${dataSource.getContactAsString(lang)}">${dataSource.getContactAsString(lang)}</a>
												<br>
											</c:if>
											<c:if test="${fn:indexOf(dataSource.getPublisher(),'http') == 0}">
												<strong><fmt:message key="sources.desc.dcterms_publisher" />: </strong><a href="${dataSource.getPublisher()}">${dataSource.getPublisher()}</a>
												<br>
											</c:if>					 
											<c:if test="${dataSource.getIssuedAsString(lang) != null}">
												<strong><fmt:message key="sources.desc.dcterms_issued" />: </strong>${dataSource.getIssuedAsString(lang)}<br>												
											</c:if>							 
											<c:if test="${dataSource.getModifiedAsString(lang) != null}">
												<strong><fmt:message key="sources.desc.dcterms_modified" />: </strong>${dataSource.getModifiedAsString(lang)}<br>
											</c:if>
											<c:if test="${fn:indexOf(dataSource.getSourceAsString(lang),'http') == 0}">
												<strong><fmt:message key="sources.desc.dcterms_source" />: </strong><a href="${dataSource.getSourceAsString(lang)}">${dataSource.getSourceAsString(lang)}</a>
												<br>
											</c:if>
											<c:if test="${fn:indexOf(dataSource.getLicenseAsString(lang),'http') == 0}">
												<strong><fmt:message key="sources.desc.dcterms_license" />: </strong><a href="${dataSource.getLicenseAsString(lang)}">${dataSource.getLicenseAsString(lang)}</a>
												<br>
											</c:if>												
										</div> <!--  / .card-body -->
										
									</div>
						</div>
					</div>
				</div>
	
			</c:when>
			
			<c:otherwise>
				<div class="row">
					<div class="col-sm-12">
						<h1>
							<fmt:message key="explore.title" />
						</h1>
						<fmt:message key="explore.sources" />
						: ${data.sourcesDisplayString} <br />
		
						<c:if test="${data.requiresFederation}">&nbsp;&nbsp;<small
								style="color: red;"><i class="fal fa-exclamation-triangle"></i>&nbsp;<fmt:message
									key="explore.sources.federatedWarning" /></small>
						</c:if>
		
						<br /> <a href="<c:url value="/sourcesSelect" />"><small><i
								class="fal fa-angle-left"></i>&nbsp;<fmt:message
									key="explore.sources.change" /></small></a>
									
						<div id="hiddenSources">
							<c:forEach items="${data.sources}" var="source" varStatus="i">
								<input type="hidden" value="${source.sourceString}" name="source" />
							</c:forEach>
						</div>
					</div>					
				 </div>
	
	
				<div class="row">
					<div class="col-sm-12">
	
						<div class="card" id="sparnatural-container">
							<div class="card-body">
								<div>
									<div id="sparnatural"></div>
									<div id="sparnatural-control" class="card-text">
										<div class="row no-gutters justify-content-end">
											<div class="col-4">
												<div class="float-right">
													<button type="button" id="run"
														class="btn  btn-amber disabled">
														<fmt:message key="explore.run" />
													</button>
													&nbsp;
													<fmt:message key="explore.andDisplayResultAs" />
													&nbsp;
												</div>
											</div>
											<div class="col-2">
												<select class="form-control form-control-lg" id="view">
													<option value="table" selected><fmt:message
															key="explore.output.table" /></option>
													<option value="leaflet"><fmt:message
															key="explore.output.leaflet" /></option>
													<option value="timeline"><fmt:message
															key="explore.output.timeline" /></option>
												</select>
											</div>
										</div>
										<div class="row no-gutters justify-content-end">
											<div class="col-2">
												<div class="collapse" id="federationWarning"
													style="color: red;">
													<i class="fal fa-exclamation-triangle"></i>&nbsp;
													<fmt:message key="explore.output.federatedWarning" />
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
	
						<input type="hidden" name="query" id="sparql" /> <input
							type="hidden" name="rawExpandedSparql" id="rawExpandedSparql" />
	
						<div class="form-group">
							<div id="sparqlResultAlert"></div>
							<div id="expandedQueryContainer">
								<textarea class="form-control" rows="15" readonly="readonly"
									name="expandedQuery" id="expandedQuery"></textarea>
							</div>
							<div id="loading"
								style="width: 100%; text-align: center; display: none;">
								<img src="<c:url value="/resources/img/Polar-1.5s-325px.gif" />" />
							</div>
							<div id="yasr"></div>
						</div>
					</div>
				</div><!-- end row -->
				
			</c:otherwise>
		</c:choose>

			</div>
		</div>

	<!--  
		
		
		
		<div id="hiddenSources">
			<c:forEach items="${data.sources}" var="source" varStatus="i">
				<input type="hidden" value="${source.sourceString}" name="source" />
			</c:forEach>


			<!-- Balise sparnatural-container 
				 

				<div class="card" id="sparnatural-container">
					<div class="card-body">
						<div>
							<div id="sparnatural"></div>
							<div id="sparnatural-control" class="card-text">
								<div class="row no-gutters justify-content-end">
									<div class="col-4">
										<div class="float-right">
											<button type="button" id="run"
												class="btn  btn-amber disabled">
												<fmt:message key="explore.run" />
											</button>
											&nbsp;
											<fmt:message key="explore.andDisplayResultAs" />
											&nbsp;
										</div>
									</div>
									<div class="col-2">
										<select class="form-control form-control-lg" id="view">
											<option value="table" selected><fmt:message
													key="explore.output.table" /></option>
											<option value="leaflet"><fmt:message
													key="explore.output.leaflet" /></option>
											<option value="timeline"><fmt:message
													key="explore.output.timeline" /></option>
										</select>
									</div>
								</div>
								<div class="row no-gutters justify-content-end">
									<div class="col-2">
										<div class="collapse" id="federationWarning"
											style="color: red;">
											<i class="fal fa-exclamation-triangle"></i>&nbsp;
											<fmt:message key="explore.output.federatedWarning" />
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>


				


			<input type="hidden" name="query" id="sparql" /> <input
				type="hidden" name="rawExpandedSparql" id="rawExpandedSparql" />

			<div class="form-group">
				<div id="sparqlResultAlert"></div>
				<div id="expandedQueryContainer">
					<textarea class="form-control" rows="15" readonly="readonly"
						name="expandedQuery" id="expandedQuery"></textarea>
				</div>
				<div id="loading"
					style="width: 100%; text-align: center; display: none;">
					<img src="<c:url value="/resources/img/Polar-1.5s-325px.gif" />" />
				</div>
				<div id="yasr"></div>
			</div>

		</div>
		-->




	<jsp:include page="footer.jsp" />

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.js"></script>
	<script src="<c:url value="/resources/js/jquery-3.3.1.min.js" />"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/yasgui-yasr@2.12.19/dist/yasr.bundled.min.js"></script>

	<script src="<c:url value="/resources/MDB-Free/js/popper.min.js" />"></script>
	<script src="<c:url value="/resources/MDB-Free/js/bootstrap.min.js" />"></script>
	<script src="<c:url value="/resources/js/timeline.js" />"></script>

	<!-- datepicker -->
	<script
		src="https://cdn.jsdelivr.net/npm/@chenfengyuan/datepicker@1.0.9/dist/datepicker.min.js"></script>

	<!-- sparnatural -->
	<script src="<c:url value="/resources/js/sparnatural.js" />"></script>

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
       				// set plugins
       				"outputPlugins": ["error", "boolean", "rawResponse", "table", "pivot", "leaflet", "gchart", "timeline"],
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
		 
		 var sourcesUrls = [];
		 $('#hiddenSources input').each(function(){
			 sourcesUrls.push(encodeURIComponent($(this).val()));
	     });
		 
		 sourceStringParam = sourcesUrls.join("&source=");
		 
		 console.log(sourceStringParam);
		 
		 $.ajax({
	         url : 'expand',
	         type : 'POST', 
	         data : 'query=' + encodeURIComponent(sparql) + '&source=' + sourceStringParam + '&view='+($( "#view option:selected" ).val()), 
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
			 if(!$(this).hasClass("disabled")) {
				 execute();
			 }
		 });
		 
		 // event on the display type select
		 $( "#view" ).change(function() {
			 console.log($(this).val());
			 if( $(this).val() === 'leaflet' || $(this).val() === 'timeline' ) {
				 $("#federationWarning").addClass("show");
			 } else {
				 $("#federationWarning").removeClass("show");
			 }
		 });
		 
		 // YASR.plugins.table.defaults = { "mergeLabelsWithUris": true };
		 YASR.registerOutput("timeline",timelinePlugin);
// 		 yasr = YASR(document.getElementById("yasr"), 
// 			{
// 			 outputPlugins: ["error", "boolean", "rawResponse", "table", "pivot", "leaflet", "timeline"]
// 			}	 
// 		 );

		 // rebuild source string
		 var sourcesUrls = [];
		 $('#hiddenSources input').each(function(){
			 sourcesUrls.push(encodeURIComponent($(this).val()));
	     });
		 
		 var sources = sourcesUrls.join(" ");

		 sparnatural = document.getElementById('sparnatural').Sparnatural({
			config: 'sparnatural-config.ttl' ,
			<c:if test="${fn:length(data.sources) == 1}">
			// don't do that - this will work only if query expansion is done client side
			// filterConfigOnEndpoint: true,
			// defaultEndpoint: '/federation/sparql?default-graph-uri='+sourcesUrls[0],
			</c:if>
			language: '${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}',
			addDistinct: true,
			sendQueryOnFirstClassSelected: true,
			noTypeCriteriaForObjects: ["http://www.openarchaeo.fr/explorateur/onto#Type", "http://www.openarchaeo.fr/explorateur/onto#Lieu"],
			autocomplete : {
				autocompleteUrl: function(domain, property, range, key) {
					return '/federation/api/autocomplete?sources='+sources+'&key='+key+'&domain='+encodeURIComponent(domain)+'&property='+encodeURIComponent(property)+'&range='+encodeURIComponent(range) ;
				}
			},
			list : {
				listUrl: function(domain, property, range) {
					return '/federation/api/list?lang=${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}&sources='+sources+'&domain='+encodeURIComponent(domain)+'&property='+encodeURIComponent(property)+'&range='+encodeURIComponent(range) ;
				}
			},
			dates : {
				datesUrl: function(domain, property, range) {
					return '/federation/api/periods?lang=${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}' ;
				},
				elementLabel: function(element) {
					return element.label + ((element.synonyms)?' '+element.synonyms.join(' '):'');
				},
			},
			onQueryUpdated: function(queryString, queryJson) {
				// ici on récupère la requete Sparql grace au premier parametre de la fonction
				console.log(queryString) ;
				$('#sparql').val(queryString);
				$('#run').removeClass("disabled");
			}
		  });
		 
	 });
	  
	</script>
</body>
</html>