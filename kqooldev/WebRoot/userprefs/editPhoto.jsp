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

<%!

%>

<%
User user=controller.getSessionInfo().getUser();
int photoId=controller.getParamAsInt("id");
Photo photo=Photo.getById(photoId);
if (!user.isBackendUser() && photo.getUserId()!=user.getId()) {
	throw new JspException("Can't edit this photo; userId mismatch.");
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


</script> 

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardTextBlockWidth">

<font class="bodyFont">
<span class="standardTextBlockWidth">
<span class="firstSentenceFont">Edit this photo.</span><br />
<img src="<%=photo.getRelativeToRootThumbnailURL(request)%>" align="right" height="<%=photo.getThumbHeight()%>" width="<%=photo.getThumbWidth()%>" />If you'd like to change the caption for this photo, or set it as the primary
photo in your collection, please make changes here and press "save."  (Changed your mind?  <a href="javascript:history.go(-1)">Go back.</a>)<br clear="all" /><br/>


</span>
<form action="processEditPhoto.jsp?<%=controller.getSiteIdNVPair()%>" method="post"  onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="currentPrimary" value="<%=photo.isPrimaryPhoto()%>" />
<input type="hidden" name="id" value="<%=photo.getId()%>" />

<span class="boldishFont">Caption</span><br />
<input style="width:250px;" type="text" class="inputText" name="caption" value="<%=photo.getCaption()%>" id="caption"><%=HtmlUtils.doubleLB(request)%>

<i>
<input type="radio" name="primary" id="primarytrue" value="true" <%=photo.isPrimaryPhoto()?"checked":""%> /><label for="primarytrue">This is my primary photo*</label><br/>
<input type="radio" name="primary" id="primaryfalse" value="false" <%=photo.isPrimaryPhoto()?"":"checked"%> /><label for="primaryfalse">This is not my primary photo</label><br/>
</i>
<%=HtmlUtils.doubleLB(request)%>
<%=HtmlUtils.formButton("save", request)%><br /><br />
<span style="font-size:11px;">*Your primary photo always appears at the top of your list of photos.  It is also the photo 
that your trainer sees first.  If you do not specify a primary photo, then the photo you've 
added most recently will be your primary photo.</span>
</form>
</div>




</div>

<%=HtmlUtils.doubleLB(request)%><br />


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

