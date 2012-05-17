<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
<%@ page import="com.theavocadopapers.apps.kqool.pfd.*" %>
 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_PERSONAL_FITNESS_PROFILE,request); %>
<% PageUtils.setShowTopNav(false,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%

int userId=Integer.parseInt(controller.getParam("userId"));
boolean showSuccessAlert=controller.getParamAsBoolean("showSuccessAlert");
boolean weightFieldsOnly=controller.getParamAsBoolean("weightFieldsOnly", false);

User user=User.getById(userId);

if (!weightFieldsOnly) {
	// deal with birthdate, which is stored in the User obj, not in a PfdItem:
	Calendar birthdate=new GregorianCalendar();
	birthdate.set(Calendar.DATE, controller.getParamAsInt("birthDateOfMonth"));
	birthdate.set(Calendar.MONTH, controller.getParamAsInt("birthMonth"));
	birthdate.set(Calendar.YEAR, controller.getParamAsInt("birthYear"));
	user.setBirthDate(birthdate.getTime());
	user.store();
}

int settingUserId=controller.getParamAsInt("settingUserId");
String retUrl=controller.getParam("retUrl");

CurrentPfdData currentData=CurrentPfdData.getByUserId(userId, settingUserId);
boolean noExistingData=controller.getParamAsBoolean("noExistingData");
Map changedItemCodesToValues=currentData.save(request.getParameterMap(), noExistingData, weightFieldsOnly);
User formSubmittingUser=controller.getSessionInfo().getUser();
boolean formSubmittingUserIsClient=(!user.isBackendUser());

// only send mail if client submitted the form (trainer doesn't need mail telling him
// that he filled out form):
if (formSubmittingUserIsClient) {
	if (noExistingData) {
		// first-time submission:
		MailUtils.sendInitialPfdResults(user, pageContext, controller);
	}
	else {
		MailUtils.sendChangedPfdResults(user, changedItemCodesToValues, pageContext, controller);
	}
}
if (showSuccessAlert) {
	%>
	<script>
	alert("Your changes to this client's personal-fitness data have been saved.")
	</script>
	<%
}
out.flush();
response.flushBuffer();
%>




<script>
location.replace("<%=retUrl%>");
</script>


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

