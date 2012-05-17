<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="javax.mail.internet.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.core.mail.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.util.*" %>
<%@ page import="java.util.*" %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%



controller.getSessionInfo().setShowDisplayPasswordPage(false);
boolean isPopup=(controller.getParamAsBoolean("isPopup"));
boolean accountCreated=(controller.getParamAsBoolean("ac", false));

SessionInfo sessionInfo=controller.getSessionInfo();
String username=controller.getParam("username");
String password=controller.getParam("password");

String requiredUserTypeForLogin=PageUtils.nonNull(sessionInfo.getRequiredUserTypeForLogin()).trim().toLowerCase();



int reasonCode=0;
String msg="";
User user=null;
try {
	user=User.getByUsername(username);
	if (user==null) {
		throw new RuntimeException("User not found.");
	}
	sessionInfo.setUser(user);
	User.authenticate(username, password);
}
catch (FailedLoginException e) {
	reasonCode=e.getReasonCode();
	msg=e.getMessage();
}
catch (RuntimeException e) {
	reasonCode=FailedLoginException.REASON_CODE_UNRECOGNIZED_USERNAME;
}

msg=java.net.URLEncoder.encode(msg==null?"":msg);

if (reasonCode>0) // if there was a FailedLoginException:
{
	if (reasonCode==FailedLoginException.REASON_CODE_FIRST_TIME_USER) {
		controller.redirect("newUser.jsp?"+controller.getSiteIdNVPair()+"&username="+URLEncoder.encode(username)+"");
	}
	else {
		controller.redirect("login.jsp?"+controller.getSiteIdNVPair()+"&msg="+msg+"&isPopup="+(isPopup?"true":"false")+"&errorCode="+(10+reasonCode)+"&username="+URLEncoder.encode(username)+"");
	}
}
else if (requiredUserTypeForLogin.equals("backenduser") && !(user.getUserType()==User.USER_TYPE_BACKENDUSER))
{
	// valid authentication info but wrong privileges:
	controller.redirect("login.jsp?"+controller.getSiteIdNVPair()+"&msg="+msg+"&isPopup="+(isPopup?"true":"false")+"&errorCode=2&username="+URLEncoder.encode(username)+"");
}

else
{
	String redirectUrl=PageUtils.nonNull(sessionInfo.getPostLoginDestinationUrl());
	PageUtils.loginUser(user, controller);
	if (redirectUrl.length()==0)
	{

		redirectUrl="../index.jsp?"+controller.getSiteIdNVPair()+"&ac="+accountCreated+"&isPopup="+(isPopup?"true":"false");
	}
	controller.redirect(redirectUrl+"");
}


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

