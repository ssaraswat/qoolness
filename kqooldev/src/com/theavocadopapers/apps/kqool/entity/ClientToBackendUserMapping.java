/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.List;

import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.SessionWrapper;


/**
 * @author sschneider
 *
 */
public class ClientToBackendUserMapping extends AbstractDbObject {

	
	protected static final Class currentClass=ClientToBackendUserMapping.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);




	protected int clientUserId;
	protected int backendUserId;

	public ClientToBackendUserMapping() {
	}
	
	public ClientToBackendUserMapping(final int clientUserId, final int backendUserId) {
		this.clientUserId=clientUserId;
		this.backendUserId=backendUserId;
	}


	public static ClientToBackendUserMapping getById(final int id) {
		return (ClientToBackendUserMapping)getById(currentClass, id, true);
	}
	


	@Override
	public Comparable getComparableValue() {
		// can't imagine this being used ever, but:
		return new Integer(id);
	}






	public static List getByClientUserId(final int clientUserId)  {
		return getByClientUserId(clientUserId, new SessionWrapper());
	}	
	protected static List getByClientUserId(final int clientUserId, final SessionWrapper sessionWrapper)  {
		return getByField("clientUserId", clientUserId, AbstractDbObject.FIELD_TYPE_NUMERIC, currentClass, true, sessionWrapper);
	}

	public static List getByBackendUserId(final int backendUserId)  {
		return getByBackendUserId(backendUserId, new SessionWrapper());
	}
	protected static List getByBackendUserId(final int backendUserId, final SessionWrapper sessionWrapper)  {
		return getByField("backendUserId", backendUserId, AbstractDbObject.FIELD_TYPE_NUMERIC, currentClass, true, sessionWrapper);
	}
	
	public static boolean mappingExists(final int clientUserId, final int backendUserId)  {
		final List list=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.clientUserId = "+clientUserId+" and i.backendUserId = "+backendUserId, true);
		return (list!=null && list.size()>0);
	}
	
	public static void delete(final int clientUserId, final int backendUserId)  {
		final List list=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.clientUserId = "+clientUserId+" and i.backendUserId = "+backendUserId, false);
		AbstractDbObject obj=null;
		if (list!=null && list.size()>0) {
			obj=(ClientToBackendUserMapping)list.get(0);
		}
		if (obj!=null) {
			deleteById(currentClass, obj.getId());
		}
	}



	public int getClientUserId() {
		return clientUserId;
	}
	public void setClientUserId(final int clientUserId) {
		this.clientUserId = clientUserId;
	}
	public int getBackendUserId() {
		return backendUserId;
	}
	public void setBackendUserId(final int backendUserId) {
		this.backendUserId = backendUserId;
	}


	public static List getAll() {
		return getAll(currentClass);
	}


}
