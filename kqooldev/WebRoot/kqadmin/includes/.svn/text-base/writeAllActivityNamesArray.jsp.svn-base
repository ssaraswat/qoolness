<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<%@ include file="../../global/topInclude.jsp" %>
<%

List allActivities=null;

try {
	allActivities=CalorieExpendingActivity.getAll();
}
catch (Throwable t) {}
if (allActivities==null) {
	allActivities=new ArrayList();
}

StringBuffer s=new StringBuffer("var "+controller.getParam("jsVarName")+"=[");
for (int i=0; i<allActivities.size(); i++)
{
	if (i>0)
	{
		s.append(",");
	}
	CalorieExpendingActivity activity=(CalorieExpendingActivity)allActivities.get(i);
	s.append("\""+activity.getName()+"\"");
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



