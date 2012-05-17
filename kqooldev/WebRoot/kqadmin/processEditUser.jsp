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
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%
int id=controller.getParamAsInt("id");
int addressId=controller.getParamAsInt("addressId");
String retUrl=controller.getParam("retUrl");
String firstName=controller.getParam("firstName");
String lastName=controller.getParam("lastName");
String emailAddress=controller.getParam("emailAddress");
String addressLine1=controller.getParam("addressLine1");
String addressLine2=controller.getParam("addressLine2");
String city=controller.getParam("city");
String stateProvinceCode=controller.getParam("stateProvinceCode");
String postalCode=controller.getParam("postalCode");
String homeTelephone=controller.getParam("homeTelephone");
String workTelephone=controller.getParam("workTelephone");
String mobileTelephone=controller.getParam("mobileTelephone");
String emergencyContact=controller.getParam("emergencyContact");
String commentsUserHidden=controller.getParam("commentsUserHidden");
int gender=controller.getParamAsInt("gender");

User user=User.getById(id);
user.setFirstName(firstName);
user.setLastName(lastName);
user.setEmailAddress(emailAddress);
user.setCommentsUserHidden(commentsUserHidden);
user.setGender(gender);
user.setEmergencyContact(emergencyContact);
user.setCommentsUserHidden(commentsUserHidden);
user.setGender(gender);
user.store();

Address address=Address.getById(addressId);
address.setAddressLine1(addressLine1);
address.setAddressLine2(addressLine2);
address.setCity(city);
address.setStateProvinceCode(stateProvinceCode);
address.setPostalCode(postalCode);
address.setHomeTelephone(homeTelephone);
address.setWorkTelephone(workTelephone);
address.setMobileTelephone(mobileTelephone);
address.store();

%>
<script type="text/javascript">
alert("Your changes have been saved.")
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

