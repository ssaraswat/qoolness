/*
 * Created on Apr 11, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity.staticdata;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;



/**
 * @author sschneider
 *
 */
public class Country extends StaticDataObject {


	/**
	 * @param name
	 * @param iso3166CountryCode2Char
	 */
	public Country(final String name, final String iso3166CountryCode2Char) {
		super(TYPE_COUNTRY);
		setLabel(name);
		setString16Char(iso3166CountryCode2Char);
	}
	
	public String getName() {
		return getLabel();
	}
	/**
	 * @return same as getIso3166CountryCode2Char()
	 */
	public String getCode() {
		return getString16Char();
	}
	/**
	 * @return the ISO 3166 2-char country code.
	 */
	public String getIso3166CountryCode2Char() {
		return getString16Char();
	}
	

	public static List getAll() {
		final List allSdo=getAllOfType(TYPE_COUNTRY, Country.class);
		if (allSdo==null) {
			return null;
		}
		final List all=new ArrayList(allSdo.size()*2);
		final Iterator allSdoIterator=allSdo.iterator();
		StaticDataObject sdo;
		while (allSdoIterator.hasNext()) {
			sdo=(StaticDataObject) allSdoIterator.next();
			all.add(new Country(sdo.getLabel(), sdo.getString16Char()));
		}
		return all;
	} 


}
