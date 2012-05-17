<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>



<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
DateFormat dateFormat=new SimpleDateFormat("EEEE MMMM d, yyyy");
%>

<%


User user=controller.getSessionInfo().getUser();
int dateYear=controller.getParamAsInt("y", -1);
int dateMonth=controller.getParamAsInt("m", -1);
int dateDate=controller.getParamAsInt("d", -1);




Calendar date;
if (dateYear==-1) {
	date=new GregorianCalendar();
	dateYear=date.get(Calendar.YEAR);
	dateMonth=date.get(Calendar.MONTH);
	dateDate=date.get(Calendar.DATE);
}
else {
	date=new GregorianCalendar(dateYear, dateMonth, dateDate);
}

CalorieWeek calorieWeek=CalorieWeek.getByUserIdAndDate(user.getId(), CalorieWeek.getWeekStartDate(date.getTime()), true);
List calorieHours;
if (calorieWeek!=null) {
	calorieHours=CalorieHour.getByWeekIdAndDate(calorieWeek.getId(), date.getTime(), true);
}
else {
	calorieHours=new ArrayList();
}
calorieHours=(calorieHours==null?Collections.emptyList():calorieHours);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

var dateYear=<%=dateYear%>;
var dateMonth=<%=dateMonth%>;
var dateDate=<%=dateDate%>;
var weekId=<%=calorieWeek.getId()%>;

var nextNegativeId=-1; // negative ids are for not-yet-inserted rows (but have to be unique so we can distinguish among them on the client side)


var deletingImg=new Image();
deletingImg.src="../images/smallerButtons/deleting.gif";

var calorieHours=[<%
    boolean first=true;            
	for (Object calorieHour: calorieHours) {
		if (!first) {
			%>, <%
		}
		else {
			first=false;
		}
		%>
		<%=((CalorieHour)calorieHour).toJSON().toString()%>
		<%
	}
	%>];


function calculateAndPolulateTotalCalories() {
	var totalCals=0;
	for (var i=0; i<calorieHours.length; i++) {
		totalCals+=parseFloat(""+calorieHours[i].totalIngestedCalories);

	}
	$("totalCaloriesValue").innerHTML=parseInt(""+Math.floor(totalCals));
}

function populateTable() {
	if (calorieHours.length>0) {
		$("tableHeaderRow").style.display="block";
		$("totalCaloriesLine").style.display="block";
	}
	else {
		$("tableHeaderRow").style.display="none";
		$("totalCaloriesLine").style.display="none";
	}
	var tablesHtml="";
	for (var i=0; i<calorieHours.length; i++) {
		var tableHtml=getTableHtml(
				calorieHours[i].ingestedLabel, 
				calorieHours[i].servingName, 
				calorieHours[i].numServings, 
				calorieHours[i].totalIngestedCalories, 
				calorieHours[i].id
			);
			tablesHtml+=tableHtml;
	}
	$("dataTables").innerHTML=tablesHtml;
	calculateAndPolulateTotalCalories();
}

function addRowAtEnd(calorieHour) {
	var currHtml=$("dataTables").innerHTML;
	currHtml+=getTableHtml(
			calorieHour.ingestedLabel, 
			calorieHour.servingName, 
			calorieHour.numServings, 
			calorieHour.totalIngestedCalories, 
			calorieHour.id
		);
	$("dataTables").innerHTML=currHtml;
	$("tableHeaderRow").style.display="block";
	$("totalCaloriesLine").style.display="block";
	calculateAndPolulateTotalCalories();
}

function getTableHtml(foodName, servingName, numServings, calories, hourId) {
	//alert("in getTableHtml(), numServings="+numServings+"; calories="+calories)
	return $("hiddenTableRowForCopying").innerHTML
		.replace(/\_\_DESCRIPTION\_\_/g, foodName)
		.replace(/\_\_SERVINGNAME\_\_/g, servingName)
		.replace(/\_\_SERVINGS\_\_/g, trimTrailingZeros(numServings))
		.replace(/\_\_CALORIES\_\_/g, parseInt(""+Math.floor(calories)))
		.replace(/\_\_CALORIEHOURID\_\_/g, hourId)
	;
}

