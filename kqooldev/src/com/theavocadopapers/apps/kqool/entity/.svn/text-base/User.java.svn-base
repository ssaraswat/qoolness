/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.theavocadopapers.apps.kqool.SiteProperties;
import com.theavocadopapers.apps.kqool.exception.FailedLoginException;
import com.theavocadopapers.apps.kqool.exception.FatalApplicationException;
import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.core.util.DatabaseEncryptionException;
import com.theavocadopapers.core.util.Util;
import com.theavocadopapers.hibernate.SessionWrapper;


/**
 * @author sschneider
 *
 */
public class User extends AbstractDbObject {
	
	private static final Class currentClass=User.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	public static final int USER_TYPE_USER=1;
	public static final int USER_TYPE_BACKENDUSER=2;
	
	public static final int BACKENDUSER_TYPE_TRAINER=1;
	public static final int BACKENDUSER_TYPE_SITE_ADMIN=2;
	public static final int BACKENDUSER_TYPE_SUPER_ADMIN=3;
	public static final int BACKENDUSER_TYPE_NUTRITIONIST=4;
	
	public static final int BACKEND_USER_PARENT_USER_ID_CLIENT=-1; // all client users should have this as their value
	public static final int BACKEND_USER_PARENT_USER_ID_SUPERADMIN_PARENT=0; // trainers and siteadmins whose parent is superadmins should have this as their value (one superadmin can't own trainers or site-admins; all superadmins own them
	
	public static final int SECRET_QUESTION_MOTHERS_MAIDEN_NAME=1;
	public static final int SECRET_QUESTION_SSN_LAST_4=2;
	public static final int SECRET_QUESTION_FIRST_PETS_NAME=3;
	public static final int SECRET_QUESTION_FIRST_STREET=4;
	
	public static final int STATUS_PREACTIVE=1;
	public static final int STATUS_ACTIVE=2;
	public static final int STATUS_SUSPENDED=3;
	public static final int STATUS_DEACTIVATED=4;
	

	
	public static final int MALE=1;
	public static final int FEMALE=2;
	
	public User() {}
	

	public User(final PreRegistrationUserData userData) {
		super();
		setFields(userData);
	}

	protected String lastName;
	protected String firstName;
	protected String username;
	protected String emailAddress;
	protected int userType;
	protected int backendUserType; // 0 for non-backendusers
	protected int backendUserParentUserId; // for BA users only, their parent user's user ID, or one of the BACKEND_USER_PARENT_USER_ID_* constants above
	protected String emergencyContact;
	protected String password;
	protected Date joinDate;
	protected Date lastAccessDate;
	protected String commentsUserVisible;
	protected String commentsUserHidden;
	protected int secretQuestion;
	protected String secretAnswer;
	protected int status;
	protected int gender;
	protected int siteId;
	protected Date birthDate;
	protected boolean nutritionist = false;	

	public static User getById(final int id) {
		return (User)getById(currentClass, id, true); 
	}
	

	@Override
	protected Comparable getComparableValue() {
		return username.toLowerCase();
	}



	// convenience method to get formatted name/username:
	public String getFormattedNameAndUsername() {
		return new StringBuilder(""+this.getLastName()+", "+this.getFirstName()+" ("+this.getUsername()+")").toString();
	}




	public String getCommentsUserHidden() {
		return this.commentsUserHidden;
	}
	public void setCommentsUserHidden(final String commentsUserHidden) {
		this.commentsUserHidden = commentsUserHidden;
	}
	public String getCommentsUserVisible() {
		return this.commentsUserVisible;
	}
	public void setCommentsUserVisible(final String commentsUserVisible) {
		this.commentsUserVisible = commentsUserVisible;
	}
	public String getEmailAddress() {
		return this.emailAddress;
	}
	public void setEmailAddress(final String emailAddress) {
		this.emailAddress = emailAddress;
	}
	public String getEmergencyContact() {
		return this.emergencyContact;
	}
	public void setEmergencyContact(final String emergencyContact) {
		this.emergencyContact = emergencyContact;
	}
	public String getFirstName() {
		return this.firstName;
	}
	public void setFirstName(final String firstName) {
		this.firstName = firstName;
	}
	public Date getJoinDate() {
		return this.joinDate;
	}
	public void setJoinDate(final Date joinDate) {
		this.joinDate = joinDate;
	}
	public Date getLastAccessDate() {
		return this.lastAccessDate;
	}
	public void setLastAccessDate(final Date lastAccessDate) {
		this.lastAccessDate = lastAccessDate;
	}
	public String getLastName() {
		return this.lastName;
	}
	public void setLastName(final String lastName) {
		this.lastName = lastName;
	}

