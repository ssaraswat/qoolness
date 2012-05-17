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
public class AmericanState extends StaticDataObject {

	public AmericanState() {
		super(TYPE_AMERICAN_STATE);
	}
	

	/**
	 * @param name
	 * @param uspsCode
	 */
	public AmericanState(final String name, final String uspsCode) {
		super(TYPE_AMERICAN_STATE);
		setLabel(name);
		setString16Char(uspsCode);
	}
	
	public String getName() {
		return getLabel();
	}
	
	public String getUspsCode() {
		return getString16Char();
	}

	public static List getAll() {
		final List allSdo=getAllOfType(TYPE_AMERICAN_STATE, AmericanState.class);
		if (allSdo==null) {
			return null;
		}
		final List all=new ArrayList(allSdo.size()*2);
		final Iterator allSdoIterator=allSdo.iterator();
		StaticDataObject sdo;
		while (allSdoIterator.hasNext()) {
			sdo=(StaticDataObject) allSdoIterator.next();
			all.add(new AmericanState(sdo.getLabel(), sdo.getString16Char()));
		}
		return all;
	} 
	
}
