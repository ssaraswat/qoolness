<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% // PageUtils.forceNoCache(response); %>

 
<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_FEEDBACK,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

String fullname=controller.getParam("fullname");
String emailAddress=controller.getParam("emailAddress");
String username=controller.getParam("username");
String browserInfo=controller.getParam("browserVer");
String queryType=controller.getParam("commentType");
String comments=controller.getParam("comments");

%>
<head>
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/popupHeadInclude.jsp" %>
</head>
<body>
<%

try {
	MailUtils.sendFeedbackMessage(controller.getSessionInfo().getUser(), fullname, emailAddress, username, queryType, comments, browserInfo, pageContext, controller);
	%><script>
	generalAlert("Message received.  We'll be in touch soon.")
	window.close()
	</script><%
}
catch (Exception e) {
	%><script>
	errorAlert("There was a problem; your message was not sent.  Please contact <%=siteProps.getCommentsEmailAddress()%>.")
	window.close()
	</script><%
}

%>
<%@ include file="/global/trackingCode.jsp" %>
</body>

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
