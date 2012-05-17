package com.theavocadopapers.apps.kqool;

import java.io.InputStream;
import java.util.Properties;

public class GenericProperties {

	
	public static final String PROPERTIES_FILENAME="/generic.properties";
	
	protected static Properties allProperties=new Properties();
	

	
	public GenericProperties() {
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
					e.printStackTrace();
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
	
	
	public boolean propertyExists(final String name) {
		return getProperty(name)!=null;
	}

	public boolean isUseNewPfpForm() {
		return getBooleanProperty("use.new.pfp.form");
	}
	
	public String getCommentsEmailAddress() {
		return getProperty("comments.email.address");
	}

	public String getExceptionEmailAddress() {
		return getProperty("exception.email.address");
	}

	public String getUserPhotoFilesysRoot() {
		return getProperty("user.photo.filesys.root");
	}

	public String getUserPhotoHttpPath() {
		return getProperty("user.photo.http.path");
	}
	
	public String getJavascriptDocumentDomain() {
		return getProperty("javascript.document.domain");
	}

	public String getVideoFilesysRoot() {
		return getProperty("video.filesys.root");
	}

	public String getVideoThumbFilesysRoot() {
		return getProperty("video.thumb.filesys.root");
	}

	public String getGenericVideoThumbImage() {
		return getProperty("generic.video.thumb.image");
	}
	
	public String getP3pPolicyRefFqUrl() {
		return getProperty("p3p.policy.ref.fq.url");
	}

	
	
	


}
