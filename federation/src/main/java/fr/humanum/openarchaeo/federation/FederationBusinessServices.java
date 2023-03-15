package fr.humanum.openarchaeo.federation;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import org.apache.jena.query.Query;
import org.apache.jena.query.QueryFactory;
import org.apache.jena.query.Syntax;
import org.eclipse.rdf4j.model.IRI;
import org.eclipse.rdf4j.model.impl.SimpleValueFactory;
import org.eclipse.rdf4j.query.BooleanQuery;
import org.eclipse.rdf4j.query.MalformedQueryException;
import org.eclipse.rdf4j.query.QueryEvaluationException;
import org.eclipse.rdf4j.query.TupleQuery;
import org.eclipse.rdf4j.query.TupleQueryResultHandlerException;
import org.eclipse.rdf4j.query.resultio.BooleanQueryResultFormat;
import org.eclipse.rdf4j.query.resultio.BooleanQueryResultWriter;
import org.eclipse.rdf4j.query.resultio.BooleanQueryResultWriterFactory;
import org.eclipse.rdf4j.query.resultio.BooleanQueryResultWriterRegistry;
import org.eclipse.rdf4j.query.resultio.TupleQueryResultFormat;
import org.eclipse.rdf4j.query.resultio.TupleQueryResultWriter;
import org.eclipse.rdf4j.query.resultio.TupleQueryResultWriterFactory;
import org.eclipse.rdf4j.query.resultio.TupleQueryResultWriterRegistry;
import org.eclipse.rdf4j.repository.Repository;
import org.eclipse.rdf4j.repository.RepositoryConnection;
import org.eclipse.rdf4j.repository.RepositoryException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import fr.humanum.openarchaeo.federation.index.IndexService;
import fr.humanum.openarchaeo.federation.index.SearchResult;
import fr.humanum.openarchaeo.federation.period.PeriodJson;
import fr.humanum.openarchaeo.federation.period.PeriodServiceIfc;
import fr.humanum.openarchaeo.federation.repository.FederationRepositoryBuilder;
import fr.humanum.openarchaeo.federation.repository.QueryPreprocessorIfc;
import fr.humanum.openarchaeo.federation.repository.RepositorySupplier;
import fr.humanum.openarchaeo.federation.repository.RequiresFederationPredicate;
import fr.humanum.openarchaeo.federation.source.FederationSource;
import fr.humanum.openarchaeo.federation.source.FederationSourceRemoteMetadataSupplier;

@Service
public class FederationBusinessServices {

	private Logger log = LoggerFactory.getLogger(this.getClass().getName());
	
	private ExtConfigService extConfigService;
	private List<? extends FederationSource> federationSources;
	private IndexService indexService;
	private PeriodServiceIfc periodsService;
	private FederationRepositoryBuilder federationBuilder;
	private QueryPreprocessorIfc queryPreprocessor;

	@Inject
	public FederationBusinessServices(
			ExtConfigService extConfigService,
			IndexService indexService,
			PeriodServiceIfc periodsService,
			FederationRepositoryBuilder federationBuilder
	) {
		this.extConfigService = extConfigService;
		this.indexService = indexService;
		this.periodsService = periodsService;
		this.federationBuilder = federationBuilder;
	}
	
	@PostConstruct
	public void init() {
		FederationSourceRemoteMetadataSupplier fsrms = new FederationSourceRemoteMetadataSupplier(extConfigService.getSourceFile());
		this.federationSources=fsrms.get();
	}
	
