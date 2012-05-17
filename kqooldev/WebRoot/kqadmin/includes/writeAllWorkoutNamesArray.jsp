<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<%@ include file="../../global/topInclude.jsp" %>
<%

List allWorkouts=Workout.getAllAdministratorAssigned();
if (allWorkouts==null) {
	allWorkouts=new ArrayList();
}

StringBuffer s=new StringBuffer("var "+controller.getParam("jsVarName")+"=[");
for (int i=0; i<allWorkouts.size(); i++)
{
	if (i>0)
	{
		s.append(",");
	}
	Workout workout=(Workout)allWorkouts.get(i);
	s.append("\""+workout.getName()+"\"");
}
s.append("]");
out.print(s.toString());
%>


<%@ include file="../../global/bottomInclude.jsp" %>


<%
if (pageException!=null)
{
	%>
	<%@ include file="../../global/jspErrorDialogLaunch.jsp" %>
	<%
}
%>



