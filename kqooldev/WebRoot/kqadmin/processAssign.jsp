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

%>

<%

boolean userIdSpecified=controller.getParamAsBoolean("userIdSpecified");


String successParam;
int userId=controller.getParamAsInt("userId");
int workoutId=controller.getParamAsInt("workoutId");
boolean sendMail=controller.getParamAsBoolean("sendMail");

User assignedToUser=new User();
Workout workout=new Workout();
try
{
	assignedToUser=User.getById(userId);
	workout=Workout.getById(workoutId);
	workout.setUserId(userId);
	workout.store();
	/*
	UserToWorkoutMapping mapping=new UserToWorkoutMapping();
	mapping.setUserId(userId);
	mapping.setWorkoutId(workoutId);
	mapping.store();
	*/
	
	if (sendMail) {
		MailUtils.sendWorkoutAssignmentMail(assignedToUser, workout, pageContext, controller);
	}

	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}

String userFullname=assignedToUser.getFormattedNameAndUsername();
String workoutName=workout.getName();
String mailSentToAddr=(sendMail?assignedToUser.getEmailAddress():"");


//if (!userIdSpecified) {
if (true) {
	controller.redirect("assignResult.jsp?"+controller.getSiteIdNVPair()+"&success="+successParam+"&userFullname="+URLEncoder.encode(userFullname)+"&workoutName="+URLEncoder.encode(workoutName)+"&mailSentToAddr="+URLEncoder.encode(mailSentToAddr)+"");
}
//else {
//	controller.redirect("userWorkouts.jsp?"+controller.getSiteIdNVPair()+"&id="+assignedToUser.getId()+"&assignedExistingWorkoutId="+workout.getId()+"&success="+successParam);
//}

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

