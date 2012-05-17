<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.ExerciseComparator" %>
<LINK REL=StyleSheet HREF="../css/calendar.css" TYPE="text/css" />
<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_EXERCISES=25; 

static DateFormat dateFormatVerbose=new SimpleDateFormat("EEEE, MM/dd/yy");
static DateFormat dateFormat=new SimpleDateFormat("MMddyy");
static DateFormat timeFormatVerbose=new SimpleDateFormat("hh:mm a");
static DateFormat timeFormat=new SimpleDateFormat("HHmm");
%>

<%



int assignToUserId=controller.getParamAsInt("assignToUserId",0);

List allActiveUsers=User.getBackendUserClients(currentUser.getId(), true);

// possible modes: add, edit, copy:
String mode=controller.getParam("mode","add");

User user=controller.getSessionInfo().getUser();
List allExercises=Exercise.getAll();
// sort by name:
Collections.sort(allExercises);
// sort by category
Collections.sort(allExercises, new ExerciseComparator(ExerciseComparator.CATEGORY));

Map exerciseIdsToVideos=ExerciseVideo.getAllAsMapExerciseIdKeys(allExercises);

HashMap idIntsToExercisesMap=new HashMap(allExercises.size());
for (int i=0; i<allExercises.size(); i++) {
	Exercise ex=(Exercise)allExercises.get(i);
	idIntsToExercisesMap.put(new Integer(ex.getId()),ex);
}

List categoriesList=ExerciseCategory.getAll();
int categoriesListSize=categoriesList.size();
HashMap categoryNamesToLabelsMap=new HashMap(categoriesList.size());
for (int i=0; i<categoriesList.size(); i++) {
	ExerciseCategory c=(ExerciseCategory)categoriesList.get(i);
	categoryNamesToLabelsMap.put(c.getCode(),c.getAbbrev());
}


Workout workout;
List exerciseDetails;
int[] exerciseIds;

if (mode.equals("add")) {
	workout=new Workout();
	exerciseDetails=new ArrayList(0);
	exerciseIds=new int[0];
}
else if (mode.equals("edit") || mode.equals("copy")) {
	workout=Workout.getById(controller.getParamAsInt("id"));
	if (assignToUserId==0) {
		assignToUserId=workout.getUserId();
	}
	ExerciseDetail.loadExerciseDetailsInto(workout);
	exerciseDetails=workout.getExerciseDetails();
	if (exerciseDetails!=null) {
		exerciseIds=new int[exerciseDetails.size()];
		for (int i=0; i<exerciseDetails.size(); i++) {
			ExerciseDetail ed=(ExerciseDetail)exerciseDetails.get(i);
			exerciseIds[i]=ed.getExerciseId();
		}
	}
	else {
		exerciseIds=new int[0];
	}
}
else {
	throw  new FatalApplicationException("unrecognized mode.");
}


 
String name=PageUtils.nonNull(workout.getName());
if (mode.equals("copy")) {
	name="copy of "+name;
}

int workoutIdToStore=0;
if (mode.equals("edit")) {
	workoutIdToStore=workout.getId();
}




%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>
<%@ include file="/global/calendarJs.jsp" %>

<script type="text/javascript">


var NUM_EXERCISES=<%=NUM_EXERCISES%>



<% pageContext.include("includes/writeAllWorkoutNamesArray.jsp?jsVarName=allNames"); %>

var mode="<%=mode%>"

var currentExerciseCategory=""
var allExercises=new Object();
<%
ExerciseVideo video;
String imgUrl;
for (int i=0; i<allExercises.size(); i++) {
	Exercise exercise=(Exercise)allExercises.get(i);
	video=(ExerciseVideo)exerciseIdsToVideos.get(exercise.getId());
	%>
	allExercises.id<%=exercise.getId()%>="<%=exercise.getName()%>"
	<%

	if (video!=null) {
		imgUrl=video.getFilename();
		imgUrl="../images/videograbs/"+imgUrl.substring(0, imgUrl.lastIndexOf(".")+1)+"jpg";
		%>
	allExercises.videoImgUrl<%=exercise.getId()%>="<%=imgUrl%>"
		<%
	}
	else {
		%>
		allExercises.videoImgUrl<%=exercise.getId()%>="../images/spacer.gif";
		<%
	}
		response.flushBuffer();
		out.flush();
}
%>


