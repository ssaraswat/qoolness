
<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ include file="/global/workoutExerciseDetailsInclude.jsp" %>


<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>
<%@ include file="../../global/topInclude.jsp" %>
<br/><br/>
<%


// get values from including jsp:
boolean prescriptive=controller.getAttrAsBoolean("prescriptive");
boolean administratorAssigned=controller.getAttrAsBoolean("administratorAssigned");
String name=(String)controller.getAttr("name");
String comments=(String)controller.getAttr("comments");
Workout workout=(Workout)controller.getAttr("workout");
NumberFormat fmt=(NumberFormat)controller.getAttr("fmt");
Map quantityCodesToNamesMap=(Map)controller.getAttr("quantityCodesToNamesMap");
Map intensityCodesToNamesMap=(Map)controller.getAttr("intensityCodesToNamesMap");
Date workoutDate=(Date)controller.getAttr("workoutDate");

boolean narrowLayout=controller.getParamAsBoolean("narrowLayout", true);
boolean showInstrux=controller.getParamAsBoolean("showInstrux", true);


String tableTitle;
if (prescriptive && administratorAssigned) {
	tableTitle=""+name+"";
}
else if (prescriptive && !administratorAssigned) {
	tableTitle=""+name+"";
}
else { // descriptive:
	tableTitle="<b>Your "+DateFormat.getDateInstance(DateFormat.LONG).format(workoutDate)+" workout</b>";
}
%>
<div style="width:<%=narrowLayout?"370":"540"%>px;">
<font size="3"><b>
<br/>
Here is your "<%=tableTitle%>" routine.<br/></b></font>
Print out this form and take it with you when you exercise.  Record your workout on it,hang onto it,
then log into kqool.com when you are near a computer and record your workout online.<br/><br/>
<i>Please note:</i>
Want a <%=narrowLayout?"wider":"narrower"%> layout for this page?  Click <a style="color:#ff9900; text-decoration:underline;" href="showWorkoutPrintable.jsp?narrowLayout=<%=!narrowLayout%>&showInstrux=<%=showInstrux%>&id=<%=controller.getParam("id")%>&<%=controller.getSiteIdNVPair()%>">here</a>.
Want to <%=showInstrux?"hide the instructions on this page (to make it shorter)?":"see the instructions (they're currently hidden)?"%> Click <a style="color:#ff9900; text-decoration:underline;" href="showWorkoutPrintable.jsp?narrowLayout=<%=narrowLayout%>&showInstrux=<%=!showInstrux%>&id=<%=controller.getParam("id")%>&<%=controller.getSiteIdNVPair()%>">here</a>.
Want to send a link to this page to your mobile phone?  Click <a style="color:#ff9900; text-decoration:underline;" href="#" onclick="document.getElementById('urlDiv').style.display='block'; document.getElementById('urlTextarea').select(); return false;">here</a>.
<br/>
<div id="urlDiv" style="display:none; border:1px solid #000000; padding:4px; margin-top:15px;"><i>Copy this link and send it to your mobile phone (or any email address):</i><br/>
<div style="background-color:#cccccc; padding:4px;">
<form action="#" onsubmit="return false" style="margin:0px; padding:0px; display:inline;">
<script>
document.write("<textarea style=\"height:50px; width:100%; overflow:visible; font-size:11px; font-family:arial,helvetica; border:0px solid #000000; background-color:#cccccc;\" rows=\"40\" cols=\"3\" name=\"urlTextarea\" id=\"urlTextarea\">"+location.href+"</textarea>")
</script>
</form></div>
</div>
<br/>
<br/>
</div>
<b>Date: </b>__________________________<br/><br/>

<b>Comments: </b><%=comments%><br/><br/>



<table border="0" cellspacing="0" cellpadding="4"  class="printableTable" >
<tr>
<td class="colHeaderFont" style="border-left:1px solid #000000; border-top:1px solid #000000; "><b>Exercise</b><br/></td>
<td class="colHeaderFont" style="border-left:1px solid #000000; border-top:1px solid #000000; "><b>What I Did</b><br/></td>
<%
if (!narrowLayout) {
	%><td class="colHeaderFont" style="border-left:1px solid #000000; border-top:1px solid #000000; "><b>Comments/Instructions</b><br/></td>
	<%
}
%>
</tr>

<%

