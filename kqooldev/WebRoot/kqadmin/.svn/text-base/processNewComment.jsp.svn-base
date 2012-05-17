<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
<%@ page import="com.theavocadopapers.apps.kqool.pfd.*" %>
 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setShowTopNav(false,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%

int userId=controller.getParamAsInt("userId");
int commentingUserId=controller.getParamAsInt("commentingUserId");
String retUrl=controller.getParam("retUrl");
String newComment=controller.getParam("newComment");

PfdComment pfdComment=new PfdComment();
pfdComment.setCommentingUserId(commentingUserId);
pfdComment.setUserId(userId);
pfdComment.setCommentText(newComment);
pfdComment.store();

%>
<script>
alert("Your comment has been added.")
</script>
<%

out.flush();
response.flushBuffer();
%>




<script>
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

