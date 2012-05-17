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
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%!
static DateFormat deadlineDateFormat=new SimpleDateFormat("MM/dd/yy 'at' h:mm aa");
%>

<%

if (controller.getParamAsBoolean("isPopup", false)) {
	controller.redirect("showWorkoutPopup.jsp?"+controller.getSiteIdNVPair()+"&mode=view&id="+controller.getParamAsInt("id"));
}
else {
	

	
	int sort=controller.getParamAsInt("sort", UserComparator.LAST_NAME);
	
	

	String mode=controller.getParam("mode"); // "add" or "edit"
	boolean success=controller.getParamAsBoolean("success",true);
	int id=controller.getParamAsInt("id");
	
	Workout workout=Workout.getById(id);
	if (workout==null) {
		throw new JspException("Workout with ID "+id+" not found; cannot continue. (id param="+request.getParameter("id")+")");
	}

	String name=workout.getName();
	String comments=workout.getComments();
	boolean prescriptive=workout.isPrescriptive();
	ExerciseDetail.loadExerciseDetailsInto(workout);
	NumberFormat fmt=NumberFormat.getInstance();
	fmt.setGroupingUsed(false);
	
	Workout sourceRoutine=Workout.getById(workout.getSourceWorkoutId());
	
	
	// for descriptive only:
	String dateStr="";
	if (!prescriptive) {
		Calendar cal=new GregorianCalendar();
		cal.setTime(workout.getPerformedDate());
		Calendar now=new GregorianCalendar();
		boolean today=(cal.get(Calendar.YEAR)==now.get(Calendar.YEAR) && cal.get(Calendar.MONTH)==now.get(Calendar.MONTH) && cal.get(Calendar.DATE)==now.get(Calendar.DATE));
		if (true) {
			dateStr=DateFormat.getDateInstance(DateFormat.LONG).format(cal.getTime());
		}
		else {
			dateStr="today's";
		}
	
	}
	
	
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
	
	
	%>
	
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
	<html>
	<head>
	 
	<%@ include file="/global/headInclude.jsp" %>
	
	<script type="text/javascript">
	
	
	function isValidAssignForm(formObj)
	{
		var els=formObj.elements;
		if (els["userId"].selectedIndex==0) {
			errorAlert("You have not chosen a user to assign this workout to; please fix and try again.",els["userId"]);
			return false;		
		}
	
		hidePageAndShowPleaseWait();
		return true;
	}
	
	
	</script>
	
	<style type="text/css">
	
	</style>
	</head>
	
	<%@ include file="/global/bodyOpen.jsp" %>
	
	<div id="mainDiv">
	<span class="standardTextBlockWidth">
	
	
	
	
	
	<font class="bodyFont">
	
	
	<%
	if (success)
	{
		if (!isPopup) {
			if (mode.equals("view"))
			{
				%>
				<span class="firstSentenceFont">Here it is...</span><br />
				<%
				if (prescriptive) {
					%>The highly anticipated "<%=name%>" routine.<%
				}
				else {
					%>The highly anticipated <%=dateStr%> workout.<%
				}

				%>
				<%
				if (sourceRoutine!=null) {
					%>
					<br/><br/>(This workout is based on the <a href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=sourceRoutine.getId()%>&mode=view"><%=sourceRoutine.getName()%></a> routine.)
					<%
				}
				%>
				<%
			}
			else if (mode.equals("edit"))
			{
				%>
				<span class="firstSentenceFont">Please Welcome Back the New and Improved...</span><br />
				<%
				if (prescriptive) {
					%>"<%=name%>" routine<%
				}
				else {
					%><%=dateStr%> workout<%
				}
				%>. 				
				<%
				if (sourceRoutine!=null) {
					%>
					<br/><br/>(This workout is based on the <a href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=sourceRoutine.getId()%>&mode=view"><%=sourceRoutine.getName()%></a> routine.)
					<%
				}
				%><br/><br/>Your changes have been made and stored in the Kqool.com database.
				<%
			}
			else if (mode.equals("add") || mode.equals("copy"))
			{
				%>
				<span class="firstSentenceFont">Please Welcome...</span><br />
				<%
				if (prescriptive) {
					%>the "<%=name%>" routine<%
				}
				else {
					%>your <%=dateStr%> workout<%
				}
				%> to your Kqool.com database. (Hold your applause.)
				<%
				if (sourceRoutine!=null) {
					%>
					<br/><br/>(This workout is based on the <a href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=sourceRoutine.getId()%>&mode=view"><%=sourceRoutine.getName()%></a> routine.)
					<%
				}
				%>
				<br /><br />

				And here it is, in all of its glory (want to make 
				<a href="workout.jsp?<%=controller.getSiteIdNVPair()%>&mode=edit&id=<%=id%>">changes to it</a>?):
	<%
			}
	
	
		}
	}
	else
	{
		%>
		<span class="firstSentenceFont">There was a problem.</span> Some or all of your data may not have been saved.
	
		<%
	}
	%><br /><br />

				<%
				if (workout.getDueDate()!=null) {
					%>
					<i>Please note: this routine is due on <%=deadlineDateFormat.format(workout.getDueDate())%>.</i><br/><br/>
					<%
				}
				%>	
	
	<% 
	// set values for included jsp --
	// get values from including jsp:
	request.setAttribute("prescriptive",new Boolean(prescriptive));
	request.setAttribute("workoutId",new Integer(workout.getId()));
	request.setAttribute("name",name);
	request.setAttribute("comments",comments);
	request.setAttribute("workout",workout);
	request.setAttribute("fmt",fmt);
	request.setAttribute("quantityCodesToNamesMap",quantityCodesToNamesMap);
	request.setAttribute("intensityCodesToNamesMap",intensityCodesToNamesMap);
	request.setAttribute("workoutDate",workout.getPerformedDate());
	request.setAttribute("administratorAssigned",new Boolean(workout.isAdministratorAssigned()));

	
	pageContext.include("includes/displayWorkout.jsp"); %>
	
	<br />
	
	</font>
	<%
	if (mode.equals("assign")) {
		%>
		<%=HtmlUtils.formButton(true, "assign", null, request)%>
		<%
	}
	else if (mode.equals("deactivate")) {
		%>
		<%=HtmlUtils.formButton(true, "deactivate", null, request)%>
		<%
	}
	if (mode.equals("activate")) {
		%>
		<%=HtmlUtils.formButton(true, "activate", null, request)%>
		<%
	}
	%>
	</span>
	</div>
	


	<%@ include file="/global/bodyClose.jsp" %>
	
	</html>
<%
}
%>

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