<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_OTHER,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_ACTIVITIES_ADD_AT_ONCE=10;
%>

<%


User user=controller.getSessionInfo().getUser();



String[] names=new String[NUM_ACTIVITIES_ADD_AT_ONCE];
double[] calsPerMinutePerLbs=new double[NUM_ACTIVITIES_ADD_AT_ONCE];


for (int i=0; i<NUM_ACTIVITIES_ADD_AT_ONCE; i++)
{
	names[i]="";
	calsPerMinutePerLbs[i]=0.0;

}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script language="JavaScript">


var NUM_ACTIVITIES_ADD_AT_ONCE=<%=NUM_ACTIVITIES_ADD_AT_ONCE%>

<% pageContext.include("includes/writeAllActivityNamesArray.jsp?jsVarName=allNames"); %>

function isValidForm(formObj)
{
	if (noActivitiesEntered(formObj,NUM_ACTIVITIES_ADD_AT_ONCE))
	{
		return false
	}
	var els=formObj.elements
	// we have at least one activity; make sure that all activities entered have all fields entered:

	for (var i=0; i<NUM_ACTIVITIES_ADD_AT_ONCE; i++)
	{
		if (trim(els["name"+i].value).length>0)
		{ 
			if (els["name"+i].value.length>100)
			{
				errorAlert("The name you have entered on row "+(i+1)+" is "+els["name"+i].value.length+" characters long; the maximum length is 100. Please fix and try again.",els["name"+i])
				return false
			}
			if (trim(els["name"+i].value).length==0)
			{
				errorAlert("You have not entered a name for the activity on row "+(i+1)+"; please fix and try again.",els["name"+i])
				return false
			}
			if (trim(els["name"+i].value).length>100)
			{
				errorAlert("The name you have entered on row "+(i+1)+" is "+trim(els["name"+i].value).length+" characters long; the maximum length is 100. Please fix and try again.",els["name"+i])
				return false
			}	
			if (trim(els["calsPerMinutePerLb"+i].value).length==0)
			{
				errorAlert("You have not entered a calories value for the \""+els["name"+i].value+"\" activity. Please fix and try again.",els["calsPerMinutePerLb"+i])
				return false
			}	
			if (!isNumber(els["calsPerMinutePerLb"+i].value))
			{
				errorAlert("The calories value you have entered for the \""+els["name"+i].value+"\" activity, \""+els["calsPerMinutePerLb"+i].value+"\", is not a number. Please fix and try again.",els["calsPerMinutePerLb"+i])
				return false
			}	
			if (parseFloat(els["calsPerMinutePerLb"+i].value)<=0)
			{
				errorAlert("The calories value you have entered for the \""+els["name"+i].value+"\" activity, \""+els["calsPerMinutePerLb"+i].value+"\", is a negative number (or zero). Please fix and try again.",els["calsPerMinutePerLb"+i])
				return false
			}	

		}
	}

	// user tried to add a username that was already in the db:
	if (duplicateActivityNameFound(formObj,NUM_ACTIVITIES_ADD_AT_ONCE))
	{
		return false
	}
	// user tried to add two users with the same username:
	if (duplicateActivityNamesInForm(formObj,NUM_ACTIVITIES_ADD_AT_ONCE))
	{
		return false
	}	
	hidePageAndShowPleaseWait()
	return true
}



<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>
<a name="top"></a>
<div id="mainDiv">

<form action="processAddCalorieExpendingActivities.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="numActivities" id="numActivities" value="<%=names.length%>">
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Add calorie-expending activities here.</span><br/>
These activities appear in the calories-expended popup.  You may add up to 
<%=NUM_ACTIVITIES_ADD_AT_ONCE%> activities at a time. If you need to add fewer than that, 
leave the unneeded activity rows blank.  <% pageContext.include("includes/calsExpendedPopupLink.jsp"); %></span><%=HtmlUtils.doubleLB(request)%><BR>

<table border="0" cellspacing="0" cellpadding="0">
<%=HtmlUtils.getHorizRuleTr(6, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<BR></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Name&nbsp;&nbsp;&nbsp;<BR></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Calories&nbsp;Expended&nbsp;Per&nbsp;Minute&nbsp;Per&nbsp;Lb.&nbsp;&nbsp;&nbsp;<BR></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont"><img src="../images/spacer.gif" height="1" width="1" /><BR></font></td>
<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(6, request)%>

 

<% 

for (int i=0; i<NUM_ACTIVITIES_ADD_AT_ONCE; i++)
{
	%>
	<tr valign="middle" class="<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%>" height="24">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td align="left"><font class="columnDataFont">&nbsp;<%=(i+1)%>.<BR></font></td>
	<td align="left"><font class="columnDataFont">&nbsp;<input class="inputText" type="text" style="width:180px;" name="name<%=i%>" id="name<%=i%>" value="<%=names[i]%>"><BR></font></td>
	<td align="left" colspan="2"><font class="columnDataFont">&nbsp;<input class="inputText" type="text" style="width:50px;" name="calsPerMinutePerLb<%=i%>" id="calsPerMinutePerLb<%=i%>" value="<%=calsPerMinutePerLbs[i]%>"><BR></font></td>
	
	<%=HtmlUtils.getSingleRuleCell(request)%>
	
	</tr>
	<%=HtmlUtils.getHorizRuleTr(6, request)%>
	<%
}

%>

</table><BR>

<%=HtmlUtils.cpFormButton(true, "add", null, request)%>
<%=HtmlUtils.cpFormButton(false, "cancel", "location.replace('menu.jsp?"+controller.getSiteIdNVPair()+"')", request)%>
<%=HtmlUtils.doubleLB(request)%><BR>
<a name="bottom"></a>

<br></font>

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

