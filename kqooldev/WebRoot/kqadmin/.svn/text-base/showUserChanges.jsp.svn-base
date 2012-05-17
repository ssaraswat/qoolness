<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%


String mode=controller.getParam("mode"); // "add" or "edit"
boolean success=controller.getParamAsBoolean("success",true);


List allUsers=User.getAll();
if (allUsers==null)
{
	allUsers=new ArrayList();
}

Collections.sort(allUsers);

String[] usernames=new String[allUsers.size()];
String[] firstNames=new String[allUsers.size()];
String[] lastNames=new String[allUsers.size()];
String[] emailAddresses=new String[allUsers.size()];
String[] comments=new String[allUsers.size()];
String[] statuses=new String[allUsers.size()];
int[] ids=new int[allUsers.size()];

for (int i=0; i<allUsers.size(); i++)
{
	User user=(User)allUsers.get(i);
	usernames[i]=user.getUsername();
	firstNames[i]=user.getFirstName();
	lastNames[i]=user.getLastName();
	emailAddresses[i]=user.getEmailAddress();
	comments[i]=user.getCommentsUserHidden();
	switch (user.getStatus()) {
		case User.STATUS_PREACTIVE : statuses[i]="preactive"; break;
		case User.STATUS_ACTIVE : statuses[i]="active"; break;
		case User.STATUS_SUSPENDED : statuses[i]="suspended"; break;
		case User.STATUS_DEACTIVATED : statuses[i]="deactivated"; break;
		default : statuses[i]="unknown";
	}
	ids[i]=user.getId();
}

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
<form>
<font class="bodyFont">


<%
if (success)
{
	if (mode.equals("view"))
	{
		%>
		<span class="firstSentenceFont">The current list of users is below.</span>  You may now:
		<ul>
		<li><a href="addUsers.jsp?<%=controller.getSiteIdNVPair()%>">add users</a></li>
		<li><a href="users.jsp?<%=controller.getSiteIdNVPair()%>">edit users</a></li>
		<li><a href="menu.jsp?<%=controller.getSiteIdNVPair()%>">return to the main admin screen</a></li>
		<li><a href="../login/logout.jsp?<%=controller.getSiteIdNVPair()%>">log out</a></li>
		</ul>
		<%
	}
	if (mode.equals("edit"))
	{
		%>
		<span class="firstSentenceFont">Your changes have been made.</span> The current list of users appears below. You may now:
		<ul>
		<li><a href="addUsers.jsp?<%=controller.getSiteIdNVPair()%>">add users</a></li>
		<li><a href="users.jsp?<%=controller.getSiteIdNVPair()%>">make more user changes</a></li>
		<li><a href="menu.jsp?<%=controller.getSiteIdNVPair()%>">return to the main admin screen</a></li>
		<li><a href="../login/logout.jsp?<%=controller.getSiteIdNVPair()%>">log out</a></li>
		</ul>
		<%
	}
	if (mode.equals("add"))
	{
		%>
		<span class="firstSentenceFont">Your additions have been made.</span> The current list of users appears below. You may now:
		<ul>
		<li><a href="addUsers.jsp?<%=controller.getSiteIdNVPair()%>">add more users</a></li>
		<li><a href="users.jsp?<%=controller.getSiteIdNVPair()%>">edit users</a></li>
		<li><a href="menu.jsp?<%=controller.getSiteIdNVPair()%>">return to the main admin screen</a></li>
		<li><a href="../login/logout.jsp?<%=controller.getSiteIdNVPair()%>">log out</a></li>
		</ul>
		<%
	}
}
else
{
	%>
	<span class="firstSentenceFont">There was a problem.</span> Some or all of your data may not have been saved. The current list of users is below.

	<%
}
%><br /><br />

<table border="0" cellspacing="0" cellpadding="0" width="650"> 
<%=HtmlUtils.getHorizRuleTr(8, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Username&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Full Name&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Email Address&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Status&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Comments <span style="font-weight:normal;">(not user-visible)</span>&nbsp;<br /></font></td>

<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(8, request)%>

 
<% 

for (int i=0; i<usernames.length; i++)
{
	%>
	<input type="hidden" name="id<%=i%>" id="id<%=i%>" value="<%=ids[i]%>">
	<tr class="<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%>" height="22">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td align="left"><font class="columnDataFont">&nbsp;<br /></font></td>
	<td align="left"><font class="columnDataFont">&nbsp;<%=usernames[i]%>&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="left"><font class="columnDataFont"><nobr>&nbsp;<%=lastNames[i]%>,&nbsp;<%=firstNames[i]%>&nbsp;&nbsp;&nbsp;<br /></nobr></font></td>
	<td align="left"><font class="columnDataFont">&nbsp;<%=HtmlUtils.getMailtoLink(emailAddresses[i])%>&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="left"><font class="columnDataFont">&nbsp;<%=statuses[i]%>&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="left"><div style="width:180px;"><font class="columnDataFont"><%=comments[i]%></font></div></td>
	
	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr>
	<%=HtmlUtils.getHorizRuleTr(8, request)%>
	<%
}

%>

</table><br />

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form></span>
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

