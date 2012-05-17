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
static final int NUM_EXERCISES_ADD_AT_ONCE=10;
%>

<%

List intensityMeasures=ExerciseIntensityMeasure.getAll();
List quantityMeasures=ExerciseQuantityMeasure.getAll();
List cats=ExerciseCategory.getAll();

User user=controller.getSessionInfo().getUser();



String[] names=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] exerciseIntensityMeasures=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] exerciseQuantityMeasures=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] categories=new String[NUM_EXERCISES_ADD_AT_ONCE];
double[] calorieFactors=new double[NUM_EXERCISES_ADD_AT_ONCE];
String[] descriptions=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] videos=new String[NUM_EXERCISES_ADD_AT_ONCE];
String[] videoImages=new String[NUM_EXERCISES_ADD_AT_ONCE];


for (int i=0; i<NUM_EXERCISES_ADD_AT_ONCE; i++)
{
	names[i]="";
	exerciseIntensityMeasures[i]="";
	exerciseQuantityMeasures[i]="";
	categories[i]="";
	calorieFactors[i]=0.0;
	descriptions[i]="";
	videos[i]="";
	videoImages[i]="";

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

var currentCalCalcMethods=[];

function getCalCalcMethodFromQuantityAndIntensity(quantityCode, intensityCode) {
	var methodKey=qtyIntensityToCalCalcMethods[quantityCode+"_"+intensityCode];
	if (typeof methodKey=="undefined" || methodKey==null) {
		methodKey=UNSPECIFIED;
	}
	return methodKey;
}



function isValidForm(formObj)
{
	if (noExercisesEntered(formObj,NUM_EXERCISES_ADD_AT_ONCE))
	{
		return false
	}
	var els=formObj.elements
	// we have at least one Exercise; make sure that all Exercises entered have all fields entered:

	for (var i=0; i<NUM_EXERCISES_ADD_AT_ONCE; i++)
	{
		if (trim(els["name"+i].value).length>0)
		{ 

			if (els["intensityMeasure"+i].selectedIndex==0)
			{
				errorAlert("You have not selected an intensity unit on row "+(i+1)+"; please fix and try again.",els["intensityMeasure"+i])
				return false
			}
			if (els["quantityMeasure"+i].selectedIndex==0)
			{
				errorAlert("You have not selected a quantity unit on row "+(i+1)+"; please fix and try again.",els["quantityMeasure"+i])
				return false
			}
			if (els["category"+i].selectedIndex==0)
			{
				errorAlert("You have not selected a category on row "+(i+1)+"; please fix and try again.",els["category"+i])
				return false
			}
			if (trim(els["name"+i].value).length>100)
			{
				errorAlert("The name you have entered on row "+(i+1)+" is "+trim(els["name"+i].value).length+" characters long; the maximum length is 100. Please fix and try again.",els["name"+i])
				return false
			}	
			if (trim(els["calorieFactor"+i].value).length==0)
			{
				errorAlert("You have not entered a calorie factor on row "+(i+1)+"; the site cannot calculate calories expended by clients without it. Please enter this value and try again.",els["calorieFactor"+i])
				return false
			}	
			if (!isNumber(trim(els["calorieFactor"+i].value)))
			{
				errorAlert("The calorie factor you have entered on row "+(i+1)+" is not a number.  Please fix and try again.",els["calorieFactor"+i])
				return false
			}	
			if (parseFloat(trim(els["calorieFactor"+i].value))==0)
			{
				if (!confirm("On row "+(i+1)+", you have entered zero as the calorie factor for this exercise.  This is an appropriate value only if clients will expend no calories whatsoever performing this exercise.  Okay to proceed?")) {
					return false;
				}
			}	

			els["calorieCalculationMethod"+i].value=window.currentCalCalcMethods[i];


           	if (els["intensityMeasure"+i].options[els["intensityMeasure"+i].selectedIndex].value=="LEVEL")
           	{
           		// then we need to validate the "maxLevel" field:
           		if (trim(els["maxLevel"+i].value)=="") {
           			errorAlert("You have chosen \"Level\" as the intensity unit on row "+(i+1)+", but you have not specified a maximum level for that row; please fix and try again.",els["maxLevel"+i])
           			return false
           		}
           		if (!isInteger(els["maxLevel"+i].value)) {
           			errorAlert("The maximum level you have specified on row "+(i+1)+" is not a whole number; please fix and try again.",els["maxLevel"+i])
           			return false
           		}
           	}
           	else {
           		// else set maxLevel to 0 (it'll be hidden from the user anyway):
           				els["maxLevel"+i].value=0;
           	}
			                                                                 	
			                                                                 			                                                                     


			
		}
	}

	// user tried to add a name that was already in the db:
	if (duplicateExerciseNameFound(formObj,NUM_EXERCISES_ADD_AT_ONCE))
	{
		return false
	}
	// user tried to add two exercises with the same name:
	if (duplicateExerciseNamesInForm(formObj,NUM_EXERCISES_ADD_AT_ONCE))
	{
		return false;
	}	
	hidePageAndShowPleaseWait();
	return true;
}


//note: idx will always be 0 --
function setCalCalcMethod(idx) {
	var quantityCode=$("quantityMeasure"+idx).options[$("quantityMeasure"+idx).selectedIndex].value;
	var intensityCode=$("intensityMeasure"+idx).options[$("intensityMeasure"+idx).selectedIndex].value;
	var calCalcMethod=getCalCalcMethodFromQuantityAndIntensity(quantityCode, intensityCode);
	currentCalCalcMethods[idx]=calCalcMethod;	
}

function showMaxLevelHelp() {
	alert("Set the Max Level value if and only if you have chosen \"Level\" as the Intensity Unit for this exercise.  If so, this value should be the highest level possible for a client to reach (for example, if StairMaster allows exercisers to choose a level from 1 to 20, then \"20\" should be the value here). The site needs this value to calculate calories expended by clients.")
}

function showCalorieFactorHelp(idx) {
	var intensityMeasure=$("intensityMeasure"+idx).options[$("intensityMeasure"+idx).selectedIndex].value;
	var quantityMeasure=$("quantityMeasure"+idx).options[$("quantityMeasure"+idx).selectedIndex].value;
	if (intensityMeasure=="" || quantityMeasure=="") {
		alert("Please choose intensity units and quantity units for this exercise before setting the calorie factor.");
	}
	else if (currentCalCalcMethods[idx]=="<%=Exercise.CAL_CALC_METHOD_LAP_X_SPEED_FACTOR%>") {
		alert("For this combination of quantity unit and intensity unit, enter how many calories a person who weighs <%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds would expend by performing one lap of this exercise at moderate speed.");
	}
	else if (currentCalCalcMethods[idx]=="<%=Exercise.CAL_CALC_METHOD_MILE_X_SPEED_FACTOR%>") {
		alert("For this combination of quantity unit and intensity unit, enter how many calories a person who weighs <%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds would expend by performing this exercise for a mile at moderate speed.");
	}
	else if (currentCalCalcMethods[idx]=="<%=Exercise.CAL_CALC_METHOD_MINUTE_X_LEVEL_FACTOR%>") {
		alert("For this combination of quantity unit and intensity unit, enter how many calories a person who weighs <%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds would expend by performing this exercise for one minute at a moderate level of intensity.");
	}
	else if (currentCalCalcMethods[idx]=="<%=Exercise.CAL_CALC_METHOD_MINUTE%>") {
		alert("For this combination of quantity unit and intensity unit, enter how many calories a person who weighs <%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds would expend by performing this exercise for one minute.");
	}
	else if (currentCalCalcMethods[idx]=="<%=Exercise.CAL_CALC_METHOD_REP_X_POUND%>") {
		alert("For this combination of quantity unit and intensity unit, enter how many calories a person who weighs <%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds would expend by performing one repetition of this exercise with one pound of resistance.");
	}
	else if (currentCalCalcMethods[idx]=="<%=Exercise.CAL_CALC_METHOD_REP%>") {
		alert("For this combination of quantity unit and intensity unit, enter how many calories a person who weighs <%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds would expend by performing one repetition of this exercise.");
	}
	else if (currentCalCalcMethods[idx]=="<%=Exercise.CAL_CALC_METHOD_REP_X_SPEED_FACTOR%>") {
		alert("For this combination of quantity unit and intensity unit, enter how many calories a person who weighs <%=Exercise.BASE_WEIGHT_FOR_CAL_CALCULATIONS%> pounds would expend by performing one repetition of this exercise at moderate speed.");
	}
	else {
		alert("WARNING: for this combination of quantity unit ("+quantityMeasure+") and intensity unit ("+intensityMeasure+"), the site does not have a way of calculating calories expended.  You may enter a calorie factor anyway, but until the site is capable of calculating expended calories based on this intensity/quantity combination, zero calories will be recorded when clients perform this exercise.");
	}
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

<form action="processAddExercises.jsp?<%=controller.getSiteIdNVPair()%>" method="post" enctype="multipart/form-data" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="numExercises" id="numExercises" value="<%=names.length%>">
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Add exercises here.</span><br />
You may add up to 
<%=NUM_EXERCISES_ADD_AT_ONCE%> exercises at a time. If you need to add fewer than that, 
leave the unneeded user rows blank.  <a href="#bottom">See below</a> for an explanation 
of intensity units and quantity units.</span><%=HtmlUtils.doubleLB(request)%><br />

<table border="0" cellspacing="0" cellpadding="0">
<%=HtmlUtils.getHorizRuleTr(13, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Name&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Intensity Units&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Quantity Units&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Category&nbsp;&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Calorie&nbsp;Factor&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Max&nbsp;Level&nbsp;<a href="#" style="text-decoration:none; color:#ff9900; font-weight:bold;" onclick="showMaxLevelHelp(); return false;">[?]</a>&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Description&nbsp;(optional)&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Video&nbsp;Upload&nbsp;(optional)&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Video&nbsp;Image&nbsp;Upload&nbsp;(optional)&nbsp;&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont"><img src="../images/spacer.gif" height="1" width="1" /><br /></font></td>
<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(13, request)%>

 

<% 

for (int i=0; i<NUM_EXERCISES_ADD_AT_ONCE; i++)
{
	%>
	<input type="hidden" name="calorieCalculationMethod<%=i%>" id="calorieCalculationMethod<%=i%>" value="" />
	<tr valign="middle" class="<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%>" height="24">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td align="left"><font class="columnDataFont">&nbsp;<%=(i+1)%>.<br /></font></td>
	<td align="left"><font class="columnDataFont"><input class="inputText" type="text" style="width:90px; margin-right:3px;" name="name<%=i%>" id="name<%=i%>" value="<%=names[i]%>"><br /></font></td>
	<td align="left"><font class="columnDataFont"><select onchange="setCalCalcMethod(<%=i%>)" name="intensityMeasure<%=i%>" id="intensityMeasure<%=i%>" class="selectText" style="width:100px; margin-right:3px;">
	<option value="">...</option>
	<%
	for (int m=0; m<intensityMeasures.size(); m++) {
		ExerciseIntensityMeasure measure=(ExerciseIntensityMeasure)intensityMeasures.get(m);
		String label=measure.getName();
		String value=measure.getCode();
		%>
		<option value="<%=value%>"><%=label%></option>
		<%
	}
	%>
	</select><br /></font></td>
	<td align="left"><font class="columnDataFont"><select onchange="setCalCalcMethod(<%=i%>)" name="quantityMeasure<%=i%>" id="quantityMeasure<%=i%>" class="selectText" style="width:100px; margin-right:3px;">
	<option value="">...</option>
	<%
	for (int m=0; m<quantityMeasures.size(); m++) {
		ExerciseQuantityMeasure measure=(ExerciseQuantityMeasure)quantityMeasures.get(m);
		String label=measure.getName();
		String value=measure.getCode();
		%>
		<option value="<%=value%>"><%=label%></option>
		<%
	}
	%>
	</select><br /></font></td>
	<td align="left"><font class="columnDataFont"><select name="category<%=i%>" class="selectText" style="width:80px; margin-right:3px;">
	<option value="">...</option>
	<%
	for (int m=0; m<cats.size(); m++) {
		ExerciseCategory category=(ExerciseCategory)cats.get(m);
		String label=category.getName();
		String value=category.getCode();
		%>
		<option value="<%=value%>"><%=label%></option>
		<%
	}
	%>
	</select><br /></font></td>
	
	<td align="left"><font class="columnDataFont"><input class="inputText" type="text" style="width:50px; margin-right:3px;" name="calorieFactor<%=i%>" id="calorieFactor<%=i%>" value="" /><a href="#" style="text-decoration:none; font-weight:bold; color:#ff9900;" onclick="showCalorieFactorHelp(<%=i%>); return false;">[?]</a><br /></font></td>
	<td align="left"><font class="columnDataFont"><input class="inputText" type="text" style="width:50px; margin-right:3px;" name="maxLevel<%=i%>" id="maxLevel<%=i%>" value="" /><br /></font></td>
	
	<td align="left"><font class="columnDataFont"><textarea  class="inputText"  name="description<%=i%>" id="description<%=i%>"  style="width:250px; height:50px; margin-right:3px;" rows="3" cols="30" ><%=descriptions[i]%></textarea><br /></font></td>
	<td align="left" nowrap="nowrap" width="200"><font class="columnDataFont"><input type="file"  class="inputText"  name="video<%=i%>" id="video<%=i%>"  style="width:150px; margin-right:3px;" /><br /></font></td>
	<td align="left" nowrap="nowrap" width="200"><font class="columnDataFont"><input type="file"  class="inputText"  name="videoThumb<%=i%>" id="videoThumb<%=i%>"  style="width:150px; margin-right:3px;" /><br /></font></td>
	<td align="left" nowrap="nowrap" width="1"><br /></td>
	
	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr>
	<%=HtmlUtils.getHorizRuleTr(13, request)%>
	<%
}

%>

</table><br />

<%=HtmlUtils.cpFormButton(true, "add", null, request)%>
<%=HtmlUtils.cpFormButton(false, "cancel", "location.replace('menu.jsp?"+controller.getSiteIdNVPair()+"')", request)%>
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

