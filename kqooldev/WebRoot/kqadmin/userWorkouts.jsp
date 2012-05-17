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




throw new RuntimeException("Users should not reach this page.");




User assignToUser=User.getById(controller.getParamAsInt("id"));

String showMode=controller.getParam("showMode", "active");
int showStatus=(showMode.equals("active")?Workout.STATUS_ACTIVE:Workout.STATUS_INACTIVE);

 
List allAssignableWorkouts=Workout.getAllAdministratorAssignedByStatus(showStatus);

allAssignableWorkouts=(allAssignableWorkouts==null?new ArrayList(0):allAssignableWorkouts);

Collections.sort(allAssignableWorkouts);





List assignedWorkouts=Workout.getAdministratorAssignedByUserId(assignToUser.getId());
assignedWorkouts=(assignedWorkouts==null?new ArrayList(0):assignedWorkouts);




int[] assignedWorkoutIds=new int[assignedWorkouts.size()];

for (int i=0; i<assignedWorkouts.size(); i++) {
	Workout workout=(Workout)assignedWorkouts.get(i);
	assignedWorkoutIds[i]=workout.getId();
}

ListIterator it=allAssignableWorkouts.listIterator();
while (it.hasNext()) {
	Workout w=(Workout)it.next();
	for (int j=0; j<assignedWorkoutIds.length; j++) {
		if (w.getId()==assignedWorkoutIds[j]) {
			it.remove();
			break;
		}
	}
}

int numWorkouts=assignedWorkouts.size();

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
<div class="standardAdminTextBlockWidth">

<%
int assignedWorkoutId=controller.getParamAsInt("assignedWorkoutId",0);
if (assignedWorkoutId>0) {
	Workout assignedWorkout=Workout.getById(assignedWorkoutId);
	%>
	<div style="color:#000000; border:1px solid #000000; padding:5px; background-color:#ff6600;"><i><b>Note:</b> the routine "<%=assignedWorkout.getName()%>" that you just created has been assigned to this user.</i></div><br />
	<%
}

int assignedExistingWorkoutId=controller.getParamAsInt("assignedExistingWorkoutId",0);
if (assignedExistingWorkoutId>0) {
	Workout assignedWorkout=Workout.getById(assignedExistingWorkoutId);
	%>
	<div style="color:#000000; border:1px solid #000000; padding:5px; background-color:#ff6600;"><i><b>Note:</b> the routine "<%=assignedWorkout.getName()%>" that you just selected has been assigned to this user.</i></div><br />
	<%
}


int unassignedWorkoutId=controller.getParamAsInt("unassignedWorkoutId",0);
if (unassignedWorkoutId>0) {
	Workout unassignedWorkout=Workout.getById(unassignedWorkoutId);
	%>
	<div style="color:#000000; border:1px solid #000000; padding:5px; background-color:#ff6600;"><i><b>Note:</b> the routine "<%=unassignedWorkout.getName()%>" has been unassigned from this user.</i></div><br />
	<%
}

%>

<span class="firstSentenceFont">Manage <%=assignToUser.getFormattedNameAndUsername()%>'s routines.</span><br />
Assign or unassign routines to <%=assignToUser.getFormattedNameAndUsername()%> on this screen, or click "create routine" below to create a new routine and assign it to <%=assignToUser.getFormattedNameAndUsername()%>.  To view this user's calorie spreadsheets, <a href="../workouts/calorieSpreadsheet.jsp?<%=controller.getSiteIdNVPair()%>&viewUserId=<%=assignToUser.getId()%>" target="_blank">click here</a>. (To see all workouts recorded by this user, click <a href="viewUserWorkouts.jsp?<%=controller.getSiteIdNVPair()%>&showLink=false&uid=<%=assignToUser.getId()%>">here</a>.)<%=HtmlUtils.doubleLB(request)%>


<%
if (assignedWorkouts.size()>0) {
	%><br />
	<font class="boldishFont">Kqool has assigned the following routines to this user.</font> Click an "unassign" button to remove a routine from the user's list:<%=HtmlUtils.doubleLB(request)%>
<table border="0" cellspacing="0" cellpadding="0" width="400">
<%=HtmlUtils.getHorizRuleTr(5, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>

<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="left" width="300" nowrap="nowrap"><font class="boldishColumnHeaderFont">Routines assigned  to <%=assignToUser.getFormattedNameAndUsername()%>&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>


<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(5, request)%>

<%

	for (int i=0; i<assignedWorkouts.size(); i++) {
		Workout workout=(Workout)assignedWorkouts.get(i);
		boolean workoutActive=(workout.getStatus()==Workout.STATUS_ACTIVE);
	
		%>
		<tr valign="middle" class=<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%> height="24">
		<%=HtmlUtils.getSingleRuleCell(request)%>
		<td align="left"><font class="columnDataFont">&nbsp;<br /></font></td>
		<td align="left" width="300" nowrap="nowrap"><font class="columnDataFont">&nbsp;<a href="#" onclick="showWorkout(<%=workout.getId()%>); return false"><%=workout.getName()%></a><%=workoutActive?"":" [deactivated]"%>&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td align="right"><font class="columnDataFont">&nbsp;
		<%=HtmlUtils.smallCpFormButton(false, "unassign", "location.href='processUnassign.jsp?"+controller.getSiteIdNVPair()+"&workoutId="+workout.getId()+"&userId="+assignToUser.getId()+"'", request)%>&nbsp;<br />
		</font></td>
	
	
	
		<%=HtmlUtils.getSingleRuleCell(request)%>
		</tr> 
		<%=HtmlUtils.getHorizRuleTr(5, request)%>
	<%

}
%>



</table><%
}
%>






<%
if (allAssignableWorkouts.size()>0) {
	%><br /><br />
<font class="boldishFont">To assign a routine to this user,</font> 
click an "assign" button in the list below (note: deactivated routines 
are not shown in this list, nor are routines already assigned to this user):<%=HtmlUtils.doubleLB(request)%>

<table border="0" cellspacing="0" cellpadding="0" width="400">
<%=HtmlUtils.getHorizRuleTr(5, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="left"><font class="boldishColumnHeaderFont">Assignable routines&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>


<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(5, request)%>

<%
boolean even=true;
for (int i=0; i<allAssignableWorkouts.size(); i++) {
	Workout workout=(Workout)allAssignableWorkouts.get(i);
	boolean workoutActive=(workout.getStatus()==Workout.STATUS_ACTIVE);
	%>
	<tr valign="middle" class="<%=even?"even":"odd"%>DataRow" height="24">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td align="left"><font class="columnDataFont">&nbsp;<br /></font></td>
	<td align="left" width="225" nowrap="nowrap"><font class="columnDataFont">&nbsp;<a href="#" onclick="showWorkout(<%=workout.getId()%>); return false"><%=workout.getName()%></a><%=workoutActive?"":" [deactivated]"%>&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="right"><font class="columnDataFont">&nbsp;
	<%=HtmlUtils.smallCpFormButton(false, "assign", ""+((!workoutActive)?"generalAlert('Deactivated routines cannot be assigned; you must activate this routine first.')":"location.href='showWorkout.jsp?"+controller.getSiteIdNVPair()+"&mode=assign&assignToUserId="+assignToUser.getId()+"&id="+workout.getId()+"'"), request)%>&nbsp;<br /></font></td>


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




<%=HtmlUtils.cpFormButton(false, "create routine", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=add&assignToUserId="+assignToUser.getId()+"'", request)%>
<%=HtmlUtils.cpFormButton(false, "cancel", "location.href='users.jsp?"+controller.getSiteIdNVPair()+"'", request)%><br />

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form>
</div>
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

