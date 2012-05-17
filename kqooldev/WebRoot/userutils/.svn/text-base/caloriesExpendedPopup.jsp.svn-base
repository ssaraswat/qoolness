<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%
long start=new Date().getTime();
%>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.*" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_UTILS,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%







List allActivities=CalorieExpendingActivity.getAll();
if (allActivities==null) {
	allActivities=new ArrayList(0);
}
Collections.sort(allActivities);
NumberFormat fmt=NumberFormat.getInstance();
fmt.setGroupingUsed(false);

double weight;
try {
	weight=Double.parseDouble(request.getParameter("weight"));
}
catch (RuntimeException e) {
	weight=0.0;
}
if (weight==0.0) {
	weight=160.0;
}
else {
	weight=Math.round(weight/5);
	weight*=5;
}

 

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">

function Activity(calsPerMinutePerLb, name, id) {
	this.calsPerMinutePerLb=calsPerMinutePerLb
	this.name=name
	this.id=id
}

var activities=[]
<%
CalorieExpendingActivity activity;
for (int i=0; i<allActivities.size(); i++) {
	activity=(CalorieExpendingActivity)allActivities.get(i);
	%>
	activities[<%=activity.getId()%>]=new Activity(<%=activity.getCalsPerMinutePerLb()%>, "<%=activity.getName()%>", <%=activity.getId()%>)
	<%
}
%>


function recalculate() {
	var activity=activities[parseInt(document.getElementById("activity").options[document.getElementById("activity").selectedIndex].value)]
	var time=parseInt(document.getElementById("time").options[document.getElementById("time").selectedIndex].value)
	var weight=parseInt(document.getElementById("weight").options[document.getElementById("weight").selectedIndex].value)
	var calories=activity.calsPerMinutePerLb*time*weight
	document.getElementById("activityDiv").innerHTML=activity.name.toLowerCase()+" "
	document.getElementById("weightDiv").innerHTML=""+weight+" "
	document.getElementById("timeDiv").innerHTML=""+time+" "
	document.getElementById("caloriesDiv").innerHTML=""+parseInt(calories)+" "
	
}

</script>

<style type="text/css">
		body {background-repeat:repeat-x; background-image:url(<%=PageUtils.getPathToAppRoot(request)%>images/bg_popup.gif); }

</style>
</head>

<body bgcolor="#ffffff" topmargin="0" leftmargin="0" onload="recalculate()">
<div id="mainDiv" class="bodyFont" style="position:absolute; top:50px; width:280px;left:15px; ">
<span class="firstSentenceFont">Burn, burn, burn!</span><br />
You expend calories twenty-four hours a day.  Some activities, or course, burn more calories than others.  Choose an activity below and an amount of time you might spend doing it, and enter your weight, to see to get a rough idea of how many calories you expend perforning different activities.<br /><br />

<form action="#" onsubmit="return false">

<span class="boldishFont">Activity</span><br />
<select name="activity" id="activity"  class="selectText" style="margin-bottom:10px; width:266px;" onchange="recalculate()">
<%
for (int i=0; i<allActivities.size(); i++) {
	activity=(CalorieExpendingActivity)allActivities.get(i);
	%>
	<option value="<%=activity.getId()%>"><%=activity.getName()%></option>
	<%
}
%>
</select><br />


<span class="boldishFont">Time</span><br />
<select style="margin-bottom:10px;width:100px" name="time" id="time"  class="selectText" onchange="recalculate()">
<%
for (int i=5; i<=120; i+=5) {
	%>
	<option <%=(i==45?" selected ":"")%> value="<%=i%>"><%=i%> minutes</option>
	<%
}
%>
<option value="150">2 1/2 hours</option>
<option value="180">3 hours</option>
<option value="210">3 1/2 hours</option>
<option value="240">4 hours</option>
<option value="270">4 1/2 hours</option>
<option value="300">5 hours</option>

</select><br />

<span class="boldishFont">Your weight</span><br />
<select style="margin-bottom:10px;width:100px" name="weight" id="weight"  class="selectText" onchange="recalculate()">
<%
for (int i=60; i<=300; i+=5) {
	%>
	<option <%=(i==(int)weight?" selected ":"")%> value="<%=i%>"><%=i%> lbs</option>
	<%
}
%>

</select><br />

<div style="padding:4px; background-color:#eeeeee;color:#000000; width:280px;">A person who weighs <b id="weightDiv"></b> pounds and performs <b id="timeDiv"></b> minutes of <b id="activityDiv"></b>  will burn about <b id="caloriesDiv" style=""></b> calories.</div><br />

</form>

<br />

</div>



<%@ include file="/global/trackingCode.jsp" %>


</body>

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

<%
long end=new Date().getTime();
%>