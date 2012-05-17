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

<%@ include file="/global/topInclude.jsp" %>

<%!

%> 

<%

SessionInfo sessionInfo=controller.getSessionInfo();

String username=(controller.getParam("username",""));
String firstName=(controller.getParam("firstName",""));
String lastName=(controller.getParam("lastName",""));
String emailAddress=(controller.getParam("emailAddress",""));
String comments=(controller.getParam("comments",""));
int gender=(controller.getParamAsInt("gender",0));
int errorCode=(controller.getParamAsInt("errorCode",0));


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

</script>

<style type="text/css">
 
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id=<%=isPopup?"popupMainDiv":"mainDiv"%>>
<span class="standardTextBlockWidth">

	<font class="bodyFont">

	
	<form action="processJoin.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 
<%
if (errorCode==1) {
		%><div class="errorDiv">Sorry, the username "<%=username%>" is already taken.  Please choose another one.</div><br /><br /><%
}
%>
		<span class="firstSentenceFont">Need some Qonvincing?</span><br />
		Here's what you can look forward to as a member of Kqool.com:<br /><br />
		
		For US$<%=siteProps.getStandardMonthlyCost()%> a month, you can open a Kqool account.  Once you're a member, you'll be served 
		up with several digital workout assignments a week &mdash; 
		each hand-tailored in frequency and intensity to your fitness goals by a certified personal trainer. 
		Every workout routine will consist of several exercises, each with a specified intensity and amount.  
		For example, you may receive an assignment like:
		<br /><br />
		&nbsp;&nbsp;Exercise: "Stairmaster"<br />
		&nbsp;&nbsp;Intensity: Level 13<br />
		&nbsp;&nbsp;Amount: 40 Minutes<br />
<br />
		or<br /><br />

		&nbsp;&nbsp;Exercise: Chest Press<br />
		&nbsp;&nbsp;Intensity: 125lbs<br />
		&nbsp;&nbsp;Amount: 3 sets of 12<br />
<br />

		Once you get your routine, you'll be able to print it out and take it with you to the gym 
		(here's a <a href="sampleSheet.html" target="_blank">sample printout</a>). Record what you actually 
		accomplish on this sheet - then use it to enter your progress into Kqool.com's Fitness Tracker. We'll take note of what you've done, and use that information to formulate your next workout.<br /><br />
		Pretty Kqool, eh?  We think so.  But that's not all.<br /><br />

		Besides the personalized workouts, you'll have access to streaming instructional fitness videos right on Kqool.com, as well as health and fitness-related articles.  And, of course, you'll always be able to <a href="#" onclick="launchFeedback(false); return false;">contact us</a> with your questions and concerns.<br /><br />
		
		
	
	


<%=HtmlUtils.doubleLB(request)%>


	<br /></font>
	
	
	<%=HtmlUtils.formButton(false,"back","location.href='join.jsp?"+controller.getSiteIdNVPair()+"'",request)%>

	</form>


      
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

