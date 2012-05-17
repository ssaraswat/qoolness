<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>


<%@ include file="/global/workoutExerciseDetailsInclude.jsp" %>


<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_EXERCISES=25;

%>

<%



// possible modes: add, edit, copy:
String mode=controller.getParam("mode","add");




List intensityMeasuresList=ExerciseIntensityMeasure.getAll();
List quantityMeasuresList=ExerciseQuantityMeasure.getAll();
HashMap intensityCodesToNamesMap=new HashMap(intensityMeasuresList.size());
HashMap quantityCodesToNamesMap=new HashMap(quantityMeasuresList.size());
for (int i=0; i<intensityMeasuresList.size(); i++) {
	ExerciseIntensityMeasure m=(ExerciseIntensityMeasure)intensityMeasuresList.get(i);
	intensityCodesToNamesMap.put(m.getCode(),m.getName());
}
for (int i=0; i<quantityMeasuresList.size(); i++) {
	ExerciseQuantityMeasure m=(ExerciseQuantityMeasure)quantityMeasuresList.get(i);
	quantityCodesToNamesMap.put(m.getCode(),m.getName());
}


User user=controller.getSessionInfo().getUser();

String name=controller.getParam("name");
String comment=controller.getParam("comment");
int numExerciseSlots=controller.getParamAsInt("numExerciseSlots");
boolean prescriptive=controller.getParamAsBoolean("prescriptive", true);
int status=controller.getParamAsInt("status", Workout.STATUS_ACTIVE);
int userId=controller.getParamAsInt("userId");
int id=controller.getParamAsInt("id");

int copyingFromWorkoutId=controller.getParamAsInt("copyingFromWorkoutId",0);

// only for descriptive:
int year=controller.getParamAsInt("year",-1);
int month=controller.getParamAsInt("month",-1);
int date=controller.getParamAsInt("date",-1);

// for descriptive only:
String dateStr="";
if (!prescriptive) {
	Calendar cal=new GregorianCalendar(year, month, date);
	Calendar now=new GregorianCalendar();
	boolean today=(cal.get(Calendar.YEAR)==now.get(Calendar.YEAR) && cal.get(Calendar.MONTH)==now.get(Calendar.MONTH) && cal.get(Calendar.DATE)==now.get(Calendar.DATE));
	if (!today) {
		dateStr="your "+DateFormat.getDateInstance(DateFormat.LONG).format(cal.getTime());
	}
	else {
		dateStr="today's";
	}

}

Workout workout;
if (id>0) {
	workout=Workout.getById(id);
	ExerciseDetail.loadExerciseDetailsInto(workout);
}
else {
	workout=new Workout();
	if (copyingFromWorkoutId==0) {
		ArrayList blankList=new ArrayList(numExerciseSlots);
		for (int i=0; i<numExerciseSlots; i++) {
			ExerciseDetail ed=new ExerciseDetail();
			ed.setExerciseId(controller.getParamAsInt("exercise"+i));
			blankList.add(ed);
		}
		workout.setExerciseDetails(blankList);
	}
	else {
		Workout copiedWorkout=Workout.getById(copyingFromWorkoutId);
		ExerciseDetail.loadExerciseDetailsInto(copiedWorkout);
		workout.setExerciseDetails(copiedWorkout.getExerciseDetails());
	}
}

HashMap exerciseIdsToExerciseDetailsMap=new HashMap(workout.getExerciseDetails().size());
for (int i=0; i<workout.getExerciseDetails().size(); i++) {
	ExerciseDetail ed=(ExerciseDetail)workout.getExerciseDetails().get(i);
	exerciseIdsToExerciseDetailsMap.put(new Integer(ed.getExerciseId()), ed);
}

List chosenExercises=new ArrayList(numExerciseSlots);
int[] exerciseIds=new int[numExerciseSlots];

for (int i=0; i<numExerciseSlots; i++) {
	exerciseIds[i]=controller.getParamAsInt("exercise"+i);
	if (exerciseIds[i]>0) {
		chosenExercises.add(Exercise.getById(exerciseIds[i]));
	}
	else {
		break;
	}
}




%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

var numExercises=<%=chosenExercises.size()%>
var okNumericChars="1234567890.";

function getValue(el) {
	if (el.selectedIndex) {
		return el.options[el.selectedIndex].value
	}
	return el.value
}

function isValidNumericEntry(s) {

	for (var i=0; i<s.length; i++) {
		if (okNumericChars.indexOf(s.charAt(i))==-1) {
			return false
		}
	}
	if (parseFloat(s)<0) {
		return false
	}
	return true
}

