
<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ include file="/global/workoutExerciseDetailsInclude.jsp" %>


<% /* PageUtils.setRequiredLoginStatus("user",request); */ %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>
<%@ include file="../../global/topInclude.jsp" %>


<script>
function launchPrintable(workoutId) {
	window.open("displayWorkoutPrintableRedirector.jsp?<%=controller.getSiteIdNVPair()%>&id="+workoutId,"printable"+workoutId)
}
</script>

<%


// get values from including jsp:
boolean prescriptive=controller.getAttrAsBoolean("prescriptive");
int workoutId=controller.getAttrAsInt("workoutId");
boolean administratorAssigned=controller.getAttrAsBoolean("administratorAssigned");
String name=(String)controller.getAttr("name");
String comments=(String)controller.getAttr("comments");
Workout workout=(Workout)controller.getAttr("workout");
NumberFormat fmt=(NumberFormat)controller.getAttr("fmt");
Map quantityCodesToNamesMap=(Map)controller.getAttr("quantityCodesToNamesMap");
Map intensityCodesToNamesMap=(Map)controller.getAttr("intensityCodesToNamesMap");
Map allUsersMap=(Map)controller.getAttr("allUsersMap");
if (allUsersMap==null) {
	allUsersMap=User.getAllAsMap();
}
Date workoutDate=(Date)controller.getAttr("workoutDate");



boolean isAdminSection=false;
if (request.getAttribute("isAdminSection")!=null) {
	isAdminSection=((Boolean)request.getAttribute("isAdminSection")).booleanValue();
}
boolean showTagline=false;
if (request.getAttribute("showTagline")!=null) {
	showTagline=((Boolean)request.getAttribute("showTagline")).booleanValue();
}

boolean showDetails=true;
if (request.getAttribute("showDetails")!=null) {
	showDetails=((Boolean)request.getAttribute("showDetails")).booleanValue();
}
boolean containInBox=true;
if (request.getAttribute("containInBox")!=null) {
	containInBox=((Boolean)request.getAttribute("containInBox")).booleanValue();
}








String tableTitle;
if (prescriptive && administratorAssigned) {
	tableTitle="<b>"+name+"</b> "+(isAdminSection?"":"(assigned by kqool)");
}
else if (prescriptive && !administratorAssigned) {
	tableTitle="<b>"+name+"</b> "+(isAdminSection?"":"(self-assigned)");
}
else { // descriptive:
	tableTitle="<b>Your "+DateFormat.getDateInstance(DateFormat.LONG).format(workoutDate)+" workout</b>";
}


%>


<%
if (showTagline) {
	%>
	<span class="bodyFont">
	<span class="firstSentenceFont">Here it is...</span><br/>
	The highly anticipated
	<%
	if (prescriptive) {
		%>"<%=name%>" routine.<%
	}
	else {
		%><%=DateFormat.getDateInstance(DateFormat.LONG).format(workoutDate)%> workout.<%
	}
	%><br/><br/>
	<%
}
%>


<table border="0" cellspacing="0" cellpadding="0" width="<%=containInBox?"400":"100%"%>"> 
<%
if (containInBox) { 
	%>
	<%=HtmlUtils.getHorizRuleTr(5, request)%>
	
	<tr height="30">
	<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
	<td align="left" colspan="3" bgcolor="#ffffff">

	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" width="307"><font class="columnDataFont">&nbsp;<%=tableTitle%><br/></font></td>
	<td nowrap="nowrap" width="98" align="right"><%
	if (prescriptive && !isAdminSection) {
		%><a href="#" onclick="launchPrintable(<%=workoutId%>)"><img src="../images/iconPrinter.gif" height="18" width="18" border="0" style="margin-right:5px;" /></a><%
	}
	%><br/></font></td>
	</tr>
	</table>

	</span>
	
	</td>
	<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
	</tr>
	<%=HtmlUtils.getHorizRuleTr(5, request)%>

	<%
}
%>
<tr class="evenDataRow" style="background-color:#ffffff;" height="24">
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
<td align="left"><font class="columnDataFont">&nbsp&nbsp&nbsp;<br/></font></td>
<td align="left"><font class="columnDataFont">
<img src="../images/spacer.gif" height="4" width="1"><br/>
<%
List exerciseDetails=workout.getExerciseDetails();
// calculate the calories for this Workout; if it's prescriptive (a routine), we'll
// display the total as the num cals client will expend if performed as assigned;
// if descriptive (a "workout"), we'll display it as calories expended:
double calories=0.0;

