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

controller.getSessionInfo().setShowDisplayPasswordPage(false);



String currentLoginStatus=PageUtils.nonNull(sessionInfo.getLoginStatus()).trim().toLowerCase();
boolean currentlyLoggedIn=(currentLoginStatus.equals("user") || currentLoginStatus.equals("backenduser"));
PageUtils.setShowTopNav(currentlyLoggedIn,request);

int errorCode=controller.getParamAsInt("errorCode",0);

String requiredUserTypeForLogin=PageUtils.nonNull(sessionInfo.getRequiredUserTypeForLogin()).trim().toLowerCase();

String username=controller.getParam("username").trim();



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
	var els=formObj.elements

	if (trim(els["username"].value).length==0)
	{
		errorAlert("You have not entered a username.  Please enter one and try again.",els["username"])
		return false
	}
	hidePageAndShowPleaseWait()
	return true
}

function forgotPassword() {
	var url="forgotPassword.jsp?<%=controller.getSiteIdNVPair()%>&username="+escape(document.forms["mainForm"].elements["username"].value)
	location.href=url
}

</script>

<style type="text/css">
 
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id=<%=isPopup?"popupMainDiv":"mainDiv"%>>
<span class="standardTextBlockWidth">

<%
if (!currentlyLoggedIn)
{
	%>
	<form action="processLogin.jsp?<%=controller.getSiteIdNVPair()%>&isPopup=<%=(isPopup?"true":"false")%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 
	<font class="bodyFont">
	<%
	if (errorCode==0) // no error:
	{
		%>
		<span class="firstSentenceFont">Please log in.</span><br />Enter your username and password, then and press the "log in" button. 
		<%
	}
	else if (errorCode==2) // backenduser needed, but user found:
	{
		%>
		<span class="firstSentenceFont">There's a problem.</span><br />The page you were trying to access requires backend-user privileges, 
		but your account does not have these privileges.  You may attempt to log in below again with a username that has backend-user privileges.
		<%	
	}
	else if (errorCode==11 || errorCode==12 || errorCode==15) // invalid username or password, or unrecognized username, or deactivated; we give the user the same message in all cases:
	{
		%>
		<span class="firstSentenceFont">There's a problem.</span><br />Either you entered an unrecognized username, or the password you entered did not match the username. Please try again.  If you continue to have difficulty, please send mail <a href="mailto:<%=siteProps.getCommentsEmailAddress()%>">here</a>.
		<%	
	}
	else if (errorCode==13)
	{
		%>
		<span class="firstSentenceFont">There's a problem.</span><br />The account "<%=username%>" exists but has not been activated, probably because kqool.com has not been notified tht you have made monthly payment arrangements (with PayPal or otherwise).  You may want to send mail <a href="mailto:<%=siteProps.getCommentsEmailAddress()%>">here</a>.
		<%	
	}
	else if (errorCode==14)
	{
		%>
		<span class="firstSentenceFont">There's a problem.</span>The account "<%=username%>" has been suspended.  If you believe it should be reactivated, please send mail <a href="mailto:<%=siteProps.getCommentsEmailAddress()%>">here</a>.
		<%	
	}
	else if (errorCode==14)
	{
		%>
		<span class="firstSentenceFont">There was a problem processing your login. Please try again.</span>
		<%	
	}


	%>

	If you are not a Kqool member but would like to be, please <a href="join.jsp?<%=controller.getSiteIdNVPair()%>">join</a>, or send an e-mail <a href="mailto:<%=siteProps.getCommentsEmailAddress()%>">here</a>. We'll praise you for your excellent decision-making skills.
		<%



	if (requiredUserTypeForLogin.equals("backenduser") && errorCode!=2)
	{
		%>
		<b>Note that the page you are attempting to access requires backend-user privileges.  If you are a user without 
		these privileges, you will not be able to access the page.</b>
		<%
	}
	%>
	


	<%=HtmlUtils.doubleLB(request)%><br />
	<form action="processLogin.jsp?<%=controller.getSiteIdNVPair()%>&isPopup=<%=(isPopup?"true":"false")%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 

	<span class="boldishFont">Username</span><br />
	<input class="inputText" type="text" size="16" name="username" id="username" value="<%=username%>"><br />
	<a href="join.jsp?<%=controller.getSiteIdNVPair()%>" tabindex="-1">Don't have one?  Join now.</a><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Password</span><br />
	<input class="inputText" type="password" size="16" name="password" id="password" value=""><br />	
	<a href="#" onclick="forgotPassword(); return false" tabindex="-1">Forgot your password?</a><br />
			<span style="font-size:11px;">Note: if you have an account<br />
			but have never logged in,<br />
			you don't need a password.</span><br />
	
<br />
	<%=HtmlUtils.formButton("logIn", request)%><%=HtmlUtils.doubleLB(request)%>
	

	<br /></font>

	</form>
	<%
}
else
{
	// user is already logged in:
	%>              
	<form action="#" onsubmit="return false">
	<font class="bodyFont">    
	<span class="firstSentenceFont">You are logged in.</span><br />
	You are currently logged in as user "<%=currentUser.getUsername()%>".  <%
	if (requiredUserTypeForLogin.equals("backenduser") && !(currentUser.isBackendUser()))
	{
		%>
	<B>However, the page you are trying to access is available only to backend users, and the user "<%=currentUser.getUsername()%>" 
	does not have backend privileges. If you wish to access this page, you must log out (by clicking "log out" below) and log 
	back in as a backend user, or have a backend user perform this task for you.
</B>		<%
	}
	else
	{
		%>
		If you wish to log out, press the "log out" button below.  (If you wish to login as another user, you must log out first.)
		<%
	}
	
	
	%><%=HtmlUtils.doubleLB(request)%><br />
	<%=HtmlUtils.formButton(false, "logOut", "location.replace('logout.jsp?"+controller.getSiteIdNVPair()+"&isPopup="+isPopup+"')", request)%><br />
	</font>
	<%
}  
%>

      
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

