<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.ExerciseComparator" %>


<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_EXERCISES=25;
%>

<%


// possible modes: add, copy:
String mode=controller.getParam("mode","add");
boolean prescriptive=controller.getParamAsBoolean("prescriptive", true);

User user=controller.getSessionInfo().getUser();
List allExercises=Exercise.getAll();
// sort by name:
Collections.sort(allExercises);
// sort by category
Collections.sort(allExercises, new ExerciseComparator(ExerciseComparator.CATEGORY));



HashMap idIntsToExercisesMap=new HashMap(allExercises.size());
for (int i=0; i<allExercises.size(); i++) {
	Exercise ex=(Exercise)allExercises.get(i);
	idIntsToExercisesMap.put(new Integer(ex.getId()),ex);
}

Workout workout;
List exerciseDetails;
int[] exerciseIds;

if (mode.equals("add")) {
	workout=new Workout();
	exerciseDetails=new ArrayList(0);
	exerciseIds=new int[0];
}
else if (mode.equals("edit") || mode.equals("copy")) {
	workout=Workout.getById(controller.getParamAsInt("id"));
	ExerciseDetail.loadExerciseDetailsInto(workout);
	exerciseDetails=workout.getExerciseDetails();
	if (exerciseDetails!=null) {
		exerciseIds=new int[exerciseDetails.size()];
		for (int i=0; i<exerciseDetails.size(); i++) {
			ExerciseDetail ed=(ExerciseDetail)exerciseDetails.get(i);
			exerciseIds[i]=ed.getExerciseId();
		}
	}
	else {
		exerciseIds=new int[0];
	}
	if (mode.equals("edit")) {
		prescriptive=workout.isPrescriptive();
	}
	else { // copy:
		// nothing; we'll keep the param def from above.
	}
}
else {
	throw  new FatalApplicationException("unrecognized mode.");
}

Workout sourceWorkout=null;
try {
	sourceWorkout=Workout.getById(controller.getParamAsInt("id"));
}
catch (Exception e) {}
User sourceWorkoutAssigningBackendUser=null;
try {
	sourceWorkoutAssigningBackendUser=User.getById(workout.getAssigningBackendUserId());
}
catch (Exception e) {}

int workoutIdToStore=0;
if (mode.equals("edit")) {
	workoutIdToStore=workout.getId();
}
workout.setPrescriptive(prescriptive);

 
String name=PageUtils.nonNull(workout.getName());

if (mode.equals("copy") && name.trim().length()>0) {
	name="copy of "+name;
}


