<% /*
Copyright (c) Steve Schneider 2002-2005..
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

User user=User.getById(controller.getParamAsInt("userId"));
String userStr=user.getFormattedNameAndUsername();
String emailAddr=user.getEmailAddress();
boolean isMale=user.getGender()==User.MALE;
boolean preChosenUser=controller.getParamAsBoolean("preChosenUser");

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

	if (trim(els["emailAddr"].value)==0)
	{
		errorAlert("You have not entered an email address.  Please enter one and try again.",els["emailAddr"])
		return false
	}
	if (!isValidEmail(els["emailAddr"].value))
	{
		errorAlert("'"+els["emailAddr"].value+"' is not a valid email address.  Please enter one and try again.",els["emailAddr"])
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
<span class="standardAdminTextBlockWidth">
<form action="processPfpRequest.jsp" onsubmit="return isValidForm(this)">
<input type="hidden" name="userId" value="<%=user.getId()%>" />
<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
<font class="bodyFont">


<%
if (preChosenUser) {
	%>
	<span class="firstSentenceFont">Want to request a personal-fitness profile from <%=userStr%>?</span><br />
	Just press the "send" button.
	(You may change <%=isMale?"his":"her"%> email address if needed first.)<br /><br />	
	<%
}
else {
	%>
	<span class="firstSentenceFont">Ready to send?</span><br />
	If <%=userStr%> has asked you to send the profile request to an email address 
	different from the one below, please
	enter <%=isMale?"his":"her"%> correct email address, then press the "send" 
	button.  Otherwise, just press the "send" button.<br /><br />	
	<%
}
%>

	
	<span class="boldishFont">Email Address</span><br />
	<input style="width:235px;" type="text" class="inputText" name="emailAddr" value="<%=emailAddr%>" /><br /><br /><br />
	
	<%=HtmlUtils.cpFormButton(true, "send", null, request)%>





<br />

<%=HtmlUtils.doubleLB(request)%><br />


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

