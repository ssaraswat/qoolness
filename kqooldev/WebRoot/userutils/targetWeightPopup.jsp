<%
/*
Note: This JSP (using JavaScript) calculates BMI based on the following formula:

BMI = 703 * (weight/(height*height))

...where weight is measured in lbs and height in in..

See http://en.wikipedia.org/wiki/Body_mass_index for more.

*/


%>

<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%
NumberFormat fmt=NumberFormat.getInstance();
fmt.setMinimumFractionDigits(0);

int caloriesPerPound=3500;
int caloriesPerPint=1000;
int caloriesBurnedPerDay=2000;


long start=new Date().getTime();
%>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.*" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_UTILS,request); %>


<%@ include file="/global/topInclude.jsp" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script language="JavaScript" src="../global/NumberFormat.js"></script>
<script type="text/javascript">


var caloriesPerPound=<%=caloriesPerPound%>;
var caloriesPerPint=<%=caloriesPerPint%>;
var caloriesBurnedPerDay=<%=caloriesBurnedPerDay%>;
var costPerCalorie=0.0035;

var caloriesBurnedPerMonth=caloriesBurnedPerDay*30

var intFormat=new NumberFormat()
intFormat.setMaximumFractionDigits(0)
intFormat.setGroupingUsed(true)


var singleDecPlaceFormat=new NumberFormat()
singleDecPlaceFormat.setMaximumFractionDigits(1)
singleDecPlaceFormat.setGroupingUsed(true)



function getGoalWeight(totalInches, targetBmi) {
	return (targetBmi*totalInches*totalInches)/703	
}



function recalculate() {
	var feetInInches=parseInt(document.getElementById("feetInInches").options[document.getElementById("feetInInches").selectedIndex].value)
	var inches=parseFloat(document.getElementById("inches").options[document.getElementById("inches").selectedIndex].value)
	var totalInches=feetInInches+inches
	var pounds=parseFloat(document.getElementById("pounds").options[document.getElementById("pounds").selectedIndex].value)
	var targetBmi=parseFloat(document.getElementById("targetBmi").options[document.getElementById("targetBmi").selectedIndex].value)
	
	var calculatedCurrBmi=703*(pounds/(totalInches*totalInches))


	var calculatedGoalWeight=getGoalWeight(totalInches, targetBmi)
	var calculatedPoundsToLose=pounds-calculatedGoalWeight
	var calculatedPintMonths=caloriesPerPound*calculatedPoundsToLose/caloriesBurnedPerMonth
	if (calculatedPintMonths>=1) {
		calculatedPintMonths=Math.round(calculatedPintMonths)
	}

	var calculatedPintMonthsStr
	if (calculatedPintMonths==1) {
		calculatedPintMonthsStr="a month"
	}
	else if (calculatedPintMonths<1) {
		calculatedPintMonthsStr=""+Math.ceil(calculatedPintMonths*4)+" week"+(Math.ceil(calculatedPintMonths*4)!=1?"s":"")
	}
	else  {
		calculatedPintMonthsStr=""+intFormat.format(calculatedPintMonths)+" months"
	}




	var height=(feetInInches/12)+"' "+inches+"\""
	var currWeight=pounds+" pounds"
	var currBmi=singleDecPlaceFormat.format(calculatedCurrBmi)
	var goalBmi=""+targetBmi
	var goalWeight=singleDecPlaceFormat.format(calculatedGoalWeight)
	var poundsToLose=singleDecPlaceFormat.format(calculatedPoundsToLose)
	var currStoredCalories=intFormat.format(caloriesPerPound*calculatedPoundsToLose)
	var numPints=intFormat.format((caloriesPerPound*calculatedPoundsToLose)/caloriesPerPint)
	var pintMonths=calculatedPintMonthsStr
	var dollarsSavedPerYear=intFormat.format((caloriesPerPound*calculatedPoundsToLose)*costPerCalorie)

	var currDollarsPerMonth=intFormat.format(pounds*0.9875)
	var targetDollarsPerMonth=intFormat.format(calculatedGoalWeight*0.9875)
	var savingsPerMonth=intFormat.format((caloriesPerPound*calculatedPoundsToLose)*costPerCalorie/12)
	var savingsPerYear=intFormat.format(dollarsSavedPerYear)


	
	if (targetBmi<=calculatedCurrBmi) {
		document.getElementById("mainText").style.display="block"
		document.getElementById("mainTextLowBmi").style.display="none"

		document.getElementById("heightDiv").innerHTML=""+height+" "
		document.getElementById("currWeightDiv").innerHTML=""+currWeight+" "
		document.getElementById("currBmiDiv").innerHTML=""+currBmi
		document.getElementById("goalBmiDiv").innerHTML=""+goalBmi+" "
		document.getElementById("goalWeightDiv").innerHTML=""+goalWeight+" "
		document.getElementById("poundsToLoseDiv").innerHTML=""+poundsToLose+" "
		document.getElementById("currStoredCaloriesDiv").innerHTML=""+currStoredCalories+" "
		document.getElementById("numPintsDiv").innerHTML=""+numPints+" "
		document.getElementById("pintMonthsDiv").innerHTML=""+pintMonths+" "
		document.getElementById("poundsToLose2Div").innerHTML=""+poundsToLose+" "
		document.getElementById("dollarsSavedDiv").innerHTML="$"+intFormat.format(dollarsSavedPerYear*0.897)+""
		document.getElementById("currDollarsPerMonthDiv").innerHTML="$"+currDollarsPerMonth+" "
		document.getElementById("targetDollarsPerMonthDiv").innerHTML="$"+targetDollarsPerMonth+" "
		document.getElementById("savingsPerMonthDiv").innerHTML="$"+savingsPerMonth+" "
		document.getElementById("savingsPerYearDiv").innerHTML="$"+savingsPerYear+" "
	}	
	else {
		document.getElementById("mainText").style.display="none"
		document.getElementById("mainTextLowBmi").style.display="block"
		
		document.getElementById("heightLowBmiDiv").innerHTML=""+height+" "
		document.getElementById("currWeightLowBmiDiv").innerHTML=""+currWeight+" "
		document.getElementById("currBmiLowBmiDiv").innerHTML=""+currBmi
		document.getElementById("goalBmiLowBmiDiv").innerHTML=""+goalBmi+" "
		document.getElementById("goalWeightLowBmiDiv").innerHTML=""+goalWeight+" "

	}
	
	
	
	

	
}