List categoriesList=ExerciseCategory.getAll();
HashMap categoryNamesToLabelsMap=new HashMap(categoriesList.size());
for (int i=0; i<categoriesList.size(); i++) {
	ExerciseCategory c=(ExerciseCategory)categoriesList.get(i);
	categoryNamesToLabelsMap.put(c.getCode(),c.getAbbrev());
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">


var NUM_EXERCISES=<%=NUM_EXERCISES%>


var mode="<%=mode%>";

var allExercises=new Object();
<%
for (int i=0; i<allExercises.size(); i++) {
	Exercise exercise=(Exercise)allExercises.get(i);
	%>allExercises.id<%=exercise.getId()%>="<%=exercise.getName()%>"
	<%
}
%>


var currExerciseIds=[<%
for (int i=0; i<exerciseIds.length; i++) {
%><%=i>0?",":""%><%=exerciseIds[i]%><%
}
%>]

function setCurrentExerciseOptions() {
	var selectObj=document.forms["mainForm"].elements["exercisesMenu"]
	
	var opts=selectObj.options
	
	if (opts!=null) {
		var numOpts=opts.length
		for (var i=0; i<numOpts; i++) {
			opts[0]=null // array shrinks after this, so easier to take options off front of list
		}
	}
	for (var i=0; i<currExerciseIds.length; i++) {
		var opt=document.createElement("OPTION");
		selectObj.options.add(opt);
		opt.value=""+currExerciseIds[i];
		opt.innerHTML=allExercises["id"+currExerciseIds[i]];
		

	}
}

function addSelectedExercise(fromClick) {
	var selectObj=document.forms["mainForm"].elements["allExercisesMenu"]
	if (selectObj.selectedIndex==-1) {
		if (!fromClick) {
			errorAlert("Please select an exercise in the lefthand menu before clicking \"add\".")
		}
	}
	else {
		if (selectObj.options[selectObj.selectedIndex].value=="") {
			if (!fromClick) {
				errorAlert("Please select an exercise in the lefthand menu before clicking \"add\".")
			}
			return
		}
		var exId=parseInt(selectObj.options[selectObj.selectedIndex].value)
		currExerciseIds[currExerciseIds.length]=exId
		setCurrentExerciseOptions()
	}
}

function removeSelectedExercise(fromClick) {
	var selectObj=document.forms["mainForm"].elements["exercisesMenu"]
	if (selectObj.options.length==0 && !fromClick) {
		errorAlert("There are no exercises to remove from the righthand list.")
	}
	else {
		if (selectObj.selectedIndex==-1) {
			if (!fromClick) {
				errorAlert("Please select an exercise in the righthand menu before clicking \"remove\".")
			}
		}
		else {
			var exId=parseInt(selectObj.options[selectObj.selectedIndex].value)
			var newIdsArray=[]
			for (var i=0; i<currExerciseIds.length; i++) {
				if (exId!=currExerciseIds[i]) {
					newIdsArray[newIdsArray.length]=currExerciseIds[i]
				}
			}
			currExerciseIds=newIdsArray
			setCurrentExerciseOptions()
		}
	}
}

var prescriptive=<%=prescriptive%>

function isValidForm(formObj)
{
	var els=formObj.elements;
	if (trim(els["name"].value).length==0 && prescriptive)
	{
		errorAlert("You have not entered a name for this "+(prescriptive?"routine":"workout")+"; please fix and try again.",els["name"]);
		return false;
	}
	var selectObj=document.forms["mainForm"].elements["exercisesMenu"];

	if (selectObj.options.length==0)
	{
		errorAlert("You have not chosen any exercises; you must choose at least one. Please fix and try again.");
		return false;
	}
	var weightInputEl=$("weight");
	// it may or may not exist; only exists if we didn't already have this 
	// user's weight in the db:
	if (weightInputEl!=null) {
		if (trim(weightInputEl.value)=="")
		{
			errorAlert("You have not entered your current weight; this is required. Please fix and try again.", weightInputEl);
			return false;
		}
		if (!isNumber(trim(weightInputEl.value)))
		{
			errorAlert("The weight you entered is not a number. Please enter your weight, in pounds, and try again.", weightInputEl);
			return false;
		}
	}

	setActionWithExerciseIds(selectObj.options, formObj);
	hidePageAndShowPleaseWait();
	return true;
}

function setActionWithExerciseIds(opts, formObj) {
	var qString="?<%=controller.getSiteIdNVPair()%>"
	for (var i=0; i<opts.length; i++) {
		qString+="&exercise"+i+"="+opts[i].value
	}
	var actn=""+formObj.action
	if (actn.indexOf("?")>-1) {
		actn=actn.substring(0, actn.indexOf("?"))
	}
	formObj.action=actn+qString
}


// overriding:
function init() {
	setCurrentExerciseOptions()
}

</script>

<style type="text/css">
.exerciseListFont {font-size:11px; font-family:arial,helvetica;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">


<font class="bodyFont"> 
<span class="standardTextBlockWidth" style="width:535px;">


<%
if (mode.equals("add")) {
	if (prescriptive) {
		%>
		<span class="firstSentenceFont">Create a new routine here.</span><br />
		A routine consists of several exercises.  Add them to your routine by selecting
		one and clicking the "add" button. (If you change your mind about an exercise,
		select it in the "this routine" list and click the "remove" button.)
		When you have finished creating your routine, click the "continue" button.</span><%=HtmlUtils.doubleLB(request)%>
		<%
	}
	else {
		%>
		<span class="firstSentenceFont">Here's Your Chance to Brag.</span><br />
		Tell us what you did today: complete the form below, then click the "continue" button.</span><%=HtmlUtils.doubleLB(request)%>
		<%
	}

}
else if (mode.equals("edit")) {
	if (prescriptive) {
		%>
		<span class="firstSentenceFont">Want to edit this routine?</span><br />
		Please make your changes, then "continue" button.</span><%=HtmlUtils.doubleLB(request)%>
		<%
	}
	else {
		%>
		<span class="firstSentenceFont">Want to edit this workout?</span><br />
		Please make your changes, then "continue" button.</span><%=HtmlUtils.doubleLB(request)%>
		<%
	}

}
else if (mode.equals("copy")) {
	String routineDetails="";
	if (sourceWorkout!=null) {
		routineDetails=" (the \""+sourceWorkout.getName()+"\" routine";
		if (sourceWorkoutAssigningBackendUser!=null) {
			routineDetails+=" assigned to you by "+sourceWorkoutAssigningBackendUser.getFirstName()+" "+sourceWorkoutAssigningBackendUser.getLastName();
		}
		routineDetails+=")";
	}
	if (prescriptive) {
		%>
		<span class="firstSentenceFont">Create a new routine here...</span><br />
		...using the one below as a starting point<%=routineDetails%>. You can 
		edit this routine to suit your needs. When you are satisfied 
		with your new routine, click the "continue" button.</span><%=HtmlUtils.doubleLB(request)%>
		<%
	}
	else {
		%>
		<span class="firstSentenceFont">Here's Your Chance to Brag.</span><br />
		Tell us what you did today. Start with the existing <%=(prescriptive?"routine":"workout")%> below<%=routineDetails%>. Edit it to match what you accomplished. Then click the "continue" button.</span><%=HtmlUtils.doubleLB(request)%>
		<%
	}
}


%>
<form action="workoutExerciseDetails.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">

<%
double clientWeight;
boolean weightFound=false;
try {
	String weightStr=PfdItem.getCurrentByUserIdAndCode(user.getId(), "weight");
	try {
		clientWeight=Double.parseDouble(weightStr);
		weightFound=true;
	}
	catch (RuntimeException e) {
		// weight hasn't been specified, so:
		if (user.getGender()==User.MALE) {
			clientWeight=Exercise.DEFAULT_MALE_WEIGHT;
		}
		else {
			clientWeight=Exercise.DEFAULT_FEMALE_WEIGHT;
		}
	}
	
}
catch (Exception e) {
	logger.warn("Exception parsing weight value from db, but we'll use defaults", e);
	clientWeight=0.0;
	weightFound=false;
}

if (!weightFound) {
	%>
	<div style="border:1px solid #333333; padding:4px; background-color:#ff9900;"><b>But 
	first... your weight!</b><br/>
	We don't have it on file.  We can't calculate how many calories 
	<%=prescriptive?"you'll burn":"you've burned"%> 
	without it. Please enter your current weight here:<br/>
	<input class="inputText" type="text" style="width:50px;" name="weight" id="weight" value="" /><br />
	</div><br />
	
	<%
}


%><br />


<input type="hidden" name="numExerciseSlots" value="<%=NUM_EXERCISES%>" />
<input type="hidden" name="prescriptive" value="<%=workout.isPrescriptive()%>" />
<input type="hidden" name="status" value="<%=workout.getStatus()%>" />
<input type="hidden" name="userId" value="<%=workout.getUserId()%>" />
<input type="hidden" name="id" value="<%=workoutIdToStore%>" />
<input type="hidden" name="mode" value="<%=mode%>" />
<input type="hidden" name="copyingFromWorkoutId" value="<%=(mode.equals("copy")?controller.getParamAsInt("id"):0)%>" />

<%
if (prescriptive) {
	%><span class="boldishFont">Name </span> (e.g., "Weekday Routine")<br />
	<input type="hidden" name="year" value="-1" />
	<input type="hidden" name="month" value="-1" />
	<input type="hidden" name="date" value="-1" />
<input class="inputText" type="text" style="width:350px;" name="name" id="name" value="<%=name%>"><br /><br /><%
}
else {
	%><span class="boldishFont">Date </span><br /><input type="hidden" name="name" value="" />
	<%HtmlUtils.dateFields(pageContext, controller);%><br /><br /><%
}
%>


<span class="boldishFont">Comments</span><br />
<textarea  class="inputText"  name="comment" id="comment"  style="width:350px; height:50px;" rows="3" cols="30" ><%=PageUtils.nonNull(workout.getComments())%></textarea><br /><br />

<span class="boldishFont">Exercises:</span> Add or remove exercises from the righthand list ("This <%=(prescriptive?"routine":"workout")%>") as needed.<br />
<div style=" overflow:visible; width:535px; border:1px solid #666666; background-color:#eeeeee; padding:4px;">
<table border="0" cellspacing="0" cellpadding="0" width="535">
<tr valign="top">
<td width="230" nowrap="nowrap" class="bodyFont" style="color:#000000;">
<i>All available exercises:</i><br />
<select ondblclick="addSelectedExercise(true)" class="selectText"  name="allExercisesMenu" style="font-size:11px; background-color:#f8f8f8;  width:230px; " size="15" >



<%
	for (int i=0; i<allExercises.size(); i++) {
		Exercise exercise=(Exercise)allExercises.get(i);
		%>

		<option value="<%=exercise.getId()%>" ><%=categoryNamesToLabelsMap.get(exercise.getCategory())%> - <%=exercise.getName()%></option>

		<%
		}
%>



</select><br /></td>
<td align="center" width="80" nowrap="nowrap">
<br />
<a href="#" onclick="addSelectedExercise(false); return false" hidefocus="true"><img src="../images/smallButtons/add_arrow.gif" height="19" width="64" border="0" /></a><br />
<a href="#" onclick="removeSelectedExercise(false); return false" hidefocus="true"><img src="../images/smallButtons/remove_arrow.gif" height="19" width="64" border="0" style="margin-top:6px;" /></a><br />
</td>
<td width="205" nowrap="nowrap" class="bodyFont" style="color:#000000;">
<i>This <%=(prescriptive?"routine":"workout")%>:</i><br />
<select ondblclick="removeSelectedExercise(true)" class="selectText" name="exercisesMenu" style="font-size:11px; background-color:#f8f8f8; width:205px; " size="15" >
<option value=""></option>
</select><br /></td>
</tr>
</table>
</div>





<br />

<%=HtmlUtils.formButton(true, "continue", null, request)%>

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form>
</div>

<%@ include file="/global/bodyClose.jsp" %>

</html>

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

