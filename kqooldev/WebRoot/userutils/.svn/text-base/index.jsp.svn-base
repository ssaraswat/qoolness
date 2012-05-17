<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_UTILS,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%

User user=controller.getSessionInfo().getUser();


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

<div id="mainDiv">


<font class="bodyFont">
<span style="width:250px; display:block;">


  


<div style="width:250px;">
<span class="firstSentenceFont">And whoever said...</span><br />
..."tools are for carpenters," never visited Kqool.com either. (Who are these people???)<br /><br />
	

	Right now, we've got two; more are on the way: one will help you to determine what your weight should be if you want to look and feel your best; the other will give you some idea of how many calories you'll burn if you perform them for a certain period of time (and yes, it <i>will</i> tell you how many calories it takes to watch TV for two hours, but the answer might sting a little.)<%=HtmlUtils.doubleLB(request) %><br />

	
	
	<% /*
	<b>Personal Calorie Spreadsheet</b><br />
	Hour-by-hour, day-by-day, week-by-week, use this spreadsheet to keep track of how many calories you take in and how many you burn off.  It's not all about calories, but... a lot of it's about calories.<br />
	<a href="calorieSpreadsheet.jsp?< % = controller.getSiteIdNVPair() % >" ><img style="margin:0px; margin-top:5px;" src="../images/smallerButtons/go.gif" height="19" width="49" border="0" /></a><br clear="all" /><br /><br />
	*/ %>
	
	<b>Calories-Burned Calculator</b><br />
	How many calories will you burn bicycling for an 90 minutes?  What about hiking for four hours?  What about brushing our teeth?  What about... TV?  This calculator will tell you.<br />
	<a href="#" onclick="launchCaloriesExpendedCalculator(); return false"><img style="margin:0px; margin-top:5px;" src="../images/smallerButtons/go.gif" height="19" width="49" border="0" /></a><br clear="all" /><br /><br />
	
	
	
	<b>Target-Weight Calculator</b><br />
	How much you should weigh depends on several factors, including your bone structure, how muscular you are, your height, and of course what makes you feel healthiest.  This calculator will get you started.<br />
	<a href="#" onclick="launchTargetWeightCalculator(); return false"><img style="margin:0px; margin-top:5px;" src="../images/smallerButtons/go.gif" height="19" width="49" border="0" /></a><br clear="all" /><br /><br />
	
	
</div>

</span>
<br />




<br />




</div>

<%=HtmlUtils.doubleLB(request)%><br />


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

