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
static final int NUM_EXERCISES_ADD_AT_ONCE=1;
%>

<%


Exercise exercise=Exercise.getById(controller.getParamAsInt("exerciseId"));
ExerciseVideo exerciseVideo=ExerciseVideo.getById(exercise.getExerciseVideoId());
boolean hasVideo=(exerciseVideo!=null);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

var hasVideo=<%=hasVideo%>

function submitVideoConfirm(formObj) {
	var okay=false;
	if (!hasVideo) {
		okay=true;
	}
	else {
		okay=confirm("You are about to overwrite the existing video associated with this exercise.  Okay to proceed?");
	}
	if (okay) {
		alert("This upload may take a while; please be patient.  Click \"OK\" to begin.")
	}
	return okay
}


function submitThumbConfirm(formObj) {
	var okay=false;
	return confirm("You are about to overwrite the existing thumbnail image associated with this video.  Okay to proceed?");
}

function deleteVideo(videoId) {
	if (confirm("Are you sure you want to delete this video (and its associated thumbnail image)?  This operation cannot be undone!")) {
		location.href="deleteVideo.jsp?exerciseId=<%=exercise.getId()%>&<%=controller.getSiteIdNVPair()%>"
	}
}




//called from hidden iframe when video successfully uploaded:
function videoUploadSuccess() {
	alert("Your video was successfully uploaded.")	
	location.replace("editExerciseVideo.jsp?siteId=<%=controller.getSiteId()%>&exerciseId=<%=exercise.getId()%>")
}


//called from hidden iframe when problem with video:
function videoUploadWrongFormat(filenameExt) {
	var fmt=(filenameExt.length>0?filenameExt.toUpperCase():"an unknown")
	alert("Sorry, your video must be in either MOV or MP4 format; the file you uploaded is in "+fmt+" format.  Please try again.")	
}



//called from hidden iframe when img successfully uploaded:
function thumbUploadSuccess() {
	alert("Your thumbnail image was successfully uploaded.")	
	location.replace("editExerciseVideo.jsp?siteId=<%=controller.getSiteId()%>&exerciseId=<%=exercise.getId()%>")
}


// called from hidden iframe when problem with image:
function thumbUploadWrongFormat(filenameExt) {
	var fmt=(filenameExt.length>0?filenameExt.toUpperCase():"an unknown")
	alert("Sorry, your video thumbnail image must be in JPG format; the file you uploaded is in "+fmt+" format.  Please try again.")	
}



	

 

<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>
<a name="top"></a>
<div id="mainDiv">


<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont"><%
if (hasVideo) {

	%>
	Change or remove the video for "<%=exercise.getName()%>" here.</span><br />
	To change the video associated with this exercise, 
	choose a new video and click 
	the "upload video" button.  To change the thumbnail image of this video, 
	choose an image and click 
	the "upload thumbnail" button (thumbnails must be in JPG format).  
	View the current video (<%=exerciseVideo.getFilename()%>) 
	<a href="#" onclick="getVideo(<%=exerciseVideo.getId()%>, '<%=exerciseVideo.getFilename()%>'); return false">here</a>.  
	Videos may be in 
	MOV or MP4 format.<br/><br/>
	To delete this video, click <a href="#" onclick="deleteVideo(<%=exerciseVideo.getId()%>); return false">here</a>.</span><br />	
	<%
}
else {
	%>
	Add a video for "<%=exercise.getName()%>" here.</span><br />
	To add a video for this exercise, choose a video and click the "upload video" button. 
	After you've uploaded a video, you may return to this screen and upload a 
	thumbnail image for it. 
	Videos must be in 
	MOV or MP4 format.</span><%=HtmlUtils.doubleLB(request)%><br />	
	<%
}
%>
<div id="uploadNew">
<iframe style="border:0px solid #ffffff; width:1px; height:1px; display:inline;" id="hiddenFrame" name="hiddenFrame" src="../global/blank.html" border="1" frameborder="1" framespacing="0"></iframe>

<form target="hiddenFrame" action="processVideoUpload.jsp?<%=controller.getSiteIdNVPair()%>" method="post" enctype="multipart/form-data" onsubmit="return submitVideoConfirm()" name="mainForm" id="mainForm">

<input type="hidden" name="exerciseId" value="<%=exercise.getId()%>" />

<span class="boldishFont">Choose a ".mov" or ".mp4" file to upload</span><br />
<input style="width:250px;" type="file" class="inputText" name="file" id="file"  size="32"><%=HtmlUtils.doubleLB(request)%>




<br />



<%=HtmlUtils.cpFormButton(true, "upload video", null, request)%>

<%=HtmlUtils.doubleLB(request)%><br />
<br /></font>

</form>
</div>

<%
if (hasVideo) {
	%>
	<div id="uploadNewThumb">
	<iframe style="border:0px solid #ffffff; width:1px; height:1px; display:inline;" id="hiddenThumbFrame" name="hiddenThumbFrame" src="../global/blank.html" border="1" frameborder="1" framespacing="0"></iframe>
	
	<form target="hiddenThumbFrame" action="processThumbUpload.jsp?<%=controller.getSiteIdNVPair()%>" method="post" enctype="multipart/form-data" onsubmit="return submitThumbConfirm()" name="thumbForm" id="thumbForm">
	
	<input type="hidden" name="exerciseId" value="<%=exercise.getId()%>" />
	
	<%
	String thumbFilename=exerciseVideo.getFilename().substring(0,exerciseVideo.getFilename().lastIndexOf("."))+".jpg";
	%>
	<table align="right" border="0" cellspacing="0" cellpadding="0" style="margin:0px 140px 5px 5px;">
	<tr>
	<td><img border="1" src="../images/videograbs/<%=thumbFilename%>" /></td>
	</tr>
	<tr>
	<td align="center" class="bodyFont" style="font-size:11px;"><i>current thumbnail</i></td>
	</tr>
	</table><span class="boldishFont">Choose a ".jpg" file to upload 
	(must be <%=com.theavocadopapers.video.VideoUtils.THUMB_IMG_WIDTH%> pixels wide 
	by <%=com.theavocadopapers.video.VideoUtils.THUMB_IMG_HEIGHT%> pixels high)</span><br />
	<input style="width:250px;" type="file" class="inputText" name="file" id="file"  size="32"><%=HtmlUtils.doubleLB(request)%>
	
	
	
	
	<br />
	
	
	
	<%=HtmlUtils.cpFormButton(true, "upload thumbnail", null, request)%>
	
	<%=HtmlUtils.doubleLB(request)%><br />
	<br /></font>
	
	</form>
	</div>
	
	<%
}
%>

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

