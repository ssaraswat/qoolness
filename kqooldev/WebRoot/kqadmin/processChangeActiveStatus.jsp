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

int workoutId=controller.getParamAsInt("workoutId");
boolean deactivate=controller.getParamAsBoolean("deactivate");


String successParam;

try
{
	Workout workout=Workout.getById(workoutId);
	workout.setStatus(deactivate?Workout.STATUS_INACTIVE:Workout.STATUS_ACTIVE);
	workout.store();
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}

controller.redirect("changeActiveStatusResult.jsp?"+controller.getSiteIdNVPair()+"&id="+workoutId+"&deactivate="+deactivate+"&success="+successParam);
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

