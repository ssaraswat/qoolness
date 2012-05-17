<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_OTHER,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%



List allSites=Site.getAll();

if (allSites==null) {
	allSites=new ArrayList(0);
}
Collections.sort(allSites);


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">
<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
.actionFormButton {font-size:11px; font-family:arial,helvetica; width:40px; background-color:#ff6600; border:1px solid #000000; color:#ffffff; }
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<form action="#" method="post" onsubmit="return false" name="mainForm" id="mainForm">
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Here are all sites in the Kqool network.</span><br />
To view or edit any of them, click the site's name.  Click the "to main menu" button below to return 
to the admin homepage.</span><%=HtmlUtils.doubleLB(request)%><br />

<table border="0" cellspacing="0" cellpadding="0">
<%=HtmlUtils.getHorizRuleTr(6, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Name&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Domain&nbsp;Prefix&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Comments&nbsp;&nbsp;&nbsp;<br /></font></td>



<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(6, request)%>

<%
for (int i=0; i<allSites.size(); i++) {
	Site site=(Site)allSites.get(i);

	%>
	<tr valign="middle" class=<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%> height="24">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td align="left"><font class="columnDataFont">&nbsp;<br /></font></td>
	<td align="left" nowrap><font class="columnDataFont">&nbsp;<a href="site.jsp?mode=edit&siteId=<%=controller.getSiteId()%>&id=<%=site.getId()%>"><%=site.getLabel()%></a>&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="left"><font class="columnDataFont"><%=site.getDomainPrefix()%></font></td>
	<td align="left"><font class="columnDataFont"><div style="margin:0px 5px 0px 5px;"><%=site.getComments()%></div></font></td>
	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr> 
	<%=HtmlUtils.getHorizRuleTr(6, request)%>
<%
}
%>



</table>

<br />



<%=HtmlUtils.cpFormButton(false, "to main menu", "location.replace('menu.jsp?"+controller.getSiteIdNVPair()+"')", request)%><br />

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form>
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

