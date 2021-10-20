package fr.humanum.openarchaeo.explorateur;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

import org.eclipse.rdf4j.model.Value;
import org.eclipse.rdf4j.model.impl.SimpleValueFactory;
import org.eclipse.rdf4j.model.vocabulary.DCAT;
import org.eclipse.rdf4j.model.vocabulary.DCTERMS;

import com.fasterxml.jackson.annotation.JsonProperty;


public class FederationSourceJson  {

	protected String sourceString;
	protected String endpoint;
	protected String defaultGraph;
	
	protected Map<String, List<LiteralOrResourceValue>> description;
	
	
	
	public FederationSourceJson() {
		super();
	}

	public FederationSourceJson(String sourceString, String endpoint, String defaultGraph, Map<String, List<LiteralOrResourceValue>> description) {
		super();
		this.sourceString = sourceString;
		this.endpoint = endpoint;
		this.defaultGraph = defaultGraph;
		this.description = description;
	}
	
	public String getSourceString() {
		return this.sourceString;
	}

	
	public String getEndpoint() {
		return this.endpoint;
	}

	
	public String getDefaultGraph() {
		return this.defaultGraph;
	}

	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}

	public void setDefaultGraph(String defaultGraph) {
		this.defaultGraph = defaultGraph;
	}
	
	static class LiteralOrResourceValue {
		@JsonProperty("@language")
		private String language;
		@JsonProperty("@value")
		private String value;
		@JsonProperty("@type")
		private String datatype;
		@JsonProperty("@id")
		private String id;
		
		public LiteralOrResourceValue() {
			super();
		}
		
		public LiteralOrResourceValue(String value, String language, String datatype) {
			super();
			this.language = language;
			this.value = value;
			this.datatype = datatype;
		}
		
		public LiteralOrResourceValue(String id) {
			super();
			this.id = id;
		}
		
		
		public String getLanguage() {
			return language;
		}
		public void setLanguage(String language) {
			this.language = language;
		}
		public String getValue() {
			return value;
		}
		public void setValue(String value) {
			this.value = value;
		}
		public String getDatatype() {
			return datatype;
		}
		public void setDatatype(String datatype) {
			this.datatype = datatype;
		}
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
	}

	public Map<String, List<LiteralOrResourceValue>> getDescription() {
		return description;
	}

	public void setDescription(Map<String, List<LiteralOrResourceValue>> description) {
		this.description = description;
	}
	
	public String getTitle(String lang) {
		return this.getValue("dcterms:"+DCTERMS.TITLE.getLocalName(), lang);
	}
	
	public String getShortDesc(String lang) {
		return this.getValue("dcterms:"+DCTERMS.DESCRIPTION.getLocalName(), lang);
	}
	
	public List<String> getSpatial(String lang) {
		return getValues("dcterms:"+DCTERMS.SPATIAL.getLocalName(), lang);
	}
	
	public List<String> getLiteralSubject(String lang) {
		return getLiteralValues("dcterms:"+DCTERMS.SUBJECT.getLocalName(), lang);
	}
	
	public List<String> getKeywords(String lang) {
		return getValues("dcat:keyword", lang);
	}
	
	public String getStartDate(String lang) {
		return this.getValue("schema:startDate", lang);
	}
	
	public String getEndDate(String lang) {
		return this.getValue("schema:endDate", lang);
	}
	
	public Value getStartDateValue(String lang) {
		return this.getValueAsValue("schema:startDate", lang);
	}
	
	public Value getEndDateValue(String lang) {
		return this.getValueAsValue("schema:endDate", lang);
	}
	
	public Value getPublisher() {
		return this.getValueAsValue("dcterms:"+DCTERMS.PUBLISHER.getLocalName(), null);
	}
	
	public String getSpatialPage(String lang) {
		return this.getSpatial(lang).stream().collect(Collectors.joining(", "));
	}
	
	public String keywordPage(String lang) {
		return this.getKeywords(lang).stream().collect(Collectors.joining(", "));
	}
	
	public String DatePublisherPage(String lang) {
		return this.getLiteralSubject(lang).stream().collect(Collectors.joining(", "));
	}
	
	public String DateupdatePublisherPage(String lang) {
		return this.getLiteralSubject(lang).stream().collect(Collectors.joining(", "));
	}
	
	public String SubjectPage(String lang) {
		return this.getLiteralSubject(lang).stream().collect(Collectors.joining(", "));
	}
	
	public String getContactPage(String lang) {
		return this.getValue("dcat:"+DCAT.CONTACT_POINT.getLocalName(), lang);
	}
	
	public String getIssuePage(String lang) {
		return this.getValue("dcterms:"+DCTERMS.ISSUED.getLocalName(), lang);
	}
	
	public String getModifiedPage(String lang) {
		return this.getValue("dcterms:"+DCTERMS.MODIFIED.getLocalName(), lang);
	}
	
	
	public String getSourcePage(String lang) {
		return this.getValue("dcterms:"+DCTERMS.SOURCE.getLocalName(), lang);
	}
	
	public String getLicensePage(String lang) {
		return this.getValue("dcterms:"+DCTERMS.LICENSE.getLocalName(), lang);
	}
	
	public String getConformsTo(String lang) {
		return this.getValue("dcterms:"+DCTERMS.CONFORMS_TO.getLocalName(), lang);
	}
	
	///dcterms:source
	
	public Map<String, List<String>> getDescriptionInLang(String lang) {
		TreeMap<String, List<String>> result = new TreeMap<String, List<String>>();
		for (Map.Entry<String, List<LiteralOrResourceValue>> e : this.description.entrySet()) {
			if(
					!e.getKey().equals("dcterms:"+DCTERMS.TITLE.getLocalName())
					&&
					!e.getKey().equals("dcterms:"+DCTERMS.DESCRIPTION.getLocalName())
					&&
					!e.getKey().equals("dcterms:"+DCTERMS.SPATIAL.getLocalName())
					&&
					!e.getKey().equals("dcat:keyword")
					&&
					!e.getKey().equals("dcterms:"+DCTERMS.CONFORMS_TO.getLocalName())
					&&
					!e.getKey().equals("dcat:theme")
					&&
					!e.getKey().equals("schema:startDate")
					&&
					!e.getKey().equals("schema:endDate")
			) {
				List<String> lValues = getValues(e.getKey(), lang);
				if(lValues != null && lValues.size() > 0) {
					result.put(e.getKey(), lValues);
				}
			}
		}
		return result;
	}
	
	
	
	public String displayValueList(List<String> values) {
		if(values == null) {
			return "";
		}
		
		return values.stream().map(s -> {
			if(s.startsWith("http")) {
				return "<a href=\""+s+"\">"+s+"</a>";
			} else if(s.startsWith("mailto:")) {
				return "<a href=\""+s+"\">"+s.substring("mailto:".length())+"</a>";
			} else {
				return s;
			}
		}).collect(Collectors.joining(", "));
	}
	
	
	public List<String> getValues(String key, String lang) {
		List<LiteralOrResourceValue> values = this.description.get(key);
		if(values == null) {
			return null;
		} else {
			return values.stream()
					.filter(v -> 
						(v.getLanguage() == null || v.getLanguage().equals(""))
						||
						(v.getLanguage() != null && v.getLanguage().equals(lang))
					)
					.map(v -> (v.getValue() != null)?v.getValue():v.getId())
					.collect(Collectors.toList());
		}
	}
	
	/**
	 * Returns only the literal values for a property
	 * @param key
	 * @param lang
	 * @return
	 */
	public List<String> getLiteralValues(String key, String lang) {
		List<LiteralOrResourceValue> values = this.description.get(key);
		if(values == null) {
			return null;
		} else {
			return values.stream()
					.filter(v -> 
						(v.getLanguage() == null || v.getLanguage().equals(""))
						||
						(v.getLanguage() != null && v.getLanguage().equals(lang))
					)
					.filter(v -> 
						v.getValue() != null
					)
					.map(v -> v.getValue())
					.collect(Collectors.toList());
		}
	}
	
	public String getValue(String key, String lang) {
		List<String> values = this.getValues(key, lang);
		if(values != null && values.size() > 0) {
			return values.get(0);
		} else {
			return null;
		}		
	}
	
	public List<Value> getValuesAsValues(String key, String lang) {
		List<LiteralOrResourceValue> values = this.description.get(key);
		if(values == null) {
			return null;
		} else {
			return values.stream()
					.filter(v -> 
						(v.getLanguage() == null || v.getLanguage().equals(""))
						||
						(v.getLanguage() != null && v.getLanguage().equals(lang))
					)
					.map(v -> {
						org.eclipse.rdf4j.model.Value rdf4jValue = null;
						
						// indicates a Literal
						if(v.getValue() != null) {
							if(v.getLanguage() != null && !v.getLanguage().equals("")) {
								rdf4jValue = SimpleValueFactory.getInstance().createLiteral(v.getValue(), v.getLanguage());
							} else if(v.getDatatype() != null) {
								rdf4jValue = SimpleValueFactory.getInstance().createLiteral(v.getValue(), SimpleValueFactory.getInstance().createIRI(v.getDatatype()));
							} else {
								rdf4jValue = SimpleValueFactory.getInstance().createLiteral(v.getValue());
							}
						} else if(v.getId() != null) {
							rdf4jValue = SimpleValueFactory.getInstance().createIRI(v.getId());
						}
						
						return rdf4jValue;
					})
					.collect(Collectors.toList());
		}
	}
	
	public Value getValueAsValue(String key, String lang) {
		List<Value> values = this.getValuesAsValues(key, lang);
		if(values != null && values.size() > 0) {
			return values.get(0);
		} else {
			return null;
		}		
	}

}