var currExerciseIds=[<%
for (int i=0; i<exerciseIds.length; i++) {
%><%=i>0?",":""%><%=exerciseIds[i]%><%
}
%>]

function setCurrentExerciseOptions() {
	var selectObj=document.forms["mainForm"].elements["exercisesMenu"]
	var opts=selectObj.options
	if (opts!=null) {
		var numOpts=opts.length
		for (var i=0; i<numOpts; i++) {
			opts[0]=null // array shrinks after this, so easier to take options off front of list
		}
	}
	for (var i=0; i<currExerciseIds.length; i++) {
		var opt=document.createElement("OPTION");
		selectObj.options.add(opt);
		opt.innerHTML=allExercises["id"+currExerciseIds[i]];
		opt.value=""+currExerciseIds[i];
	}
}

function addSelectedExercise(fromClick) {
	setUpDownButtons(true, true)
	var selectObj=document.forms["mainForm"].elements["allExercisesMenu"+currentExerciseCategory]
	if (selectObj.selectedIndex==-1) {
		if (!fromClick) {
			errorAlert("Please select an exercise in the lefthand menu before clicking \"add\".")
		}
	}
	else {
		var exId=parseInt(selectObj.options[selectObj.selectedIndex].value)
		currExerciseIds[currExerciseIds.length]=exId
		setCurrentExerciseOptions()
	}
}

var currentExerciseVideoUrl=null;
var showVidImageTimeout=null;

function showSelectedExerciseVideoImg() {
	clearTimeout(showVidImageTimeout)
	var selectObj=document.forms["mainForm"].elements["allExercisesMenu"+currentExerciseCategory]
	var exId=parseInt(selectObj.options[selectObj.selectedIndex].value)
	window.currentExerciseVideoUrl=allExercises["videoImgUrl"+exId];
	showVidImageTimeout=setTimeout("showSelectedExerciseVideoImgAfterTimeout()", 0)                                       	
}


function showSelectedExerciseVideoImgAfterTimeout() {
	if (currentExerciseVideoUrl!=null) {
		document.getElementById("vidImage").src=currentExerciseVideoUrl
	}
}

function removeSelectedExercise(fromClick) {
	setUpDownButtons(true, true)
	var selectObj=document.forms["mainForm"].elements["exercisesMenu"]
	if (selectObj.options.length==0 && !fromClick) {
		errorAlert("There are no exercises to remove from the righthand list.")
	}
	else {
		if (selectObj.selectedIndex==-1) {
			if (!fromClick) {
				errorAlert("Please select an exercise in the righthand menu before clicking \"remove\".")
			}
		}
		else {
			var exId=parseInt(selectObj.options[selectObj.selectedIndex].value)
			var newIdsArray=[]
			for (var i=0; i<currExerciseIds.length; i++) {
				if (exId!=currExerciseIds[i]) {
					newIdsArray[newIdsArray.length]=currExerciseIds[i]
				}
			}
			currExerciseIds=newIdsArray
			setCurrentExerciseOptions()
		}
	}
}


function isValidForm(formObj)
{
	var els=formObj.elements
	if (trim(els["name"].value).length==0)
	{
		errorAlert("You have not entered a name for this routine; please fix and try again.",els["name"])
		return false
	}
	var selectObj=document.forms["mainForm"].elements["exercisesMenu"]

	if (selectObj.options.length==0)
	{
		errorAlert("You have not chosen any exercises; you must choose at least one. Please fix and try again.")
		return false
	}
	if (mode!="edit") {
		if (!confirmDuplicateWorkoutNameFoundOk(els["name"]))
		{
			return false
		}
	}
	setActionWithExerciseIds(selectObj.options, formObj)
	hidePageAndShowPleaseWait()
	return true
}





function setActionWithExerciseIds(opts, formObj) {
	var qString=""
	for (var i=0; i<opts.length; i++) {
		qString+=(i==0?"?":"&")+"exercise"+i+"="+opts[i].value
	}
	var actn=""+formObj.action
	if (actn.indexOf("?")>-1) {
		actn=actn.substring(0, actn.indexOf("?"))
	}
	formObj.action=actn+qString
}