function trimTrailingZeros(n) {
	if (n==parseInt(""+n)) {
		return parseInt(""+n);
	}
	return n;
}

function deleteRow(id) {
	$("deleteButton"+id).src=deletingImg.src
	setTimeout("doDeleteRow("+id+")", 250)

}

function doDeleteRow(id) {
	var url=this.location.href;
	url=url.substring(0, url.lastIndexOf("/")+1)+"deleteCalorieHour.jsp";
	var qString="siteId=<%=controller.getSiteId()%>&id="+id+"&t="+new Date().getTime();
	
	//alert("about to do ajax req for "+url+"?"+qString);
	currentAjaxRequest=new Ajax.Request(
		url, 
		{
			method: "post", 
			parameters: qString, 
			onComplete: deleteRowCALLBACK
	});

	//alert("ajax req made")
	var newCalorieHours=[];
	for (var i=0; i<calorieHours.length; i++) {
		//alert(calorieHours[i].id+" "+id)
		if (calorieHours[i].id!=id) {
			newCalorieHours[newCalorieHours.length]=calorieHours[i]
			                                         			
		}
	}
	calorieHours=newCalorieHours;
	populateTable();           	
}


function deleteRowCALLBACK(xmlHttpRequest, xJsonResponseHeader) {
	//alert(""+xmlHttpRequest.responseText+" "+xJsonResponseHeader)
}

// for debugging:
function breakIntoLines(s, maxLineLength) {
	var ret="";
	for (var i=0; i!=-1; i+=maxLineLength) {
		ret+=s.substring(i, Math.min(maxLineLength, s.length))+"\r\n";
		if (i>maxLineLength) {
			break;
		}
	} 
	return ret;
}

function saveFood(numServings, escapedRawData) {
	//alert("in saveFood(), numServings="+numServings+"\r\nescapedRawData="+breakIntoLines(escapedRawData, 100)+"\r\nchosenFood="+chosenFood)
	var url="saveCalorieHour.jsp";
	var params="dateYear="+window.dateYear+"&dateMonth="+window.dateMonth+"&dateDate="+window.dateDate+"&weekId="+window.weekId+"&numServings="+numServings+"&escapedRawData="+escapedRawData;

	//prompt("", url+"?"+params);
	
	new Ajax.Request(
			url, 
			{
				method: "get", 
				parameters: params,
				onComplete: saveFoodCALLBACK
		});
}

function saveFoodCALLBACK(xmlHttpRequest, xJsonResponseHeader) {
	response=eval('('+xmlHttpRequest.responseText+')');
	var numServings=response.numServings;
	var rawData=response.rawData;
	var calorieHour=new Object();
	calorieHour.totalIngestedCalories=parseFloat(rawData.calories)*parseFloat(numServings);
	calorieHour.totalIngestedCalcium=parseFloat(rawData.calcium)*parseFloat(numServings);
	calorieHour.totalIngestedCarb=parseFloat(rawData.carb)*parseFloat(numServings);
	calorieHour.totalIngestedCholesterol=parseFloat(rawData.cholesterol)*parseFloat(numServings);
	calorieHour.totalIngestedFat=parseFloat(rawData.fat)*parseFloat(numServings);
	calorieHour.totalIngestedFiber=parseFloat(rawData.fiber)*parseFloat(numServings);
	calorieHour.totalIngestedProtein=parseFloat(rawData.protein)*parseFloat(numServings);
	calorieHour.totalIngestedSatfat=parseFloat(rawData.satfat)*parseFloat(numServings);
	calorieHour.totalIngestedSodium=parseFloat(rawData.sodium)*parseFloat(numServings);
	calorieHour.totalIngestedSugar=parseFloat(rawData.sugar)*parseFloat(numServings);
	if (rawData.chosenFood==null || rawData.chosenFood=="null") {
		alert("in saveFoodCALLBACK(), rawData.chosenFood is null; about to throw error");
		throw new Error("in saveFoodCALLBACK(), rawData.chosenFood is null");
	}
	calorieHour.ingestedLabel=rawData.chosenFood;
	calorieHour.id=rawData.id;
	
	// now we need to add the stuff that didn't come in the raw data:
	calorieHour.dateYear=window.dateYear;
	calorieHour.dateMonth=window.dateMonth;
	calorieHour.dateDate=window.dateDate;
	calorieHour.expendedLabel="";
	calorieHour.expendedCalories=0;
	calorieHour.weekId=window.weekId;
	calorieHour.hour=0;
	calorieHour.numServings=numServings;
	//alert(calorieHour.numServings)
	calorieHour.servingName=rawData.name;
	//alert(calorieHour.servingName)
	calorieHours[calorieHours.length]=calorieHour;
	addRowAtEnd(calorieHour);
}


