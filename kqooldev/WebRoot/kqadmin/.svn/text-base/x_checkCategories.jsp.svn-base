<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.util.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.hibernate.acp.*" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("superuser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%

ConnectionWrapper cw=DatabaseManager.getConnection();

List videos=null;
try {
	videos=ExerciseVideo.selectAll(cw);
}
catch (ExpectedDataNotFoundException e) {}
if (videos==null) {
	videos=new ArrayList();
}

Collections.sort(videos, new ExerciseVideoComparator(ExerciseVideoComparator.NAME));

List allExercises=Exercise.selectAll(cw);

Collections.sort(allExercises, new ExerciseComparator(ExerciseComparator.NAME));


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



<input type="hidden" name=changedVideoIds value="" />
<blockquote><br /><br />
<%

if (controller.getParamAsBoolean("e")) {
	Exception ex=(Exception)session.getAttribute("ex"); 
	%>
	<b style="color:#cc0000;">There was an exception; all changes may not have been saved.</b> The exception was:<br /><br />
	<pre>
	<%=ex%>
	<%=ex.getMessage()%>
	<%
	%>
	</pre><br /><br />
	<%
}

else if (controller.getParamAsBoolean("c")) {
%>
	<b>Your changes have been made.</b><br /><br />
	<%
}
%>
<a href="#" onclick="alert('Adding videos must be done directly in the database.'); return false">[add video]</a><br /><br />

Edit videos:<br />
<table border=1>
<tr >
<td><br /></td>
<td><b>Video name</b><br /></td>
<td><b>Video cat.</b><br /></td>
<td><b>Mapped to exercise</b><br /></td>
<td><b>Exercise cat.</b><br /></td>
</tr>

<%
for (int i=0; i<videos.size(); i++) {
	String exerciseCat=null;
	%>
	<script type="text/javascript">
	window.status="Loading <%=(i+1)%> of <%=(videos.size())%> videos..."
	</script>
	<%
	response.flushBuffer();
	out.flush();
	ExerciseVideo video=(ExerciseVideo)videos.get(i);
	List mappings=null;
	try {
		mappings=VideoToExerciseMapping.selectByExerciseVideoId(cw, video.getId());
	}
	catch (ExpectedDataNotFoundException e) {}
	if (mappings==null) {
		mappings=new ArrayList();
	}
	%>
	<tr valign="middle">
	<td><img src="../images/videograbs/<%=video.getThumbnailFilename()%>" height=41 width=55 /><br /></td>
	<td><%=video.getName()%><br /></td>
	<td><%=video.getExerciseCategory()%></td>
	<td><%
	
	if (mappings.size()>1) {
		%>[mutiple mappings]<%
	}
	else {
		VideoToExerciseMapping mapping;
		if (mappings.size()==0) {
			mapping=new VideoToExerciseMapping();
		}
		else {
			mapping=(VideoToExerciseMapping)mappings.get(0);
		}
		%>
		<input type="hidden" name=currExerciseId<%=video.getId()%> value=<%=mapping.getExerciseId()%> />

		<%
		
		for (int j=0; j<allExercises.size(); j++) {
			Exercise exercise=null;
			exercise=(Exercise)allExercises.get(j);
			if (mapping.getExerciseId()==exercise.getId()) {
			%>
			<%=exercise.getName()%><br />
			<%
			exerciseCat=exercise.getCategory();
			break;
			}
		}
	}

	%></td>
	<td><%
	if (exerciseCat!=null && exerciseCat.trim().equals(video.getExerciseCategory())) {
		%><%=exerciseCat%><%
	}
	else {
		%><font color=cc0000><b><%=exerciseCat%></b></font><%
	}
	%></td>
	</tr>
	<%
}
	%>
<script type="text/javascript">
window.status="Loading: done."
</script>
<%
response.flushBuffer();
out.flush();
%>
</table>
<br />
<input type="submit" value="save changes" style="width:100px; " class="formButton" />

</blockquote>



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

