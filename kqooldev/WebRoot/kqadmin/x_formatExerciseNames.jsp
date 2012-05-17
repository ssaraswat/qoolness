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

<%!
static String formatName(String name) {
	StringBuffer newName=new StringBuffer(name.length());
	for (int i=0; i<name.length(); i++) {
		if (i==0 || (i>0 && name.charAt(i-1)==' ')) {
			newName.append((""+name.charAt(i)).toUpperCase());
		}
		else {
			newName.append((""+name.charAt(i)).toLowerCase());
		}
	}
	String ret=newName.toString();
	ret=GeneralUtils.stringReplace(ret, "Db", "DB");
	ret=GeneralUtils.stringReplace(ret, "db", "DB");
	ret=GeneralUtils.stringReplace(ret, "Ii", "II");
	ret=GeneralUtils.stringReplace(ret, "Iii", "III");
	ret=GeneralUtils.stringReplace(ret, "Dumbbell", "DB");
	ret=GeneralUtils.stringReplace(ret, "Medicineball", "Medicine Ball");
	ret=GeneralUtils.stringReplace(ret, "Situp", "Sit-up");
	ret=GeneralUtils.stringReplace(ret, "Bent Over", "Bent-over");
	ret=GeneralUtils.stringReplace(ret, "Pullover", "Pull-over");
	ret=GeneralUtils.stringReplace(ret, "Pushup", "Push-up");
	ret=GeneralUtils.stringReplace(ret, "Pullup", "Pull-up");
	ret=GeneralUtils.stringReplace(ret, "Pull Up", "Pull-up");
	ret=GeneralUtils.stringReplace(ret, "Pulldown", "Pull-down");
	ret=GeneralUtils.stringReplace(ret, "Pull Down", "Pull-down");
	ret=GeneralUtils.stringReplace(ret, "Pull Up", "Pull-up");
	ret=GeneralUtils.stringReplace(ret, "Legraise", "Leg-raise");
	ret=GeneralUtils.stringReplace(ret, "Leg Raise", "Leg-raise");
	ret=GeneralUtils.stringReplace(ret, "Stepup", "Step-up");
	ret=GeneralUtils.stringReplace(ret, "Step Up", "Step-up");
	ret=GeneralUtils.stringReplace(ret, "Olympic", "Oly.");
	ret=GeneralUtils.stringReplace(ret, " The", " the");
	return ret;
}
%>

<%

ConnectionWrapper cw=DatabaseManager.getConnection();

List exercises=null;
try {
	exercises=Exercise.selectAll(cw);
}
catch (ExpectedDataNotFoundException e) {}
if (exercises==null) {
	exercises=new ArrayList();
}

Collections.sort(exercises, new ExerciseComparator(ExerciseComparator.NAME));

for (int i=0; i<exercises.size(); i++) {
	Exercise v=(Exercise)exercises.get(i);
	String name=new String(v.getName().trim());
	v.setName(formatName(name));
}



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">




</script>

<style type="text/css">
body {background-image:url(); font-size:11px; font-family:arial, helvetica; }
td {font-size:11px; font-family:arial, helvetica; }
</style>
</head>

<%@ include file="/global/x_bodyOpen.jsp" %>


<form name="mainForm" id="mainForm" action=x_processFormatExerciseNames.jsp method="post">

<blockquote><br /><br />


About to reformat all exercise names as follows:<br />
<table border=1>
<tr >
<td><br /></td>
<td><b>Name</b><br /></td>
</tr>

<%
for (int i=0; i<exercises.size(); i++) {
	%>
	<script type="text/javascript">
	window.status="Loading <%=(i+1)%> of <%=(exercises.size())%> exercises..."
	</script>
	<%
	response.flushBuffer();
	out.flush();
	Exercise exercise=(Exercise)exercises.get(i);
	%>
	<tr valign="middle">
	<td><br /></td>
	<td><input type="text" size="50" name="name<%=exercise.getId()%>" value="<%=exercise.getName().trim()%>" /><br /></td>
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

