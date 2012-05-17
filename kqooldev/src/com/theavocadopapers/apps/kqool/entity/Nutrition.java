/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.List;

import com.theavocadopapers.core.logging.Logger;

/** 
 * @author iahmad
 *
 */
public class Nutrition extends AbstractDbObject {
	
	private static final Class currentClass=Nutrition.class;
	
	//private static final Logger logger = Logger.getLogger(currentClass);

	protected int userId;

	String sundayRec="";
	String mondayRec="";
	String tuesdayRec="";
	String wednesdayRec="";
	String thursdayRec="";
	String fridayRec="";
	String saturdayRec="";
	String instructions="";

	public static NutritionPlan getById(final int id) {
		return (NutritionPlan)getById(currentClass, id, false);
	}
	
	@Override
	protected Comparable getComparableValue() {
		return new Integer(getId());
	}

	public int getUserId() {
		return this.userId;
	}
	public void setUserId(final int userId) {
		this.userId = userId;
	}

	public static NutritionPlan getByUserId(final int userId) {
		return (NutritionPlan)getUniqueByField("userId", 
""+userId, FIELD_TYPE_NUMERIC, currentClass, false);
	}

	public static List getAll() {
		return getAll(currentClass);
	}

	public void setSundayRec(String rec) { 
		this.sundayRec = rec;
	}
	public void setMondayRec(String rec) { 
		this.mondayRec = rec;
	}
	public void setTuesdayRec(String rec) { 
		this.tuesdayRec = rec;
	}
	public void setWednesdayRec(String rec) { 
		this.wednesdayRec = rec;
	}
	public void setThursdayRec(String rec) { 
		this.thursdayRec = rec;
	}
	public void setFridayRec(String rec) { 
		this.fridayRec = rec;
	}
	public void setSaturdayRec(String rec) { 
		this.saturdayRec = rec;
	}
	public void setInstructions(String instr) { 
		this.instructions = instr;
	}

        public String getSundayRec() { 
		return this.sundayRec;
	}
        public String getMondayRec() { 
		return this.mondayRec;
	} 
        public String getTuesdayRec() { 
		return this.tuesdayRec;
	} 
        public String getWednesdayRec() { 
		return this.wednesdayRec;
	} 
        public String getThursdayRec() { 
		return this.thursdayRec;
	} 
        public String getFridayRec() { 
		return this.fridayRec;
	} 
        public String getSaturdayRec() { 
		return this.saturdayRec;
	} 
	public String getInstructions() { 
		return this.instructions;
	}
}
