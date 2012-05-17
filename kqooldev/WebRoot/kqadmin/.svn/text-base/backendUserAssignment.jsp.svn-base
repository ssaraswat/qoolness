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

boolean assign=controller.getParamAsBoolean("assign"); // false means unassign
String retUrl=controller.getParam("retUrl");
int backendUserId=controller.getParamAsInt("backendUserId");
int clientId=controller.getParamAsInt("clientId");

User backendUser=User.getById(backendUserId);
User client=User.getById(clientId);

String message;
try
{
	if (!assign) { // unassigning
		try {
			ClientToBackendUserMapping.delete(clientId, backendUserId);
		}
		catch (Exception e) {
			logger.error("deleting mapping", e);
		}
		message="Backend user "+backendUser.getFormattedNameAndUsername()+" has been unassigned from client "+client.getFormattedNameAndUsername()+".";
	}
	else { // assigning
		try {
			ClientToBackendUserMapping mapping=new ClientToBackendUserMapping(clientId, backendUserId);
			mapping.store();
			MailUtils.sendAssignmentMailToBackendUser(backendUser, client, currentUser, pageContext, controller);
		}
		catch (Exception e) {
			// may bump up against a unique constraint, which is fine.
		}
		message="Backend user "+backendUser.getFormattedNameAndUsername()+" has been assigned to client "+client.getFormattedNameAndUsername()+".";
	}
}
catch (Exception e)
{
	throw e;
}



%>
<script type="text/javascript">
alert("<%=message%>")
</script>
<%

out.flush();
response.flushBuffer();
out.flush();
controller.redirect(retUrl);
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

