package fr.humanum.openarchaeo.federation.source;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.eclipse.rdf4j.model.IRI;
import org.eclipse.rdf4j.model.Literal;
import org.eclipse.rdf4j.model.Resource;
import org.eclipse.rdf4j.model.Value;
import org.eclipse.rdf4j.model.vocabulary.DCTERMS;


public class SimpleFederationSource implements FederationSource {

	protected IRI sourceIri;
	protected IRI endpoint;
	protected IRI defaultGraph;
	protected Map<IRI, List<Value>> dcterms;
	
	public SimpleFederationSource(IRI sourceIri, IRI endpoint, IRI defaultGraph, Map<IRI, List<Value>> dcterms) {
		super();
		this.sourceIri = sourceIri;
		this.endpoint = endpoint;
		this.defaultGraph = defaultGraph;
		this.dcterms = dcterms;
	}
	
	/**
	 * Constructor without dcterms description
	 * @param endpointUrl
	 * @param defaultGraphUri
	 */
	public SimpleFederationSource(IRI sourceIri, IRI endpoint, IRI defaultGraph) {
		this(sourceIri, endpoint, defaultGraph, null);
	}
	
	public String getTitle(String lang) {
		List<String> titles = getDctermsValues(DCTERMS.TITLE, lang);
		if(titles != null && titles.size() > 0) {
			return titles.get(0);
		} else {
			List<String> titlesWithoutLanguage = getDctermsValues(DCTERMS.TITLE, null);
			if(titlesWithoutLanguage != null && titlesWithoutLanguage.size() > 0) {
				return titlesWithoutLanguage.get(0);
			} else {
				return null;
			}
		}
	}
	
	private List<String> getDctermsValues(IRI dcProperty, String lang) {
		List<Value> values = this.dcterms.get(dcProperty);
		if(values == null) {
			return null;
		} else {
			return values.stream()
					.filter(v -> 
						v instanceof Resource
						||
						(
								v instanceof Literal
								&&
								(
									(lang == null && !((Literal)v).getLanguage().isPresent()
									||
									(
										(Literal)v).getLanguage().isPresent()
										&&
										((Literal)v).getLanguage().get().equals(lang)
									)
								)
						)
					)
					.map(v -> v.stringValue())
					.collect(Collectors.toList());
		}
	}

	@Override
	public IRI getSourceIri() {
		return this.sourceIri;
	}

	@Override
	public IRI getEndpoint() {
		return this.endpoint;
	}

	@Override
	public Optional<IRI> getDefaultGraph() {
		return Optional.ofNullable(this.defaultGraph);
	}
	
	@Override
	public Map<IRI, List<Value>> getDcterms() {
		return dcterms;
	}

	public void setEndpoint(IRI endpoint) {
		this.endpoint = endpoint;
	}

	public void setDefaultGraph(IRI defaultGraph) {
		this.defaultGraph = defaultGraph;
	}

	public void setDcterms(Map<IRI, List<Value>> dcterms) {
		this.dcterms = dcterms;
	}

}
