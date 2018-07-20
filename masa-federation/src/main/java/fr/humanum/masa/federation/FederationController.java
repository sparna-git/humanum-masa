package fr.humanum.masa.federation;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.client.ClientProtocolException;
import org.eclipse.rdf4j.query.resultio.TupleQueryResultFormat;
import org.eclipse.rdf4j.query.resultio.sparqlxml.SPARQLResultsXMLWriter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FederationController {

	private final FederationService federationService;
	private Properties properties;


	@Inject
	public FederationController(FederationService federationService) throws FileNotFoundException, IOException {
		this.federationService=federationService;
		this.properties=federationService.getProperties("config.properties");
	}


	@RequestMapping(value = {"/","home"},method=RequestMethod.GET)
	public ModelAndView sparqlHome(
			HttpServletRequest request,
			HttpServletResponse response
			){
		ModelAndView model=new ModelAndView("home");
		return model;
	}
	
	
	@RequestMapping(value = {"sparql"},method={RequestMethod.POST,RequestMethod.GET})
	public void getXMLResult(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value="query",required=true) String query
			){

		try {
			
			System.out.println(query);
			String endpointUrl=properties.getProperty("masa.endpoint.url");
			federationService.initializeRepositoryWithFederation(endpointUrl);
			response.setContentType(TupleQueryResultFormat.SPARQL.getDefaultMIMEType());
			//query example : SELECT+%2A+WHERE+%7B%0D%0A++%3Fsub+%3Fpred+%3Fobj+.%0D%0A%7D+%0D%0ALIMIT+10
			federationService.getResultToXml(query,federationService.getRepository(),response.getOutputStream());
			System.out.println("end");

		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMessage());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	

	}

}