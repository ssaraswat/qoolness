<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>



<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>

<%@ include file="/global/topInclude.jsp" %>

<%

String retUrl="nutritionist.jsp?" + controller.getSiteIdNVPair();

User user=controller.getSessionInfo().getUser();
user.setNutritionist(true);
user.store();

%>

<script type="text/javascript">
alert("Your changes have been saved.")
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