function changeCategory(code) {
	document.getElementById("exercisesList"+currentExerciseCategory).style.display="none"
	document.getElementById("exercisesList"+code).style.display="block"
	currentExerciseCategory=code;
}


function registerRoutineMenuClick(selectObj) {
	var selectedIdx=selectObj.selectedIndex
	var numOptions=selectObj.options.length
	var upButtonDisabled
	var downButtonDisabled
	if (selectedIdx==-1) {
		upButtonDisabled=true
		downButtonDisabled=true
	}
	else if (selectedIdx==0) {
		upButtonDisabled=true
		if (numOptions==1) {
			downButtonDisabled=true
		}
	}
	else if (selectedIdx==numOptions-1) {
		downButtonDisabled=true
		if (numOptions==1) {
			upButtonDisabled=true
		}
	}
	else {
		upButtonDisabled=false
		downButtonDisabled=false
	}
	setUpDownButtons(upButtonDisabled, downButtonDisabled)
}

function setUpDownButtons(upDisabled, downDisabled) {
	document.getElementById("moveExerciseUpButton").disabled=upDisabled
	document.getElementById("moveExerciseDownButton").disabled=downDisabled
}

function assignToUserIdChange(selectObj) {
	var clientId=selectObj.options[selectObj.selectedIndex].value
	window.frames["clientRoutines"].location.href="clientRoutines.jsp?<%=controller.getSiteIdNVPair()%>&id="+clientId
	window.frames["clientWorkouts"].location.href="clientWorkouts.jsp?<%=controller.getSiteIdNVPair()%>&id="+clientId
}

function moveCurrentItemUpOrDown(moveUp) { // moveUp is true for up, false for down
	var exercisesMenuObj=document.getElementById("exercisesMenu")
	var selectedIndex=exercisesMenuObj.selectedIndex
	if (selectedIndex>-1) { // it always will be, I think:
		// we don't manipulate the menu directly; we manipulate currExerciseIds
		// and then call setCurrentExerciseOptions(), which removes and re-adds
		// the options (the "array" of options and currExerciseIds are parallel,
		// so indices between them are the same:
		var swappedIndex1=selectedIndex
		var swappedIndex2=selectedIndex+(moveUp?-1:1)
		var newSwappedValue1=exercisesMenuObj.options[swappedIndex2].value
		var newSwappedValue2=exercisesMenuObj.options[swappedIndex1].value
		// manipulate the array in place:
		for (var i=0; i<currExerciseIds.length; i++) {
			if (i==swappedIndex1) {
				currExerciseIds[i]=newSwappedValue1
			}
			else if (i==swappedIndex2) (
				currExerciseIds[i]=newSwappedValue2
			)
			else {
				// nothing; leave this value alone
			}
			
		}
		setCurrentExerciseOptions()
		exercisesMenuObj.selectedIndex=selectedIndex+(moveUp?-1:1)
		registerRoutineMenuClick(exercisesMenuObj) // there hasn't been a click, but there's been a change in what item is selected
	}
}

// overriding:
function init() {
	setCurrentExerciseOptions();
}

