/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.theavocadopapers.apps.kqool.food.Food;
import com.theavocadopapers.apps.kqool.food.Serving;
import com.theavocadopapers.core.logging.Logger;

/**
 * @author sschneider
 *
 */
public class CalorieHour extends AbstractDbObject {




	private static final Class currentClass=CalorieHour.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	private static final NutrientDecimalFormat GENERIC_DOUBLE_FORMAT=new CalorieHour().new NutrientDecimalFormat();
	
	protected static NumberFormat servingsFormat=new DecimalFormat("0.#");

	
	protected int dateYear;
	protected int dateMonth;
	protected int dateDate;
	protected String ingestedLabel="";
	protected double totalIngestedCalories;
	protected String expendedLabel="";
	protected double totalExpendedCalories;
	protected int weekId;
	protected int hour;
	
	// from Serving object (if intakeCalories > 0 only):
	protected double totalIngestedFat;
	protected double totalIngestedCarb;
	protected double totalIngestedProtein;
	protected double totalIngestedFiber;
	protected double totalIngestedSugar;
	protected double totalIngestedSodium;
	protected double totalIngestedCalcium;
	protected double totalIngestedSatfat;
	protected double totalIngestedCholesterol;
	protected double numServings;
	protected String servingName="";


	public CalorieHour() {
		this(null, null, 0);
	}
	
	public CalorieHour(final Food food, final Serving serving, final double numServings) {
		super();
		this.numServings=numServings;
		if (food!=null) {
			this.ingestedLabel=food.getLabel();
		}
		if (serving!=null) {
			this.totalIngestedCalories=serving.getCalories()*numServings;
			this.totalIngestedFat=serving.getFat()*numServings;
			this.totalIngestedCarb=serving.getCarb()*numServings;
			this.totalIngestedProtein=serving.getProtein()*numServings;
			this.totalIngestedFiber=serving.getFiber()*numServings;
			this.totalIngestedSugar=serving.getSugar()*numServings;
			this.totalIngestedSodium=serving.getSodium()*numServings;
			this.totalIngestedCalcium=serving.getCalcium()*numServings;
			this.totalIngestedSatfat=serving.getSatfat()*numServings;
			this.totalIngestedCholesterol=serving.getCholesterol()*numServings;
			this.servingName=serving.getName();
		}
	}
	

	public static CalorieHour getById(final int id) {
		return (CalorieHour)getById(currentClass, id, false);
	}
	


	@Override
	protected Comparable getComparableValue() {
		return new Integer(this.dateYear*365+this.dateMonth*30+this.dateDate);
	}










	public static List getByWeekId(final int weekId)  {	
		return getByField("weekId", weekId, FIELD_TYPE_NUMERIC, currentClass, false);
	} 

	/** Passed an true ingested boolean, returns CalorieHours containing calories-ingested data; passed a false boolean, returns calories-expended
	 * @param week
	 * @param dayIndex
	 * @param ingested
	 * @return
	 */
	public static List getByWeekAndDayIndex(final CalorieWeek week, final int dayIndex, final boolean ingested)  {
		final Calendar weekStartDate=new GregorianCalendar(week.getStartDateYear(), week.getStartDateMonth(), week.getStartDateDate());
		weekStartDate.add(Calendar.DATE, dayIndex);
		return getByWeekIdAndDate(week.getId(), weekStartDate.getTime(), ingested);
	}
	
