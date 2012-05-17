<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
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

static String[] PFD_SECTION_CODES={"Current","Comments","Historical","Photos"};
static String[] PFD_SECTION_LINK_LABELS={"Current&nbsp;Data","Comments","Historical&nbsp;Data","Photos"};

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
Address userAddress=Address.getByUserId(viewingUser.getId());

NutritionPlan nutritionPlan;
nutritionPlan = NutritionPlan.getByUserId(viewingUser.getId());
if (nutritionPlan == null) { 
    nutritionPlan = new NutritionPlan();
}

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


//We deal with all photos here -- client-uploaded and backend-user-
//uploaded (the BE-user photos appear under the "fitness data" tab,
//while client-uploaded photos appear under the "photos" tab).
List allPhotos=Photo.getByUserId(viewingUser.getId());
allPhotos=(allPhotos==null?new ArrayList():allPhotos);
List clientPhotos=new ArrayList(allPhotos.size());
List backendUserPhotos=new ArrayList(allPhotos.size());

for (Object photo: allPhotos) {
	if (((Photo)photo).getUserId()==((Photo)photo).getUploadingUserId()) {
		clientPhotos.add(photo);
	}
	else {
		backendUserPhotos.add(photo);
	}
}




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


// Photo stuff:
	
	
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
	location.replace("user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>&activeTab=pfd&activePfdTab=Photos&t=<%=new Date().getTime()%>")
}

// called from hidden iframe when img successfully uploaded:
function photoUploadWrongFormat(filenameExt) {
	var fmt=(filenameExt.length>0?filenameExt.toUpperCase():"an unknown")
	alert("Sorry, your photo must be in either JPEG, GIF, or PNG format; the file you uploaded is in "+fmt+" format.  Please try again.")	
}





function showAddPhotoModule(divId) {
	document.getElementById(divId).style.display="block"
}


function deletePhoto(id) {
	if (confirm("Are you sure you want to delete this photo?")) {
		location.href="deletePhoto.jsp?<%=controller.getSiteIdNVPair()%>&id="+id
	}
}
	

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
	if(tabCode=="nutrition"){
		callCalendar();
	}
	
}

function gup(name){
		
	  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
	  var regexS = "[\\?&]"+name+"=([^&#]*)";
	  var regex = new RegExp( regexS );
	  var results = regex.exec( window.location.href );
	  if( results == null )
	    return "";
	  else
	    return results[1];
	}

function callCalendar(){
	urldate = gup('uDate');
		if(urldate == ""){
			displayDates(new Date());
		}else {
			displayDates(new Date(urldate));
		}
		//document.getElementById("mealMenuDropDown").style.visibility = 'hidden'; 
		//document.getElementById("mealMenuTxt").style.visibility = 'hidden'; 
		//document.getElementById("mealMenuSubmit").style.visibility = 'hidden'; 
		//displayMealMenuTxt("select");
		
		clkDate= document.getElementById('slcDay');//gup('slcDay');
		if(clkDate.value!=""){
			document.getElementById("mealMenuDropDown").style.visibility = 'visible';
		}
}

</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
.contentDiv {border:4px solid #cccccc; width: 700px; padding:15px;}
#leftLink{float:left;}
#contentnutrition{
display:block;
width:1000px;
}
#rightLink{float:right;}
a:link {
text-decoration: none;
COLOR:white;
background-color:#A5A5A5;
}
a:visited {
COLOR:white;
background-color:#A5A5A5;
}
a:target{
COLOR:white;
}
a:hover {
text-decoration: none;
COLOR: white;
background-color:#878787;
}
a:active {
COLOR: white;
background-color:#A5A5A5;
}
a{
text-decoration: none;
color:black;
font-size:13px;
font-weight:bold
}

#testId{
background-color:;
}

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>
<a name="top"></a>
<div id="mainDiv">

<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Here are <%=viewingUser.getFormattedNameAndUsername()%>'s details.</span><br />
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

<table border="0" cellspacing="0" cellpadding="0" width="100%">
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
		<span class="bodyFont">Client's primary photo:</span><br/>
		<table border="0" cellspacing="0" cellpadding="0" style="margin-top:4px;">
		<tr>
		<td align="center" nowrap="nowrap"><img src="<%=primaryPhoto.getRelativeToRootMainURL(request)%>" height="<%=primaryPhoto.getMainHeight()%>"  width="<%=primaryPhoto.getMainWidth()%>" border="0" /></td>
		</tr>
		<tr>
		<td align="center"><div align="center"  style="margin-top:3px; font-size:11px;" class="bodyFont"> (<a href="#" onclick="tabClick('photos'); return false">see all</a> client-uploaded photos, or<br/>
		all <a href="user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>&activeTab=pfd&activePfdTab=Photos">backend-user-uploaded photos</a>)<br/>
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
<%
if (clientPhotos.size()==0) {
	%><i>This client has not uploaded any photos.</i>   (Go <a href="user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>&activeTab=pfd&activePfdTab=Photos">here</a> to see 
	photos uploaded by you or other backend users.)<br/><%
}
else {
	%>
	Here are the photos this client has uploaded.  (Go <a href="user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>&activeTab=pfd&activePfdTab=Photos">here</a> to see 
	photos uploaded by you or other backend users.)<br/><br/>
	<%
}
%>

<%

boolean primary;
if (clientPhotos.size()==0) {
	primary=true;
}
else {
	primary=false;
}

%>


</span>


<%
putPrimaryPhotoFirst(clientPhotos);
Iterator p=clientPhotos.iterator();
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
		%></i><br/></td>
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
	onclick="confirmActivate("+viewingUser.getId()+",'"+viewingUser.getFormattedNameAndUsername()+"',"+viewingUser.getStatus()+", '"+retUrl+"')";
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
		%>&nbsp;&nbsp;&nbsp;&nbsp;<!-- <a href="backendUser.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=backendUser.getId()%>"> --><%=backendUser.getFormattedNameAndUsername()%><!-- </a> --> (<%=backendUser.getDefaultBackendUserTypeLabel()%>, <%=site.getLabel()%>)
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
	<option value="<%=assignableUser.getId()%>"><%=assignableUser.getFormattedNameAndUsername()%> (<%=assignableUser.getDefaultBackendUserTypeLabel()%>, <%=site.getLabel()%>)</option>
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
			Workout workoutStoredFromRoutine=Workout.getBySourceWorkoutId(routine.getId());
			int workoutStoredFromRoutineId=workoutStoredFromRoutine.getId();
			%><span style="color:#009900;">[routine is completed; <a style="color:#009900;" target="_blank" href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=workoutStoredFromRoutineId%>">open the workout in a new window</a>]</span><%
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
	window.frames["weeksheet"].location.replace("../workouts/spreadsheetFrame.jsp?allowViewModeChange=false&advancedViewMode=true&siteId=<%=controller.getSiteId()%>&viewUserId=<%=viewingUser.getId()%>&weekId="+selectMenu.options[selectMenu.selectedIndex].value+"&dayIndex=0");
}

