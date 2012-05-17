/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.theavocadopapers.core.logging.Logger;



/** 
 * @author sschneider
 *
 */
public class PfdItem extends AbstractDbObject {
	
	private static final Class currentClass=PfdItem.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	protected String code;
	protected String value;
	protected String subsequentValue;
	protected boolean current;
	protected int userId;
	protected int settingUserId;
	
	public PfdItem() {}

	public PfdItem(final PfdItem pfdItem) {
		this.code=pfdItem.code;
		this.value=pfdItem.value;
		this.userId=pfdItem.userId;
	}

	@Override
	protected Comparable getComparableValue() {
		return getCreateDate();
	}

	public String getCode() {
		return this.code;
	}
	public void setCode(final String code) {
		this.code = code;
	}
	public String getValue() {
		return this.value;
	}
	public void setValue(final String value) {
		this.value = value;
	}
	public boolean isCurrent() {
		return this.current;
	}
	private void setCurrent(final boolean current) {
		this.current = current;
	}
	public int getUserId() {
		return this.userId;
	}
	public void setUserId(final int userId) {
		this.userId = userId;
	}
	public int getSettingUserId() {
		return this.settingUserId;
	}
	private void setSettingUserId(final int settingUserId) {
		this.settingUserId = settingUserId;
	}
	public String getSubsequentValue() {
		return subsequentValue;
	}
	private void setSubsequentValue(final String subsequentValue) {
		this.subsequentValue = subsequentValue;
	}
	


	public static List getCurrentByUserId(final int userId) {
		return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = "+userId+" and i.current = true", false);
	} 

	public static boolean isUserHasCurrentItems(final int userId) {
		final List items=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = "+userId+" and i.current = true", 1, false);
		return (items!=null && items.size()>0);
	}
	
	public static boolean isUserHasHistoricalItems(final int userId) {
		final List items=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = "+userId+" and i.current = false", 1, false);
		return (items!=null && items.size()>0);
	}
	
	public static String getCurrentByUserIdAndCode(final int userId, final String code) {
		final List items=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = "+userId+" and i.current = true and i.code = '"+code+"'", 1, false);
		// special case for weight:
		if (code.equals("weight") && (items==null || items.size()==0)) {
			final User user=User.getById(userId);
			if (user.getGender()==User.MALE) {
				return ""+Exercise.DEFAULT_MALE_WEIGHT;
			}
			else {
				return ""+Exercise.DEFAULT_FEMALE_WEIGHT;
			}
		}
		return (items==null?null:((PfdItem)items.get(0)).getValue());
	}
	
	/** Keys are codes, values are PfdItems
	 * @return
	 */
	public static Map<String,PfdItem> getCurrentByUserIdAsMap(final int userId) {
		final List list=getCurrentByUserId(userId);
		if (list==null) {
			return null;
		}
		final Map<String,PfdItem> map=new HashMap<String,PfdItem>(list.size()*2);
		final Iterator listIt=list.iterator();
		PfdItem item;
		while (listIt.hasNext()) {
			item=(PfdItem) listIt.next();
			map.put(item.getCode(), item);
		}
		return map;
	}

	public static List getHistoricalByUserId(final int userId) {
		return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = "+userId+" and i.current = false", false);
	}


	
	/** Stores this item (inserts it; PfdItems are never updated); also sets the current flag of any existing items with this userId/code to false (never use store() to store PfdItems and sets the settingUserId; always use this)
	 * @return
	 */
	public int store(final int settingUserId) {
		if (this.getId()>0) {
			throw new IllegalStateException("Can't update; this method only inserts.  Always create a new instance of PfdItems and store that.");
		}
		this.setCurrent(true);
		this.setSettingUserId(settingUserId);
		PfdItem potentialOldItem;
		try {
			potentialOldItem=(PfdItem)getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = "+userId+" and i.code = '"+code+"' and i.current = true order by i.id desc", 1, false).get(0);
			if (this.getId()!=potentialOldItem.getId()) {
				potentialOldItem.setCurrent(false);
				potentialOldItem.setSubsequentValue(this.getValue());
				potentialOldItem.store();
			}
		}
		catch (final RuntimeException e) {} // could be NP or AIOB, either meaning that there isn't an older version
		return store();

	}



	

	
	
	
	


}
