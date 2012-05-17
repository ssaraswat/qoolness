/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.exception.ConstraintViolationException;

import com.theavocadopapers.apps.kqool.entity.staticdata.ExerciseIntensityMeasure;
import com.theavocadopapers.apps.kqool.entity.staticdata.ExerciseQuantityMeasure;
import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.SessionWrapper;


/**
 * @author sschneider
 *
 */
public class ExerciseDetail extends AbstractDbObject {
	
	public static final String[] SPEED_LABELS={"","very low","low","moderate","high","max"};


	private static final Class currentClass=ExerciseDetail.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);
	
	public static final int DEFAULT_REST_INTERVAL=180;
	
	public static final DateFormat YEAR_DATE_FORMAT=new SimpleDateFormat("yyyy");
	public static final DateFormat MONTH_DATE_FORMAT=new SimpleDateFormat("M");
	public static final DateFormat DATE_DATE_FORMAT=new SimpleDateFormat("d");
	
	public static final NumberFormat DECIMAL_FORMAT_OPTIONAL_FRACTIONS=new DecimalFormat("0.##");

	protected static boolean measureMapsInitialized=false;
	protected static List intensityMeasuresList=null;
	protected static List quantityMeasuresList=null;
	protected static Map intensityCodesToNamesMap=null;
	protected static Map quantityCodesToNamesMap=null;

	


	protected int exerciseId;
	protected int workoutId;
	protected double quantity;
	protected double intensity;
	protected int reps;
	protected int index;
	protected int supersetGroup;
	protected int restInterval=DEFAULT_REST_INTERVAL;
	protected String comments;
	protected int calorieHourId; // will be zero for pre-cal-counter ED's
	protected double currentUserWeight;
	protected Exercise exercise;



	public static ExerciseDetail getById(final int id) {
		final SessionWrapper sessionWrapper=SessionWrapper.openIfNotOpen(null);
		try {
			final ExerciseDetail exerciseDetail=(ExerciseDetail)getById(currentClass, id, false, sessionWrapper);
			if (exerciseDetail!=null) {
				exerciseDetail.setExercise(Exercise.getById(exerciseDetail.getExerciseId(), sessionWrapper));
			}
			return exerciseDetail;
		}
		finally {
			SessionWrapper.closeIfNotNested(sessionWrapper);
		}
	}
	

	
    public boolean sameAs(final ExerciseDetail ed) {
        if (ed.getExerciseId()!=this.getExerciseId()) {
            return false;
        }
        if (ed.getCalorieHourId()!=this.getExerciseId()) {
            return false;
        }
        if (ed.getWorkoutId()!=this.getWorkoutId()) {
            return false;
        }
        if (ed.getQuantity()!=this.getQuantity()) {
            return false;
        }
        if (ed.getIntensity()!=this.getIntensity()) {
            return false;
        }
        if (ed.getReps()!=this.getReps()) {
            return false;
        }
        if (ed.getIndex()!=this.getIndex()) {
            return false;
        }
        if (ed.getSupersetGroup()!=this.getSupersetGroup()) {
            return false;
        }    
        if (ed.getRestInterval()!=this.getRestInterval()) {
            return false;
        }
       if (!ed.getComments().equals(this.getComments())) {
            return false;
        }
        return true;
    }
    
    

	@Override
	protected Comparable getComparableValue() {
		return new Integer(index);
	}








    /**
     * @return Returns the exerciseId.
     */
    public int getExerciseId() {
        return exerciseId;
    }
    /**
     * @param exerciseId The exerciseId to set.
     */
    public void setExerciseId(final int exerciseId) {
        this.exerciseId=exerciseId;
    }
    /**
     * @return Returns the index.
     */
    public int getIndex() {
        return index;
    }
    /**
     * @param index The index to set.
     */
    public void setIndex(final int index) {
        this.index=index;
    }
    /**
     * @return Returns the intensity.
     */
    public double getIntensity() {
        return intensity;
    }
    /**
     * @param intensity The intensity to set.
     */
    public void setIntensity(final double intensity) {
        this.intensity=intensity;
    }
    /**
     * @return Returns the quantity.
     */
    public double getQuantity() {
        return quantity;
    }
    /**
     * @param quantity The quantity to set.
     */
    public void setQuantity(final double quantity) {
        this.quantity=quantity;
    }
    /**
     * @return Returns the reps.
     */
    public int getReps() {
        return reps;
    }
    /**
     * @param reps The reps to set.
     */
    public void setReps(final int reps) {
        this.reps=reps;
    }
    /**
     * @return Returns the supersetGroup.
     */
    public int getSupersetGroup() {
        return supersetGroup;
    }
    /**
     * @param supersetGroup The supersetGroup to set.
     */
    public void setSupersetGroup(final int supersetGroup) {
        this.supersetGroup=supersetGroup;
    }
    /**
     * @return Returns the workoutId.
     */
    public int getWorkoutId() {
        return workoutId;
    }
    /**
     * @param workoutId The workoutId to set.
     */
    public void setWorkoutId(final int workoutId) {
        this.workoutId=workoutId;
    }
    /**
     * @return Returns the comments.
     */
    public String getComments() {
        return comments;
    }
    /**
     * @param comments The comments to set.
     */
    public void setComments(final String comments) {
        this.comments=comments;
    }

    
	public int getRestInterval() {
		return restInterval;
	}

	public void setRestInterval(final int restInterval) {
		this.restInterval = restInterval;
	}
    

    
    
    
    
    
    
    
    
    
	public int getCalorieHourId() {
		return calorieHourId;
	}



	public void setCalorieHourId(final int calorieHourId) {
		this.calorieHourId = calorieHourId;
	}



	public double getCurrentUserWeight() {
		return currentUserWeight;
	}



	public void setCurrentUserWeight(final double currentUserWeight) {
		this.currentUserWeight = currentUserWeight;
	}



	public Exercise getExercise() {
		return exercise;
	}



	public void setExercise(final Exercise exercise) {
		this.exercise = exercise;
	}

	public static List getByWorkoutId(final int workoutId) {
		return getByWorkoutId(workoutId, new SessionWrapper());
	}

	protected static List getByWorkoutId(final int workoutId, final SessionWrapper sessionWrapper) {
		return getByField("workoutId", workoutId, FIELD_TYPE_NUMERIC, currentClass, false, sessionWrapper);
	}
	
	
	public static List getAll() {
		return getAll(currentClass);
	}
		

	
   


    public static void loadExerciseDetailsInto(final Workout workout)  {
		final List exerciseDetails=getByWorkoutId(workout.getId());
		if (exerciseDetails!=null) {
	        Collections.sort(exerciseDetails); // sort by index
	        workout.setExerciseDetails(exerciseDetails);
		}
		else {
			workout.setExerciseDetails(new ArrayList(0));
		} 
    }
     

    	
    /** This stores (or deletes as needed) all ED's in a Workout; it also upserts/deletes CalorieHours as needed.
     * @param workout
     */
    public static void storeExerciseDetailsFrom(final Workout workout, final User user, final double currentUserWeight, final Map exerciseIdsToExercises)  {
    	SessionWrapper sessionWrapper=SessionWrapper.openIfNotOpen(null);
    	try {
    		logger.debug ("Kishore Entering");
	    	CalorieWeek calorieWeek=null;
	    	boolean recordCalories=false;
	    	int dateDate=-1;
	    	int dateMonth=-1;
	    	int dateYear=-1;
	    	double totalCalorieWeekCalories=0.0; // may end up being positive or negative
	    	if (!workout.isPrescriptive()) {
	        	calorieWeek=CalorieWeek.getByUserIdAndDate(user.getId(), workout.getPerformedDate(), true, sessionWrapper);
	        	dateYear=Integer.parseInt(YEAR_DATE_FORMAT.format(workout.getPerformedDate()));
	        	dateMonth=Integer.parseInt(MONTH_DATE_FORMAT.format(workout.getPerformedDate()))-1;
	        	dateDate=Integer.parseInt(DATE_DATE_FORMAT.format(workout.getPerformedDate()));
	        	recordCalories=true;
	    	}
	    	List existingList=getByWorkoutId(workout.getId(), sessionWrapper);
	        existingList=(existingList==null?new ArrayList():existingList);
	        List newList=workout.getExerciseDetails();
	        newList=(newList==null?new ArrayList():newList);
	        validListCheck(newList);
	        setWorkoutIds(newList, workout.getId());
	
	        // first, delete from the db ExerciseDetails that were associated with this workout but which are not on the newList:
	        for (int i=0; i<existingList.size(); i++) {
	            final ExerciseDetail exerciseDetail=(ExerciseDetail)existingList.get(i);
	            boolean delete=true;
	            for (int j=0; j<newList.size(); j++) {
	            	logger.debug("Kishore 2");
	                final ExerciseDetail newExerciseDetail=(ExerciseDetail)newList.get(i);
	                if (exerciseDetail.getId()>0 && exerciseDetail.getId()==newExerciseDetail.getId()) {
	                    delete=false;
	                    break;
	                }
	            }
	            if (delete) {
	            	final int calorieHourId=exerciseDetail.getCalorieHourId();
	            	logger.debug("Kishore 3 ExeciseDetail ID " + exerciseDetail.getId());
	            	sessionWrapper.flush();
	            	sessionWrapper.close();
	            	
	            	sessionWrapper=SessionWrapper.openIfNotOpen(null);
	            	
	            	ExerciseDetail.deleteById(currentClass, exerciseDetail.getId(), sessionWrapper);
	                if (recordCalories) {
	                	CalorieHour calorieHour=null;
	                	if (calorieHourId>0) {
	                		calorieHour=(CalorieHour)getById(currentClass, calorieHourId, false, sessionWrapper);
	                		totalCalorieWeekCalories-=calorieHour.getTotalExpendedCalories();
	                		deleteById(currentClass, calorieHourId, sessionWrapper);
	                		logger.debug("Kishore 1 ExeciseDetail ID " + calorieHourId);
	                	}
	                }
	            }
	        }
	        // everything in newList we're updating or inserting; FIRST, update the objects already in the db:
	        for (int i=0; i<newList.size(); i++) {
	            final ExerciseDetail exerciseDetail=(ExerciseDetail)newList.get(i);
	            if (exerciseDetail.getId()>0) {
	                if (recordCalories) {
	                	CalorieHour calorieHour=null;
	                	if (exerciseDetail.getCalorieHourId()>0) {
	                		calorieHour=(CalorieHour)getById(currentClass, exerciseDetail.getCalorieHourId(), false, sessionWrapper);
	                	}
	                	if (calorieHour==null) {
	                		calorieHour=new CalorieHour();
	                		calorieHour.setDateYear(dateYear);
	                		calorieHour.setDateMonth(dateMonth);
	                		calorieHour.setDateDate(dateDate);
	                		calorieHour.setWeekId(calorieWeek.getId()); 
	                	}
	            		final Exercise exercise=(Exercise)exerciseIdsToExercises.get(exerciseDetail.getExerciseId());
	            		final double caloriesExpended=exerciseDetail.calculateCaloriesExpended(exercise);
	            		calorieHour.setExpendedLabel(getCaloriesExpendedLabel(exerciseDetail, exercise));
	            		calorieHour.setTotalExpendedCalories(caloriesExpended);
	            		final int calorieHourId=calorieHour.store(sessionWrapper);
	            		exerciseDetail.setCalorieHourId(calorieHourId);
	            		totalCalorieWeekCalories+=caloriesExpended;
	                }
	                logger.debug("Kishore 5");
	                exerciseDetail.store(sessionWrapper);
	            }
	        }
	        // SECOND, insert the objects not yet in the db:
	        for (int i=0; i<newList.size(); i++) {
	            final ExerciseDetail exerciseDetail=(ExerciseDetail)newList.get(i);
	            if (exerciseDetail.getId()==0) {
	            	exerciseDetail.currentUserWeight=currentUserWeight;
	                if (recordCalories) {
	            		final Exercise exercise=(Exercise)exerciseIdsToExercises.get(exerciseDetail.getExerciseId());
	            		final double caloriesExpended=exerciseDetail.calculateCaloriesExpended(exercise);
	                	final CalorieHour calorieHour=new CalorieHour();
	            		calorieHour.setDateYear(dateYear);
	            		calorieHour.setDateMonth(dateMonth);
	            		calorieHour.setDateDate(dateDate);
	            		calorieHour.setWeekId(calorieWeek.getId());            		
	            		calorieHour.setExpendedLabel(getCaloriesExpendedLabel(exerciseDetail, exercise));
	            		calorieHour.setTotalExpendedCalories(caloriesExpended);
	            		final int calorieHourId=calorieHour.store(sessionWrapper);
	            		exerciseDetail.setCalorieHourId(calorieHourId);
	            		totalCalorieWeekCalories+=caloriesExpended;
	                }
	                logger.debug ("Kishore 7");
	                exerciseDetail.store(sessionWrapper);
	            }
	        }
	        
	        if (recordCalories) {
	        	// note that we may be increasing or decreasing this value depending on whether 
	        	// totalCalorieWeekCalories is positive or negative:
	        	calorieWeek.setTotalCalExpended(calorieWeek.getTotalCalExpended()+totalCalorieWeekCalories);
	        	calorieWeek.store(sessionWrapper);
	        }
    	}
    	
    	catch (Exception e) {
    		System.out.println("Hello 111");
    		e.printStackTrace();
    		logger.debug ("Caught Exception");
    	}
    	finally {
    		System.out.println("Hello 222");
    		SessionWrapper.closeIfNotNested(sessionWrapper);
    	}

    }

    


    @Override
	public int store() {
		return storeWithUniqueIndices(null);
	}



	@Override
	protected int store(final SessionWrapper session) {
		return storeWithUniqueIndices(session);
	}


	// hackery: we do this because when we edit existing workouts, sometimes
	// bad stuff happens without this:
	private int storeWithUniqueIndices(final SessionWrapper session) {
		int id=0;
		while (id==0) {
			try {
				id=super.store(session);
			}
			catch (final ConstraintViolationException e) {
				this.index++;
			}
			catch (final RuntimeException e) {
				throw e;
			}
		}
		return id;
	}



	public synchronized double calculateCaloriesExpended(final Exercise exercise) {
		if (!measureMapsInitialized) {
			initializeMeasureMaps();
		}
		double baseCaloriesExpended;
		
		double intensity=this.getIntensity();
		//logger.debug(">>>>>>>>>>> in calculateCaloriesExpended(): exercise.getCalorieCalculationMethod()="+exercise.getCalorieCalculationMethod());
    	if (
    			exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_LAP_X_SPEED_FACTOR) || 
    			exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_MILE_X_SPEED_FACTOR) ||
    			exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_MINUTE_X_LEVEL_FACTOR)
    		) {
    		// calculation is the same when intensity measure is SPEED or LEVEL regardless of what quantity measure is:
    		// only diff with LEVEL is that unlike speed, where we know the average SPEED, we have to calculate the average LEVEL:
    		double averageSpeedOrLevel;
    		if (exercise.getIntensityMeasure().equals("SPEED")) {
    			intensity/=10; // we store intensities *10 for speed (10, 20, 30, 40, 50) so we can add more speed "notches" if needed.
    			averageSpeedOrLevel=3;
    		}
    		else {
    			averageSpeedOrLevel=exercise.getMaxLevel()/2;
    		}
    		final double speedOrLevelFactor=intensity/averageSpeedOrLevel;
    		// number of laps or miles or minutes times calorie factor adjusted for speed/level:
    		baseCaloriesExpended=this.getQuantity()*exercise.getCalorieFactor()*speedOrLevelFactor;
    		//logger.debug(">>>>>>>>>>> in calculateCaloriesExpended(): this.getQuantity()*exercise.getCalorieFactor()="+this.getQuantity()*exercise.getCalorieFactor()+"; speedOrLevelFactor="+speedOrLevelFactor);
    	}
    	else if (
    			exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_MINUTE) || 
    			exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_REP)
    		) {
    		// calculation is the same when quantity measure is MINUTE OR REP if intensity is NA, except if it's reps we need to multiply by quantity:
    		int quantity;
    		if (exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_REP)) {
    			quantity=(int)(this.getQuantity()*this.getReps());
    		}
    		else {
    			quantity=(int) this.getQuantity();
    		}
    		baseCaloriesExpended=quantity*exercise.getCalorieFactor();
    		//logger.debug(">>>>>>>>>>> in calculateCaloriesExpended(): quantity="+quantity+"; exercise.getCalorieFactor()="+exercise.getCalorieFactor());
    	}
    	else if (exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_REP_X_POUND)) {
    		// reps per set times number of sets times pounds times calorie factor:
    		baseCaloriesExpended=this.getReps()*this.getQuantity()*intensity*exercise.getCalorieFactor();
    		//logger.debug(">>>>>>>>>>> in calculateCaloriesExpended(): this.getReps()="+this.getReps()+"; this.getQuantity()="+this.getQuantity()+"; intensity="+intensity+"; exercise.getCalorieFactor()="+exercise.getCalorieFactor());
    	}
    	else if (exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_REP_X_SPEED_FACTOR)) {
    		final double speedFactor=intensity/30; // 30 is average speed (3, but we store it as 30 to leave room for more intensity "notches").
    		// reps-per-set times sets times speed factor times calorie factor:
    		baseCaloriesExpended=this.getReps()*this.getQuantity()*speedFactor*exercise.getCalorieFactor();
    		//logger.debug(">>>>>>>>>>> in calculateCaloriesExpended(): this.getReps()="+this.getReps()+"; this.getQuantity()="+this.getQuantity()+"; speedFactor="+speedFactor+"; exercise.getCalorieFactor()"+exercise.getCalorieFactor());
    	}
    	else if (
    			exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_UNSPECIFIED) || 
    			exercise.getCalorieCalculationMethod().equals(Exercise.CAL_CALC_METHOD_NOT_APPLICABLE)
    		) {
    		baseCaloriesExpended=0.0;
    		//logger.debug(">>>>>>>>>>> in calculateCaloriesExpended(): (no cals expended; unspecified or n/a)");
    	}
    	else {
    		//logger.debug(">>>>>>>>>>> throwing runtime ex; can't calc...");
    		throw new RuntimeException("Cannot compute calories expended because \""+exercise.getCalorieCalculationMethod()+"\" is not a recognized calorie calculation method.");
    	}
    	// now we have baseCaloriesExpended, but this applies if client weighs 170; need to adjust for client's actual weight:
    	final double weightFactor=this.currentUserWeight/Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS;
    	//logger.debug(">>>>>>>>>>> in calculateCaloriesExpended(): weightFactor="+weightFactor+"; baseCaloriesExpended="+baseCaloriesExpended+"; baseCaloriesExpended*weightFactor="+baseCaloriesExpended*weightFactor);
    	return baseCaloriesExpended*weightFactor;
	}



	public static synchronized String getCaloriesExpendedLabel(final ExerciseDetail exerciseDetail, final Exercise exercise) {
		if (!measureMapsInitialized) {
			initializeMeasureMaps();
		}
		final StringBuilder label=new StringBuilder();
		label.append(exercise.getName()+": ");
		final double quantityDouble=exerciseDetail.getQuantity();
		final double intensityDouble=exerciseDetail.getIntensity();
		final int repsInt=exerciseDetail.getReps();

		final String quantity=DECIMAL_FORMAT_OPTIONAL_FRACTIONS.format(quantityDouble);
		final String intensity=DECIMAL_FORMAT_OPTIONAL_FRACTIONS.format(intensityDouble);
		final String reps=DECIMAL_FORMAT_OPTIONAL_FRACTIONS.format(repsInt);

		
		
		final String quantityUnits=exercise.getQuantityMeasure();
		if (quantityUnits.equals("NA")) {
			// nothing.
		}
		else if (quantityUnits.equals("SET")) {
			label.append(quantity+" sets of "+reps+" reps");
		}	
		else {
			label.append(quantity+" "+((String)quantityCodesToNamesMap.get(quantityUnits)).toLowerCase());
		}	

		final String intensityUnits=exercise.getIntensityMeasure();
		if (intensityUnits.equals("NA")) {
			// nothing.
		}
		else if (intensityUnits.equals("LEVEL")) {
			label.append(" at level "+intensity);
		}
		else if (intensityUnits.equals("SPEED")) {
			// note: values are 10, 20, 30, etc -- leaves us room to add more speeds if needed, and still have them be comparable with each other
			label.append(" at "+SPEED_LABELS[(int)intensityDouble/10]+" speed");
		}
		else {
			label.append("at "+intensity+" "+((String)intensityCodesToNamesMap.get(intensityUnits)).toLowerCase());

		}
		return label.toString();
		
	}


	// synchronize on the whole class while we initialize these (for some reason,
	// initializing them in a static initializer was a problem, so the first time
	// an instance of this class needs these, we initialize them (weird, but really
	// I don't have time to figure out what the issue is):
	private static synchronized void initializeMeasureMaps() {
		intensityMeasuresList=ExerciseIntensityMeasure.getAll();
		quantityMeasuresList=ExerciseQuantityMeasure.getAll();
		intensityCodesToNamesMap=new HashMap(intensityMeasuresList.size());
		quantityCodesToNamesMap=new HashMap(quantityMeasuresList.size());

		// these (and the lists above) come from the db, but they can be static 
		// because they change so infrequently (haven't changed in five years and
		// counting), and only manually via the db.
		for (int i=0; i<intensityMeasuresList.size(); i++) {
			final ExerciseIntensityMeasure m=(ExerciseIntensityMeasure)intensityMeasuresList.get(i);
			intensityCodesToNamesMap.put(m.getCode(),m.getName());
		}
		for (int i=0; i<quantityMeasuresList.size(); i++) {
			final ExerciseQuantityMeasure m=(ExerciseQuantityMeasure)quantityMeasuresList.get(i);
			quantityCodesToNamesMap.put(m.getCode(),m.getName());
		}
		measureMapsInitialized=true;
		
	}



	private static void setWorkoutIds(final List list, final int workoutId) {
        for (int i=0; i<list.size(); i++) {
            ((ExerciseDetail)list.get(i)).setWorkoutId(workoutId);
        }
    }

    private static void validListCheck(final List list) {
        // look for duplicate indices, non-consecutive indices:
        final boolean[] testIndexSlots=new boolean[list.size()];
        Arrays.fill(testIndexSlots, false);
        int i=-1;
        try {
	        for (i=0; i<list.size(); i++) {
	            final ExerciseDetail exDetail=(ExerciseDetail)list.get(i);
	            final int index=exDetail.getIndex();
	            if (index<0) {
	                throw new RuntimeException("The list of ExerciseDetails was not valid; negative index found.");
	            }
	            if (testIndexSlots[index]) {
	                throw new RuntimeException("The list of ExerciseDetails was not valid; two instances of the index '"+index+"' found.");
	            }
	            testIndexSlots[index]=true;
	        }
        }
        catch (final ArrayIndexOutOfBoundsException e) {
            throw new RuntimeException("The list of ExerciseDetails was not valid; the index '"+i+"' is out of range.");
        }
    }




}
