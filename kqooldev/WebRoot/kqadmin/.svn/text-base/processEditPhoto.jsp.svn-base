<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

 
<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

User user=controller.getSessionInfo().getUser();
Photo photo=Photo.getById(controller.getParamAsInt("id"));
if (!user.isBackendUser() && photo.getUserId()!=user.getId()) {
	throw new JspException("Can't delete photo; userID mismatch.");
}
photo.setCaption(controller.getParam("caption"));
photo.store();

boolean currentPrimary=controller.getParamAsBoolean("currentPrimary");
boolean newPrimary=controller.getParamAsBoolean("primary");

if (currentPrimary!=newPrimary) {
	if (newPrimary) {
		Photo.setPrimaryPhotoByUserIdAndPhotoId(photo.getUserId(), photo.getId());
	}
	else {
		Photo.unsetPrimaryPhotoByUserId(photo.getUserId());
	}
}
%>
<script>
alert("Your changes have been stored.")
</script>
<%
response.flushBuffer();
out.flush();
response.flushBuffer();
controller.redirect("user.jsp?siteId="+controller.getSiteId()+"&id="+photo.getUserId()+"&activeTab=pfd&activePfdTab=Photos&t="+new Date().getTime());
%>




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

