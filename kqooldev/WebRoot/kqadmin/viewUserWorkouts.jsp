<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_EXERCISES=25;
%>

<%


User user=controller.getSessionInfo().getUser();

User recordingUser=User.getById(controller.getParamAsInt("uid"));
int linkedWorkoutId=controller.getParamAsInt("wid");
boolean showLinkToSpecificWorkout=controller.getParamAsBoolean("showLink");

List allSavedWorkouts=Workout.getUserCreated(recordingUser.getId(), false);


allSavedWorkouts=(allSavedWorkouts==null?new ArrayList(0):allSavedWorkouts);

Collections.sort(allSavedWorkouts, new WorkoutComparator(WorkoutComparator.DATE, false));



String showMode=controller.getParam("showMode", "active");








%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

function reloadPage(radioBtn) {
	var mode=radioBtn.value
	if (radioBtn.checked) {
		var newLoc=new String(location.href)
		var paramNameAndEquals="showMode="
		if (newLoc.indexOf(paramNameAndEquals)==-1) {
			if (newLoc.indexOf("?")==-1) {
				newLoc+="?"
			}
			else {
				newLoc+="&"
			}
			newLoc+=paramNameAndEquals+mode
		}
		else {
			newLoc+="&"
			newLoc=newLoc.substring(0, newLoc.indexOf(paramNameAndEquals))
				+paramNameAndEquals+mode
		}
		location.href=newLoc
	}
}

<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">
.actionFormButton {font-size:11px; font-family:arial,helvetica; width:40px; background-color:#ff6600; border:1px solid #000000; color:#ffffff; }
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<form action="workoutExerciseDetails.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">



<span class="firstSentenceFont">Here are all workouts...</span><br />
...saved by <%=recordingUser.getFormattedNameAndUsername()%>, in descending order. Click a date to view the workout.
<%
if (showLinkToSpecificWorkout) {
	%>The workout just saved by this user is <a href="#" onclick="showWorkout(<%=linkedWorkoutId%>, false); return false">here</a>.<%
}

%>  To view this user's calorie spreadsheets, <a href="../workouts/calorieSpreadsheet.jsp?<%=controller.getSiteIdNVPair()%>&viewUserId=<%=recordingUser.getId()%>" target="_blank">click here</a>.   (To see all routines assigned to this user by Kqool, click <a href="userWorkouts.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=recordingUser.getId()%>">here</a>.)<%=HtmlUtils.doubleLB(request)%>









<%
if (allSavedWorkouts.size()>0) {
	%><br /><br />

<table border="0" cellspacing="0" cellpadding="0" width="400">
<%=HtmlUtils.getHorizRuleTr(5, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="left"><font class="boldishColumnHeaderFont">Stored workouts&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>


<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(5, request)%>

<%
boolean even=true;
for (int i=0; i<allSavedWorkouts.size(); i++) {
	Workout workout=(Workout)allSavedWorkouts.get(i);
	boolean workoutActive=(workout.getStatus()==Workout.STATUS_ACTIVE);
	if ((showMode.equals("active") && !workoutActive) || (showMode.equals("deactivated") && workoutActive)) {
		continue;
	}
	%>
	<tr valign="middle" class="<%=even?"even":"odd"%>DataRow" height="24">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td align="left"><font class="columnDataFont">&nbsp;<br /></font></td>
	<td align="left" width="390" nowrap="nowrap"><font class="columnDataFont">&nbsp;<a href="#" onclick="showWorkout(<%=workout.getId()%>,false); return false"><%=DateFormat.getDateInstance(DateFormat.LONG).format(workout.getPerformedDate())%></a>&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="right" nowrap="nowrap" width="1"><br /></td>


	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr> 
	<%=HtmlUtils.getHorizRuleTr(5, request)%>
	<%
	even=!even;
}
%>



</table><%
}
%>


<br /><br />
<font class="boldishFont">To create a new routine to assign to this user,</font> click the "create routine" button below.  (Note:
you will be able to assign this new routine to other users as well.)<%=HtmlUtils.doubleLB(request,20)%>




<%=HtmlUtils.cpFormButton(false, "create routine", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=add&assignToUserId="+recordingUser.getId()+"'", request)%>


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

