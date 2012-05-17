<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>
<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>

<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<%@ include file="/global/topInclude.jsp" %>
<%




String successParam;
int userId=controller.getParamAsInt("userId");
int workoutId=controller.getParamAsInt("workoutId");

try
{
	/*
	UserToWorkoutMapping.delete(userId, workoutId);
	*/
	Workout workout=Workout.getById(workoutId);
	workout.setUserId(0);
	workout.store();
	
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}



controller.redirect("userWorkouts.jsp?"+controller.getSiteIdNVPair()+"&id="+controller.getParamAsInt("userId")+"&unassignedWorkoutId="+controller.getParamAsInt("workoutId")+"&success="+successParam);


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
