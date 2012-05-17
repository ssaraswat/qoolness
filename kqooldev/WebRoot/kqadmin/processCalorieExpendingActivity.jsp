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

String successParam;

try
{
	int numActivities=controller.getParamAsInt("numActivities");
	for (int i=0; i<numActivities; i++)
	{
		CalorieExpendingActivity activity=CalorieExpendingActivity.getById(controller.getParamAsInt("id"+i));
		activity.setName(controller.getParam("name"+i));
		activity.setCalsPerMinutePerLb(controller.getParamAsDouble("calsPerMinutePerLb"+i));
		activity.store();
	}
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}

controller.redirect("confirmActivityAction.jsp?"+controller.getSiteIdNVPair()+"&mode=edit&id="+URLEncoder.encode(controller.getParam("id0"))+"&success="+successParam);
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

