<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.*" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% /* PageUtils.setRequiredLoginStatus("backenduser",request); */ %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%


boolean showDetails=controller.getParamAsBoolean("showDetails", true);
boolean containInBox=controller.getParamAsBoolean("containInBox", true);

int sort=controller.getParamAsInt("sort", UserComparator.LAST_NAME);

int assignToUserId=controller.getParamAsInt("assignToUserId",0);
boolean userIdSpecified=assignToUserId>0;
User assignToUser;
if (userIdSpecified) {
	assignToUser=User.getById(assignToUserId);
}
else {
	assignToUser=new User();
}

List allUsers;
if (true) {
	allUsers=(List)controller.getAttr("allUsers");
	if (allUsers==null) {
		throw new JspException("allUsers list not found in request; this is required when this file is included.");
	}
}
else {
	allUsers=User.getAll();
	if (allUsers==null) {
		allUsers=new ArrayList(0);
	}	
}




Collections.sort(allUsers, new UserComparator(sort));

String mode=controller.getParam("mode"); // "add" or "edit"
boolean success=controller.getParamAsBoolean("success",true);
int id=controller.getParamAsInt("id");

Workout workout=Workout.getById(id);
String name=workout.getName();
String comments=workout.getComments();
ExerciseDetail.loadExerciseDetailsInto(workout);
NumberFormat fmt=NumberFormat.getInstance();
fmt.setGroupingUsed(false);


List intensityMeasuresList;
List quantityMeasuresList;
HashMap intensityCodesToNamesMap;
HashMap quantityCodesToNamesMap;

if (true) {
	intensityCodesToNamesMap=(HashMap)controller.getAttr("intensityCodesToNamesMap");
	if (intensityCodesToNamesMap==null) {
		throw new JspException("intensityCodesToNamesMap map not found in request; this is required when this file is included.");
	}
	quantityCodesToNamesMap=(HashMap)controller.getAttr("quantityCodesToNamesMap");
	if (quantityCodesToNamesMap==null) {
		throw new JspException("quantityCodesToNamesMap map not found in request; this is required when this file is included.");
	}
}
else {
	intensityMeasuresList=ExerciseIntensityMeasure.getAll();
	quantityMeasuresList=ExerciseQuantityMeasure.getAll();
	intensityCodesToNamesMap=new HashMap(intensityMeasuresList.size());
	quantityCodesToNamesMap=new HashMap(quantityMeasuresList.size());
	for (int i=0; i<intensityMeasuresList.size(); i++) {
		ExerciseIntensityMeasure m=(ExerciseIntensityMeasure)intensityMeasuresList.get(i);
		intensityCodesToNamesMap.put(m.getCode(),m.getName());
	}
	for (int i=0; i<quantityMeasuresList.size(); i++) {
		ExerciseQuantityMeasure m=(ExerciseQuantityMeasure)quantityMeasuresList.get(i);
		quantityCodesToNamesMap.put(m.getCode(),m.getName());
	}	
}

boolean showIntroText=controller.getParamAsBoolean("showIntroText", true);


