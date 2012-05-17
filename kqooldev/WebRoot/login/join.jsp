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

function isValidForm(formObj)
{
	var els=formObj.elements

	if (els["firstName"].value.length==0)
	{
		errorAlert("You have not entered a first name.  Please enter one and try again.",els["firstName"])
		return false
	}
	if (els["lastName"].value.length==0)
	{
		errorAlert("You have not entered a last name.  Please enter one and try again.",els["lastName"])
		return false
	}
	if (els["emailAddress"].value.length==0)
	{
		errorAlert("You have not entered an email address.  Please enter one and try again.",els["emailAddress"])
		return false
	}
	if (els["username"].value.length==0)
	{
		errorAlert("You have not entered the username you'd like to have.  Please enter one and try again.",els["username"])
		return false
	}

	
	
	
	if (!isValidEmail(els["emailAddress"].value)) {
		errorAlert("The email address you have entered is not valid.  'john@mymail.com' is an example of a valid email address.  Please enter one and try again.",els["emailAddress"])
		return false
	}
	if (!isValidUsername(els["username"].value)) {
		errorAlert("The username you have entered is not valid.  Usernames must be between four and 16 characters long and may contain only letters, numerals, underscores, hyphens, and periods. Please fix and try again.",els["username"])
		return false
	}
	if (els["comments"].value.length>800) {
		errorAlert("The comments you have entered are "+els["comments"].value.length+" characters long; the maximum is 800 characters.  Please fix and try again.",els["comments"])
		return false
	}
	var gender=0
	for (var i=0; i<els.length; i++) {
		if (els[i].name=="gender" && els[i].checked) {
			gender=els[i].value
			break
		}
	}
	if (gender==0) {
		errorAlert("You have not indicated your gender.  Please fix and try again.",els["gender"])
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

	<font class="bodyFont">

	
	<form action="processJoin.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 
<%
if (errorCode==1) {
		%><div class="errorDiv">Sorry, the username "<%=username%>" is already taken.  Please choose another one.</div><br /><br /><%
}
%>
		<span class="firstSentenceFont">Want to join Kqool? Smart Qookie.</span><br />
		Please supply the information below. Then press "continue." (Need some <a href="quonvincing.jsp?<%=controller.getSiteIdNVPair()%>">Qonvincing?</a>)
	
	


	<%=HtmlUtils.doubleLB(request)%><br />


	<span class="boldishFont">First Name</span><br />
	<input class="inputText" type="text" style="width:250px;" name="firstName" id="firstName" value="<%=firstName%>"><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Last Name</span><br />
	<input class="inputText" type="text"  style="width:250px;"  name="lastName" id="lastName" value="<%=lastName%>"><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Email Address</span><br />
	<input class="inputText" type="text"  style="width:250px;"  name="emailAddress" id="emailAddress" value="<%=emailAddress%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">Preferred Username</span><br />
	<input class="inputText" type="text" style="width:250px;" name="username" id="username" value="<%=username%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">Gender</span><br />
	<input type="radio" name="gender" value="<%=User.MALE%>" id="gender<%=User.MALE%>" <%=gender==User.MALE?"checked":""%> /><label for="gender<%=User.MALE%>" />male</label>&nbsp;&nbsp;&nbsp;
	<input type="radio" name="gender" value="<%=User.FEMALE%>" id="gender<%=User.FEMALE%>" <%=gender==User.FEMALE?"checked":""%> /><label for="gender<%=User.FEMALE%>" />female</label><br />

<%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">Comments</span> (optional)<br />
	<textarea class="inputText" style="width:250px; height:100px;" rows="5" cols="40" name="comments" id="comments"><%=comments%></textarea>

<%=HtmlUtils.doubleLB(request)%>


	<br /></font>
	
	
	<%=HtmlUtils.formButton(true,"continue",null,request)%>

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

