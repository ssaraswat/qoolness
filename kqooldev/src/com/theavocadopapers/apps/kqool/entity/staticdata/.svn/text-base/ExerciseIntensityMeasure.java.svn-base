/*
 * Created on Apr 11, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity.staticdata;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.theavocadopapers.hibernate.SessionWrapper;




/**
 * @author sschneider
 *
 */
public class ExerciseIntensityMeasure extends StaticDataObject {
 
	public ExerciseIntensityMeasure() {
		super(TYPE_EXERCISE_INTENSITY_MEASURE);
	}
	
	/**
	 * @param name
	 * @param uspsCode
	 */
	public ExerciseIntensityMeasure(final String name, final String abbrev, final String code) {
		super(TYPE_EXERCISE_INTENSITY_MEASURE);
		setLabel(name);
		setString255Char(abbrev);
		setString16Char(code);
		
	}
	
	public static List getAll() {
		return getAll(new SessionWrapper());
	} 
	public static List getAll(final SessionWrapper sessionWrapper) {
		final List allSdo=getAllOfType(TYPE_EXERCISE_INTENSITY_MEASURE, ExerciseIntensityMeasure.class, sessionWrapper);
		if (allSdo==null) {
			return null;
		}
		final List all=new ArrayList(allSdo.size()*2);
		final Iterator allSdoIterator=allSdo.iterator();
		StaticDataObject sdo;
		while (allSdoIterator.hasNext()) {
			sdo=(StaticDataObject) allSdoIterator.next();
			all.add(new ExerciseIntensityMeasure(sdo.getLabel(), sdo.getString255Char(), sdo.getString16Char()));
		}
		return all;
	} 

	
	
	public String getName() {
		return getLabel();
	}
	public String getAbbrev() {
		return getString255Char();
	}
	public String getCode() {
		return getString16Char();
	}


}
