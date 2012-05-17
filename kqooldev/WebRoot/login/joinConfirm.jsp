<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>
<% PageUtils.setShowTopNav(false,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%

// in case a user is logged in:
PageUtils.logoutUser(controller);

String username=controller.getParam("username");
String itemName=siteProps.getPaypalStandardMonthlySubscriptionItemName();
String itemNumber=siteProps.getPaypalStandardMonthlySubscriptionItemNumber();

String payPalUrl=
	"paypalSubscriptionRedirector.jsp?itemName="
	+URLEncoder.encode(itemName)+"&itemNumber="
	+URLEncoder.encode(itemNumber)+"&username="
	+URLEncoder.encode(username)+"&siteId="
	+controller.getSiteId()
;
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

<div id=<%=isPopup?"popupMainDiv":"mainDiv"%>>
<span class="standardTextBlockWidth">


<font class="bodyFont">

<span class="firstSentenceFont">oK!</span><br />

The next step is setting up your monthly payments to Kqool.com. Kqool membership 
is US$<%=siteProps.getStandardMonthlyCost()%> per month. 
All Kqool.com payments are billed through PayPal, 
the credit-card payment processor owned by Ebay. (You can get all the juicy details on 
PayPal <a href="https://www.paypal.com" target="_blank">here</a>.)  Please click 
"pay with PayPal" below to set up these payments.<br /><br />
<b>Please note!</b> At the end of the process, don't forget to click PayPal's "Access Subscription" 
link, which will return you to this site and create an account for you in our database.


<br /><br /><br />


<a href="<%=payPalUrl%>" onclick="alert('Please remember!!!...\r\n\r\nAt the end of the PayPal payment process, don\'t forget to click PayPal\'s \'Return To Merchant\' link, which will return you to this site and create an account for you.  If you forget to click that button, the processing of your new account will be delayed.'); return true;"><img src="../images/buttonPayWithPayPal.gif" height="45" width="167" border="0" /></a>



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