	public int getSecretQuestion() {
		return this.secretQuestion;
	}
	public void setSecretQuestion(final int secretQuestion) {
		this.secretQuestion = secretQuestion;
	}
	public int getStatus() {
		return this.status;
	}
	public void setStatus(final int status) {
		this.status = status;
	}

	public String getUsername() {
		return this.username;
	}
	public void setUsername(final String username) {
		this.username = username;
	}
	public int getUserType() {
		return this.userType;
	}
	public void setUserType(final int userType) {
		this.userType = userType;
	}

	public int getBackendUserType() {
		return this.backendUserType;
	}
	public void setBackendUserType(final int backendUserType) {
		this.backendUserType = backendUserType;
	}

	
	// convenience method:
	public boolean isBackendUser() {
		return this.getUserType()==USER_TYPE_BACKENDUSER;
	}
	
	public boolean isTrainerOrHigher() {
		return (
				this.getBackendUserType()==BACKENDUSER_TYPE_TRAINER || 
				this.getBackendUserType()==BACKENDUSER_TYPE_SITE_ADMIN || 
				this.getBackendUserType()==BACKENDUSER_TYPE_SUPER_ADMIN
		);
	}

	public boolean isSiteAdminOrHigher() {
		return (
				this.getBackendUserType()==BACKENDUSER_TYPE_SITE_ADMIN || 
				this.getBackendUserType()==BACKENDUSER_TYPE_SUPER_ADMIN
		);
	}

	public boolean isSuperAdmin() {
		return (this.getBackendUserType()==BACKENDUSER_TYPE_SUPER_ADMIN);
	}
	
	public String getDefaultBackendUserTypeLabel() {
		switch (this.getBackendUserType()) {
			case BACKENDUSER_TYPE_TRAINER: return "Trainer";
			case BACKENDUSER_TYPE_SITE_ADMIN: return "Site Admin";
			case BACKENDUSER_TYPE_SUPER_ADMIN: return "Super Admin";
			case BACKENDUSER_TYPE_NUTRITIONIST: return "Nutritionist";

			default: return "";
		}
	}

	
	// SETTERS/GETTERS FOR ENCRYPTED FIELDS:
	public String getPassword() throws DatabaseEncryptionException {
		return password;
	}
	public String getUnencryptedPassword() throws DatabaseEncryptionException {
		if (password==null) {
			return null;
		}
		return Util.databaseDecrypt(password);
	}
	public void setPassword(final String password) throws DatabaseEncryptionException {
		if (password==null) {
			this.password=null;
		}
		else {
			this.password=Util.databaseEncrypt(password); 
		}
	}
	
