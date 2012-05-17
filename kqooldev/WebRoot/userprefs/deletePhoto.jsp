<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% //PageUtils.forceNoCache(response); %>

 
<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_PREFS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%
GenericProperties genericProps=new GenericProperties();
User user=controller.getSessionInfo().getUser();
Photo photo=Photo.getById(controller.getParamAsInt("id"));
if (!user.isBackendUser() && photo.getUserId()!=user.getId()) {
	throw new JspException("Can't delete photo; userID mismatch.");
}
photo.getMainFile().deleteOnExit();
photo.getThumbnailFile().deleteOnExit();
Photo.deleteById(photo.getId());

controller.redirect("photos.jsp?"+controller.getSiteIdNVPair());
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

