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

<c:set var="dataSource" value="${requestScope['sourcesDefinition']}" />
<c:set var="dataMeta" value="${requestScope['sourcesDefinitionJson']}" />
<c:set var="lang"
	value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}" />

<!-- Start metadonnées -->

<script type="text/javascript">
	var sources = ${requestScope['sourcesDefinitionJson']};
</script>

<!-- Declare a JsRender template, in a script block: -->
<script id="keyWordTagTemplate" type="text/x-jsrender">
	<span class="badge badge-pill {{if selected}}badge-success{{else}}badge-secondary{{/if}} keyword-badge" data-value="{{:key}}">
		<span class="key">{{:key}}</span>
		(<span class="doc_count">{{:doc_count}}</span>)
    </span>
</script>

<script id="spatialTagTemplate" type="text/x-jsrender">
	<span class="badge badge-pill {{if selected}}badge-success{{else}}badge-secondary{{/if}} spatial-badge" data-value="{{:key}}">
		<span class="key">{{:key}}</span>
		(<span class="doc_count">{{:doc_count}}</span>)
    </span>
</script>

<script id="subjectTagTemplate" type="text/x-jsrender">
	<span class="badge badge-pill {{if selected}}badge-success{{else}}badge-secondary{{/if}} subject-badge" data-value="{{:key}}">
		<span class="key">{{:key}}</span>
		(<span class="doc_count">{{:doc_count}}</span>)
    </span>
</script>

<script id="sourceTemplate" type="text/x-jsrender">
{{for items}}
	<div class="col-15" id="source{{:#index}}">
		<div class="card sourceCard">
		  <div class="card-header sourceCardHeader">
			  <h4 class="card-title">					
			  		{{:title}}
			  </h4>
			  <p><em>{{:shortDesc}}</em></p>			  
		  </div> <!-- / .card-header -->
		  <div class="card-body">
    		<strong><fmt:message key="sources.desc.spatial" /></strong> : <ul class="inline-list">{{for spatial}}<li>{{:}}</li>{{/for}}</ul></li><br/>
			<strong><fmt:message key="sources.desc.temporal" /></strong> : <fmt:message key="sources.desc.temporal.from" /> {{:startYear}} <fmt:message key="sources.desc.temporal.to" /> {{:endYear}}</li><br/>
			<strong><fmt:message key="sources.desc.keywords" /></strong> : <ul class="inline-list">{{for keywords}}<li>{{:}}</li>{{/for}}</ul></li><br/>
			<strong><fmt:message key="sources.desc.dcterms_subject" /></strong> : <ul class="inline-list">{{for subject}}<li>{{:}}</li>{{/for}}</ul></li><br/>
			<smaller><a data-toggle="collapse" href="#source{{:#index}}_details"><fmt:message key="sources.desc.details" />&nbsp;<i class="fal fa-angle-down"></i></a></smaller><br/>
			<div id="source{{:#index}}_details">
				<fmt:message key="sources.desc.dcat_contactPoint" /> : {{if contact && (contact.indexOf('http') == 0) }}<a href="{{:contact}}">{{:contact}}</a>{{else contact && (contact.indexOf('mailto') == 0)}}<a href="{{:contact}}">{{:contact.substring(7)}}</a>{{else}}{{:contact}}{{/if}}</li><br/>
				<fmt:message key="sources.desc.dcterms_publisher" /> : {{if publisher && (publisher.indexOf('http') == 0) }}<a href="{{:publisher}}">{{:publisher}}</a>{{else}}{{:publisher}}{{/if}}</li><br/>
				<fmt:message key="sources.desc.dcterms_issued" /> : {{:issued}}</li><br/>
				<fmt:message key="sources.desc.dcterms_modified" /> : {{:modified}}</li><br/>
				<fmt:message key="sources.desc.dcterms_source" /> : {{if source && (source.indexOf('http') == 0 || source.indexOf('mailto') == 0) }}<a href="{{:source}}">{{:source}}</a>{{else}}{{:source}}{{/if}}</li><br/>
				<fmt:message key="sources.desc.dcterms_license" /> : {{if license && (license.indexOf('http') == 0 || license.indexOf('mailto') == 0) }}<a href="{{:license}}">{{:license}}</a>{{else}}{{:license}}{{/if}}</li>				
			</div>
		  </div> <!-- / .card-body -->
		</div> 
	</div>

