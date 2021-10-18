package fr.humanum.openarchaeo.explorateur;

import java.util.Date;
import java.util.List;

import org.eclipse.rdf4j.model.Literal;
import org.eclipse.rdf4j.model.vocabulary.DCAT;
import org.eclipse.rdf4j.model.vocabulary.DCTERMS;

public class FederationSourceDisplayData {

	protected String sourceString;
	protected String endpoint;
	protected String defaultGraph;
	
	protected String title;
	protected List<String> keywords;
	protected String shortDesc;
	protected List<String> spatial;
	
	protected int startYear;
	protected int endYear;
	protected String startDateDisplay;
	protected String endDateDisplay;
	
	protected String contact;
	
	protected String issued;
	protected String issuedDisplay;
	
	protected String license;
	
	protected String modified;
	protected String modifiedDisplay;
	
	protected String publisher;
	
	protected String source;
	
	protected List<String> subject;
	
	public FederationSourceDisplayData(FederationSourceJson original, String lang) {
		this.sourceString = original.sourceString;
		this.endpoint = original.endpoint;
		this.defaultGraph = original.defaultGraph;
		this.title = original.getTitle(lang);
		this.keywords = original.getKeywords(lang);
		this.shortDesc = original.getShortDesc(lang);
		this.spatial = original.getSpatial(lang);
		
		if(original.getStartDateValue(lang) != null) {
			this.startYear = ((Literal)original.getStartDateValue(lang)).calendarValue().getYear();
		}
		this.startDateDisplay = original.getStartDate(lang);
		
		if(original.getEndDateValue(lang) != null) {
			this.endYear = ((Literal)original.getEndDateValue(lang)).calendarValue().getYear();
		}
		this.endDateDisplay = original.getEndDate(lang);
		
		this.contact = original.getValue("dcat:"+DCAT.CONTACT_POINT.getLocalName(), lang);
		
		this.issued = original.getValue("dcterms:"+DCTERMS.ISSUED.getLocalName(), lang);
		this.issuedDisplay = issued;
		
		this.license = original.getValue("dcterms:"+DCTERMS.LICENSE.getLocalName(), lang);
		
		this.modified = original.getValue("dcterms:"+DCTERMS.MODIFIED.getLocalName(), lang);
		this.modifiedDisplay = modified;
		
		this.publisher = original.getValue("dcterms:"+DCTERMS.PUBLISHER.getLocalName(), lang);
		
		this.source = original.getValue("dcterms:"+DCTERMS.SOURCE.getLocalName(), lang);
		
		this.subject = original.getLiteralSubject(lang);
	}

	public String getSourceString() {
		return sourceString;
	}

	public void setSourceString(String sourceString) {
		this.sourceString = sourceString;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public List<String> getKeywords() {
		return keywords;
	}

	public void setKeywords(List<String> keywords) {
		this.keywords = keywords;
	}

	public String getShortDesc() {
		return shortDesc;
	}

	public void setShortDesc(String shortDesc) {
		this.shortDesc = shortDesc;
	}

	public List<String> getSpatial() {
		return spatial;
	}

	public void setSpatial(List<String> spatial) {
		this.spatial = spatial;
	}

	public int getStartYear() {
		return startYear;
	}

	public void setStartYear(int startYear) {
		this.startYear = startYear;
	}

	public int getEndYear() {
		return endYear;
	}

	public void setEndYear(int endYear) {
		this.endYear = endYear;
	}

	public String getStartDateDisplay() {
		return startDateDisplay;
	}

	public void setStartDateDisplay(String startDateDisplay) {
		this.startDateDisplay = startDateDisplay;
	}

	public String getEndDateDisplay() {
		return endDateDisplay;
	}

	public void setEndDateDisplay(String endDateDisplay) {
		this.endDateDisplay = endDateDisplay;
	}

	public String getContact() {
		return contact;
	}
	
	

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getIssued() {
		return issued;
	}

	public void setIssued(String issued) {
		this.issued = issued;
	}

	public String getIssuedDisplay() {
		return issuedDisplay;
	}

	public void setIssuedDisplay(String issuedDisplay) {
		this.issuedDisplay = issuedDisplay;
	}

	public String getLicense() {
		return license;
	}

	public void setLicense(String license) {
		this.license = license;
	}

	public String getModified() {
		return modified;
	}

	public void setModified(String modified) {
		this.modified = modified;
	}

	public String getModifiedDisplay() {
		return modifiedDisplay;
	}

	public void setModifiedDisplay(String modifiedDisplay) {
		this.modifiedDisplay = modifiedDisplay;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getEndpoint() {
		return endpoint;
	}

	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}

	public String getDefaultGraph() {
		return defaultGraph;
	}

	public void setDefaultGraph(String defaultGraph) {
		this.defaultGraph = defaultGraph;
	}

	public List<String> getSubject() {
		return subject;
	}

	public void setSubject(List<String> subject) {
		this.subject = subject;
	}
	
	
	
}
