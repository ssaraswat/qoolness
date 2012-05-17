/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.SessionWrapper;

/**
 * @author sschneider
 *
 */
public class Exercise extends AbstractDbObject {

	
	private static final Class currentClass=Exercise.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);
	
	private static final int SITE_ID_ALL_SITES_FLAG=-1;

	public static final int STATUS_ACTIVE=1;
	public static final int STATUS_INACTIVE=2;
	
	public static final int DEFAULT_MALE_WEIGHT=170;
	public static final int DEFAULT_FEMALE_WEIGHT=140;
	public static final int BASE_WEIGHT_FOR_CAL_CALCULATIONS=170;
	
	public static final String CAL_CALC_METHOD_UNSPECIFIED="UNSPECIFIED";
	public static final String CAL_CALC_METHOD_NOT_APPLICABLE="NOT_APPLICABLE";
	public static final String CAL_CALC_METHOD_LAP_X_SPEED_FACTOR="LAP_X_SPEED_FACTOR";
	public static final String CAL_CALC_METHOD_MILE_X_SPEED_FACTOR="MILE_X_SPEED_FACTOR";
	public static final String CAL_CALC_METHOD_MINUTE_X_LEVEL_FACTOR="MINUTE_X_LEVEL_FACTOR";
	public static final String CAL_CALC_METHOD_MINUTE="MINUTE";
	public static final String CAL_CALC_METHOD_REP_X_POUND="REP_X_POUND";
	public static final String CAL_CALC_METHOD_REP="REP";
	public static final String CAL_CALC_METHOD_REP_X_SPEED_FACTOR="REP_X_SPEED_FACTOR";

	public static final String CAL_CALC_LABEL_UNSPECIFIED="[Unknown]";
	public static final String CAL_CALC_LABEL_NOT_APPLICABLE="[Not applicable]";
	public static final String CAL_CALC_LABEL_LAP_X_SPEED_FACTOR="Calories per lap at normal speed";
	public static final String CAL_CALC_LABEL_MILE_X_SPEED_FACTOR="Calories per mile at normal speed";
	public static final String CAL_CALC_LABEL_MINUTE_X_LEVEL_FACTOR="Calories per minute at normal level";
	public static final String CAL_CALC_LABEL_MINUTE="Calories per minute";
	public static final String CAL_CALC_LABEL_REP_X_POUND="Calories per rep per pound";
	public static final String CAL_CALC_LABEL_REP="Calories per rep";
	public static final String CAL_CALC_LABEL_REP_X_SPEED_FACTOR="Calories per rep at normal speed";


	public static Map<String,String> calCalcMethodsToLabels;
	public static Map<String,String> qtyIntensityToCalCalcMethods;
	
	static {
		calCalcMethodsToLabels=new LinkedHashMap<String,String>(20);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_UNSPECIFIED, CAL_CALC_LABEL_UNSPECIFIED);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_NOT_APPLICABLE, CAL_CALC_LABEL_NOT_APPLICABLE);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_LAP_X_SPEED_FACTOR, CAL_CALC_LABEL_LAP_X_SPEED_FACTOR);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_MILE_X_SPEED_FACTOR, CAL_CALC_LABEL_MILE_X_SPEED_FACTOR);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_MINUTE_X_LEVEL_FACTOR, CAL_CALC_LABEL_MINUTE_X_LEVEL_FACTOR);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_MINUTE, CAL_CALC_LABEL_MINUTE);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_REP_X_POUND, CAL_CALC_LABEL_REP_X_POUND);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_REP, CAL_CALC_LABEL_REP);
		calCalcMethodsToLabels.put(CAL_CALC_METHOD_REP_X_SPEED_FACTOR, CAL_CALC_LABEL_REP_X_SPEED_FACTOR);
		
		qtyIntensityToCalCalcMethods=new LinkedHashMap<String,String>(20);
		qtyIntensityToCalCalcMethods.put("LAP_SPEED", CAL_CALC_METHOD_LAP_X_SPEED_FACTOR);
		qtyIntensityToCalCalcMethods.put("MILE_SPEED", CAL_CALC_METHOD_MILE_X_SPEED_FACTOR);
		qtyIntensityToCalCalcMethods.put("MINUTE_LEVEL", CAL_CALC_METHOD_MINUTE_X_LEVEL_FACTOR);
		qtyIntensityToCalCalcMethods.put("MINUTE_NA", CAL_CALC_METHOD_MINUTE);
		qtyIntensityToCalCalcMethods.put("NA_NA", CAL_CALC_METHOD_NOT_APPLICABLE);
		qtyIntensityToCalCalcMethods.put("SET_NA", CAL_CALC_METHOD_REP);
		qtyIntensityToCalCalcMethods.put("SET_POUND", CAL_CALC_METHOD_REP_X_POUND);
		qtyIntensityToCalCalcMethods.put("SET_SPEED", CAL_CALC_METHOD_REP_X_SPEED_FACTOR);
	}

	protected String name;
	protected String quantityMeasure;
	protected String intensityMeasure;
	protected int status=STATUS_ACTIVE;
	protected String description;
	protected String category;
	protected int exerciseVideoId;
	protected int maxLevel; // the highest level this machine goes, for exercises where the intensity is LEVEL (otherwise field is ignored)
	private double calorieFactor; // used to calculate calories expended (in combination with the *measure values and client's weight; see ExcerciseDetail.getCaloriesExpended() for use.
	private String calorieCalculationMethod;
	private int siteId=SITE_ID_ALL_SITES_FLAG;


	
	public static String getCalorieCalculationMethod(final Exercise exercise) {
		if (exercise==null) {
			return null;
		}
		if (exercise.getQuantityMeasure().equals("LAP") && exercise.getIntensityMeasure().equals("SPEED")) {
			return CAL_CALC_METHOD_LAP_X_SPEED_FACTOR;
		}
		if (exercise.getQuantityMeasure().equals("MILE") && exercise.getIntensityMeasure().equals("SPEED")) {
			return CAL_CALC_METHOD_MILE_X_SPEED_FACTOR;
		}
		if (exercise.getQuantityMeasure().equals("MINUTE") && exercise.getIntensityMeasure().equals("LEVEL")) {
			return CAL_CALC_METHOD_MINUTE_X_LEVEL_FACTOR;
		}
		if (exercise.getQuantityMeasure().equals("MINUTE") && exercise.getIntensityMeasure().equals("NA")) {
			return CAL_CALC_METHOD_MINUTE;
		}
		if (exercise.getQuantityMeasure().equals("SET") && exercise.getIntensityMeasure().equals("NA")) {
			return CAL_CALC_METHOD_REP;
		}
		if (exercise.getQuantityMeasure().equals("SET") && exercise.getIntensityMeasure().equals("POUND")) {
			return CAL_CALC_METHOD_REP_X_POUND;
		}
		if (exercise.getQuantityMeasure().equals("SET") && exercise.getIntensityMeasure().equals("SPEED")) {
			return CAL_CALC_METHOD_REP_X_SPEED_FACTOR;
		}
		return CAL_CALC_METHOD_UNSPECIFIED;
	}
	
	public static Exercise getById(final int id) {
		return getById(id, new SessionWrapper());
	}
	public static Exercise getById(final int id, final SessionWrapper sessionWrapper) {
		return (Exercise)getById(currentClass, id, true, sessionWrapper);
	}
	

	

	@Override
	protected Comparable getComparableValue() {
		return name;
	}







	public static boolean exists(final String name) {
		return getByName(name)!=null;
	}
	



	public static Exercise getByName(final String name) {
		return (Exercise)getUniqueByField("name", name, FIELD_TYPE_TEXTUAL, currentClass, true);
	}
	
	public static Map getAllAsMap() {
		return getAllAsMap(currentClass);
	}
	
	public static List getByCategory(final String category, final boolean withVideosOnly) {
		return getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.category = '"+category+"'"+(withVideosOnly?" and i.exerciseVideoId > 0":""), true);
	}
	
	public static List getAll() {
		return getAll(new SessionWrapper());
	}
	
	public static List getAll(final SessionWrapper sessionWrapper) {
		return getAll(currentClass, sessionWrapper);
	}
		
	public static double calculateProjectedCaloriesExpended(final int exerciseId, final double currentClientWeight, final double intensity, final double quantity, final int reps) {
		final List<Integer> exerciseIds=new LinkedList<Integer>();
		exerciseIds.add(exerciseId);
		final List<Double> currentClientWeights=new LinkedList<Double>();
		currentClientWeights.add(currentClientWeight);
		final List<Double> intensities=new LinkedList<Double>();
		intensities.add(intensity);
		final List<Double> quantities=new LinkedList<Double>();
		quantities.add(quantity);
		final List<Integer> repses=new LinkedList<Integer>();
		repses.add(reps);
		return calculateProjectedCaloriesExpended(exerciseIds, currentClientWeights, intensities, quantities, repses).get(0);
	}

	
	public static List<Double> calculateProjectedCaloriesExpended(final List<Integer> exerciseIds, final List<Double> currentClientWeights, final List<Double> intensities, final List<Double> quantities, final List<Integer> repses) {
		final List exercises=getByIds(currentClass, exerciseIds, false);
		final List<Double> calorieDoubles=new LinkedList<Double>();
		int i=0;
		ExerciseDetail exerciseDetail;
		double cals;
		for (final Object exercise: exercises) {
			exerciseDetail=new ExerciseDetail();
			exerciseDetail.setCurrentUserWeight(currentClientWeights.get(i));
			exerciseDetail.setExerciseId(((Exercise)exercise).getId());
			exerciseDetail.setIntensity(intensities.get(i));
			exerciseDetail.setQuantity(quantities.get(i));
			exerciseDetail.setReps(repses.get(i));
			try {
				cals=exerciseDetail.calculateCaloriesExpended((Exercise)exercise);
			}
			catch (final RuntimeException e) {
				cals=-1.0;
				logger.error("Exception calculating calories in calculateProjectedCaloriesExpended() swallowing and returning -1.0 (exerciseId "+((Exercise)exercise).getId()+")", e); 
			}
			calorieDoubles.add(cals);
			i++;
		}


		return calorieDoubles;
	}
	
	
	public String getDescription() {
		return description;
	}
	public void setDescription(final String description) {
		this.description = description;
	}
	public String getIntensityMeasure() {
		return intensityMeasure;
	}
	public void setIntensityMeasure(final String intensityMeasure) {
		this.intensityMeasure = intensityMeasure;
	}
	public String getName() {
		return name;
	}
	public void setName(final String name) {
		this.name = name;
	}
	public String getQuantityMeasure() {
		return quantityMeasure;
	}
	public void setQuantityMeasure(final String quantityMeasure) {
		this.quantityMeasure = quantityMeasure;
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
	 * @return Returns the category.
	 */
	public String getCategory() {
		return category;
	}
	/**
	 * @param category The category to set.
	 */
	public void setCategory(final String category) {
		this.category = category;
	}




	public int getExerciseVideoId() {
		return exerciseVideoId;
	}




	public void setExerciseVideoId(final int exerciseVideoId) {
		this.exerciseVideoId = exerciseVideoId;
	}




	public void setCalorieFactor(final double calorieFactor) {
		this.calorieFactor = calorieFactor;
	}




	public double getCalorieFactor() {
		return calorieFactor;
	}




	public String getCalorieCalculationMethod() {
		return calorieCalculationMethod;
	}




	public void setCalorieCalculationMethod(final String calorieCalculationMethod) {
		this.calorieCalculationMethod = calorieCalculationMethod;
	}

	public int getMaxLevel() {
		return maxLevel;
	}

	public void setMaxLevel(final int maxLevel) {
		this.maxLevel = maxLevel;
	}

	public int getSiteId() {
		return siteId;
	}

	public void setSiteId(final int siteId) {
		this.siteId = siteId;
	}
	




}
