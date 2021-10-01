<!--  
<!DOCTYPE html>
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!-- setup the locale for the messages based on the language in the session -->
<fmt:setLocale value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}"/>
<fmt:setBundle basename="fr.humanum.openarchaeo.explorateur.i18n.OpenArchaeo"/>

<c:set var="data" value="${requestScope['sourcesDefinition']}" />
<c:set var="lang" value="${sessionScope['fr.humanum.openarchaeo.SessionData'].userLocale.language}" />

<html 
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:skos="http://www.w3.org/2004/02/skos/core#"
xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
xmlns:foaf="http://xmlns.com/foaf/0.1/"
>

<head>
<title><fmt:message key="window.app" /> | <fmt:message key="sources.window.title" /></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<!-- Font Awesome -->
<link rel="stylesheet" href="<c:url value="/resources/fa/css/all.min.css" />">

<!-- Bootstrap + Material Design Bootstrap -->
<link rel="stylesheet" href="<c:url value="/resources/MDB-Free/css/bootstrap.min.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/MDB-Free/css/mdb.min.css" />">

<!-- Vis.js -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.css">

<!-- favicon, if any -->
<link rel="icon" type="image/png" href="resources/favicon.png" />

<!-- JQuery UI -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">


<!-- App-specific CSS -->
<link rel="stylesheet" href="<c:url value="/resources/css/openarchaeo-explorateur.css" />" />

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

	<div class="col-3" id="source{{:#index}}">
		<div class="card sourceCard">
			<div class="card-header sourceCardHeader">
				<h4 class="card-title"><input type="checkbox" class="selectSourceCheckbox" data-uri="{{:sourceString}}" data-endpoint="{{:endpoint}}" />&nbsp;{{:title}}</h4>
				<p><em>{{:shortDesc}}</em></p>			 
		  	</div> <!-- / .card-header -->
			
		   	<div>	
				<smaller><a data-toggle="collapse" href="#source{{:#index}}_details"><fmt:message key="sources.desc.details" />&nbsp;<i class="fal fa-angle-down"></i></a></smaller>					  
		  		<div  class="collapse card-body" id="source{{:#index}}_details">
    				<strong><fmt:message key="sources.desc.spatial" /> :</strong><br> <ul class="inline-list">{{for spatial}}<li>{{:}}</li>{{/for}}</ul></li><br>
					<strong><fmt:message key="sources.desc.temporal" /> :</strong><br> <fmt:message key="sources.desc.temporal.from" /> {{:startYear}} <fmt:message key="sources.desc.temporal.to" /> {{:endYear}}</li><br>
					<strong><fmt:message key="sources.desc.keywords" /> :</strong><br> <ul class="inline-list">{{for keywords}}<li>{{:}}</li>{{/for}}</ul></li><br>
					<strong><fmt:message key="sources.desc.dcterms_subject" /> :</strong><br> <ul class="inline-list">{{for subject}}<li>{{:}}</li>{{/for}}</ul></li>
				</div>
			</div>
			<!--
			<div class="collapse" id="source{{:#index}}_details">
				<ul class="fa-ul">
					<li><i class="fa-li fal fa-angle-right"></i><fmt:message key="sources.desc.dcat_contactPoint" /> : {{if contact && (contact.indexOf('http') == 0) }}<a href="{{:contact}}">{{:contact}}</a>{{else contact && (contact.indexOf('mailto') == 0)}}<a href="{{:contact}}">{{:contact.substring(7)}}</a>{{else}}{{:contact}}{{/if}}</li>
					<li><i class="fa-li fal fa-angle-right"></i><fmt:message key="sources.desc.dcterms_publisher" /> : {{if publisher && (publisher.indexOf('http') == 0) }}<a href="{{:publisher}}">{{:publisher}}</a>{{else}}{{:publisher}}{{/if}}</li>
					<li><i class="fa-li fal fa-angle-right"></i><fmt:message key="sources.desc.dcterms_issued" /> : {{:issued}}</li>
					<li><i class="fa-li fal fa-angle-right"></i><fmt:message key="sources.desc.dcterms_modified" /> : {{:modified}}</li>
					<li><i class="fa-li fal fa-angle-right"></i><fmt:message key="sources.desc.dcterms_source" /> : {{if source && (source.indexOf('http') == 0 || source.indexOf('mailto') == 0) }}<a href="{{:source}}">{{:source}}</a>{{else}}{{:source}}{{/if}}</li>
					<li><i class="fa-li fal fa-angle-right"></i><fmt:message key="sources.desc.dcterms_license" /> : {{if license && (license.indexOf('http') == 0 || license.indexOf('mailto') == 0) }}<a href="{{:license}}">{{:license}}</a>{{else}}{{:license}}{{/if}}</li>
				</ul>
			</div> -->
		  </div> <!-- / .card-body -->
		</div> 
	</div>

