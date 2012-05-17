<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% //PageUtils.forceNoCache(response); %>

 
<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_PREFS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

String successParam;
boolean passwordChanged=false;
boolean addressExisted=false;



try
{
	SessionInfo sessionInfo=controller.getSessionInfo();
	User user=sessionInfo.getUser();
	user.setFirstName(controller.getParam("firstName"));
	user.setLastName(controller.getParam("lastName"));
	user.setEmailAddress(controller.getParam("emailAddress"));
	user.setEmergencyContact(controller.getParam("emergencyContact"));

	Address address=new Address();
	try {
		address=Address.getByUserId(user.getId());
		if (address==null) {
			address=new Address();
			throw new RuntimeException("Address not found.");
		}
		addressExisted=true;
	}
	catch (RuntimeException e) {
		addressExisted=false;
		address.setUserId(user.getId());
	}
	address.setAddressLine1(controller.getParam("addressLine1"));
	address.setAddressLine2(controller.getParam("addressLine2"));
	address.setCity(controller.getParam("city"));
	address.setStateProvinceCode(controller.getParam("stateProvinceCode"));
	address.setPostalCode(controller.getParam("postalCode"));
	address.setHomeTelephone(controller.getParam("homeTelephone"));
	address.setWorkTelephone(controller.getParam("workTelephone"));
	address.setMobileTelephone(controller.getParam("mobileTelephone"));
	address.setRegion("");
	address.setCountryCode("USA");
	
	
	
	String password=controller.getParam("password","");
	if (password.trim().length()>0)
	{
		// if the user entered a password, then he/she wants to change it (otherwise leave it):
		user.setPassword(controller.getParam("password"));
	}
	passwordChanged=(password.length()>0);
	user.store();
	if (addressExisted) {
		address.store();
	}
	else {
		address.store();
	}
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}

controller.redirect("showPrefsChanges.jsp?"+controller.getSiteIdNVPair()+"&pc="+passwordChanged+"&success="+successParam);
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

