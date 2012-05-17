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
String name="";
try
{
	CalorieExpendingActivity activity=CalorieExpendingActivity.getById(controller.getParamAsInt("id"));
	name=activity.getName();
	activity.delete();
	successParam="true";
}
catch (Throwable e)
{
	successParam="false";
}


controller.redirect("calorieExpendingActivities.jsp?"+controller.getSiteIdNVPair()+"&action=delete&name="+URLEncoder.encode(name)+"&success="+successParam);
%>


<%
%>

<%@ include file="/global/bottomInclude.jsp" %>







<% PageUtils.jspEnd(request); %>

