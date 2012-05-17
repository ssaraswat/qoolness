package com.theavocadopapers.apps.kqool;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;

public class PfdProperties {

	
	public static final String PROPERTIES_FILENAME="/pfd.properties";
	
	protected static Properties allProperties=new Properties();
	

	
	public PfdProperties() {
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

	public LinkedHashMap<String,String> getOptionsItemValueLabelMap(final String code) {
		try {
			final LinkedHashMap<String,String> map=new LinkedHashMap<String,String>(20);
			final String answerValuesProp=getProperty("optionsitem."+code+".answervalues");
			final String[] answerValues=answerValuesProp.split("\\~");
			final String answerLabelsProp=getProperty("optionsitem."+code+".answerlabels");
			final String[] answerLabels=answerLabelsProp.split("\\~");
			final int mapSize=answerValues.length;
			for (int i=0; i<mapSize; i++) {
				map.put(answerValues[i], answerLabels[i]);
			}
			return map;
		}
		catch (final RuntimeException e) {
			return null;
		}
	}
	
	public String getQuestion(final String code) {
		final String q=getProperty("question."+code+"");
		if (q==null) {
			throw new NullPointerException("Property not found for question."+code);
		}
		return q;
	}
	
	/** Keys are codes (e.g. howLongExercise), values are verbose questions
	 * @return
	 */
	public Map<String,String> getAllQuestionsAsMap() {
		final Iterator keysIt=allProperties.keySet().iterator();
		final Map<String,String> map=new HashMap<String,String>();
		String key;
		final String prefix="question.";
		final int prefixLength=prefix.length();
		while (keysIt.hasNext()) {
			key=(String)keysIt.next();
			if (key.startsWith(prefix)) {
				map.put(key.substring(prefixLength, key.length()), allProperties.getProperty(key));
			}
		}
		return map;
	}
	
	public String[] getItemsGroupCodes(final String groupName) {
		final String prop=getProperty("itemsgroup."+groupName);
		return prop.split("\\~");
	}
	

	
	


}
