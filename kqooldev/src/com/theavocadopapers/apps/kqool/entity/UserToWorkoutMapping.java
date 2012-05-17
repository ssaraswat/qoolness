/*
 * Created on Dec 30, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.ArrayList;
import java.util.List;

import com.theavocadopapers.core.logging.Logger;

/**
 * @author Steve Schneider
 *
 */
public class UserToWorkoutMapping extends IntToIntMapping {

	private static final Class currentClass=UserToWorkoutMapping.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	public static final int TYPE=TYPE_USER_TO_WORKOUT;


	public UserToWorkoutMapping() {}

	public UserToWorkoutMapping(final IntToIntMapping intToIntMapping) {
		this.setUserId(intToIntMapping.getFromInt());
		this.setWorkoutId(intToIntMapping.getToInt());
		this.setType(TYPE);
		this.publicSetId(intToIntMapping.getId());
	}


	public static UserToWorkoutMapping getById(final int id) {
		return (UserToWorkoutMapping)getById(IntToIntMapping.currentClass, id, false);
	}
	


	public static List getAll() {
		final List<IntToIntMapping> mappings=getAll(TYPE);
		return asSubclasses(mappings);
	}

	
	public static void delete(final int userId, final int workoutId)  {
	    delete(userId, workoutId, TYPE);
	}
	


	public static List<UserToWorkoutMapping> getByUserId(final int id) {
		final List<IntToIntMapping> mappings=getByFromInt(id, TYPE);
		return asSubclasses(mappings);
	}
	

	
	public static List<UserToWorkoutMapping> getByWorkoutId(final int id)  {
		final List<IntToIntMapping> mappings=getByToInt(id, TYPE);
		return asSubclasses(mappings);
	}


 	
	private static List<UserToWorkoutMapping> asSubclasses(final List<IntToIntMapping> mappings) {
		if (mappings==null) {
			return null;
		}
		final int mappingsSize=mappings.size();
		final List<UserToWorkoutMapping> objects=new ArrayList<UserToWorkoutMapping>(mappingsSize);
		for (int i=0; i<mappingsSize; i++) {
			objects.add(new UserToWorkoutMapping(mappings.get(i)));
		}
		return objects;
	}


	
	public void setUserId(final int id) {
		setFromInt(id);
	}
	public void setWorkoutId(final int id) {
		setToInt(id);
	}
	public int getUserId() {
		return getFromInt();
	}
	public int getWorkoutId() {
		return getToInt();
	}
	
	

}
