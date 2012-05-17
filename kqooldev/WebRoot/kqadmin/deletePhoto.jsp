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
if (!user.isBackendUser()) {
	throw new JspException("Can't delete photo; current user is not a backend user.");
}
photo.getMainFile().deleteOnExit();
photo.getThumbnailFile().deleteOnExit();
Photo.deleteById(photo.getId());

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