function getNewDate(selectObj) {
	var optionValue=selectObj.options[selectObj.selectedIndex].value;
	var optionValueSplit=optionValue.split("_");
	var url="caloriesIngested.jsp?siteId=<%=controller.getSiteId()%>&y="+optionValueSplit[0]+"&m="+optionValueSplit[1]+"&d="+optionValueSplit[2]+"&t="+new Date().getTime()+"#menuTop";
	window.location.href=url
}

</script>

<%@ include file="/global/calCounterJs.jsp" %>

<style type="text/css">
.listFont {font-size:11px; font-family:arial,helvetica;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="searchMain" 
	style="display:none; position:absolute; top:400px; left:250px; z-index:20">
	<iframe id="searchMainIframe" name="searchMainIframe" 
		scrolling="no" style="width:600px; height:400px; border:2px solid #333333;" 
		frameborder="0" framespacing="0" 
		src="calCounter/search.jsp?siteId=1">
	</iframe>
	<br/>
	<a href="#" onclick="return false;" id="hiddenFocusReceiver"></a>
	<br/><br/>
</div>
<div id="searchShadow" 
	style="visibility:hidden; display:none; position:absolute; top:401px; left:251px; z-index:18">
	<iframe style="width:600px; height:400px; border:2px solid #000000;" 
		frameborder="0" framespacing="0" 
		src="about:blank">
	</iframe>
</div>

<div id="mainDiv">


<font class="bodyFont"> 
<span class="standardTextBlockWidth" style="width:600px;">
<span class="firstSentenceFont">What'd you eat?</span><br>
Kqool tracks the calories
you consume and the calories you burn, but to do that, you have to let
us know what you've eaten! Click "add foods" to get started.  (Or, choose another
date from the menu.)<a name="menuTop"></a><br><br>
<form action="#" onsubmit="return false;" style="padding:0px; margin:0px; display:inline;">
<select class="selectText" style="margin-bottom:12px;" name="date" id="dateMenu" onchange="getNewDate(this)">
<%
Calendar cal=new GregorianCalendar();
int numDates=30;
String label;
boolean selected;
for (int i=0; i<numDates; i++) {
	if (i==0) {
		label="Today";
	}
	else if (i==1) {
		label="Yesterday";
	}
	else {
		label=dateFormat.format(cal.getTime());
	}
	selected=(dateYear==cal.get(Calendar.YEAR) && dateMonth==cal.get(Calendar.MONTH) && dateDate==cal.get(Calendar.DATE));
	%><option <%=selected?"selected=\"selected\"":""%> value="<%=cal.get(Calendar.YEAR)%>_<%=cal.get(Calendar.MONTH)%>_<%=cal.get(Calendar.DATE)%>"><%=label%></option>
	<%
	cal.add(Calendar.DATE, -1);
}
%>
</select>
</form><br/>	


	<table border="0" cellpadding="0" cellspacing="0" id="tableHeaderRow" style="display:none;">
	<tbody><tr><td colspan="8" class="ruleRow"><img src="../images/spacer.gif" width="1" height="1"><br></td></tr>
	<tr class="headerRow" height="20">
	<td class="ruleRow" nowrap="nowrap"><img src="../images/spacer.gif" width="1" height="1"><br></td>
	<td valign="middle" align="left"><div style="width:3px; overflow:hidden;"><font class="boldishColumnHeaderFont">&nbsp;</font></div></td>
	<td valign="middle" align="left"><div style="width:300px; overflow:hidden;"><font class="boldishColumnHeaderFont">Description</font></div></td>
	<td valign="middle" align="left"><div style="width:110px; overflow:hidden;"><font class="boldishColumnHeaderFont">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Serving Size</font></div></td>
	<td valign="middle" align="left"><div style="width:60px; overflow:hidden;"><font class="boldishColumnHeaderFont">&nbsp;&nbsp;&nbsp;Servings</font></div></td>
	<td valign="middle" align="right"><div style="width:70px; overflow:hidden;"><font class="boldishColumnHeaderFont">Calories&nbsp;&nbsp;&nbsp;</font></div></td>
	<td valign="middle" align="center"><div style="width:50px; overflow:hidden;"><font class="boldishColumnHeaderFont">&nbsp;</font></div></td>
	<td class="ruleRow" width="1" nowrap="nowrap"><img src="../images/spacer.gif" width="1" height="1"><br></td>
	</tr>
	<tr><td colspan="8" class="ruleRow"><img src="../images/spacer.gif" width="1" height="1"><br></td></tr>
	</tbody></table>

	<div id="dataTables">
	

	</div>