%>
<style type="text/css"">
.ruleRow {background-color:#eeeeee; border:0px solid #ffffff;}
</style>


<form method="post" action="<%
if (mode.equals("assign")) {
	%>processAssign.jsp?<%=controller.getSiteIdNVPair()%><%
}
else if (mode.equals("deactivate")) {
	%>processChangeActiveStatus.jsp?<%=controller.getSiteIdNVPair()%>&deactivate=true<%
}
else if (mode.equals("activate")) {
	%>processChangeActiveStatus.jsp?<%=controller.getSiteIdNVPair()%>&deactivate=false<%
}
else {
	%>#<%
}
%>" onsubmit="<%
if (mode.equals("assign") && !userIdSpecified) {
	%>return isValidAssignForm(this)<%
}
else {
	%>return true<%
}
%>">

<%
if (userIdSpecified) {
	%>
	<input type="hidden" name="userIdSpecified" value="<%=userIdSpecified%>" />
	<%
}
%>


<font class="bodyFont">


<%
if (success)
{
	if (showIntroText) {
		if (!controller.getParamAsBoolean("isPopup", false)) {
			if (mode.equals("view"))
			{
				%>
				<span class="firstSentenceFont">Here is the "<%=name%>" routine.</span><br /><br />
	
				<%
			}
			else if (mode.equals("edit"))
			{
				%>
				<span class="firstSentenceFont">Your changes to the "<%=name%>" routine have been made.</span><br />The changes are shown below.<br /><br />
	
				<%
			}
			else if (mode.equals("add") || mode.equals("copy"))
			{
				%>
				<span class="firstSentenceFont">Your have created the "<%=name%>" routine.</span><br />It appears below.<br /><br />
	
				<%
			}
			else if (mode.equals("deactivate"))
			{
				%>
				<span class="firstSentenceFont">You are about to deactivate 
				the "<%=name%>" routine</span><br />
				shown below. Are you sure you want to do this? 
				Deactivating does not delete the routine from the database, but users cannot
				see deactivated routines.  (You can always re-activate this routine
				later.)  If you wish to deactivate the "<%=name%>" routine, please click
				the "deactivate" button below.<br /><br />
				<%
			}
			else if (mode.equals("activate"))
			{
				%>
				<span class="firstSentenceFont">You are about to re-activate 
				the "<%=name%>" routine</span><br />
				shown below. If this routine is currently 
				assigned to any users, they will now be able to see this routine.
				To re-activate the "<%=name%>" routine, please click
				the "activate" button below.<br /><br />
				<%
			}
			else if (mode.equals("assign"))
			{
				if (!userIdSpecified) {
					%>
					<span class="firstSentenceFont">You are about to assign</span><br />
					 the routine below to
					 a kqool.com user.  Please choose the 
					user from the list below, indicate if the user should receive email 
					notification of the assignment,
					and click the "assign" button at the bottom of the page.<%=HtmlUtils.doubleLB(request)%><br />
					<font class="boldishFont">Choose user</font><br />
					<select name="userId" class="selectText" style="width:300px; ">
					<option value="">...</option>
					<%
					for (int i=0; i<allUsers.size(); i++) {
						User user=(User)allUsers.get(i);
						if (!user.isBackendUser() && (user.getStatus()==User.STATUS_ACTIVE || user.getStatus()==User.STATUS_PREACTIVE)) {
							String label; 
							switch (sort) {
								case UserComparator.LAST_NAME: label=user.getLastName()+", "+user.getFirstName()+" ("+user.getUsername()+")"; break;
								case UserComparator.FIRST_NAME: label=user.getFirstName()+" "+user.getLastName()+" ("+user.getUsername()+")"; break;
								case UserComparator.USERNAME: label=user.getUsername()+" ("+user.getLastName()+", "+user.getFirstName()+")"; break;
								default: throw new FatalApplicationException("Unrecognized sort parameter.");
							}
							%>
							<option value="<%=user.getId()%>"><%=label%></option>
							<%
						}
					}
					%>
					</select><br />
					Sort above list of users by:
					
					<a <%=sort!=UserComparator.LAST_NAME?"":"x"%>href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&mode=assign&id=<%=id%>&sort=<%=UserComparator.LAST_NAME%>">last</a> |
					<a <%=sort!=UserComparator.FIRST_NAME?"":"x"%>href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&mode=assign&id=<%=id%>&sort=<%=UserComparator.FIRST_NAME%>">first</a> | 
					<a <%=sort!=UserComparator.USERNAME?"":"x"%>href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&mode=assign&id=<%=id%>&sort=<%=UserComparator.USERNAME%>">username</a><%=HtmlUtils.doubleLB(request)%>
					<%
				}
				else { // user id specified:
					%>
					<span class="firstSentenceFont">You are about to assign the routine below to 
					<%=assignToUser.getFormattedNameAndUsername()%>.</span><br />
					  Please indicate 
					 if the user should receive email 
					notification of the assignment,
					and click the "assign" button.<%=HtmlUtils.doubleLB(request)%><br />
					<input name="userId" type="hidden" value="<%=assignToUserId%>" />
					<%
				}
				%>
				<input type="checkbox" name="sendMail" value="true" id="sendMailTrue" checked="true" /><label for="sendMailTrue">Notify this user via e-mail</label><br /><br />
				<font class="boldishFont">Routine to be assigned:</font><br /><br /><br />
				<%
			}
		}
	}
}
else
{
	%>
	<span class="firstSentenceFont">There was a problem.</span> Some or all of your data may not have been saved.<br /><br />

	<%
}
%>

<input type="hidden" name="workoutId" value="<%=id%>" />


<% 
// set values for included jsp --

request.setAttribute("prescriptive",new Boolean(controller.getParamAsBoolean("prescriptive",true)));
request.setAttribute("workoutId",new Integer(id));
request.setAttribute("name",workout.getName());
request.setAttribute("comments",workout.getComments());
request.setAttribute("workout",workout);
request.setAttribute("fmt", fmt);
request.setAttribute("quantityCodesToNamesMap",quantityCodesToNamesMap);
request.setAttribute("intensityCodesToNamesMap",intensityCodesToNamesMap);
request.setAttribute("workoutDate",new Date(0));
request.setAttribute("administratorAssigned",new Boolean(true));
request.setAttribute("isAdminSection",new Boolean(true));
request.setAttribute("showDetails",new Boolean(showDetails));
request.setAttribute("containInBox",new Boolean(containInBox));
request.setAttribute("showToMainMenuButton",new Boolean(false));


pageContext.include("../workouts/includes/displayWorkout.jsp"); %>


</font>

</form>





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