</script>

<style type="text/css">
		body {background-repeat:repeat-x; background-image:url(<%=PageUtils.getPathToAppRoot(request)%>images/bg_popup.gif); }

</style>
</head>

<body bgcolor="#ffffff" topmargin="0" leftmargin="0">
<div id="mainDiv" class="bodyFont" style="position:absolute; width:530px; top:50px; left:15px; ">
<span class="firstSentenceFont">How much "should" you weigh?</span><br />
That depends on how tall you are, how muscular, what type of bone structure you've got, and what makes you look and feel your best.  One way of calculating your ideal weight is based on your current Body Mass Index (BMI), a number calculated from your current weight and height.  Please specify your height, weight, and target BMI below to get an idea of where you stand.<br /><br />

<form action="#" onsubmit="return false">


<table border="0" cellspacing="0" cellpadding="0" width="535">
<tr valign="top" >
<td nowrap="nowrap" width="119"><span class="boldishFont">Your Height</span><br /></td>
<td nowrap="nowrap" width="10"><br /></td>
<td nowrap="nowrap" width="72"><span class="boldishFont">Your Weight</span><br /></td>
<td nowrap="nowrap" width="10"><br /></td>
<td nowrap="nowrap" width="324"><span class="boldishFont">Your Target BMI</span><br /></td>
</tr>
<tr valign="top" >
<td><select name="feetInInches" id="feetInInches"  class="selectText" style="width:50px;  margin-bottom:10px; " onchange="recalculate()">
<%
for (int i=4; i<=7; i++) {
	%>
	<option <%=(i==5?" selected ":"")%> value="<%=(i*12)%>"><%=i%> ft., </option>
	<%
}
%>
</select><select name="inches" id="inches"  class="selectText" style="width:62px;  margin-left:3px; margin-bottom:10px; " onchange="recalculate()">
<%
for (double i=0.0; i<=11.5; i+=0.5) {
	%>
	<option <%=(i==7?" selected ":"")%> value="<%=i%>"><%=fmt.format(i)%> in.</option>
	<%
}
%>
</select><br /></td>
<td><br /></td>
<td><select name="pounds" id="pounds"  class="selectText" style="width:64px; margin-bottom:10px; " onchange="recalculate()">
<%
for (int i=80; i<=300; i++) {
	%>
	<option <%=(i==145?" selected ":"")%> value="<%=i%>"><%=i%> lbs.</option>
	<%
}
%>
</select><br /></td>
<td><br /></td>
<td><select style="margin-bottom:0px;width:82px; " name="targetBmi" id="targetBmi"  class="selectText" onchange="recalculate()">
<%
for (double i=17.0; i<=27.0; i+=0.5) {
	%>
	<option <%=(Math.round(i*10)==220?" selected ":"")%> value="<%=i%>"><%=fmt.format(i)%></option>
	<%
}
%>
</select><br/>
<div style="width:325px;font-size:11px; color:#666666;"><i>BMI 22 indicates average bone structure and muscularity; adjust up or down if you're more or less muscular or "big-boned" than average.</i></div><br /></td>
</tr>
</table>






