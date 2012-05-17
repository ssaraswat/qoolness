<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("superuser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">






</script>

<style type="text/css">
body {background-image:url(); font-size:11px; font-family:arial, helvetica; }
td {font-size:11px; font-family:arial, helvetica; }
</style>
</head>

<%@ include file="/global/x_bodyOpen.jsp" %>

<blockquote>
<br /><br />
<a href="x_formatExerciseNames.jsp">Format exercise names</a><br />
<a href="x_formatVideoNames.jsp">Format video names</a><br />
<a href="x_manageArticles.jsp">Manage articles</a><br />
<a href="x_manageVideos.jsp">Manage videos</a><br />
<a href="x_integrityChecks.jsp">Integrity checks</a><br />
<a href="x_checkCategories.jsp">Check video and exercise categories</a><br />


</blockquote>

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