	public void executeSparql(String query, OutputStream out, String mimeType, List<String> defaultGraphUris) throws IOException {
		log.debug("Executing SPARQL : \n"+query);
		long start = System.currentTimeMillis();
		List<? extends FederationSource> sourcesToQuery;
		if(defaultGraphUris == null || defaultGraphUris.isEmpty()) {
			sourcesToQuery = this.filterFederationSources(QueryFactory.create(query));
		} else {
			sourcesToQuery = defaultGraphUris.stream().map(source -> findSource(source)).collect(Collectors.toList());
		}

		String queryWithoutOriginalFromClauses = this.removeFromClauses(QueryFactory.create(query)).toString(Syntax.syntaxSPARQL_11);
		log.debug("Query after removing FROM clauses : \n"+queryWithoutOriginalFromClauses);
		
		// here, the repository might not be a federated repository if the same sources are querying the same repo
		Repository repository = this.createRepositoryFromSources(sourcesToQuery, query);	
		
		RequiresFederationPredicate test = new RequiresFederationPredicate();
		boolean requiresFederation = test.test(test.new QueryOverSources(query, sourcesToQuery));
		
		String queryToExecute = queryWithoutOriginalFromClauses;
		if(!requiresFederation) {
			log.debug("Federation not used, will set FROM clauses in the query");
			queryToExecute = this.addFromGraphClauses(sourcesToQuery, QueryFactory.create(queryWithoutOriginalFromClauses)).toString(Syntax.syntaxSPARQL_11);
			log.debug("Query after setting FROM clauses : \n"+queryToExecute);
		}
		
		long startExecution = System.currentTimeMillis();
		this.executeQuery(
				queryToExecute,
				repository,
				out,
				mimeType
		);
		log.debug("SPARQL sent to triplestore in "+new DecimalFormat("#.###").format(((float)(System.currentTimeMillis() - startExecution))/1000)+" s");
		long timeInMillis = System.currentTimeMillis() - start;
		log.debug("Done executing SPARQL in "+new DecimalFormat("#.###").format((float)timeInMillis/1000)+" s");
	}
	
	private void executeQuery(
			String queryString,
			Repository repository,
			OutputStream out,
			String mimeType
	) throws IOException {
		if(queryString.toLowerCase().substring(0, queryString.indexOf('{')).contains("ask")) {
			BooleanQueryResultWriterRegistry registry = BooleanQueryResultWriterRegistry.getInstance();
			BooleanQueryResultWriterFactory f = registry.get(
					registry.getFileFormatForMIMEType(mimeType).orElse(BooleanQueryResultFormat.SPARQL)
			).orElse(registry.get(BooleanQueryResultFormat.SPARQL).get());
			
			try (RepositoryConnection conn = repository.getConnection()) {
				BooleanQuery q = conn.prepareBooleanQuery(queryString);				
				BooleanQueryResultWriter writer = f.getWriter(out);
				writer.write(q.evaluate());
			}
		} else {
			TupleQueryResultWriterRegistry registry = TupleQueryResultWriterRegistry.getInstance();
			TupleQueryResultWriterFactory f = registry.get(
					registry.getFileFormatForMIMEType(mimeType).orElse(TupleQueryResultFormat.SPARQL)
			).orElse(registry.get(TupleQueryResultFormat.SPARQL).get());
			
					
			try (RepositoryConnection conn = repository.getConnection()) {
				TupleQuery q = conn.prepareTupleQuery(queryString);
				TupleQueryResultWriter writer = f.getWriter(out);
				q.evaluate(writer);
			}			
		}
	}
	

	/**
	 * Créé un Repository avec les sources indiquées, pour la query indiquée
	 * 
	 * @param sources
	 * @return
	 */
	private Repository createRepositoryFromSources(List<? extends FederationSource> sources, String query){
		log.debug("Création d'un repository "+sources.size()+" sources");
		return this.federationBuilder.buildRepository(
				sources,
				query
		);
	}

	private Query addFromGraphClauses(List<? extends FederationSource> sources, Query query){
		for (FederationSource federationSource : sources) {
			federationSource.getDefaultGraph().ifPresent(i -> { 
				query.addGraphURI(i.stringValue());
			});			
		}
		return query;
	}
	
	/**
	 * Renvoie toutes les sources paramétrées dans la fédération
	 * @return
	 */
	public List<? extends FederationSource> getFederationSources() {
		return this.federationSources;
	}
	
