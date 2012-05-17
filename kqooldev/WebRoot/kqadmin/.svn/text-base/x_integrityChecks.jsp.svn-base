<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("superuser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%
ConnectionWrapper cw=DatabaseManager.getConnection();


List articlesToExercises;
List usersToWorkouts;
List videosToExercises;
List details;

try {
	articlesToExercises=ArticleToExerciseMapping.selectAll(cw);
}
catch (ExpectedDataNotFoundException e) {
	articlesToExercises=new ArrayList(0);
}
try {
	usersToWorkouts=UserToWorkoutMapping.selectAll(cw);
}
catch (ExpectedDataNotFoundException e) {
	usersToWorkouts=new ArrayList(0);
}
try {
	videosToExercises=VideoToExerciseMapping.selectAll(cw);
}
catch (ExpectedDataNotFoundException e) {
	videosToExercises=new ArrayList(0);
}
try {
	details=ExerciseDetail.selectAll(cw);
}
catch (ExpectedDataNotFoundException e) {
	details=new ArrayList(0);
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">






</script>

<style type="text/css">
body {background-image:url(); font-size:11px; font-family:arial, helvetica; }
td {font-size:11px; font-family:arial, helvetica; }
</style>
</head>

<%@ include file="/global/x_bodyOpen.jsp" %>

<%
boolean badMappingFound=false;
for (int i=0; i<articlesToExercises.size(); i++) {
	ArticleToExerciseMapping mapping=(ArticleToExerciseMapping)articlesToExercises.get(i);
	Article fromObj;
	try {
		fromObj=new Article(cw, mapping.getFromInt());
	}
	catch (ExpectedDataNotFoundException e) {
		fromObj=null;
	}
	Exercise toObj;
	try {
		toObj=new Exercise(cw, mapping.getToInt());
	}
	catch (ExpectedDataNotFoundException e) {
		toObj=null;
	}
	if (fromObj==null && toObj==null) {
	}
	else if (fromObj==null) {
		badMappingFound=true;
		/* %>ArticleToExerciseMapping <%=mapping.getId()%> (to Exercise "<%=toObj.getName()%>") is invalid: Article <%=mapping.getFromInt()%>) doesn't exist.<br /><% */
	}
	else if (toObj==null) {
		badMappingFound=true;
		/* %>ArticleToExerciseMapping <%=mapping.getId()%> (from Article "<%=fromObj.getTitle()%>") is invalid: Exercise <%=mapping.getToInt()%> doesn't exist.<br /><% */
	}
}
if (!badMappingFound) {
	%>All ArticleToExerciseMappings are valid.<br /><%
}
%>

<br />





<%
badMappingFound=false;
for (int i=0; i<videosToExercises.size(); i++) {
	VideoToExerciseMapping mapping=(VideoToExerciseMapping)videosToExercises.get(i);
	ExerciseVideo fromObj;
	try {
		fromObj=new ExerciseVideo(cw, mapping.getFromInt());
	}
	catch (ExpectedDataNotFoundException e) {
		fromObj=null;
	}
	Exercise toObj;
	try {
		toObj=new Exercise(cw, mapping.getToInt());
	}
	catch (ExpectedDataNotFoundException e) {
		toObj=null;
	}
	if (fromObj==null && toObj==null) {
	}
	else if (fromObj==null) {
		badMappingFound=true;
		%>VideoToExerciseMapping <%=mapping.getId()%> (to Exercise "<%=toObj.getName()%>") is invalid: ExerciseVideo <%=mapping.getFromInt()%> doesn't exist.<br /><%
	}
	else if (toObj==null) {
		badMappingFound=true;
		%>VideoToExerciseMapping <%=mapping.getId()%> (from ExerciseVideo "<%=fromObj.getName()%>") is invalid: Exercise <%=mapping.getToInt()%> doesn't exist.<br /><%
	}
}
if (!badMappingFound) {
	%>All VideoToExerciseMappings are valid.<br /><%
}
%>

<br />







<%
badMappingFound=false;
for (int i=0; i<usersToWorkouts.size(); i++) {
	UserToWorkoutMapping mapping=(UserToWorkoutMapping)usersToWorkouts.get(i);
	User fromObj;
	try {
		fromObj=new User(cw, mapping.getFromInt());
	}
	catch (ExpectedDataNotFoundException e) {
		fromObj=null;
	}
	Workout toObj;
	try {
		toObj=new Workout(cw, mapping.getToInt());
	}
	catch (ExpectedDataNotFoundException e) {
		toObj=null;
	}
	if (fromObj==null && toObj==null) {
	}
	else if (fromObj==null) {
		badMappingFound=true;
		%>UserToWorkoutMapping <%=mapping.getId()%> (to Workout "<%=toObj.getName()%>") is invalid: User <%=mapping.getFromInt()%> doesn't exist.<br /><%
	}
	else if (toObj==null) {
		badMappingFound=true;
		%>UserToWorkoutMapping <%=mapping.getId()%> (from User "<%=fromObj.getUsername()%>") is invalid: Workout <%=mapping.getToInt()%> doesn't exist.<br /><%
	}
}
if (!badMappingFound) {
	%>All UserToWorkoutMappings are valid.<br /><%
}
%>

<br />





<%
/*
boolean badDetailFound=false;
for (int i=0; i<details.size(); i++) {
	ExerciseDetail detail=(ExerciseDetail)details.get(i);
	Workout workout;
	try {
		workout=new Workout(cw, detail.getWorkoutId());
	}
	catch (ExpectedDataNotFoundException e) {
		badDetailFound=true;
		%>ExerciseDetail <%=detail.getId()%> is invalid: Workout <%=detail.getWorkoutId()%> doesn't exist.<br /><%
	}
}
if (!badDetailFound) {
	%>All ExerciseDetails have existing Workouts.<br /><%
}
*/
%>

<br />


<%
boolean badDetailFound=false;
for (int i=0; i<details.size(); i++) {
	ExerciseDetail detail=(ExerciseDetail)details.get(i);
	Exercise exercise;
	try {
		exercise=new Exercise(cw, detail.getExerciseId());
	}
	catch (ExpectedDataNotFoundException e) {
		badDetailFound=true;
		%>ExerciseDetail <%=detail.getId()%> (for Workout <%=detail.getWorkoutId()%>) is invalid: Exercise <%=detail.getExerciseId()%> doesn't exist.<br /><%
	}
}
if (!badDetailFound) {
	%>All ExerciseDetails have existing Exercises.<br /><%
}
%>

<br />





<%@ include file="/global/bodyClose.jsp" %>

</html>


<%
DatabaseManager.closeConnection(cw);
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

