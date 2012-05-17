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
ConnectionWrapper cw=DatabaseManager.getConnection();


List articles=null;
try {
	articles=Article.selectAll(cw);
}
catch (ExpectedDataNotFoundException e) {}
if (articles==null) {
	articles=new ArrayList();
}



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

<blockquote><br /><br />

<a href="x_article.jsp?id=0">[add article]</a><br /><br />

Edit articles:<br />
<table border=1>
<%
for (int i=0; i<articles.size(); i++) {
	Article article=(Article)articles.get(i);
	%>
	<tr valign="top">
	<td><%=article.getTitle()%><br /></td>
	<td><a href="x_article.jsp?id=<%=article.getId()%>">[edit]</a><br /></td>
	</tr>
	<%
}
%>
</table>

</blockquote>

<%@ include file="/global/bodyClose.jsp" %>

</html>


<%
DatabaseManager.closeConnection(cw);
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

