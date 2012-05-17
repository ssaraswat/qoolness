/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.SessionWrapper;


/**
 * @author sschneider
 *
 */
public class ExerciseVideo extends AbstractDbObject {

	private static final Class currentClass=ExerciseVideo.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);


	protected String name;
	protected String exerciseCategory;
	protected String altIconImage;
	protected String description;
	protected String filename;

	
	
	public static ExerciseVideo getById(final int id) {
		return getById(id, new SessionWrapper());
	}

	public static ExerciseVideo getById(final int id, final SessionWrapper sessionWrapper) {
		return (ExerciseVideo)getById(currentClass, id, true, sessionWrapper);
	}
	

	
	@Override
	protected Comparable getComparableValue() {
		return name;
	}






	public static List getByExerciseCategory(final String exerciseCategory)  {
		return getByField("exerciseCategory", exerciseCategory, FIELD_TYPE_TEXTUAL, currentClass, true);
	}


	public static Exercise getByName(final String name) {
		return (Exercise)getUniqueByField("name", name, FIELD_TYPE_TEXTUAL, currentClass, true);
	}
	
	public static Map getAllAsMap() {
		return getAllAsMap(currentClass);
	}
	
	public static Map getAllAsMapExerciseIdKeys(final List allExercises) {
		final Map<Integer,ExerciseVideo> videosMap=getAllAsMap();
		final Map map=new HashMap(videosMap.size());
		int videoId;
		ExerciseVideo video;
		for (final Object exercise : allExercises) {
			videoId=((Exercise)exercise).getExerciseVideoId();
			video=videosMap.get(videoId);
			if (video!=null) {
				map.put(((Exercise)exercise).getId(), video);
			}
		}
		return map;
	}
	
	
	public static void deleteById(final int id) {
		deleteById(currentClass, id);
	}



	public String getName() {
		return name;
	}
	public void setName(final String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}
	public void setDescription(final String description) {
		this.description = description;
	}
	public String getAltIconImage() {
		return altIconImage;
	}
	public void setAltIconImage(final String altIconImage) {
		this.altIconImage = altIconImage;
	}
	public String getExerciseCategory() {
		return exerciseCategory;
	}
	public void setExerciseCategory(final String exerciseCategory) {
		this.exerciseCategory = exerciseCategory;
	}
    /**
     * @return Returns the filename.
     */
    public String getFilename() {
        return filename;
    }
    /**
     * @param filename The filename to set.
     */
    public void setFilename(final String filename) {
        this.filename=filename;
    }

    public String getThumbnailFilename() {
    	return filename.substring(0, filename.lastIndexOf("."))+".jpg";
    }

    public static List getAll() {
    	return getAll(new SessionWrapper());
    }
    public static List getAll(final SessionWrapper sessionWrapper) {
		return getAll(currentClass, sessionWrapper);
	}
		


}
