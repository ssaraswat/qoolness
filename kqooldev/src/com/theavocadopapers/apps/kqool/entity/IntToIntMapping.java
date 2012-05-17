/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.List;

import com.theavocadopapers.core.logging.Logger;


/**
 * @author sschneider
 *
 */
public class IntToIntMapping extends AbstractDbObject {

	
	protected static final Class currentClass=IntToIntMapping.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	
	public static final int TYPE_USER_TO_WORKOUT=1;
	public static final int TYPE_VIDEO_TO_EXECISE=2;
	public static final int TYPE_ARTICLE_TO_EXECISE=3;
	


	protected int fromInt;
	protected int toInt;
	protected int type;


	public static IntToIntMapping getById(final int id) {
		return (IntToIntMapping)getById(currentClass, id, false);
	}
	


	@Override
	protected Comparable getComparableValue() {
		return new Integer(type);
	}






	protected static List getAll(final int type) {
		return getByField("type", type, FIELD_TYPE_NUMERIC, currentClass, true);
	}


	private static List getByFromOrToInt(final int n, final int type, final String intFieldName)  {
		return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i."+intFieldName+" = '"+n+"' and i.type = '"+type+"'", false);
	}
	
	protected static List getByFromInt(final int n, final int type)  {
		return getByFromOrToInt(n, type, "fromInt");
	}

	protected static List getByToInt(final int n, final int type)  {
		return getByFromOrToInt(n, type, "toInt");
	}
	
	public static void delete(final int fromInt, final int toInt, final int type)  {
		final IntToIntMapping obj=(IntToIntMapping) getByHQLQuery("fromInt = '"+fromInt+"' and toInt = '"+toInt+"' and type = '"+type+"'", false);
		if (obj!=null) {
			deleteById(currentClass, obj.getId());
		}
	}



	public int getFromInt() {
		return fromInt;
	}
	public void setFromInt(final int fromInt) {
		this.fromInt = fromInt;
	}
	public int getToInt() {
		return toInt;
	}
	public void setToInt(final int toInt) {
		this.toInt = toInt;
	}
	public int getType() {
		return type;
	}
	public void setType(final int type) {
		this.type = type;
	}
}
