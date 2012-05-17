/*
 * Created on Apr 13, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.core.util;

import java.io.UnsupportedEncodingException;

/**
 * @author sschneider
 *
 */
public class URLDecoder {

	public static final String DEFAULT_ENCODING=URLEncoder.DEFAULT_ENCODING;
	
	/**
	 * Can't instantiate this class.
	 *
	 */	
	private URLDecoder() {}
	
	/**
	 * Decode the string with the default encoding specified by DEFAULT_ENCODING ("UTF-8") - this gets around the annoying deprecation of java.net.URLDecoder(String s) and resulting exception handling that must therefore take place.
	 * @param s
	 * @return
	 */
	public static String decode(final String s) {
		try {
			return java.net.URLDecoder.decode(s, "UTF-8");
		} 
		catch (final UnsupportedEncodingException e) {
			throw new RuntimeException(e);
		}
	}
	
    public static String decode(final String s, final String enc) throws UnsupportedEncodingException {
    	return java.net.URLDecoder.decode(s, enc);
    }

	
	
}