<div id="mainText" style="display:none; padding:4px; background-color:#eeeeee;color:#000000; width:520px;">
You weigh <b style="" id="currWeightDiv" ></b> and are <b style="" id="heightDiv" ></b> tall.  That means that your current BMI is <b id="currBmiDiv" style=""></b>.  Your BMI goal of <b style="" id="goalBmiDiv" ></b> indicates a target weight of <b id="goalWeightDiv" style=""></b> pounds.  Your target BMI is partly dependant on your bone structure and on how muscular you are, but for people of average bone structure and muscularity, the following applies (adjust up or down depending on your body type): if your BMI is below 18, you are probably underweight; a BMI of between 18 and 25 is generally healthy; people with BMIs over 25 and up to 30 are usually considered to be overweight and to have increased health risks; a BMI over 30 indicates obesity -- health risk increases while life-expectancy shrinks.<br /><br />

To reach your goal weight, you'll need to lose <b id="poundsToLoseDiv" style=""></b> pounds of body fat. Since a pound of fat contains about <%=caloriesPerPound%> calories, you've got about  <b id="currStoredCaloriesDiv" style=""></b> calories stored away in your body in the form of fat. Now, if you were to eat 100 calories fewer per day below your target caloric intake, you'd burn body fat and gradually lose weight.   Since food (on average) costs a little over a third of a cent per calorie, you'd be spending, daily, 35 cents or so less per while losing that excess body fat.  After losing all <b id="poundsToLose2Div" style=""></b> pounds of excess body fat, you'll have saved <b id="dollarsSavedDiv" style=""></b>! (To put it another way: this extra fat you've got amounts to carrying around <b id="numPintsDiv" style=""></b> pints of ice cream -- each about <%=caloriesPerPint%> calories, depending on the brand -- on your body.   You could survive on this ice cream for <b id="pintMonthsDiv" style=""></b> without consuming anything but water and a vitamin supplement.)<br /><br />

Assuming you're not rapidly losing or gaining weight currently, you're spending about <b id="currDollarsPerMonthDiv" style=""></b> on food every month (if you eat out a lot, or live in or near, say, New York City, you're spending more): the more you weigh, the more it takes to stay at your weight.  After reaching your goal weight, you'll spend only <b id="targetDollarsPerMonthDiv" style=""></b> per month: a savings of <b id="savingsPerMonthDiv" style=""></b> or more.  Over a year, every year, you'll save <b id="savingsPerYearDiv" style=""></b> on food assuming you maintain your target weight.  Looking and feeling better while having more cash in your pocket: not a bad deal!<br />  

</div>


<div id="mainTextLowBmi" style="display:none; padding:4px; background-color:#eeeeee;color:#000000; width:520px;">
You weigh <b style="" id="currWeightLowBmiDiv" ></b> and are <b style="" id="heightLowBmiDiv" ></b> tall.  That means that your current BMI is <b id="currBmiLowBmiDiv" style=""></b>.  Your BMI goal of <b style="" id="goalBmiLowBmiDiv" ></b> indicates a target weight of <b id="goalWeightLowBmiDiv" style=""></b> pounds.  Your target BMI is partly dependant on your bone structure and on how muscular you are, but for people of average bone structure and muscularity, the following applies (adjust up or down depending on your body type): if your BMI is below 18, you are probably underweight; a BMI of between 18 and 25 is generally healthy; people with BMIs over 25 and up to 30 are usually considered to be overweight and to have increased health risks; a BMI over 30 indicates obesity -- health risk increases while life-expectancy shrinks.<br />
</div>






</form>

<br />




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