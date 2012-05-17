<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_PRIVACY,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

String currentLoginStatus=PageUtils.nonNull(controller.getSessionInfo().getLoginStatus()).trim().toLowerCase();
boolean currentlyLoggedIn=(currentLoginStatus.equals("user") || currentLoginStatus.equals("backenduser"));
PageUtils.setShowTopNav(currentlyLoggedIn,request);

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

<span class="standardTextBlockWidth" style="display:block;">

<font class="bodyFont">

<span class="firstSentenceFont">Kqool values your privacy.</span><br />

The Kqool.com Privacy Policy, which appears below, is our commitment to your privacy.<br /><br />

Kqool.com<sup style="font-size:8px;">TM</sup> is committed to protecting your privacy and ensuring that your  visit to our website is completely secure.<br /><br />

If you have any questions or problems with any aspect of our privacy policy, please contact us.<br /><br />

<b>Collection of your Personal Information	</b><br /><br />

Kqool.com only saves such personal information that is necessary  for you to access and use our services. This personal information  includes, but is not limited to, first and last name, physical address,  email address, phone number, birth date, financial information, and  vehicle information.<br /><br />

<b>How we use your Personal Information </b><br /><br />

Your personal information will be used in order to provide you with better service.  This includes the use of information for completing transactions or communicating  back to you. Credit card numbers are used only for payment processing and are not  used for any other purpose.<br /><br />

<b>Who we share your Personal Information with	</b><br /><br />

We will NOT sell or rent your name or personal information to anyone  else. We DO NOT sell, rent or provide outside access to our mailing  list at all.<br /><br />

If required by law, search warrant, subpoena, court order, or credit card  fraud investigation, Kqool.com may be required to release such  personal information.<br /><br />

<b>Security of your Personal Information </b><br /><br />

Kqool.com maintains the security of your information at all times. We store 
your information in a secure database, and further protect sensitive data such
as passwords by encrypting them.  Finally, Kqool does not store user credit-card information,
since Kqool payments are processed by PayPal.<br /><br />

Once the information is in our system, it is accessible to authorized Kqool.com personnel only (except for encrypted data, which is not accessible to Kqool staff at all). We strictly enforce our privacy policies with our employees and any breach of this policy will result in termination and the pressing of criminal charges where there are grounds.<br />
<br />
<br /><br />



<br /></font>
</span>

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

