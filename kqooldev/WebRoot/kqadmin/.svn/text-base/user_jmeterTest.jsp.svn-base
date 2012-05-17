<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!
static final int[] MAX_WORKOUT_RESULTS={3, 5, 10, 20, 999999};

static DateFormat genericDateFormat=new SimpleDateFormat("MMMM d, yyyy 'at' h:mm a");
static DateFormat uploadDateFormat=new SimpleDateFormat("MMMM d, yyyy");

static Map tabCodesToLabelsMap=initTabCodesToLabelsMap();


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

static String[] PFD_SECTION_CODES={"Current","Comments","Historical"};
static String[] PFD_SECTION_LINK_LABELS={"Current&nbsp;Data","Comments","Historical&nbsp;Data"};

static String getPfdSectionLinks(String code) {
	StringBuilder b=new StringBuilder(512);
	b.append("<div style=\"padding:4px; background-color:#eeeeee; font-weight:bold;\">");
	for (int i=0; i<PFD_SECTION_CODES.length; i++) {
		if (i>0) {
			b.append("&nbsp;&nbsp;|&nbsp;&nbsp;");
		}
		if (!code.equals(PFD_SECTION_CODES[i])) {
			b.append("<a href=\"#\" onclick=\"switchPfdSection('"+PFD_SECTION_CODES[i]+"'); return false;\">"+PFD_SECTION_LINK_LABELS[i]+"</a>");
		}
		else {
			b.append(PFD_SECTION_LINK_LABELS[i]);
		}
	}
	b.append("</div>");
	return b.toString();
}


static Map<String,String> initTabCodesToLabelsMap() {
	Map<String,String> map=new LinkedHashMap<String,String>(20);
	map.put("general","General");
	map.put("photos","Photos");
	map.put("status","Status");
	map.put("backendUsers","Backend Users");
	map.put("routines","Routines");
	map.put("workouts","Workouts");
	map.put("calories","Calories");
	map.put("pfd","Fitness Data");
	map.put("nutrition","Nutrition");
	return map;
}

static DateFormat dateFormat=new SimpleDateFormat("MM/dd/yyyy");
//static DateFormat dateTimeFormat=new SimpleDateFormat("MM/dd/yyyy, hh:mm a '(Eastern)'");
static DateFormat dateTimeFormat=new SimpleDateFormat("MM/dd/yyyy");
static DateFormat workoutDateTimeFormat=new SimpleDateFormat("MM/dd/yyyy 'at' hh:mm a");
static DateFormat workoutDateFormat=new SimpleDateFormat("EEEE, MMMM d, yyyy");
%>

<%
// reusable:
Iterator it;

int maxRoutineResults=controller.getParamAsInt("maxRoutineResults", 3);
int maxWorkoutResults=controller.getParamAsInt("maxWorkoutResults", 3);



int viewingUserId=controller.getParamAsInt("id");
User viewingUser=User.getById(viewingUserId);

// for testing:
currentUser=User.getById(1);
User user=User.getById(1);

Address userAddress=Address.getByUserId(viewingUser.getId());
/*
// for testing:
userAddress=new Address();
userAddress.setAddressLine1("142 Montague St., #5R");
userAddress.setCity("Brooklyn");
userAddress.setStateProvinceCode("NY");
userAddress.setPostalCode("11201");
userAddress.setCountryCode("USA");
userAddress.setMobileTelephone("718-809-0536");
*/

String activeTab=controller.getParam("activeTab", "general");
String activePfdTab=controller.getParam("activePfdTab", "Current");


//note: these lists and maps used by both routines and workouts tabs:
List intensityMeasuresList=ExerciseIntensityMeasure.getAll();
List quantityMeasuresList=ExerciseQuantityMeasure.getAll();
HashMap intensityCodesToNamesMap=new HashMap(intensityMeasuresList.size());
HashMap quantityCodesToNamesMap=new HashMap(quantityMeasuresList.size());
for (int i=0; i<intensityMeasuresList.size(); i++) {
	ExerciseIntensityMeasure m=(ExerciseIntensityMeasure)intensityMeasuresList.get(i);
	intensityCodesToNamesMap.put(m.getCode(),m.getName());
}
for (int i=0; i<quantityMeasuresList.size(); i++) {
	ExerciseQuantityMeasure m=(ExerciseQuantityMeasure)quantityMeasuresList.get(i);
	quantityCodesToNamesMap.put(m.getCode(),m.getName());
}
List allUsers=User.getAll();
if (allUsers==null) {
	allUsers=new ArrayList(0);
}
Map allUsersMap=User.getAllAsMap();
Map allSitesMap=Site.getAllAsMap();


request.setAttribute("intensityCodesToNamesMap", intensityCodesToNamesMap);
request.setAttribute("quantityCodesToNamesMap", quantityCodesToNamesMap);
request.setAttribute("allUsers", allUsers);
request.setAttribute("allUsersMap", allUsersMap);


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">
<% pageContext.include("js/js.jsp"); %>

var activeTab="<%=activeTab%>"



function confirmActivate(id, fullname, statusInt, retUrl) {
	var status
	switch (statusInt) {
		case 1 : status="preactive"; break;
		case 3 : status="suspended"; break;
		case 4 : status="deactivated"; break;
		default : status="unknown"
	}
	if (generalConfirm(fullname+"'s account status is \""+status+"\"; about to "+(status!="preactive"?"re-":"")+"activate and send notification email.  Okay to proceed?")) {
		alert(""+fullname+"'s account has been activated.")
		location.href="userStatus.jsp?<%=controller.getSiteIdNVPair()%>&id="+id+"&retUrl="+retUrl;
	}
}