{{else}}
  <div class="col-12"><h4><fmt:message key="sources.result.nomatching" /></h4></div>
{{/for}}
</script>


</head>

<body>



	<jsp:include page="navbar.jsp">
		<jsp:param name="active" value="explorer"/>
	</jsp:include>

	<div class="container-fluid">
		<div class="row justify-content-center">
			<div class="col-sm-11">			
				<div class="card" id="sourcesSelectCard">
				  <div class="card-body">
				    <h1 class="card-title"><i class="fal fa-database"></i>&nbsp;&nbsp;<fmt:message key="sources.title" /></h1>
				    <div class="card-text" id="sourcesCardText">
				    		<div class="container-fluid">
				    			<div class="row">
				    				<div class="col-sm-3">
				    					<h4><fmt:message key="sources.facet.search" /></h4>
				    					<div id="fulltextSearchCriteria">
				    						<input type="text" name="fullTextSearch" id="fullTextSearch" placeholder="<fmt:message key="sources.facet.search.placeholder" />" />
				    					</div>
				    					<br />
				    					<h4><fmt:message key="sources.facet.keywords" /></h4>
						    			<div id="keywordsFacet"></div>
						    			<br />
						    			<h4><fmt:message key="sources.facet.temporal" /></h4>
										<input type="text" id="years" readonly style="" />
										<div id="slider-range"></div>
										<br />
										<h4><fmt:message key="sources.facet.spatial" /></h4>
										<div id="spatialFacet"></div>
										<br />
										<h4><fmt:message key="sources.facet.subject" /></h4>
										<div id="subjectFacet"></div>
									</div>
									<div class="col-sm-9">									
										<div class="container-fluid" id="sourcesList">
											<div class="row no-gutters" id="sourcesResults">
								    			<c:forEach items="${data}" var="source" varStatus="i">
								    				<div class="col-4">
									    				<div class="card sourceCard ">
									    				  <div class="card-header sourceCardHeader" id="heading${i.index}">
									    				  	<div class="row">
									    				  		<div class="col-sm-10">
										    				  		<h4 class="card-title"><input type="checkbox" class="selectSourceCheckbox" data-uri="${source.sourceString}" data-endpoint="${source.endpoint}" />&nbsp;${source.getTitle(lang)}</h4>
										    				  		<p><em>${source.getShortDesc(lang)}</em></p>
									    				  		</div>
									    				  	</div>
									    				  </div> <!-- / .card-header -->
														 <div class="card-body">
												    		Loading data...
														  </div> <!--  / .card-body -->
														</div> 
													</div>
												</c:forEach>
											</div>
							    		</div>
									</div>
								</div> <!-- / .row -->
								<!-- In a separate row so that button does not go up when there are no matching results -->
								<div class="row no-gutters">
									<div class="col-1 offset-3">
										<form action="explorer" method="get" style="margin:auto;" name="formsource" id="formsource">
							    			<div id="hiddenSources">
							    				<!-- here be inserted hidden inputs -->
							    			</div>
											<button class="btn btn-amber" id="submitSources"><fmt:message key="sources.validate" /></button>
										</form>
									</div>
									<div class="col-8">
										<div class="collapse alert alert-warning alert-dismissible fade" role="alert" id="federationAlert">
										  <strong>Warning !</strong> Querying all these sources requires federated querying, which may result in poor performance.
										</div>
									</div>
								</div>
				    		</div>
				    </div>
				  </div>
				</div>
			
			</div>
		</div>
		
	</div>
	
	<jsp:include page="footer.jsp" />
	
	
	<script src="<c:url value="/resources/MDB-Free/js/jquery-3.1.1.min.js" />"></script>
	<script src="<c:url value="/resources/MDB-Free/js/popper.min.js" />"></script>
	<script src="<c:url value="/resources/MDB-Free/js/bootstrap.min.js" />"></script>
	<script src="<c:url value="/resources/js/itemsjs.min.js" />"></script>
	
	<!-- Jquery UI for range slider -->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	
	<!-- JSRender for templating -->
	<script src="https://www.jsviews.com/download/jsrender.js"></script>
	
	<script type="text/javascript">

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


	</script>
	
</body>
</html>