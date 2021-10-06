package fr.humanum.openarchaeo.explorateur;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.IOUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import fr.humanum.openarchaeo.SessionData;
import fr.sparna.i18n.StrictResourceBundleControl;

@Controller
public class ExplorateurController {

	private Logger log = LoggerFactory.getLogger(this.getClass().getName());

	private final ExplorateurService explorateurService;
	private final ExtConfigService extConfigService;

	@Inject
	public ExplorateurController(ExplorateurService explorateurService, ExtConfigService extConfigService)
			throws FileNotFoundException, IOException {
		this.explorateurService = explorateurService;
		this.extConfigService = extConfigService;
	}

	@RequestMapping(value = { "home" }, method = RequestMethod.GET)
	public ModelAndView home(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = new ModelAndView("home");
		model.addObject("content", this.readHomePage(SessionData.get(request.getSession()).getUserLocale()));
		model.addObject("legalNotice", this.readLegalNotice(SessionData.get(request.getSession()).getUserLocale()));
		return model;
	}

	@RequestMapping(value = { "sourcesSelect", "/" }, method = RequestMethod.GET)
	public ModelAndView sourcesSelect(HttpServletRequest request, HttpServletResponse response) throws Exception {

		List<FederationSourceJson> sourcesDefinition;
		if (SessionData.get(request.getSession()).getSources() == null) {
			log.debug("Récupération des sources");
			sourcesDefinition = explorateurService.getSources();
			SessionData.get(request.getSession()).setSources(sourcesDefinition);
			log.debug("Récupération des sources terminée");
		} else {
			log.debug("Sources déjà en cache.");
			sourcesDefinition = SessionData.get(request.getSession()).getSources();
		}

		ModelAndView model = new ModelAndView("sourcesSelect");
		model.addObject("sourcesDefinition", sourcesDefinition);

		List<FederationSourceDisplayData> fsdd = sourcesDefinition.stream()
				.map(s -> new FederationSourceDisplayData(s,
						SessionData.get(request.getSession()).getUserLocale().getLanguage()))
				.collect(Collectors.toList());

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		PrintWriter pw = new PrintWriter(baos);
		writeJson(fsdd, pw);
		pw.flush();
		model.addObject("sourcesDefinitionJson", baos.toString());
		
		model.addObject("legalNotice", this.readLegalNotice(SessionData.get(request.getSession()).getUserLocale()));
		return model;
	}

