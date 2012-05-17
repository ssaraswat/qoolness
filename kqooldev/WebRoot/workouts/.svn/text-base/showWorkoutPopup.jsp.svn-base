<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%
long start=new Date().getTime();
%>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.*" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%





int sort=controller.getParamAsInt("sort", UserComparator.LAST_NAME);



List allUsers=User.getAll();
if (allUsers==null) {
	allUsers=new ArrayList(0);
}
Collections.sort(allUsers, new UserComparator(sort));

String mode=controller.getParam("mode"); // "add" or "edit"
boolean success=controller.getParamAsBoolean("success",true);
int id=controller.getParamAsInt("id");

Workout workout=Workout.getById(id);
String name=workout.getName();
String comments=workout.getComments();
boolean prescriptive=workout.isPrescriptive();
ExerciseDetail.loadExerciseDetailsInto(workout);
NumberFormat fmt=NumberFormat.getInstance();
fmt.setGroupingUsed(false);


// for descriptive only:
String dateStr="";
if (!prescriptive) {
	Calendar cal=new GregorianCalendar();
	cal.setTime(workout.getPerformedDate());
	Calendar now=new GregorianCalendar();
	boolean today=(cal.get(Calendar.YEAR)==now.get(Calendar.YEAR) && cal.get(Calendar.MONTH)==now.get(Calendar.MONTH) && cal.get(Calendar.DATE)==now.get(Calendar.DATE));
	if (!today) {
		dateStr=" "+DateFormat.getDateInstance(DateFormat.LONG).format(cal.getTime());
	}
	else {
		dateStr="today's";
	}

}


List intensityMeasuresList=ExerciseIntensityMeasure.getAll();
List quantityMeasuresList=ExerciseQuantityMeasure.getAll();
HashMap intensityCodesToNamesMap=new HashMap(intensityMeasuresList.size());
HashMap quantityCodesToNamesMap=new HashMap(quantityMeasuresList.size());
for (int i=0; i<intensityMeasuresList.size(); i++) {
	ExerciseIntensityMeasure m=(ExerciseIntensityMeasure)intensityMeasuresList.get(i);
	intensityCodesToNamesMap.put(m.getCode(),m.getName());
}
for (int i=0; i<quantityMeasuresList.size(); i++) {
	ExerciseQuantityMeasure m=(ExerciseQuantityMeasure)quantityMeasuresList.get(i);
	quantityCodesToNamesMap.put(m.getCode(),m.getName());
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">


function isValidAssignForm(formObj)
{
	var els=formObj.elements;
	if (els["userId"].selectedIndex==0) {
		errorAlert("You have not chosen a user to assign this workout to; please fix and try again.",els["userId"]);
		return false;		
	} 

	hidePageAndShowPleaseWait();
	return true;
}


</script>

<style type="text/css">
		body {background-repeat:repeat-x; background-image:url(<%=PageUtils.getPathToAppRoot(request)%>images/bg_popup.gif); }

</style>
</head>

<body bgcolor="#ffffff" topmargin="0" leftmargin="0">
<div id="mainDiv" style="position:absolute; top:50px; left:15px; ">

<% 
// set values for included jsp --
// get values from including jsp:
request.setAttribute("prescriptive",new Boolean(prescriptive));
request.setAttribute("workoutId",new Integer(workout.getId()));
request.setAttribute("name",name);
request.setAttribute("comments",comments);
request.setAttribute("workout",workout);
request.setAttribute("fmt",fmt);
request.setAttribute("quantityCodesToNamesMap",quantityCodesToNamesMap);
request.setAttribute("intensityCodesToNamesMap",intensityCodesToNamesMap);
request.setAttribute("workoutDate",workout.getPerformedDate());
request.setAttribute("administratorAssigned",new Boolean(workout.isAdministratorAssigned()));
request.setAttribute("showTagline",new Boolean(true));

pageContext.include("includes/displayWorkout.jsp"); %>

<br />

</div>



<%@ include file="/global/trackingCode.jsp" %>


</body>

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

<%
long end=new Date().getTime();
%>