<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.jspStart(request); %>

<% PageUtils.setSkipTrialPeriodExpireCheck(true,request); %>
<% PageUtils.setSkipMaxUsersExceededCheck(true,request); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>

<%@ include file="/global/topInclude.jsp" %>
<%@ include file="includes/pfpItemsDef.jsp" %>

<%

User user=User.getById(controller.getParamAsInt("userId"));

MailUtils.sendPfpResults(user,  MED_CONDITIONS_1, MED_CONDITIONS_2, MED_CONDITIONS_3, MED_CONDITIONS_4, pageContext, controller);

controller.redirect("pfpConfirm.jsp?"+controller.getSiteIdNVPair());


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