<div id="hiddenTableRowForCopying" style="display:none;">
	<table border="0" cellpadding="0" cellspacing="0">
	<tbody>
	<tr class="evenDataRow" valign="middle" height="24">
	<td class="ruleRow" nowrap="nowrap"><img src="../images/spacer.gif" width="1" height="1"><br></td>
	<td align="left"><div style="width:3px; overflow:hidden;"><font class="columnDataFont">&nbsp;</font></div></td>
	<td align="left" nowrap="nowrap"><div style="width:300px; overflow:hidden;"><font class="columnDataFont">__DESCRIPTION__</font></div></td>
	<td align="left" nowrap="nowrap"><div style="width:110px; overflow:hidden;"><font class="columnDataFont">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__SERVINGNAME__</font></div></td>
	<td align="left" nowrap="nowrap"><div style="width:60px; overflow:hidden;"><font class="columnDataFont">&nbsp;&nbsp;&nbsp;__SERVINGS__</font></div></td>
	<td align="right" nowrap="nowrap"><div style="width:70px; overflow:hidden;"><font class="columnDataFont">__CALORIES__&nbsp;&nbsp;&nbsp;</font></div></td>
	<td align="left"><div style="width:50px; overflow:hidden;"><font class="columnDataFont"><a href="#" onclick="deleteRow(__CALORIEHOURID__); return false;"><img id="deleteButton__CALORIEHOURID__" src="../images/smallerButtons/delete.gif" width="49" border="0" height="19" /></a></font></div></td>
	<td class="ruleRow" width="1" nowrap="nowrap"><img src="../images/spacer.gif" width="1" height="1"><br></td>
	</tr>
	<tr><td colspan="8" class="ruleRow"><img src="../images/spacer.gif" width="1" height="1"><br></td></tr>
	</tbody></table>
</div>

<div style="xborder:1px solid #000000; text-align:right; margin: 8px 0px 0px 265px; width: 270px; display:none;" id="totalCaloriesLine">
<i>Total calories ingested:</i>&nbsp;&nbsp;<span style="font-weight:bold;" id="totalCaloriesValue">0</span>
</div>

<%=HtmlUtils.formButton(false, "addFood", "addFood(); ", request)%><br/><br/>
<i>Please note: individual calorie values are rounded down to the nearest whole number, 
so they may not sum exactly to "total calories ingested" (which is also rounded down).</i>

<br>
<br>
<br>
<br>




</div>

<script type="text/javascript">
populateTable();
</script>

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

