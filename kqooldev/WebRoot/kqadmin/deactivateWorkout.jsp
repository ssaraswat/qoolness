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

<%!

%>

<%
String retUrl=controller.getParam("retUrl");
int id=controller.getParamAsInt("id");
Workout workout=Workout.getById(id);
if (workout!=null) {
	workout.setStatus(Workout.STATUS_INACTIVE);
	workout.store();
}
%>

<script type="text/javascript">
alert("The routine \"<%=workout.getName()%>\" has been deactivated.")
</script>

<%
out.flush();
response.flushBuffer();
out.flush();

%>
<script type="text/javascript">
location.replace("<%=retUrl%>")
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

