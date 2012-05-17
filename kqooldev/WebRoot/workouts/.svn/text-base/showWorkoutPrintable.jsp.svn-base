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

<% PageUtils.setRequiredLoginStatus("none",request); %>
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
		dateStr="your "+DateFormat.getDateInstance(DateFormat.LONG).format(cal.getTime());
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
<script type="text/javascript">
window.focus()
</script>
<style type="text/css">
.printableTable {border-right:1px solid #000000; border-bottom:1px solid #000000;}
.printableTd {border-left:1px solid #000000; border-top:1px solid #000000; font-family:arial.helvetica; font-size:11px; }
.bodyFont {font-family:arial.helvetica; font-size:11px; }
.colHeaderFont {font-family:arial.helvetica; font-size:14px;  }
.exerciseNameFont {font-family:arial.helvetica; font-size:14px;  }

</style>
</head>
<body onload="window.focus()" bgcolor="ffffff" text="000000">
<div>
<div align="left" style="width:550px; margin:5px 0px 0px 0px; ">
<img src="../images/printableWorksheetLogo.gif" height="93" width="283" border="0" />

<font size="2" face="arial,helvetica" class="bodyFont">


 
<% 
// set values for included jsp --
// get values from including jsp:
request.setAttribute("prescriptive",new Boolean(prescriptive));
request.setAttribute("name",name);
request.setAttribute("comments",comments);
request.setAttribute("workout",workout);
request.setAttribute("fmt",fmt);
request.setAttribute("quantityCodesToNamesMap",quantityCodesToNamesMap);
request.setAttribute("intensityCodesToNamesMap",intensityCodesToNamesMap);
request.setAttribute("workoutDate",workout.getPerformedDate());
request.setAttribute("administratorAssigned",new Boolean(workout.isAdministratorAssigned()));


pageContext.include("includes/displayWorkoutPrintable.jsp"); %>


</font>
</div>
</div>

<%@ include file="/global/trackingCode.jsp" %>


</body>
</html>
<%

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

<%
long end=new Date().getTime();
%>


<% PageUtils.jspEnd(request); %>

