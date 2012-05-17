<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%
int workoutId=controller.getParamAsInt("workoutId");
String retUrl=controller.getParam("retUrl");
Workout workout=Workout.getById(workoutId);
workout.setDueDate(null);
workout.store();
%>
<script type="text/javascript">
alert("The deadline for the <%=workout.getName().replace('"','\'')%> routine will now be ignored.")
location.replace("<%=retUrl%>");
</script>


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

