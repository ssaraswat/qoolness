<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_PREFS,request); %>

<%@ include file="/global/topInclude.jsp" %>
<%@ include file="includes/prefsInclude.jsp" %>


<%



User user=controller.getSessionInfo().getUser();

 
//for include of pfdForm.jsp:
request.setAttribute("controller", controller);
request.setAttribute("user", user);
request.setAttribute("retUrl", controller.getPathToAppRoot()+"userprefs/viewPfd.jsp?siteId="+controller.getSiteId());
request.setAttribute("settingUserId", user.getId());

request.setAttribute("tagline", "Tell us about yourself.");
request.setAttribute("introText", "Please provide us with the information requested below. We need it to formulate a workout program that's specifically tailored to your needs and goals.");
if (PfdItem.isUserHasHistoricalItems(user.getId())) {
	request.setAttribute("historicalText", "If you'd like to see historical data that you've since updated, go <a href=\"pfdHistorical.jsp?"+controller.getSiteIdNVPair()+"\">here</a>.");
}
request.setAttribute("historicalText", "<br/><br/>If you'd like to see fitness data you've since updated, go <a href=\"pfdHistorical.jsp?"+controller.getSiteIdNVPair()+"\">here</a>.");
request.setAttribute("medicalDisclaimer", "Note: None of the following questions are for diagnostic or treatment purposes.");
request.setAttribute("isAdminSection", new Boolean(false));
request.setAttribute("preSubmitButtonText", "");

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
pageContext.include("../global/pfdForm.jsp");
%>
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

