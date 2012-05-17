<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>


<%!

static CalorieWeek getWeekByIdFromList(List weeks, int weekId) {
	int numWeeks=weeks.size();
	CalorieWeek week;
	for (int i=0; i<numWeeks; i++) {
		week=(CalorieWeek)weeks.get(i);
		if (week.getId()==weekId) {
			return week;
		}
	}
	throw new RuntimeException("No CalorieWeek found with ID "+weekId+".");
}

%>

<%


User user=controller.getSessionInfo().getUser();


int viewUserId;
User viewUser;
try {
	viewUserId=Integer.parseInt(request.getParameter("viewUserId"));
	if (viewUserId>0) {
		viewUser=User.getById(viewUserId);
	}
	else {
		viewUser=user;
	}
}
catch (RuntimeException e) {
	viewUserId=0;
	viewUser=user;
}

// note: let's make the default for nutritionists true, not false (for clients, though, this is appropriate):
boolean advancedViewMode=controller.getParamAsBoolean("advancedViewMode", false);




// note: list will always contain at least two elements (last week and this week); note also that weeks which are not assocaited with any actual user entries are not included:
List weeks=CalorieWeek.getAllByUserId(viewUser.getId(), true);

int weekId;
try {
	weekId=Integer.parseInt(request.getParameter("weekId"));
}
catch (RuntimeException e) {
	weekId=((CalorieWeek)weeks.get(weeks.size()-1)).getId();
}

int dayIndex;
boolean dayIndexSpecified=false;
try {
	dayIndex=Integer.parseInt(request.getParameter("dayIndex"));
	dayIndexSpecified=true;
}
catch (RuntimeException e) {
	dayIndex=0;
}

int numWeeks=weeks.size();
CalorieWeek week;
String label;
DateFormat dateFormat=new SimpleDateFormat("MMMM dd, yyyy");
Calendar startDate;
Calendar endDate;
boolean thisWeek=false;


//CalorieWeek week=getWeekByIdFromList(weeks, weekId);


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

//  note: can be reset by doc in iframe below:

var unsavedChanges=false

var weekId=<%=weekId%>
var viewUserId=<%=viewUserId%>


var advancedViewMode=<%=advancedViewMode%>

function changeDay(dayIndex) {
	if (viewUserId==0) {
		if (!unsavedChanges || confirm("You have unsaved changes; okay to discard them?  If not, press \"cancel\" and then click \"save\".")) {
			location.replace("calorieSpreadsheet.jsp?<%=controller.getSiteIdNVPair()%>&dayIndex="+dayIndex+"&weekId="+weekId+"#iframeTop");
		}
	}
	else {
		location.replace("calorieSpreadsheet.jsp?<%=controller.getSiteIdNVPair()%>&viewUserId="+viewUserId+"&dayIndex="+dayIndex+"&weekId="+weekId+"#iframeTop");
	}

}





function getWeek(selectMenu) {	
	window.frames["weeksheet"].location.replace("spreadsheetFrame.jsp?advancedViewMode="+advancedViewMode+"&siteId=<%=controller.getSiteId()%>&viewUserId=<%=viewUserId%>&weekId="+selectMenu.options[selectMenu.selectedIndex].value+"&dayIndex=0");
}



</script> 

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">


<font class="bodyFont">
<span style="width:250px; display:block;">


  


<div style="width:250px;">


<%
if (viewUserId==0) {
	%>
	<span class="firstSentenceFont">Your calories.</span><br />
	Below are the calories you've consumed and the calories
	you've expended by exercising.  The information on this screen comes from food
	you've entered on the 
	<a href="caloriesIngested.jsp?siteId=<%=controller.getSiteId()%>">What'd you eat?</a>
	 screen and from the <a href="workoutList.jsp?siteId=<%=controller.getSiteId()%>&selfAssign=true&prescriptive=false">workouts you've
	stored</a>.<br /><br />
	<%
}
else {
	%>
	<span class="firstSentenceFont">Here is <%=""+viewUser.getFormattedNameAndUsername()%>'s calorie table.</span><br /><br />
	<%
}
%>
	
	
</div>



</div>
</font>

</span>
</div>
<div style="border:1px solid #cccccc; background-color:#dddddd; padding:1px; width:904px;overflow:visible;">
<table width="901"  bgcolor="#ffffff" border="0" cellspacing="0" cellpadding="0" style="border-bottom:3px solid #ffffff;">
<form action="#" onsubmit="return false">
<tr>
<td nowrap="nowrap" height="21" width="95">
<span class="bodyFont">&nbsp;Choose&nbsp;a&nbsp;week:</span><br />
</td>
<td><a name="iframeTop"></a><select  class="selectText" style="font-size:11px; margin-left:3px;" name="weekId" onchange="getWeek(this)">

<%
for (int i=0; i<numWeeks; i++) {
	week=(CalorieWeek)weeks.get(i);
	if (i==numWeeks-1) {
		label="This week";
		thisWeek=(weekId==week.getId());
	}
	else if (i==numWeeks-2) {
		label="Last week";
	}
	else {
		startDate=new GregorianCalendar(week.getStartDateYear(), week.getStartDateMonth(), week.getStartDateDate());
		endDate=new GregorianCalendar();
		endDate.setTime(startDate.getTime());
		endDate.add(Calendar.DATE, 6);
		label=dateFormat.format(startDate.getTime())+" - "+dateFormat.format(endDate.getTime());
	}
	%>
	<option value="<%=week.getId()%>" <%=(weekId==week.getId()?" selected ":"")%>><%=label%></option>
	<%
}

if (thisWeek) {
	// if the week is this week, we want the day index to be today if one wasn't specified:
	if (!dayIndexSpecified) {
		Calendar now=new GregorianCalendar();
		dayIndex=now.get(Calendar.DAY_OF_WEEK)-1;
	}
}
%>


</select>
</td>
<td>&nbsp;</td>
<td align="right"><br />
</td>
</tr>
</table>


<iframe src="spreadsheetFrame.jsp?advancedViewMode=<%=advancedViewMode%>&<%=controller.getSiteIdNVPair()%>&viewUserId=<%=viewUserId%>&weekId=<%=weekId%>&dayIndex=<%=dayIndex%>" style="border:1px solid #cccccc;" name="weeksheet" id="weeksheet" width="900" height="508"  marginwidth="3" marginheight="3" scrolling="auto" frameborder="0"></iframe>
</div>
<br /><br />
</span>
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

