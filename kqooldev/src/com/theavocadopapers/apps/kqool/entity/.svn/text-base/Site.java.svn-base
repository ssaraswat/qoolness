/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.List;
import java.util.Map;

import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.SessionWrapper;

/**
 * @author sschneider
 *
 */
public class Site extends AbstractDbObject {

	
	private static final Class currentClass=Site.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);
	
	public static final int UI_TYPE_KQOOL_PROPER=1;
	public static final int UI_TYPE_SKINNABLE_LITE=2;
	public static final int UI_TYPE_SKINNABLE_MEDIUM=3;
	public static final int UI_TYPE_SKINNABLE_FULL=4;

	protected String label;
	protected String domainPrefix;
	protected String comments;
	protected int uiType;
	protected boolean canShareClients;
	protected int primaryContactUserId;



	public static Site getById(final int id) {
		return (Site)getById(currentClass, id, true);
	}
	

	

	@Override
	protected Comparable getComparableValue() {
		return new Integer(id);
	}







	public static boolean exists(final String label) {
		return getByLabel(label)!=null;
	}
	



	public static Site getByLabel(final String label) {
		return (Site)getUniqueByField("label", label, FIELD_TYPE_TEXTUAL, currentClass, true);
	}

	/*
	public static Site getByDomainPrefix(final String domainPrefix) {
		return (Site)getUniqueByField("domainPrefix", domainPrefix, FIELD_TYPE_TEXTUAL, currentClass);
	}
	*/
	
	public static List getAll() {
		return getAll(new SessionWrapper());
	}
	
	public static List getAll(final SessionWrapper sessionWrapper) {
		return getAll(currentClass, sessionWrapper);
	}
	
	public static Map getAllAsMap() {
		return getAllAsMap(currentClass);
	}

	public String getLabel() {
		return label;
	}
	public void setLabel(final String label) {
		this.label = label;
	}




	public String getDomainPrefix() {
		return domainPrefix;
	}




	public void setDomainPrefix(final String domainPrefix) {
		this.domainPrefix = domainPrefix;
	}




	public String getComments() {
		return comments;
	}




	public void setComments(final String comments) {
		this.comments = comments;
	}




	public int getUiType() {
		return uiType;
	}




	public void setUiType(final int uiType) {
		this.uiType = uiType;
	}




	public boolean isCanShareClients() {
		return canShareClients;
	}




	public void setCanShareClients(final boolean canShareClients) {
		this.canShareClients = canShareClients;
	}




	public int getPrimaryContactUserId() {
		return primaryContactUserId;
	}




	public void setPrimaryContactUserId(final int primaryContactUserId) {
		this.primaryContactUserId = primaryContactUserId;
	}




}
