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

int id=controller.getParamAsInt("id");
String action=controller.getParam("action");
int status=0;
if (action.trim().equals("suspend")) {
	status=User.STATUS_SUSPENDED;
}
else if (action.trim().equals("deactivate")) {
	status=User.STATUS_DEACTIVATED;
}
else {
	throw new RuntimeException("unrecognized action param: '"+action+"'");
}

User u=User.getById(id);
u.setStatus(status);
u.store();

%>
<script>
alert("The user's new status has been set.")
</script>
<%
//controller.redirect("users.jsp?"+controller.getSiteIdNVPair()+"&action="+status+"&n="+(URLEncoder.encode(u.getFirstName()+" "+u.getLastName()+" ("+u.getUsername()+")"))+"");
controller.redirect(request.getParameter("retUrl"));

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
