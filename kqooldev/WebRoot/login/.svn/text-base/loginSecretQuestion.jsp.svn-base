<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>
<% PageUtils.setShowTopNav(false,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
 
%> 

<%



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>


<script type="text/javascript">



function isValidForm(formObj)
{
	var els=formObj.elements

	if (trim(els["secretAnswer"].value).length==0)
	{
		errorAlert("You have not supplied an answer to your secret question. Please supply one and try again.",els["secretAnswer"])
		return false
	}	
	generalAlert("Thank you; if you ever forget your password, Kqool.com will now be able to retrieve it for you.");
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

<form action="processLoginSecretQuestion.jsp?<%=controller.getSiteIdNVPair()%>&isPopup=<%=(isPopup?"true":"false")%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 

<font class="bodyFont">

<span class="firstSentenceFont">You are now logged in,</span> but Kqool does not have a "secret question" and its answer on file for you.  Please supply these below, then press the "submit" button.  Then, if you ever forget your password, Kqool will be able to remind you of what it is, assuming you can answer the secret question accurately:<br /><br />


<span class="boldishFont">Secret question</span><br />
<select class="selectText" style="width:310px;" name="secretQuestion" id="secretQuestion">
<%

for (int i=0; i<AppConstants.SECRET_QUESTION_LABELS.length; i++)
{
	%>
	<option value="<%=AppConstants.SECRET_QUESTION_VALUES[i]%>"><%=AppConstants.SECRET_QUESTION_LABELS[i]%></option>
	<%
}
%>
</select><br /><br />

<span class="boldishFont">Answer to secret question</span> (Note: If you lose your password, you will need to remember <I>exactly</I> what you typed here to get it back; you will also not be able to change this field once you submit this page.)<br />
<input type="text" class="inputText" name="secretAnswer" id="secretAnswer" value="" size=16><%=HtmlUtils.doubleLB(request)%><br />

	<input class="formButton" type="submit" value="submit"><%=HtmlUtils.doubleLB(request)%>


</font>

<br /></font>
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

