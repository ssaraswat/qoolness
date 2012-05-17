<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<%@ include file="../../global/topInclude.jsp" %>
<%

List allExercises=null;

try {
	allExercises=Exercise.getAll();
}
catch (Throwable t) {}
if (allExercises==null) {
	allExercises=new ArrayList();
}

StringBuffer s=new StringBuffer("var "+controller.getParam("jsVarName")+"=[");
for (int i=0; i<allExercises.size(); i++)
{
	if (i>0)
	{
		s.append(",");
	}
	Exercise exercise=(Exercise)allExercises.get(i);
	s.append("\""+exercise.getName()+"\"");
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



