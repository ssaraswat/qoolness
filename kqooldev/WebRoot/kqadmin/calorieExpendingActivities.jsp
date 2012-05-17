<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.ExerciseComparator" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_OTHER,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

String mode=controller.getParam("mode"); // "add" or "edit"
boolean success=controller.getParamAsBoolean("success",true);
String sort=controller.getParam("sort","name");
boolean showFullDesc=controller.getParamAsBoolean("showFullDesc",false);

List allActivities=CalorieExpendingActivity.getAll();

if (allActivities==null)
{
	allActivities=new ArrayList();
}
// sort by name first, regardless of sortparam:
Collections.sort(allActivities);


String[] names=new String[allActivities.size()];
double[] calsPerMinutePerLbs=new double[allActivities.size()];
int[] ids=new int[allActivities.size()];






for (int i=0; i<allActivities.size(); i++)
{
	CalorieExpendingActivity activity=(CalorieExpendingActivity)allActivities.get(i);
	names[i]=activity.getName();
	calsPerMinutePerLbs[i]=activity.getCalsPerMinutePerLb();
	ids[i]=activity.getId();
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">

function confirmDelete(id) {
	if (confirm("Okay to permanently delete this activity?")) {
		location.href="deleteCalorieExpendingActivity.jsp?<%=controller.getSiteIdNVPair()%>&id="+id
	}
}

</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardAdminTextBlockWidth">
<form>
<font class="bodyFont">


<%
String action=controller.getParam("action");

if (success)
{
	if (action==null || action.trim().equals("")) {
		%>
		<span class="firstSentenceFont">Edit calorie-expending activities here.</span><br />
		The current list of activities appears below. <% pageContext.include("includes/calsExpendedPopupLink.jsp"); %><br /><br />	
		<%
	}
	else if (action.equals("delete")) {
		%>
		
		<span class="firstSentenceFont">Edit calorie-expending activities here.</span><br />
		The current list of activities appears below.<br /><br />	
		<i style="color:#cc0000;">Note: The "<%=request.getParameter("name")%>" activity was successfully deleted.</i> <% pageContext.include("includes/calsExpendedPopupLink.jsp"); %><br /><br />

		<%
	}
}
else
{
	%>
	<span class="firstSentenceFont">There was a problem.</span> <br />
	Some or all of your data may not have been processed. The current list of activities is below. <% pageContext.include("includes/calsExpendedPopupLink.jsp"); %>

	<%
}
%>

<table border="0" cellspacing="0" cellpadding="0" width="534"> 
<%=HtmlUtils.getHorizRuleTr(6, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td nowrap="nowrap" width="5" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td nowrap="nowrap" width="107" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Name&nbsp;&nbsp;&nbsp;<br /></font></td>
<td nowrap="nowrap" width="240" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Calories&nbsp;Expended&nbsp;Per&nbsp;Minute&nbsp;Per&nbsp;Lb.&nbsp;<br /></font></td>
<td nowrap="nowrap" width="90" valign="middle" align="center"><font class="boldishColumnHeaderFont"><img src="../images/spacer.gif" height="1" width="1" /><br /></font></td>
<td nowrap="nowrap" width="90" valign="middle" align="center"><font class="boldishColumnHeaderFont"><img src="../images/spacer.gif" height="1" width="1" /><br /></font></td>
<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(6, request)%>

 </table>
<% 

for (int i=0; i<names.length; i++)
{
	%>
	<table border="0" cellspacing="0" cellpadding="0" width="534"> 
	<input type="hidden" name="id<%=i%>" id="id<%=i%>" value="<%=ids[i]%>">
	<tr valign="top" class=<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%>>
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td align="left" style="width:5px; padding-top:4px; padding-bottom:4px;"><font class="columnDataFont">&nbsp;<br /></font></td>
	<td align="left" style="width:107px; padding-top:4px; padding-bottom:4px; padding-left:4px; padding-right:4px;"><font class="columnDataFont"><%=names[i]%><br /></font></td>
	<td align="left" style="width:240px; padding-top:4px; padding-bottom:4px;"><font class="columnDataFont"><%=calsPerMinutePerLbs[i]%>&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="left" style="width:90px; padding-top:4px; padding-bottom:4px;">&nbsp;<%=HtmlUtils.smallCpFormButton(false, "edit", "location.href='editCalorieExpendingActivity.jsp?"+controller.getSiteIdNVPair()+"&id="+ids[i]+"'", request)%><br /></font></td>
	<td align="left" style="width:90px; padding-top:4px; padding-bottom:4px;">&nbsp;<%=HtmlUtils.smallCpFormButton(false, "remove", "confirmDelete("+ids[i]+")", request)%><br /></font></td>
	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr>

	<%=HtmlUtils.getHorizRuleTr(6	, request)%>
	</table>
	<%
	response.flushBuffer();
	out.flush();
}


%>

<br />

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

