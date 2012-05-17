/*
 * Created on Dec 30, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity.comparator;

import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;

import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.apps.kqool.exception.FatalApplicationException;
import com.theavocadopapers.core.logging.Logger;


/**
 * @author Steve Schneider
 * 
 */
public class UserComparator implements Comparator {

	private static final Logger logger = Logger.getLogger(UserComparator.class);

	public static final int LAST_NAME=1;
	public static final int FIRST_NAME=2;
	public static final int USERNAME=3;
	public static final int EMAIL_ADDRESS=4;
	public static final int JOIN_DATE=5;
	public static final int LAST_ACCESS_DATE=6;
	
	public static final Date NO_DATE=new GregorianCalendar(1980,1,1).getTime();


	
	protected int type;
	protected boolean ascending=true;
	
	public UserComparator(final int type) {
		super();
		this.type=type;
	}
	public UserComparator(final int type, final boolean ascending) {
		super();
		this.type=type;
		this.ascending=ascending;
	}

	/* (non-Javadoc)
	 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
	 */
	public int compare(final Object o1, final Object o2) {
		Comparable c1, c2;
		switch (type) {
			case LAST_NAME: c1=((User)o1).getLastName().toLowerCase(); c2=((User)o2).getLastName().toLowerCase(); break;
			case FIRST_NAME: c1=((User)o1).getFirstName().toLowerCase(); c2=((User)o2).getFirstName().toLowerCase(); break;
			case USERNAME: c1=((User)o1).getUsername().toLowerCase(); c2=((User)o2).getUsername().toLowerCase(); break;
			case EMAIL_ADDRESS: c1=((User)o1).getEmailAddress().toLowerCase(); c2=((User)o2).getEmailAddress().toLowerCase(); break;
			case JOIN_DATE: {
				c1=((User)o1).getJoinDate();
				c2=((User)o2).getJoinDate();
				if (c1==null) {
					c1=NO_DATE;
				}
				if (c2==null) {
					c2=NO_DATE;
				}
				break;
			} 
			case LAST_ACCESS_DATE: {
				c1=new Long(((User)o1).getLastAccessDate().getTime());
				c2=new Long(((User)o2).getLastAccessDate().getTime());
				if (c1==null) {
					c1=new Long(NO_DATE.getTime());
				}
				if (c2==null) {
					c2=new Long(NO_DATE.getTime());
				}
				break;
			}
			default: throw new FatalApplicationException("Unrecognized type.");
		}
		//logger.debug("c1.getClass().getName()="+c1.getClass().getName());
		//logger.debug("c2.getClass().getName()="+c2.getClass().getName());
		if (ascending) {
			return c1.compareTo(c2);
		}
		// descending:
		return c2.compareTo(c1);
	}

}
