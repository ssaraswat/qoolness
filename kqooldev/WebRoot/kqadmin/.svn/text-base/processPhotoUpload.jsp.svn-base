<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="com.theavocadopapers.img.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.entity.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
GenericProperties genericProps=new GenericProperties();
Photo photo=new Photo();
long nowTime=new Date().getTime();
try {
	MultipartServletRequest req=new MultipartServletRequest(request);
	String caption=req.getParameter("caption");
	FileItem fileItem=req.getFileItem("file");
	String filename=fileItem.getName();
	String filenameExt=filename.substring(filename.lastIndexOf(".")+1, filename.length()).trim().toLowerCase();
	boolean imageFormatOk=(filenameExt.equals("jpg") || filenameExt.equals("jpeg") || filenameExt.equals("png") || filenameExt.equals("gif"));
	
	if (!imageFormatOk) {
		%>
		<script>
		document.domain="<%=genericProps.getJavascriptDocumentDomain()%>"
		parent.photoUploadWrongFormat("<%=filenameExt%>")
		</script>		
		<%
		response.flushBuffer();
		out.flush();
		response.flushBuffer();
	}
	
	else {
		photo.setCaption(caption);
		// ImgUtils will save GIFs as PNGs, so we need to store this image in the db as such:
		photo.setFilenameExtension(filenameExt.toLowerCase().equals("gif")?"png":filenameExt);
		photo.setFilenamePrefix(""+nowTime);
		photo.setUploadDate(new Date());
		photo.setUserId(Integer.parseInt(req.getParameter("userId")));
		photo.setUploadingUserId(Integer.parseInt(req.getParameter("uploadingUserId")));
		photo.setPrimaryPhoto(req.getParameter("primary").equals("true"));
		photo.store();
		
		File tempFile=File.createTempFile("tempPhotoUpload","");
		ImgUtils.saveUploadedFile(fileItem, tempFile, request);
		File userImageDir=new File(genericProps.getUserPhotoFilesysRoot()+"/"+req.getParameter("userId"));
		if (!userImageDir.exists()) {
			userImageDir.mkdirs();
		}
		File mainFile=new File(userImageDir, ""+nowTime+"main."+filenameExt);
		File thumbFile=new File(userImageDir, ""+nowTime+"thumb."+filenameExt);
		int[] mainHeightWidth=ImgUtils.createResizedFile(tempFile, mainFile, 250, filenameExt);
		int[] thumbHeightWidth=ImgUtils.createResizedFile(tempFile, thumbFile, 50, filenameExt);
		tempFile.delete();	
		photo.setMainHeight(mainHeightWidth[0]);
		photo.setMainWidth(mainHeightWidth[1]);
		photo.setThumbHeight(thumbHeightWidth[0]);
		photo.setThumbWidth(thumbHeightWidth[1]);
		photo.store();
		%>
		<script>
		document.domain="<%=genericProps.getJavascriptDocumentDomain()%>"
		parent.photoUploadSuccess()
		</script>
		<%
	}

}

catch (Exception e) {
	try {
		Photo.deleteById(photo.getId());
	}
	catch (Exception ignore) {}
	%>
	<script>
	alert("There was an error; your photo may not have been uploaded.  Error: <%=e.getClass().getName()%>: <%=e.getMessage()%>")
	</script>
	<%
}
%>