User user=(User)allUsersMap.get(workout.getUserId());
boolean isUnassignedWorkout=(user==null || user.getId()==0);

// Calculate a generic client weight to use if one isn't stored with an ExerciseDetail (first
// see if they have a current weight recorded in their PFD data; if not, go with the
// generic gender weights):
double clientWeight=0.0;
try {
	clientWeight=Double.parseDouble(PfdItem.getCurrentByUserIdAndCode(user.getId(), "weight"));
}
catch (Exception e) {
	// Lots of users won't have this data stored, at least initially
}

if (clientWeight==0.0) {
	if (isUnassignedWorkout) {
		clientWeight=Exercise.DEFAULT_MALE_WEIGHT;
	}
	else {
		if (user.getGender()==User.MALE) {
			clientWeight=Exercise.DEFAULT_MALE_WEIGHT;
		}
		else {
			clientWeight=Exercise.DEFAULT_FEMALE_WEIGHT;
		}
	}
}

for (int i=0; i<exerciseDetails.size(); i++) {
	ExerciseDetail exerciseDetail=(ExerciseDetail)exerciseDetails.get(i);
	//logger.debug(">>>>>>>>>>> In for loop, i="+i+"; exerciseDetail.getCurrentUserWeight()="+exerciseDetail.getCurrentUserWeight());
	if (exerciseDetail.getCurrentUserWeight()==0.0) {
		exerciseDetail.setCurrentUserWeight(clientWeight);
	}
	Exercise exercise=Exercise.getById(exerciseDetail.getExerciseId());
	//logger.debug(">>>>>>>>>>> About to call calculateCaloriesExpended()...");
	calories+=exerciseDetail.calculateCaloriesExpended(exercise);
}

if (workout.isPrescriptive()) {
	
	%><i>Assigned on:</i> <%=(workout.getCreateDate()==null?"[unknown]":DateFormat.getDateInstance(DateFormat.LONG).format(workout.getCreateDate()))%><br/>
	<img src="../images/spacer.gif" height="5" width="1"><br/>
	<i>Calories expended if performed as assigned:</i> <%=((int)Math.floor(calories))%><br/>
	<img src="../images/spacer.gif" height="5" width="1"><br/>
	<%
}

else {
	%><i>Calories expended during this workout:</i> <%=((int)Math.floor(calories))%><br/>
	<img src="../images/spacer.gif" height="5" width="1"><br/>
	<%
}

if (workout.getAssigningBackendUserId()>0) {
	User assigningBackendUser=(User)allUsersMap.get(workout.getAssigningBackendUserId());
	if (assigningBackendUser!=null) {
		%>
		<i>Assigned by: </i><%=assigningBackendUser.getFormattedNameAndUsername()%><br/>
		<img src="../images/spacer.gif" height="5" width="1"><br/>
		
		<%
	}
}
%>
<i>Comments: </i><%=comments!=null && comments.trim().length()>0?comments+(showDetails?"<br/>":""):"[none]"%><br/></font></td>
<td valign="top"  align="right" rowspan="<%=(exerciseDetails.size()+3)%>"><%
if (containInBox) {
	%><img vspace="4" hspace="2" src="../images/workoutDisplayLogo.gif" height="36" width="16" /><br/><%
}
else {
	%>&nbsp;<%
}
%></font></td>
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
</tr>


<tr class="evenDataRow" style="background-color:#ffffff;" height="24">
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
<td align="left"><font class="columnDataFont">&nbsp;<br/></font></td>
<td align="left"><font class="columnDataFont">
<i>Exercises:</i><br/></font></td>
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
</tr>




