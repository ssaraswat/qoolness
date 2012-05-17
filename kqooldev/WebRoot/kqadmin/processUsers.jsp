<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

  
<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSkipMaxUsersExceededCheck(true,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%



 


String successParam;
try
{
	int numUsers=controller.getParamAsInt("numUsers");
	for (int i=0; i<numUsers; i++)
	{
		User user=User.getById(controller.getParamAsInt("id"+i));
		user.setUsername(controller.getParam("username"+i));
		user.setFirstName(controller.getParam("firstName"+i));
		user.setLastName(controller.getParam("lastName"+i));
		user.setEmailAddress(controller.getParam("emailAddress"+i));
		user.store();
	}
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}

controller.redirect("users.jsp?"+controller.getSiteIdNVPair()+"&mode=edit&success="+successParam);
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