	public String getUnencryptedSecretAnswer() throws DatabaseEncryptionException {
		if (secretAnswer==null) {
			return null;
		}
		return Util.databaseDecrypt(secretAnswer);
	}
	public void setSecretAnswer(final String secretAnswer) throws DatabaseEncryptionException {
		if (secretAnswer==null) {
			this.secretAnswer=null;
		}
		else {
			this.secretAnswer=Util.databaseEncrypt(secretAnswer);
		}
	}	
	public String getSecretAnswer() {
		return secretAnswer;
	}

	

	

	
	public static void authenticate(final String username, final String password) throws FailedLoginException {

		final User testUser=getByUsername(username);
		if (testUser==null) {
			throw new FailedLoginException(FailedLoginException.REASON_CODE_UNRECOGNIZED_USERNAME);
		}
		try {
			String msg="";
			// We got here, so a user with this username exists; check password match:
			if (!(password.equals(testUser.getUnencryptedPassword()))) {
				throw new FailedLoginException(FailedLoginException.REASON_CODE_USERNAME_PASSWORD_MISMATCH);
			}
			if (password.trim().length()==0) {
				throw new FailedLoginException(FailedLoginException.REASON_CODE_FIRST_TIME_USER);
			}
			// Password okay; now make sure user is active:
			if (testUser.getStatus()!=STATUS_ACTIVE) {
				// User failed login because not active; determine status and set reasonCode accordingly:
				int reasonCode;
				if (testUser.getStatus()==STATUS_PREACTIVE) {
					throw new FailedLoginException(FailedLoginException.REASON_CODE_PREACTIVE_USER);
				}
				if (testUser.getStatus()==STATUS_SUSPENDED) {
					reasonCode=FailedLoginException.REASON_CODE_SUSPENDED_USER;
				}
				else if (testUser.getStatus()==STATUS_DEACTIVATED) {
					reasonCode=FailedLoginException.REASON_CODE_DEACTIVATED_USER;
				}
				else {
					msg="User status is "+testUser.getStatus()+".";
					reasonCode=FailedLoginException.REASON_CODE_OTHER;
				}
				throw new FailedLoginException(msg, reasonCode);
			}
		}
		catch (final DatabaseEncryptionException e) {
			throw new FatalApplicationException(e);
		}
	
		// We got here, so the authentication succeeded, indicated to client by lack of thrown FailedLoginException.
	}
	



	public static boolean exists(final String username) {
		return getByUsername(username)!=null;
	}
	

	public static User getByUsername(final String username) {
		return (User)getUniqueByField("username", username, FIELD_TYPE_TEXTUAL, currentClass, true);
	}
	
	public static List getBackendUserClients(final int backendUserId, final boolean activeOnly) {
		return getBackendUserClients(backendUserId, activeOnly, null);
	}
	
	// return all clients who are assigned to the specified backend user or to the backend user's trainers/site-admins:
	public static List getBackendUserClients(final int backendUserId, final boolean activeOnly, final SessionWrapper sessionWrapper) {
		final User backendUser=(User)getById(currentClass, backendUserId, false, sessionWrapper);
		if (!backendUser.isBackendUser()) {
			throw new IllegalArgumentException("User '"+backendUser.getUsername()+"' with ID "+backendUser.getId()+" is not a backend user.");
		}
		final boolean userIsSuperadmin=(backendUser.isSuperAdmin());
		if (userIsSuperadmin) {
			// user is a super admin, which means all clients are his clients, so:
			if (activeOnly) {
				return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.status = "+User.STATUS_ACTIVE+" and i.userType = "+User.USER_TYPE_USER, true, sessionWrapper);
			}
			else {
				return getByField("userType", User.USER_TYPE_USER, AbstractDbObject.FIELD_TYPE_NUMERIC, currentClass, true, sessionWrapper);
			}
		}
		else { // not a superadmin; either a trainer or a site admin:
			final List clientUsers=new ArrayList();
			// we need this backend users' clients but also (if a site admin) this site admin's trainers' clients if any, so...
			// ...first deal with direct mappings between this BA user and clients:
			final List allMappings=new ArrayList();
			List immediateMappings=ClientToBackendUserMapping.getByBackendUserId(backendUserId, sessionWrapper);
			if (immediateMappings==null) {
				immediateMappings=new ArrayList(0);
			}
			allMappings.addAll(immediateMappings);
			
			// ...second, if this BA user is a site-admin, get his trainers (if any) and add the trainers' mappings:
			if (backendUser.getBackendUserType()==User.BACKENDUSER_TYPE_SITE_ADMIN) {
				List trainerUsers=User.getBackendUserChildren(backendUserId, activeOnly, sessionWrapper);
				if (trainerUsers==null) {
					trainerUsers=new ArrayList(0);
				}
				final Iterator i=trainerUsers.iterator();
				User trainerUser;
				List mappings;
				while (i.hasNext()) {
					trainerUser=(User)i.next();
					mappings=ClientToBackendUserMapping.getByBackendUserId(trainerUser.getId(), sessionWrapper);
					if (mappings!=null) {
						allMappings.addAll(mappings);
					}
				}
			}
			

			final Iterator i=allMappings.iterator();
			User clientUser;
			ClientToBackendUserMapping mapping;
			while (i.hasNext()) {
				mapping=(ClientToBackendUserMapping) i.next();
				clientUser=(User)getById(currentClass, mapping.getClientUserId(), false, sessionWrapper);
				if (clientUser!=null) {
					if (!activeOnly || clientUser.getStatus()==User.STATUS_ACTIVE) {
						clientUsers.add(clientUser);
					}
				}
				
			}
			return clientUsers;
		}

	}

