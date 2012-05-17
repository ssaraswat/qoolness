<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setSkipTrialPeriodExpireCheck(true,request); %>
<% PageUtils.setSkipMaxUsersExceededCheck(true,request); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!



%>

<%


SessionInfo sessionInfo=controller.getSessionInfo();

String username=controller.getParam("username").trim();
String firstName=controller.getParam("firstName").trim();
String lastName=controller.getParam("lastName").trim();
String emailAddress=controller.getParam("emailAddress").trim();
String comments=controller.getParam("comments").trim();
int gender=controller.getParamAsInt("gender");




if (UserUtils.usernameInUse(username)) {
	controller.redirect("join.jsp?"+controller.getSiteIdNVPair()+"&errorCode=1&username="+URLEncoder.encode(username)+"&firstName="+URLEncoder.encode(firstName)+"&lastName="+URLEncoder.encode(lastName)+"&emailAddress="+URLEncoder.encode(emailAddress)+"&gender="+gender+"&comments="+URLEncoder.encode(comments)+"");
}
else {
	User tempUser=new User();
	tempUser.setUsername(username);
	tempUser.setFirstName(firstName);
	tempUser.setLastName(lastName);
	tempUser.setEmailAddress(emailAddress);
	tempUser.setGender(gender);
	tempUser.setSiteId(controller.getSiteIdInt());
	MailUtils.sendInitialUserContactNotification(tempUser, comments, pageContext, controller);
	PreRegistrationUserData userData=new PreRegistrationUserData();
	userData.setUsername(username);
	userData.setFirstName(firstName);
	userData.setLastName(lastName);
	userData.setEmailAddress(emailAddress);
	userData.setComments(comments);
	userData.setGender(gender);
	userData.setSiteId(controller.getSiteIdInt());

	userData.store();

	controller.redirect("joinConfirm.jsp?"+controller.getSiteIdNVPair()+"&username="+URLEncoder.encode(username));
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

