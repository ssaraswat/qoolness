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
public class PreRegistrationUserData extends AbstractDbObject {


	private static final Class currentClass=PreRegistrationUserData.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	


	protected String lastName;
	protected String firstName;
	protected String username;
	protected String emailAddress;
	protected String comments;
	protected int gender;
	protected int siteId;

	
	

	public static PreRegistrationUserData getById(final int id) {
		return (PreRegistrationUserData)getById(currentClass, id, false);
	}
	

	

	@Override
	protected Comparable getComparableValue() {
		return username.toLowerCase();
	}





	// convenience method to get formatted name/username:
	public String getFormattedNameAndUsername() {
		return new StringBuilder(""+this.getLastName()+", "+this.getFirstName()+" ("+this.getUsername()+")").toString();
	}







	public String getComments() {
		return this.comments;
	}
	public void setComments(final String comments) {
		this.comments = comments;
	}
	public String getEmailAddress() {
		return this.emailAddress;
	}
	public void setEmailAddress(final String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public String getFirstName() {
		return this.firstName;
	}
	public void setFirstName(final String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return this.lastName;
	}
	public void setLastName(final String lastName) {
		this.lastName = lastName;
	}


	public String getUsername() {
		return this.username;
	}
	public void setUsername(final String username) {
		this.username = username;
	}



	


	public static boolean exists(final String username) {
		return getByUsername(username)!=null;
	}
	

	public static PreRegistrationUserData getByUsername(final String username) {
		return (PreRegistrationUserData)getUniqueByField("username", username, FIELD_TYPE_TEXTUAL, currentClass, false);
	}
	
	public static List getAll() {
		return getAll(new SessionWrapper());
	}
	
	public static List getAll(final SessionWrapper sessionWrapper) {
		return getAll(currentClass, sessionWrapper);
	}
		


	public void delete()  {
		deleteById(currentClass, this.getId());
	}
	
	
	/**
	 * @return Returns the gender.
	 */
	public int getGender() {
		return gender;
	}
	/**
	 * @param gender The gender to set.
	 */
	public void setGender(final int gender) {
		this.gender = gender;
	}




	public int getSiteId() {
		return siteId;
	}




	public void setSiteId(final int siteId) {
		this.siteId = siteId;
	}
	
	
}
