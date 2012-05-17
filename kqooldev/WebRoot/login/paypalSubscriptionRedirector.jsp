<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>

<%@ page import="com.theavocadopapers.apps.kqool.util.PaymentUtils" %>
<%@ page import="com.theavocadopapers.apps.kqool.util.MailUtils" %>

<%@ include file="/global/topInclude.jsp" %>



<%
//in case a user is logged in, log them out: they're paying for a new membership, so don't have an acct yet, so if anyone is logged in, it's someone else (like me or Andrew doing testing or development: confusing):
PageUtils.logoutUser(controller);


String itemName=controller.getParam("itemName");
String itemNumber=controller.getParam("itemNumber");
String username=controller.getParam("username");
controller.setCookieValue("u", URLEncoder.encode(GeneralUtils.wEncrypt(username), "UTF-8"));
controller.setCookieValue("s", URLEncoder.encode(GeneralUtils.wEncrypt(controller.getSiteId()), "UTF-8"));
double price=siteProps.getStandardMonthlyCost();
String retUrl=""+GeneralUtils.getRequestURL(request, controller.getSiteIdInt());
retUrl=retUrl.substring(0,retUrl.indexOf("/login/")+("/login/").length())+"processPPReturn.jsp?"+controller.getSiteIdNVPair();
String redirUrl=PaymentUtils.getPayPalSubscriptionURL(itemName, itemNumber, price, retUrl, controller);

%>
<script>
location.replace("<%=redirUrl%>")
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

