<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setShowTopNav(false,request); %>
<% request.setAttribute("logoutPage", new Boolean(true)); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%
PageUtils.logoutUser(controller);
controller.getSessionInfo().setShowDisplayPasswordPage(false);
controller.getSessionInfo().setPostLoginDestinationUrl("../index.jsp");
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

<font class="bodyFont">

<span class="firstSentenceFont">You are now logged out.</span><br />
To log in again, please click the "log in" button below.<br />
<br /><br />

<%=HtmlUtils.cpFormButton(false, "log in", "location.href='../index.jsp?"+controller.getSiteIdNVPair()+"'", request)%>

<br /></font>
</span>

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

