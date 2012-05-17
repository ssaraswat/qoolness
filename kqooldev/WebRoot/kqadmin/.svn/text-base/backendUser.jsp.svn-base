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
static final int[] MAX_WORKOUT_RESULTS={5, 10, 20, 999999};

static Map tabCodesToLabelsMap=initTabCodesToLabelsMap();

static Map<String,String> initTabCodesToLabelsMap() {
	Map<String,String> map=new LinkedHashMap<String,String>(20);
	map.put("general","General");
	map.put("status","Status");
	map.put("clients","Clients");
	map.put("routines","Routines");
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

int maxRoutineResults=controller.getParamAsInt("maxRoutineResults", 10);




int viewingUserId=controller.getParamAsInt("id");
User viewingUser=User.getById(viewingUserId);
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
	<td nowrap="nowrap"><div onclick="tabClick('<%=tabCode%>')" style="cursor:pointer; padding: 4px 20px 4px 20px; background-color:#<%=activeTab.equals(tabCode)?"cccccc":"eeeeee"%>; font-size:12px; font-family:arial,helvetica; font-weight:bold;" id="tab<%=tabCode%>"><%=tabLabel%></div></td>
	<td>&nbsp;&nbsp;</td>
	<%
}
%>
</tr>
</table>
<div id="contentgeneral" class="contentDiv" style="display:<%=activeTab.equals("general")?"block":"none"%>">

<b>Username:</b> <%=viewingUser.getUsername()%><br/>
<b>Full Name:</b> <%=viewingUser.getFirstName()%> <%=viewingUser.getLastName()%><br/>
<b>Email:</b> <a href="mailto:<%=viewingUser.getEmailAddress()%>"><%=viewingUser.getEmailAddress()%></a><br/><br/>

<b>Backend User Type:</b> <%=viewingUser.getDefaultBackendUserTypeLabel()%><br/>
<b>Site:</b> <%=((Site)allSitesMap.get(new Integer(viewingUser.getSiteId()))).getLabel()%><br/>
<%
String supervisor;
User supervisingUser=(User)allUsersMap.get(new Integer(viewingUser.getBackendUserParentUserId()));
if (supervisingUser!=null) {
	supervisor=supervisingUser.getFormattedNameAndUsername();
}
else {
	if (viewingUser.getBackendUserParentUserId()==User.BACKEND_USER_PARENT_USER_ID_SUPERADMIN_PARENT) {
		supervisor="Super Admin";
	}
	else {
		supervisor="[unknown]";
	}
}
%>
<b>Supervising Backend User:</b> <%=supervisor%><br/><br/>


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

<%=HtmlUtils.smallCpFormButton(false, "edit this data", "location.href='editUser.jsp?retUrl="+URLEncoder.encode("backendUser.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=general","UTF-8")+"&"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"'", request)%><br />

</div>






<div id="contentstatus" class="contentDiv" style="display:<%=activeTab.equals("status")?"block":"none"%>">
<b>Status:</b> <%=viewingUser.getStatusLabel()%>.<br/><br/> <%
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
%><br/><br/>
<%
String onclick;
String retUrl=URLEncoder.encode(request.getContextPath()+"/kqadmin/backendUser.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=status");
if (viewingUser.getStatus()!=User.STATUS_ACTIVE) {
	onclick="confirmActivate("+viewingUser.getId()+",'"+viewingUser.getFormattedNameAndUsername()+"',"+viewingUser.getStatus()+", '"+retUrl+"')";
}
else {
	onclick="location.href='userStatus.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&retUrl="+retUrl+"'";
}

%>
<%=HtmlUtils.smallCpFormButton(false, "change status", onclick, request)%><br />
</div>


<div id="contentclients" class="contentDiv" style="display:<%=activeTab.equals("clients")?"block":"none"%>">
<%
List mappings=ClientToBackendUserMapping.getByBackendUserId(viewingUser.getId());
mappings=(mappings==null?new ArrayList():mappings);
if (mappings.size()==0) {
	%>This backend user is currently not associated with any clients.<%
}
else {
	%>This backend user is currently shared with the following clients.  Un-share this backend user from a client by clicking an "un-share" link.<br/><br/><%
	User client;
	ClientToBackendUserMapping mapping;
	Site site;
	it=mappings.iterator();
	while (it.hasNext()) {
		mapping=(ClientToBackendUserMapping)it.next();
		client=(User)allUsersMap.get(new Integer(mapping.getClientUserId()));
		if (client==null || client.isBackendUser()) {
			continue;
		}
		site=(Site)allSitesMap.get(new Integer(client.getSiteId()));
		%>&nbsp;&nbsp;&nbsp;&nbsp;<a href="user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=client.getId()%>"><%=client.getFormattedNameAndUsername()%></a> (<%=site.getLabel()%>)
		<b><%
		if (currentUser.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER) {
			%><a onclick="alert('You must be a site admin or a super admin to un-share backend users from clients.  Please speak to your site admin or super admin.'); return false;" href="#" style="color:#cc0000;">[un-share]</a><%
		}
		else {
			%><a onclick="return confirm('Are you sure you want to un-share this backend user from this client?')" href="backendUserAssignment.jsp?assign=false&<%=controller.getSiteIdNVPair()%>&backendUserId=<%=viewingUser.getId()%>&clientId=<%=client.getId()%>&retUrl=<%=URLEncoder.encode("backendUser.jsp?activeTab=clients&"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId(), "UTF-8")%>" style="color:#cc0000;">[un-share]</a><%
		}
		%></b><br/>
		<%
	}
}


