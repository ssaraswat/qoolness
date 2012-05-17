<%@ page import="com.theavocadopapers.hibernate.SessionWrapper" %>
<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<%@ include file="../../global/topInclude.jsp" %>
<%

SessionWrapper sessionWrapper=(SessionWrapper)request.getAttribute("sessionWrapper");

List allUsers;
List allUserDatas;

if (sessionWrapper==null) {
	allUsers=User.getAll();
	allUserDatas=PreRegistrationUserData.getAll();
}
else {
	allUsers=User.getAll(sessionWrapper);
	allUserDatas=PreRegistrationUserData.getAll(sessionWrapper);	
}

allUserDatas=(allUserDatas==null?new ArrayList():allUserDatas);

List allUsernames=new ArrayList(allUsers.size()+allUserDatas.size());
for (int i=0; i<allUsers.size(); i++) {
	User user=(User)allUsers.get(i);
	allUsernames.add(user.getUsername());
}
for (int i=0; i<allUserDatas.size(); i++) {
	PreRegistrationUserData userData=(PreRegistrationUserData)allUserDatas.get(i);
	allUsernames.add(userData.getUsername());
}


StringBuffer s=new StringBuffer("var "+controller.getParam("jsVarName")+"=[");
for (int i=0; i<allUsernames.size(); i++)
{
	if (i>0)
	{
		s.append(",");
	}
	s.append("\""+(String)allUsernames.get(i)+"\"");
}
s.append("]");
out.print(s.toString());
%>


<%@ include file="../../global/bottomInclude.jsp" %>


<%
if (pageException!=null)
{
	%>
	<%@ include file="../../global/jspErrorDialogLaunch.jsp" %>
	<%
}
%>



