<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!
DateFormat deadlineFormat=new SimpleDateFormat("MM/dd/yyyy HHmm");
DateFormat deadlineDateFormat=new SimpleDateFormat("MM/dd/yyyy");
%>

<%

Date currDate = new Date();

int assignToUserId=controller.getParamAsInt("assignToUserId",0);
boolean curDayMail = false;
boolean assignWorkoutToUser=(assignToUserId>0);

User assignToUser=null;
if (assignWorkoutToUser) {
	assignToUser=User.getById(assignToUserId);
}
String deadlineDate=controller.getParam("deadlineDate");
String deadlineTime=controller.getParam("deadlineTime");

Date dDeadline = deadlineDateFormat.parse(deadlineDate);

 Calendar calendar = Calendar.getInstance();

	calendar.set(Calendar.HOUR_OF_DAY, 0);
	calendar.set(Calendar.MINUTE, 0);
	calendar.set(Calendar.SECOND, 0);
	calendar.set(Calendar.MILLISECOND, 0);
 	Date dtCurrDate = calendar.getTime();

	Date dtDeadline = deadlineDateFormat.parse(deadlineDate);
	if(dtCurrDate.compareTo(dDeadline)==0){
		  curDayMail = true;
	}

Date deadline;
if (deadlineDate.equals("0") || deadlineTime.equals("0000")) {
	deadline=null;
}
else {
	String deadlineStr=deadlineDate+" "+deadlineTime; // something like "081509 1300"
	System.out.println(deadlineStr);
	
	
	deadline=deadlineFormat.parse(deadlineStr);
}

String successParam;
int id=controller.getParamAsInt("id",0);
String mode=controller.getParam("mode","add");



boolean workoutExists=(mode.equals("edit"));
try
{
	int numExercises=controller.getParamAsInt("numExercises");
	System.out.println("numExercises :" + new Integer(numExercises));
	
	Workout workout;
	List exerciseDetails=new ArrayList(numExercises);
	if (workoutExists) {
		workout=Workout.getById(id);
		// hackery:
		if (workout==null) {
			workout=new Workout();
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
	}
	System.out.println("name:"+ controller.getParam("name"));
	workout.setName(controller.getParam("name"));
	workout.setComments(controller.getParam("comment"));
	workout.setUserId(0); // no user id; created by kqool
	workout.setPrescriptive(true);
	workout.setAdministratorAssigned(true);
	if (workout.getAssigningBackendUserId()==0) {
		// only set this if this is a new routine; don't overwrite if it already exists:
			workout.setAssigningBackendUserId(currentUser.getId());
	}
	// may be null (if no deadline) or not:
	workout.setDueDate(deadline);

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
		System.out.println(workout.getName());
		id=workout.store();
	}
	else {
		System.out.println(workout.getName());
		id=workout.store();
	}

	double clientWeight=0.0;
	try {
		//clientWeight=Double.parseDouble(PfdItem.getCurrentByUserIdAndCode(assignToUser.getId(), "weight"));
	}
	catch (Exception e) {

		// Lots of users won't have this data stored, at least initially
	}

	if (clientWeight==0.0) {

		if (assignToUser != null && assignToUser.getGender()==User.MALE) {

			clientWeight=Exercise.DEFAULT_MALE_WEIGHT;

		}
		else {
			clientWeight=Exercise.DEFAULT_FEMALE_WEIGHT;

		}

	}

	ExerciseDetail.storeExerciseDetailsFrom(workout, assignToUser, clientWeight, Exercise.getAllAsMap());
	
	if (assignWorkoutToUser) {
		workout.setUserId(assignToUserId);
		// Yes, it *IS* ugly that we're storing this twice:
		id=workout.store();
		if(curDayMail)
			MailUtils.sendWorkoutAssignmentMail(assignToUser, workout, pageContext, controller);
	}
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
	// fuck it:
	throw new JspException("Exception trying to process workout: "+e.getClass()+": "+e.getMessage(), e);
}

//if  (assignWorkoutToUser) {
if  (false) {
	controller.redirect("userWorkouts.jsp?"+controller.getSiteIdNVPair()+"&id="+assignToUserId+"&assignedWorkoutId="+id+"&success="+successParam);
}
else {
	controller.redirect("showWorkout.jsp?"+controller.getSiteIdNVPair()+"&id="+id+"&mode="+mode+"&success="+successParam);
}
%>


<%@ include file="/global/bottomInclude.jsp" %>


<%
if (pageException!=null)
{
	%>
	<%@ include file="/global/jspErrorDialogLaunch.jsp" %>
	<%
}
%>





<% PageUtils.jspEnd(request); %>

