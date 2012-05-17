<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.ExerciseComparator" %>

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
boolean noCurrentData=controller.getParamAsBoolean("noCurrentData");
User user=User.getById(controller.getParamAsInt("userId"));
  
// for include of pfdForm.jsp:
request.setAttribute("controller", controller);
request.setAttribute("user", user);
request.setAttribute("retUrl", controller.getParam("retUrl"));
request.setAttribute("settingUserId", currentUser.getId());

if (noCurrentData) {
	request.setAttribute("tagline", "Add "+user.getFormattedNameAndUsername()+"'s fitness data here.");
	request.setAttribute("introText", "Please complete the client's personal-fitness-data form below, then click the \"submit\" button.  (Remember, you can also have email sent to the client requesting that they complete this form by clicking <a href=\"pfpRequestDetails.jsp?preChosenUser=true&siteId="+controller.getSiteId()+"&userId="+user.getId()+"\">here</a>.)");
}
else {
	request.setAttribute("tagline", "Edit "+user.getFormattedNameAndUsername()+"'s fitness data here.");
	request.setAttribute("introText", "Please make any required changes to this client's personal-fitness data then click the \"submit\" button.");
}
request.setAttribute("medicalDisclaimer", null);
request.setAttribute("isAdminSection", new Boolean(true));
request.setAttribute("preSubmitButtonText", null);



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

<%
pageContext.include("../global/pfdForm.jsp");
%>

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

