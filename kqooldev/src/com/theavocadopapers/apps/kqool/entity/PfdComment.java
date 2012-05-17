/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.List;

import com.theavocadopapers.core.logging.Logger;



/** 
 * @author sschneider
 *
 */
public class PfdComment extends AbstractDbObject {
	
	private static final Class currentClass=PfdComment.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	protected int userId;
	protected int commentingUserId;
	protected String commentText;

	


	public static PfdComment getById(final int id) {
		return (PfdComment)getById(currentClass, id, false);
	}
	
	public static List getByUserId(final int userId) {
		return getByField("userId", userId, FIELD_TYPE_NUMERIC, currentClass, false);
	}
	

	@Override
	protected Comparable getComparableValue() {
		return getCreateDate();
	}


	public int getUserId() {
		return userId;
	}


	public void setUserId(final int userId) {
		this.userId = userId;
	}


	public int getCommentingUserId() {
		return commentingUserId;
	}


	public void setCommentingUserId(final int commentingUserId) {
		this.commentingUserId = commentingUserId;
	}


	public String getCommentText() {
		return commentText;
	}


	public void setCommentText(final String commentText) {
		this.commentText = commentText;
	}




}