	@RequestMapping(value = { "explorer" }, method = RequestMethod.GET)
	public ModelAndView sparql(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "source", required = true) List<String> sources) throws Exception {

		ModelAndView model = new ModelAndView("explorer");

		// store sources if they are not
		if (SessionData.get(request.getSession()).getSources() == null) {
			SessionData.get(request.getSession()).setSources(explorateurService.getSources());
		}

		List<SourceExplorerDisplay> sourcesDisplay = sources.stream().map(s -> {
			// lookup source
			FederationSourceJson theSource = SessionData.get(request.getSession()).findSourceById(s);
			return new SourceExplorerDisplay(s, (theSource != null) ? theSource.getTitle("fr") : s);
		}).collect(Collectors.toList());
		
		// Read resource
		List<FederationSourceJson> sourcesDefinition;
		if (SessionData.get(request.getSession()).getSources() == null) {
			sourcesDefinition = explorateurService.getSources();
			SessionData.get(request.getSession()).setSources(sourcesDefinition);
		} else {
			sourcesDefinition = SessionData.get(request.getSession()).getSources();			
		}
		
		if (sources.size() == 1) {
			FederationSourceJson singleSourceDefinition = SessionData.get(request.getSession()).findSourceById(sources.get(0));
			model.addObject("singleSourceDefinition", singleSourceDefinition);
		}

		ExplorerDisplayData data = new ExplorerDisplayData();
		data.setSources(sourcesDisplay);

		data.setRequiresFederation(
				explorateurService.requiresFederation(sources, SessionData.get(request.getSession()).getSources()));
		
		
		model.addObject("data", data);
		model.addObject("legalNotice", this.readLegalNotice(SessionData.get(request.getSession()).getUserLocale()));

		return model;
	}

	@RequestMapping(value = { "expand" }, method = { RequestMethod.GET, RequestMethod.POST })
	public void expand(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "query", required = true) String query,
			@RequestParam(value = "source", required = false) List<String> sources,
			@RequestParam(value = "view", required = true) String view) throws IOException {

		response.addHeader("Content-Encoding", "UTF-8");
		response.setContentType("application/json");

		log.debug("Expand query  : 1. add sources, 2. translate to CIDOC-CRM, 3. add extra properties");

		// ajout de la source à la requete si source != null
		query = explorateurService.addSourcesToQuery(query, sources);

		// Expand query
		String queryExpand = explorateurService.expandQuery(query);

		// add extra properties
		ExplorateurService.View viewValue = ExplorateurService.View.valueOf(view.toUpperCase());
		queryExpand = explorateurService.addPropertiesToQuery(queryExpand, viewValue);

		ExplorateurData data = new ExplorateurData();
		data.setQuery(query);
		data.setExpandQuery(queryExpand);

		ObjectMapper mapper = new ObjectMapper();
		mapper.setSerializationInclusion(Include.NON_NULL);
		mapper.enable(SerializationFeature.INDENT_OUTPUT);
		mapper.writeValue(response.getOutputStream(), data);
		log.debug("Final query after expansion : " + "\n" + queryExpand);
	}

	// read file sparnatural

	@RequestMapping(value = { "sparnatural" })
	@ResponseBody
	public String readSparnatural(HttpServletRequest request, HttpServletResponse response) {
		String configString = this.readSparnatural(SessionData.get(request.getSession()).getUserLocale());
		return configString;
	}

	private String readSparnatural(Locale locale) {
		try {
			return IOUtils.toString(
					new FileInputStream(this.extConfigService.findMandatoryFile("sparnatural-config.ttl")),
					Charset.forName("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	private String readLegalNotice(Locale locale) {
		// retrieve resource bundle for path to home page
		ResourceBundle b = ResourceBundle.getBundle("fr.humanum.openarchaeo.explorateur.i18n.OpenArchaeo", locale,
				new StrictResourceBundleControl());

		try {
			return IOUtils.toString(
					new FileInputStream(
							this.extConfigService.findMandatoryFile(b.getString("window.footer.legalNotice.content"))),
					Charset.forName("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	private String readHomePage(Locale locale) {
		// retrieve resource bundle for path to home page
		ResourceBundle b = ResourceBundle.getBundle("fr.humanum.openarchaeo.explorateur.i18n.OpenArchaeo", locale,
				new StrictResourceBundleControl());

		try {
			return IOUtils.toString(
					new FileInputStream(this.extConfigService.findMandatoryFile(b.getString("home.content"))),
					Charset.forName("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	protected void writeJson(Object o, PrintWriter out)
			throws JsonGenerationException, JsonMappingException, IOException {
		ObjectMapper mapper = new ObjectMapper();
		mapper.setSerializationInclusion(Include.NON_NULL);
		mapper.enable(SerializationFeature.INDENT_OUTPUT);
		mapper.writeValue(out, o);
	}

	@RequestMapping(value = { "sitemap.xml" })
	@ResponseBody
	protected void generateSitemap(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String urlBase = extConfigService.getApplicationProperties().getProperty(ExtConfigService.EXPLORATEUR_BASE_URL);
		
		List<FederationSourceJson> sourcesDefinition;
		if (SessionData.get(request.getSession()).getSources() == null) {
			sourcesDefinition = explorateurService.getSources();
			SessionData.get(request.getSession()).setSources(sourcesDefinition);
		} else {
			sourcesDefinition = SessionData.get(request.getSession()).getSources();
		}
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

		// Elemento ra�z
		Document doc = docBuilder.newDocument();
		Element rootElement = doc.createElement("urlset");
		Attr attrRoot = doc.createAttribute("xmlns");
		attrRoot.setValue("http://www.sitemaps.org/schemas/sitemap/0.9");
		rootElement.setAttributeNode(attrRoot);
		doc.appendChild(rootElement);

		for(FederationSourceJson src:sourcesDefinition) {
			// url element
			Element urlXML = doc.createElement("url");
			rootElement.appendChild(urlXML);
			
			Element loc = doc.createElement("loc");
			String urlQuery = urlBase+"/explorer?source="+URLEncoder.encode(src.getSourceString(),"UTF-8");
			loc.setTextContent(urlQuery);
			urlXML.appendChild(loc);
		}
		
		// Se escribe el contenido del XML en un archivo
		TransformerFactory transformerFactory = TransformerFactory.newInstance();
		Transformer transformer = transformerFactory.newTransformer();
		DOMSource source = new DOMSource(doc);
		StreamResult result = new StreamResult(response.getOutputStream());
		try {
			transformer.transform(source, result);
		} catch (TransformerException tfe) {
			tfe.printStackTrace();
		}
	}

}
