<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.*" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%


int id=controller.getParamAsInt("id");
User u=User.getById(id);
String fullname=u.getFormattedNameAndUsername()+")";

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">

window.focus()

var id=<%=controller.getParam("id")%>

function isValidAssignForm(formObj)
{
	var els=formObj.elements
	if (els["userId"].selectedIndex==0) {
		errorAlert("You have not chosen a user to assign this routine to; please fix and try again.",els["userId"])
		return false		
	}

	hidePageAndShowPleaseWait()
	return true
}

function setCommentsOnOpener(formObj) {
	if (window.opener) {
		window.opener.setComments(id, formObj.elements["comments"].value)
	}
	return true
}

</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv" style="position:absolute; top:50px; left:10px; ">
<span style="width:300px; ">
<form method="post" action="processEditComment.jsp?id=<%=id%>&<%=controller.getSiteIdNVPair()%>" onsubmit="return setCommentsOnOpener(this)">



<font class="bodyFont">


	<span class="firstSentenceFont">Please edit comments</span><br />
	for <%=fullname%>'s account and press the "save" button.  
	These comments are not visible to the user and are 
	only for admin reference.<br /><br />
	<span class="boldishFont">Comments:</span><br />
	<script type="text/javascript">
	document.write("<textarea name=comments rows=4 cols=30 class=\"inputText\" style=\"width:350px; height:115px;\">"+unescape("<%=controller.getParam("c")%>")+"</textarea>")
	</script>

<br /><br />
<nobr>
<%=HtmlUtils.cpFormButton(true, "save", null, request)%>
<%=HtmlUtils.cpFormButton(false, "cancel", "window.close()", request)%><br />
</nobr>

</font>

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

