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

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">


<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv"><br />
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">


	<span class="firstSentenceFont">An account for this user already exists.</span><br />
	
	<%=controller.getParam("n")%> has set up recurring payments on PayPal and
	created an account for himself or herself (username 
	"<%=controller.getParam("u")%>", without the quotes),
	 so no further action is currently necessary
	for this user.<%=HtmlUtils.doubleLB(request)%>
	<b>However,</b> as a precaution you should look for an email in your inbox
	entitled "You have a new subscriber to Kqool.com standard membership."  Open it and make
	sure that the user has set up payments for the correct monthly amount
	($<%=siteProps.getStandardMonthlyCost()%>).
	It is possible for "unsavory" users to alter the monthly amount that they pay to Kqool.  The 
	solution, should you find that a user has done this, is to suspend his or her account until
	you resolve the situation with him or her.  You can suspend a user's membership by choosing "view/edit (active)
	from the "users..." menu above.</span><%=HtmlUtils.doubleLB(request)%></font>
<%=HtmlUtils.cpFormButton(false, "to main menu", "location.href='menu.jsp?"+controller.getSiteIdNVPair()+"'", request)%><br />

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

