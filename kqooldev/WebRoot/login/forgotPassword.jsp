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
String username=controller.getParam("username","");

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

</script>

<style type="text/css">
 
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id=<%=isPopup?"popupMainDiv":"mainDiv"%>>
<span class="standardTextBlockWidth">
	<form method="post" action="answerSecretQuestion.jsp?<%=controller.getSiteIdNVPair()%>&isPopup=<%=(isPopup?"true":"false")%>" onsubmit="return isValidForm(this)">
	<font class="bodyFont">    
	<span class="firstSentenceFont">Forgot your password?</span><br />
	Please enter your username, then click the "answer" button. Once you've correctly answered the question, Kqool.com will tell you your password.<br /><br />
	
	(Please note: if you are logging into Kqool.com for the first time, you do not need a password for access. If you are logging in for the first time, please <a href="login.jsp?<%=controller.getSiteIdNVPair()%>">return to the login page</a> and login without entering a password.)
<br /><br />
	<span class="boldishFont">Username:<br /></span>
	<input class="inputText" name="username" id="username" value="<%=username%>" size="16"><br /><br />
<br />

	<%=HtmlUtils.formButton("answer", request)%><br />


	
	
	</font>


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

