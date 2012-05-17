<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%


User user=controller.getSessionInfo().getUser();

String successParam;
int id=controller.getParamAsInt("id",0);



Workout workout=workout=Workout.getById(id);
workout.setStatus(Workout.STATUS_INACTIVE);
workout.store();



String nameForUserNotification;
if (workout.isPrescriptive()) {
	nameForUserNotification=workout.getName();
}
else {
	nameForUserNotification=DateFormat.getDateInstance(DateFormat.LONG).format(workout.getPerformedDate());
}

controller.redirect(controller.getParam("r")+"&n="+URLEncoder.encode(nameForUserNotification)+"&"+controller.getSiteIdNVPair());

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

