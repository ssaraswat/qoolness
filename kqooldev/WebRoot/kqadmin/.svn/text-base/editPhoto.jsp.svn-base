<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


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
User user=controller.getSessionInfo().getUser();
int photoId=controller.getParamAsInt("id");
Photo photo=Photo.getById(photoId);
if (!user.isBackendUser()) {
	throw new JspException("Can't edit this photo; current user is not a backend user.");
}

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

	if (trim(els["caption"].value).length==0)
	{
		errorAlert("You have not supplied a caption; this field is required. Please fix and try again.",els["caption"])
		return false
	}


	return true
}





<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>
<a name="top"></a>

<div id="mainDiv">

<font class="bodyFont">
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Edit this photo.</span><br />
<img src="<%=photo.getRelativeToRootMainURL(request)%>" align="right" height="<%=photo.getMainHeight()%>" width="<%=photo.getMainWidth()%>" />If you'd like to change the caption for this photo, 
do that here and then press "save."  (Changed your mind?  <a href="javascript:history.go(-1)">Go back.</a>)<br/><br/>


</span>
<form action="processEditPhoto.jsp?<%=controller.getSiteIdNVPair()%>" method="post"  onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="currentPrimary" value="false" />
<input type="hidden" name="id" value="<%=photo.getId()%>" />

<span class="boldishFont">Caption</span><br />
<input style="width:250px;" type="text" class="inputText" name="caption" value="<%=photo.getCaption()%>" id="caption"><br/><br/>

<input type="hidden" name="primary" value="false" />

<%=HtmlUtils.cpFormButton("save", request)%><br /><br />

</form>
</div>




</div>

<br/><br />


<br /></font>

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

