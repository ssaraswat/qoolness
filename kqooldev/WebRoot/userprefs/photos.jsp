<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_PREFS,request); %>

<%@ include file="/global/topInclude.jsp" %>
<%@ include file="includes/prefsInclude.jsp" %>

<%!
static DateFormat uploadDateFormat=new SimpleDateFormat("MMMM d, yyyy");

static boolean hasClientPhotos(List photos, int userId) {
	Iterator i=photos.iterator();
	Photo photo;
	boolean clientPhotoFound=false;
	while (i.hasNext()) {
		photo=(Photo)i.next();
		if (photo.getUploadingUserId()!=userId) {
			continue;
		}
		return true;
	}
	return false;

}

static void putPrimaryPhotoFirst(List photos) {
	if (photos.size()<=1) {
		return;
	}
	Photo primaryPhoto=null;
	Photo photo;
	Iterator i=photos.iterator();
	while (i.hasNext()) {
		photo=(Photo)i.next();
		if (photo.isPrimaryPhoto()) {
			primaryPhoto=photo;
			i.remove();
			break;
		}
	}
	if (primaryPhoto!=null) {
		photos.add(0, primaryPhoto);
	}
}
%>

<%
User user=controller.getSessionInfo().getUser();

Map userIdsToUsers=User.getAllAsMap();

List photos=Photo.getByUserId(user.getId());
photos=(photos==null?new ArrayList():photos);
Collections.sort(photos);
Collections.reverse(photos);

boolean clientPhotosExist=hasClientPhotos(photos, controller.getSessionInfo().getUser().getId());
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

function isValidForm(formObj)
{
	var els=formObj.elements

	if (trim(els["caption"].value).length==0)
	{
		errorAlert("You have not supplied a caption; this field is required. Please fix and try again.",els["caption"])
		return false
	}


	return true
}

//called from hidden iframe when img successfully uploaded:
function photoUploadSuccess() {
	alert("Your photo was successfully uploaded.")	
	location.replace("photos.jsp?<%=controller.getSiteIdNVPair()%>&t=<%=new Date().getTime()%>")
}

// called from hidden iframe when img successfully uploaded:
function photoUploadWrongFormat(filenameExt) {
	var fmt=(filenameExt.length>0?filenameExt.toUpperCase():"an unknown")
	alert("Sorry, your photo must be in either JPEG, GIF, or PNG format; the file you uploaded is in "+fmt+" format.  Please try again.")	
}





function showAddPhotoModule() {
	document.getElementById("uploadNew").style.display="block"
}


function deletePhoto(id) {
	if (confirm("Are you sure you want to delete this photo?")) {
		location.href="deletePhoto.jsp?<%=controller.getSiteIdNVPair()%>&id="+id
	}
}
</script> 

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardTextBlockWidth">

<font class="bodyFont">
<span class="standardTextBlockWidth">
<span class="firstSentenceFont">Your photos.</span><br />
<%
boolean showAddPhotoDiv;
boolean primary;
if (!clientPhotosExist) {
	showAddPhotoDiv=true;
	primary=true;
	%>
	Here are your photos!  Except that you haven't uploaded any photos yet.  Please get started by uploading
	one here.
	<%
}
else {
	showAddPhotoDiv=false;
	primary=false;
	%>
	Here are your photos!  Want to add more?  Click <a href="#" onclick="showAddPhotoModule(); return false">here</a>.  You can also edit or delete existing
	photos by clicking the appropriate "edit" or "delete" button below.
	<%
}
%>

<%=HtmlUtils.doubleLB(request)%><br />
<iframe style="border:0px solid #ffffff; width:1px; height:1px;" id="hiddenFrame" name="hiddenFrame" src="../global/blank.html" border="1" frameborder="1" framespacing="0"></iframe>
</span>

