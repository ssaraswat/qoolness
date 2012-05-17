<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("superuser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%

ConnectionWrapper cw=DatabaseManager.getConnection();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">



function registerChange(videoId) {
	document.forms["mainForm"].elements["changedVideoIds"].value+=""+videoId+","
}


</script>

<style type="text/css">
body {background-image:url(); font-size:11px; font-family:arial, helvetica; }
td {font-size:11px; font-family:arial, helvetica; }
</style>
</head>

<%@ include file="/global/x_bodyOpen.jsp" %>
<pre>
<%
List exercises=Exercise.selectAll(cw);
for (int i=0; i<exercises.size(); i++) {
	Exercise exercise=(Exercise)exercises.get(i);
	%><%=exercise.getName()%><%=""+'\t'%><%
	String videoName;
	try {
		List mappings=VideoToExerciseMapping.selectByExerciseId(cw, exercise.getId());
		VideoToExerciseMapping mapping=(VideoToExerciseMapping)mappings.get(0);
		ExerciseVideo video=new ExerciseVideo(cw, mapping.getExerciseVideoId());
		videoName=video.getName();
	}
	catch (ExpectedDataNotFoundException e) {
		videoName="(no video)";
	}
	%><%=videoName%><%=""+'\t'%><%=exercise.getCategory()%><%=""+'\t'%><%=exercise.getIntensityMeasure()%><%=""+'\t'%><%=exercise.getQuantityMeasure()%><%=""+'\t'%><%=exercise.getDescription()%><%=""+'\t'%>
<%
}
%>
</pre>
<%@ include file="/global/bodyClose.jsp" %>

</html>

<%
DatabaseManager.closeConnection(cw);
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