function changeDay(dayIndex) {
	window.frames.weeksheet.location.replace("../workouts/spreadsheetFrame.jsp?allowViewModeChange=false&advancedViewMode=true&<%=controller.getSiteIdNVPair()%>&viewUserId=<%=viewingUser.getId()%>&dayIndex="+dayIndex+"&weekId=<%=weekId%>");

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
	var codes=["Current","Comments","Historical","Photos"]
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
		<i><%=dateFormat.format(pfdItem.getCreateDate())%>:</i> <%=changingUser.getFormattedNameAndUsername()%> 
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

<div id="contentpfdPhotos" style="display:<%=activePfdTab.equals("Photos")?"block":"none"%>;">
<%=getPfdSectionLinks("Photos")%><br/>
<%
if (backendUserPhotos.size()==0) {
	%><i>No backend users have uploaded photos of this user.</i>  (Go <a href="#" onclick="tabClick('photos'); return false">here</a> to see 
	photos uploaded by the client.)<br/><%
}
else {
	%>
	Here are the photos backend users have uploaded.  (Go <a href="#" onclick="tabClick('photos'); return false">here</a> to see 
	photos uploaded by the client.)<br/><br/>
	<%
}
%>

<%
boolean showAddPhotoDiv;

if (backendUserPhotos.size()==0) {
	showAddPhotoDiv=true;
}
else {
	showAddPhotoDiv=false;
	%>
	To upload more, click <a href="#" onclick="showAddPhotoModule('uploadNew'); return false">here</a>.  You can also edit or delete existing
	photos by clicking the appropriate "edit" or "delete" button below.<br/>
	<%
}

%>
</form>

<iframe style="border:0px solid #ffffff; width:1px; height:1px;" id="hiddenFrame" name="hiddenFrame" src="../global/blank.html" border="1" frameborder="1" framespacing="0"></iframe>
</span>

<div id="uploadNew" style="display:<%=showAddPhotoDiv?"block":"none"%>">
<form target="hiddenFrame" action="processPhotoUpload.jsp?<%=controller.getSiteIdNVPair()%>" method="post" enctype="multipart/form-data" onsubmit="return isValidPhotoForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="userId" value="<%=viewingUser.getId()%>" />
<input type="hidden" name="uploadingUserId" value="<%=currentUser.getId()%>" />

<input type="hidden" name="primary" value="false" />
You may upload photos to this client's profile in JPEG, GIF, or PNG format.  All photos will
be visible only to you (and other backend users with whom this client is shared), <i>not
to the client</i>.  Photos may be up to 250 pixels wide (wider photos 
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
p=backendUserPhotos.iterator();

while (p.hasNext()) {
	photo=(Photo)p.next();

	%>
		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td align="center" nowrap="nowrap" width="250"><img src="<%=photo.getRelativeToRootMainURL(request)%>" height="<%=photo.getMainHeight()%>"  width="<%=photo.getMainWidth()%>" border="0" /></td>
		</tr>
		<tr>
		<td align="center"><div align="center"  style="margin-top:3px; font-size:11px;" class="bodyFont"><%=photo.getCaption()%><br/>
		<i>Uploaded:<%=uploadDateFormat.format(photo.getUploadDate())%></i><br/>
		
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

<script>
function showAddACommentForm() {
	document.getElementById("showAddACommentLink").style.display="none"
	document.getElementById("addAComment").style.display="block"
}
</script>

<script>
	
	function leapYear(year) {
		if (year % 4 == 0) // basic rule
		return true // is leap year
		
		return false // is not leap year
	}
	
	
	
	function getMonthDays(month, year) {

		var ar = new Array(12)
		ar[0] = 31 // January
		ar[1] = (leapYear(year)) ? 29 : 28 // February
		ar[2] = 31 // March
		ar[3] = 30 // April
		ar[4] = 31 // May
		ar[5] = 30 // June
		ar[6] = 31 // July
		ar[7] = 31 // August
		ar[8] = 30 // September
		ar[9] = 31 // October
		ar[10] = 30 // November
		ar[11] = 31 // December
		
		return ar[month]
	}
	
	function subtractFromDate(dateObj,num) {
		var varDate = dateObj.getDate() - num;
		var varMonth = dateObj.getMonth();
		var varYear = 0;
		if((dateObj.getMonth()==0) && (varDate < 0)){
			varYear = dateObj.getFullYear() - 1;
		}else {
			varYear = dateObj.getFullYear();
		}
		if(dateObj.getDate() == 0){
			prevMonth = getMonthDays(varMonth-1,varYear);
			varDate = prevMonth + varDate;
			varMonth = varMonth - 1;
		}
		newDateObj = new Date(varYear,varMonth,varDate);
		return newDateObj;
	}
	
	function addToDate(dateObj,num) {
		var varDate = dateObj.getDate() + num;
		var varMonth = dateObj.getMonth();
		var varYear = 0;
		var numOfDays = getMonthDays(dateObj.getMonth(),dateObj.getFullYear());
		if((dateObj.getMonth() == 11) && (varDate > numOfDays)){
			varYear = dateObj.getFullYear() - 1;
			varMonth = 0;
		}else {
			if(varDate > numOfDays){
				varMonth = varMonth + 1;
			}
			varYear = dateObj.getFullYear();
		}
		if(numOfDays < varDate){
			varDate = varDate - numOfDays;
		}
		newDateObj = new Date(varYear,varMonth,varDate);
		return newDateObj;
	}
	
	function getMonthName(month) {
		// create array to hold name of each month
		var ar = new Array(12)
		ar[0] = "January"
		ar[1] = "February"
		ar[2] = "March"
		ar[3] = "April"
		ar[4] = "May"
		ar[5] = "June"
		ar[6] = "July"
		ar[7] = "August"
		ar[8] = "September"
		ar[9] = "October"
		ar[10] = "November"
		ar[11] = "December"
		
		// return name of specified month (parameter)
		return ar[month]
	}
	
	function createDaysOfWeek(fd,ld){
		var ar = new Array(7);
		var dl = fd.getDate();
		var dr = ld.getDate();
		var temp = dl;
		if(dr > dl){
			for(var i = 0; i < 7; i++){
				ar[i] = temp + ' ' + getMonthName(fd.getMonth());
				temp = temp + 1;
			}
		}else {
			var ml = getMonthDays(fd.getMonth(),fd.getFullYear());
			for(var i = 0 ; i <= (ml - dl);i++){
				ar[i] = temp + ' ' + getMonthName(fd.getMonth());
				temp = temp + 1;
			}
			temp = 1;
			for(var j = (ml - dl)+1; j < 7; j++){
				ar[j] = temp + '-' + getMonthName(ld.getMonth());
				temp = temp + 1;
			}
		}
		return ar;
	}
	
	
	
	
	
	
	function createCal(sd,ed){
		var daysArray = createDaysOfWeek(sd,ed);
 		urldate = gup('uDate');
 		valueOfDay = document.getElementById('slcDay')//gup('slcDay');
 		var year=sd.getFullYear();
 		var contextValue='<%=request.getContextPath()%>';
 		var HTMLTable = '<table><tr>';
 		if(valueOfDay.value == 0){
		 	HTMLTable = '<table><tr><td id="testId" width="125" align="center" color="white" bgcolor="#A5A5A5"><a id="0" href="#" onClick="togglehide(0)">Sunday -'+daysArray[0]+'</a></td>';
		 }else{
		 	HTMLTable = '<table><tr><td width="125" align="center" bgcolor="#A5A5A5" color="white"><a id="0" href="#" onClick="togglehide(0)">Sunday -'+daysArray[0]+'</a></td>';
		 }
		HTMLTable = HTMLTable + '&nbsp;';
		
		if(valueOfDay.value == 1){
	   		 HTMLTable = HTMLTable + '<td id="testId" width="125" align="center"><a id="testId" href="#" onClick="togglehide(1)">Monday -'+daysArray[1]+'</a></td><td width="1%">&nbsp;</td>';
	   	}else{
	   	 	HTMLTable = HTMLTable + '<td width="125" align="center" bgcolor="#A5A5A5" ><a id="1" href="#" onClick="togglehide(1)">Monday -'+daysArray[1]+'</a></td><td width="1%">&nbsp;</td>';
	   	}
	   	
	   	if(valueOfDay.value == 2){
			HTMLTable = HTMLTable + '<td id="testId" width="125" align="center"><a id="testId" href="#" onClick="togglehide(2)">Tuesday -'+daysArray[2]+'</a></td>';
		}else{
			HTMLTable = HTMLTable + '<td width="125" align="center" bgcolor="#A5A5A5" ><a id="2" href="#" onClick="togglehide(2)">Tuesday -'+daysArray[2]+'</a></td>';
		}
		
		if(valueOfDay.value == 3){
	   		 HTMLTable = HTMLTable + '<td  width="1%">&nbsp;</td><td id="testId" width="125" align="center"><a id="testId" href="#" onClick="togglehide(3)">Wednesday-'+daysArray[3]+'</a></td>';
	   	}else{
	   	 HTMLTable = HTMLTable + '<td width="1%">&nbsp;</td><td  width="125" align="center" bgcolor="#A5A5A5" ><a id="3" href="#" onClick="togglehide(3)">Wednesday-'+daysArray[3]+'</a></td>';
	   	}
	   	
	   	if(valueOfDay.value == 4){
	    	HTMLTable = HTMLTable + '<td width="1%">&nbsp;</td><td id="testId" width="125" align="center" ><a id="testId" href="#" onClick="togglehide(4)">Thursday -'+daysArray[4]+'</a></td>';
	    }else{
	    	HTMLTable = HTMLTable + '<td width="1%">&nbsp;</td><td width="125" align="center" bgcolor="#A5A5A5" ><a id="4" href="#" onClick="togglehide(4)">Thursday -'+daysArray[4]+'</a></td>';
	    }
	    
	    if(valueOfDay.value == 5){
	    	HTMLTable = HTMLTable + '<td width="1%">&nbsp;</td><td id="testId" width="125" align="center"><a id="testId" href="#" onClick="togglehide(5)">Friday -'+daysArray[5]+'</a></td>';
	    }else{
	    	HTMLTable = HTMLTable + '<td width="1%">&nbsp;</td><td width="125" align="center" bgcolor="#A5A5A5"><a id="5" href="#" onClick="togglehide(5)">Friday -'+daysArray[5]+'</a></td>';
	    }
	    
	    if(valueOfDay == 6){
			HTMLTable = HTMLTable + '<td width="1%">&nbsp;</td><td id="testId" width="125" align="center" ><a id="testId" href="#" onClick="togglehide(6)">Saturday -'+daysArray[6]+'</a></td></tr><tr>';
		}else{
			HTMLTable = HTMLTable + '<td width="1%">&nbsp;</td><td width="125" align="center" bgcolor="#A5A5A5" ><a id="6" href="#" onClick="togglehide(6)">Saturday -'+daysArray[6]+'</a></td></tr><tr>';
		}

		

	    HTMLTable = HTMLTable + '</table>';
		
		return HTMLTable;
	}
	
	
	
	function togglehide(tag) {
		switch(tag){
			case 0:
			 		document.getElementById('activeTab').value="nutrition"
			 		document.getElementById('slcDay').value = 0;
			 		break;
			 
			 case 1:
			 		document.getElementById('activeTab').value="nutrition"
			 		document.getElementById('slcDay').value = 1;
			 		break;
			 		
			 case 2:
			 		document.getElementById('activeTab').value="nutrition"
			 		document.getElementById('slcDay').value = 2;
			 		break;
			 
			  case 3:
			 		document.getElementById('activeTab').value="nutrition"
			 		document.getElementById('slcDay').value = 3;
			 		break;
			 		
			 case 4:
			 		document.getElementById('activeTab').value="nutrition"
			 		document.getElementById('slcDay').value = 4;
			 		break;
			 		
			 case 5:
			 		document.getElementById('activeTab').value="nutrition"
			 		document.getElementById('slcDay').value = 5;
			 		break;
			 		
			 case 6:
			 		document.getElementById('activeTab').value="nutrition"
			 		document.getElementById('slcDay').value = 6;
			 		break;
		}
	}
	
	function getSelectedDate(sd,ed){
		var daysArray = new Array(7);
		var curDate;
		k=sd;
		for(var i=0;i<7;i++){
			daysArray[i]=k;
			k=addToDate(k,1);
		}	
		valueOfDay = document.getElementById('slcDay');	//gup('slcDay');
		//alert(valueOfDay.value);	
		for( var i = 0; i< 7 ; i++){
			if(valueOfDay.value!=""){
				if(valueOfDay.value==i){
					curDate=new Date(daysArray[i].toString());
				}
			}
		}
		
		date=curDate.getDate();
		month=curDate.getMonth()+1;
		year=curDate.getFullYear();
		var DATETable ='<input type="hidden" id="selected_date" name="selected_date" value='+year+"-"+month+"-"+date+'></input>';
			DATETable = DATETable + '<input type="hidden" id="selected_day" name="selected_day" value='+ valueOfDay +'></input>';
		return DATETable;
	}
	
	function createLink(dObj,flag){
		
	    var date = dObj.getDate()+1;
	    var year = dObj.getFullYear();
	    var month = dObj.getMonth()+1;
	    
	    var dateString = new String(month+"/"+date+"/"+year);
	    var contextValue='<%=request.getContextPath()%>';
	    var linkHTML= '<a href="'+contextValue+'/kqadmin/user.jsp?siteId=1&id=483&uDate='+ dateString +'&activeTab=nutrition " onclick="'+tabClick('nutrition')+'">'; 
		if(flag) {
			linkHTML ='<div id="leftLink">' + linkHTML + '<<</a></div>';		
		}else {
			linkHTML = '<div id="rightLink">' + linkHTML + '>></a></div>';			
		}
		
		return linkHTML;
	}
	
	
	
	function displayDates(d){
		
	    var curDate=d.getDate();
	    var curDay=d.getDay();
	    var firstDate=new Date(d.toString());
	    var lastDate=new Date(d.toString());
		var leftDate = new Date(d.toString());
		var rightDate = new Date(d.toString());
	    
		switch(curDay)
		{ 
		case 0:
			leftDate = subtractFromDate(leftDate,2);
		    lastDate = addToDate(lastDate,6);
			rightDate = addToDate(rightDate,8);
		    break;
		case 1:
		    firstDate = subtractFromDate(firstDate,1);
		    lastDate = addToDate(lastDate,5);
			leftDate  = subtractFromDate(leftDate,3);
		    rightDate = addToDate(rightDate,7);
		    break;
		case 2:
			firstDate = subtractFromDate(firstDate,2);
		    lastDate = addToDate(lastDate,4);
			leftDate  = subtractFromDate(leftDate,4);
		    rightDate = addToDate(rightDate,6);
		    break;
		case 3:
			firstDate = subtractFromDate(firstDate,3);
		    lastDate = addToDate(lastDate,3);
			leftDate  = subtractFromDate(leftDate,5);
		    rightDate = addToDate(rightDate,5);
		    break;
		case 4:
			firstDate = subtractFromDate(firstDate,4);
		    lastDate = addToDate(lastDate,2);
			leftDate  = subtractFromDate(leftDate,6);
		    rightDate = addToDate(rightDate,4);
		    break;
		case 5:
			firstDate = subtractFromDate(firstDate,5);
		    lastDate = addToDate(lastDate,1);
			leftDate  = subtractFromDate(leftDate,7);
		    rightDate = addToDate(rightDate,3);
		    break;
		case 6:
			firstDate = subtractFromDate(firstDate,6);
			leftDate  = subtractFromDate(leftDate,8);
		    rightDate = addToDate(rightDate,2);
		    break;
		}
	
	    
	    document.getElementById("calDiv").innerHTML = createCal(firstDate,lastDate);
	    document.getElementById("leftLinkDiv").innerHTML = createLink(leftDate,true);
		document.getElementById("rightLinkDiv").innerHTML = createLink(rightDate,false);
		document.getElementById("hiddenDate").innerHTML=getSelectedDate(firstDate,lastDate);
	}
	
	
	  
	window.onload = function(){
		document.getElementById("mealMenuDropDown").style.visibility = 'hidden'; 
		document.getElementById("mealMenuTxt").style.visibility = 'hidden'; 
		document.getElementById("mealMenuSubmit").style.visibility = 'hidden'; 
		document.getElementById('slcDay').value= 0;
		urldate = gup('uDate');
		val=document.getElementById('activeTab');
		tab=gup('activeTab');
		if(val.value=="nutrition"||tab=="nutrition"){
			if(urldate == ""){
			displayDates(new Date());
			}else {
				displayDates(new Date(urldate));
			}
			callCalendar();
		}
				
	}
	
	function displayMealMenuTxt(s){
		var selectedItem = document.getElementById("mealMenuDropDown").value;
		if(selectedItem!="select"&& s!="select"){
			document.getElementById("mealMenuTxt").style.visibility = 'visible'; 
			document.getElementById("mealMenuSubmit").style.visibility = 'visible'; 
			}else{
			document.getElementById("mealMenuTxt").style.visibility = 'hidden';
			document.getElementById("mealMenuSubmit").style.visibility = 'hidden'; 
			}
	
	}
	
	var v=0;
	function submitDetails(){
		selectedDay = document.getElementById('slcDay');//gup('slcDay');
		if(document.getElementById("mealMenuTxt").value!=""){
			var section=document.getElementById("mealMenuDropDown").value;
			var details=document.getElementById("mealMenuTxt").value;	
			var HTMLTable;
			
			var l=0;
			
			if(selectedDay.value == 0){
				if(section == "Breakfast"||section == "Snack" || section == "Dinner"||section == "Dessert"||section == "Lunch"){
						var tbForLabel = document.createElement('table');
						var trForLabel = document.createElement('tr');
						var td = document.createElement('td');
						td.style.fontSize="12px";
						td.style.fontWeight="bold";
						//var sp = document.createElement('td');
						//sp.style.width="50px";
						var val = document.createTextNode(section);
						val.id = 'sunSec'+v;
						var t  = document.getElementById('divForMeal');
						
						td.appendChild(val);
						trForLabel.appendChild(td);
						
						
						var trForDetails = document.createElement('tr');
						var td1 = document.createElement('td');
						//var spForDetails = document.createElement('td');
						//spForDetails.style.width="50px";
						var tx1 = document.createElement('textarea'); 
						tx1.style.width = "120px";
						tx1.id = 'sunDetail'+v;
						var val1 = document.createTextNode(details);
						var t1  = document.getElementById('divForMeal');
						tx1.appendChild(val1);
						td1.appendChild(tx1);
						trForDetails.appendChild(td1);
				
						//t.appendChild(tbForLabel);
						//t1.appendChild(tbForDetails);
						tbForLabel.appendChild(trForLabel);
						tbForLabel.appendChild(trForDetails);
						t.appendChild(tbForLabel);
												
					}
				v++;
			}
				
			if(selectedDay.value == 1){
				if(section == "Breakfast"||section == "Snack" || section == "Dinner"||section == "Dessert"||section == "Lunch"){
							
							///////////code to display section name
							var tbForLabel = document.createElement('table');
							var trForLabel = document.createElement('tr');
							var td = document.createElement('td');
							td.style.fontSize="12px";
							td.style.fontWeight="bold";
							var sp = document.createElement('td');
							sp.style.width="136px";
							var val = document.createTextNode(section);
							val.id = 'monSec'+v;
							var t  = document.getElementById('divForMeal1');
							
							td.appendChild(val);
							trForLabel.appendChild(sp);
							trForLabel.appendChild(td);
							
							
							
							/////code to display textarea for that section
							
							var trForDetails = document.createElement('tr');
							var td1 = document.createElement('td');
							var spForDetails = document.createElement('td');
							spForDetails.style.width="136px";
							var tx1 = document.createElement('textarea'); 
							tx1.id = 'monDetail'+v;
							tx1.style.width = "120px";
							var val1 = document.createTextNode(details);
							var t1  = document.getElementById('divForMeal1');
							tx1.appendChild(val1);
							td1.appendChild(tx1);
							
							trForDetails.appendChild(spForDetails);
							trForDetails.appendChild(td1);
							
							//t.appendChild(trForLabel);
							//t1.appendChild(trForDetails);
							tbForLabel.appendChild(trForLabel);
							tbForLabel.appendChild(trForDetails);
							t.appendChild(tbForLabel);
							
					}
						v++;
				}
					
					
				if(selectedDay.value == 2){
						if(section == "Breakfast"||section == "Snack" || section == "Dinner"||section == "Dessert"||section == "Lunch"){
							
							///////////code to display section name
							var tbForLabel = document.createElement('table');
							var trForLabel = document.createElement('tr');
							var td = document.createElement('td');
							td.style.fontSize="12px";
							td.style.fontWeight="bold";
							//var sp = document.createElement('td');
							//sp.style.width="135px";
							var val = document.createTextNode(section);
							val.id = 'tuesSec'+v;
							
							var t  = document.getElementById('divForMeal2');
							
							td.appendChild(val);
							//trForLabel.appendChild(sp);
							trForLabel.appendChild(td);
							
							
							/////code to display textarea for that section
							
							var trForDetails = document.createElement('tr');
							var td1 = document.createElement('td');
							//var spForDetails = document.createElement('td');
							//spForDetails.style.width="135px";
							var tx1 = document.createElement('textarea'); 
							tx1.style.width = "120px";
							
							tx1.id = 'tuesDetail'+v;
							var val1 = document.createTextNode(details);
							//var t1  = document.getElementById('divForMeal2');
							tx1.appendChild(val1);
							td1.appendChild(tx1);
							
							//trForDetails.appendChild(spForDetails);
							trForDetails.appendChild(td1);
							
							tbForLabel.appendChild(trForLabel);
							tbForLabel.appendChild(trForDetails);
							t.appendChild(tbForLabel);
						}
						v++;	
					}
					
					
					if(selectedDay.value == 3){
					
						if(section == "Breakfast"||section == "Snack" || section == "Dinner"||section == "Dessert"||section == "Lunch"){
							
							///////////code to display section name
							var tbForLabel = document.createElement('table');
							var trForLabel = document.createElement('tr');
							var td = document.createElement('td');
							td.style.fontSize="12px";
							td.style.fontWeight="bold";
							//var sp = document.createElement('td');
							//sp.style.width="100px";
							var val = document.createTextNode(section);
							val.id = 'wedSec'+v;
							
							var t  = document.getElementById('divForMeal3');
							
							td.appendChild(val);
							//trForLabel.appendChild(sp);
							trForLabel.appendChild(td);
							
							
							/////code to display textarea for that section
							
							var trForDetails = document.createElement('tr');
							var td1 = document.createElement('td');
							//var spForDetails = document.createElement('td');
							//spForDetails.style.width="472px";
							var tx1 = document.createElement('textarea'); 
							tx1.style.width = "125px";
							
							tx1.id = 'wedDetail'+v;
							var val1 = document.createTextNode(details);
							//var t1  = document.getElementById('divForMeal3');
							tx1.appendChild(val1);
							td1.appendChild(tx1);
							
							//trForDetails.appendChild(spForDetails);
							trForDetails.appendChild(td1);
							
							tbForLabel.appendChild(trForLabel);
							tbForLabel.appendChild(trForDetails);
							t.appendChild(tbForLabel);
						}
						v++;
					}
					
					
					if(selectedDay.value == 4){
						if(section == "Breakfast"||section == "Snack" || section == "Dinner"||section == "Dessert"||section == "Lunch"){
							
							///////////code to display section name
							var tbForLabel = document.createElement('table');
							var trForLabel = document.createElement('tr');
							var td = document.createElement('td');
							td.style.fontSize="12px";
							td.style.fontWeight="bold";
							//var sp = document.createElement('td');
							//sp.style.width="136px";
							var val = document.createTextNode(section);
							val.id = 'thurSec'+v;
							
							var t  = document.getElementById('divForMeal4');
							
							td.appendChild(val);
							//trForLabel.appendChild(sp);
							trForLabel.appendChild(td);
							
							
							/////code to display textarea for that section
							
							var trForDetails = document.createElement('tr');
							var td1 = document.createElement('td');
							//var spForDetails = document.createElement('td');
							//spForDetails.style.width="136px";
							var tx1 = document.createElement('textarea'); 
							tx1.style.width = "130px";
							
							tx1.id = 'thurDetail'+v;
							var val1 = document.createTextNode(details);
							//var t1  = document.getElementById('divForMeal');
							tx1.appendChild(val1);
							td1.appendChild(tx1);
							
							//trForDetails.appendChild(spForDetails);
							trForDetails.appendChild(td1);
							
							tbForLabel.appendChild(trForLabel);
							tbForLabel.appendChild(trForDetails);
							t.appendChild(tbForLabel);
						}
						v++;
					}
					
					
					if(selectedDay.value == 5){
					
						if(section == "Breakfast"||section == "Snack" || section == "Dinner"||section == "Dessert"||section == "Lunch"){
							
							///////////code to display section name
							var tbForLabel = document.createElement('table');
							var trForLabel = document.createElement('tr');
							var td = document.createElement('td');
							td.style.fontSize="12px";
							td.style.fontWeight="bold";
							//var sp = document.createElement('td');
							//sp.style.width="136px";
							var val = document.createTextNode(section);
							val.id = 'friSec'+v;
							
							var t  = document.getElementById('divForMeal5');
							
							td.appendChild(val);
							//trForLabel.appendChild(sp);
							trForLabel.appendChild(td);
							
							
							/////code to display textarea for that section
							
							var trForDetails = document.createElement('tr');
							var td1 = document.createElement('td');
							//var spForDetails = document.createElement('td');
							//spForDetails.style.width="136px";
							var tx1 = document.createElement('textarea'); 
							tx1.style.width = "125px";
							
							tx1.id = 'friDetail'+v;
							var val1 = document.createTextNode(details);
							//var t1  = document.getElementById('divForMeal5');
							tx1.appendChild(val1);
							td1.appendChild(tx1);
							
							//trForDetails.appendChild(spForDetails);
							trForDetails.appendChild(td1);
							
							tbForLabel.appendChild(trForLabel);
							tbForLabel.appendChild(trForDetails);
							t.appendChild(tbForLabel);
						}
					v++;	
				}
					
					if(selectedDay.value == 6){

						if(section == "Breakfast"||section == "Snack" || section == "Dinner"||section == "Dessert"||section == "Lunch"){
							
							///////////code to display section name
							var tbForLabel = document.createElement('table');
							var trForLabel = document.createElement('tr');
							var td = document.createElement('td');
							td.style.fontSize="12px";
							td.style.fontWeight="bold";
							//var sp = document.createElement('td');
							//sp.style.width="136px";
							var val = document.createTextNode(section);
							val.id = 'satSec'+v;
							
							var t  = document.getElementById('divForMeal6');
							
							td.appendChild(val);
							//trForLabel.appendChild(sp);
							trForLabel.appendChild(td);
							
							
							/////code to display textarea for that section
							
							var trForDetails = document.createElement('tr');
							var td1 = document.createElement('td');
							//var spForDetails = document.createElement('td');
							//spForDetails.style.width="136px";
							var tx1 = document.createElement('textarea'); 
							tx1.style.width = "118px";
							
							tx1.id = 'satDetail'+v;
							var val1 = document.createTextNode(details);
							//var t1  = document.getElementById('divForMeal');
							tx1.appendChild(val1);
							td1.appendChild(tx1);
							
							//trForDetails.appendChild(spForDetails);
							trForDetails.appendChild(td1);
							
							tbForLabel.appendChild(trForLabel);
							tbForLabel.appendChild(trForDetails);
							t.appendChild(tbForLabel);
						}
					v++;
				}
	
		}else{
			var msg="Enter the "+document.getElementById("mealMenuDropDown").value+" details";
			alert(msg);
		}
			
		document.getElementById("mealMenuTxt").value="";
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
		<i>Added by <%=commentingUser.getFormattedNameAndUsername()%> on <%=genericDateFormat.format(pfdComment.getCreateDate())%>:</i><br/>
		<%=pfdComment.getCommentText()%><br/><br/>
		<%
	}
}
%>

</div>
</div>

<div id="contentnutrition" class="contentDiv" style="display:<%=activeTab.equals("nutrition")?"block":"none"%>">
<form action="processNutrition.jsp?<%=controller.getSiteIdNVPair()%>" method="post" name="mainForm" id="mainForm">

<input type="hidden" name="id" value="<%=nutritionPlan.getId()%>" />
<input type="hidden" name="userid" value="<%=viewingUserId%>" />

<input type="hidden" name="retUrl" value="user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>"/>

<!--Nutritionist screen not implemented right now.-->

<table width="100%">
                  <tr>
                    <td height="44" background="../images/box_header.jpg" 
class="box_heading">&nbsp;&nbsp;&nbsp;Weekly Meal Plan</td>
<td><div id="hiddenDate"></div></td>
                  </tr>


<!--
<tr><td>
	<table border="0" width="75%"  height="25" cellpadding="0" cellspacing="0"  bgcolor="#E5E5E5">
		<tr>
			<td width="156">
					 <select name="meal" size="1" style=" width:200; height:21">
                      <option selected="selected">Breakfast</option>
                      <option>Lunch</option>
                      <option>Dinner</option>
                    </select></td>
			<td  width="10">&nbsp;</td>
			<td  width="128">&nbsp;</td>
			<td  width="10">&nbsp;</td>

			<td align="center" width="103">							
			<a onmouseover="var 
img=document['fpAnimswapImgFP4'];img.imgRolln=img.src;img.src=img.lowsrc?img.lowsrc:img.getAttribute?img.getAttribute('lowsrc'):img.src;" 
onmouseout="document['fpAnimswapImgFP4'].src=document['fpAnimswapImgFP4'].imgRolln" href="javascript:void(0)">							
			<img border="0" src="images/btn_select.jpg" width="95" height="24" 
id="fpAnimswapImgFP4" name="fpAnimswapImgFP4" dynamicanimation="fpAnimswapImgFP4" 
lowsrc="images/btn_select.jpg"></a></td>
			<td width="4">&nbsp;</td>
			<td width="103" align="center">							
			<a onmouseover="var 
img=document['fpAnimswapImgFP5'];img.imgRolln=img.src;img.src=img.lowsrc?img.lowsrc:img.getAttribute?img.getAttribute('lowsrc'):img.src;" 
onmouseout="document['fpAnimswapImgFP5'].src=document['fpAnimswapImgFP5'].imgRolln" href="javascript:void(0)">
			<img border="0" src="images/btn_sel_end.jpg" width="95" height="24" 
id="fpAnimswapImgFP5" name="fpAnimswapImgFP5" dynamicanimation="fpAnimswapImgFP5" 
lowsrc="images/btn_sel_end.jpg"></a></td>
			<td width="4">&nbsp;</td>
			<td width="219">							
			<a onmouseover="var 
img=document['fpAnimswapImgFP6'];img.imgRolln=img.src;img.src=img.lowsrc?img.lowsrc:img.getAttribute?img.getAttribute('lowsrc'):img.src;" 
onmouseout="document['fpAnimswapImgFP6'].src=document['fpAnimswapImgFP6'].imgRolln" href="javascript:void(0)">							
			<img border="0" src="images/btn_sel_name.jpg" width="95" height="24" 
id="fpAnimswapImgFP6" name="fpAnimswapImgFP6" dynamicanimation="fpAnimswapImgFP6" 
lowsrc="images/btn_sel_name.jpg"></a></td>

			<td><a onmouseover="var 
img=document['fpAnimswapImgFP6'];img.imgRolln=img.src;img.src=img.lowsrc?img.lowsrc:img.getAttribute?img.getAttribute('lowsrc'):img.src;" 
onmouseout="document['fpAnimswapImgFP6'].src=document['fpAnimswapImgFP6'].imgRolln" 
href="javascript:void(0)"><img src="images/btn_assign_nut.jpg" alt="" name="fpAnimswapImgFP6" width="95" 
height="24" border="0" lowsrc="images/btn_assign_nut.jpg" id="fpAnimswapImgFP8" 
dynamicanimation="fpAnimswapImgFP6" /></a></td>
			<td width="60">&nbsp;</td>
		</tr>
	</table>
	</td>
  </tr>
-->

  <tr>
    <td height="12px"></td>
  </tr>

<%--  <tr>--%>
<%--    <td>--%>
<%--	<table border="0" width="100%" height="25" cellpadding="0" cellspacing="0" class="days">--%>
<%--		<tr>--%>
<%--        <td width="1%">&nbsp;</td>--%>
<%--			<td width="10%" align="center" bgcolor="#DFD0FF">Sunday11</td>--%>
<%--			<td width="3%">&nbsp;</td>--%>
<%----%>
<%--			<td width="10%" align="center" bgcolor="#FFFFCC">Monday</td>--%>
<%--			<td width="3%">&nbsp;</td>--%>
<%--			<td width="10%" align="center" bgcolor="#B2E5E5">Tuesday</td>--%>
<%--			<td width="3%">&nbsp;</td>--%>
<%--			<td width="10%" align="center" bgcolor="#DEFFBE">Wednesday</td>--%>
<%--			<td width="3%">&nbsp;</td>--%>
<%--			<td width="10%" align="center" bgcolor="#FFD2A5">Thursday</td>--%>
<%----%>
<%--			<td width="3%">&nbsp;</td>--%>
<%--			<td width="10%" align="center" bgcolor="#D1A3BA">Friday</td>--%>
<%--			<td width="3%">&nbsp;</td>--%>
<%--			<td width="10%" align="center" bgcolor="#B8E3FF">Saturday</td>--%>
<%--			<td width="1%">&nbsp;</td>--%>
<%--		</tr>--%>
<%--	</table>--%>
<%--	</td>--%>
<%--  </tr>--%>
	<tr>
	<td>
	<div id="leftLinkDiv"></div>
	<div id="rightLinkDiv"></div>
	</td>
	</tr>
	<tr>
	<td>
	<div id="calDiv"></div>
	</td>
	</tr>
	<tr>
	<td align="center">
		<select id="mealMenuDropDown" name="mealMenuDropDown" onchange="displayMealMenuTxt(this.value)">
		  <option value="select" selected="selected">Select..</option>
		
		  <option value="Breakfast">Breakfast</option>
		  <option value="Lunch">Lunch</option>
		  <option value="Dinner">Dinner</option>
		  <option value="Dessert">Dessert</option>
		  <option value="Snack">Snack</option>
		</select>
		<textarea  type=hidden id="mealMenuTxt" rows="1" cols="50"></textarea>
		<input  id="mealMenuSubmit"  type="button" name="addMeal" value="Add" onclick="submitDetails()">
		<input type="hidden" id="uDate" name="uDate"/>
		<input type="hidden" id="slcDay" name="slcDay" value=""/>
		<input type="hidden" id="activeTab" name="activeTab" value=""/>
		
	</td>
	</tr>
  <tr>
    <td height="10"></td>
  </tr>
  <tr><td>
	<table border="0" width="100%" cellpadding="0" cellspacing="0" align="">
	<tr>
    	<td  height="1" bgcolor="#333333"></td>
	</tr>
	</table>
	</td>
  </tr>
  <tr>
    <td height="12"></td>
  </tr>
<tr>
 	<table>
 	<tr>
	 	<table>
		 	<tr>
				 <td width="140px" id="divForMeal">
				 </td>
			
				 <td width="140px" id="divForMeal1">
				</td>
				 
				 <td width="140px" id="divForMeal2">
				 </td>
				 
				  <td width="140px" id="divForMeal3">
				 </td>
				 
				  <td width="160px" id="divForMeal4">
				 </td>
				 
				   <td width="140px" id="divForMeal5">
				 </td>
				 
				  <td width="150px" id="divForMeal6">
				 </td>
			</tr>
			<tr>
				<td>
					<table id="hiddenFieldForSec"><tr></tr></table></td><td width="130"> 
				 </td>
				 <td><table id="hiddenFieldForValue"><tr></tr></table></td><td width="130"></td>
				 <td><table id="dinner"><tr></tr></table></td><td width="135"></td>
				 <td><table id="dessert"><tr></tr></table></td><td width="135"></td>
			 </tr>
			
		</table>
	</tr>

	 <tr>
	 	<table style="font-size: 10pt">
		 	<tr><td></td>
		 		<td width="100" align="center"><b>Colories:</b></td><td width="1%">&nbsp;</td><td width="100" align="center"><b>Colories:</b></td>
		 		<td width="1%">&nbsp;</td><td width="100" align="center"><b>Colories:</b></td><td width="1%">&nbsp;</td><td width="100" align="center"><b>Colories:</b></td>
		 		<td width="1%">&nbsp;</td><td width="100" align="center"><b>Colories:</b></td><td width="1%">&nbsp;</td><td width="100" align="center"><b>Colories:</b></td>
		 		<td width="1%">&nbsp;</td><td width="100" align="center"><b>Colories:</b></td>
		 	</tr>
		 	<tr><td></td>
		 		<td width="100"><input type="text" id="sunCal" name="sunCal" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="100"><input type="text" id="monCal" name="monCal" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="100"><input type="text" id="tuesCal" name="tuesCal" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="100"><input type="text" id="wedCal" name="wedCal" size="17"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="100"><input type="text" id="thurCal" name="thurCal" size="17"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="100"><input type="text" id="friCal" name="friCal" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="100"><input type="text" id="satCal" name="satCal" size="16"></td>
		 	</tr>
		</table>
 	</tr>
 	<tr>
 		<td height="1%">&nbsp;</td>
 	</tr>
 	
 	<tr>
	 	<table style="font-size: 10pt">
		 	<tr><td></td>
		 		<td width="100" align="center"><b>Total Carbs:</b></td><td width="1%">&nbsp;</td><td width="100" align="center"><b>Total Carbs:</b></td>
		 		<td width="1%">&nbsp;</td><td width="100" align="center"><b>Total Carbs:</b></td><td width="1%">&nbsp;</td><td width="100" align="center"><b>Total Carbs:</b></td>
		 		<td width="1%">&nbsp;</td><td width="100" align="center"><b>Total Carbs:</b></td><td width="1%">&nbsp;</td><td width="90" align="center"><b>Total Carbs:</b></td>
		 		<td width="1%">&nbsp;</td><td width="100" align="center"><b>Total Carbs:</b></td>
		 	</tr>
		 	<tr><td></td>
		 		<td width="86"><input type="text" id="sunCarbs" name="sunCarbs" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="monCarbs" name="monCarbs" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="tuesCarbs" name="tuesCarbs" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="wedCarbs" name="wedCarbs" size="17"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="thurCarbs" name="thurCarbs" size="17"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="friCarbs" name="friCarbs" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="satCarbs" name="satCarbs" size="16"></td>
		 	</tr>
	 	</table>
 	</tr>
 	<tr>
 		<td height="1%">&nbsp;</td>
 	</tr>
 
 	<tr>
	 	<table style="font-size: 10pt">
		 	<tr><td></td>
		 		<td width="95" align="center"><b>Fiber:</b></td><td width="1%">&nbsp;</td><td width="100" align="center"><b>Fiber:</b></td>
		 		<td width="1%">&nbsp;</td><td width="100" align="center"><b>Fiber:</b></td><td width="1%">&nbsp;</td><td width="100" align="center"><b>Fiber:</b></td>
		 		<td width="1%">&nbsp;</td><td width="90" align="center"><b>Fiber:</b></td><td width="1%">&nbsp;</td><td width="90" align="center"><b>Fiber:</b></td>
		 		<td width="1%">&nbsp;</td><td width="90" align="center"><b>Fiber:</b></td>
		 	</tr>
		 	<tr><td></td>
		 		<td width="86"><input type="text" id="sunFiber" name="sunFiber" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="monFiber" name="monFiber" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="tuesFiber" name="tuesFiber" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="wedFiber" name="wedFiber" size="17"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="thurFiber" name="thurFiber" size="17"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="friFiber" name="friFiber" size="16"></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="86"><input type="text" id="satFiber" name="satFiber" size="16"></td>
		 	</tr>
	 	</table>
 	</tr>
 	<tr>
 		<td height="1%">&nbsp;</td>
 	</tr>
 	<tr>
	 	<table style="font-size: 10pt">
		 	<tr><td></td>
		 		<td width="100" align="center"><b>Instructions:</b></td><td width="1%">&nbsp;</td><td width="115" align="center"><b>Instructions:</b></td>
		 		<td width="1%">&nbsp;</td><td width="115" align="center"><b>Instructions:</b></td><td width="1%">&nbsp;</td><td width="115" align="center"><b>Instructions:</b></td>
		 		<td width="1%">&nbsp;</td><td width="96" align="center"><b>Instructions:</b></td><td width="1%">&nbsp;</td><td width="85" align="center"><b>Instructions:</b></td>
		 		<td width="1%">&nbsp;</td><td width="90" align="center"><b>Instructions:</b></td>
		 	</tr>
		 	<tr><td></td>
		 		<td width="96"><textarea rows="2" cols="12" id="sunInstn" name="sunInstn"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="96"><textarea rows="2" cols="13" id="monInstn" name="monInstn"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="96"><textarea rows="2" cols="12" id="tuesInstn" name="tuesInstn"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="96"><textarea rows="2" cols="13" id="wedInstn" name="wedInstn"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="96"><textarea rows="2" cols="13" id="thurInstn" name="thurInstn"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="96"><textarea rows="2" cols="13" id="friInstn" name="friInstn"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="96"><textarea rows="2" cols="13" id="satInstn" name="satInstn"></textarea></td>
		 	</tr>
	 	</table>
 	</tr>
 	<tr>
	 	<table style="font-size: 10pt">
		 	<tr><td></td>
		 		<td width="90" align="center"><b>User Comments:</b></td><td width="1%">&nbsp;</td><td width="90" align="center"><b>User Comments:</b></td>
		 		<td width="1%">&nbsp;</td><td width="95" align="center"><b>User Comments:</b></td><td width="1%">&nbsp;</td><td width="85" align="center"><b>User Comments:</b></td>
		 		<td width="1%">&nbsp;</td><td width="90" align="center"><b>User Comments:</b></td><td width="1%">&nbsp;</td><td width="90" align="center"><b>User Comments:</b></td>
		 		<td width="1%">&nbsp;</td><td width="90" align="center"><b>User Comments:</b></td>
		 	</tr>
		 	<tr><td></td>
		 		<td width="95"><textarea rows="2" cols="12" id="sunUserComm" name="sunUserComm"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="97"><textarea rows="2" cols="13" id="monUserComm" name="monUserComm"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="100"><textarea rows="2" cols="12" id="tuesUserComm" name="tuesUserComm"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="100"><textarea rows="2" cols="13" id="wedUserComm" name="wedUserComm"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="95"><textarea rows="2" cols="13" id="thurUserComm" name="thurUserComm"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="90"><textarea rows="2" cols="13" id="friUserComm" name="friUserComm"></textarea></td>
		 		<td width="1%">&nbsp;</td>
		 		<td width="90"><textarea rows="2" cols="13" id="satUserComm" name="satUserComm"></textarea></td>
		 	</tr>
	 	</table>
 	</tr>
  	<tr>
    	<td>
     	 <textarea name="instr" cols="120" rows="3" style="background-color:"><%=PageUtils.nonNull(nutritionPlan.getInstructions())%></textarea>
    	</td>
  	</tr>
	 <tr>
	    <td>&nbsp;</td>
	 </tr>
  	 <tr>
		<td>
		<table border="0" width="75%" cellpadding="0" cellspacing="0">
			<tr>
	 			<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td width="97">
				<input type="image" border="0" src="../images/btn_send_int.jpg" width="97" height="24" alt="Submit" value="Submit">
				</td>
				<td width="70">&nbsp;</td>
	
			</tr>
		</table>
		</td>
 	 </tr>
 	</table>
 	
	</table>
</form>

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

