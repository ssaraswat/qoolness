<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% //PageUtils.forceNoCache(response); %>

 
<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_PREFS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

Exercise exercise=Exercise.getById(controller.getParamAsInt("exerciseId"));
if (exercise!=null) {
	ExerciseVideo video=ExerciseVideo.getById(exercise.getExerciseVideoId());
	if (video!=null) {
		exercise.setExerciseVideoId(0);
		exercise.store();
		ExerciseVideo.deleteById(video.getId());		
	}	
}

%>
<script>
alert("The video for \"<%=exercise.getName()%>\" has been deleted.")
</script>
<%
response.flushBuffer();
out.flush();
response.flushBuffer();
controller.redirect("exercises.jsp?siteId="+controller.getSiteId());
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