var fieldPrefixes=["quantity","reps","intensity","comments"]

function isValidForm(formObj)
{
	var els=formObj.elements
	for (var i=0; i<numExercises; i++) {
		for (var p=0; p<fieldPrefixes.length; p++) {
			var fieldValue=getValue(els[fieldPrefixes[p]+i])
			if (fieldPrefixes[p]!="comments") {
				if (trim(fieldValue).length==0) {
					errorAlert("On row "+(i+1)+", there is a missing value.  Please fix and try again.",els[fieldPrefixes[p]+i])
					return false
				}
				if (!isValidNumericEntry(trim(fieldValue))) {
					errorAlert("On row "+(i+1)+", '"+fieldValue+"' is not a number.  Please fix and try again.",els[fieldPrefixes[p]+i])
					return false
				}
			}
			else {
				if (trim(fieldValue).length>255) {
					errorAlert("On row "+(i+1)+", the comment is "+trim(fieldValue).length+" characters long; the maximum is 255.  Please fix and try again.",els[fieldPrefixes[p]+i])
					return false
				}			
			}
		}
	}
	var okToSubmit=findSupersetRestIntervalConflicts(els, false)
	if (okToSubmit) {
		hidePageAndShowPleaseWait()
		return true
	}
	return false;
}


function findSupersetRestIntervalConflicts(els, doFix) {
	//alert("in find, numExercises="+numExercises)
	var conflictFound=false
	var isLastExercise
	for (var i=0; i<numExercises; i++) {
		//alert("i="+i)
		isLastExercise=(i==numExercises-1)
		var currentIsSuperset=(els["ssg"+i].selectedIndex>0)
		var nextIsSameSuperset=(i<(numExercises-1) && els["ssg"+(i+1)].selectedIndex>0 && (els["ssg"+i].selectedIndex==els["ssg"+(i+1)].selectedIndex))
		var currentIsZeroRestInterval=(els["ri"+i].selectedIndex==0)
		if (currentIsSuperset && (nextIsSameSuperset || isLastExercise) && !currentIsZeroRestInterval) {
			if (doFix) {
				//alert("setting el "+els["ri"+i]+"'s selected index to 0")
				els["ri"+i].selectedIndex=0
			}
			else {
				conflictFound=true
				break
			}
		}
	}
	if (!doFix && conflictFound) {
		if (confirm("One or more conflicts found between your rest-interval and superset settings (exercises in a superset must have a rest interval of zero, except for the last exercise in the superset).  Okay to set rest intervals to zero as needed and then submit?")) {
			findSupersetRestIntervalConflicts(els, true)
			return true;
		}
		else {
			return false;
		}
	}
	return true;
}



var SUPERSET_COLORS=[]
<%                 
for (int j=0; j<SUPERSET_COLORS.length; j++) {
	%>
	SUPERSET_COLORS[<%=j%>]="<%=SUPERSET_COLORS[j]%>";
	<%
}
%>
               	
function supersetChange(selectObj) {
	var newColor=SUPERSET_COLORS[selectObj.selectedIndex]
	selectObj.style.backgroundColor=newColor
	if (selectObj.selectedIndex==0) {
		selectObj.style.color="#000000"
	}   		
	else {
		selectObj.style.color="#ffffff"
	}   		
}



</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">


<font class="bodyFont"> 
<span class="standardTextBlockWidth">


<%
if (mode.equals("add")) {
	%>
	<span class="firstSentenceFont"><%=prescriptive?"How hard do you want to work?":"How hard did you work?"%></span><br />
	<%
	if (prescriptive) {
		%>Please select a quantity and intensity for each exercise listed in the "<%=name%>" 
		routine. Then press the "add" button. You must enter a number
		for all text fields.<%
	}

	else { // descriptive
		%>Please select the quantity and intensity of each exercise you completed 
		during 
		 <%=dateStr%> workout. Then press the "add" button. You must enter 
		a positive number in each text field.<%
	}
	%></span><%=HtmlUtils.doubleLB(request)%><br />
	<%
}
else if (mode.equals("copy")) {
	%>
	<span class="firstSentenceFont"><%=prescriptive?"How hard do you want to work?":"How hard did you work?"%></span><br />
	<%
	if (prescriptive) {
		%>Please select a quantity and intensity for each exercise listed in the
		 "<%=name%>" 
		routine. Then press the "add" button. You must enter a number 
		for all text fields.<%
	}
	else { // descriptive
		%>Please select the quantity and intensity of each exercise you completed during 
		 <%=dateStr%> workout. Then press the "add" button. You must enter 
		a positive number in each text field.<%
	}
	%>
</span><%=HtmlUtils.doubleLB(request)%><br />
	<%
}
else if (mode.equals("edit")) {
	%>
	<span class="firstSentenceFont"><%=prescriptive?"How hard do you want to work?":"How hard did you work?"%></span><br />
	Please edit specifics for <%=prescriptive?"the \""+name+"\"":dateStr%> <%=prescriptive?"routine":"workout"%>, 
	then press the "save" button.  
	
	<%
	if (prescriptive) {
		%>You must enter a number for 
		all text fields.<%
	}
	else {
		%>You must enter a positive number in each text field.<%
	}
	%></span><%=HtmlUtils.doubleLB(request)%><br />
	<%
}


