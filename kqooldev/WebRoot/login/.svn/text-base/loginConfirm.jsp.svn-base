<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
 
%> 

<%
boolean accountCreated=controller.getParamAsBoolean("ac",false);
User user=controller.getSessionInfo().getUser();

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

<div id=<%=isPopup?"popupMainDiv":"mainDiv"%>>
<span class="standardTextBlockWidth">


<font class="bodyFont">
<%
// if we're here because, after going thru pamt process, we're here for the first time:
if (accountCreated) {
	%>
	<span class="firstSentenceFont">Account setup is complete.</span>  

	<%
}
else {
	%>
	<span class="firstSentenceFont">You are logged in.</span>
	<%
}
%>

<font color="#000000">
<ul>

</ul>
</font>

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

