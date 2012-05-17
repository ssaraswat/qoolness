<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_SECTION_HOME,request); %>



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

function isValidForm(formObj)
{
	var els=formObj.elements

	if (trim(els["firstName"].value).length==0)
	{
		errorAlert("You have not supplied a first name; this field is required. Please fix and try again.",els["firstName"])
		return false
	}

	if (trim(els["lastName"].value).length==0)
	{
		errorAlert("You have not supplied a last name; this field is required. Please fix and try again.",els["lastName"])
		return false
	}

	if (trim(els["emailAddress"].value).length==0)
	{
		errorAlert("You have not supplied an email address; this field is required. Please fix and try again.",els["emailAddress"])
		return false
	}

	if (trim(els["emergencyContact"].value).length==0)
	{
		errorAlert("You have not supplied emergency contact; this field is required. Please fix and try again.",els["emergencyContact"])
		return false
	}


	var password=els["password"].value
	var retypepassword=els["retypepassword"].value
	if (""+password!=""+retypepassword)
	{
		errorAlert("The password and the retyped password do not match.  Please fix and try again. (Note that you should leave these two fields blank unless you wish to change your password.)",els["retypepassword"])
		return false
	}
	



 	
 	// If we've gotten this far, then we know that all fields that should have something in
 	// them do; now make sure all field values are valid:
 	

	if (els["password"].value.length>0 && !isValidPassword(els["password"].value))
	{
		errorAlert("The password \""+els["password"].value+"\" is not valid; passwords may contain only letters, numbers, underscores, dashes, and periods, and must be between "+PASSWORD_MIN_LENGTH+" and "+PASSWORD_MAX_LENGTH+" characters long. Please fix and try again. (Note that you should leave these two fields blank unless you wish to change your password.)",els["password"])
		return false
	}

	if (!isValidEmail(els["emailAddress"].value))
	{
		errorAlert("The email address \""+els["emailAddress"].value+"\" is not valid; 'john@mymail.com'is an example of a valid email address.  Please fix and try again.",els["emailAddress"])
		return false
	}


	hidePageAndShowPleaseWait()
	return true
}

</script> 

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardTextBlockWidth">
<form action="processPrefs.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">

<font class="bodyFont">
<span class="standardTextBlockWidth">
<span class="firstSentenceFont">Yours.  All Yours.</span><br />
All Kqool.com workouts are unique to you, whether you or Kqool assigned them.
Each time you log in you'll be given the option to review all of them.<br /><br />

Kqool.com has divided your fitness regimen into two separate categories. 
Exercise programs that you have yet to complete are <i>routines</i>.
Exercise programs that you have conquered, dominated, or... feebly attempted to complete, are <i>workouts</i>.<br /><br />


Sub-Categories are listed below.<br /><br />

<b>Your Routines</b><br />
(or workouts-to-be):<%=HtmlUtils.doubleLB(request)%>

<table border="0" cellspacing="0" cellpadding="0" width="250">
<tr>
<td nowrap="nowrap" width="10">&nbsp;<br /></td>
<td class="bodyFont">
<a href="workoutList.jsp?<%=controller.getSiteIdNVPair()%>&selfAssign=false&prescriptive=true">Kqool-Assigned</a> - 
Take this routine and call us in the morning.
Routines formulated specifically for you by  Kqool.<br /><br />

<a href="workout.jsp?<%=controller.getSiteIdNVPair()%>&mode=add&prescriptive=true">Add-a-Routine</a> - 
<i>Make</i> this routine and call us in the morning.
A template to create and save a routine for yourself.  Once completed and saved, 
you will be able to access these routines in Self-Assigned (see next item).<br /><br />

<a href="workoutList.jsp?<%=controller.getSiteIdNVPair()%>&selfAssign=true&prescriptive=true">Self-Assigned</a> -
Re-Take this routine and call us in the morning. Routines you've already put together for yourself<br /><br />
</td>
</tr>
</table>
<br />
<b>Your Workouts</b><br />
(or ghosts of routines past...)<%=HtmlUtils.doubleLB(request)%>

<table border="0" cellspacing="0" cellpadding="0" width="250">
<tr>
<td nowrap="nowrap" width="10">&nbsp;<br /></td>
<td class="bodyFont">
<a href="workoutList.jsp?<%=controller.getSiteIdNVPair()%>&selfAssign=true&prescriptive=false">View Past Workouts</a> - 
Routines you have completed and recorded in Record a Workout (see next item).  You can view past routines to track your progress.<br /><br />
<a href="workout.jsp?<%=controller.getSiteIdNVPair()%>&mode=add&prescriptive=false">Record a Workout</a> - 
Log the results of your routine and save it.  Kqool will look over the progress you've recorded, and help you to formulate new routines.


</td>
</tr>
</table>


</span>







</div>

<%=HtmlUtils.doubleLB(request)%>


<br /></font>

</form></span>
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

