<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

boolean success=controller.getParamAsBoolean("success",true);
String userFullname=controller.getParam("userFullname");
String workoutName=controller.getParam("workoutName");
String mailSentToAddr=controller.getParam("mailSentToAddr");


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

	%>
	<span class="firstSentenceFont">The routine "<%=workoutName%>" has 
	been assigned</span><br />
	 to <%=userFullname%><%
	if (mailSentToAddr.trim().length()>0) {
		%> and an e-mail has been sent to <a href="mailto:<%=mailSentToAddr%>"><%=mailSentToAddr%></a> notifying him 
		or her of this.<%
	}
	else {
		%>; note that you opted not to send an email to this user notifying him or her of the new assignment.<%
	}


}
else
{
	%>
	<span class="firstSentenceFont">There was a problem.</span><br />
	Some or all of your data may not have been processed/stored.

	<%
}
%>
<br /><br /><br />
<%=HtmlUtils.cpFormButton(false, "toMainMenu", "location.href='menu.jsp?"+controller.getSiteIdNVPair()+"'", request)%><br />



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

