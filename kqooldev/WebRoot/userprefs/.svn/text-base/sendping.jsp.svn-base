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


	var password=trim(els["password"].value)
	var retypepassword=trim(els["retypepassword"].value)
	if (""+password!=""+retypepassword)
	{
		errorAlert("The password and the retyped password do not match.  Please fix and try again. (Note that you should leave these two fields blank unless you wish to change your password.)",els["retypepassword"])
		return false
	}
	



 	
 	// If we've gotten this far, then we know that all fields that should have something in
 	// them do; now make sure all field values are valid:
 	

	if (trim(els["password"].value).length>0 && !isValidPassword(trim(els["password"].value)))
	{
		errorAlert("The password \""+trim(els["password"].value)+"\" is not valid; passwords may contain only letters, numbers, underscores, dashes, and periods, and must be between "+PASSWORD_MIN_LENGTH+" and "+PASSWORD_MAX_LENGTH+" characters long. Please fix and try again. (Note that you should leave these two fields blank unless you wish to change your password.)",els["password"])
		return false
	}

	if (!isValidEmail(trim(els["emailAddress"].value)))
	{
		errorAlert("The email address \""+trim(els["emailAddress"].value)+"\" is not valid; 'john@mymail.com'is an example of a valid email address.  Please fix and try again.",els["emailAddress"])
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

<form name="theform">kj
<% pageContext.include("../global/calendarLauncherInclude.jsp"); %>

</form>
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

