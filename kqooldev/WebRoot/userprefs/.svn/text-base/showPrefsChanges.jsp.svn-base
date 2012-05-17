<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_PREFS,request); %>

<%@ include file="/global/topInclude.jsp" %>
<%@ include file="includes/prefsInclude.jsp" %>
<%!

%>



<%



boolean success=controller.getParamAsBoolean("success",true);
boolean passwordChanged=controller.getParamAsBoolean("pc");



User user=controller.getSessionInfo().getUser();
Address address=Address.getByUserId(user.getId());
String addressText=
	address.getAddressLine1()+", "
	+(address.getAddressLine2()!=null && address.getAddressLine2().trim().length()>0?address.getAddressLine2()+", ":"")
	+address.getCity()+", "+address.getStateProvinceCode()+" "+address.getPostalCode()
;
String homeTelephone=address.getHomeTelephone();
String workTelephone=address.getWorkTelephone();
String mobileTelephone=address.getMobileTelephone();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">

</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">


<font class="bodyFont">


<%
if (success)
{
	%>
	<span class="firstSentenceFont">Your changes have been made.</span><br />
	Your current Kqool.com identity is below:

	<%
}
else
{
	%>
	<span class="firstSentenceFont">There's a problem.</span><br />
	Some or all of your data may not have been saved. The<br />
	current configuration of your account is below.


	<%
}
%><br /><br />


<span class="boldishFont">Name:</span> <%=user.getFirstName()%> <%=user.getLastName()%><br /><br />
<span class="boldishFont">Email Address:</span> <a href="mailto:<%=user.getEmailAddress()%>"><%=user.getEmailAddress()%></a><br /><br />
<span class="boldishFont">Address:</span> <%=addressText%><br /><br />
<span class="boldishFont">Home Telephone:</span> <%=homeTelephone%><br />
<span class="boldishFont">Work Telephone:</span> <%=workTelephone%><br />
<span class="boldishFont">Mobile Telephone:</span> <%=mobileTelephone%><br /><br />

<span class="boldishFont">Emergency Contact:</span> <%=user.getEmergencyContact()%><br /><br />
<span class="boldishFont">Password:</span> <%=(passwordChanged?"[changed]":"[unchanged]")%><br />





<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>


</div>

<%@ include file="/global/bodyClose.jsp" %>

</html>




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

