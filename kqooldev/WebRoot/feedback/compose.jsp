<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
       

<% PageUtils.jspStart(request); %>
<% //PageUtils.forceNoCache(response); %>
     
<%@ page import="java.util.*" %>   

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_FEEDBACK,request); %>
 
<%@ include file="/global/topInclude.jsp" %>
<%!

%>        

<%

User user=controller.getSessionInfo().getUser();

String fullname="";
String emailAddress="";
String username="";

if (user!=null)
{
	fullname=PageUtils.nonNull(user.getFirstName())+" "+PageUtils.nonNull(user.getLastName());
	emailAddress=PageUtils.nonNull(user.getEmailAddress());
	username=PageUtils.nonNull(user.getUsername());
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/popupHeadInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

var browserVer=(navigator.appName+" "+navigator.appVersion).replace(/Microsoft Internet Explorer/g,"MSIE")
var commentsEmailAddress="<%=siteProps.getCommentsEmailAddress()%>"


function isValidForm(formObj)
{ 
	var els=formObj.elements

	if (trim(els["fullname"].value).length==0)
	{
		errorAlert("You have not entered your name. Please fix and try again.",els["fullname"])
		return false
	}
	if (trim(els["emailAddress"].value).length==0)
	{
		errorAlert("You have not entered your email address. Please fix and try again.",els["emailAddress"])
		return false
	}
	if (trim(els["comments"].value).length==0)
	{
		errorAlert("You have not entered any comments. Please fix and try again.",els["comments"])
		return false
	}
	
	// all reqd fields entered; now check for invalid entries:
	if (!isValidEmail(els["emailAddress"].value))
	{
		errorAlert("\""+els["emailAddress"].value+"\" is not a valid e-mail address. Please fix and try again.  \"myname@mycompany.com\" is an example of a valid e-mail address.",els["emailAddress"])
		return false
	}


	setTimeout("sendSuccess(true)",2000)

	hidePageAndShowPleaseWait()
	return true
}


  
 
function sendSuccess(isSuccess)
{
	if (isSuccess)
	{
		generalAlert("Thank you; your message has been sent.")
		top.close()
	}
	else
	{
		generalAlert("Hmm, there was a problem sending your message; please check with your administrator to make sure that he or she has configured e-mail properly.  In the meantime, you may send your comment via e-mail to "+window.commentsEmailAddress+".")
	}
} 

</script> 

<style type="text/css">
.inputClass {padding:2px; height:20px; border: 1px solid #7F7F5E; font-size:11px; font-family:arial,helvetica; width:294px; } 
.textareaClass {padding:4px; height:120px; width:294px; border: 1px solid #7F7F5E; font-size:11px; font-family:arial,helvetica; } 
.selectClass {background-color:#eeeeee; padding:2px; width:290px; border: 1px solid #7F7F5E; font-size:11px; font-family:arial,helvetica; }

</style>

 
  
 
</head>

<%@ include file="/global/bodyOpen.jsp" %>  

<div id="popupMainDiv">
<form action="send.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">

<font class="bodyFont">


	<span class="popupFirstSentenceFont">Talk to us.</span><br />
	What's on your mind? Please let us know.



<%=HtmlUtils.doubleLB(request)%>
 
<span class="boldishFont">Your name</span><br />
<input type="text" class="inputText" style="width:290px;" name="fullname" id="fullname" value="<%=fullname%>"><%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Your e-mail address</span><br />
<input type="text" class="inputText" style="width:290px;" name="emailAddress" id="emailAddress" value="<%=emailAddress%>"><%=HtmlUtils.doubleLB(request)%>


<span class="boldishFont">Your username</span> (if  applicable)<br />
<input type="text" class="inputText" style="width:290px;" name="username" id="username" value="<%=username%>"><%=HtmlUtils.doubleLB(request)%>





<span class="boldishFont">What is your question or comment regarding?</span><br />
	<select name="commentType" id="commentType" class="selectClass">
	<%
	if (user!=null && !user.isBackendUser()) {
		List mappings=ClientToBackendUserMapping.getByClientUserId(user.getId());
		mappings=(mappings==null?new ArrayList():mappings);
		Iterator it=mappings.iterator();
		ClientToBackendUserMapping mapping;
		User bu;
		while (it.hasNext()) {
			mapping=(ClientToBackendUserMapping)it.next();
			bu=User.getById(mapping.getBackendUserId());
			%>
			<option value="backendUser_<%=bu.getId()%>">Message to <%=bu.getFirstName()%> <%=bu.getLastName()%></option>
			<%
		}
	}
	%>
	<option value="suggestion">Suggestion/feature request</option>
	<option value="technical support request">Technical support</option>
	<option value="membership question">My membership</option>
	<option value="general comment">Something else</option>
	</select><%=HtmlUtils.doubleLB(request)%>
	




<span class="boldishFont">Your comment or question</span><br />
<textarea class="inputText" style="width:290px; height:130px;" rows="10" cols="40" name="comments" id="comments" wrap="virtual"></textarea><%=HtmlUtils.doubleLB(request)%>


<script type="text/javascript">
document.write("<input type=\"hidden\" class=inputClass name=browserVer id=browserVer value=\""+browserVer+"\">")
</script>

<%=HtmlUtils.smallFormButton(true, "send", null, request)%>
<%=HtmlUtils.smallFormButton(false, "cancel", "top.close()", request)%><br />

<br />
</font>

</form>	

</div>

<%@ include file="/global/popupBodyClose.jsp" %>

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