	public static List getBackendUserChildren(final int backendUserId, final boolean activeOnly) {
		return getBackendUserChildren(backendUserId, activeOnly, new SessionWrapper());
	}
	// return all backend users who are children of (or children of children of) the specified backend user
	public static List getBackendUserChildren(final int backendUserId, final boolean activeOnly, final SessionWrapper sessionWrapper) {
		User backendUser;
		if (backendUserId>0) {
			backendUser=(User)getById(currentClass, backendUserId, true, sessionWrapper);
		}
		else {
			// make a dummy superadmin user:
			backendUser=new User();
			backendUser.setUserType(USER_TYPE_BACKENDUSER);
			backendUser.setBackendUserType(BACKENDUSER_TYPE_SUPER_ADMIN);
		}
		if (!backendUser.isBackendUser()) {
			throw new IllegalArgumentException("User '"+backendUser.getUsername()+"' with ID "+backendUser.getId()+" is not a backend user.");
		}
		// NOTE!!! -- a backendUserId of 0 indicates generic superadmin:
		final boolean userIsSuperadmin=(backendUserId==0 || backendUser.isSuperAdmin());
		// if user is super admin, this is easy; we return all backend users aside from super admins:
		if (userIsSuperadmin) {
			if (activeOnly) {
				return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.status = "+User.STATUS_ACTIVE+" and i.userType = "+User.USER_TYPE_BACKENDUSER+" and (i.backendUserType = "+User.BACKENDUSER_TYPE_SITE_ADMIN+" or i.backendUserType = "+User.BACKENDUSER_TYPE_TRAINER+")", true);
			}
			else {
				return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userType = "+User.USER_TYPE_BACKENDUSER+" and i.backendUserType <> "+User.BACKENDUSER_TYPE_SUPER_ADMIN, true);
			}
		}
		else if (backendUser.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER) {
			// trainers have no backend-user children, so:
			return new ArrayList(0);
		}
		else {
			// this is a siteadmin and we want to return his trainer children:
			if (activeOnly) {
				return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.status = "+User.STATUS_ACTIVE+" and i.userType = "+User.USER_TYPE_BACKENDUSER+" and i.backendUserParentUserId = "+backendUserId, true);
			}
			else {
				return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userType = "+User.USER_TYPE_BACKENDUSER+" and i.backendUserParentUserId = "+backendUserId, true);
			}
			
		}

	}

	public static List getBackendUserParents(final int backendUserId, final boolean directParentsOnly, final boolean activeOnly) {
		return getBackendUserParents(backendUserId, directParentsOnly, activeOnly, new SessionWrapper());
	}

