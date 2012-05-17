<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_OTHER,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

boolean success=controller.getParamAsBoolean("success",true);
int id=controller.getParamAsInt("id");
String mode=controller.getParam("mode");

String name="";
if (mode.equals("edit")) {
	CalorieExpendingActivity activity=CalorieExpendingActivity.getById(id);
	name=activity.getName();
}



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">

</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardAdminTextBlockWidth">
<form>
<font class="bodyFont">


<%
if (success)
{
	if (mode.equals("add")) {
		%>
		<span class="firstSentenceFont">Success:</span><br />
		You have successfully added one or more calorie-expending activities. 
		To return to the main admin menu, click
		"to main menu." To perform other actions, use the pulldown menus above. <% pageContext.include("includes/calsExpendedPopupLink.jsp"); %><br /><br /><br /><%
	}
	else if (mode.equals("edit")) {
		%>
		<span class="firstSentenceFont">Success:</span><br />
		You have successfully edited the "<%=name%>" activity. To return to the list 
		of activities, click "back to list"; to return to the main admin menu, click
		"to main menu." To perform other actions, use the pulldown menus above. <% pageContext.include("includes/calsExpendedPopupLink.jsp"); %><br /><br /><br />
		
		<%=HtmlUtils.cpFormButton(false, "back to list", "location.href='calorieExpendingActivities.jsp?"+controller.getSiteIdNVPair()+"'", request)%> <%
	}




}
else
{
	%>
	<span class="firstSentenceFont">There was a problem.</span><br />Some or all of your data may not have been saved. <% pageContext.include("includes/calsExpendedPopupLink.jsp"); %><br /><br /><br />

	<%
}
%>




<%=HtmlUtils.cpFormButton(false, "to main menu", "location.href='menu.jsp?"+controller.getSiteIdNVPair()+"'", request)%>

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form></span>
</div>

<%@ include file="/global/bodyClose.jsp" %>

</html>

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

