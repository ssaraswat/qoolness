<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>
<% PageUtils.setSkipSiteIdCheck(request); %>




<%@ include file="/global/topInclude.jsp" %>


<%


// on this page, since it can't receive params (since PayPal return pages can't have params in them), 
// we pick up the siteId from a cookie set before we went to PayPal:
String siteId=GeneralUtils.wDecrypt(controller.getCookieValue("s"));
// ...and on this page only, put the siteId in the request object as an attr (controller does this on every other page):
request.setAttribute(Controller.SITE_ID_ATTR, new Integer(siteId).toString());

com.theavocadopapers.apps.kqool.jsphelpers.LoginJspHelper.processPPReturn(controller);

controller.redirect("newUser.jsp?"+controller.getSiteIdNVPair()+"&isPopup=false&ac=true");


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

