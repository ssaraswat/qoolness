<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>
 
<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%



User user=controller.getSessionInfo().getUser();

String successParam;
int id=controller.getParamAsInt("id",0);
String mode=controller.getParam("mode","add");

boolean prescriptive=controller.getParamAsBoolean("prescriptive");
boolean sendMail=controller.getParamAsBoolean("sendMail", false);

// only for descriptive:
int year=controller.getParamAsInt("year",-1);
int month=controller.getParamAsInt("month",-1);
int date=controller.getParamAsInt("date",-1);

boolean workoutExists=(mode.equals("edit"));
try
{
	int numExercises=controller.getParamAsInt("numExercises");

	Workout workout;
	Workout sourceWorkout=null;
	List<ExerciseDetail> exerciseDetails=new ArrayList<ExerciseDetail>(numExercises);
	if (workoutExists) {
		workout=Workout.getById(id);
		// hackery:
		if (workout==null) {
			workout=new Workout();
			if (mode.equals("copy") && !controller.getParamAsBoolean("prescriptive")) {
				sourceWorkout=Workout.getById(controller.getParamAsInt("copyingFromWorkoutId"));
				if (sourceWorkout!=null) {
					workout.setSourceWorkoutId(sourceWorkout.getId());
				}
			}
			try {
				id=workout.store();
			}
			catch (Exception e) {
				id=0;
				workoutExists=false;
			}
		}
	}
	else {
		workout=new Workout();
		if (mode.equals("copy") && !controller.getParamAsBoolean("prescriptive")) {
			sourceWorkout=Workout.getById(controller.getParamAsInt("copyingFromWorkoutId"));
			if (sourceWorkout!=null) {
				workout.setSourceWorkoutId(sourceWorkout.getId());
			}
			
		}
	}
	workout.setName(controller.getParam("name"));
	workout.setComments(controller.getParam("comment"));
	workout.setUserId(user.getId());
	workout.setPrescriptive(controller.getParamAsBoolean("prescriptive"));
	workout.setAdministratorAssigned(false);
	if (!prescriptive) {
		// workout
		workout.setPerformedDate(new GregorianCalendar(year, month, date).getTime());
		if (sourceWorkout!=null) {
			sourceWorkout.setRecordedAsWorkoutDate(new GregorianCalendar(year, month, date).getTime());
			sourceWorkout.store();
		}
	}
	else {
		// routine
		workout.setPerformedDate(new Date(0));
	}
	
	

	for (int i=0; i<numExercises; i++) {
		double intensity=controller.getParamAsDouble("intensity"+i);
		double quantity=controller.getParamAsDouble("quantity"+i);
		int reps=controller.getParamAsInt("reps"+i);

		ExerciseDetail ed=new ExerciseDetail();
		ed.setExerciseId(controller.getParamAsInt("id"+i));
		ed.setIntensity(intensity);
		ed.setQuantity(quantity);
		ed.setReps(reps);
		ed.setComments(controller.getParam("comments"+i));
		ed.setIndex(i);
		ed.setSupersetGroup(controller.getParamAsInt("ssg"+i));
		ed.setRestInterval(controller.getParamAsInt("ri"+i));
		exerciseDetails.add(ed);
	}
	workout.setExerciseDetails(exerciseDetails);
	if (workoutExists) {
		id=workout.store();
	}
	else {
		id=workout.store();
	}
	
	if (sendMail) {
		MailUtils.sendWorkoutNotification(workoutExists, workout, user, pageContext, controller);
	}
	
	// will only be passed if we asked for it; we only ask for it if we
	// didn't already have it in the db, but to be double-safe, we'll still
	// revert to male/female defaults if need be:
	double clientWeight=controller.getParamAsDouble("weight", 0.0);
	
	if (clientWeight>0.0) {
		// Save it if it was passed:
		PfdItem weightItem=new PfdItem();
		weightItem.setCode("weight");
		weightItem.setValue(""+clientWeight);
		weightItem.setUserId(user.getId());
		weightItem.store(user.getId());
	}
	else {
		// it wasn't passed, so it should exist in the db...
		try {
			clientWeight=Double.parseDouble(PfdItem.getCurrentByUserIdAndCode(user.getId(), "weight"));
		}
		catch (Exception e) {}
		// ... but if not, we'll use the male or female defaults for now (difficult
		// to see how we'd get here, but whatever):
		if (clientWeight==0.0) {
			if (user.getGender()==User.MALE) {
				clientWeight=Exercise.DEFAULT_MALE_WEIGHT;
			}
			else {
				clientWeight=Exercise.DEFAULT_FEMALE_WEIGHT;
			}
		}
	}

	
	// note: also stores calories expended:
	ExerciseDetail.storeExerciseDetailsFrom(workout, user, clientWeight, Exercise.getAllAsMap());
	
	workout.setUserId(user.getId());
	// Storing the Workout twice: agree, this is ugly, but we'll all live:
	id=workout.store();


	successParam="true";
}
catch (Exception e)
{
	successParam="false";
	// fuck it:
	throw new JspException("Exception trying to process workout: "+e.getClass()+": "+e.getMessage(), e);

}



controller.redirect("showWorkout.jsp?"+controller.getSiteIdNVPair()+"&id="+id+"&mode="+mode+"&success="+successParam);

%>

<%@ include file="/global/bottomInclude.jsp" %>







<% PageUtils.jspEnd(request); %>

