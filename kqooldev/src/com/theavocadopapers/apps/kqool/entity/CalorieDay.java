/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import com.theavocadopapers.core.logging.Logger;


/**
 * @author sschneider
 *
 */
public class CalorieDay extends AbstractDbObject {


	private static final Class currentClass=CalorieDay.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);




	protected int dateYear;
	protected int dateMonth;
	protected int dateDate;
	protected int userId;
	protected int weekId;
	protected float weight;
	protected float waist;
	protected float chest;
	protected float thigh;
	protected float hip;

	

	public static CalorieDay getById(final int id) {
		return (CalorieDay)getById(currentClass, id, false);
	}
	



	@Override
	protected Comparable getComparableValue() {
		return new Integer(this.dateYear*365+this.dateMonth*30+this.dateDate);
	}













	public static CalorieDay getByUserIdAndDate(final int userId, final Date date, final boolean createIfNotFound)  {	
		try {
			final Calendar cal=new GregorianCalendar();
			cal.setTime(date);
			final List daysList=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = '"+userId+"' and i.dateYear = '"+cal.get(Calendar.YEAR)+"' and i.dateMonth='"+cal.get(Calendar.MONTH)+"' and i.dateDate='"+cal.get(Calendar.DATE)+"'", false);
			if (daysList==null || daysList.size()==0) {
				if (createIfNotFound) {
					final CalorieDay calorieDay=new CalorieDay();
					calorieDay.setUserId(userId);
					cal.setTime(date);
					calorieDay.setDateYear(cal.get(Calendar.YEAR));
					calorieDay.setDateMonth(cal.get(Calendar.MONTH));
					calorieDay.setDateDate(cal.get(Calendar.DATE));
					calorieDay.store();
					return calorieDay;
				}
				else {
					return null;
				}
			}
			return (CalorieDay)daysList.get(0);
		}
		catch (final Exception e) {
			throw new RuntimeException(e);
		}
	} 







	
	public static List getAll() {
		return getAll(currentClass);
	}

	





	public int getUserId() {
		return userId;
	}
	public void setUserId(final int userId) {
		this.userId = userId;
	}
	

	public float getChest() {
		return chest;
	}
	public void setChest(final float chest) {
		this.chest = chest;
	}
	public float getHip() {
		return hip;
	}
	public void setHip(final float hip) {
		this.hip = hip;
	}
	public float getThigh() {
		return thigh;
	}
	public void setThigh(final float thigh) {
		this.thigh = thigh;
	}
	public float getWaist() {
		return waist;
	}
	public void setWaist(final float waist) {
		this.waist = waist;
	}
	public float getWeight() {
		return weight;
	}
	public void setWeight(final float weight) {
		this.weight = weight;
	}
	public int getDateDate() {
		return dateDate;
	}
	public void setDateDate(final int dateDate) {
		this.dateDate = dateDate;
	}
	public int getDateMonth() {
		return dateMonth;
	}
	public void setDateMonth(final int dateMonth) {
		this.dateMonth = dateMonth;
	}
	public int getDateYear() {
		return dateYear;
	}
	public void setDateYear(final int dateYear) {
		this.dateYear = dateYear;
	}

	public int getWeekId() {
		return weekId;
	}
	public void setWeekId(final int weekId) {
		this.weekId = weekId;
	}
}
