/*
 * Created on Dec 30, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.List;

import com.theavocadopapers.core.logging.Logger;


/**
 * @author Steve Schneider
 *
 */
public class ArticleToExerciseMapping extends IntToIntMapping {

	
	private static final Class currentClass=ArticleToExerciseMapping.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	public static final int TYPE=TYPE_ARTICLE_TO_EXECISE;

	

	public static ArticleToExerciseMapping getById(final int id) {
		return (ArticleToExerciseMapping)getById(IntToIntMapping.currentClass, id, true);
	}



	
	public static List getAll() {
		return getAll(TYPE);
	}

	
	public static void delete(final int articleId, final int exerciseId)  {
	    delete(articleId, exerciseId, TYPE);
	}
	


	public static List getByArticleId(final int id) {
	    return getByFromInt(id, TYPE);
	}
	

	
	public static List getByExerciseId(final int id) {
	    return getByToInt(id, TYPE);
	}

	
	
	
	public void setArticleId(final int id) {
		setFromInt(id);
	}
	public void setExerciseId(final int id) {
		setToInt(id);
	}
	public int getArticleId() {
		return getFromInt();
	}
	public int getExerciseId() {
		return getToInt();
	}
	
	

}
