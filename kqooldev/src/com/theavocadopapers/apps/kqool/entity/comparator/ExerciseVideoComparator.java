/*
 * Created on Dec 30, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity.comparator;

import java.util.Comparator;

import com.theavocadopapers.apps.kqool.entity.ExerciseVideo;
import com.theavocadopapers.apps.kqool.exception.FatalApplicationException;


/**
 * @author Steve Schneider
 *
 */
public class ExerciseVideoComparator implements Comparator {

	public static final int CATEGORY=1;
	public static final int NAME=2;


	
	protected int type;
	
	public ExerciseVideoComparator(int type) {
		super();
		this.type=type;
	}

	/* (non-Javadoc)
	 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
	 */
	public int compare(Object o1, Object o2) {
		String c1, c2;
		switch (type) {
			case CATEGORY: c1=((ExerciseVideo)o1).getExerciseCategory(); c2=((ExerciseVideo)o2).getExerciseCategory(); break;
			case NAME: c1=((ExerciseVideo)o1).getName(); c2=((ExerciseVideo)o2).getName(); break;
			default: throw new FatalApplicationException("Unrecognized type.");
		}
		c1=c1.toLowerCase();
		c2=c2.toLowerCase();
		return c1.compareTo(c2);
	}

}