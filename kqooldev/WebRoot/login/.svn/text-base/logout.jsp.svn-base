<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>
<% PageUtils.setShowTopNav(false,request); %>
<% request.setAttribute("logoutPage", new Boolean(true)); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%
PageUtils.logoutUser(controller);
controller.getSessionInfo().setShowDisplayPasswordPage(false);
controller.getSessionInfo().setPostLoginDestinationUrl(null);
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

<span class="standardTextBlockWidth">

<font class="bodyFont">







<span class="firstSentenceFont">You are now logged out.</span><br />
(But you're still logged into our hearts.)<br /><br />

If you'd like to log in as another user, please click the "log in" button below.
Or, if you're already having separation anxiety, feel free to log back in.<br />
<br /><br />

<%=HtmlUtils.formButton(false, "logIn", "location.replace('login.jsp?"+controller.getSiteIdNVPair()+"&isPopup="+isPopup+"')", request)%>

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

