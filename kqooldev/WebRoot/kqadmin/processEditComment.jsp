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
<%



try {
	User u=User.getById(controller.getParamAsInt("id"));
	u.setCommentsUserHidden(controller.getParam("comments"));
	u.store();
	%><script>
	alert("Your changes have been saved.")
	window.close()
	</script><%
}
catch (Exception e) {
	%><script>
	alert("There was a problem; your changes have not been saved.")
	window.close()
	</script><%	
}


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
