<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
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

List allUsers=User.getBackendUserClients(currentUser.getId(), true);
Collections.sort(allUsers);


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">

function isValidForm(formObj)
{
	var els=formObj.elements

	if (els["userId"].selectedIndex==0)
	{
		errorAlert("You have not chosen a user from the menu; this is required.  Please choose one and try again.",els["userId"])
		return false
	}

	

	hidePageAndShowPleaseWait();
	return true
}


</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardAdminTextBlockWidth">
<form target=_blank action="../workouts/calorieSpreadsheet.jsp" onsubmit="return isValidForm(this)">
<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
<font class="bodyFont">



	<span class="firstSentenceFont">Want to view a user's calorie spreadsheets?</span><br />
	Please choose the user from the pulldown menu below and press the "continue" button.  The user's spreadsheets will open in a new window.<br /><br />
	
	
	<span class="boldishFont">Choose a user...</span><br />
	<select style="width:190px; " class="selectText" name="viewUserId">
	<option value="">...</option>
	<%
	for (int i=0; i<allUsers.size(); i++) {
		User user=(User)allUsers.get(i);
		if (user.getUserType()==User.USER_TYPE_USER && (user.getStatus()==User.STATUS_ACTIVE || user.getStatus()==User.STATUS_PREACTIVE)) {
			%><option value="<%=user.getId()%>"><%=user.getFormattedNameAndUsername()%></option>
			<%
		}
	}
	%>
	</select><br /><br /><br />
	
	<%=HtmlUtils.cpFormButton(true, "continue", null, request)%>





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