	// return all backend users who are parents (or parents of parents of) this backend user; this will include all super admins
	protected static List getBackendUserParents(final int backendUserId, final boolean directParentsOnly, final boolean activeOnly, final SessionWrapper sessionWrapper) {
		final User backendUser=(User)getById(currentClass, backendUserId, false, sessionWrapper);
		if (!backendUser.isBackendUser()) {
			throw new IllegalArgumentException("User '"+backendUser.getUsername()+"' with ID "+backendUser.getId()+" is not a backend user.");
		}
		final boolean userIsSuperadmin=(backendUser.isSuperAdmin());
		// if user is a super admin, he has not parents, so:
		if (userIsSuperadmin) {
			return new ArrayList(0);
		}
		// the user is a site admin or trainer; either way, all superadmins are his parents 
		// (although possibly not direct parents, but we'll deal with that in a sec), so:
		List allSuperadmins;
		if (activeOnly) {
			allSuperadmins=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.status = "+User.STATUS_ACTIVE+" and i.userType = "+User.USER_TYPE_BACKENDUSER+" and i.backendUserType = "+User.BACKENDUSER_TYPE_SUPER_ADMIN, true, sessionWrapper);
		}
		else {
			allSuperadmins=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userType = "+User.USER_TYPE_BACKENDUSER+" and i.backendUserType = "+User.BACKENDUSER_TYPE_SUPER_ADMIN, true, sessionWrapper);
		}
		User parentSiteadminUser=null;
		// only if the user is a trainer, he has exactly one site admin parent; get it if needed:
		if (backendUser.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER) {
			parentSiteadminUser=(User)getById(currentClass, backendUser.getBackendUserParentUserId(), false, sessionWrapper);
			if (activeOnly && parentSiteadminUser.getStatus()!=User.STATUS_ACTIVE) {
				parentSiteadminUser=null;
			}
		}
		final List parents=new ArrayList();
		// add the direct parent if applicable:
		if (parentSiteadminUser!=null) {
			parents.add(parentSiteadminUser);
		}
		// add the superadmins if the user is a siteadmin or if not directParentsOnly:
		if (backendUser.getBackendUserType()==User.BACKENDUSER_TYPE_SITE_ADMIN || !directParentsOnly) {
			parents.addAll(allSuperadmins);
		}
		return parents;
	}
	
	// return all backend users to whom the client is assigned:
	public static List getClientParents(final int clientUserId, final boolean directParentsOnly, final boolean activeOnly) {
		final SessionWrapper sessionWrapper=SessionWrapper.openIfNotOpen(null);
		try {
			final List backendUserMappings=ClientToBackendUserMapping.getByClientUserId(clientUserId, sessionWrapper);
			final List backendUsers=new ArrayList(backendUserMappings.size());
			Iterator i=backendUserMappings.iterator();
			User backendUser;
			ClientToBackendUserMapping mapping;
			while (i.hasNext()) {
				mapping=(ClientToBackendUserMapping) i.next();
				backendUser=(User)getById(currentClass, mapping.getBackendUserId(), false, sessionWrapper);
				if (!activeOnly || backendUser.getStatus()==User.STATUS_ACTIVE) {
					backendUsers.add(backendUser);
				}
			}
			
			// now, if not directParentsOnly, we iterate over all backend users and add their parents too:
			if (!directParentsOnly) {
				i=backendUsers.iterator();
				List parentUsers=new ArrayList();
				while (i.hasNext()) {
					backendUser=(User) i.next();
					parentUsers=backendUser.getBackendUserParents(backendUser.getId(), false, activeOnly, sessionWrapper);
				}
				backendUsers.addAll(parentUsers);
			}
			return backendUsers;
		}
		finally {
			SessionWrapper.closeIfNotNested(sessionWrapper);
		}
	}
	
	public static List getAllSuperAdmins(final boolean activeOnly) {
		if (activeOnly) {
			return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.status = "+User.STATUS_ACTIVE+" and i.userType = "+User.USER_TYPE_BACKENDUSER+" and i.backendUserType = "+User.BACKENDUSER_TYPE_SUPER_ADMIN, true);
		}		
		else {
			return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userType = "+User.USER_TYPE_BACKENDUSER+" and i.backendUserType = "+User.BACKENDUSER_TYPE_SUPER_ADMIN, true);
		}		
	}
	public static List getAll() {
		return getAll(new SessionWrapper());
	}
	
	public static List getAll(final SessionWrapper sessionWrapper) {
		return getAll(currentClass, sessionWrapper);
	}
	
	public static List getAllBackendUsers(final boolean activeOnly) {
		if (activeOnly) {
			return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.status = "+User.STATUS_ACTIVE+" and i.userType = "+User.USER_TYPE_BACKENDUSER, true);
		}
		else {
			return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userType = "+User.USER_TYPE_BACKENDUSER, true);
		}
	}
	