boolean even=true;
NumberFormat fmt=NumberFormat.getInstance();
fmt.setGroupingUsed(false);
%>





<table border="0" cellspacing="0" cellpadding="0" width="730"> 

<form action="processWorkout.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="numExercises" value="<%=chosenExercises.size()%>" />
<input type="hidden" name="name" value="<%=name%>" />
<input type="hidden" name="id" value="<%=id%>" />
<input type="hidden" name="mode" value="<%=mode%>" />
<input type="hidden" name="prescriptive" value="<%=prescriptive%>" />
<input type="hidden" name="year" value="<%=year%>" />
<input type="hidden" name="month" value="<%=month%>" />
<input type="hidden" name="date" value="<%=date%>" />
<input type="hidden" name="copyingFromWorkoutId" value="<%=copyingFromWorkoutId%>" />
<input type="hidden" name="weight" value="<%=controller.getParamAsDouble("weight", 0.0)%>" />



<tr height="1"><td colspan="8" class="ruleRow"><img src="../images/spacer.gif" height="1" width="1"><br /></td></tr>
<tr class="headerRow" height="30">
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
<td valign="middle" align="center" nowrap="nowrap" width="20"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Exercise&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center" width="265" nowrap="nowrap"><font class="boldishColumnHeaderFont">&nbsp;Quantity/Intensity&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Rest&nbsp;Interval&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Superset?&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Comments&nbsp;&nbsp;&nbsp;<br /></font></td>
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
</tr>
<%=HtmlUtils.getHorizRuleTr(8, request)%>

<%