	/**
	 * Filtre les sources à utiliser pour créer une fédération en fonction des clauses
	 * FROM de la query.
	 * 
	 * @param q
	 * @return
	 */
	public List<? extends FederationSource> filterFederationSources(Query q) {
		// if query does not have FROM clauses, we return all the sources
		if(q.getNamedGraphURIs() == null || q.getNamedGraphURIs().isEmpty()){
			log.debug("No named graphs declared, querying all sources");
			return this.federationSources;
		} else {
			log.debug("Found some named graphs declared");
			List<FederationSource> filteredFederationSource = new ArrayList<FederationSource>();
			for (String source : q.getNamedGraphURIs()) {
				FederationSource fs = findSource(source);
				if(fs != null) {
					log.debug("Found source :"+ fs.getSourceIri());
					filteredFederationSource.add(fs);
				} else {
					log.warn("Oups, found an unknown source :"+ source);
				}
			}
			return filteredFederationSource;
		}
	}
	
	public FederationSource findSource(String sourceIri) {
		for (FederationSource aSource : federationSources) {
			if(aSource.getSourceIri().equals(SimpleValueFactory.getInstance().createIRI(sourceIri))){
				return aSource;
			}
		}
		return null;
	}
	
	private Query removeFromClauses(Query q) {
		List<String> querySources = q.getNamedGraphURIs();
		List<String> sourcesToRemove = querySources.stream().filter(s -> { 
			for (FederationSource aSource : this.federationSources) {
				if(aSource.getSourceIri().stringValue().equals(s)) {
					return true;
				}
			}
			return false;
		}).collect(Collectors.toList());
		
		for (String source : sourcesToRemove) {
			q.getNamedGraphURIs().remove(source);
		}
		
		return q;
	}
	
	/**
	 * Renvoie les queries d'exemple paramétrées dans l'application.
	 * 
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public List<QueryExample> getExampleQueries() {
		File exampleQueryFile = this.extConfigService.getExampleQueriesFile();
		
		if(exampleQueryFile != null && exampleQueryFile.exists()){
			ObjectMapper objectMapper=new ObjectMapper();
			//add this line  
			objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);    
			try {
				List<QueryExample> result = objectMapper.readValue(exampleQueryFile , new TypeReference<List<QueryExample>>(){});
				log.debug("Read query examples :\n"+result);
				return result;
			} catch (Exception e) {
				e.printStackTrace();
				return null;
			}
		} else {
			log.warn("Exemple queries config file is not setup or does not exists. It value it : "+exampleQueryFile);
			return null;
		}
	}
	
	public List<SearchResult> autocomplete(
			String key,
			String indexId,
			List<String> sources,
			int limit
	) throws IOException {		
		sources = (sources != null)?sources.stream().map(s -> s.replaceAll("\\W+", "")).collect(Collectors.toList()):null;
		return this.indexService.autocomplete(key, indexId, sources, "fr", limit);
	}
	
	public List<SearchResult> list(
			String indexId,
			String lang,
			List<String> sources
	) throws IOException {
		sources = (sources != null)?sources.stream().map(s -> s.replaceAll("\\W+", "")).collect(Collectors.toList()):null;
		List<SearchResult> result = this.indexService.getEntries(indexId, lang, sources);
		// sort the list alphabetically
		Collections.sort(result, new Comparator<SearchResult>() {

			@Override
			public int compare(SearchResult r1, SearchResult r2) {
				return r1.getLabel().compareToIgnoreCase(r2.getLabel());
			}
			
		});
		return result;
	}
	
	public Set<String> getIndexIds() throws IOException {
		Set<String> result = this.indexService.getDistinctIndexIds();
		log.debug("Retrieved index IDs "+result);
		return result;
	}

	
	public void reindex(IRI source) throws IOException {
		// creer un repository pour la source indiquee
		FederationSource fs = findSource(source.stringValue());
		Repository r = new RepositorySupplier(fs).getRepository();
    	
    	this.indexService.reIndexSource(
    			// identifiant de la source
    			source.stringValue().replaceAll("\\W+", ""),
    			// repository
    			r
    	);
	}
	
	public List<PeriodJson> getPeriods(String lang) {
		return this.periodsService.getPeriods(lang);
	}
}
