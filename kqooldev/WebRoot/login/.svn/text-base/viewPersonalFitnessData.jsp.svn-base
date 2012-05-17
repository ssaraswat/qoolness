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


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

// this page may load in a frame (e.g. on the "list" page), so don't allow that:

if (top.frames.length>0)
{
	top.location.replace(""+location.href)
}

function isValidForm(formObj)
{

	hidePageAndShowPleaseWait();
	return true;
}

</script>

<style type="text/css">
 
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<%
request.setAttribute("tagline", "Thanks!");
request.setAttribute("introText", "Your data has been saved and sent to your trainer. Here it is.");


pageContext.include("../global/viewPfd.jsp");
%>
<br/><br/><br/>
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

