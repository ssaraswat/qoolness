/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.ListIterator;

import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.SessionWrapper;

/**
 * @author sschneider
 *
 */
public class CalorieWeek extends AbstractDbObject {



	private static final Class currentClass=CalorieWeek.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);
	
	public static final int FIRST_DAY_OF_WEEK_CALENDAR_CONSTANT = Calendar.SUNDAY;
	
	public static final String TABLE_NAME="calorie_week";

	private static final String GET_EARLIEST_BY_USER_ID_SQL = "select * from calorie_week where user_id = ? order by start_date_year ASC, start_date_month ASC, start+date+date ASC,  limit 1";


	protected int startDateYear;
	protected int startDateMonth;
	protected int startDateDate;
	protected String comments;
	protected int userId;
	protected double endWeight=-1.0;
	protected double endWaist=-1.0;
	protected double endChest=-1.0;
	protected double endThigh=-1.0;
	protected double endHip=-1.0;
	protected double totalCalIntake;
	protected double totalCalExpended;
	
	protected double totalFatIntake;
	protected double totalCarbIntake;
	protected double totalProteinIntake;
	protected double totalFiberIntake;
	protected double totalSugarIntake;
	protected double totalSodiumIntake;
	protected double totalCalciumIntake;
	protected double totalSatfatIntake;
	protected double totalCholesterolIntake;

	


	public static CalorieWeek getById(final int id) {
		return (CalorieWeek)getById(currentClass, id, false);
	}
	

	
	

	@Override
	protected Comparable getComparableValue() {
		return new Integer(this.startDateYear*365+this.startDateMonth*30+this.startDateDate);
	}



	/**
	 * @param calorieHour
	 * @param adding True if the CalorieHour is being added; false if it's being deleted
	 */
	public void adjustIngestedValuesBasedOnCalorieHour(final CalorieHour calorieHour, final boolean adding) {
		final int negativityFactor=(adding?1:-1);
		if (calorieHour.getTotalIngestedCalories()>-1) {
			this.totalCalIntake+=(calorieHour.getTotalIngestedCalories()*negativityFactor);
			this.totalCalIntake=(this.totalCalIntake==-0.0?0.0:this.totalCalIntake);
		}
		if (calorieHour.getTotalIngestedFat()>-1) {
			this.totalFatIntake+=(calorieHour.getTotalIngestedFat()*negativityFactor);
			this.totalFatIntake=(this.totalFatIntake==-0.0?0.0:this.totalFatIntake);
		}
		if (calorieHour.getTotalIngestedCarb()>-1) {
			this.totalCarbIntake+=(calorieHour.getTotalIngestedCarb()*negativityFactor);
			this.totalCarbIntake=(this.totalCarbIntake==-0.0?0.0:this.totalCarbIntake);
		}
		if (calorieHour.getTotalIngestedProtein()>-1) {
			this.totalProteinIntake+=(calorieHour.getTotalIngestedProtein()*negativityFactor);
			this.totalProteinIntake=(this.totalProteinIntake==-0.0?0.0:this.totalProteinIntake);
		}
		if (calorieHour.getTotalIngestedFiber()>-1) {
			this.totalFiberIntake+=(calorieHour.getTotalIngestedFiber()*negativityFactor);
			this.totalFiberIntake=(this.totalFiberIntake==-0.0?0.0:this.totalFiberIntake);
		}
		if (calorieHour.getTotalIngestedSugar()>-1) {
			this.totalSugarIntake+=(calorieHour.getTotalIngestedSugar()*negativityFactor);
			this.totalSugarIntake=(this.totalSugarIntake==-0.0?0.0:this.totalSugarIntake);
		}
		if (calorieHour.getTotalIngestedSodium()>-1) {
			this.totalSodiumIntake+=(calorieHour.getTotalIngestedSodium()*negativityFactor);
			this.totalSodiumIntake=(this.totalSodiumIntake==-0.0?0.0:this.totalSodiumIntake);
		}
		if (calorieHour.getTotalIngestedCalcium()>-1) {
			this.totalCalciumIntake+=(calorieHour.getTotalIngestedCalcium()*negativityFactor);
			this.totalCalciumIntake=(this.totalCalciumIntake==-0.0?0.0:this.totalCalciumIntake);
		}
		if (calorieHour.getTotalIngestedSatfat()>-1) {
			this.totalSatfatIntake+=(calorieHour.getTotalIngestedSatfat()*negativityFactor);
			this.totalSatfatIntake=(this.totalSatfatIntake==-0.0?0.0:this.totalSatfatIntake);
		}
		if (calorieHour.getTotalIngestedCholesterol()>-1) {
			this.totalCholesterolIntake+=(calorieHour.getTotalIngestedCholesterol()*negativityFactor);
			this.totalCholesterolIntake=(this.totalCholesterolIntake==-0.0?0.0:this.totalCholesterolIntake);
		}
	}




	public static CalorieWeek getEarliestByUserId(final int userId, final boolean createIfNotFound)  {	
		final SessionWrapper sessionWrapper=SessionWrapper.openIfNotOpen(null);
		try {
			final List weeksList=getBySQLQuery(GET_EARLIEST_BY_USER_ID_SQL.replaceAll("?", ""+userId), false, sessionWrapper);
			if (weeksList==null || weeksList.size()==0) {
				if (createIfNotFound) {
					final CalorieWeek calorieWeek=new CalorieWeek();
					calorieWeek.setUserId(userId);
					final Calendar cal=new GregorianCalendar();
					cal.setTime(getCurrentWeekStartDate());
					calorieWeek.setStartDateYear(cal.get(Calendar.YEAR));
					calorieWeek.setStartDateMonth(cal.get(Calendar.MONTH));
					calorieWeek.setStartDateDate(cal.get(Calendar.DATE));
					calorieWeek.setComments("");
					calorieWeek.store(sessionWrapper);
				}
				else {
					return null;
				}
			}
			return (CalorieWeek)weeksList.get(0);
		}
		finally {
			SessionWrapper.closeIfNotNested(sessionWrapper);
		}
	} 
	public static CalorieWeek getByUserIdAndDate(final int userId, final Date date, final boolean createIfNotFound)  {
		return getByUserIdAndDate(userId, date, createIfNotFound, new SessionWrapper());
	}
	
	protected static CalorieWeek getByUserIdAndDate(final int userId, final Date date, final boolean createIfNotFound, final SessionWrapper sessionWrapper)  {	
		final Calendar cal=new GregorianCalendar();
		cal.setTime(date);
		while (cal.get(Calendar.DAY_OF_WEEK)!=Calendar.SUNDAY) {
			cal.add(Calendar.DATE, -1);
		}

		final List weeksList=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = '"+userId+"' and i.startDateYear = '"+cal.get(Calendar.YEAR)+"' and i.startDateMonth='"+cal.get(Calendar.MONTH)+"' and i.startDateDate='"+cal.get(Calendar.DATE)+"'", false, sessionWrapper);

		if (weeksList==null || weeksList.size()==0) {
			if (createIfNotFound) {
				final CalorieWeek calorieWeek=new CalorieWeek();
				calorieWeek.setUserId(userId);
				calorieWeek.setStartDateYear(cal.get(Calendar.YEAR));
				calorieWeek.setStartDateMonth(cal.get(Calendar.MONTH));
				calorieWeek.setStartDateDate(cal.get(Calendar.DATE));

				calorieWeek.setComments("");
				calorieWeek.store(sessionWrapper);
				return calorieWeek;
			}
			else {
				return null;
			}
		}
		return (CalorieWeek)weeksList.get(0);
	} 


	public static List getAllByUserId(final int userId, final boolean createCurrentAndLastIfNotFound)  {	
		final SessionWrapper sessionWrapper=SessionWrapper.openIfNotOpen(null);
		try {
			List weeksList=getByField("userId", userId, FIELD_TYPE_NUMERIC, currentClass, false, sessionWrapper);
	
			weeksList=(weeksList==null?new ArrayList(0):weeksList);
			final ListIterator weeksIterator=weeksList.listIterator();
			final CalorieWeek calorieWeek;
			final List calorieHours;
			final List calorieDays;
			// remove weeks which were inserted at one point but which don't have any CalorieHours associated with them:
			
			/*while (weeksIterator.hasNext()) {
				calorieWeek=(CalorieWeek) weeksIterator.next();
				calorieHours=CalorieHour.getByWeekId(calorieWeek.getId());
				if (calorieHours==null || calorieHours.size()==0) {
					weeksIterator.remove();
					// also remove the CalorieWeek from the db, so we're not always dealing with it:
					CalorieWeek.deleteById(currentClass, calorieWeek.getId());
				}
			}
			*/
			if (createCurrentAndLastIfNotFound) {
				final CalorieWeek thisWeek=getCurrentByUserId(userId, false, sessionWrapper);
				if (thisWeek==null) {
					weeksList.add(getCurrentByUserId(userId, true, sessionWrapper));
				}
				
				final CalorieWeek lastWeek=getCurrentByUserId(userId, -1, false);
				if (lastWeek==null) {
					weeksList.add(getCurrentByUserId(userId, -1, true, sessionWrapper));
				}
			}
			if (weeksList.size()==0) {
				return null;
			}
			Collections.sort(weeksList);
			return weeksList;
		}
		finally {
			SessionWrapper.closeIfNotNested(sessionWrapper);
		}

	} 

	public static CalorieWeek getCurrentByUserId(final int userId, final boolean createIfNotFound)  {
		return getCurrentByUserId(userId, createIfNotFound, new SessionWrapper());
	}
	
	protected static CalorieWeek getCurrentByUserId(final int userId, final boolean createIfNotFound, final SessionWrapper sessionWrapper)  {	
		return getCurrentByUserId(userId, 0, createIfNotFound, sessionWrapper);
	}	
	
	public static CalorieWeek getCurrentByUserId(final int userId, final int weeksOffset, final boolean createIfNotFound)  {
		return getCurrentByUserId(userId, weeksOffset, createIfNotFound, new SessionWrapper());
	}
	
	protected static CalorieWeek getCurrentByUserId(final int userId, final int weeksOffset, final boolean createIfNotFound, final SessionWrapper sessionWrapper)  {	
		final Calendar cal=new GregorianCalendar();
		cal.setTime(getCurrentWeekStartDate());
		if (weeksOffset!=0) {
			cal.add(Calendar.DATE, weeksOffset*7);
		}
		return getByUserIdAndDate(userId, cal.getTime(), createIfNotFound, sessionWrapper);
	}	
	



	
	


	
	/**
	 * @return
	 */
	public static Date getCurrentWeekStartDate() {
		return getWeekStartDate(new Date());
	}
	
	public static Date getWeekStartDate(final Date date) {
		final GregorianCalendar cal=new GregorianCalendar();
		cal.setTime(date);
		cal.set(Calendar.AM_PM, Calendar.AM);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		while (cal.get(Calendar.DAY_OF_WEEK)!=FIRST_DAY_OF_WEEK_CALENDAR_CONSTANT) {
			cal.add(Calendar.DATE, -1);
		}
		return cal.getTime();		
	}

	
	public static List getAll() {
		return getAll(currentClass);
	}
		

	



	
	
	public String getComments() {
		return comments;
	}
	public void setComments(final String comments) {
		this.comments = comments;
	}



	public int getUserId() {
		return userId;
	}
	public void setUserId(final int userId) {
		this.userId = userId;
	}
	

	public double getEndChest() {
		return endChest;
	}
	public void setEndChest(final double endChest) {
		this.endChest = endChest;
	}
	public double getEndHip() {
		return endHip;
	}
	public void setEndHip(final double endHip) {
		this.endHip = endHip;
	}
	public double getEndThigh() {
		return endThigh;
	}
	public void setEndThigh(final double endThigh) {
		this.endThigh = endThigh;
	}
	public double getEndWaist() {
		return endWaist;
	}
	public void setEndWaist(final double endWaist) {
		this.endWaist = endWaist;
	}
	public double getEndWeight() {
		return endWeight;
	}
	public void setEndWeight(final double endWeight) {
		this.endWeight = endWeight;
	}
	public int getStartDateDate() {
		return startDateDate;
	}
	public void setStartDateDate(final int startDateDate) {
		this.startDateDate = startDateDate;
	}
	public int getStartDateMonth() {
		return startDateMonth;
	}
	public void setStartDateMonth(final int startDateMonth) {
		this.startDateMonth = startDateMonth;
	}
	public int getStartDateYear() {
		return startDateYear;
	}
	public void setStartDateYear(final int startDateYear) {
		this.startDateYear = startDateYear;
	}
	public double getTotalCalExpended() {
		return totalCalExpended;
	}
	public void setTotalCalExpended(final double totalCalExpended) {
		this.totalCalExpended = totalCalExpended;
	}
	public double getTotalCalIntake() {
		return totalCalIntake;
	}
	public void setTotalCalIntake(final double totalCalIntake) {
		this.totalCalIntake = totalCalIntake;
	}

	public double getTotalFatIntake() {
		return totalFatIntake;
	}

	public void setTotalFatIntake(final double totalFatIntake) {
		this.totalFatIntake = totalFatIntake;
	}

	public double getTotalCarbIntake() {
		return totalCarbIntake;
	}

	public void setTotalCarbIntake(final double totalCarbIntake) {
		this.totalCarbIntake = totalCarbIntake;
	}

	public double getTotalProteinIntake() {
		return totalProteinIntake;
	}

	public void setTotalProteinIntake(final double totalProteinIntake) {
		this.totalProteinIntake = totalProteinIntake;
	}

	public double getTotalFiberIntake() {
		return totalFiberIntake;
	}

	public void setTotalFiberIntake(final double totalFiberIntake) {
		this.totalFiberIntake = totalFiberIntake;
	}

	public double getTotalSugarIntake() {
		return totalSugarIntake;
	}

	public void setTotalSugarIntake(final double totalSugarIntake) {
		this.totalSugarIntake = totalSugarIntake;
	}

	public double getTotalSodiumIntake() {
		return totalSodiumIntake;
	}

	public void setTotalSodiumIntake(final double totalSodiumIntake) {
		this.totalSodiumIntake = totalSodiumIntake;
	}

	public double getTotalCalciumIntake() {
		return totalCalciumIntake;
	}

	public void setTotalCalciumIntake(final double totalCalciumIntake) {
		this.totalCalciumIntake = totalCalciumIntake;
	}

	public double getTotalSatfatIntake() {
		return totalSatfatIntake;
	}

	public void setTotalSatfatIntake(final double totalSatfatIntake) {
		this.totalSatfatIntake = totalSatfatIntake;
	}

	public double getTotalCholesterolIntake() {
		return totalCholesterolIntake;
	}

	public void setTotalCholesterolIntake(final double totalCholesterolIntake) {
		this.totalCholesterolIntake = totalCholesterolIntake;
	}
}
