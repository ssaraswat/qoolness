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

 
//for include of pfdForm.jsp:
request.setAttribute("controller", controller);
request.setAttribute("user", user);
request.setAttribute("retUrl", controller.getPathToAppRoot()+"workouts/viewPfd_weightFields.jsp?siteId="+controller.getSiteId());
request.setAttribute("settingUserId", user.getId());

request.setAttribute("tagline", "How much do you weigh?");
request.setAttribute("introText", "To give you effective fitness advice, we need to know what you weigh and what you'd like to weigh.  Please enter both here.");
if (PfdItem.isUserHasHistoricalItems(user.getId())) {
	request.setAttribute("historicalText", "If you'd like to see historical weight data, go <a href=\"pfdHistorical_weightFields.jsp?"+controller.getSiteIdNVPair()+"\">here</a>.");
}
request.setAttribute("medicalDisclaimer", null);
request.setAttribute("isAdminSection", new Boolean(false));
request.setAttribute("preSubmitButtonText", "");

request.setAttribute("weightFieldsOnly", new Boolean(true));


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