<%
boolean even=true;
int supersetGroup;
boolean isSuperset;
for (int i=0; i<exerciseDetails.size(); i++) {
	ExerciseDetail ed=(ExerciseDetail)exerciseDetails.get(i);
	Exercise exercise=Exercise.getById(ed.getExerciseId());
	supersetGroup=ed.getSupersetGroup();
	isSuperset=(supersetGroup>0); 
	int restInterval=ed.getRestInterval();


	
	// the fact that this is a list (of either zero or one vids) is a vestige from when we used to allow for more than one exercise video to be associated with an exercise (although we never did it):
	List videos=new ArrayList();
	if (exercise.getExerciseVideoId()>0) {
		videos.add(ExerciseVideo.getById(exercise.getExerciseVideoId()));
	}

	double quantityDouble=ed.getQuantity();
	double intensityDouble=ed.getIntensity();
	int repsInt=ed.getReps();
	
	
	

	
	String quantity=fmt.format(quantityDouble);
	String intensity=fmt.format(intensityDouble);
	String reps=fmt.format(repsInt);
	
	%>
	<tr class="<%=even?"even":"odd"%>DataRow" >
	<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
	<td align="left"><font class="columnDataFont">&nbsp;<br/></font></td>
	<td align="left"><font class="columnDataFont">
	<img src="../images/spacer.gif" height="4" width="1"><br/>
	&nbsp;&nbsp;<b><%=(i+1)%>.<nobr>
	&nbsp;<%=exercise.getName()%>:</nobr> <%
	String quantityUnits=exercise.getQuantityMeasure();
	if (quantityUnits.equals("NA")) {
		// nothing.
	}
	else if (quantityUnits.equals("SET")) {
		%><%=quantity%> sets of <%=reps%> reps<%
	}	
	else {
		%><%=quantity%> <%=((String)quantityCodesToNamesMap.get(quantityUnits)).toLowerCase()%><%
	}	
	%>
	
	<%
	String intensityUnits=exercise.getIntensityMeasure();
	if (intensityUnits.equals("NA")) {
		// nothing.
	}
	else if (intensityUnits.equals("LEVEL")) {
		%>at level <%=intensity%><%
	}
	else if (intensityUnits.equals("SPEED")) {
		// note: values are 10, 20, 30, etc -- leaves us room to add more speeds if needed, and still have them be comparable to eachother
		%>at <%=SPEED_LABELS[(int)intensityDouble/10]%> speed<%
	}
	else {
		%>at <%=intensity%> <%=((String)intensityCodesToNamesMap.get(intensityUnits)).toLowerCase()%><%
	}

	%></b><%
	if (isSuperset) {
		if (showDetails) {
			%>
			<div style="margin-left:20px; padding:4px; xcolor:#ffffff; background-color:<%=SUPERSET_COLORS[supersetGroup]%>;">This exercise is part of superset <%=supersetGroup%>. It should be performed 
			with no rest interval between it and the other exercises in this superset.</div>
			<%
		}
		else {
			%>
			<span style="color:<%=SUPERSET_COLORS[supersetGroup]%>; font-weight:bold;">[Superset <%=supersetGroup%>]</span>
			<%
		}
	}
	if (showDetails) {
		%>&nbsp;&nbsp;&nbsp;&nbsp;<br/><%
	}

	if (showDetails && exercise.getDescription()!=null && exercise.getDescription().trim().length()>0) {
		%><div style="width:350px; margin-top:4px; margin-left:20px;"><i>Instructions: </i><%=exercise.getDescription()%></div><%
	}
	if (i<exerciseDetails.size()-1) {
		%>
		<div style="<%=showDetails?"width:350px;":""%> margin-top:4px; margin-left:20px;"><i>Rest interval before next exercise: </i><%=restInterval%> seconds</div>
		<%
	}

	if (ed.getComments()!=null && ed.getComments().trim().length()>0) {
		%><div style="<%=showDetails?"width:350px;":""%> margin-top:4px; margin-left:20px;"><i>Comments: </i><%=ed.getComments()%></div><%
	}
	if (showDetails && videos.size()>0) {
		%><div style="width:350px; margin-top:4px; margin-left:20px;"><i>Video<%=videos.size()>1?"s":""%>:</i><br/>
		<img src="../images/spacer.gif" height="3" width="1"><br/>
		<%
		// videos.size() will always now be 0 or 1:
		for (int j=0; j<videos.size(); j++) {
			if (j>0) {
				%><br/><%
			}
			%><%HtmlUtils.getVideoThumb(exercise, (ExerciseVideo)videos.get(j), true, pageContext, controller); %><%
		}
		%></div><br/><%
	}
	%>
	
	</font><%=showDetails?"<br/>":""%></td>


	<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
	</tr>

	<%
	//even=(even?false:true);
}
%>
<tr class="evenDataRow"  style="background-color:#ffffff;" height="12">
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
<td align="left"><font class="columnDataFont">&nbsp;<br/></font></td>
<td align="left"><font class="columnDataFont">&nbsp;<br/></font></td>
<td class="ruleRow" nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1"><br></td>
</tr>

	<%=HtmlUtils.getHorizRuleTr(5, request)%>
</table>

</span>
<%@ include file="../../global/bottomInclude.jsp" %>


<%
if (pageException!=null)
{
	%>
	<%@ include file="../../global/jspErrorDialogLaunch.jsp" %>
	<%
}
%>





























