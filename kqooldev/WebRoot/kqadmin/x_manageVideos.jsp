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


<form name="mainForm" id="mainForm" action=x_processManageVideos.jsp method="post">
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

<font size=3 color=cc0000> <b>NOTE:</b> Because of a bug in this page, to change a video, first remove the exercise mapping and then add the correct one.<br /><br />
</font>

Edit videos:<br />
<table border=1>
<tr >
<td><br /></td>
<td><b>Name</b><br /></td>
<td><b>Mapped to exercise</b><br /></td>
</tr>

<%
for (int i=0; i<videos.size(); i++) {
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
	<td><%=video.getName()%> (<%=video.getId()%>)<br /></td>
	<td><%

	if (mappings.size()>1) {
		%><select disabled="disabled" style="width:290px;" name="id<%=video.getId()%>" class=selectText>
		<option value=IGNORE>[mutiple mappings; edit manually]</option>
		</select><%
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
		<select onchange="registerChange(<%=video.getId()%>)" style="width:290px;" name="id"<%=video.getId()%> class=selectText>
		<option value="">[none]</option>
		<%
		for (int j=0; j<allExercises.size(); j++) {
			Exercise exercise=(Exercise)allExercises.get(j);
			%><option <%=(mapping.getExerciseId()==exercise.getId()?"selected":"")%> value="<%=exercise.getId()%>"><%=exercise.getName()%> (<%=exercise.getId()%>)</option>
			<%
		}
		%></select><%
	}

	%><br /></td>
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