	public static List getAllClients(final boolean activeOnly) {
		if (activeOnly) {
			return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.status = "+User.STATUS_ACTIVE+" and i.userType = "+User.USER_TYPE_USER, true);
		}
		else {
			return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userType = "+User.USER_TYPE_USER, true);
		}
	}
	public static Map getAllAsMap() {
		return getAllAsMap(new SessionWrapper());
	}
	
	public static Map getAllAsMap(final SessionWrapper sessionWrapper) {
		return getAllAsMap(currentClass, sessionWrapper);
	}
		
	// convenience method:
	public boolean hasPastDueRoutines() {
		return Workout.userHasPastDueRoutines(this.getId());
	}
	

	
	public String getLinkedEmailAddress(final boolean escapeForJavaScript, String linkColor, final int siteId) {
		linkColor=(linkColor==null?new SiteProperties(siteId).getDefaultMailLinkColor():linkColor);
		final String quoteChars=(escapeForJavaScript?"\\\"":"\"");
		return "<a style=\"color:"+linkColor+";\" href="+quoteChars+"mailto:"+emailAddress+""+quoteChars+">"+emailAddress+"</a>";
	}
	
	public String getLinkedEmailAddress(final int siteId) {
		return getLinkedEmailAddress(false, null, siteId);
	}
	public String getLinkedEmailAddress(final boolean escapeForJavaScript, final int siteId) {
		return getLinkedEmailAddress(escapeForJavaScript, null, siteId);
	}
	public String getLinkedEmailAddress(final String linkColor, final int siteId) {
		return getLinkedEmailAddress(false, linkColor, siteId);
	}
	
	protected void setNonNullValues() {
		if (getCommentsUserHidden()==null) {
			setCommentsUserHidden("");
		}
		if (getCommentsUserVisible()==null) {
			setCommentsUserVisible("");
		}
		if (getEmergencyContact()==null) {
			setEmergencyContact("");
		}
		if (getLastAccessDate()==null) {
			setLastAccessDate(new Date());
		}		
		try {
			if (getPassword()==null) {
				setPassword("");
			}
			if (getSecretAnswer()==null) {
				setSecretAnswer("");
			}
		}
		catch (final DatabaseEncryptionException e) {
			logger.error("Exception trying to setNonNullValues()", e);
		}		
	}


	@Override
	public int store() { 
		setNonNullValues();
		final int id=super.store();
		return id;	
	}


	
	public void setFields(final PreRegistrationUserData userData) {
		username=userData.getUsername();
		firstName=userData.getFirstName();
		lastName=userData.getLastName();
		emailAddress=userData.getEmailAddress();	
		gender=userData.getGender();
		siteId=userData.getSiteId();
	}
	/**
	 * @return Returns the birthDate.
	 */
	public Date getBirthDate() {
		return birthDate;
	}
	/**
	 * @param birthDate The birthDate to set.
	 */
	public void setBirthDate(final Date birthDate) {
		this.birthDate = birthDate;
	}
	

	public int getBackendUserParentUserId() {
		return backendUserParentUserId;
	}


	public void setBackendUserParentUserId(final int backendUserParentUserId) {
		this.backendUserParentUserId = backendUserParentUserId;
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

	public boolean isNutritionist () { 
		return nutritionist;
	}

	public void setNutritionist (boolean nutritionist) {
		this.nutritionist = nutritionist;
	}
	
	public void setSiteId(final int siteId) {
		this.siteId = siteId;
	}

	
	public String getStatusLabel() {
		switch (status) {
			case STATUS_PREACTIVE: return "Preactive";
			case STATUS_ACTIVE: return "Active";
			case STATUS_SUSPENDED: return "Suspended";
			case STATUS_DEACTIVATED: return "Deactivated";
			default: throw new RuntimeException(""+status+" is not a valid status.");
		}
	}

	@Override
	public boolean equals(final Object o) {
		final User u=(User)o;
		return u.getId()==this.id;
	}


	@Override
	public int hashCode() {
		return id;
	}

	

}
