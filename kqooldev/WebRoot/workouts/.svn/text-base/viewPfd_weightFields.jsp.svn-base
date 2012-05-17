<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>
<%@ include file="../userprefs/includes/prefsInclude.jsp" %>


<%



User user=controller.getSessionInfo().getUser();


request.setAttribute("controller", controller);
request.setAttribute("user", user);
request.setAttribute("tagline", "Changes noted.");
request.setAttribute("introText", "Your changes have been saved and sent to your trainer. Here are your new values:");
request.setAttribute("weightFieldsOnly", new Boolean("true"));


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

</script> 

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>
<div style="width:300px;">

<%
pageContext.include("../global/viewPfd.jsp");
%>
<br/><br/><br/>
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

