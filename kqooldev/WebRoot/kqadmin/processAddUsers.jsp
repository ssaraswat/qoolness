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

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<script>
var username="";
</script>
<%



boolean single=controller.getParamAsBoolean("single",false);


try
{
	int numUsers=controller.getParamAsInt("numUsers");
	for (int i=0; i<numUsers; i++)
	{
		if (controller.getParam("username"+i).trim().length()>0)
		{
			try {
				// then this is a user to add (not a blank row):
				User user=new User();
				user.setUsername(controller.getParam("username"+i));
				user.setFirstName(controller.getParam("firstName"+i));
				user.setLastName(controller.getParam("lastName"+i));
				user.setEmailAddress(controller.getParam("emailAddress"+i));
				user.setUserType(User.USER_TYPE_USER);
				user.setStatus(controller.getParam("status"+i).equals("preactive")?User.STATUS_PREACTIVE:User.STATUS_ACTIVE);
				user.setJoinDate(new Date());
				user.setBirthDate(new Date());
				user.setLastAccessDate(new Date());
				user.setGender(controller.getParamAsInt("gender"+i));
				user.setSiteId(controller.getParamAsInt("siteId"+i));
				user.setEmergencyContact("");
				user.setPassword("");
				user.setCommentsUserVisible("");
				user.setCommentsUserHidden(controller.getParam("comments"+i));
				user.setSecretAnswer("");
				user.setBackendUserParentUserId(User.BACKEND_USER_PARENT_USER_ID_CLIENT);
				User testUser=User.getByUsername(controller.getParam("username"+i));
				if (testUser==null)
				{
					user.store();
				}
				else
				{
					// else (see above) user already exists:
					user.store();
				}
				// add a mapping to the backend user specified if it doesn't exist (why would it exist since these are new users??? -- whatever):
				boolean mappingExists=ClientToBackendUserMapping.mappingExists(user.getId(), controller.getParamAsInt("trainerId"+i));
				if (!mappingExists) {
					ClientToBackendUserMapping mapping=new ClientToBackendUserMapping(user.getId(), controller.getParamAsInt("trainerId"+i));
					mapping.store();
				}
	
				
				if (controller.getParamAsBoolean("sendMail"+i)) {
					boolean isActive=(user.getStatus()==User.STATUS_ACTIVE);
					MailUtils.sendCreationNotification(user, isActive, pageContext, controller);
				}
			}
			catch (Exception e1) {
				%>
				<script>
				alert("Sorry, it looks like you tried to add the user \"<%=controller.getParam("username"+i).trim()%>\" twice.  Perhaps you pushed the \"submit\" button twice?  Rest assured, this user has been added to the database.");
				</script>
				<%
				response.flushBuffer();
				out.flush();
				response.flushBuffer();
			}
		}
	}
}
catch (Exception e)
{
	throw e;
}


controller.redirect("users.jsp?"+controller.getSiteIdNVPair()+"&single="+single+"&mode=add&success=true");
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

