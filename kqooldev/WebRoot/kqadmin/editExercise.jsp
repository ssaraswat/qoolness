<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_EXERCISES,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_EXERCISES_ADD_AT_ONCE=1;
%>

<%

List intensityMeasures=ExerciseIntensityMeasure.getAll();
List quantityMeasures=ExerciseQuantityMeasure.getAll();
List cats=ExerciseCategory.getAll();

User user=controller.getSessionInfo().getUser();



String[] names=new String[NUM_EXERCISES_ADD_AT_ONCE];
double[] calorieFactors=new double[NUM_EXERCISES_ADD_AT_ONCE];
int[] maxLevels=new int[NUM_EXERCISES_ADD_AT_ONCE];
String[] exerciseIntensityMeasures=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] exerciseQuantityMeasures=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] categories=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] descriptions=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] calorieCalculationMethods=new String[NUM_EXERCISES_ADD_AT_ONCE];
int[] ids=new int[NUM_EXERCISES_ADD_AT_ONCE];


Exercise exercise=Exercise.getById(controller.getParamAsInt("id"));

for (int i=0; i<1; i++)
{
	names[i]=exercise.getName();
	calorieFactors[i]=exercise.getCalorieFactor();
	maxLevels[i]=exercise.getMaxLevel();
	exerciseIntensityMeasures[i]=exercise.getIntensityMeasure();
	exerciseQuantityMeasures[i]=exercise.getQuantityMeasure();
	categories[i]=exercise.getCategory();
	descriptions[i]=exercise.getDescription();
	calorieCalculationMethods[i]=exercise.getCalorieCalculationMethod();
	ids[i]=exercise.getId();

}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">


var NUM_EXERCISES_ADD_AT_ONCE=<%=NUM_EXERCISES_ADD_AT_ONCE%>



<% pageContext.include("includes/writeAllExerciseNamesArray.jsp?jsVarName=allNames"); %>

var calCalcKeys=[];

<%
Set<String> calCalcKeys=Exercise.calCalcMethodsToLabels.keySet();
int c=0;
for (String key: calCalcKeys) {
	%>
	var <%=key%>="<%=key%>";
	calCalcKeys[<%=c%>]=<%=key%>;
	<%
	c++;
}
%>
var qtyIntensityToCalCalcMethods=new Object();
<%
Set<String> keys=Exercise.qtyIntensityToCalCalcMethods.keySet();
for (String key: keys) {
	%>
	qtyIntensityToCalCalcMethods.<%=key%>=<%=Exercise.qtyIntensityToCalCalcMethods.get(key)%>;
	<%
}
%>

var currentCalCalcMethod=null;

function getCalCalcMethodFromQuantityAndIntensity(quantityCode, intensityCode) {
	var methodKey=qtyIntensityToCalCalcMethods[quantityCode+"_"+intensityCode];
	if (typeof methodKey=="undefined" || methodKey==null) {
		methodKey=UNSPECIFIED;
	}
	return methodKey;
}

// note: idx will always be 0 --
function setCalCalcMethod(idx) {
	var quantityCode=$("quantityMeasure"+idx).options[$("quantityMeasure"+idx).selectedIndex].value;
	var intensityCode=$("intensityMeasure"+idx).options[$("intensityMeasure"+idx).selectedIndex].value;
	var calCalcMethod=getCalCalcMethodFromQuantityAndIntensity(quantityCode, intensityCode);

	if (currentCalCalcMethod!=null) {
		$("entryField"+currentCalCalcMethod+idx).style.display="none";
	}
	currentCalCalcMethod=calCalcMethod;	
	$("entryField"+currentCalCalcMethod+idx).style.display="block";
}

function setMaxLevelFieldVisibility(idx) {
	var intensityCode=$("intensityMeasure"+idx).options[$("intensityMeasure"+idx).selectedIndex].value;
	if (intensityCode=="LEVEL") {
		$("maxLevelDiv"+idx).style.display="block"
	}
	else {
		$("maxLevelDiv"+idx).style.display="none"
	}
}

