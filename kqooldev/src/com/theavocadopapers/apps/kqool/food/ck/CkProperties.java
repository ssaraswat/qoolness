package com.theavocadopapers.apps.kqool.food.ck;

import java.io.InputStream;
import java.util.Properties;

public class CkProperties {

	
	public static final String PROPERTIES_FILENAME="/ck.properties";
	
	protected static Properties allProperties=new Properties();
	

	
	public CkProperties() {
		synchronized (allProperties) {
			if (!allProperties.propertyNames().hasMoreElements()) {
				InputStream is=null;
				final String propsFilename=PROPERTIES_FILENAME;
				try {
					allProperties=new Properties();
					is=this.getClass().getResourceAsStream(propsFilename);
					allProperties.load(is);
				} 
				catch(final Exception e) {
					throw new RuntimeException("Cannot load "+propsFilename+".");			
				}
				finally {
					try {
						is.close();
					}
					catch (final Exception e) {
						// ignore; either a harmless nullpointer or something we can't do anything about.
					}
				}
			}
		}
	}
	
	protected String getProperty(final String name) {
		return allProperties.getProperty(name);
	}
	protected int getIntProperty(final String name) {
		return Integer.parseInt(getProperty(name));
	}
	protected boolean getBooleanProperty(final String name) {
		return Boolean.parseBoolean(getProperty(name));
	}
	protected double getDoubleProperty(final String name) {
		return Double.parseDouble(getProperty(name));
	}

	
	public String getDeveloperKey() {
		return getProperty("developer.key");
	}
	public String getLogoUrl() {
		return getProperty("logo.url");
	}
	public String getMobileLogoUrl() {
		return getProperty("mobile.logo.url");
	}
	public String getRESTSearchBaseUrl() {
		return getProperty("rest.search.base.url");
	}
	public String getRESTNutrientsBaseUrl() {
		return getProperty("rest.nutrients.base.url");
	}
	


}
