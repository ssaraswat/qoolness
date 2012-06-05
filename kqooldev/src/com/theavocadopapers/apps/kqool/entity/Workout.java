/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.theavocadopapers.core.logging.Logger;


/**
 * @author sschneider
 *
 */
public class Workout extends AbstractDbObject {

	
	private static final Class currentClass=Workout.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	
	public static final int STATUS_ACTIVE=1;
	public static final int STATUS_INACTIVE=2;
	
	protected String name;
	protected String comments;
	protected boolean prescriptive;
	protected boolean administratorAssigned;
	protected int status=STATUS_ACTIVE;
	protected int userId; // formerly used only for self-assigned workouts; now used for trainer-assigned workouts (routines) as well.
	protected double weightLbs; // used only for descriptive workouts
	protected Date performedDate; // used only for descriptive workouts; null means not completed
	protected int assigningBackendUserId; // if any (there usually will be, but not if user creates his own routine)
	protected int sourceWorkoutId; // if this is a workout based on a routine (that is, a backend-user-assigned workout), this will be that routine's id
	protected Date dueDate; // prescriptive workouts assigned by backend users will have due dates (null indicates no due date).
	protected Date recordedAsWorkoutDate; // prescriptive workouts assigned by BE users get this date set when a descriptive workout is saved from this workout

	
	// loaded by ExerciseDetail methods:
	protected List<ExerciseDetail> exerciseDetails;




	public static Workout getById(final int id) {
		return (Workout)getById(currentClass, id, false);
	}
	

	


	
	
    /**
     * @return Returns the exerciseDetails.
     */
    public List getExerciseDetails() {
        return exerciseDetails;
    }
    /**
     * @param exerciseDetails The exerciseDetails to set.
     */
    public void setExerciseDetails(final List exerciseDetails) {
        this.exerciseDetails=exerciseDetails;
    }

    
	@Override
	protected Comparable getComparableValue() {
		return id; // effectively sorts chronologically
	}









	public static boolean exists(final String name) {
		return getByName(name)!=null;
	}
	

	public static Workout getByName(final String name) {
		return (Workout)getUniqueByField("name", name, FIELD_TYPE_TEXTUAL, currentClass, false);
	}
	
	public static Workout getBySourceWorkoutId(final int sourceWorkoutId) {
		return (Workout)getUniqueByField("sourceWorkoutId", ""+sourceWorkoutId, FIELD_TYPE_NUMERIC, currentClass, false);
	}
	
	
	
	public static List getAll() {
		return getAll(currentClass);
	}

	public static List getAllAdministratorAssignedByStatus(final int status) {
		if (status!=STATUS_ACTIVE && status!=STATUS_INACTIVE) {
			throw new IllegalArgumentException("status value is invalid; valid values are STATUS_ACTIVE nad STATUS_INACTIVE.");
		}
		return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.administratorAssigned = true and i.status = '"+status+"'", false);
	}
	
	
	public static List getAllAdministratorAssigned()  {
		return getByField("administratorAssigned", "true", FIELD_TYPE_BOOLEAN, currentClass, true);
	}

	public static List getAdministratorAssignedByAssigningBackendUserId(final int backendUserId, final int maxResults) {
		return getAdministratorAssignedByAssigningBackendUserId(backendUserId, maxResults, false);
	}
	
	public static List getAdministratorAssignedByAssigningBackendUserId(final int backendUserId, final int maxResults, final boolean activeOnly) {
		String activeOnlyAndClause="";
		if (activeOnly) {
			activeOnlyAndClause=" and i.status="+Workout.STATUS_ACTIVE+" ";
		}
		return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.administratorAssigned = true and i.assigningBackendUserId = '"+backendUserId+"' "+activeOnlyAndClause+" order by i.id desc", maxResults, true);
	}
	
	public static List getAdministratorAssignedByUserId(final int userId) {
		return getAdministratorAssignedByUserId(userId, 9999999);
	}
	
	public static List getAdministratorAssignedByUserId(final int userId, final int maxResults) {
		return getAdministratorAssignedByUserId(userId, maxResults, true);
	}
	
	public static List getAdministratorAssignedByUserId(final int userId, final int maxResults, final boolean activeOnly) {
		return getAdministratorAssignedByClientIdAndBackendUserId(userId, -1, maxResults, activeOnly);
	}
	
	public static List getAdministratorAssignedByBackendUserId(final int backendUserId, final int maxResults, final boolean activeOnly) {
		return getAdministratorAssignedByClientIdAndBackendUserId(-1, backendUserId, maxResults, activeOnly);
	}
	
