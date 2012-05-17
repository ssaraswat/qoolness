<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setSkipMaxUsersExceededCheck(true,request); %>

<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
  
<%@ include file="/global/topInclude.jsp" %>

<%! 

%>

<%


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






<span class="standardAdminTextBlockWidth">

<font class="bodyFont">

<span class="firstSentenceFont">Control things from here.</span><br />
These control-center screens are visible only to backend users.  
This is where you create user accounts, manage exercises,
and combine exercises to create the routines you assign to your clients.
Please use the menus above to navigate.

<%=HtmlUtils.doubleLB(request)%>

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

