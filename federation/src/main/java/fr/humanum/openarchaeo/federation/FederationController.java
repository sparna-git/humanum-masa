package fr.humanum.openarchaeo.federation;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Set;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.jena.query.QueryFactory;
import org.apache.jena.query.Syntax;
import org.eclipse.rdf4j.query.resultio.QueryResultFormat;
import org.eclipse.rdf4j.query.resultio.TupleQueryResultFormat;
import org.eclipse.rdf4j.repository.Repository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import fr.humanum.openarchaeo.federation.admin.SessionManager;
import fr.humanum.openarchaeo.federation.source.FederationSource;

@Controller
public class FederationController {

	private Logger log = LoggerFactory.getLogger(this.getClass().getName()); 

	private final FederationBusinessServices federationService;

	@Inject
	public FederationController(FederationBusinessServices federationService) throws FileNotFoundException, IOException {
		this.federationService=federationService;
	}


	@RequestMapping(value = {"/","sparql-form"},method=RequestMethod.GET)
	public ModelAndView sparqlHome(
			HttpServletRequest request,
			HttpServletResponse response
			) throws FileNotFoundException, IOException{

		//create a list with all queries
		FederationData data=new FederationData();
		data.setQueries(federationService.getExampleQueries());

		//get all sources
		data.setFederationSources(federationService.getFederationSources());
		return new ModelAndView("sparql-form",FederationData.KEY,data);
	}


	@RequestMapping(value = {"sparql"},method={RequestMethod.POST,RequestMethod.GET})
	public void getXMLResult(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value="query",required=true) String query,
			@RequestParam(value="default-graph-uri",required=false) List<String> defaultGraphUris
			)
	throws Exception {
		QueryResultFormat outputFormat = TupleQueryResultFormat.JSON;
		log.debug("MimeType : "+outputFormat.getDefaultMIMEType());
		
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			federationService.executeSparql(query, baos, outputFormat.getDefaultMIMEType(), defaultGraphUris);
			response.setContentType(outputFormat.getDefaultMIMEType());
			response.getOutputStream().write(baos.toByteArray());
		} catch (Exception e) {
			log.error("Error while executing SPARQL query, returning raw stacktrace.");
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			e.printStackTrace();
			e.printStackTrace(response.getWriter());
			response.flushBuffer();
		}
	}

}