<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">
.exerciseListFont {font-size:11px; font-family:arial,helvetica;}
.historyIframe {border:1px solid #666666;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<form action="workoutExerciseDetails.jsp" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="numExerciseSlots" value="<%=NUM_EXERCISES%>" />
<input type="hidden" name="prescriptive" value="<%=workout.isPrescriptive()%>" />
<input type="hidden" name="status" value="<%=workout.getStatus()%>" />
<input type="hidden" name="userId" value="<%=workout.getUserId()%>" />
<input type="hidden" name="id" value="<%=workoutIdToStore%>" />
<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
<input type="hidden" name="copyingFromWorkoutId value="<%=(mode.equals("copy")?controller.getParamAsInt("id"):0)%>" />






<input type="hidden" name="mode" value="<%=mode%>" />

<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">


<%
if (mode.equals("add")) {
	User assignToUser=User.getById(assignToUserId);
	String toUserStr="";
	if (assignToUser!=null) {
		toUserStr="to "+assignToUser.getFormattedNameAndUsername()+" ";
	}
	%>
	<span class="firstSentenceFont">Assign a new routine <%=toUserStr%>here.</span><br />
	A routine consists of one or more exercises.  
	After completing the form below, click the "continue" button (on the next screen, you'll specify 
	intensities and quantities for each exercise).</span><%=HtmlUtils.doubleLB(request)%><br />
	<%
}
else if (mode.equals("copy")) {
	%>
	<span class="firstSentenceFont">Below is the existing routine...</span><br />...from which you are creating a 
	new routine. Please make revisions below as necessary, then 
	click the "continue" button (on the next screen, you'll specify 
	intensities and quantities for each exercise). </span><%=HtmlUtils.doubleLB(request)%><br />
	<%
}
else if (mode.equals("edit")) {
	%>
	<span class="firstSentenceFont">Below is the routine you're currently editing.</span><br />
	After making revisions below, please click the "continue" button (on the next screen, you'll specify 
	intensities and quantities for each exercise).. </span><%=HtmlUtils.doubleLB(request)%><br />
	<%
}
%>




<span class="boldishFont">Routine Name</span><br />
<input class="inputText" type="text" style="width:350px;" name="name" id="name" value="<%=name%>"><br /><br />

<span class="boldishFont">Client<br />
<select style="width:350px;" name="assignToUserId" class="selectText" onchange="assignToUserIdChange(this)">
<option value="0">[unassigned]</option>
<%
Iterator it=allActiveUsers.iterator();
User u;
while (it.hasNext()) {
	u=(User)it.next();
	%>
	<option value="<%=u.getId()%>" <%=u.getId()==assignToUserId?" selected":""%>><%=u.getFormattedNameAndUsername()%></option>
	<%
}
%>
</select><br/><br/>


<span class="boldishFont">Deadline<br />
<input type="text" name="deadlineDate" style="width:180px;" readonly><img src="../images/calendar/cal.gif" onClick="displayDatePicker('deadlineDate', false, 'mdy', '/')" />

<select style="width:147px; margin-left:3px;" name="deadlineTime" class="selectText">
<%
Calendar cal=new GregorianCalendar();
cal.set(Calendar.HOUR_OF_DAY, 0);
cal.set(Calendar.MINUTE, 0);
for (int i=0; i<24; i++) {
	%>
	<option value="<%=timeFormat.format(cal.getTime())%>"><%=timeFormatVerbose.format(cal.getTime())%></option>
	<%
	cal.add(Calendar.HOUR_OF_DAY, 1);
}
%>
</select><br/><br/>

<span class="boldishFont">Comments</span><br />
<textarea  class="inputText"  name="comment" id="comment"  style="width:350px; height:50px;" rows="3" cols="30" ><%=PageUtils.nonNull(workout.getComments())%></textarea><br /><br />
 
<span class="boldishFont">Exercises:</span> Add or remove exercises from the righthand list ("This routine") as needed.<br />
<div style="overflow:visible; width:1085px; border:1px solid #666666; background-color:#eeeeee; padding:4px;">
<table border="0" cellspacing="0" cellpadding="0">
<tr valign="top">
<td  class="bodyFont" style="color:#000000;">
<b>All available exercises:</b><br />
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bodyFont"><i>category...</i></td>
<td class="bodyFont">&nbsp;</td>
<td class="bodyFont"><i>exercise...</i></td>
</tr>
<tr>
<td><select onchange="changeCategory(this.options[this.selectedIndex].value)" class="selectText" name="cats" style="background-color:#f6f6f6; height:300px; width:80px;   font-size:9px;" size="10" >
<option value="" selected="selected" >[show all]</option>
<%
	ExerciseCategory category;
	for (int i=0; i<categoriesListSize; i++) {
		category=(ExerciseCategory)categoriesList.get(i);
		if (category.getCode().equals("NONE")) {
			continue;
		}
		%>

		<option value="<%=category.getCode()%>" ><%=category.getName()%></option>

		<%
		}
%>



</select><br /></td>


<td></td>
<td><%
for (int c=0; c<=categoriesListSize; c++) {
	String code;
	if (c<categoriesListSize) {
		category=(ExerciseCategory)categoriesList.get(c);
		code=category.getCode();
	}
	else {
		code="";
	}
	%><select id="exercisesList<%=code%>" onchange="showSelectedExerciseVideoImg()" ondblclick="addSelectedExercise(true)" class="selectText" name="allExercisesMenu<%=code%>" style="display:<%=code.length()==0?"block":"none"%>; background-color:#f6f6f6; height:300px; width:220px;  font-size:9px;" size="10" >

	<%
		Exercise exercise;
		for (int i=0; i<allExercises.size(); i++) {
			exercise=(Exercise)allExercises.get(i);
			if (code.length()>0 && !exercise.getCategory().equals(code)) {
				continue;
			}
			%>
			<option <%=i==0?"selected":""%> value="<%=exercise.getId()%>" ><%=code.length()==0?categoryNamesToLabelsMap.get(exercise.getCategory())+" - ":""%><%=exercise.getName()%></option>
			<%
		}
	%>
	
	
	
	</select>
	<%
	
}
%></td>
</tr>
</table>
</td> 
<td align="center" width="103" nowrap="nowrap">
<br/><br/>


<input type="button" value="add &gt;&gt;" 
onclick="addSelectedExercise(false); return false" 
class="controlPanelSmallButton" 
style="width:75px;"><br/>

<input type="button" value="&lt;&lt; remove " 
onclick="removeSelectedExercise(false); return false" 
class="controlPanelSmallButton" 
style="background-color:#ff6600; width:75px;margin-top:4px;"><br/>

<img id="vidImage" xsrc="../images/videograbs/advanced_bike_pedals.jpg" src="../images/spacer.gif" width="85" height="64" 
border="0" style="margin:24px 0px 0px 0px;" /><br/>
</td>
<td  class="bodyFont" style="color:#000000;">



<b><br/>This routine:</b><br />
<select 
ondblclick="removeSelectedExercise(true)" 
onclick="registerRoutineMenuClick(this)" 
onchange="registerRoutineMenuClick(this)" 
class="selectText" 
name="exercisesMenu" 
id="exercisesMenu" 
style="background-color:#f6f6f6; height:300px; width:200px; font-size:9px;" 
size="10" >
<option value=""></option>
</select><br /></td>
<td align="center" width="55" nowrap="nowrap">
<br /><br/>

<input type="button" id="moveExerciseUpButton" value="up" onclick="moveCurrentItemUpOrDown(true); return false" class="controlPanelSmallButton" style="width:40px;" disabled="disabled"><br/>
<input type="button" id="moveExerciseDownButton" value="down" onclick="moveCurrentItemUpOrDown(false); return false" class="controlPanelSmallButton" style="width:40px;margin-top:6px;" disabled="disabled"><br/>

</td> 
<td><iframe class="historyIframe" id="clientRoutines" name="clientRoutines" 
border="0" frameborder="0"
src="clientRoutines.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=assignToUserId%>" 
style="width:370px; height:240px; margin-bottom:10px; margin-left:15px;"><br/></iframe>
<iframe class="historyIframe" id="clientWorkouts" name="clientWorkouts" 
border="0" frameborder="0" 
src="clientWorkouts.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=assignToUserId%>" 
style="width:370px; height:240px; margin-left:15px;"></iframe><br/></td>
</tr>
</table>
</div>




<%

/*
for (int i=0; i<NUM_EXERCISES; i++) {
	%>
	<select name="exercise<%=i%>"  class="selectText" style="width:350px;">
	<option value="">...</option>
	<%
	for (int e=0; e<allExercises.size(); e++) {
		Exercise exercise=(Exercise)allExercises.get(e);
		boolean selected;
		if (i>=exerciseIds.length) {
			selected=false;
		}
		else {
			selected=(exercise.getId()==exerciseIds[i]);
		}
		%>
		<option value="<%=exercise.getId()%>" <%=selected?" selected ":""%>><%=exercise.getName()%> (<%=quantityCodesToNamesMap.get(exercise.getQuantityMeasure())%>/<%=intensityCodesToNamesMap.get(exercise.getIntensityMeasure())%>)</option>
		<%
	}
	%>
	</select><%=HtmlUtils.doubleLB(request,2)%>
	<%
}

*/
%>


<br />

<%=HtmlUtils.cpFormButton(false, "cancel", "location.replace('menu.jsp?"+controller.getSiteIdNVPair()+"')", request)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%=HtmlUtils.cpFormButton(true, "continue", null, request)%>
<br />

<%=HtmlUtils.doubleLB(request)%><br />


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

 