function isValidForm(formObj)
{

	var els=formObj.elements

	var i=0
	if (trim(els["name"+i].value).length==0)
	{
		errorAlert("You have not entered a name for this exercise; please fix and try again.",els["name"+i])
		return false
	}
	if (els["intensityMeasure"+i].selectedIndex==0)
	{
		errorAlert("You have not selected an intensity unit; please fix and try again.",els["intensityMeasure"+i])
		return false
	}
	if (els["intensityMeasure"+i].options[els["intensityMeasure"+i].selectedIndex].value=="LEVEL")
	{
		// then we need to validate the "maxLevel" field:
		if (trim(els["maxLevel"+i].value)=="") {
			errorAlert("You have chosen \"Level\" as the intensity unit, but you have not specified a maximum level; please fix and try again.",els["maxLevel"+i])
			return false
		}
		if (!isInteger(els["maxLevel"+i].value)) {
			errorAlert("The maximum level you have specified is not a whole number; please fix and try again.",els["maxLevel"+i])
			return false
		}
	}
	else {
		// else set maxLevel to 0 (it'll be hidden from the user anyway):
		els["maxLevel"+i].value=0;
	}
	
	if (els["quantityMeasure"+i].selectedIndex==0)
	{
		errorAlert("You have not selected a quantity unit; please fix and try again.",els["quantityMeasure"+i])
		return false
	}
	if (els["category"+i].selectedIndex==0)
	{
		errorAlert("You have not selected a category; please fix and try again.",els["category"+i])
		return false
	}
	if (trim(els["name"+i].value).length>100)
	{
		errorAlert("The name you have entered is "+trim(els["name"+i].value).length+" characters long; the maximum length is 100. Please fix and try again.",els["name"+i])
		return false
	}	
	if (trim(els["calorieFactor"+i].value).length==0)
	{
		errorAlert("You have not entered a calorie factor; the site cannot calculate calories expended by clients without it. Please enter this value and try again.",els["name"+i])
		return false
	}	
	if (!isNumber(trim(els["calorieFactor"+i].value)))
	{
		errorAlert("The calorie factor you have entered is not a number.  Please fix and try again.",els["name"+i])
		return false
	}	
	if (parseFloat(trim(els["calorieFactor"+i].value))==0)
	{
		if (!confirm("You have entered zero as the calorie factor for this exercise.  This is an appropriate value only if clients will expend no calories whatsoever performing this exercise.  Okay to proceed?")) {
			return false;
		}
	}	

	els["calorieCalculationMethod"+i].value=window.currentCalCalcMethod
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

<form action="processExercises.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">

<input type="hidden" name="numExercises" id="numExercises" value="<%=names.length%>">
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Here is the <%=exercise.getName()%> exercise.</span><br />
Make changes to it, then press "save changes" below. <a href="#bottom">See below</a> for an explanation of intensity units and quantity units.  
(To add or change the video associated with this exercise, click <a href="editExerciseVideo.jsp?<%=controller.getSiteIdNVPair()%>&exerciseId=<%=exercise.getId()%>">here</a>.)</span><%=HtmlUtils.doubleLB(request)%><br />



<% 

for (int i=0; i<NUM_EXERCISES_ADD_AT_ONCE; i++)
{
	%>
	<input type="hidden" name="id<%=i%>" id="id<%=i%>" value="<%=ids[i]%>" />
	<input type="hidden" name="calorieCalculationMethod<%=i%>" id="calorieCalculationMethod<%=i%>" value="<%=calorieCalculationMethods[i]%>" />
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<font class="boldishFont">Name:<br /></font>
	<font class="columnDataFont"><input class="inputText" type="text" style="width:300px;" name="name<%=i%>" id="name<%=i%>" value="<%=names[i]%>"><br /></font>
	
	<br />
	<font class="boldishFont">Intensity Units:<br /></font>
	<font class="columnDataFont"><select name="intensityMeasure<%=i%>" id="intensityMeasure<%=i%>" class="selectText" onchange="setCalCalcMethod(<%=i%>); setMaxLevelFieldVisibility(<%=i%>);" style="width:150px;">
	<option value="">...</option>
	<%
	for (int m=0; m<intensityMeasures.size(); m++) {
		ExerciseIntensityMeasure measure=(ExerciseIntensityMeasure)intensityMeasures.get(m);
		String label=measure.getName();
		String value=measure.getCode();
		%>
		<option value="<%=value%>" <%=exerciseIntensityMeasures[i].equals(measure.getCode())?"selected":""%>><%=label%></option>
		<%
	}
	%>
	</select><br /></font>
	
	<br />
	<font class="boldishFont">Quantity Units:<br /></font>
	<font class="columnDataFont"><select name="quantityMeasure<%=i%>" id="quantityMeasure<%=i%>" class="selectText" onchange="setCalCalcMethod(<%=i%>)" style="width:150px;">
	<option value="">...</option>
	<%
	for (int m=0; m<quantityMeasures.size(); m++) {
		ExerciseQuantityMeasure measure=(ExerciseQuantityMeasure)quantityMeasures.get(m);
		String label=measure.getName();
		String value=measure.getCode();
		%>
		<option value="<%=value%>"<%=exerciseQuantityMeasures[i].equals(measure.getCode())?"selected":""%>><%=label%></option>
		<%
	}
	%>
	</select><br /></font>


	<div style="xdisplay:none;" id="maxLevelDiv<%=i%>">
	<br />
	<font class="boldishFont">Maximum Level</font> (applies since Intensity Unit is "Level"):<br/>
	<font class="columnDataFont"><input class="inputText" type="text" style="width:50px;" 
	name="maxLevel<%=i%>" id="maxLevel<%=i%>" value="<%=maxLevels[i]%>" /></font>
	</div>


	<br />
	<font class="boldishFont">Category:<br /></font>
	<font class="columnDataFont"><select name="category<%=i%>" class="selectText" style="width:150px;">
	<option value="">...</option>
	<%
	for (int m=0; m<cats.size(); m++) {
		ExerciseCategory category=(ExerciseCategory)cats.get(m);
		String label=category.getName();
		String value=category.getCode();
		%>
		<option value="<%=value%>"<%=categories[i].equals(category.getCode())?"selected":""%>><%=label%></option>
		<%
	}
	%>
	</select><br /></font>
	<br />
	<font class="boldishFont">Description:<br /></font>
	<font class="columnDataFont">
	<textarea  class="inputText"  name="description<%=i%>" id="description<%=i%>"  style="width:300px; height:100px;" rows="3" cols="30" ><%=descriptions[i]%></textarea><br /></font></td>
	<br/>
	
	<font class="boldishFont">Calorie factor:</font>
	<% /* Only one of the following divs will ever be visible at one time (at render time, none of them are; at load time, one of them is made visible) -- */ %>
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_UNSPECIFIED%><%=i%>">
	<!-- Nothing. -->
	</div>
	
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_NOT_APPLICABLE%><%=i%>">
	<!-- Nothing. -->
	</div>
	
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_LAP_X_SPEED_FACTOR%><%=i%>">
	How many calories would a person who weighed 
	<%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds expend by performing one
	lap of this exercise at moderate speed?</div>
	
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_MILE_X_SPEED_FACTOR%><%=i%>">
	How many calories would a person who weighed 
	<%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds expend by performing this exercise for a mile 
	at moderate speed?</div>
	
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_MINUTE_X_LEVEL_FACTOR%><%=i%>">
	How many calories would a person who weighed 
	<%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds expend by performing this exercise
	for one minute at a moderate level of intensity?</div>
	
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_MINUTE%><%=i%>">
	How many calories would a person who weighed 
	<%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds expend performing this exercise for 
	one minute?</div>
	
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_REP_X_POUND%><%=i%>">
	How many calories would a person who weighed 
	<%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds expend by performing one repetition of 
	this exercise with one pound of resistance?</div>
	
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_REP%><%=i%>">
	How many calories would a person who weighed 
	<%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds expend by performing one repetition of 
	this exercise?</div>
	
	<div style="width:300px; display:none;" id="entryField<%=Exercise.CAL_CALC_METHOD_REP_X_SPEED_FACTOR%><%=i%>">
	How many calories would a person who weighed 
	<%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds expend by performing one repetition of this
	exercise at moderate speed?</div>
	
	
	
	<input class="inputText" type="text" style="width:50px;" 
	name="calorieFactor<%=i%>" id="calorieFactor<%=i%>" value="<%=calorieFactors[i]%>" />
		


	<br />

	<font class="columnDataFont">

	<br />
</td>
	<%
}

%>

<br />

<%=HtmlUtils.cpFormButton(true, "save", null, request)%>

<%=HtmlUtils.doubleLB(request)%><br />
<a name="bottom"></a>

<b>Intensity Units</b><br />
The amount of energy that the user expends to perform 
	a given exercise is referred to here as "intensity."  For example, with resistence training, 
	intensity is usually measured in terms of the amount of weight being lifted or moved.  On the 
	other hand, cardiovascular training machines often measure intensity in terms of "level" or a 
	similar measure.  When assigning exercises to users as part of a routine, you will specify the intensity
	level for the exercise using these units. For example, you might specify that for a given user, the Overhead 
	Press exercise
	should be performed at 170 pounds.  Users will also record their routines in the routine tracker using
	these units.  (If you don't see the measure you're looking for, contact
	 <%=siteProps.getDeveloperName()%> <a href="mailto:<%=siteProps.getDeveloperEmailAddress()%>">here</a>.)<br /><br />
	 <a href="#top">[back to top]</a><br /><br />
	<b>Quantity Units</b><br />
	The the number of times 
		that the user should repeat a given exercise (or continue doing a given exercise) is referred 
		to here as "quantity."  For example, with resistence training, 
	quantity is usually measured in terms of sets and reps.  On the 
	other hand, with cardiovascular training, "quantity" is specified in terms of time or distance (for example, 
	"jog 8 miles," or " do the Stairmaster for 40 minutes).  When assigning exercises 
	to users as part of a routine, you will specify the quantity
	 for the exercise using these units.   (If you don't see the measure you're looking for, contact 
		<%=siteProps.getDeveloperName()%> <a href="mailto:<%=siteProps.getDeveloperEmailAddress()%>">here</a>.)<br /><br />
		 <a href="#top">[back to top]</a><br /><br />

<br /></font>

</form>
</div>

<script type="text/javascript">
setCalCalcMethod(0);
setMaxLevelFieldVisibility(0);
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

