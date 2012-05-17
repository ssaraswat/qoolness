<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.WorkoutComparator" %>

<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_EXERCISES=25;

static final int NONE=0; 
static final int ONE=1; 
static final int MANY=2; 

static int countActives(List workouts) {
	int c=0;
	for (int i=0; i<workouts.size(); i++) {
		Workout workout=(Workout)workouts.get(i);
		if (workout.getStatus()==Workout.STATUS_ACTIVE) {
			c++;
		}
	}
	return c;
}

static DateFormat deadlineDateFormat=new SimpleDateFormat("MM/dd/yy, h:mm aa");
static DateFormat completedDateFormat=new SimpleDateFormat("MM/dd/yy");
%>

<%


boolean prescriptive=controller.getParamAsBoolean("prescriptive");
boolean selfAssign=controller.getParamAsBoolean("selfAssign");

int highlightId=controller.getParamAsInt("id",0);

User user=controller.getSessionInfo().getUser();
List allWorkouts=null;
try {
	if (prescriptive) {
		if (!selfAssign) {
			allWorkouts=Workout.getAdministratorAssignedByUserId(user.getId());
			if (allWorkouts==null) {
				allWorkouts=new ArrayList();
			}
		}
		else {
			allWorkouts=Workout.getUserCreated(user.getId(), true);
			if (allWorkouts==null) {
				allWorkouts=new ArrayList();
			}
		}
	}
	else {
		allWorkouts=Workout.getUserCreated(user.getId(), false);
		if (allWorkouts==null) {
			allWorkouts=new ArrayList();
		}
	}
}
catch (RuntimeException e) {}
if (allWorkouts==null) {
	allWorkouts=new ArrayList(0);
}
if (prescriptive) {
	// sort by name (the default):
	Collections.sort(allWorkouts);
}
else {
	// sort by date:
	Collections.sort(allWorkouts, new WorkoutComparator(WorkoutComparator.DATE, false));
}
String showMode=controller.getParam("showMode", "active");

int numActiveWorkouts=countActives(allWorkouts);

int numWorkouts=NONE;
if (numActiveWorkouts>0) {
	if (numActiveWorkouts==1) {
		numWorkouts=ONE;
	}
	else {
		numWorkouts=MANY;
	}
}

DateFormat fmt=DateFormat.getDateInstance(DateFormat.LONG);

%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">
var selfAssign=<%=selfAssign%>
var prescriptive=<%=prescriptive%>

var n="<%=controller.getParam("n","")%>"

function reloadPage(radioBtn) {
	var mode=radioBtn.value;
	if (radioBtn.checked) {
		var newLoc=new String(location.href);
		var paramNameAndEquals="showMode=";
		if (newLoc.indexOf(paramNameAndEquals)==-1) {
			if (newLoc.indexOf("?")==-1) {
				newLoc+="?";
			}
			else {
				newLoc+="&";
			}
			newLoc+=paramNameAndEquals+mode;
		}
		else {
			newLoc+="&";
			newLoc=newLoc.substring(0, newLoc.indexOf(paramNameAndEquals))
				+paramNameAndEquals+mode;
		}
		location.href=newLoc;
	}
}

function deleteWorkout(id, label) {
	if (generalConfirm("Are you sure that you want to delete \""+label+"\"?")) {
		location.href="processDeleteWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id="+id+"&r="+escape("workoutList.jsp?selfAssign="+selfAssign+"&prescriptive="+prescriptive+"")
	}
}

function init() {
	if (n.length>0) {
		generalAlert("'"+n+"' has been deleted.")
	}
}


