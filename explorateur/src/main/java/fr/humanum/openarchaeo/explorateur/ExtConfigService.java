package fr.humanum.openarchaeo.explorateur;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import org.springframework.stereotype.Service;

import fr.humanum.openarchaeo.OpenArchaeoException;

@Service
public class ExtConfigService {

	public static String EXT_DIRECTORY_PROPERTY 		= 	"ext.directory.explorateur";
	public static String APPLICATION_PROPERTIES_FILE 	= 	"config.properties";
	public static String QUERY_EXPANSION_CONFIG_FILE 	= 	"query_expansion.ttl";
	public static String QUERY_EXAMPLE_CONFIG_FILE 		= 	"query_examples.json";


	public static String FEDERATION_SERVICE_URL = 			"federation.service.url";
	public static String FEDERATION_SERVICE_API_SOURCES = 	"federation.service.api.sources";
	public static String EXPLORATEUR_BASE_URL = 			"explorateur.base.url";
	public static String EXPLORATEUR_PATH_LABEL			=	"explorateur.path.label";
	public static String EXPLORATEUR_PATH_LATITUDE		=	"explorateur.path.latitude";
	public static String EXPLORATEUR_PATH_LONGITUDE		=	"explorateur.path.longitude";
	
	private File extFolder;
	private Properties properties;

	public ExtConfigService() {
		if(System.getProperty(EXT_DIRECTORY_PROPERTY) == null) {
			throw new RuntimeException("System Property '"+EXT_DIRECTORY_PROPERTY+"' was not found. Please set this system property to point to the ext folder containing configuration files (java -D"+EXT_DIRECTORY_PROPERTY+"=/path/to/ext/folder ...).");
		}
		String extPath = System.getProperty(EXT_DIRECTORY_PROPERTY);
		this.extFolder = new File(extPath);

		if(!this.extFolder.exists()) {
			throw new RuntimeException("Configured '"+EXT_DIRECTORY_PROPERTY+"' does not exist : "+extPath);
		}
		
		File f = findFile(APPLICATION_PROPERTIES_FILE);
		this.properties = new Properties();
		try {
			this.properties.load(new FileInputStream(f));
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	public Properties getApplicationProperties() {
		return properties;
	}

	public File findFile(String path) {
		File environmentFile = new File(this.extFolder, path);
		if (environmentFile.exists()) {
			return environmentFile;
		} else {
			return null;
		}
	}
	
	public File findMandatoryFile(String path) {
		return OpenArchaeoException.failIfNull(findFile(path), "Required file was not found in ext.directory : "+path);		
	}

}
