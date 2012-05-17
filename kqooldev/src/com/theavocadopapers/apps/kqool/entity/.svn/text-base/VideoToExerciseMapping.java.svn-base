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
public class VideoToExerciseMapping extends IntToIntMapping {

	private static final Class currentClass=VideoToExerciseMapping.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	public static final int TYPE=TYPE_VIDEO_TO_EXECISE;

	public VideoToExerciseMapping() {}

	public VideoToExerciseMapping(final IntToIntMapping intToIntMapping) {
		this.setExerciseVideoId(intToIntMapping.getFromInt());
		this.setExerciseId(intToIntMapping.getToInt());
		this.setType(TYPE);
		this.publicSetId(intToIntMapping.getId());
	}


	public static VideoToExerciseMapping getById(final int id) {
		return (VideoToExerciseMapping)getById(IntToIntMapping.currentClass, id, true);
	}
	

	public static List getAll() {
		final List<IntToIntMapping> mappings=getAll(TYPE);
		return asSubclasses(mappings);
	}

	
	public static void delete(final int exerciseVideoId, final int exerciseId)  {
	    delete(exerciseVideoId, exerciseId, TYPE);
	}
	


	public static List<VideoToExerciseMapping> getByExerciseVideoId(final int id)  {
		final List<IntToIntMapping> mappings=getByFromInt(id, TYPE);
		return asSubclasses(mappings);

	}
	

	public static List<VideoToExerciseMapping> getByExerciseId(final int id)  {
		final List<IntToIntMapping> mappings=getByToInt(id, TYPE);
		return asSubclasses(mappings);
	} 

	
 	
	private static List<VideoToExerciseMapping> asSubclasses(final List<IntToIntMapping> mappings) {
		if (mappings==null) {
			return null;
		}
		final int mappingsSize=mappings.size();
		final List<VideoToExerciseMapping> objects=new ArrayList<VideoToExerciseMapping>(mappingsSize);
		for (int i=0; i<mappingsSize; i++) {
			objects.add(new VideoToExerciseMapping(mappings.get(i)));
		}
		return objects;
	}


	
	public void setExerciseVideoId(final int id) {
		setFromInt(id);
	}
	public void setExerciseId(final int id) {
		setToInt(id);
	}
	public int getExerciseVideoId() {
		return getFromInt();
	}
	public int getExerciseId() {
		return getToInt();
	}
	
	

}
