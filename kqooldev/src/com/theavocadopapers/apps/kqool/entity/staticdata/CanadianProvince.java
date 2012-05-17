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
public class CanadianProvince extends StaticDataObject {


	/**
	 * @param name
	 * @param postalCode
	 */
	public CanadianProvince(final String name, final String postalCode) {
		super(TYPE_CANADIAN_PROVINCE);
		setLabel(name);
		setString16Char(postalCode);
	}
	
	public String getName() {
		return getLabel();
	}
	
	public String getPostalCode() {
		return getString16Char();
	}

	

	public static List getAll() {
		final List allSdo=getAllOfType(TYPE_CANADIAN_PROVINCE, CanadianProvince.class);
		if (allSdo==null) {
			return null;
		}
		final List all=new ArrayList(allSdo.size()*2);
		final Iterator allSdoIterator=allSdo.iterator();
		StaticDataObject sdo;
		while (allSdoIterator.hasNext()) {
			sdo=(StaticDataObject) allSdoIterator.next();
			all.add(new CanadianProvince(sdo.getLabel(), sdo.getString16Char()));
		}
		return all;
	} 

}
