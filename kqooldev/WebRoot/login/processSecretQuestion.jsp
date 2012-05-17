<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%


boolean isPopup=(controller.getParamAsBoolean("isPopup"));

String username=controller.getParam("username");
String secretAnswer=controller.getParam("secretAnswer");


User user=User.getByUsername( request.getParameter("username"));
user=(user==null?new User():user);

boolean correctAnswer=false;
try
{
	if (user!=null)
	{
		if (user.getSecretAnswer()!=null)
		{
			if (user.getUnencryptedSecretAnswer().trim().toLowerCase().equals(secretAnswer.trim().toLowerCase()))
			{
				correctAnswer=true;
			}
		}
	}
}
catch (Exception e)
{}
if (correctAnswer)
{
	session.setAttribute("wr.spf",username);
	controller.getSessionInfo().setShowDisplayPasswordPage(true);
	controller.redirect("displayPassword.jsp?"+controller.getSiteIdNVPair()+"&username="+URLEncoder.encode(username)+"&isPopup="+isPopup);
}
else
{
	session.setAttribute("wr.spf",null);
	controller.getSessionInfo().setShowDisplayPasswordPage(false);
	controller.redirect("answerSecretQuestion.jsp?"+controller.getSiteIdNVPair()+"&isPopup="+isPopup+"&error=true&username="+username);
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