	public static List getAdministratorAssignedByClientIdAndBackendUserId(final int userId, final int backendUserId, final int maxResults, final boolean activeOnly) {
		String activeOnlyAndClause="";
		if (activeOnly) {
			activeOnlyAndClause=" and i.status="+Workout.STATUS_ACTIVE+" ";
		}	
		String userIdAndClause="";
		if (userId>-1) {
			userIdAndClause=" and i.userId="+userId+" ";
		}
		String backendUserIdAndClause="";
		if (backendUserId>-1) {
			backendUserIdAndClause=" and i.assigningBackendUserId="+backendUserId+" ";
		}
		return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.administratorAssigned = true "+userIdAndClause+" "+backendUserIdAndClause+" "+activeOnlyAndClause+" order by i.id desc", maxResults, false);
	}

	public static List getUserCreated(final int userId, final boolean prescriptive) {
		return getUserCreated(userId, prescriptive, 9999999);
	}
	
	public static List getUserCreated(final int userId, final boolean prescriptive, final int maxResults) {
		return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.administratorAssigned = false and i.userId = '"+userId+"' and i.prescriptive="+prescriptive+" order by i.id desc", maxResults, false);
	}
	

	public static boolean userHasPastDueRoutines(final int userId) {
		final long nowTime=new Date().getTime();
		List routines=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = "+userId+" and i.status = "+Workout.STATUS_ACTIVE+" and i.administratorAssigned = true and i.prescriptive = true and i.dueDate is not null and i.recordedAsWorkoutDate is null", false);
		routines=(routines==null?new ArrayList():routines);
		final Iterator it=routines.iterator();
		Workout routine;
		while (it.hasNext()) {
			routine=(Workout)it.next();
			if (routine.getDueDate().getTime()<nowTime) {
				return true;
			}
		}
		return false;
	}
	
	public static List getAllRoutinesForDate() {
		String sCurrDate;
    	Format formatter;
		Date currDate=new Date();
    	formatter = new SimpleDateFormat("yyyy-MM-dd");
    	sCurrDate = formatter.format(currDate);		
		List routines=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where Date(i.dueDate) = '"+sCurrDate+"'", false);
		routines=(routines==null?new ArrayList():routines);
		final Iterator it=routines.iterator();
		Workout routine;
		while (it.hasNext()) {
			routine=(Workout)it.next();
		
		}
		return routines;
	}
	
	

	
	
	public String getComments() {
		return comments;
	}
	public void setComments(final String comments) {
		this.comments = comments;
	}
	public String getName() {
		return name;
	}
	public void setName(final String name) {
		this.name = name;
	}
	// convenience:
	public boolean isPrescriptive() {
		return getPrescriptive();
	}
	public boolean getPrescriptive() {
		return prescriptive;
	}
	public void setPrescriptive(final boolean prescriptive) {
		this.prescriptive = prescriptive;
	}
	public boolean isAdministratorAssigned() {
		return administratorAssigned;
	}
	public void setAdministratorAssigned(final boolean administratorAssigned) {
		this.administratorAssigned = administratorAssigned;
	}
	/**
	 * @return Returns the userId.
	 */
	public int getUserId() {
		return userId;
	}
	/**
	 * @param userId The userId to set.
	 */
	public void setUserId(final int userId) {
		this.userId = userId;
	}
	/**
	 * @return Returns the status.
	 */
	public int getStatus() {
		return status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(final int status) {
		this.status = status;
	}
	/**
	 * @return Returns the weightLbs.
	 */
	public double getWeightLbs() {
		return weightLbs;
	}
	/**
	 * @param weightLbs The weightLbs to set.
	 */
	public void setWeightLbs(final double weightLbs) {
		this.weightLbs = weightLbs;
	}
    /**
     * @return Returns the performedDate.
     */
    public Date getPerformedDate() {
        return performedDate;
    }
    /**
     * @param performedDate The performedDate to set.
     */
    public void setPerformedDate(final Date performedDate) {
        this.performedDate=performedDate;
    }

	public int getAssigningBackendUserId() {
		return assigningBackendUserId;
	}

	public void setAssigningBackendUserId(final int assigningBackendUserId) {
		this.assigningBackendUserId = assigningBackendUserId;
	}

	public int getSourceWorkoutId() {
		return sourceWorkoutId;
	}

	public void setSourceWorkoutId(final int sourceWorkoutId) {
		this.sourceWorkoutId = sourceWorkoutId;
	}

	public Date getDueDate() {
		return dueDate;
	}

	public void setDueDate(final Date dueDate) {
		this.dueDate = dueDate;
	}

	public Date getRecordedAsWorkoutDate() {
		return recordedAsWorkoutDate;
	}

	public void setRecordedAsWorkoutDate(final Date recordedAsWorkoutDate) {
		this.recordedAsWorkoutDate = recordedAsWorkoutDate;
	}





}
