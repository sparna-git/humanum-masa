package fr.humanum.openarchaeo.federation.index;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.rdf4j.model.IRI;
import org.eclipse.rdf4j.query.AbstractTupleQueryResultHandler;
import org.eclipse.rdf4j.query.Binding;
import org.eclipse.rdf4j.query.BindingSet;
import org.eclipse.rdf4j.query.TupleQueryResultHandlerException;
import org.eclipse.rdf4j.repository.Repository;
import org.eclipse.rdf4j.repository.RepositoryConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import fr.humanum.openarchaeo.Perform;

/**
 * Abstract class that executes a SPARQL query to
 * @author thomas
 *
 */
public class SparqlIriFetcher implements IriFetcher {

	private Logger log = LoggerFactory.getLogger(this.getClass().getName()); 
	
	protected String sparql;
	
	public SparqlIriFetcher(String sparql) {
		super();
		this.sparql = sparql;
	}

	@Override
	public List<IRI> fetchIrisToIndex(Repository repository) {
		List<IRI> result = new ArrayList<>();
		
		log.debug("Fetching IRIs with SPARQL:\n"+this.sparql);
		try(RepositoryConnection c = repository.getConnection()) {
			Perform.on(c).query(this.sparql, new AbstractTupleQueryResultHandler() {
				@Override
				public void handleSolution(BindingSet bindingSet) throws TupleQueryResultHandlerException {
					Binding b = bindingSet.getBinding(bindingSet.getBindingNames().iterator().next());
					result.add((IRI)b.getValue());
				}
			});
		}
		
		return result;
	}

	public String getSparql() {
		return sparql;
	}

	public void setSparql(String sparql) {
		this.sparql = sparql;
	}

}
