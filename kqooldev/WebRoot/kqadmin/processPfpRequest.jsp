<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

String successParam;
int userId=controller.getParamAsInt("userId");
String emailAddr=controller.getParam("emailAddr");
String userFullname="";
User user=new User();

try
{
	user=User.getById(userId);
	MailUtils.sendPfpRequest(user, emailAddr, pageContext, controller);
	userFullname=user.getFormattedNameAndUsername();
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}



controller.redirect("pfpRequestConfirm.jsp?"+controller.getSiteIdNVPair()+"&success="+successParam+"&userFullname="+URLEncoder.encode(userFullname)+"&emailAddr="+URLEncoder.encode(emailAddr));


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

