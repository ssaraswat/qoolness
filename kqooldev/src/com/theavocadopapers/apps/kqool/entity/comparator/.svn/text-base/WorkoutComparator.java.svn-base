/*
 * Created on Dec 30, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity.comparator;

import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;

import com.theavocadopapers.apps.kqool.entity.Workout;
import com.theavocadopapers.apps.kqool.exception.FatalApplicationException;


/**
 * @author Steve Schneider
 *
 */
public class WorkoutComparator implements Comparator {

	public static final Date NO_DATE_INDICATOR=new GregorianCalendar(1980,1,1).getTime();
	
	public static final int DATE=1; // for performed date
	public static final int NAME=2;
	public static final int ASSIGNED_DATE=3;



	
	protected int type;
	protected boolean ascending=true;

	
	public WorkoutComparator(final int type, final boolean ascending) {
		super();
		this.type=type;
		this.ascending=ascending;
	}
	
	public WorkoutComparator(final int type) {
		super();
		this.type=type;
	}

	/* (non-Javadoc)
	 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
	 */
	public int compare(final Object o1, final Object o2) {
		Comparable c1, c2;
		if (type==DATE || type==ASSIGNED_DATE) {
			if (type==DATE) {
				c1=((Workout)o1).getPerformedDate();
				c2=((Workout)o2).getPerformedDate();
			}
			else { // ASSIGNED_DATE
				c1=((Workout)o1).getCreateDate();
				c2=((Workout)o2).getCreateDate();
			}
			c1=(c1==null?NO_DATE_INDICATOR:c1);
			c2=(c2==null?NO_DATE_INDICATOR:c2);
		}
		else if (type==NAME) {
			c1=((Workout)o1).getName().toLowerCase();
			c2=((Workout)o2).getName().toLowerCase();
		}
		else {
			throw new FatalApplicationException("Unrecognized type.");
		}
		return (ascending?c1.compareTo(c2):c2.compareTo(c1));
	}

}
