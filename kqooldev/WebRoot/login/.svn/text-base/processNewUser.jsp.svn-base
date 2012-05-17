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

<%


SessionInfo sessionInfo=controller.getSessionInfo();

boolean accountCreated=controller.getParamAsBoolean("ac",false);

String username=controller.getParam("username").trim();
User user=sessionInfo.getUser();
Address address;
boolean addressExists;
try {
	address=Address.getByUserId(user.getId());
	if (address==null) {
		address=new Address();
		throw new RuntimeException("Address not found.");
	}
	addressExists=true;
}
catch (RuntimeException e) {
	address=new Address();
	addressExists=false;
}

LoginHelper.popupateNewUserData(request, user, address);
user.store();

// add a mapping to the site's primary backend user:
final Site site=Site.getById(controller.getSiteIdInt());
final boolean mappingExists=ClientToBackendUserMapping.mappingExists(user.getId(), site.getPrimaryContactUserId());
if (!mappingExists) {
	final ClientToBackendUserMapping mapping=new ClientToBackendUserMapping(user.getId(), site.getPrimaryContactUserId());
	mapping.store();
}

address.store();


String redirectUrl=PageUtils.nonNull(sessionInfo.getPostLoginDestinationUrl());
PageUtils.loginUser(user, controller);


MailUtils.sendActivationNotification(user, User.STATUS_ACTIVE, pageContext, controller);

if (redirectUrl.length()==0)
{

	redirectUrl="../index.jsp?"+controller.getSiteIdNVPair()+"&ac="+accountCreated+"&isPopup=false";
}
controller.redirect(redirectUrl);


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

