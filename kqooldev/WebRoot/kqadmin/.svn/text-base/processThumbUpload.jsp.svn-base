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
	String exerciseId=req.getParameter("exerciseId");
	String filename=fileItem.getName();
	String filenameExt=filename.substring(filename.lastIndexOf(".")+1, filename.length()).trim().toLowerCase();
	boolean imageFormatOk=(filenameExt.equals("jpg") || filenameExt.equals("jpeg"));
	
	if (!imageFormatOk) {
		%>
		<script>
		document.domain="<%=genericProps.getJavascriptDocumentDomain()%>"
		parent.thumbUploadWrongFormat("<%=filenameExt%>")
		</script>		
		<%
		response.flushBuffer();
		out.flush();
		response.flushBuffer();
	}
	
	else {
		Exercise exercise=Exercise.getById(Integer.parseInt(exerciseId));
		ExerciseVideo video=ExerciseVideo.getById(exercise.getExerciseVideoId());
		String thumbFilename=new String(video.getFilename());
		thumbFilename=thumbFilename.substring(0, thumbFilename.lastIndexOf("."))+".jpg";
		VideoUtils.saveThumbnail(fileItem, thumbFilename, request);
		// we're done; unlike when we upload a video, we don't need to change anything
		// in the db -- the ExerciseVideo object remains the same; just the contents
		// of the thumb file is different.
		%>
		<script>
		document.domain="<%=genericProps.getJavascriptDocumentDomain()%>"
		parent.thumbUploadSuccess()
		</script>
		<%
	}

}

catch (Exception e) {
	%>
	<script>
	alert("There was an error; your thumbnail image may not have been uploaded.  Error: <%=e.getClass().getName()%>: <%=e.getMessage()%>")
	</script>
	<%
}
%>