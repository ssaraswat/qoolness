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
static final int NUM_ACTIVITIES_ADD_AT_ONCE=1;
%>

<%


User user=controller.getSessionInfo().getUser();



String[] names=new String[NUM_ACTIVITIES_ADD_AT_ONCE];
double[] calsPerMinutePerLbs=new double[NUM_ACTIVITIES_ADD_AT_ONCE];

int[] ids=new int[NUM_ACTIVITIES_ADD_AT_ONCE];


CalorieExpendingActivity activity=CalorieExpendingActivity.getById(controller.getParamAsInt("id"));

for (int i=0; i<1; i++)
{
	names[i]=activity.getName();
	ids[i]=activity.getId();

	calsPerMinutePerLbs[i]=activity.getCalsPerMinutePerLb();

}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">


var NUM_ACTIVITIES_ADD_AT_ONCE=<%=NUM_ACTIVITIES_ADD_AT_ONCE%>



<% pageContext.include("includes/writeAllActivityNamesArray.jsp?jsVarName=allNames"); %>

function isValidForm(formObj)
{

	var els=formObj.elements

			var i=0
			if (trim(els["name"+i].value).length==0)
			{
				errorAlert("You have not entered a name for this activity; please fix and try again.",els["name"+i])
				return false
			}
			if (trim(els["name"+i].value).length>100)
			{
				errorAlert("The name you have entered is "+trim(els["name"+i].value).length+" characters long; the maximum length is 100. Please fix and try again.",els["name"+i])
				return false
			}	
			if (trim(els["calsPerMinutePerLb"+i].value).length==0)
			{
				errorAlert("You have not entered a calories value. Please fix and try again.",els["calsPerMinutePerLb"+i])
				return false
			}	
			if (!isNumber(els["calsPerMinutePerLb"+i].value))
			{
				errorAlert("The calories value you have entered, \""+els["calsPerMinutePerLb"+i].value+"\", is not a number. Please fix and try again.",els["calsPerMinutePerLb"+i])
				return false
			}	
			if (parseFloat(els["calsPerMinutePerLb"+i].value)<=0)
			{
				errorAlert("The calories value you have entered, \""+els["calsPerMinutePerLb"+i].value+"\", is a negative number (or zero). Please fix and try again.",els["calsPerMinutePerLb"+i])
				return false
			}	

	if (confirm("A person weighing 200 pounds would expend approximately "+(Math.floor(parseFloat(els["calsPerMinutePerLb"+i].value)*200*60))+" calories performing this activity for an hour; is this correct?")) {
		hidePageAndShowPleaseWait()
		return true
	} 
	return false
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

<form action="processCalorieExpendingActivity.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="numActivities" id="numActivities" value="<%=names.length%>">
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Here is the <%=activity.getName()%> calorie-expending activity.</span><br />
Make changes to it, then press "save changes" below.  <% pageContext.include("includes/calsExpendedPopupLink.jsp"); %></span><%=HtmlUtils.doubleLB(request)%><br />



<% 

for (int i=0; i<NUM_ACTIVITIES_ADD_AT_ONCE; i++)
{
	%>
	<input  type="hidden"  name="id<%=i%>" id="id<%=i%>" value="<%=ids[i]%>">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<font class="boldishFont">Name:<br /></font>
	<font class="columnDataFont"><input class="inputText" type="text" style="width:300px;" name="name<%=i%>" id="name<%=i%>" value="<%=names[i]%>"><br /></font>
	
	<br />
	<font class="boldishFont">Calories Expended Per Minute Per Lb.:<br /></font>
	<font class="columnDataFont">
	<input type="text"  class="inputText"  name="calsPerMinutePerLb<%=i%>" id="calsPerMinutePerLb<%=i%>"  style="width:50px; " value="<%=calsPerMinutePerLbs[i]%>"><br /></font></td>
	<td align="left" nowrap="nowrap" width="1"><br />

	<%
}

%>

<br />

<%=HtmlUtils.cpFormButton(true, "save", null, request)%>

<%=HtmlUtils.doubleLB(request)%><br />
<a name="bottom"></a>

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