<div id="uploadNew" style="display:<%=showAddPhotoDiv?"block":"none"%>">
<form target="hiddenFrame" action="processPhotoUpload.jsp?<%=controller.getSiteIdNVPair()%>" method="post" enctype="multipart/form-data" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="userId" value="<%=user.getId()%>" />
<input type="hidden" name="uploadingUserId" value="<%=user.getId()%>" />
<input type="hidden" name="primary" value="<%=primary%>" />
You may upload photos in JPEG, GIF, or PNG format.  All photos will
be visible only to you and to your trainer.  Photos may be up to 250 pixels wide (wider photos 
will be resized to 250 pixels) and should show your current state of physical fitness.
Please choose a file and enter a caption for it, then press the "add" button:<br/><br/>
<span class="boldishFont">Choose a file</span><br />
<input style="width:250px;" type="file" class="inputText" name="file" id="file"  size="32"><%=HtmlUtils.doubleLB(request)%>


<span class="boldishFont">Caption</span><br />
<input style="width:250px;" type="text" class="inputText" name="caption" id="caption"><%=HtmlUtils.doubleLB(request)%>
<br />
<%=HtmlUtils.formButton("add", request)%><br /><br />
</form>
</div>

<br />

<%
if (photos!=null) {
	
	
	%>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr valign="top">
	<td>
		<%
		
		// client-uploaded photos:
		%>
		<%
		putPrimaryPhotoFirst(photos);
		Iterator i=photos.iterator();
		Photo photo;
		boolean clientPhotoFound=false;
		while (i.hasNext()) {
			photo=(Photo)i.next();
			if (photo.getUploadingUserId()!=controller.getSessionInfo().getUser().getId()) {
				continue;
			}
			clientPhotoFound=true;
	
			%>
			<table border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="center" nowrap="nowrap" width="250"><img src="<%=photo.getRelativeToRootMainURL(request)%>" height="<%=photo.getMainHeight()%>"  width="<%=photo.getMainWidth()%>" border="0"  /></td>
			</tr>
			<tr>
			<td align="center"><div align="center"  style="margin-top:3px; font-size:11px;" class="bodyFont"><%=photo.getCaption()%><br/>
			<i>Uploaded: <%=uploadDateFormat.format(photo.getUploadDate())%><%
			if (photo.isPrimaryPhoto()) {
				%><br/>(This is your primary photo.)<%
			}
			%></i><br/>
			
			<div style="padding-top:5px;">
			<%=HtmlUtils.smallerFormButton(false, "edit", "location.href='editPhoto.jsp?"+controller.getSiteIdNVPair()+"&id="+photo.getId()+"'", request)%>&nbsp;&nbsp;
			<%=HtmlUtils.smallerFormButton(false, "delete", "deletePhoto("+photo.getId()+")", request)%></div>
			</div></td>
			</tr>
			</table><br/><br/><br/>
			<%
			if (!clientPhotoFound) {
				%>[You haven't uploaded any photos yet.]<%
			}
		}
	%>
	</td>
	<% /* %>
	<td width="15" style="border-right:1px solid #999999;" nowrap="nowrap">&nbsp;</td>
	<td width="15" nowrap="nowrap">&nbsp;</td>
	<td>
	<%
	


	
		// backend-user-uploaded photos:
		%>
		
		<i class="bodyFont">Photos uploaded by staff:</i><br/><br/>
		<%
		i=photos.iterator();
		boolean backendUserPhotoFound=false;
		User uploadingUser;
		while (i.hasNext()) {
			photo=(Photo)i.next();
			if (photo.getUploadingUserId()==controller.getSessionInfo().getUser().getId()) {
				continue;
			}
			backendUserPhotoFound=true;
			uploadingUser=(User)(userIdsToUsers.get(photo.getUploadingUserId()));
			%>
			<table border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="center" nowrap="nowrap" width="250"><img src="<%=photo.getRelativeToRootMainURL(request)%>" height="<%=photo.getMainHeight()%>"  width="<%=photo.getMainWidth()%>" border="0" /></td>
			</tr>
			<tr>
			<td align="center"><div align="center"  style="margin-top:3px; font-size:11px;" class="bodyFont"><%=photo.getCaption()%><br/>
			<i>Uploaded: <%=uploadDateFormat.format(photo.getUploadDate())%> by <%=uploadingUser.getFirstName()%> <%=uploadingUser.getLastName()%></i><br/></td>
			</tr>
			</table><br/><br/><br/>
			<%
			if (!backendUserPhotoFound) {
				%>[There are no staff-uploaded photos.]<%
			}
		}
		%>
		<% */ %>

	</td>
	</tr>
	</table>
	<%
}
%>




</div>

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</span>
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

