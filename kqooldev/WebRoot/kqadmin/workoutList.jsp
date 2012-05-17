<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static final int NUM_EXERCISES=25;


static final String[][] SORTS={
	{""+WorkoutComparator.ASSIGNED_DATE,"Routine assignment date"},
	{""+WorkoutComparator.NAME,"Routine name"},
};

static final String[][] SORT_ORDERS={
	{"asc","...in ascending order"},
	{"desc","...in descending order"},
};

static final String[][] LIST_LENGTH_LIMITS={
	{"999999","[no limit]"},
	{"25","25 routines"},
	{"50","50 routines"},
	{"100","100 routines"},
	{"200","200 routines"},
	{"500","500 routines"},
	{"1000","1000 routines"},
};

static final String[][] PAST_DEADLINE_ONLY_OPTIONS={
	{"false","Show all routines (past-deadline or not)"},
	{"true","Show only past-due routines"},

};


static final String[][] STATUSES={
	{"0","all routines"},
	{""+Workout.STATUS_ACTIVE,"active routines only"},
	{""+Workout.STATUS_INACTIVE,"deactivated routines only"},



};

static DateFormat defaultDateFormat=new SimpleDateFormat("MM/dd/yy");

%>

<%
boolean doDisplay=(request.getParameter("doDisplay")!=null && request.getParameter("doDisplay").equals("true"));

int routineStatus=controller.getParamAsInt("routineStatus", Workout.STATUS_ACTIVE);
int sortType=controller.getParamAsInt("sortType", WorkoutComparator.ASSIGNED_DATE);
boolean sortAsc=controller.getParamAsBoolean("sortAsc", false);
boolean pastDeadlineOnly=controller.getParamAsBoolean("pastDeadlineOnly", Boolean.parseBoolean(PAST_DEADLINE_ONLY_OPTIONS[0][0]));
int assignedToClientIdOnly=controller.getParamAsInt("assignedToClientIdOnly", 0);
int assignedByBackendUserIdOnly=controller.getParamAsInt("assignedByBackendUserIdOnly", 0);
int maxListLength=controller.getParamAsInt("maxListLength", 25);

String contains=controller.getParam("contains", "").trim();


Map allUsersMap=User.getAllAsMap();
if (allUsersMap==null) {
	allUsersMap=new HashMap();
}
List allClients;
if (currentUser.isSuperAdmin()) {
	//allClients=User.getAllClients(true);
	allClients=User.getBackendUserClients(currentUser.getId(), true);
}
else {
	allClients=User.getBackendUserClients(currentUser.getId(), true);
}
if (allClients==null) {
	allClients=new ArrayList();
}

List allBackendUsers=User.getBackendUserChildren(currentUser.getId(), true);
if (allBackendUsers==null) {
	allBackendUsers=new ArrayList();
}
if (currentUser.isSuperAdmin()) {
	allBackendUsers.addAll(0, User.getAllSuperAdmins(true));
}
else {
	allBackendUsers.add(0, currentUser);
}

