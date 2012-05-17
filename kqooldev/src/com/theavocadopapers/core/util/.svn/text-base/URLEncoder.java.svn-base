/*
 * Created on Apr 13, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.core.util;


/**
 * @author sschneider
 *
 */
public class URLEncoder {

	public static final String DEFAULT_ENCODING="UTF-8";
	
	/**
	 * Can't instantiate this class.
	 *
	 */	
	private URLEncoder() {}
	
	/**
	 * Encode the string with the default encoding specified by DEFAULT_ENCODING ("UTF-8") - this gets around the annoying deprecation of java.net.URLEncoder(String s) and resulting exception handling that must therefore take place.
	 * 
	 * @param s
	 * @return
	 */
	public static String encode(final String s) {
		return java.net.URLEncoder.encode(s);
	}
	
    public static String encode(final String s, final String enc) { //throws UnsupportedEncodingException {
    	return java.net.URLEncoder.encode(s);
    }

	
	
}