%>
</div>


<div id="contentroutines" class="contentDiv" style="display:<%=activeTab.equals("routines")?"block":"none"%>">
<script type="text/javascript">

function routineSelectChanged(selectObj) {
	var selectedValue=selectObj.options[selectObj.selectedIndex].value
	if (selectedValue!=999999) {
		location.href='backendUser.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=viewingUser.getId()%>&activeTab=routines&maxRoutineResults='+selectedValue
	}
	else {
		window.open("workoutList.jsp?<%=controller.getSiteIdNVPair()%>&doDisplay=true&routineStatus=1&sortType=3&sortAsc=desc&maxListLength=999999&assignedToClientIdOnly=-1&assignedByBackendUserIdOnly=<%=viewingUser.getId()%>&pastDeadlineOnly=false", "allRoutines");
		selectObj.selectedIndex=0
	}
}
</script>

<%
List routines=Workout.getAdministratorAssignedByAssigningBackendUserId(viewingUser.getId(), maxRoutineResults, true);
if (routines!=null && routines.size()>0) {
	%>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr valign="middle">
	<td class="bodyFont">Here are the <%=routines.size()%> most recent routines assigned by this backend user.  <i>See more/fewer:</i><br/>
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
	<!--  <%=HtmlUtils.smallCpFormButton(false, "assign new routine", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=add'", request)%><br /> -->
	<br/><%
}
%>

<%
long nowTime;
Workout routine;
Workout completedWorkout;
boolean completed;
boolean pastDue;
int c;

if (routines==null) {
	%><i>No routines have been assigned to clients by this backend user.</i><br/><br/>
	
	<!-- <%=HtmlUtils.smallCpFormButton(false, "assign new routine", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=add'", request)%><br /> -->
	<%
}

else {
	it=routines.iterator();
	nowTime=new Date().getTime();
	c=1;
	User client;
	while (it.hasNext()) {
		routine=(Workout)it.next();
		client=(User)allUsersMap.get(new Integer(routine.getUserId()));
		completedWorkout=Workout.getBySourceWorkoutId(routine.getId());
		completed=(completedWorkout!=null);
		pastDue=(!completed && routine.getDueDate()!=null && routine.getRecordedAsWorkoutDate()==null && routine.getDueDate().getTime()<nowTime);

		%>
		<div style="font-weight:bold; width:690px; padding:3px; background-color:#eeeeee;"><%=c%>. <%=routine.getName()%> <span style="font-weight:normal;"><%

			if (client!=null) {
				%>(to <a href="user.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=client.getId()%>"><%=client.getFormattedNameAndUsername()%></a>)<%
			}
			else {
				%>(unassigned)<%
			}

		%>
		<%
		if (completed) {
			%><span style="color:#009900;">[routine is completed; <a style="color:#009900;" target="_blank" href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=completedWorkout.getId()%>">open the workout in a new window</a>]</span><%
		}
		else if (pastDue) {
			%><span style="color:#cc0000;">[routine is past-deadline; it was due on <%=workoutDateTimeFormat.format(routine.getDueDate())%>. <a style="color:#ff9900;" href="ignoreDeadline.jsp?<%=controller.getSiteIdNVPair()%>&workoutId=<%=routine.getId()%>&retUrl=<%=URLEncoder.encode("backendUser.jsp?activeTab=routines&siteId="+controller.getSiteId()+"&id="+viewingUser.getId(), "UTF-8")%>">Ignore deadline.</a>]</span><%
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
		<%=HtmlUtils.smallCpFormButton(false, "deactivate", "location.href='deactivateWorkout.jsp?"+controller.getSiteIdNVPair()+"&id="+routine.getId()+"&retUrl="+URLEncoder.encode("backendUser.jsp?"+controller.getSiteIdNVPair()+"&id="+viewingUser.getId()+"&activeTab=routines&maxRoutineResults="+maxRoutineResults+"","UTF-8")+"'", request, 70)%><br />
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