List rawAllRoutines=new ArrayList();
List allRoutines=new ArrayList();
if (doDisplay) {
	rawAllRoutines=Workout.getAdministratorAssignedByClientIdAndBackendUserId(assignedToClientIdOnly, assignedByBackendUserIdOnly, maxListLength, routineStatus==Workout.STATUS_ACTIVE);

	if (rawAllRoutines==null)
	{
		rawAllRoutines=new ArrayList();
	}
	// FIRST, do sort:
	Collections.sort(rawAllRoutines, new WorkoutComparator(sortType, sortAsc));

	allRoutines=new ArrayList(rawAllRoutines.size());
	
	ListIterator it=rawAllRoutines.listIterator();
	int listSize=0;
	

	// SECOND, do all filtering:
	long nowMillis=new Date().getTime();
	
	boolean doSearch=(contains.length()>0);
	String lcContains=contains.toLowerCase();

	while (it.hasNext()) {
		Workout routine=(Workout)it.next();
		if (
			(routineStatus==0 || routineStatus==routine.getStatus()) &&
			(!doSearch || (routine.getName().toLowerCase().indexOf(lcContains)>-1)) &&
			(!pastDeadlineOnly || routine.getDueDate()==null || (routine.getDueDate().getTime()>nowMillis))	
		) {
			allRoutines.add(routine);
			listSize++;
		}
		
		if (listSize>=maxListLength) {
			break;
		}
	}
	

}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
.actionFormButton {font-size:11px; font-family:arial,helvetica; width:40px; background-color:#ff6600; border:1px solid #000000; color:#ffffff; }
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<form action="workoutList.jsp" method="get" name="mainForm" id="mainForm">
<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
<input type="hidden" name="doDisplay" value="true" />

<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">

<%
if (!doDisplay) {
	// user hadn't entered any display criteria yet:
	%>
	<span class="firstSentenceFont">To view routines...</span><br />please choose view options below, and then press the "view routine list" button.
	<%
}
else {
	%><span class="firstSentenceFont">You may view or manage routines...</span><br />by clicking the appropriate button.  To re-sort or filter this list, please 
	choose new view options below, and then press the "view routine list" button.<%
}
%></span><%=HtmlUtils.doubleLB(request)%><br />
<br />



<div style="border:1px solid #999999; xbackground-color:#eeeeee; padding:4px;">
<div style="padding:2px; background-color:#cccccc; font-weight:bold;">View options:</div><br/>

<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td align="right" nowrap="nowrap" class="bodyFont"><i>Filter by status: show...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
<td colspan="8"><select class="selectText" name="routineStatus">
<%


for (int i=0; i<STATUSES.length; i++) {
	%>
	<option value="<%=STATUSES[i][0]%>" <%=routineStatus==Integer.parseInt(STATUSES[i][0])?" selected ":""%>><%=STATUSES[i][1]%></option>
	<%
}
%>
</select>


</td>
</tr>

<tr>
<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
</tr>


<tr>
<td align="right" nowrap="nowrap" class="bodyFont"><i>Sort routines by...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
<td colspan="8"><select class="selectText" name="sortType">
<%


for (int i=0; i<SORTS.length; i++) {
	%>
	<option value="<%=SORTS[i][0]%>" <%=sortType==Integer.parseInt(SORTS[i][0])?" selected ":""%>><%=SORTS[i][1]%></option>
	<%
}
%>
</select><select style="margin-left:5px;" class="selectText" name="sortAsc">
<%
boolean selected;
for (int i=0; i<SORT_ORDERS.length; i++) {
	selected=((sortAsc && i==0) || (!sortAsc && i!=0));
	%>
	<option value="<%=SORT_ORDERS[i][0]%>" <%=selected?" selected ":""%>><%=SORT_ORDERS[i][1]%></option>
	<%
}
%>
</select>

</td>
</tr>

<tr>
<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
</tr>

<tr>
<td align="right" nowrap="nowrap" class="bodyFont"><i>Limit list length to...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
<td colspan="8"><select class="selectText" name="maxListLength">
<%


for (int i=0; i<LIST_LENGTH_LIMITS.length; i++) {
	%>
	<option value="<%=LIST_LENGTH_LIMITS[i][0]%>" <%=maxListLength==Integer.parseInt(LIST_LENGTH_LIMITS[i][0])?" selected ":""%>><%=LIST_LENGTH_LIMITS[i][1]%></option>
	<%
}
%>
</select>


</td>
</tr>



<tr>
<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
</tr>

<tr>
<td align="right" nowrap="nowrap" class="bodyFont"><i>Show only routines assigned to...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
<td colspan="8"><select class="selectText" name="assignedToClientIdOnly">
<option value="-1">[any client]</option>
<option value="0" <%=assignedToClientIdOnly==0?" selected ":""%> >[not assigned]</option>
<%

Iterator it=allClients.iterator();
User client;
while (it.hasNext()) {
	client=(User)it.next();
	%>
	<option value="<%=client.getId()%>" <%=client.getId()==assignedToClientIdOnly?" selected ":""%>><%=client.getFormattedNameAndUsername()%></option>
	<%
}
%>
</select>


</td>
</tr>



<tr>
<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
</tr>

<tr>
<td align="right" nowrap="nowrap" class="bodyFont"><i>Show only routines assigned by...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
<td colspan="8"><select class="selectText" name="assignedByBackendUserIdOnly">
	<option value="-1">[any backend user]</option>

<%

it=allBackendUsers.iterator();
User backendUser;
while (it.hasNext()) {
	backendUser=(User)it.next();
	%>
	<option value="<%=backendUser.getId()%>" <%=backendUser.getId()==assignedByBackendUserIdOnly?" selected ":""%>><%=backendUser.getFormattedNameAndUsername()%></option>
	<%
}
%>
</select>


</td>
</tr>

<!-- 

<tr>
<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
</tr>

<tr>
<td align="right" nowrap="nowrap" class="bodyFont"><i>Past-deadline routines...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
<td colspan="8"><select class="selectText" name="pastDeadlineOnly">
<%


for (int i=0; i<PAST_DEADLINE_ONLY_OPTIONS.length; i++) {
	%>
	<option value="<%=PAST_DEADLINE_ONLY_OPTIONS[i][0]%>" <%=pastDeadlineOnly==Boolean.parseBoolean(PAST_DEADLINE_ONLY_OPTIONS[i][0])?" selected ":""%>><%=PAST_DEADLINE_ONLY_OPTIONS[i][1]%></option>
	<%
}
%>
</select>


</td>
</tr>
 -->
 
<tr>
<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
</tr>
 
<tr>
<td align="right" nowrap="nowrap" class="bodyFont"><i>Routine name contains...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
<td colspan="8"><input type="text" name="contains" value="<%=contains%>" class="inputText" style="width:130px;" /><br/>
</td>
</tr>	
 

<tr>
<td></td>
<td colspan="4"><input style="margin-top:12px; " type="submit" value="view routine list" class="controlPanelSmallButton"></td>
</tr>
</table>
<br/>

</div><br/>

<%
if (doDisplay && allRoutines.size()==0) {
	%><i style="color:#ff6600;">No routines match your "view options" criteria above.<br/></i><%
}
else if (doDisplay && allRoutines.size()>0) {
	%>
	<table border="0" cellspacing="0" cellpadding="0">
	<%=HtmlUtils.getHorizRuleTr(8, request)%>
	<tr class="headerRow" height="20">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Routine&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Client&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Backend&nbsp;User&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Date&nbsp;Assigned&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Actions&nbsp;&nbsp;&nbsp;<br /></font></td>
	
	
	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr>
	<%=HtmlUtils.getHorizRuleTr(8, request)%>
	
	<%

	for (int i=0; i<allRoutines.size(); i++) {
		Workout workout=(Workout)allRoutines.get(i);
		boolean workoutActive=(workout.getStatus()==Workout.STATUS_ACTIVE);
		client=(User)allUsersMap.get(new Integer(workout.getUserId()));
		backendUser=(User)allUsersMap.get(new Integer(workout.getAssigningBackendUserId()));
		%>
		<tr valign="middle" class=<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%> height="24">
		<%=HtmlUtils.getSingleRuleCell(request)%>
		<td align="left"><font class="columnDataFont">&nbsp;<br /></font></td>
		<td align="left" nowrap="nowrap"><font class="columnDataFont">&nbsp;<a href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=workout.getId()%>" target="_blank"><%=workout.getName()%></a><%=workoutActive?"":" [deactivated]"%>&nbsp;&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td align="left" nowrap="nowrap"><font class="columnDataFont"><nobr>&nbsp;<%=client==null?"[unassigned]":client.getFormattedNameAndUsername()%>&nbsp;&nbsp;&nbsp;</nobr></font></td>
		<td align="left" nowrap="nowrap"><font class="columnDataFont"><nobr>&nbsp;<%=backendUser==null?"[unknown]":backendUser.getFormattedNameAndUsername()%>&nbsp;&nbsp;&nbsp;</nobr></font></td>
		<td align="left" nowrap="nowrap"><font class="columnDataFont"><nobr>&nbsp;<%=workout.getCreateDate()==null?"[unknown]":defaultDateFormat.format(workout.getCreateDate())%>&nbsp;&nbsp;&nbsp;</nobr></font></td>
		<td align="left" nowrap="nowrap"><font class="columnDataFont"><%=HtmlUtils.smallCpFormButton(false, "edit", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=edit&id="+workout.getId()+"'", request, 70)%>
<%=HtmlUtils.smallCpFormButton(false, "copy", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=copy&id="+workout.getId()+"'", request, 70)%>
<%=HtmlUtils.smallCpFormButton(false, (workoutActive?"deactivate":"activate"), "location.href='showWorkout.jsp?"+controller.getSiteIdNVPair()+"&mode="+(workoutActive?"deactivate":"activate")+"&id="+workout.getId()+"'", request, 70)%>
<%
if (client==null) {
	%><%=HtmlUtils.smallCpFormButton(false, "assign", ""+((!workoutActive)?"generalAlert('Deactivated routines cannot be assigned; you must activate this routine first.')":"location.href='showWorkout.jsp?"+controller.getSiteIdNVPair()+"&mode=assign&id="+workout.getId()+"'"), request, 70)%>
	<%
}
%><img src="../images/spacer.gif" height="1" width="3" /><br />
		</font></td>
		<%=HtmlUtils.getSingleRuleCell(request)%>
		</tr> 
		<%=HtmlUtils.getHorizRuleTr(8, request)%>
	<%
	}
	%>
	
	
	
	</table>
		
	<%
}
%>

<br />



<%=HtmlUtils.cpFormButton(false, "to main menu", "location.href='menu.jsp?"+controller.getSiteIdNVPair()+"'", request)%><br />

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form>
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

