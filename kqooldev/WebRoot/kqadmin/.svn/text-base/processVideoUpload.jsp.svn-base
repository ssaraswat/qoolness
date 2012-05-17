<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="com.theavocadopapers.video.*" %>
<%@ page import="com.theavocadopapers.img.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.entity.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%

GenericProperties genericProps=new GenericProperties();

long nowTime=new Date().getTime();
try {
	MultipartServletRequest req=new MultipartServletRequest(request);
	FileItem fileItem=req.getFileItem("file");
	String filename=fileItem.getName();
	String filenameExt=filename.substring(filename.lastIndexOf(".")+1, filename.length()).trim().toLowerCase();
	boolean imageFormatOk=(filenameExt.equals("mov") || filenameExt.equals("mp4"));
	
	if (!imageFormatOk) {
		%>
		<script>
		document.domain="<%=genericProps.getJavascriptDocumentDomain()%>"
		parent.videoUploadWrongFormat("<%=filenameExt%>")
		</script>		
		<%
		response.flushBuffer();
		out.flush();
		response.flushBuffer();
	}
	
	else {
		filename=VideoUtils.saveVideoAndGenericThumbnail(fileItem, filenameExt, request);
	
		Exercise exercise=Exercise.getById(Integer.parseInt(req.getParameter("exerciseId")));
		ExerciseVideo exerciseVideo=ExerciseVideo.getById(exercise.getExerciseVideoId());
		if (exerciseVideo==null) {
			exerciseVideo=new ExerciseVideo();
		}
		exerciseVideo.setName("");
		exerciseVideo.setDescription("");
		exerciseVideo.setFilename(filename);
		exerciseVideo.setExerciseCategory(exercise.getCategory());
		exerciseVideo.store();
		exercise.setExerciseVideoId(exerciseVideo.getId());
		exercise.store();
		%>
		<script>
		document.domain="<%=genericProps.getJavascriptDocumentDomain()%>"
		parent.videoUploadSuccess()
		</script>
		<%
	}

}

catch (Exception e) {

	%>
	<script>
	alert("There was an error; your video may not have been uploaded.  Error: <%=e.getClass().getName()%>: <%=e.getMessage()%>")
	</script>
	<%
}
%>