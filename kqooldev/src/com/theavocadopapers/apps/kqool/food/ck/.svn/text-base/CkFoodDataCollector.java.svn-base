package com.theavocadopapers.apps.kqool.food.ck;

import java.io.IOException;
import java.io.StringReader;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import com.theavocadopapers.apps.kqool.food.Food;
import com.theavocadopapers.apps.kqool.food.Serving;
import com.theavocadopapers.apps.kqool.util.HttpUtils;
import com.theavocadopapers.core.logging.Logger;



public class CkFoodDataCollector {

	private static final Logger logger = Logger.getLogger(CkFoodDataCollector.class);

	static final String XML_READER_CLASS="org.apache.xerces.parsers.SAXParser";
	

	
	protected static CkProperties ckProperties=new CkProperties();
	
	public static List<Food> searchForFoodsByKeywords(final String keywords) throws IOException, SAXException {
		long start=new Date().getTime();
		final String xml=HttpUtils.getHttpResponse(ckProperties.getRESTSearchBaseUrl()+URLEncoder.encode(keywords, "UTF-8"), false, ckProperties.getDeveloperKey(), null);
		logger.info("Getting response for query '"+keywords+"' from CalorieKing took "+(new Date().getTime()-start)+"ms");
		final XMLReader parser=XMLReaderFactory.createXMLReader(XML_READER_CLASS);
		final CkFoodSearchContentHandler contentHandler=new CkFoodSearchContentHandler();
		parser.setContentHandler(contentHandler);
		parser.setErrorHandler(new CkErrorHandler());
		start=new Date().getTime();
		parser.parse(new InputSource(new StringReader(xml)));
		logger.info("Parsing XML from '"+keywords+"' query took "+(new Date().getTime()-start)+"ms");
		List<Food> results=contentHandler.getListItemsFromParsedXML();
		// clean up the results:
		start=new Date().getTime();
		if (results==null) {
			results=new ArrayList<Food>(0);
		}
		String label;
		for (final Food food: results) {
			label=food.getLabel();
			food.setLabel(okCharsOnly(label));
		}
		logger.info("Cleaning up search results for '"+keywords+"' query took "+(new Date().getTime()-start)+"ms");
		return results;
	}
 

	public static List<Serving> getNutrientDataForServings(final String foodId) throws IOException, SAXException {
		long start=new Date().getTime();
		final String xml=HttpUtils.getHttpResponse(ckProperties.getRESTNutrientsBaseUrl()+URLEncoder.encode(foodId, "UTF-8"), false, ckProperties.getDeveloperKey(), null);
		logger.info("Getting servings for foodId '"+foodId+"' from CalorieKing took "+(new Date().getTime()-start)+"ms");

		final XMLReader parser=XMLReaderFactory.createXMLReader(XML_READER_CLASS);
		final CkServingsContentHandler contentHandler=new CkServingsContentHandler();
		parser.setContentHandler(contentHandler);
		parser.setErrorHandler(new CkErrorHandler());
		start=new Date().getTime();
		parser.parse(new InputSource(new StringReader(xml)));
		logger.info("Parsing servings XML for foodId '"+foodId+"' took "+(new Date().getTime()-start)+"ms");
		List<Serving> results=contentHandler.getListItemsFromParsedXML();
		// clean up the results:
		start=new Date().getTime();
		if (results==null) {
			results=new ArrayList<Serving>(0);
		}
		String name;
		for (final Serving serving: results) {
			name=serving.getName();
			serving.setName(okCharsOnly(name));
		}
		logger.info("Cleaning up servings results for '"+foodId+"' took "+(new Date().getTime()-start)+"ms");
		return results;
	}

	
	private static String okCharsOnly(String s) {
		//final long start=new Date().getTime();
		if (s==null) {
			s="";
		}
		final StringBuilder b=new StringBuilder(s.length());
		final String okChars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 _-~!@#$%^&*()+= {[}]|:;<,>.";
		final int sLen=s.length();
		char c;
		for (int i=0; i<sLen; i++) {
			c=s.charAt(i);
			if (okChars.indexOf(c)>-1) {
				b.append(c);
			}
		}
		//logger.info("In okCharsOnly(), took "+(new Date().getTime()-start)+"ms to parse \""+s+"\".");
		return b.toString();
	}

}
