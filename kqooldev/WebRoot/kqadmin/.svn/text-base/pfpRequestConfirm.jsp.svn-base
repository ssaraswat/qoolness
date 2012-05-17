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

<%!

%>

<%

boolean success=controller.getParamAsBoolean("success",true);
String userFullname=controller.getParam("userFullname");
String mailSentToAddr=controller.getParam("emailAddr");


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
	<span class="firstSentenceFont">Mail has been sent...</span><br />
	 asking <%=userFullname%> to complete an online personal fitness profile.  
	 The message was sent to <a href="mailto:<%=mailSentToAddr%>"><%=mailSentToAddr%></a>.
	 When the client has completed the form, the results will be emailed to you.<br /><br />
	 If you do not hear from this client within a few days, you may want to follow up.


<%

}
else
{
	%>
	<span class="firstSentenceFont">There was a problem.</span><br />
	The email may or may not have been sent.

	<%
}
%>
<br /><br /><br />
<%=HtmlUtils.cpFormButton(false, "to main menu", "location.href='menu.jsp?"+controller.getSiteIdNVPair()+"'", request)%><br />



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