for (int i=0; i<workout.getExerciseDetails().size(); i++) {
	%><tr valign="top"><%
	ExerciseDetail ed=(ExerciseDetail)workout.getExerciseDetails().get(i);
	Exercise exercise=Exercise.getById(ed.getExerciseId());
	double quantityDouble=ed.getQuantity();
	double intensityDouble=ed.getIntensity();
	int repsInt=ed.getReps();
	// we don't "do" videos on this page, but we show video thumbs *actually, the first video thumb):
	String videoThumb="";

	//List videoMappings=VideoToExerciseMapping.getByExerciseId(exercise.getId());
	
	if (exercise.getExerciseVideoId()>0) {
		ExerciseVideo video=ExerciseVideo.getById(exercise.getExerciseVideoId());
		videoThumb="../images/videograbs/"+video.getThumbnailFilename();
	}

	String quantity=fmt.format(quantityDouble);
	String intensity=fmt.format(intensityDouble);
	String reps=fmt.format(repsInt);
	%>

	<td class="printableTd"><font  class="bodyFont" size="2" face="arial,helvetica" nowrap="nowrap"><nobr><span class="exerciseNameFont"><%=exercise.getName()%>.</span></nobr><br/>
	<%
	String quantityUnits=exercise.getQuantityMeasure();
	if (quantityUnits.equals("NA")) {
		// nothing.
	}
	else if (quantityUnits.equals("SET")) {
		%><b><%=quantity%> sets</b> of <b><%=reps%> reps</b> <%
	}	
	else {
		%><b><%=quantity%> <%=((String)quantityCodesToNamesMap.get(quantityUnits)).toLowerCase()%></b> <%
	}
	String intensityUnits=exercise.getIntensityMeasure();
	if (intensityUnits.equals("NA")) {
		// nothing.
	}
	else if (intensityUnits.equals("LEVEL")) {
		%>at <b>level <%=intensity%></b> <%
	}
	else if (intensityUnits.equals("SPEED")) {
		// note: values are 10, 20, 30, etc -- leaves us room to add more speeds if needed, and still have them be comparable to eachother
		%>at <b><%=SPEED_LABELS[(int)intensityDouble/10]%> speed</b> <%
	}
	else {
		%>at <b><%=intensity%> <%=((String)intensityCodesToNamesMap.get(intensityUnits)).toLowerCase()%></b> <%
	}

	%><br/>
	<%
	if (ed.getSupersetGroup()>0) {
		%>
		<div style="width:150px; font-weight:bold; color:<%=SUPERSET_COLORS[ed.getSupersetGroup()]%>;">This is part of superset <%=ed.getSupersetGroup()%>.</div>
		<%
	}
	%>
	
	</font></nobr>
	
	<%
	if (narrowLayout) {
		%>
		<div  class="bodyFont" size="2" face="arial,helvetica" style="width:150px">
		<%
		if (ed.getComments()!=null && ed.getComments().trim().length()>0) {
			%><i>Comments: </i><%=ed.getComments()%><br/><br/><%
		}
	
		if (videoThumb.length()>0) {
			%><img src="<%=videoThumb%>" height="83" width="111" border="0"  /><br/><%
		}
		%>
		<i>Instructions: </i><%=showInstrux?exercise.getDescription():"[hidden]"%><br/>
		<i>Rest interval before next exercise: </i><%=ed.getRestInterval()%> seconds<br/>
		</div>		 
		<%
	}
	%>	
	
	</td>
	<td class="printableTd" nowrap="nowrap"><nobr><font  class="bodyFont" size="2" face="arial,helvetica"><br/>
	<%

	if (quantityUnits.equals("NA")) {
		// nothing.
	}
	else if (quantityUnits.equals("SET")) {
		%>___ sets of ___ reps <%
	}	
	else {
		%>___ <%=((String)quantityCodesToNamesMap.get(quantityUnits)).toLowerCase()%> <%
	}

	if (intensityUnits.equals("NA")) {
		// nothing.
	}
	else if (intensityUnits.equals("LEVEL")) {
		%>at level ___ <%
	}
	else if (intensityUnits.equals("SPEED")) {
		// note: values are 10, 20, 30, etc -- leaves us room to add more speeds if needed, and still have them be comparable to eachother
		%>at ___ speed <%
	}
	else {
		%>at ___ <%=((String)intensityCodesToNamesMap.get(intensityUnits)).toLowerCase()%> <%
	}

	%><br/><br/>
	<i>Rest interval:</i> ___ seconds<br/>
	
	<%
	if (ed.getSupersetGroup()>0) {
		%>
		<br/><i>Performed as superset:</i>&nbsp;&nbsp;Yes&nbsp;&nbsp;No<br/>
		<%
	}
	%>
	

	
	</font></nobr></td>
	<%
	if (!narrowLayout) {
		%>
		<td class="printableTd"><font  class="bodyFont" size="2" face="arial,helvetica">
		<%
		if (ed.getComments()!=null && ed.getComments().trim().length()>0) {
			%><i>Comments: </i><%=ed.getComments()%><br/><br/><%
		}
	
		if (videoThumb.length()>0) {
			%><img src="<%=videoThumb%>" height="83" width="111" border="0" /><br/><%
		}
		%>
		<i>Instructions: </i><%=showInstrux?exercise.getDescription():"[hidden]"%><br/>
		<i>Rest interval before next exercise: </i><%=ed.getRestInterval()%> seconds<br/>
		</font></td>
		<%
	}
	%>
	</tr>
	<%
	

}
%>
<%
for (int i=workout.getExerciseDetails().size(); i<workout.getExerciseDetails().size()+10; i++) {
	%>
	<tr valign="top">
	<td class="printableTd"><span class="exerciseNameFont">Exercise <%=(i+1)%>.<br/><br/></span><br/></td>
	<td class="printableTd">
	<br/>
	<nobr>_________ at ______<br/><br/>
	<i>Rest interval:</i> ___ seconds<br/></nobr></td>
	<%
	if (!narrowLayout) {
		%><td class="printableTd"><br/></td><%
	}
	%>
	
	</tr>
	<%
}
%>

</table>

<%@ include file="../../global/bottomInclude.jsp" %>


<%
if (pageException!=null)
{
	%>
	<%@ include file="../../global/jspErrorDialogLaunch.jsp" %>
	<%
}
%>





