	/** Passed an true ingested boolean, returns CalorieHours containing calories-ingested data; passed a false boolean, returns calories-expended
	 * @param weekId
	 * @param date
	 * @param ingested
	 * @return
	 */
	public static List getByWeekIdAndDate(final int weekId, final Date date, final boolean ingested)  {	
		final Calendar cal=new GregorianCalendar();
		cal.setTime(date);
		String ingestedCondition;
		if (ingested) {
			ingestedCondition="i.totalIngestedCalories > 0";
		}
		else {
			ingestedCondition="i.totalExpendedCalories > 0";
		}

		//if (ingested) {
			return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i " +
					"where i.weekId = '"+weekId+"' " +
					"and i.dateYear = '"+cal.get(Calendar.YEAR)+"' " +
					"and i.dateMonth='"+cal.get(Calendar.MONTH)+"' " +
					"and i.dateDate='"+cal.get(Calendar.DATE)+"' " +
					"and "+ingestedCondition+"", false)
				;
		/*
		else {
			// return fake, calories-expended objects:
			final CalorieHour fakeHour1=new CalorieHour();
			fakeHour1.setTotalExpendedCalories(192);
			fakeHour1.setExpendedLabel("Chest press machine (3 sets of 12 reps at 130 lbs");
			fakeHour1.setWeekId(weekId);
			fakeHour1.setDateDate(cal.get(Calendar.DATE));
			fakeHour1.setDateMonth(cal.get(Calendar.MONTH));
			fakeHour1.setDateYear(cal.get(Calendar.YEAR));
			
			final CalorieHour fakeHour2=new CalorieHour();
			fakeHour2.setTotalExpendedCalories(98);
			fakeHour2.setExpendedLabel("Shoulder press (3 sets of 12 reps at 140 lbs");
			fakeHour2.setWeekId(weekId);
			fakeHour2.setDateDate(cal.get(Calendar.DATE));
			fakeHour2.setDateMonth(cal.get(Calendar.MONTH));
			fakeHour2.setDateYear(cal.get(Calendar.YEAR));

			final CalorieHour fakeHour3=new CalorieHour();
			fakeHour3.setTotalExpendedCalories(202);
			fakeHour3.setExpendedLabel("Leg extensions (4 sets of 10 reps at 290 lbs");
			fakeHour3.setWeekId(weekId);
			fakeHour3.setDateDate(cal.get(Calendar.DATE));
			fakeHour3.setDateMonth(cal.get(Calendar.MONTH));
			fakeHour3.setDateYear(cal.get(Calendar.YEAR));

			final List ret=new ArrayList();
			ret.add(fakeHour1);
			ret.add(fakeHour2);
			ret.add(fakeHour3);
			return ret;
		}
		*/
	} 
	


	/**
	 * @param hour
	 * @param date
	 * @param weekId
	 * @param createIfNotFound
	 * @return
	 * @deprecated Because CalorieHours no longer correspond to actual hours.
	 */
	@Deprecated
	public static CalorieHour getByWeekIdAndDateAndHour(final int hour, final Date date, final int weekId, final boolean createIfNotFound)  {	
		final Calendar cal=new GregorianCalendar();
		cal.setTime(date);

		final List hoursList=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.hour='"+hour+"' and i.weekId = '"+weekId+"' and i.dateYear = '"+cal.get(Calendar.YEAR)+"' and i.dateMonth='"+cal.get(Calendar.MONTH)+"' and i.dateDate='"+cal.get(Calendar.DATE)+"'", false);

		if (hoursList==null || hoursList.size()==0) {
			if (createIfNotFound) {
				final CalorieHour calorieHour=new CalorieHour();
				final Calendar now=new GregorianCalendar();
				calorieHour.setDateYear(now.get(Calendar.YEAR));
				calorieHour.setDateMonth(now.get(Calendar.MONTH));
				calorieHour.setDateDate(now.get(Calendar.DATE));
				calorieHour.setHour(hour);
				calorieHour.setWeekId(weekId);
				calorieHour.setExpendedLabel("");
				calorieHour.setIngestedLabel("");
				calorieHour.setServingName("");
				calorieHour.store();
			}
			else {
				return null;
			}
		}
		return (CalorieHour)hoursList.get(0);

	} 
	

	/**
	 * @param calorieHours
	 * @return
	 * @deprecated CalorieHours no longer represent actual hours in a day, so this method is not needed
	 */
	@Deprecated
	public static Map getHourIntsToCalorieHours(final List calorieHours) {
		return getHourIntsToCalorieHours(calorieHours, false, null, -1);
	}
	
	/**
	 * @param calorieHours
	 * @param fillInBlankHours
	 * @param week
	 * @param dayIndex
	 * @return
	 * @deprecated CalorieHours no longer represent actual hours in a day, so this method is not needed
	 */
	@Deprecated
	public static Map getHourIntsToCalorieHours(final List calorieHours, final boolean fillInBlankHours, final CalorieWeek week, final int dayIndex) {
		final Map map=new HashMap(24);
		final int numHours=calorieHours.size();
		CalorieHour hour;
		for (int i=0; i<numHours; i++) {
			hour=(CalorieHour)calorieHours.get(i);
			map.put(new Integer(hour.getHour()), hour);
		}
		if (fillInBlankHours) {
			final Calendar cal=new GregorianCalendar(week.getStartDateYear(), week.getStartDateMonth(), week.getStartDateDate());
			cal.add(Calendar.DATE, dayIndex);
			final int y=cal.get(Calendar.YEAR);
			final int m=cal.get(Calendar.MONTH);
			final int d=cal.get(Calendar.DATE);
			int newId=-1;
			for (int i=0; i<24; i++) {
				if (map.get(new Integer(i))==null) {
					hour=new CalorieHour();
					hour.setDateYear(y);
					hour.setDateMonth(m);
					hour.setDateDate(d);
					hour.setHour(i);
					hour.setWeekId(week.getId());
					hour.publicSetId(newId);
					map.put(new Integer(i), hour);
					newId--;
				}
			}
		}
		return map;
	}

	
	public static List getAll() {
		return getAll(currentClass);
	}
	
	public static void deleteById(final int id) {
		deleteById(currentClass, id);
	}
		

	
	
	
	public String getIngestedLabel() {
		return ingestedLabel;
	}
	
	public void setIngestedLabel(final String intakeComments) {
		this.ingestedLabel = intakeComments;
	}

	public int getWeekId() {
		return weekId;
	}
	
	public void setWeekId(final int weekId) {
		this.weekId = weekId;
	}
	
	public double getTotalIngestedCalories() {
		return totalIngestedCalories;
	}
	
	public void setTotalIngestedCalories(final double intakeCalories) {
		this.totalIngestedCalories = intakeCalories;
	}
	
	public double getTotalExpendedCalories() {
		return totalExpendedCalories;
	}
	
	public void setTotalExpendedCalories(final double expendedCalories) {
		this.totalExpendedCalories = expendedCalories;
	}
	public String getExpendedLabel() {
		return expendedLabel;
	}
	
	public void setExpendedLabel(final String expendedComments) {
		this.expendedLabel = expendedComments;
	}
	
	public int getHour() {
		return hour;
	}
	
	public void setHour(final int hour) {
		this.hour = hour;
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

	public double getTotalIngestedFat() {
		return totalIngestedFat;
	}

	public void setTotalIngestedFat(final double fat) {
		this.totalIngestedFat = fat;
	}

	public double getTotalIngestedCarb() {
		return totalIngestedCarb;
	}

	public void setTotalIngestedCarb(final double carb) {
		this.totalIngestedCarb = carb;
	}

	public double getTotalIngestedProtein() {
		return totalIngestedProtein;
	}

	public void setTotalIngestedProtein(final double protein) {
		this.totalIngestedProtein = protein;
	}

	public double getTotalIngestedFiber() {
		return totalIngestedFiber;
	}

	public void setTotalIngestedFiber(final double fiber) {
		this.totalIngestedFiber = fiber;
	}

	public double getTotalIngestedSugar() {
		return totalIngestedSugar;
	}

	public void setTotalIngestedSugar(final double sugar) {
		this.totalIngestedSugar = sugar;
	}

	public double getTotalIngestedSodium() {
		return totalIngestedSodium;
	}

	public void setTotalIngestedSodium(final double sodium) {
		this.totalIngestedSodium = sodium;
	}

	public double getTotalIngestedCalcium() {
		return totalIngestedCalcium;
	}

	public void setTotalIngestedCalcium(final double calcium) {
		this.totalIngestedCalcium = calcium;
	}

	public double getTotalIngestedSatfat() {
		return totalIngestedSatfat;
	}

	public void setTotalIngestedSatfat(final double satfat) {
		this.totalIngestedSatfat = satfat;
	}

	public double getTotalIngestedCholesterol() {
		return totalIngestedCholesterol;
	}

	public void setTotalIngestedCholesterol(final double cholesterol) {
		this.totalIngestedCholesterol = cholesterol;
	}
	
	public double getNumServings() {
		return numServings;
	}

	public void setNumServings(final double numServings) {
		this.numServings = numServings;
	}

	public String getServingName() {
		return servingName;
	}

	public void setServingName(final String servingName) {
		this.servingName = servingName;
	}	
	
	
	
	@Override
	public String toString() {
		final StringBuffer b=new StringBuffer(255);
		final Calendar cal=new GregorianCalendar(this.getDateYear(), this.getDateMonth(), this.getDateDate(), this.getHour(), 0);
		b.append("id="+this.getId()+"; date="+cal.getTime()+"; totalIngestedCalories="+this.totalIngestedCalories+"; expendedCalories="+this.totalExpendedCalories+"; weekId="+this.weekId+"\r\n");
		return b.toString();
	}
	
	public StringBuilder toJSON() {
		final StringBuilder b=new StringBuilder(512);
		b.append('{');
		b.append("\"id\": \""+getId()+"\",");
		b.append("\"dateYear\": \""+getDateYear()+"\",");
		b.append("\"dateMonth\": \""+getDateMonth()+"\",");
		b.append("\"dateDate\": \""+getDateDate()+"\",");
		b.append("\"ingestedLabel\": \""+formatStringForJSON(getIngestedLabel())+"\",");
		b.append("\"totalIngestedCalories\": \""+getTotalIngestedCalories()+"\",");
		b.append("\"expendedLabel\": \""+formatStringForJSON(getExpendedLabel())+"\",");
		b.append("\"totalExpendedCalories\": \""+getTotalExpendedCalories()+"\",");
		b.append("\"weekId\": \""+getWeekId()+"\",");
		b.append("\"hour\": \""+getHour()+"\",");
		b.append("\"totalIngestedFat\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedFat(), "?")+"\",");
		b.append("\"totalIngestedCarb\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedCarb(), "?")+"\",");
		b.append("\"totalIngestedProtein\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedProtein(), "?")+"\",");
		b.append("\"totalIngestedFiber\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedFiber(), "?")+"\",");
		b.append("\"totalIngestedSugar\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedSugar(), "?")+"\",");
		b.append("\"totalIngestedSodium\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedSodium(), "?")+"\",");
		b.append("\"totalIngestedCalcium\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedCalcium(), "?")+"\",");
		b.append("\"totalIngestedSatfat\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedSatfat(), "?")+"\",");
		b.append("\"totalIngestedCholesterol\": \""+GENERIC_DOUBLE_FORMAT.format(getTotalIngestedCholesterol(), "?")+"\",");
		b.append("\"numServings\": \""+GENERIC_DOUBLE_FORMAT.format(getNumServings(), "?")+"\",");
		b.append("\"servingName\": \""+formatStringForJSON(getServingName())+"\"");
		b.append('}');
		return b;
	}
	
	private String formatStringForJSON(final String s) {
		return (s==null?null:s.replaceAll("\"", "&quot;").replaceAll("'", "\\'"));
	}

	@SuppressWarnings("serial")
	public class NutrientDecimalFormat extends DecimalFormat {

		public NutrientDecimalFormat() {
			super("0.##");
		}

		public String format(final double n, final String strIfNegative) {
			if (n<0) {
				return strIfNegative;
			}
			return super.format(n);
		}
	}



}
