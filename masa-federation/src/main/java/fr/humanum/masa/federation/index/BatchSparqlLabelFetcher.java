package fr.humanum.masa.federation.index;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.rdf4j.model.IRI;
import org.eclipse.rdf4j.query.AbstractTupleQueryResultHandler;
import org.eclipse.rdf4j.query.BindingSet;
import org.eclipse.rdf4j.query.TupleQueryResultHandlerException;
import org.eclipse.rdf4j.repository.Repository;
import org.eclipse.rdf4j.repository.RepositoryConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import fr.humanum.masa.Perform;

/**
 * Implements a LabelFetcher with a batch processing of the IRIs in a SPARQL query;
 * @author thomas
 *
 */
public abstract class BatchSparqlLabelFetcher implements LabelFetcher {

	private Logger log = LoggerFactory.getLogger(this.getClass().getName()); 
	
	protected int batchSize = 200;
	
	public BatchSparqlLabelFetcher() {
		super();
	}
	
	public BatchSparqlLabelFetcher(int batchSize) {
		super();
		this.batchSize = batchSize;
	}

	@Override
	public void fetchLabels(List<IRI> iris, Repository repository, LabelEntryHandler handler) {		
		List<IRI> remainingEntries = new ArrayList<>(iris);
		while(remainingEntries.size() > batchSize) {
			List<IRI> currentBatch = remainingEntries.subList(0, batchSize);
			processBatch(currentBatch, repository, handler);
			remainingEntries.removeAll(currentBatch);
		}
		// process last batch
		if(remainingEntries.size() > 0) {
			processBatch(remainingEntries, repository, handler);
		}
	}

	private void processBatch(List<IRI> iris, Repository repository, LabelEntryHandler handler) {
		String sparql = generateSparqlFetch(iris);
		try(RepositoryConnection c = repository.getConnection()) {
			Perform.on(c).query(sparql, new AbstractTupleQueryResultHandler() {
				@Override
				public void handleSolution(BindingSet bindingSet) throws TupleQueryResultHandlerException {
					handler.handle(LabelEntry.fromBindingSet(bindingSet));
				}				
			});
		}
	}
	
	/**
	 * The generated SPARQL query MUST return the following variables : iri, label, prefLabel
	 * 
	 * @param iris
	 * @return
	 */
	protected abstract String generateSparqlFetch(List<IRI> iris);

	public int getBatchSize() {
		return batchSize;
	}

	public void setBatchSize(int batchSize) {
		this.batchSize = batchSize;
	}
	
}