function tabClick(tabCode) {
	if (tabCode==activeTab) {
		return;
	}
	var currentTabDiv=document.getElementById("tab"+activeTab)
	var currentContentDiv=document.getElementById("content"+activeTab)
	var newTabDiv=document.getElementById("tab"+tabCode)
	var newContentDiv=document.getElementById("content"+tabCode)
	
	currentTabDiv.style.backgroundColor="#eeeeee";
	newTabDiv.style.backgroundColor="#cccccc";
	currentContentDiv.style.display="none";
	newContentDiv.style.display="block";

	activeTab=tabCode
	
}
</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
.contentDiv {border:4px solid #cccccc; width: 700px; padding:15px;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>
<a name="top"></a>
<div id="mainDiv">

<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Here are <%=viewingUser.getFirstName()%> <%=viewingUser.getLastName()%>'s details.</span><br />
Click the appropriate tab to view the data you're looking for.<br/></span><%=HtmlUtils.doubleLB(request)%>

<script type="text/javascript">
function dataLoadDone() {
	document.getElementById("tabsAndContent").style.display="block"
	document.getElementById("loadingTabsAndContent").style.display="none"
}
</script>

<div id="loadingTabsAndContent">
<b style="color:#cc0000;">[Loading data...]</b>
</div>

<div id="tabsAndContent" style="display:none;">

<table border="0" cellspacing="0" cellpadding="0">
<tr align="center">
<%
Iterator<String> tabKeysIterator=tabCodesToLabelsMap.keySet().iterator();
String tabCode;
String tabLabel;
while (tabKeysIterator.hasNext()) {
	tabCode=tabKeysIterator.next();
	tabLabel=(String)tabCodesToLabelsMap.get(tabCode);
	%>
	<td nowrap="nowrap"><div onclick="tabClick('<%=tabCode%>')" style="cursor:pointer; padding: 2px 8px 2px 8px; background-color:#<%=activeTab.equals(tabCode)?"cccccc":"eeeeee"%>; font-size:12px; font-family:arial,helvetica; font-weight:bold;" id="tab<%=tabCode%>"><%=tabLabel%></div></td>
	<td>&nbsp;</td>
	<%
}
%>
</tr>
</table>
<div id="contentgeneral" class="contentDiv" style="display:<%=activeTab.equals("general")?"block":"none"%>">

<table border="0" cellspacing="0" cellpadding="0" width="685">
<tr valign="top">
<td class="bodyFont">
<b>Username:</b> <%=viewingUser.getUsername()%><br/>
<b>Full Name:</b> <%=viewingUser.getFirstName()%> <%=viewingUser.getLastName()%><br/>
<b>Email:</b> <a href="mailto:<%=viewingUser.getEmailAddress()%>"><%=viewingUser.getEmailAddress()%></a><br/><br/>

<b>Gender:</b> <%=viewingUser.getGender()==User.MALE?"male":"female"%><br/><br/>

<b>Emergency Contact:</b> <%=(viewingUser.getEmergencyContact()==null?"[unknown]":viewingUser.getEmergencyContact())%><br/><br/>

<b>Comments:</b> <%=(viewingUser.getCommentsUserHidden()==null || viewingUser.getCommentsUserHidden().trim().length()==0?"[none]":viewingUser.getCommentsUserHidden())%><br/><br/>

<b>Join Date:</b> <%=viewingUser.getJoinDate()!=null?dateFormat.format(viewingUser.getJoinDate()):"[unknown]"%><br/>
<b>Last Login:</b> <%=viewingUser.getJoinDate()!=null?dateTimeFormat.format(viewingUser.getLastAccessDate()):"[unknown]"%><br/><br/>
<b>Address:</b>
<%
if (userAddress==null) {
	%>[unknown]<%
}
else {
	%><br/>
	<%
	if (userAddress.getAddressLine1()!=null && userAddress.getAddressLine1().trim().length()>0) {
		%>&nbsp;&nbsp;&nbsp;&nbsp;<%=userAddress.getAddressLine1()%><br/><%
	}
	if (userAddress.getAddressLine2()!=null && userAddress.getAddressLine2().trim().length()>0) {
		%>&nbsp;&nbsp;&nbsp;&nbsp;<%=userAddress.getAddressLine2()%><br/><%
	}
	if (userAddress.getCity()!=null && userAddress.getCity().trim().length()>0) {
		%>&nbsp;&nbsp;&nbsp;&nbsp;<%=userAddress.getCity()%>, <%
	}
	if (userAddress.getStateProvinceCode()!=null && userAddress.getStateProvinceCode().trim().length()>0) {
		%><%=userAddress.getStateProvinceCode()%> <%
	}
	if (userAddress.getPostalCode()!=null && userAddress.getPostalCode().trim().length()>0) {
		%><%=userAddress.getPostalCode()%><br/><%
	}
	if (userAddress.getCountryCode()!=null && userAddress.getCountryCode().trim().length()>0) {
		%>&nbsp;&nbsp;&nbsp;&nbsp;<%=userAddress.getCountryCode()%><br/><br/><%
	}
	%>
	<b>Home Telephone:</b> <%=(userAddress.getHomeTelephone()==null?"[unknown]":userAddress.getHomeTelephone())%><br/>
	<b>Work Telephone:</b> <%=(userAddress.getWorkTelephone()==null?"[unknown]":userAddress.getWorkTelephone())%><br/>
	<b>Mobile Telephone:</b> <%=(userAddress.getMobileTelephone()==null?"[unknown]":userAddress.getMobileTelephone())%><br/>
	<%
	
	
}
%><br/><br/>

<%=HtmlUtils.smallCpFormButton(false, "edit this data", "location.href='editUser.jsp?retUrl="+URLEncoder.encode("user.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=general","UTF-8")+"&"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"'", request)%><br />
</td>
<td>
<%
Photo primaryPhoto=Photo.getPrimaryByUserId(viewingUser.getId());

if (primaryPhoto==null) {
	%><img src="../images/noUserPhoto.gif" width="250" height="300" alt="" /><%
}
else {
	%>
		<b class="bodyFont">Client's primary photo (<a href="#" onclick="tabClick('photos'); return false">see all</a>):</b><br/>
		<table border="0" cellspacing="0" cellpadding="0" style="margin-top:4px;">
		<tr>
		<td align="center" nowrap="nowrap"><img src="<%=primaryPhoto.getRelativeToRootMainURL(request)%>" height="<%=primaryPhoto.getMainHeight()%>"  width="<%=primaryPhoto.getMainWidth()%>" border="0" /></td>
		</tr>
		<tr>
		<td align="center"><div align="center"  style="margin-top:3px; font-size:11px;" class="bodyFont"><%=primaryPhoto.getCaption()%><br/>
		<i>Uploaded:<%=uploadDateFormat.format(primaryPhoto.getUploadDate())%></i><br/>
		</td>
		</tr>
		</table>
	<%
}
%>
</td>
</tr>
</table>
</div>


<div id="contentphotos" class="contentDiv" style="display:<%=activeTab.equals("photos")?"block":"none"%>">
<script>

function isValidPhotoForm(formObj)
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
	location.replace("user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>&activeTab=photos&t=<%=new Date().getTime()%>")
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
<%
List allPhotos=Photo.getByUserId(viewingUser.getId());
allPhotos=(allPhotos==null?new ArrayList():allPhotos);
if (allPhotos.size()==0) {
	%><i>This client has not uploaded any photos.</i><br/><%
}
else {
	%>
	Here are the photos this client has uploaded.<br/><br/>
	<%
}
%>

<%
boolean showAddPhotoDiv;
boolean primary;
if (allPhotos.size()==0) {
	showAddPhotoDiv=true;
	primary=true;
}
else {
	showAddPhotoDiv=false;
	primary=false;
	%>
	To upload more, click <a href="#" onclick="showAddPhotoModule(); return false">here</a>.  You can also edit or delete existing
	photos by clicking the appropriate "edit" or "delete" button below.<br/>
	<%
}

%>


<iframe style="border:0px solid #ffffff; width:1px; height:1px;" id="hiddenFrame" name="hiddenFrame" src="../global/blank.html" border="1" frameborder="1" framespacing="0"></iframe>
</span>

<div id="uploadNew" style="display:<%=showAddPhotoDiv?"block":"none"%>">
<form target="hiddenFrame" action="processPhotoUpload.jsp?<%=controller.getSiteIdNVPair()%>" method="post" enctype="multipart/form-data" onsubmit="return isValidPhotoForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="userId" value="<%=viewingUser.getId()%>" />
<input type="hidden" name="uploadingUserId" value="<%=currentUser.getId()%>" />

<input type="hidden" name="primary" value="<%=primary%>" />
You may upload photos to this client's profile in JPEG, GIF, or PNG format.  All photos will
be visible only to you (and other backend users with whom this client is shared) and to this client.  Photos may be up to 250 pixels wide (wider photos 
will be resized to 250 pixels).
Please choose a file and enter a caption for it, then press the "add" button:<br/><br/>
<span class="boldishFont">Choose a file</span><br />
<input style="width:250px;" type="file" class="inputText" name="file" id="file"  size="32"><%=HtmlUtils.doubleLB(request)%>


<span class="boldishFont">Caption</span><br />
<input style="width:250px;" type="text" class="inputText" name="caption" id="caption"><%=HtmlUtils.doubleLB(request)%>
<br />
<%=HtmlUtils.cpFormButton("add", request)%><br /><br />
</form>
</div>


<%
putPrimaryPhotoFirst(allPhotos);
Iterator p=allPhotos.iterator();
Photo photo;
while (p.hasNext()) {
	photo=(Photo)p.next();

	%>
		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td align="center" nowrap="nowrap" width="250"><img src="<%=photo.getRelativeToRootMainURL(request)%>" height="<%=photo.getMainHeight()%>"  width="<%=photo.getMainWidth()%>" border="0" /></td>
		</tr>
		<tr>
		<td align="center"><div align="center"  style="margin-top:3px; font-size:11px;" class="bodyFont"><%=photo.getCaption()%><br/>
		<i>Uploaded:<%=uploadDateFormat.format(photo.getUploadDate())%><%
		if (photo.isPrimaryPhoto()) {
			%><br/>(This is the primary photo.)<%
		}
		%></i><br/>
		
		<div style="padding-top:3px;">
		<%=HtmlUtils.smallCpFormButton(false, "edit", "location.href='editPhoto.jsp?"+controller.getSiteIdNVPair()+"&id="+photo.getId()+"'", request, 50)%>&nbsp;&nbsp;
		<%=HtmlUtils.smallCpFormButton(false, "delete", "deletePhoto("+photo.getId()+")", request, 50)%></div>
		</div></td>
		</tr>
		</table><br/><br/><br/>
	<%
}

%>
</div>



<div id="contentstatus" class="contentDiv" style="display:<%=activeTab.equals("status")?"block":"none"%>">
<b>Status:</b> <%=viewingUser.getStatusLabel()%>.<br/> <%
if (viewingUser.getStatus()==User.STATUS_PREACTIVE) {
	%>

	<%
}
else if (viewingUser.getStatus()==User.STATUS_ACTIVE) {
	%>

	<%
}
else if (viewingUser.getStatus()==User.STATUS_SUSPENDED) {
	%>

	<%
}
else if (viewingUser.getStatus()==User.STATUS_DEACTIVATED) {
	%>

	<%
}
%><br/>
<%
String onclick;
String retUrl=URLEncoder.encode(request.getContextPath()+"/kqadmin/user.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=status");
if (viewingUser.getStatus()!=User.STATUS_ACTIVE) {
	onclick="confirmActivate("+viewingUser.getId()+",'"+viewingUser.getFirstName()+" "+viewingUser.getLastName()+"',"+viewingUser.getStatus()+", '"+retUrl+"')";
}
else {
	onclick="location.href='userStatus.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&retUrl="+retUrl+"'";
}

%>
<%=HtmlUtils.smallCpFormButton(false, "change status", onclick, request)%><br />
</div>


<div id="contentbackendUsers" class="contentDiv" style="display:<%=activeTab.equals("backendUsers")?"block":"none"%>">
<%
List mappings=ClientToBackendUserMapping.getByClientUserId(viewingUser.getId());
mappings=(mappings==null?new ArrayList():mappings);
if (mappings.size()==0) {
	%>This client is currently not associated with any backend users.<%
}
else {
	%>This client is currently shared with the following backend user(s).  Un-share a backend user from this client by clicking an "un-share" link.<br/><br/><%
	User backendUser;
	ClientToBackendUserMapping mapping;
	Site site;
	it=mappings.iterator();
	while (it.hasNext()) {
		mapping=(ClientToBackendUserMapping)it.next();
		backendUser=(User)allUsersMap.get(new Integer(mapping.getBackendUserId()));
		site=(Site)allSitesMap.get(new Integer(backendUser.getSiteId()));
		%>&nbsp;&nbsp;&nbsp;&nbsp;<!-- <a href="backendUser.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=backendUser.getId()%>"> --><%=backendUser.getFirstName()%> <%=backendUser.getLastName()%><!-- </a> --> (<%=backendUser.getDefaultBackendUserTypeLabel()%>, <%=site.getLabel()%>)
		<b><%
		if (currentUser.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER) {
			%><a onclick="alert('You must be a site admin or a super admin to un-share backend users from clients.  Please speak to your site admin or super admin.'); return false;" href="#" style="color:#cc0000;">[un-share]</a><%
		}
		else {
			%><a onclick="return confirm('Are you sure you want to un-share this backend user from this client?')" href="backendUserAssignment.jsp?assign=false&<%=controller.getSiteIdNVPair()%>&backendUserId=<%=backendUser.getId()%>&clientId=<%=viewingUser.getId()%>&retUrl=<%=URLEncoder.encode("user.jsp?activeTab=backendUsers&"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId(), "UTF-8")%>" style="color:#cc0000;">[un-share]</a><%
		}
		%></b><br/>
		<%
	}
}

List allAssignableBackendUsers=User.getAllBackendUsers(true);
Collections.sort(allAssignableBackendUsers, new UserComparator(UserComparator.FIRST_NAME));
it=allAssignableBackendUsers.iterator();

%><br/><br/>
You may share this client with a new backend user by choosing one from the following list and clicking "share" (doing so will have no effect on backend users already sharing this client):<br/><br/>

<form onsubmit="return confirm('An email will be sent to this backend user telling them that you have shared this client with them.  Are you sure you want to proceed?')" action="backendUserAssignment.jsp" style="padding:0px; margin:0px; display:inline;">
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bodyFont">&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td>
<input type="hidden" name="clientId" value="<%=viewingUser.getId()%>" />
<input type="hidden" name="assign" value="true" />
<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
<input type="hidden" name="retUrl" value="<%="user.jsp?activeTab=backendUsers&"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()%>" />
<select class="selectText" name="backendUserId" style="margin-right:3px;">
<%
User assignableUser;
Site site;
while (it.hasNext()) {
	assignableUser=(User)it.next();
	site=(Site)allSitesMap.get(assignableUser.getSiteId());
	%>
	<option value="<%=assignableUser.getId()%>"><%=assignableUser.getFirstName()%> <%=assignableUser.getLastName()%> (<%=assignableUser.getDefaultBackendUserTypeLabel()%>, <%=site.getLabel()%>)</option>
	<%
}
%>
</select><br/>
</td>
<td><%=HtmlUtils.smallCpFormButton(true, "share", null, request)%><br /></td>
</tr>
</table>
</form>
</div>


<div id="contentroutines" class="contentDiv" style="display:<%=activeTab.equals("routines")?"block":"none"%>">
<script type="text/javascript">

function routineSelectChanged(selectObj) {
	var selectedValue=selectObj.options[selectObj.selectedIndex].value
	if (selectedValue!=999999) {
		location.href='user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>&activeTab=routines&maxRoutineResults='+selectedValue
	}
	else {
		window.open("workoutList.jsp?<%=controller.getSiteIdNVPair()%>&doDisplay=true&routineStatus=1&sortType=3&sortAsc=desc&maxListLength=999999&assignedToClientIdOnly=<%=viewingUser.getId()%>&assignedByBackendUserIdOnly=-1&pastDeadlineOnly=false", "allRoutines");
		selectObj.selectedIndex=0
	}
}
</script>

<%
List routines=Workout.getAdministratorAssignedByUserId(viewingUser.getId(), maxRoutineResults, true);
routines=(routines==null?new ArrayList():routines);

if (routines.size()>0) {
	%>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr valign="middle">
	<td class="bodyFont">Here are the <%=routines.size()%> most recent routines assigned to this client.  <i>See more/fewer:</i><br/>
	</td>
	<td><select style="margin-left:5px;" name="maxRoutineResults" class="selectText" onchange="routineSelectChanged(this)">
	<%
	for (int i=0; i<MAX_WORKOUT_RESULTS.length; i++) {
		%>
		<option value="<%=MAX_WORKOUT_RESULTS[i]%>" <%=MAX_WORKOUT_RESULTS[i]==maxRoutineResults?"selected=\"selected\"":""%>><%=MAX_WORKOUT_RESULTS[i]<999999?""+MAX_WORKOUT_RESULTS[i]+" most recent routines":"list all routines in a new window"%></option>
		<%
	}
	%>
	</select><br/>
	
	
	</td>
	</tr>
	</table>
	<br/>
	<%=HtmlUtils.smallCpFormButton(false, "assign new routine", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=add&assignToUserId="+viewingUser.getId()+"'", request)%><br />
	<br/>	
	<%
}
%>
<%

%>

<%
long nowTime;
Workout routine;
boolean completed;
boolean pastDue;
int c;

if (routines.size()==0) {
	%><i>No routines have been assigned to this client.</i><br/><br/>
	
	<%=HtmlUtils.smallCpFormButton(false, "assign new routine", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=add&assignToUserId="+viewingUser.getId()+"'", request)%><br />
	<%
}

else {
	it=routines.iterator();
	nowTime=new Date().getTime();
	c=1;
	while (it.hasNext()) {
		routine=(Workout)it.next();
		completed=(routine.getRecordedAsWorkoutDate()!=null);
		pastDue=(!completed && routine.getDueDate()!=null && routine.getDueDate().getTime()<nowTime);

		%>
		<div style="font-weight:bold; width:690px; padding:3px; background-color:#eeeeee;"><%=c%>. <%=routine.getName()%> <span style="font-weight:normal;"><%
		if (completed) {
			%><span style="color:#009900;">[routine is completed; <a style="color:#009900;" target="_blank" href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=routine.getSourceWorkoutId()%>">open the workout in a new window</a>]</span><%
		}
		else if (pastDue) {
			%><span style="color:#cc0000;">[routine is past-deadline; it was due on <%=workoutDateTimeFormat.format(routine.getDueDate())%>. <a style="color:#ff9900;" href="ignoreDeadline.jsp?<%=controller.getSiteIdNVPair()%>&workoutId=<%=routine.getId()%>&retUrl=<%=URLEncoder.encode("user.jsp?activeTab=routines&siteId="+controller.getSiteId()+"&id="+viewingUser.getId(), "UTF-8")%>">Ignore deadline.</a>]</span><%
		}
		else if (routine.getDueDate()!=null) {
			%><span style="color:#ff9900;">[routine is due on <%=workoutDateTimeFormat.format(routine.getDueDate())%>.]</span><%
		}
		else if (routine.getDueDate()==null) {
			%><span style="color:#ff9900;">[routine does not have a due date.]</span><%
		}
		%></span></div>
		<div style="margin:5px 0px 5px 32px;">
		<%=HtmlUtils.smallCpFormButton(false, "edit", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=edit&id="+routine.getId()+"'", request, 70)%>
		<%=HtmlUtils.smallCpFormButton(false, "copy", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=copy&id="+routine.getId()+"'", request, 70)%>
		<%=HtmlUtils.smallCpFormButton(false, "deactivate", "location.href='deactivateWorkout.jsp?"+controller.getSiteIdNVPair()+"&id="+routine.getId()+"&retUrl="+URLEncoder.encode("user.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=routines&maxRoutineResults="+maxRoutineResults+"","UTF-8")+"'", request, 70)%><br />
		</div>
		<%
		pageContext.include("showWorkoutInclude.jsp?"+controller.getSiteIdNVPair()+"&prescriptive=true&showDetails=false&showIntroText=false&showTagline=false&containInBox=false&mode=view&isPopup=false&id="+routine.getId());
		c++;
		%>
		<br/><br/>
		<%
	}
}
%>
</div>



<div id="contentworkouts" class="contentDiv" style="display:<%=activeTab.equals("workouts")?"block":"none"%>">
<script type="text/javascript">

function workoutSelectChanged(selectObj) {
	var selectedValue=selectObj.options[selectObj.selectedIndex].value
	if (selectedValue!=999999) {
		location.href='user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>&activeTab=workouts&maxWorkoutResults='+selectedValue
	}
	else {
		window.open("workoutList.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUserId%>&prescriptive=false&userIsClient=true", "allWorkouts");
		selectObj.selectedIndex=0
	}
}
</script>

<%
List workouts=Workout.getUserCreated(viewingUser.getId(), false, maxWorkoutResults);
if (workouts!=null && workouts.size()>0) {
	%>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr valign="middle">
	<td class="bodyFont">Here are the <%=workouts.size()%> most recent workouts stored by this client.  <i>See more/fewer:</i><br/>
	</td>
	<td><select style="margin-left:5px;" name="maxWorkoutResults" class="selectText" onchange="workoutSelectChanged(this)">
	<%
	for (int i=0; i<MAX_WORKOUT_RESULTS.length; i++) {
		if (MAX_WORKOUT_RESULTS[i]==999999) {
			// for now:
			break;
		}
		%>
		<option value="<%=MAX_WORKOUT_RESULTS[i]%>" <%=MAX_WORKOUT_RESULTS[i]==maxWorkoutResults?"selected=\"selected\"":""%>><%=MAX_WORKOUT_RESULTS[i]<999999?""+MAX_WORKOUT_RESULTS[i]+" most recent workouts":"list all workouts in a new window"%></option>
		<%
	}
	%>
	</select><br/>
	
	
	</td>
	</tr>
	</table>
	<br/><%
}
%>

<%

if (workouts==null) {
	%><i>This client has not stored any workouts.</i><%
}

else {
	it=workouts.iterator();
	nowTime=new Date().getTime();
	Workout workout;
	Workout sourceRoutine;
	String sourceRoutineNote;
	
	c=1;
	while (it.hasNext()) {
		workout=(Workout)it.next();
		sourceRoutineNote="";
		if (workout.getSourceWorkoutId()>0) {
			sourceRoutine=Workout.getById(workout.getSourceWorkoutId());
			if (sourceRoutine!=null) {
				sourceRoutineNote="[stored from the <a target=\"_blank\" href=\"showWorkout.jsp?"+controller.getSiteIdNVPair()+"&id="+sourceRoutine.getId()+"\">"+sourceRoutine.getName()+"</a> routine]";
			}
		}
		%>
		<div style="font-weight:bold; width:690px; padding:3px; background-color:#eeeeee;"><%=c%>. <%=workoutDateFormat.format(workout.getPerformedDate())%> <span style="font-weight:normal;"><%=sourceRoutineNote%></span><%
		/*
		if (completed) {
			%><span style="color:#00cc00;">[routine is completed; <a target="_blank" href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=completedWorkout.getId()%>">open the workout in a new window</a>]</span><%
		}
		*/
	
		%></div>
		<%
		pageContext.include("showWorkoutInclude.jsp?"+controller.getSiteIdNVPair()+"&prescriptive=false&showDetails=false&showIntroText=false&showTagline=false&containInBox=false&mode=view&isPopup=false&id="+workout.getId());
		c++;
		%>
		<br/><br/>
		<%
	}
}
%>

</div>











<%

boolean advancedViewMode=controller.getParamAsBoolean("advancedViewMode", true);




//note: list will always contain at least two elements (last week and this week); note also that weeks which are not assocaited with any actual user entries are not included:
List weeks=CalorieWeek.getAllByUserId(viewingUser.getId(), true);

int weekId;
try {
	weekId=Integer.parseInt(request.getParameter("weekId"));
}
catch (RuntimeException e) {
	weekId=((CalorieWeek)weeks.get(weeks.size()-1)).getId();
}

int dayIndex;
boolean dayIndexSpecified=false;
try {
	dayIndex=Integer.parseInt(request.getParameter("dayIndex"));
	dayIndexSpecified=true;
}
catch (RuntimeException e) {
	dayIndex=0;
}

int numWeeks=weeks.size();
CalorieWeek week;
String label;
DateFormat dateFormat=new SimpleDateFormat("MMMM dd, yyyy");
Calendar startDate;
Calendar endDate;
boolean thisWeek=false;

%>

<script type="text/javascript">

var advancedViewMode=<%=advancedViewMode%>



function getWeek(selectMenu) {
	location.href="user.jsp?activeTab=calories&id=<%=viewingUser.getId()%>&advancedViewMode=true&<%=controller.getSiteIdNVPair()%>&viewUserId=<%=viewingUserId%>&weekId="+selectMenu.options[selectMenu.selectedIndex].value;
}

function changeDay(dayIndex) {
	window.frames.weeksheet.location.href="spreadsheetFrame.jsp?allowViewModeChange=false&advancedViewMode=true&<%=controller.getSiteIdNVPair()%>&viewUserId=<%=viewingUser.getId()%>&dayIndex="+dayIndex+"&weekId=<%=weekId%>";

}
</script>


<div id="contentcalories" class="contentDiv" style="width:904px; display:<%=activeTab.equals("calories")?"block":"none"%>">
This table depicts this client's calories ingested and calories expended.  Calories ingested are
entered by clients in their "What'd You Eat?" screen (with calorie and other 
nutrition information coming from the CalorieKing database).  Calories expended
are calculated by the site automatically when the client saves a workout.<br/><br/>
<div style="xborder:1px solid #cccccc; xbackground-color:#dddddd; xpadding:1px; width:904px;overflow:visible;">
<table  bgcolor="#eeeeee" border="0" cellspacing="0" cellpadding="3" style="margin-bottom:3px;">
<form action="#" onsubmit="return false">
<tr>
<td nowrap="nowrap">
<span class="bodyFont"><i>Choose&nbsp;a&nbsp;week:</i></span><br />
</td>
<td><select  class="selectText" style="font-size:11px;" name="weekId" onchange="getWeek(this)">

<%
for (int i=0; i<numWeeks; i++) {
	week=(CalorieWeek)weeks.get(i);
	if (i==numWeeks-1) {
		label="This week";
		thisWeek=(weekId==week.getId());
	}
	else if (i==numWeeks-2) {
		label="Last week";
	}
	else {
		startDate=new GregorianCalendar(week.getStartDateYear(), week.getStartDateMonth(), week.getStartDateDate());
		endDate=new GregorianCalendar();
		endDate.setTime(startDate.getTime());
		endDate.add(Calendar.DATE, 6);
		label=dateFormat.format(startDate.getTime())+" - "+dateFormat.format(endDate.getTime());
	}
	%>
	<option value="<%=week.getId()%>" <%=(weekId==week.getId()?" selected ":"")%>><%=label%></option>
	<%
}

if (thisWeek) {
	// if the week is this week, we want the day index to be today if one wasn't specified:
	if (!dayIndexSpecified) {
		Calendar now=new GregorianCalendar();
		dayIndex=now.get(Calendar.DAY_OF_WEEK)-1;
	}
}
%>


</select>
</td>
</tr>
</table>


<iframe src="../workouts/spreadsheetFrame.jsp?allowViewModeChange=false&advancedViewMode=true&<%=controller.getSiteIdNVPair()%>&viewUserId=<%=viewingUserId%>&weekId=<%=weekId%>&dayIndex=<%=dayIndex%>" style="xborder:1px solid #cccccc;" name="weeksheet" id="weeksheet" width="900" height="508"  marginwidth="0" marginheight="0" topmargin="0" leftmargin="0" scrolling="auto" frameborder="0"></iframe>
</div>
</div>



<div id="contentpfd" class="contentDiv" style="display:<%=activeTab.equals("pfd")?"block":"none"%>">

<script>
function toggleCurrentHistorical(showHistorical) {
	document.getElementById("contentpfdCurrent").style.display=(showHistorical?"none":"block")
	document.getElementById("contentpfdHistorical").style.display=(!showHistorical?"none":"block")
}

function switchPfdSection(code) {
	var codes=["Current","Comments","Historical"]
	for (var i=0; i<codes.length; i++) {
		document.getElementById("contentpfd"+codes[i]).style.display=(code==codes[i]?"block":"none")
	}
}
</script>
<div id="contentpfdCurrent" style="display:<%=activePfdTab.equals("Current")?"block":"none"%>;">
<%=getPfdSectionLinks("Current")%><br/>
<%
boolean hasCurrentItems=com.theavocadopapers.apps.kqool.pfd.CurrentPfdData.isCurrentPfdDataExists(viewingUser.getId());
List historicalPfdItems=com.theavocadopapers.apps.kqool.entity.PfdItem.getHistoricalByUserId(viewingUser.getId());
boolean hasHistoricalItems=(historicalPfdItems!=null && historicalPfdItems.size()>0);

PfdProperties pfdProps=new PfdProperties();
if (hasHistoricalItems) {
	Collections.sort(historicalPfdItems);
	Collections.reverse(historicalPfdItems);
}
if (!hasCurrentItems) {
	%>
	This client has not filled out a personal-fitness-data form.  To send this client
	mail asking them to fill one out, go <a href="pfpRequestDetails.jsp?preChosenUser=true&<%=controller.getSiteIdNVPair()%>&userId=<%=viewingUser.getId()%>">here</a>.
	You can also fill out a this client's personal-fitness-data form yourself <a href="pfdEdit.jsp?noCurrentData=true&<%=controller.getSiteIdNVPair()%>&userId=<%=viewingUser.getId()%>&retUrl=<%=URLEncoder.encode(controller.getPathToAppRoot()+"kqadmin/user.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=pfd", "UTF-8")%>">here</a>.<br/>
	<%
}
else {
	%>
	Here is this client's current personal fitness data.  
	This data was initially entered
	by the client, but it may have been changed since then, either by a backend user or by
	the client.  (Click the "Historical Data" tab for older data.)  
	All of this data is visible to the client.  You may also add a comment to this client's
	fitness profile, or view comments that you or other backend users have added, by clicking the 
	"Comments" tab (unlike fitness data, comments are not visible to clients).<br/><br/>
	To make changes to the data below,
	<a href="pfdEdit.jsp?<%=controller.getSiteIdNVPair()%>&userId=<%=viewingUser.getId()%>&retUrl=<%=URLEncoder.encode(controller.getPathToAppRoot()+"kqadmin/user.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=pfd", "UTF-8")%>">click here</a>.<br/><br/>
	<%
	
	request.setAttribute("controller", controller);
	request.setAttribute("user", viewingUser);
	request.setAttribute("tagline", null);
	request.setAttribute("introText", null);
	request.setAttribute("highlightTrueMedicalConditionBooleans", new Boolean(true));
	
	

	pageContext.include("../global/viewPfd.jsp");

}

%>
<!--  	<%=HtmlUtils.smallCpFormButton(false, "edit this data", "location.href='pfdEdit.jsp?"+controller.getSiteIdNVPair()+"&userId="+viewingUser.getId()+"&retUrl="+URLEncoder.encode(controller.getPathToAppRoot()+"kqadmin/user.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=pfd", "UTF-8")+"'", request)%>
-->

<%
List currentComments=PfdComment.getByUserId(viewingUserId);
%>
<br/>
<br/>

<%
if (currentComments==null || currentComments.size()==0) {
	// nothing
}
else {
	Collections.sort(currentComments); // sort by date
	Collections.reverse(currentComments); // make them descending by date
}
%><br/><br/>
<script>

function isValidCommentForm(formObj) {
	var commentsTextarea=formObj.elements["newComment"]
	if (commentsTextarea.value=="") {
		errorAlert("You haven't entered anything in the comments box.  Please fix and try again.");
		commentsTextarea.focus()
		return false
	}
	return true
}
</script>

</div>
<div id="contentpfdHistorical" style="display:<%=activePfdTab.equals("Historical")?"block":"none"%>;">
<%=getPfdSectionLinks("Historical")%><br/>
Following are changes made to this client's personal-fitness data by either the client
or a backend user (most recent changes are at the top of the list).<br/>
<br/>
<%
if (historicalPfdItems!=null) {
	Iterator histItemsIt=historicalPfdItems.iterator();
	PfdItem pfdItem;
	User changingUser;
	boolean isClient;
	String question;
	String value;
	String subsequentValue;
	Map optionsItemValueLabelMap;
	while (histItemsIt.hasNext()) {
		pfdItem=(PfdItem)histItemsIt.next();
		changingUser=(User)allUsersMap.get(new Integer(pfdItem.getSettingUserId()));
		isClient=changingUser.getId()==viewingUser.getId();
		// handle height as a special case; it's the only field that has two values:
		if (pfdItem.getCode().equals("heightFeet")) {
			question="What is your height? (feet)";
		}
		else if (pfdItem.getCode().equals("heightInches")) {
			question="What is your height? (inches)";
		}
		else {
			question=pfdProps.getQuestion(pfdItem.getCode());
		}
		while (question.endsWith(".")) {
			question=question.substring(0, question.length()-1);
		}
		value=pfdItem.getValue();
		subsequentValue=pfdItem.getSubsequentValue();
		if (value!=null) {
			if (value.equals("true")) {
				value="Yes";
			}
			else if (value.equals("false")) {
				value="No";
			}
			else {
				optionsItemValueLabelMap=pfdProps.getOptionsItemValueLabelMap(pfdItem.getCode());
				if (optionsItemValueLabelMap!=null) {
					String temp=(String)optionsItemValueLabelMap.get(value);
					if (temp!=null) {
						value=temp;
					}
				}
			}
		}
		if (subsequentValue!=null) {
			if (subsequentValue.equals("true")) {
				subsequentValue="Yes";
			}
			else if (subsequentValue.equals("false")) { 
				subsequentValue="No";
			}
			else {
				optionsItemValueLabelMap=pfdProps.getOptionsItemValueLabelMap(pfdItem.getCode());
				if (optionsItemValueLabelMap!=null) {
					String temp=(String)optionsItemValueLabelMap.get(subsequentValue);
					if (temp!=null) {
						subsequentValue=temp;
					}
				}
			}
		}


		%>
		<div style="margin-bottom:10px;">
		<i><%=dateFormat.format(pfdItem.getCreateDate())%>:</i> <%=changingUser.getFirstName()%> <%=changingUser.getLastName()%> 
		set <b><%=question%></b> to 
		<b><%=subsequentValue%></b> (previous value: <b><%=value%></b>).
		</div>
		<%
	}
	%>
	<br/>
	<%
}
else {
	%><i>(No historical data found.)</i><%
}
%>

</div>

<script>
function showAddACommentForm() {
	document.getElementById("showAddACommentLink").style.display="none"
	document.getElementById("addAComment").style.display="block"
}
</script>

<div id="contentpfdComments" style="display:<%=activePfdTab.equals("Comments")?"block":"none"%>;">
<%=getPfdSectionLinks("Comments")%><br/>
<%
if (currentComments!=null) {
	%>
	Here are comments regarding this client added by backend users.
	These comments are not visible to the client.
	<%
}
else {
	%>
	No comments regarding this client have been added by backend users.
	<%
}
%><br/><br/>
<div id="showAddACommentLink"><i><a href="#" onclick="showAddACommentForm(); return false;">Add a comment...</a></i><br/><br/></div>
<div id="addAComment" style="display:none;"><i>Add a comment...</i><br/><br/>

<form style="margin:0px; padding:0px;" action="processNewComment.jsp" onsubmit="return isValidCommentForm(this)" method="post">
<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
<input type="hidden" name="userId" value="<%=viewingUser.getId()%>" />
<input type="hidden" name="commentingUserId" value="<%=currentUser.getId()%>" />
<input type="hidden" name="retUrl" value="user.jsp?siteId=<%=controller.getSiteId()%>&id=<%=viewingUser.getId()%>&activeTab=pfd&activePfdTab=Comments#comments" />
<b>Your comment:</b><br/>
<textarea class="inputText" name="newComment" id="newComment" style="width:350px; height:120px;" rows="10" cols="10"></textarea><br/>
<br/>
<%=HtmlUtils.smallCpFormButton("add comment", request)%><br /><br />
</form>
</div>
</blockquote>
<%
if (currentComments!=null && currentComments.size()>0) {
	Iterator commentsIt=currentComments.iterator();
	PfdComment pfdComment;
	User commentingUser;
	while (commentsIt.hasNext()) {
		pfdComment=(PfdComment)commentsIt.next();
		commentingUser=(User)allUsersMap.get(new Integer(pfdComment.getCommentingUserId()));
		%>
		<i>Added by <%=commentingUser.getFirstName()%> <%=commentingUser.getLastName()%> on <%=genericDateFormat.format(pfdComment.getCreateDate())%>:</i><br/>
		<%=pfdComment.getCommentText()%><br/><br/>
		<%
	}
}
%>

</div>
</div>
<div id="contentnutrition" class="contentDiv" style="display:<%=activeTab.equals("nutrition")?"block":"none"%>">
Nutritionist screen not implemented yet.
</div>
</div><!-- end tabsAndContent div -->

<script type="text/javascript">
// show the tabs and content divs:
dataLoadDone()
</script>

<br />


<%=HtmlUtils.doubleLB(request)%><br />
</font>


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