</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
.actionFormButton {font-size:11px; font-family:arial,helvetica; width:40px; background-color:#ff6600; border:1px solid #000000; color:#ffffff; }
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<font class="bodyFont"> 
<span class="standardTextBlockWidth">
<%
	if (selfAssign==false && prescriptive==true) {
		if (numWorkouts==NONE) {
			%><span class="firstSentenceFont">There are no routines...</span><br />
			...assigned to you.  If you like, you may <a href="workout.jsp?<%=controller.getSiteIdNVPair()%>&mode=add&prescriptive=true">assign one to yourself</a>.</span><%=HtmlUtils.doubleLB(request)%><%
		}
		else if (numWorkouts==ONE) {
			%><span class="firstSentenceFont">Here is the routine...</span><br />
			...assigned to you.  If you've performed the routine and would like to record a workout based on it, click the "save workout" button.  
			(You can also make a copy of this routine for your own later use by clicking the "copy" button.)</span><%=HtmlUtils.doubleLB(request)%><%
		}
		else if (numWorkouts==MANY) {
			%><span class="firstSentenceFont">Here are the routines...</span><br />
			...that have been assigned to you.  If you've performed one of the routines and would like to record a workout based on it, 
			click the appropriate "save workout" button.  
			(You can also make a copy of any routine for your own later use by clicking the appropriate "copy" button.)</span><%=HtmlUtils.doubleLB(request)%><%
		}
	}
	else if (selfAssign==true && prescriptive==true) {
		if (numWorkouts==NONE) {
			%><span class="firstSentenceFont">You haven't assigned...</span><br />
			...any routines to yourself.  If you like, you may <a href="workout.jsp?<%=controller.getSiteIdNVPair()%>&mode=add&prescriptive=true">do that here</a>.
			Of course, you may also want to ask your trainer to assign you a workout.</span><%=HtmlUtils.doubleLB(request)%><%
		}
		else if (numWorkouts==ONE) {
			%><span class="firstSentenceFont">Here is the routine...</span><br />
			...you've created for yourself.<br />

			If you've performed the routine and would like to record a workout based on it, click the "save workout" button.  
			(You can also make a copy of this routine for your own later use by clicking the "copy" button.)<br /><br />
			
			If you'd like to edit it, click the "edit" button.<br /><br />
			
			If you'd like to delete it... you guessed it &mdash; click the "delete" button.</span><%=HtmlUtils.doubleLB(request)%><%
		}
		else if (numWorkouts==MANY) {
			%><span class="firstSentenceFont">Here are the routines...</span><br />
			...you've created for yourself.<br />

			If you've completed one of the routines and would like to record a workout based on it, 
			click the appropriate "save workout" button.  (You can also make a copy of any routine for your own later use by clicking the appropriate "copy" button.)<br /><br />
			
			If you'd like to edit a routine, click an "edit" button.<br /><br />
			
			If you'd like to delete a routine... you guessed it &mdash; click a "delete" button.</span><%=HtmlUtils.doubleLB(request)%><%
		}
	}
	else { // descriptive workout
		if (numWorkouts==NONE) {
			%><span class="firstSentenceFont">You haven't recorded...</span><br />
			...any any workouts yet.  Want to <a href="workout.jsp?<%=controller.getSiteIdNVPair()%>&mode=add&prescriptive=false">get started</a> now?</span><%=HtmlUtils.doubleLB(request)%><%
		}
		else {
			%><span class="firstSentenceFont">Here are the workouts of days past... (they're baaaack)</span><br />
			If you'd like to record a workout using an old one as a template, click a "copy" button.<br /><br />

			If you'd like to edit an old workout, click an 
			edit button.<br /><br />

			If you'd like to delete an old workout... you guessed it! Click a delete button next to your future trash.<br /><br />

			If these options aren't doing it for you, you can <a href="workout.jsp?<%=controller.getSiteIdNVPair()%>&mode=add&prescriptive=false">add a new workout</a>.</span><%=HtmlUtils.doubleLB(request)%><%
		}	
	}
%>


<%
if (numActiveWorkouts>0) {
%>
	<table border="0" cellspacing="0" cellpadding="0">
	<form action="workoutExerciseDetails.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
	<%=HtmlUtils.getHorizRuleTr(5, request)%>
	<tr class="headerRow" height="20">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<%=(prescriptive?"Routine":"Workout")%>&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Actions&nbsp;&nbsp;&nbsp;<br /></font></td>
	
	
	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr>
	<%=HtmlUtils.getHorizRuleTr(5, request)%>
	
	<%
	long nowTime=new Date().getTime();
	for (int i=0; i<allWorkouts.size(); i++) {
		Workout workout=(Workout)allWorkouts.get(i);
		boolean workoutActive=(workout.getStatus()==Workout.STATUS_ACTIVE);
		String workoutName;
		if (prescriptive) {
			workoutName=workout.getName();
		}
		else {
			workoutName=fmt.format(workout.getPerformedDate());
		}
		if ((showMode.equals("active") && !workoutActive) || (showMode.equals("deactivated") && workoutActive)) {
			continue;
		}
		%>
		<tr valign="middle" class=<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%> height="24">
		<%=HtmlUtils.getSingleRuleCell(request)%>
		<td align="left"><font class="columnDataFont">&nbsp;<br /></font></td>
		<td align="left" width="225" nowrap="nowrap"><font class="columnDataFont"><a href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=workout.getId()%>&mode=view" xonclick="showWorkout(<%=workout.getId()%>); return false"><%=workoutName%></a><%=workoutActive?"":" [deactivated]"%><%=(workout.getId()==highlightId)?" <b style=\"color:#ff6600;\">[new]</b>":""%><br/>
		<%
		if (workout.isPrescriptive()) {
			%>
			<%=workout.getDueDate()!=null?" Deadline: "+deadlineDateFormat.format(workout.getDueDate())+"":" Deadline: none"%><%
				if (workout.getRecordedAsWorkoutDate()==null && workout.getDueDate()!=null && workout.getDueDate().getTime()<nowTime) {
					%> <b style="color:#cc0000">[past-due]</b><%
				}	
			%><br/>			
			<%
		}
		
		if (workout.isPrescriptive()) {
			%>
			<%=workout.getRecordedAsWorkoutDate()!=null?" Completed: "+completedDateFormat.format(workout.getRecordedAsWorkoutDate())+"":" Completed: (not completed)"%><br /></font></td>
			<%
		}
		else {
			%>
			<%=workout.getPerformedDate()!=null?" Completed: "+completedDateFormat.format(workout.getPerformedDate())+"":" Completed: (not completed)"%><br /></font></td>
			<%			
		}
		%>

		<td align="left"><font class="columnDataFont"><%
	if (selfAssign) {
		%><%=HtmlUtils.smallerFormButton(false, "edit", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=edit&id="+workout.getId()+"'", request)%><img src="../images/spacer.gif" height="1" width="1"
	/><%
	}
	%><%=HtmlUtils.smallerFormButton(false, "copy", "location.href='workout.jsp?mode=copy&prescriptive=true&"+controller.getSiteIdNVPair()+"&id="+workout.getId()+"'", request)%><img src="../images/spacer.gif" height="1" width="1"
	/><%=HtmlUtils.smallFormButton(false, "saveWorkout", "location.href='workout.jsp?mode=copy&prescriptive=false&"+controller.getSiteIdNVPair()+"&id="+workout.getId()+"'", request)%><img src="../images/spacer.gif" height="1" width="1"
	/><%
	if (selfAssign) {
		%><%=HtmlUtils.smallerFormButton(false, "delete", "deleteWorkout("+workout.getId()+",'"+workoutName+"'); return false;", request)%><img src="../images/spacer.gif" height="1" width="3" /><%
	}
	%><br />
	
		<%=HtmlUtils.getSingleRuleCell(request)%>
		</tr> 
		<%=HtmlUtils.getHorizRuleTr(5, request)%>
	<%
	}
	%>
	
	
	
	</table>
<%
}
%>

<br />




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