{{else}}
  <div class="col-12"><h4><fmt:message key="sources.result.nomatching" /></h4></div>
{{/for}}
</script>
<!-- fin metadonnées -->


<html>
<head>
<title><fmt:message key="window.app" /> | <fmt:message
		key="explore.window.sparnatural" /></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">


<!-- Font Awesome -->
<link rel="stylesheet"
	href="<c:url value="/resources/fa/css/all.min.css" />">

<!-- Bootstrap + Material Design Bootstrap -->
<link rel="stylesheet"
	href="<c:url value="/resources/MDB-Free/css/bootstrap.min.css" />" />
<link rel="stylesheet"
	href="<c:url value="/resources/MDB-Free/css/mdb.min.css" />">

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


<!-- datepicker -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/@chenfengyuan/datepicker@1.0.9/dist/datepicker.min.css">


<!-- Call Isidore RDFa -->
<link rel="dc:identifier" href="demo" />
<c:forEach items="${dataSource}" var="source" varStatus="i">
	
	<meta property="dct:title" content="${source.getTitle(lang)}" />
	<meta property="dct:description" content="${source.getShortDesc(lang)}" xml:lang="${lang}" />
	
	<!-- # couverture temporelle -->
	<meta property="dct:temporal" contest="schema:startDate "${""+source.getStartDate(lang) }"^^xsd:gYear ; schema:endDate" ${""+source.getEndDate(lang) }"^^xsd:gYear ;"/>
	
	<!-- Contact Point -->
	
	
	<!-- Spatial -->
	<c:forEach items="${source.getSpatial(lang)}" var="sourceSpatial" varStatus="i">
		<meta property="dct:spatial" content="${sourceSpatial }"/>
	</c:forEach>
	<!-- Keys -->
	<c:forEach items="${source.getKeywords(lang)}" var="sourceKeys" varStatus="i">
		<meta property="dct:subject" content="${sourceKeys }"/>
	</c:forEach>
	
	<meta property="dc:format" content="text/html" />	
	<meta property="dc:relation" content="${source.getSourceString()}" />
	
	
			
</c:forEach>

 <!--fin Isidore -->


