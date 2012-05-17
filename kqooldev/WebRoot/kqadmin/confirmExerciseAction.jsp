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

%>

<%

boolean success=controller.getParamAsBoolean("success",true);
int id=controller.getParamAsInt("id");
String mode=controller.getParam("mode");

String name="";
if (mode.equals("edit")) {
	Exercise exercise=Exercise.getById(id);
	name=exercise.getName();
}



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">

</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardAdminTextBlockWidth">
<form>
<font class="bodyFont">


<%
if (success)
{
	if (mode.equals("add")) {
		%>
		<span class="firstSentenceFont">Success:</span><br />
		You have successfully added one or more exercises. 
		To return to the main admin menu, click
		"to main menu." To perform other actions, use the pulldown menus above.<br /><br /><%
		String exerciseIdsOfBadVideos=controller.getParam("vidErrors","");
		String exerciseIdsOfBadVideoThumbs=controller.getParam("vidThumbErrors","");
		if (exerciseIdsOfBadVideos.length()>0 || exerciseIdsOfBadVideoThumbs.length()>0) {
			Map allExercisesMap=Exercise.getAllAsMap();
			if (exerciseIdsOfBadVideos.length()>0) {
				// then it starts with a "-" which we need to trim:
				exerciseIdsOfBadVideos=exerciseIdsOfBadVideos.substring(1, exerciseIdsOfBadVideos.length());
				String[] exerciseIds;	
				exerciseIds=exerciseIdsOfBadVideos.split("-");
				%>Please note that videos for the following exercises were not uploaded because
				they were of the wrong file type (only ".mov" and ".mp4" files are allowed).  You
				may add valid video files by clicking on the exercise name.
				<ul><%
				for (int i=0; i<exerciseIds.length; i++) {
					Exercise exercise=(Exercise)allExercisesMap.get(Integer.parseInt(exerciseIds[i]));
					%>
					<li><a href="editExerciseVideo.jsp?<%=controller.getSiteIdNVPair()%>&exerciseId=<%=exercise.getId()%>"><%=exercise.getName()%></a></li>
					<%
				}
				%>
				</ul><br/>
				<%
			}
			if (exerciseIdsOfBadVideoThumbs.length()>0) {
				// then it starts with a "-" which we need to trim:
				exerciseIdsOfBadVideoThumbs=exerciseIdsOfBadVideoThumbs.substring(1, exerciseIdsOfBadVideoThumbs.length());
				String[] exerciseIds;	
				exerciseIds=exerciseIdsOfBadVideoThumbs.split("-");
				%>Please note that video thumbnail images for the following exercises were not uploaded because
				they were of the wrong file type (only ".jpg" and ".jpeg" files are allowed).  You
				may add valid thumbnail-image files by clicking on the exercise name (if 
				you have not uploaded a video yet for a given exercise, you will be required to 
				upload one first).
				<ul><%
				for (int i=0; i<exerciseIds.length; i++) {
					Exercise exercise=(Exercise)allExercisesMap.get(Integer.parseInt(exerciseIds[i]));
					%>
					<li><a href="editExerciseVideo.jsp?<%=controller.getSiteIdNVPair()%>&exerciseId=<%=exercise.getId()%>"><%=exercise.getName()%></a></li>
					<%
				}
				%>
				</ul>
				<%
			}

		}
		%><br /><%
	}
	else if (mode.equals("edit")) {
		%>
		<span class="firstSentenceFont">Success:</span><br />
		You have successfully edited the "<%=name%>" exercise. To return to the list 
		of exercises, click "back to list"; to return to the main admin menu, click
		"to main menu." To perform other actions, use the pulldown menus above.<br /><br /><br />
		
		<%=HtmlUtils.cpFormButton(false, "back to list", "location.href='exercises.jsp?"+controller.getSiteIdNVPair()+"'", request)%> <%
	}




}
else
{
	%>
	<span class="firstSentenceFont">There was a problem.</span><br />Some or all of your data may not have been saved.<br /><br /><br />

	<%
}
%>



<%=HtmlUtils.cpFormButton(false, "to main menu", "location.href='menu.jsp?"+controller.getSiteIdNVPair()+"'", request)%>

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form></span>
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