for (int i=0; i<chosenExercises.size(); i++) {
	Exercise exercise=(Exercise)chosenExercises.get(i);
	ExerciseDetail ed=(ExerciseDetail)exerciseIdsToExerciseDetailsMap.get(new Integer(exercise.getId()));
	
	int restInterval=15;
	int supersetGroup=0;
	if (ed!=null) {
		restInterval=ed.getRestInterval();
		supersetGroup=ed.getSupersetGroup();		
	}
	

 
	String intensity="";
	double intensityDouble=0;
	try {
		intensityDouble=ed.getIntensity();
		intensity=fmt.format(intensityDouble);
	}
	catch (RuntimeException e) {}
	intensity=(intensity.equals("0")?"":intensity);
	
	
	String quantity="";
	double quantityDouble=0;
	try {
		quantityDouble=ed.getQuantity();
		quantity=fmt.format(quantityDouble);
	}
	catch (RuntimeException e) {}
	quantity=(quantity.equals("0")?"":quantity);


	
	String reps="";
	int repsInt=0;
	try {
		repsInt=ed.getReps();
		reps=fmt.format(repsInt);
	}
	catch (RuntimeException e) {}
	reps=(reps.equals("0")?"":reps);
	
	String comments=(ed==null?"":ed.getComments());
	comments=(comments!=null?comments:"");



	%>
	<input type="hidden" name="id<%=i%>" value="<%=exercise.getId()%>" />
	<tr class="<%=even?"even":"odd"%>DataRow" height="30">
	<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
	<td align="left"><font class="columnDataFont">&nbsp;<%=(i+1)%>.<br /></font></td>
	<td align="left"><font class="columnDataFont"><%=exercise.getName()%><br /></font></td>
	<td align="left"><font class="columnDataFont"><%
	String quantityUnits=exercise.getQuantityMeasure();
	if (quantityUnits.equals("NA")) {
		%><input type="hidden" value="0" name="quantity<%=i%>" value="0" /><input type="hidden"  value="0" name="reps<%=i%>" /><%
	}
	else if (quantityUnits.equals("SET")) {
		%><input class="inputText" style="width:26px;" type="text"  value="<%=quantity%>"  name="quantity<%=i%>" /> sets of <input class="inputText" style="width:26px;" type="text"   value="<%=reps%>"  name="reps<%=i%>" /> reps<%
	}	
	else {
		%><input class="inputText" style="width:26px;" type="text" value="<%=quantity%>"  name="quantity<%=i%>" /> <%=((String)quantityCodesToNamesMap.get(quantityUnits)).toLowerCase()%><input type="hidden"   value="0"  name="reps<%=i%>" /><%
	}	
	%>
	
	<%
	String intensityUnits=exercise.getIntensityMeasure();
	if (intensityUnits.equals("NA")) {
		%><input type="hidden" value="0" name="intensity<%=i%>" value="0" /><%
	}
	else if (intensityUnits.equals("LEVEL")) {
		%>at level <select class="selectText"  
		name="intensity<%=i%>" id="intensity<%=i%>">
		<option value=""></option>
		<%
		for (int j=1; j<=exercise.getMaxLevel(); j++) {
			%>
			<option value="<%=j%>"><%=j%></option>
			<%
		}
		%>
		</select><%
	}
	else if (intensityUnits.equals("SPEED")) {
		%>at <select class="selectText"  name="intensity<%=i%>">
		<option value=""></option>
		<%
		for (int s=1; s<=5; s++) {
		// note: values are 10, 20, 30, etc -- leaves us room to add more speeds if needed, and still have them be comparable to eachother
			%><option value="<%=(s*10)%>" <%=intensityDouble==s*10?" selected ":""%>><%=SPEED_LABELS[s]%></option><%
		}
		%></select> speed<%
	}
	else {
		%>at <input class="inputText" style="width:26px;" type="text"  value="<%=intensity%>" name="intensity<%=i%>" /> <%=((String)intensityCodesToNamesMap.get(intensityUnits)).toLowerCase()%><%
	}

	%>&nbsp;<br /></font></td>
	<td align="left"><font class="columnDataFont"><select class="selectText"  name="ri<%=i%>" style="margin-right:5px;">
	<%
	for (int j=0; j<REST_INTERVAL_VALUES.length; j++) {
		%>
		<option value="<%=REST_INTERVAL_VALUES[j]%>" <%=REST_INTERVAL_VALUES[j]==restInterval?"selected=\"selected\"":""%>><%=REST_INTERVAL_VALUES[j]%> <%=REST_INTERVAL_VALUES[j]==1?"second":"seconds"%></option>
		<%
	}
	%>
	</select><br /></font></td>

	<td align="left"><font class="columnDataFont"><select id="ssg<%=i%>" class="selectText"  onchange="supersetChange(this)" style="margin-right:5px;color:#<%=supersetGroup==0?"000000":"ffffff"%>; background-color:<%=SUPERSET_COLORS[supersetGroup]%>;" name="ssg<%=i%>">
	<%
	for (int j=0; j<SUPERSET_COLORS.length; j++) {
		%>
		<option style="background-color:<%=SUPERSET_COLORS[j]%>; color:<%=j==0?"#000000":"#ffffff"%>; " value="<%=j%>" <%=j==supersetGroup?"selected=\"selected\"":""%>><%
		if (j==0) {
			%>none<%
		}
		else {
			%>superset <%=j%><%
		}
		%></option>
		<%
	}
	%>	
	</select><br /></font></td>

	<td align="left"><font class="columnDataFont"><nobr><textarea rows="3" cols="20" name="comments<%=i%>" class="inputText" style="height:35px; width:125px; margin:2px;" ><%=comments%></textarea></nobr><br /></font></td>

	<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
	</tr>

	<%=HtmlUtils.getHorizRuleTr(8, request)%>
	<%
	even=(even?false:true);
}
%>

</table>



<%
String buttonLabel="";
if (mode.equals("add") || mode.equals("copy")) {
	buttonLabel="add";
}
else if (mode.equals("edit")) {
	buttonLabel="save";
}
%>


<%

if (prescriptive) {
	%><input type="hidden" name="sendMail" value="false"  /><%
}
else {

	if (mode.equals("add") || mode.equals("copy")) {
		%>
		<input type="checkbox" name="sendMail" id="sendMailTrue" value="true" checked="checked" /><label for="sendMailTrue">Notify <%=controller.getSite().getLabel()%> of this workout.</label>
		<%
	}
	else if (mode.equals("edit")) {
		%>
		<input type="checkbox" name="sendMail" id="sendMailTrue" value="true"  /><label for="senMailTrue">Notify <%=controller.getSite().getLabel()%> of the changes you've made.</label>
		<%
	}
}
%>

<br /><br /><br />

<%=HtmlUtils.formButton(true, buttonLabel, null, request)%>

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

<textarea rows="1" cols="1" name="comment" style="display:none; visibility:hidden"><%=comment%></textarea>

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

