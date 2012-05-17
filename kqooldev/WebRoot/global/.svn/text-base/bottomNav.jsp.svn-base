<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><a href="<%=PageUtils.getPathToAppRoot(request)%>index.jsp?<%=controller.getSiteIdNVPair()%>"><img style="margin-left:20px; margin-right:25px;" galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/bottomnav/home.gif" height="55" width="61" border="0"
 /></a><a href="javascript:launchFeedback(false)"><img style="margin-right:25px;" galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/bottomnav/contact.gif" height="55" width="80" border="0"
 /></a><a href="<%=PageUtils.getPathToAppRoot(request)%>etc/privacy.jsp?<%=controller.getSiteIdNVPair()%>"><img style="margin-right:25px;" galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/bottomnav/privacy.gif" height="55" width="76" border="0"
 /></a><%
String currLoginStatus=PageUtils.nonNull(controller.getSessionInfo().getLoginStatus()).trim().toLowerCase();
boolean currLoggedIn=(currLoginStatus.equals("user") || currLoginStatus.equals("backenduser"));
if (currLoggedIn) {
	%><a href="<%=PageUtils.getPathToAppRoot(request)%>login/logout.jsp?<%=controller.getSiteIdNVPair()%>"><img galleryimg="false" style="margin-right:25px;" src="<%=PageUtils.getPathToAppRoot(request)%>images/bottomnav/logout.gif" height="55" width="70" border="0"
 /></a><%
}
else {
	%><a href="<%=PageUtils.getPathToAppRoot(request)%>login/login.jsp?<%=controller.getSiteIdNVPair()%>"><img galleryimg="false" style="margin-right:25px;" src="<%=PageUtils.getPathToAppRoot(request)%>images/bottomnav/login.gif" height="55" width="52" border="0"
 /></a><%
}

%><a href="<%=PageUtils.getPathToAppRoot(request)%>etc/faq.jsp?<%=controller.getSiteIdNVPair()%>"><img  style="margin-right:25px;" galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/bottomnav/faq.gif" height="55" width="51" border="0"
 /></a><br/>

 
 