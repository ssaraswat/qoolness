<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_PERSONAL_FITNESS_PROFILE,request); %>
<% PageUtils.setShowTopNav(false,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%!

%>

<%

User user=null;
boolean userFound;
try {
	user=User.getByUsername(GeneralUtils.wDecrypt(controller.getParam("n")));
	if (user==null) {
		throw new RuntimeException("User not found.");
	}
	userFound=true;
}
catch (RuntimeException e) {
	userFound=false;
}
  
// for include of pfdForm.jsp:
request.setAttribute("controller", controller);
request.setAttribute("user", user);
request.setAttribute("retUrl", controller.getPathToAppRoot()+"login/viewPersonalFitnessData.jsp?n="+GeneralUtils.wEncrypt(user.getUsername())+"&siteId="+controller.getSiteId());
request.setAttribute("settingUserId", user.getId());

request.setAttribute("tagline", "Tell us about yourself.");
request.setAttribute("introText", "Please provide us with the information requested below. We need it to formulate a workout program that's specifically tailored to your needs and goals.");
request.setAttribute("medicalDisclaimer", "Note: None of the following questions are for diagnostic or treatment purposes.");
request.setAttribute("isAdminSection", new Boolean(false));
request.setAttribute("preSubmitButtonText", "Thank you for telling us who you are.  Now get ready to change that for the better. Click \"submit\" below.");



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

// this page may load in a frame (e.g. on the "list" page), so don't allow that:


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

