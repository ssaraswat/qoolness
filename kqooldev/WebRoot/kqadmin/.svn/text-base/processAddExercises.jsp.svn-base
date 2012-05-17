<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.img.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="com.theavocadopapers.video.*" %>




<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

// We process the request as a MultipartServletRequest, not an HttpServletRequest,
// as references to the native request object are useless.
MultipartServletRequest req=new MultipartServletRequest(request);

String successParam;
StringBuilder exerciseIdsOfBadVideos=new StringBuilder(1024);
StringBuilder exerciseIdsOfBadVideoThumbs=new StringBuilder(1024);
try
{
	int numExercises=req.getParamAsInt("numExercises");
	for (int i=0; i<numExercises; i++)
	{
		if (req.getParam("name"+i).trim().length()>0)
		{
			// then this is a Exercise to add (not a blank row):
			Exercise exercise=new Exercise();
			exercise.setName(req.getParam("name"+i));
			exercise.setQuantityMeasure(req.getParam("quantityMeasure"+i));
			exercise.setIntensityMeasure(req.getParam("intensityMeasure"+i));
			exercise.setCategory(req.getParam("category"+i));
			exercise.setDescription(req.getParam("description"+i));
			exercise.setCalorieFactor(req.getParamAsDouble("calorieFactor"+i));
			exercise.setMaxLevel(req.getParamAsInt("maxLevel"+i)); // default to 0, which is the appropriate value whenever intensityMeasure isn't "LEVEL" (and we've already validated to see if that's the case)
			exercise.setCalorieCalculationMethod(req.getParam("calorieCalculationMethod"+i, Exercise.CAL_CALC_METHOD_UNSPECIFIED));
			exercise.store();
			
			// Deal with the video, if any:
			FileItem fileItem=req.getFileItem("video"+i);
			if (fileItem!=null) {
				// then a video was uploaded, so process it (note: we ignore images uploaded without videos):
				String filename=fileItem.getName();
				String filenameExt=filename.substring(filename.lastIndexOf(".")+1, filename.length()).trim().toLowerCase();
				boolean fileFormatOk=(filenameExt.equals("mov") || filenameExt.equals("mp4"));
				if (!fileFormatOk) {
					exerciseIdsOfBadVideos.append("-"+exercise.getId());
				}
				else {
					filename=VideoUtils.saveVideoAndGenericThumbnail(fileItem, filenameExt, request);
					ExerciseVideo exerciseVideo=new ExerciseVideo();
					exerciseVideo.setName("");
					exerciseVideo.setDescription("");
					exerciseVideo.setFilename(filename);
					exerciseVideo.setExerciseCategory(exercise.getCategory());
					exerciseVideo.store();
					exercise.setExerciseVideoId(exerciseVideo.getId());
					exercise.store();
					// now let's see if a thumb was uploaded too (currently, we've stored
					// the generic thumb):
					fileItem=req.getFileItem("videoThumb"+i);
					filename=fileItem.getName();
					filenameExt=filename.substring(filename.lastIndexOf(".")+1, filename.length()).trim().toLowerCase();
					boolean imageFormatOk=(filenameExt.equals("jpg") || filenameExt.equals("jpeg"));
					if (!imageFormatOk) {
						exerciseIdsOfBadVideoThumbs.append("-"+exercise.getId());
					}
					else {
						String thumbFilename=new String(exerciseVideo.getFilename());
						thumbFilename=thumbFilename.substring(0, thumbFilename.lastIndexOf("."))+".jpg";
						VideoUtils.saveThumbnail(fileItem, thumbFilename, request);
						// we're done; unlike when we upload a video, we don't need to change anything
						// in the db -- the ExerciseVideo object remains the same; just the contents
						// of the thumb file is different.
					}
					
				}
			}
			

		}
	}
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}

controller.redirect("confirmExerciseAction.jsp?"+controller.getSiteIdNVPair()+"&mode=add&success="+successParam+"&vidErrors="+exerciseIdsOfBadVideos+"&vidThumbErrors="+exerciseIdsOfBadVideoThumbs);
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

