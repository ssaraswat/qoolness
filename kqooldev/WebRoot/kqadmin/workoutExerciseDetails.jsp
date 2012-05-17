<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>

<%@ include file="/global/workoutExerciseDetailsInclude.jsp" %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_EXERCISES=25;
NumberFormat weightFormat=new DecimalFormat("0.##");

%>

<%

// possible modes: add, edit, copy:
String mode=controller.getParam("mode","add");

int assignToUserId=controller.getParamAsInt("assignToUserId",0);
boolean assignWorkoutToUser=(assignToUserId>0);
String deadlineDate=controller.getParam("deadlineDate");
String deadlineTime=controller.getParam("deadlineTime");

String username;

User assignedToUser;
if (assignWorkoutToUser) {
	assignedToUser=User.getById(assignToUserId);
	username=assignedToUser.getUsername();
}
else {
	assignedToUser=new User();
	username="";
}

String addButtonName=(assignWorkoutToUser?"assign":"add");

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

double clientWeight=0.0;
boolean clientWeightAvailable;
String hisOrHer=null;
String heOrShe=null;
String genderLabel=null;
try {
	clientWeight=Double.parseDouble(PfdItem.getCurrentByUserIdAndCode(assignedToUser.getId(), "weight"));
	clientWeightAvailable=true;
}
catch (Exception e) {
	// Lots of users won't have this data stored, at least initially
	clientWeightAvailable=false;
}
if (clientWeight==0.0) {
	if (user.getGender()==User.MALE) {
		clientWeight=Exercise.DEFAULT_MALE_WEIGHT;
		hisOrHer="his";
		heOrShe="he";
		genderLabel="men";
	}
	else {
		clientWeight=Exercise.DEFAULT_FEMALE_WEIGHT;
		hisOrHer="her";
		heOrShe="she";
		genderLabel="women";

	}
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

var username="<%=username%>"
var numExercises=<%=chosenExercises.size()%>;
var okNumericChars="1234567890.";


var currentClientWeight=<%=clientWeight%>;

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
	var mailCheckboxChecked=els["sendMail"].checked
	var confirmMsg
	if (username.length>0) {
		confirmMsg="You are about to assign this routine to "+username+". "+(mailCheckboxChecked?"An email will be sent to this client notifying him or her of the new routine.":"However, you have opted not to send the client an email notifying him or her of the new routine.")+" Okay to proceed?"
	}
	else {
		confirmMsg="You have created a new routine, which you are not assigning to a client right now.  Okay to proceed?"
	}
	if (!confirm(confirmMsg)) {
		return false
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

function calculateCals(idx, quantityUnits, intensityUnits, exerciseId, clientWeight) {
	try {
		var intensity=0;
		var quantity=0;
		var reps=0;

		// Get the intensity:
		if (intensityUnits=="SPEED" || intensityUnits=="LEVEL") {
			intensity=$("intensity"+idx).options[$("intensity"+idx).selectedIndex].value;
		}
		else if ($("intensity"+idx)!=null) {
			intensity=$("intensity"+idx).value;
		}
		intensity=trim(intensity);

		if (intensity=="" || !isNumber(intensity)) {
			setEstimatedCals("?", idx);
			return;
		}

		// get the quantity:
		quantity=$("quantity"+idx).value;
		quantity=trim(quantity);

		if (quantity=="" || !isNumber(quantity)) {
			setEstimatedCals("?", idx);
			return;
		}

		if (quantityUnits=="SET") {
			reps=$("reps"+idx).value;
			reps=trim(reps);

			if (reps=="" || !isNumber(reps)) {
				setEstimatedCals("?", idx);
				return;
			}
			// NO, this calculation is done elsewhere.
			//quantity*=reps;
		}
		if (clientWeight<=0) {
			clientWeight=window.currentClientWeight;
		}
		var url="calculateProjectedCaloriesExpended.jsp";
		var params="<%=controller.getSiteIdNVPair()%>&idx="+idx+"&intensity="+intensity+"&quantity="+quantity+"&reps="+reps+"&exerciseId="+exerciseId+"&currentClientWeight="+clientWeight+"";

		//alert("reps="+reps+"; quantity="+quantity+"; intensity="+intensity+"");
		
		var currentAjaxRequest=new Ajax.Request(
			url, 
			{
				method: "post", 
				parameters: params, 
				onComplete: calculateCalsCALLBACK
		});
		
	}
	catch (e) {
		throw(e);
	}
}

function calculateCalsCALLBACK(xmlHttpRequest, xJsonResponseHeader) {
	//response=eval('('+xmlHttpRequest.responseText+')');
	var calsAndIdx=trim(xmlHttpRequest.responseText);
	if (calsAndIdx.indexOf("|")>-1) {
		var calsAndIdxSplit=calsAndIdx.split("|");
		if (calsAndIdxSplit.length==2) {
			var cals=calsAndIdxSplit[0];
			var idx=calsAndIdxSplit[1];
			if (cals.length>0 && idx.length>0) {
				cals=""+cals;
				if (cals.indexOf(".")>-1) {
					cals=cals.substring(0, cals.indexOf("."));
				}
				setEstimatedCals(cals, idx);
			}
			else if (idx.length>0) {
				setEstimatedCals("?", idx)
			}
		}
	}
}

function numsOnly(s) {
	s=""+s
	var okChars="1234567890-.";
	var ret="";
	for (var i=0; i<s.length; i++) {
		if (okChars.indexOf(s.charAt(i))>-1) {
			ret+=s.charAt(i);
		}
	}
	return ret;
}

function setEstimatedCals(cals, idx) {
	$("estimatedCals"+idx).innerHTML=cals;
	var totalCals=0;

	for(i=0; i<numExercises; i++) {
		var calValue=trim(numsOnly($("estimatedCals"+i).innerHTML));
		if (calValue.length>0) {
			totalCals+=parseFloat(calValue);
			
		}
	}
	if (totalCals==0) {
		totalCals="?";
	}
	else {
		totalCals=""+totalCals;
		if (totalCals.indexOf(".")>-1) {
			totalCals=totalCals.substring(0, totalCals.indexOf("."));
		}
	}
	$("estimatedCalsTotal").innerHTML=totalCals;
}


<% pageContext.include("js/js.jsp"); %>
</script>


<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<form action="processWorkout.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" id="numExercises" name="numExercises" value="<%=chosenExercises.size()%>" />
<input type="hidden" name="name" name="name" value="<%=name%>" />
<input type="hidden" id="id" value="<%=id%>" />
<input type="hidden" id="mode" name="mode" value="<%=mode%>" />
<input type="hidden" id="assignToUserId" name="assignToUserId" value="<%=assignToUserId%>" />
<input type="hidden" id="deadlineDate" name="deadlineDate" value="<%=deadlineDate%>" />
<input type="hidden" id="deadlineTime" name="deadlineTime" value="<%=deadlineTime%>" />


<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">


<%
if (mode.equals("add")) {
	%>
	<span class="firstSentenceFont">Please add exercise specifics...</span><br />...
	for the "<%=name%>" routine, 
	then press the <%=addButtonName%> button,<%=assignWorkoutToUser?" which will assign this new routine to "+assignedToUser.getFormattedNameAndUsername()+"":""%>.  
	You must enter a number for 
	all text fields.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}
else if (mode.equals("copy")) {
	%>
	<span class="firstSentenceFont">Please specify exercise specifics...</span><br />...for 
	the "<%=name%>" routine, 
	then press the <%=addButtonName%> button.  (Existing values, where  applicable, 
	are  from the routine that you copied.)  You must enter a number for
	all text fields.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}
else if (mode.equals("edit")) {
	%>
	<span class="firstSentenceFont">Please edit exercise specifics as needed...</span><br />...for the "<%=name%>" routine, 
	then press the "save" button.  You must enter a number for 
	all text fields.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}

if (clientWeightAvailable) {
	%><i>Note: calorie calculations are based on this client's stated weight of 
	<%=weightFormat.format(clientWeight)%> pounds.</i><%
}
else {
	%><span style="color:#cc0000;"><i>Note: this client has not entered <%=hisOrHer%> 
	weight, so the calorie-calculation module will assume a default weight (for
	<%=genderLabel%>) of
	<%=weightFormat.format(clientWeight)%> pounds.  When the client records this routine as a workout,
	<%=heOrShe%> will be prompted for <%=hisOrHer%> weight, so that more accurate 
	calorie calculations may be made.</i></span><%
}
%><%=HtmlUtils.doubleLB(request)%><br />





<table border="0" cellspacing="0" cellpadding="0" width="830"> 


<tr height="1"><td colspan="9" class="ruleRow"><img src="../images/spacer.gif" height="1" width="1"><br /></td></tr>
<tr class="headerRow" height="30">
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
<td valign="middle" align="center" nowrap="nowrap" width="20"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Exercise&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center" width="265" nowrap="nowrap"><font class="boldishColumnHeaderFont">&nbsp;Quantity/Intensity&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Rest&nbsp;Interval&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Superset?&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Comments&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Calories&nbsp;&nbsp;&nbsp;<br /></font></td>
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
</tr>
<%=HtmlUtils.getHorizRuleTr(9, request)%>

<%
double totalCals=0.0;
boolean even=true;
NumberFormat fmt=NumberFormat.getInstance();
fmt.setGroupingUsed(false);
for (int i=0; i<chosenExercises.size(); i++) {
	

	Exercise exercise=(Exercise)chosenExercises.get(i);
	System.out.println ("Index : " + new Integer(i));
	System.out.println("Kishore 111 : " + exercise.getDescription());
	System.out.println("Kishore 111 : " + new Integer(exercise.getId()));
	System.out.println("Exercise Detail Map : " + new Integer(exerciseIdsToExerciseDetailsMap.size()));
	ExerciseDetail ed=(ExerciseDetail)exerciseIdsToExerciseDetailsMap.get(new Integer(exercise.getId()));
	System.out.println("Kishore222 " + ed);
	if (ed == null) {
		System.out.println ("ED is null for new exercise");
		ed = new ExerciseDetail();
	}
	double calsThisRow;
	try {
		calsThisRow=ed.calculateCaloriesExpended(exercise);
		calsThisRow=Math.floor(calsThisRow);
		totalCals+=calsThisRow;
	}
	catch (Exception e) {
		calsThisRow=0;
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
	
	int restInterval=15;
	int supersetGroup=0;
	if (ed!=null) {
		restInterval=ed.getRestInterval();
		supersetGroup=ed.getSupersetGroup();		
	}
	

	%>
	<input type="hidden" name="id<%=i%>" id="id<%=i%>" value="<%=exercise.getId()%>" />
	<tr class="<%=even?"even":"odd"%>DataRow" height="30">
	<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
	<td align="left"><font class="columnDataFont">&nbsp;<%=(i+1)%>.<br /></font></td>
	<td align="left"><font class="columnDataFont"><nobr>&nbsp;<%=exercise.getName()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</nobr><br /></font></td>
	<td align="left"><font class="columnDataFont"><%
	String quantityUnits=exercise.getQuantityMeasure();
	String intensityUnits=exercise.getIntensityMeasure();
	if (quantityUnits.equals("NA")) {
		%><input type="hidden" id="quantity<%=i%>" name="quantity<%=i%>" value="0" /><input type="hidden"  value="0" name="reps<%=i%>" id="reps<%=i%>" /><%
	}
	else if (quantityUnits.equals("SET") && ed != null) {
		%><input onkeyup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		onmouseup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, 
		<%=ed.getCurrentUserWeight()%>)" 
		class="inputText" style="width:26px;" type="text" value="<%=quantity%>"  
		name="quantity<%=i%>" id="quantity<%=i%>" /> sets of 
		<input  onkeyup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)"  
		onmouseup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		class="inputText" style="width:26px;" type="text"   value="<%=reps%>"  id="reps<%=i%>" name="reps<%=i%>" /> reps<%
	}	
	else {
		if (ed != null) {
		%><input  onkeyup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)"  
		onmouseup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		class="inputText" style="width:26px;" type="text" value="<%=quantity%>"  
		name="quantity<%=i%>" id="quantity<%=i%>" />
		<%=((String)quantityCodesToNamesMap.get(quantityUnits)).toLowerCase()%><input type="hidden"   value="0"  name="reps<%=i%>" id="reps<%=i%>" /><%
		}
	}	
	%>
	
	<%
	
	if (intensityUnits.equals("NA")) {
		%><input type="hidden" value="0" name="intensity<%=i%>" id="intensity<%=i%>" value="0" /><%
	}
	else if (intensityUnits.equals("LEVEL") && ed != null) {
		%>at level <select  onchange="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		onkeyup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		onchange="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		class="selectText"  name="intensity<%=i%>" id="intensity<%=i%>">
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
	else if (intensityUnits.equals("SPEED") && ed != null) {
		%>at <select  onchange="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		onkeyup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		onchange="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		class="selectText"  name="intensity<%=i%>" id="intensity<%=i%>">
		<option value=""></option>
		<%
		for (int s=1; s<=5; s++) {
		// note: values are 10, 20, 30, etc -- leaves us room to add more speeds if needed, and still have them be comparable to eachother
			%><option value="<%=(s*10)%>" <%=intensityDouble==s*10?" selected ":""%>><%=SPEED_LABELS[s]%></option><%
		}
		%></select> speed<%
	}
	else {
		if (ed != null) {
		%>at <input  onkeyup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)"  
		onkeyup="calculateCals(<%=i%>, '<%=quantityUnits%>', '<%=intensityUnits%>', <%=exercise.getId()%>, <%=ed.getCurrentUserWeight()%>)" 
		class="inputText" style="width:26px;" type="text"  value="<%=intensity%>" 
		name="intensity<%=i%>" id="intensity<%=i%>" /> <%=((String)intensityCodesToNamesMap.get(intensityUnits)).toLowerCase()%><%
		}
	}

	%>&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="left"><font class="columnDataFont"><select class="selectText"  name="ri<%=i%>"   id="ri<%=i%>" style="margin-right:5px;">
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
	<td align="left"><font class="columnDataFont"><nobr><textarea rows="3" cols="20" name="comments<%=i%>" class="inputText" style="height:50px; width:200px; margin:2px;" ><%=comments%></textarea></nobr><br /></font></td>
	<td align="left"><font class="columnDataFont" style="font-weight:bold;"><div  id="estimatedCals<%=i%>" style="width:38px; text-align:right;"><%=calsThisRow==0?"?":""+(int)calsThisRow%></div></font></td>

	<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
	</tr>
	<%=HtmlUtils.getHorizRuleTr(9, request)%>
	<%
	even=(even?false:true);
}
%>
	
<tr class="evenDataRow" height="18">

<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
<td align="right" colspan="6"><font class="columnDataFont"><i>Total Calories:&nbsp;</i></td>
<td align="left"><font class="columnDataFont" style="font-weight:bold;"><div  id="estimatedCalsTotal" style="width:38px; text-align:right;"><%=totalCals==0?"?":""+(int)totalCals%></div></font></td>
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br /></td>
</tr>
<%=HtmlUtils.getHorizRuleTr(9, request)%>
<table>

<br />

<%
String buttonLabel="";
if (mode.equals("add") || mode.equals("copy")) {
	buttonLabel=addButtonName;
}
else if (mode.equals("edit")) {
	buttonLabel="save";
}
%>

<%
if (assignWorkoutToUser) {
	%>
	<input type="checkbox" name="sendMail" id="sendMail" value="true" checked="checked" /><label for="sendMail">Notify the client of the new routine via email</label><br/><br/>
	<%
}
%>


<%=HtmlUtils.cpFormButton(false, "cancel", "location.replace('menu.jsp?"+controller.getSiteIdNVPair()+"')", request)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%=HtmlUtils.cpFormButton(true, buttonLabel, null, request)%><br />

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

