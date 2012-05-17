/*
 * Created on Apr 11, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity.staticdata;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import com.theavocadopapers.apps.kqool.entity.AbstractDbObject;
import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.SessionWrapper;


/**
 * @author sschneider
 *
 */
public class StaticDataObject extends AbstractDbObject {

	
	private static final Class currentClass=StaticDataObject.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	public static final int TYPE_AMERICAN_STATE=1;
	public static final int TYPE_COUNTRY=2;
	public static final int TYPE_FOOD_ITEM=3;
	public static final int TYPE_CANADIAN_PROVINCE=4;
	public static final int TYPE_EXERCISE_QUANTITY_MEASURE=5;
	public static final int TYPE_EXERCISE_INTENSITY_MEASURE=6;
	public static final int TYPE_EXERCISE_CATEGORY=7;
	
	public static final int[] TYPES={
		0, // ignore
		TYPE_AMERICAN_STATE,
		TYPE_COUNTRY,
		TYPE_FOOD_ITEM,
		TYPE_CANADIAN_PROVINCE,
		TYPE_EXERCISE_QUANTITY_MEASURE,
		TYPE_EXERCISE_INTENSITY_MEASURE,
		TYPE_EXERCISE_CATEGORY,
	};

	protected static Hashtable cachedListsHash=inittedCachedListsHash();

	
	protected int type;
	protected String label;
	protected String string255Char;
	protected String string16Char;
	protected int int1;
	protected int int2;
	protected int int3;
	protected int int4;
	protected float float1;
	protected float float2;

	public StaticDataObject() {
		super();
	}

	/**
	 * @return
	 */
	private static Hashtable inittedCachedListsHash() {
		final Hashtable hash=new Hashtable();
		for (int i=1; i<TYPES.length; i++) {
			hash.put(new Integer(i), new ArrayList(0));
		}
		return hash;
	}

	public static final String DEFAULT_TABLE_NAME="static_data_object";
	

	/**
	 * @param type
	 */
	protected StaticDataObject(final int type) {
		super();
		this.type = type;
	}

	
	@Override
	protected Comparable getComparableValue() {
		return label;
	}


	protected void setLinkedIdsFields(final Connection connection) throws SQLException {

	}


	/**
	 * @return Returns the float1.
	 */
	public float getFloat1() {
		return this.float1;
	}
	/**
	 * @param float1 The float1 to set.
	 */
	public void setFloat1(final float float1) {
		this.float1 = float1;
	}
	/**
	 * @return Returns the float2.
	 */
	public float getFloat2() {
		return this.float2;
	}
	/**
	 * @param float2 The float2 to set.
	 */
	public void setFloat2(final float float2) {
		this.float2 = float2;
	}
	/**
	 * @return Returns the int1.
	 */
	public int getInt1() {
		return this.int1;
	}
	/**
	 * @param int1 The int1 to set.
	 */
	public void setInt1(final int int1) {
		this.int1 = int1;
	}
	/**
	 * @return Returns the int2.
	 */
	public int getInt2() {
		return this.int2;
	}
	/**
	 * @param int2 The int2 to set.
	 */
	public void setInt2(final int int2) {
		this.int2 = int2;
	}
	/**
	 * @return Returns the label.
	 */
	public String getLabel() {
		return this.label;
	}
	/**
	 * @param label The label to set.
	 */
	public void setLabel(final String label) {
		this.label = label;
	}
	/**
	 * @return Returns the string16Char.
	 */
	public String getString16Char() {
		return this.string16Char;
	}
	/**
	 * @param string16Char The string16Char to set.
	 */
	public void setString16Char(final String string16Char) {
		this.string16Char = string16Char;
	}
	/**
	 * @return Returns the string255Char.
	 */
	public String getString255Char() {
		return this.string255Char;
	}
	/**
	 * @param string255Char The string255Char to set.
	 */
	public void setString255Char(final String string255Char) {
		this.string255Char = string255Char;
	}
	/**
	 * @return Returns the type.
	 */
	public int getType() {
		return this.type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(final int type) {
		this.type = type;
	}
	/**
	 * @return Returns the int3.
	 */
	public int getInt3() {
		return this.int3;
	}
	/**
	 * @param int3 The int3 to set.
	 */
	public void setInt3(final int int3) {
		this.int3 = int3;
	}
	/**
	 * @return Returns the int4.
	 */
	public int getInt4() {
		return this.int4;
	}
	/**
	 * @param int4 The int4 to set.
	 */
	public void setInt4(final int int4) {
		this.int4 = int4;
	}
	
	
	public static List getAllOfType(final int type, final Class cls, final boolean fromCacheIfCached) {
		return getAllOfType(type, cls, fromCacheIfCached, new SessionWrapper());
	}
	protected static List getAllOfType(final int type, final Class cls, final boolean fromCacheIfCached, final SessionWrapper sessionWrapper) {
		List all=(List)cachedListsHash.get(new Integer(type));
		if(all==null) {
			return null;
		}
		if (all.size()==0 || !fromCacheIfCached) {
			all=getByField("type", type, FIELD_TYPE_NUMERIC, currentClass, false, sessionWrapper); // false because this class does its own caching
			cachedListsHash.put(new Integer(type), all);
		}
		return all;
	}
	
	public static List getAllOfType(final int type, final Class cls) {
		return getAllOfType(type, cls, new SessionWrapper());
	}
	protected static List getAllOfType(final int type, final Class cls, final SessionWrapper sessionWrapper) {
		return getAllOfType(type, cls, true, sessionWrapper);
	}




	
}