</head>
<body>

	<jsp:include page="navbar.jsp">
		<jsp:param name="active" value="explorer" />
	</jsp:include>



	<c:set var="count" value="0" scope="page" />
	<c:forEach items="${data.sourcesDisplayString}" var="thisItem">
		<c:set var="count" value="${count + 1}" scope="page" />		
	</c:forEach>

	<c:choose>
		<c:when test="${count == 1}">
			<div class="container-md mt-3 border">

				<div style="margin-left: 10px">
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
				<div class="container-md mt-3 border">
					<div class="row" style="margin-left: 20px; margin-right: 10px;">
						<div style="width: 68%;">
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
						<div style="width: 30%;">
							<div class="card-body" style="">
								<div class="row" id="sourcesResults">
									<c:forEach items="${dataSource}" var="source" varStatus="i">										
										<div class="card sourceCard">
											<div class="card-header sourceCardHeader"
												id="heading${i.index}">
												<div class="row">
													<div class="col-ms-6">
														<h4 class="card-title">${source.sourceString}
															${source.endpoint} ${source.getTitle(lang)}</h4>														
														<p><em>${source.getShortDesc(lang)}</em></p>														
													</div>
												</div>												
											</div>
										</div>
										
									</c:forEach>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<div class="col-sm-10">
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
			</div>
		</c:otherwise>
	</c:choose>

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

	<!-- <script src="<c:url value="/resources/MDB-Free/js/jquery-3.1.1.min.js" />"></script> -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.js"></script>
	<script src="<c:url value="/resources/js/jquery-3.3.1.min.js" />"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/yasgui-yasr@2.12.19/dist/yasr.bundled.min.js"></script>

	<script src="<c:url value="/resources/MDB-Free/js/popper.min.js" />"></script>
	<script src="<c:url value="/resources/MDB-Free/js/bootstrap.min.js" />"></script>
	<script src="<c:url value="/resources/js/timeline.js" />"></script>

	<!-- metadonnees -->
	<script src="<c:url value="/resources/js/itemsjs.min.js" />"></script>

	<!-- datepicker -->
	<script
		src="https://cdn.jsdelivr.net/npm/@chenfengyuan/datepicker@1.0.9/dist/datepicker.min.js"></script>

	<!-- sparnatural -->
	<script src="<c:url value="/resources/js/sparnatural.js" />"></script>


	<!-- Processus Metadonnées -->

	<!-- Jquery UI for range slider -->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

	<!-- JSRender for templating -->
	<script src="https://www.jsviews.com/download/jsrender.js"></script>


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

		 $('#sparnatural').Sparnatural({
			config: 'sparnatural' ,
			// config: 'sparnatural-config.json',
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
	 
	 
	 // Processus Metadonnées
	 
	 enableSourceBehavior = function() {
		$(".selectSourceCheckbox").click(function () {
			if($(this).prop('checked')) {
				// set selected class on this one
				$(this).closest(".sourceCardHeader").addClass("sourceCardHeader-selected");
			} else {
				$(this).closest(".sourceCardHeader").removeClass("sourceCardHeader-selected");
			}
			
			// recompute value of sources
			$("#hiddenSources").html("")
			$(".selectSourceCheckbox:checked").each(function( index ) { 
				$("#hiddenSources").append("<input type='hidden' name='source' value="+$(this).attr('data-uri')+" />");
			});
			
			// enable submit button if needed
			if($(".selectSourceCheckbox:checked").length > 0) {
    			$('#submitSources').attr('disabled', false);
			} else {
				$('#submitSources').attr('disabled', true);
			}
			
			// enable warning on federation if needed
			var endpoints = $('.selectSourceCheckbox:checked').map(function() {
				return $(this).attr('data-endpoint');
			}).get();
			// keep unique values
			endpoints = jQuery.uniqueSort( endpoints );
			if(endpoints.length > 1) {
				console.log("Warning on federation !");
				$("#federationAlert").addClass("show");
			} else {
				$("#federationAlert").removeClass("show");
			}
		});
	}
	 
	 
	 triggerSearch = function() {
		
		var min = $( "#slider-range" ).slider( "values", 0 );
		var max = $( "#slider-range" ).slider( "values", 1 );
		
		// gets all the selected keywords based on CSS class
		var keywords = $(".keyword-badge.badge-selected").map(function() {return $(this).attr("data-value"); }).get();
		// get all selected spatials
		var spatial = $(".spatial-badge.badge-selected").map(function() {return $(this).attr("data-value"); }).get();
		// get all selected subjects
		var subjects = $(".subject-badge.badge-selected").map(function() {return $(this).attr("data-value"); }).get();
		
		// get full text criteria if present
		var fullTextCriteria = $( "#fullTextSearch" ).val();
		
		var searchParameters = {
	  			  per_page: 1000,
	  			  sort: 'title_asc',
	  			  filters: {
	  				  keywords: keywords,
	  				  spatial: spatial,
	  				  subject: subjects
	  			  },
	  			  query:fullTextCriteria,
	   			  filter: function(item) {
	  				    return (
	  				    		( item.startYear >= min && item.startYear <= max )
	  				    		||
	  				    		( item.endYear >= min && item.endYear <= max )
	  				    		||
	  				    		// case of selected range inside the range of the item
	  				    		( item.endYear > max && item.startYear < min )
	  				    );
	  				  }
	  			  };
		
		// log the search parameters if needed
		console.log(JSON.stringify(searchParameters, null, 2));
		
		// trigger search
		var results = itemsjs.search(searchParameters);
		
		// display the results
		displaySearchResult(results);
			
	}
	
	displaySearchResult = function(results) {			
		
		// full log of results if needed
		// console.log(JSON.stringify(results, null, 2));
		
		// small log of total results
		console.log(results.pagination.total);
		
		// Update the state of all keywords
		$(".keyword-badge").each(function() {
			// finds this keyword in aggregation results
			var bucket = results.data.aggregations.keywords.buckets.find(v => v.key == $(this).attr("data-value"));
			
			// if not found
			if (!bucket) {
				// disable the pill
				$(this).addClass("badge-disabled");
				$(this).addClass("disabled");
				// set count to 0
				$(".doc_count", this).html("0");
				// remove click event
				$(this).unbind("click");
			} else {
				// yes, it is found
				// re-enable the pill
				$(this).removeClass("badge-disabled");
				$(this).removeClass("disabled");
				// sets the cound
				$(".doc_count", this).html( bucket.doc_count );						
				
				// if selected, change the color of the pill
				if(bucket.selected) {
					$(this).addClass("badge-selected");
				} else {
					$(this).removeClass("badge-selected");
				}
				
				
				// unbund previous existing click event
				$(this).unbind('click');
				// register click behavior on keywords pills
				$(this).click(function() {
					// set a marker to indicated it is a selected value - will be read when generating query
					$(this).toggleClass("badge-selected");
					triggerSearch();
				});
			}
		});
		
		// update the state of spatials
		$(".spatial-badge").each(function() {
			// finds this keyword in aggregation results
			var bucket = results.data.aggregations.spatial.buckets.find(v => v.key == $(this).attr("data-value"));
			
			// if not found
			if (!bucket) {
				// disable the pill
				$(this).addClass("badge-disabled");
				$(this).addClass("disabled");
				// set count to 0
				$(".doc_count", this).html("0");
				// remove click event
				$(this).unbind("click");
			} else {
				// yes, it is found
				// re-enable the pill
				$(this).removeClass("badge-disabled");
				$(this).removeClass("disabled");
				// sets the cound
				$(".doc_count", this).html( bucket.doc_count );						
				
				// if selected, change the color of the pill
				if(bucket.selected) {
					$(this).removeClass("badge-secondary");
					$(this).addClass("badge-success");
				} else {
					$(this).removeClass("badge-success");
					$(this).addClass("badge-secondary");
				}
				
				
				// unbund previous existing click event
				$(this).unbind('click');
				// register click behavior on keywords pills
				$(this).click(function() {
					// set a marker to indicated it is a selected value - will be read when generating query
					$(this).toggleClass("badge-selected");
					triggerSearch();
				});
			}
		});
		
		// update the state of collections
		$(".subject-badge").each(function() {
			// finds this collection in aggregation results
			var bucket = results.data.aggregations.subject.buckets.find(v => v.key == $(this).attr("data-value"));
			
			// if not found
			if (!bucket) {
				// disable the pill
				$(this).addClass("badge-disabled");
				$(this).addClass("disabled");
				// set count to 0
				$(".doc_count", this).html("0");
				// remove click event
				$(this).unbind("click");
			} else {
				// yes, it is found
				// re-enable the pill
				$(this).removeClass("badge-disabled");
				$(this).removeClass("disabled");
				// sets the count
				$(".doc_count", this).html( bucket.doc_count );						
				
				// if selected, change the color of the pill
				if(bucket.selected) {
					$(this).removeClass("badge-secondary");
					$(this).addClass("badge-success");
				} else {
					$(this).removeClass("badge-success");
					$(this).addClass("badge-secondary");
				}				
				
				// unbund previous existing click event
				$(this).unbind('click');
				// register click behavior on keywords pills
				$(this).click(function() {
					// set a marker to indicated it is a selected value - will be read when generating query
					$(this).toggleClass("badge-selected");
					triggerSearch();
				});
			}
		});
		
		
		
		var tmpl = $.templates("#sourceTemplate"); // Get compiled template
		var sourcesHtml = tmpl.render(results.data);
		$("#sourcesResults").html(sourcesHtml);
		
		enableSourceBehavior();
	}
	
	
	
	// sets the min and max of slider
	var startYears = sources.map(s => s["startYear"]);
	var endYears = sources.map(s => s["endYear"]);
	var minYear = Math.min.apply( null, startYears );
	var maxYear = Math.max.apply( null, endYears );
	$('#yearRange').attr('min', minYear);
	$('#yearRange').attr('max', maxYear);    		
	  
	// init slider
    $( "#slider-range" ).slider({
      range: true,
      min: minYear,
      max: maxYear,
      values: [ minYear, maxYear ],
   	  step: 10,
      slide: function( event, ui ) {
    	  // on slider change, print the values and trigger the search
        $( "#years" ).val( ui.values[ 0 ] + " / " + ui.values[ 1 ] );		        
        triggerSearch();
      }
    });
    
	// on first init print the values
    $( "#years" ).val( $( "#slider-range" ).slider( "values", 0 ) +
      " / " + $( "#slider-range" ).slider( "values", 1 ) );
	
	// itemjs configuration
		var configuration = {
		  searchableFields: ["title", "keywords", "shortDesc", "spatial"],
		  sortings: {
		    title_asc: {
		      field: 'title',
		      order: 'asc'
		    }
		  },
		  aggregations: {
		    keywords: {
		      title: 'Keywords',
		      sort: 'term',
		      order: 'asc'
		    },
		    spatial: {
		      title: 'Spatial',
		      sort: 'term',
		      order: 'asc'
		    },
		    subject: {
		      title: 'Subject',
		      sort: 'term',
		      order: 'asc'
		    }
		  }
		}

		// init itemjs with configuration and data
		itemsjs = itemsjs(sources, configuration);

		// trigger an empty search to match all items
		var results = itemsjs.search({
		  per_page: 1000,
		  sort: 'title_asc',
		});
		
		// prints all tags
		var tmpl = $.templates("#keyWordTagTemplate"); // Get compiled template
		var keywordsHtml = results.data.aggregations.keywords.buckets.sort((a, b) => a.key.localeCompare(b.key)).map(
				element => {
					var html = tmpl.render(element);
					return html;
				}
		).join("&nbsp;");
		$("#keywordsFacet").html(keywordsHtml);			
		
		// print all spatials
		var spatialTmpl = $.templates("#spatialTagTemplate"); // Get compiled template
		var spatialHtml = results.data.aggregations.spatial.buckets.sort((a, b) => a.key.localeCompare(b.key)).map(
				element => {
					return spatialTmpl.render(element);
				}
		).join("&nbsp;");
		$("#spatialFacet").html(spatialHtml);	
		
		var subjectTmpl = $.templates("#subjectTagTemplate"); // Get compiled template
		var subjectHtml = results.data.aggregations.subject.buckets.sort((a, b) => a.key.localeCompare(b.key)).map(
				element => {
					return subjectTmpl.render(element);
				}
		).join("&nbsp;");
		$("#subjectFacet").html(subjectHtml);
	
		// display the result of the empty search
		displaySearchResult(results);
	
	
		$( document ).ready(function() {
			
			$('#submitSources').attr('disabled', true);
			enableSourceBehavior();
    		$("#submitSources").click(function () {
    		    if($("#sources").val().length != 0) {
    		    	$("#formsource").submit();
    		    }
    		});
    		
    		// keyup and not keypress to capture `Delete` key, and not keydown which is fired _before_ the character is inserted
    		$("#fullTextSearch").keyup(function () {
    			triggerSearch();
    		});
				
	 	}); // end document ready	 
	 // fin processus Metadonnées
	 
	  
	</script>
</body>
</html>