<%@ page import="com.theavocadopapers.hibernate.SessionWrapper" %>

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
static final String NO_COMMENTS_INDICATOR="<i>(none)</i>";

static final String[][] SORTS={
	{""+UserComparator.USERNAME,"Username"},
	{""+UserComparator.FIRST_NAME,"First Name"},
	{""+UserComparator.LAST_NAME,"Last Name"},
	{""+UserComparator.JOIN_DATE,"Join Date"},
	{""+UserComparator.LAST_ACCESS_DATE,"Last Login Date"},
};

static final String[][] SORT_ORDERS={
	{"asc","...in ascending order"},
	{"desc","...in descending order"},
};

static final String[][] LIST_LENGTH_LIMITS={
	{"9999999","[no limit]"},
	{"25","25 clients"},
	{"50","50 clients"},
	{"100","100 clients"},
	{"200","200 clients"},
};

static final String[][] PAST_DEADLINE_ONLY_OPTIONS={
	{"false","Show all clients (past-deadline or not)"},
	{"true","Show only clients with past-due routines"},

};


static final String[][] STATUSES={
	{"0","all clients"},
	{""+User.STATUS_PREACTIVE,"preactive clients only"},
	{""+User.STATUS_ACTIVE,"active clients only"},
	{""+User.STATUS_SUSPENDED,"suspended clients only"},
	{""+User.STATUS_DEACTIVATED,"deactivated clients only"},


};


public static String getCommaDelimitedTrainerIds(User user) {
	StringBuilder b=new StringBuilder(128);
	List mappings=ClientToBackendUserMapping.getByClientUserId(user.getId());
	mappings=(mappings==null?new ArrayList(0):mappings);
	Iterator it=mappings.iterator();
	ClientToBackendUserMapping mapping;
	int c=0;
	while (it.hasNext()) {
		if (c>0) {
			b.append(",");
		}
		mapping=(ClientToBackendUserMapping)it.next();
		b.append(mapping.getBackendUserId());
		c++;
	}
	return b.toString();
}

static DateFormat createdFormat=new SimpleDateFormat("MM/dd/yy");
static DateFormat accessedFormat=new SimpleDateFormat("MM/dd/yy");
%>

<%
//Opening a session here in the JSP tier.  This should not usually be
//done; doing it here because this page makes many db queries.  When
//we do do this, the entire JSP MUST be enclosed in a try block (and
//not the try block provided by the framework; an explicit one), and
//the session MUST be closed in a finally block.
SessionWrapper sessionWrapper=SessionWrapper.openIfNotOpen(null);
// also make it available to included JSPs:
request.setAttribute("sessionWrapper", sessionWrapper);
try {
		
	boolean doDisplay=(request.getParameter("doDisplay")!=null && request.getParameter("doDisplay").equals("true"));
	
	boolean showAll=controller.getParamAsBoolean("showAll",true);
	String mode=controller.getParam("mode","");
	int userStatusInt=controller.getParamAsInt("userStatus",0);
	
	Map allUsersMap=User.getAllAsMap(sessionWrapper);
	Map allPrimaryPhotosMap=Photo.getUserIdToPrimaryPhotoMap(sessionWrapper);
	
	List allSites=Site.getAll(sessionWrapper);
	Map allSitesMap=new HashMap(allSites.size());
	Iterator allSitesIt=allSites.iterator();
	while (allSitesIt.hasNext()) {
		Site site=(Site)allSitesIt.next();
		allSitesMap.put(new Integer(site.getId()), site);
	}
	
	
	String sortType=request.getParameter("sortType");
	sortType=(sortType!=null?sortType:SORTS[0][0]);
	String sortOrder=request.getParameter("sortOrder");
	sortOrder=(sortOrder!=null?sortOrder:SORT_ORDERS[0][0]);
	String listLengthLimit=request.getParameter("listLengthLimit");
	listLengthLimit=(listLengthLimit!=null?listLengthLimit:LIST_LENGTH_LIMITS[0][0]);
	String pastDeadlineOnly=request.getParameter("pastDeadlineOnly");
	pastDeadlineOnly=(pastDeadlineOnly!=null?pastDeadlineOnly:PAST_DEADLINE_ONLY_OPTIONS[0][0]);
	String userStatus=request.getParameter("userStatus");
	userStatus=(userStatus!=null?userStatus:""+User.STATUS_ACTIVE);
	
	String contains=controller.getParam("contains", "").trim();
	
	boolean sortAscending=(sortOrder.equals("asc"));
	int maxListLength=Integer.parseInt(listLengthLimit);
	boolean pastDeadlineUsersOnly=(pastDeadlineOnly.equals("true"));
	int showClientsOfBackendUserId=controller.getParamAsInt("showClientsOfBackendUserId", currentUser.getId());
	
	List rawAllUsers=new ArrayList();
	List allUsers=new ArrayList();
	if (doDisplay) {
		if (showClientsOfBackendUserId==0) { // indicates show all:
			rawAllUsers=User.getAll(sessionWrapper);
		}
		else {
			rawAllUsers=User.getBackendUserClients(showClientsOfBackendUserId, false, sessionWrapper);
		}
		if (rawAllUsers==null)
		{
			rawAllUsers=new ArrayList();
		}
		// FIRST, do sort:
		Collections.sort(rawAllUsers, new UserComparator(Integer.parseInt(sortType), sortAscending));
	
		allUsers=new ArrayList(rawAllUsers.size());
		
		ListIterator it=rawAllUsers.listIterator();
		int listSize=0;
		
	
		// SECOND, do all filtering:
		boolean doSearch=(contains.length()>0);
		String lcContains=contains.toLowerCase();
		while (it.hasNext()) {
			User user=(User)it.next();
			if (
				!user.isBackendUser() && 
				(userStatusInt==0 || userStatusInt==user.getStatus()) &&
				(!doSearch || ((user.getFirstName()+"|"+user.getLastName()+"|"+user.getUsername()).toLowerCase().indexOf(lcContains)>-1)) &&
				(!pastDeadlineUsersOnly || user.hasPastDueRoutines())	
			) {
				allUsers.add(user);
				listSize++;
			}
			
			if (listSize>=maxListLength) {
				break;
			}
		}
		
	
	}
	
	
	
	String[] usernames=new String[allUsers.size()];
	String[] firstNames=new String[allUsers.size()];
	String[] lastNames=new String[allUsers.size()];
	String[] comments=new String[allUsers.size()];
	String[] thumbUrls=new String[allUsers.size()];
	int[] thumbWidths=new int[allUsers.size()];
	int[] thumbHeights=new int[allUsers.size()];
	String[] emailAddresses=new String[allUsers.size()];
	Date[] createDates=new Date[allUsers.size()];
	Date[] accessedDates=new Date[allUsers.size()];
	int[] ids=new int[allUsers.size()];
	int[] statuses=new int[allUsers.size()];
	String[] commaDelimitedTrainerIds=new String[allUsers.size()];
	int[] genders=new int[allUsers.size()];
	Date[] birthDates=new Date[allUsers.size()];
	
	Photo primaryPhotoThumb;
	User user;
	for (int i=0; i<allUsers.size(); i++)
	{
		user=(User)allUsers.get(i);
		primaryPhotoThumb=(Photo)allPrimaryPhotosMap.get(new Integer(user.getId()));
		usernames[i]=user.getUsername();
		firstNames[i]=user.getFirstName();
		lastNames[i]=user.getLastName();
		comments[i]=user.getCommentsUserHidden();
		thumbUrls[i]=(primaryPhotoThumb==null?null:primaryPhotoThumb.getRelativeToRootMainURL(request));
		thumbWidths[i]=(primaryPhotoThumb==null?0:primaryPhotoThumb.getThumbWidth());
		thumbHeights[i]=(primaryPhotoThumb==null?0:primaryPhotoThumb.getThumbHeight());
		thumbUrls[i]=(primaryPhotoThumb==null?null:primaryPhotoThumb.getRelativeToRootMainURL(request));
		emailAddresses[i]=user.getEmailAddress();
		createDates[i]=user.getJoinDate();
		accessedDates[i]=user.getLastAccessDate();
		ids[i]=user.getId();
		statuses[i]=user.getStatus();
		commaDelimitedTrainerIds[i]=getCommaDelimitedTrainerIds(user);
		genders[i]=user.getGender();
		birthDates[i]=user.getBirthDate();
	}
	
	%>
	
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
	<html>
	<head>
	 
	<%@ include file="/global/headInclude.jsp" %>
	<%@ include file="/global/validationJs.jsp" %>
	
	
	<script type="text/javascript">
	
	var NO_COMMENTS_INDICATOR="<%=NO_COMMENTS_INDICATOR%>"
	
	var numUsers=<%=allUsers.size()%>
	
	<% pageContext.include("includes/writeAllUsernamesArray.jsp?jsVarName=allUsernames"); %>
	
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
		
		
	function clickButton(i) {
		var radioBtn
		if (document.all) {
			radioBtn=document.all["associateWithAllProjects"+i+"false"]
		}
		if (document.getElementById) {
			radioBtn=document.getElementById("associateWithAllProjects"+i+"false")
		}
		radioBtn.checked=true
	}
	
	
	function editComments(id) {
		var currComment
		if (document.getElementById) {
			currComment=document.getElementById("commentsDiv"+id).innerHTML
		}
		else {
			currComment=document.all["commentsDiv"+id].innerHTML
		}
		if (trim(currComment).toLowerCase()==NO_COMMENTS_INDICATOR.toLowerCase()) {
			currComment=""
		}
		openWin("editComment.jsp?<%=controller.getSiteIdNVPair()%>&isPopup=true&id="+id+"&c="+escape(currComment)+"", "comments"+id, 350, 380, false)
	}
	
	function setComments(id, s) {
		if (trim(s).length==0) {
			s=NO_COMMENTS_INDICATOR
		}
		if (document.getElementById) {
			document.getElementById("commentsDiv"+id).innerHTML=s
		}
		else {
			document.all["commentsDiv"+id].innerHTML=s
		}
	
	}
	
	function isValidForm(formObj)
	{
		var els=formObj.elements
		// we have at least one user; make sure that all users entered have all fields entered:
		var totalActiveUsersCount=0
		for (var i=0; i<numUsers; i++)
		{
			if (trim(els["username"+i].value).length>0)
			{ 
				var username=els["username"+i].value
				if (els["firstName"+i].value.length==0)
				{
					errorAlert("You have not entered a first name on row "+(i+1)+" (for username '"+username+"'); please fix and try again.",els["firstName"+i])
					return false
				}
				if (els["lastName"+i].value.length==0)
				{
					errorAlert("You have not entered a last name on row "+(i+1)+" (for username '"+username+"'); please fix and try again.",els["lastName"+i])
					return false
				}
				if (els["emailAddress"+i].value.length==0)
				{
					errorAlert("You have not entered an email address on row "+(i+1)+" (for username '"+username+"'); please fix and try again.",els["emailAddress"+i])
					return false
				}
			}
	
		}
	
	
		if (duplicateUsernamesInForm(formObj,numUsers))
		{
			return false
		}
		if (badUsernameFound(formObj,numUsers))
		{
			return false
		}
		if (badEmailFound(formObj,numUsers))
		{
			return false
		}
		if (demoCheck()) {
			return false
		}
		hidePageAndShowPleaseWait()
		return true
	} 
	
	function switchDisplayMode(showAll)
	{
		top.location.href="users.jsp?<%=controller.getSiteIdNVPair()%>&showAll="+(showAll?"true":"false");
	}
	
	<% pageContext.include("js/js.jsp"); %>
	
	</script>
	
	<style type="text/css">
	
	.actionFormButton {margin:2px; margin-bottom:1px; font-size:11px; font-family:arial,helvetica; width:40px; background-color:#ff6600; border:1px solid #000000; color:#ffffff; }
	
	</style>
	</head>
	
	<%@ include file="/global/bodyOpen.jsp" %>
	
	<div id="mainDiv">
	  
	<form action="users.jsp" method="get" onsubmit="return true" name="mainForm" id="mainForm">
	<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
	<input type="hidden" name="doDisplay" value="true" />
	
	<font class="bodyFont">
	<span class="standardAdminTextBlockWidth">
	<%
	int statusAction=controller.getParamAsInt("statusAction",0);
	
	if (statusAction>0) {
		String newStatus;
		boolean mailSent=false;
		switch (statusAction) {
			case User.STATUS_ACTIVE: newStatus="active"; mailSent=true; break;
			case User.STATUS_DEACTIVATED: newStatus="deactivated"; break;
			case User.STATUS_SUSPENDED: newStatus="suspended"; break;
			default: newStatus="";
		}
	
		%>
		<div style="color:#000000; border:1px solid #000000; 
		padding:5px; background-color:#ff6600;">
		<i><b>Note:</b> The status of user <%=controller.getParam("name")%> has been set to
		<%=newStatus%>. A notification email <%=mailSent?"has":"<b>has not</b>"%> been sent to the user.</i></div><br />
		<%
	}
	
	if (mode.equals("add")) {
		%>
		<div style="color:#000000; border:1px solid #000000; 
		padding:5px; background-color:#ff6600;">
		<i>Your additions have been made; you may view users below.</i></div><br />
		
		<%
	}
	int action=controller.getParamAsInt("action",0);
	if (action==User.STATUS_SUSPENDED || action==User.STATUS_DEACTIVATED) {
		%>
		<div style="color:#000000; border:1px solid #000000; 
		padding:5px; background-color:#ff6600;">
		<i>Note: <%=controller.getParam("n")%>'s account has been <%=action==User.STATUS_SUSPENDED?"suspended":"deactivated"%>. This user will not be able to enter the site again until his or her status us set back to "active."</i></div><br />
		
		<%
	}
	%>
	
	<span class="firstSentenceFont">View all your clients here.</span><br />
	<%
	if (!doDisplay) {
		// user hadn't entered any display criteria yet:
		%>
		To view clients, please choose view options below, and then press the "view client list" button.
		<%
	}
	else {
		%>You may assign routines to clients, change their status, see workouts recorded by clients, or view and edit client data by clicking the
	appropriate "view/edit" button.  To re-sort or filter this list, please choose new view options below, and then press the "view client list" button.<%
	}
	%>
	
	<br /><br />
	
	
	
	
	</span>
	
	<div style="border:1px solid #999999; xbackground-color:#eeeeee; padding:4px;">
	<div style="padding:2px; background-color:#cccccc; font-weight:bold;">View options:</div><br/>
	
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Filter by status: show...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="userStatus">
	<%
	
	
	for (int i=0; i<STATUSES.length; i++) {
		%>
		<option value="<%=STATUSES[i][0]%>" <%=userStatus.equals(STATUSES[i][0])?" selected ":""%>><%=STATUSES[i][1]%></option>
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
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Sort clients by...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="sortType">
	<%
	
	
	for (int i=0; i<SORTS.length; i++) {
		%>
		<option value="<%=SORTS[i][0]%>" <%=sortType.equals(SORTS[i][0])?" selected ":""%>><%=SORTS[i][1]%></option>
		<%
	}
	%>
	</select><select style="margin-left:5px;" class="selectText" name="sortOrder">
	<%
	for (int i=0; i<SORT_ORDERS.length; i++) {
		%>
		<option value="<%=SORT_ORDERS[i][0]%>" <%=sortOrder.equals(SORT_ORDERS[i][0])?" selected ":""%>><%=SORT_ORDERS[i][1]%></option>
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
	<td colspan="8"><select class="selectText" name="listLengthLimit">
	<%
	
	
	for (int i=0; i<LIST_LENGTH_LIMITS.length; i++) {
		%>
		<option value="<%=LIST_LENGTH_LIMITS[i][0]%>" <%=listLengthLimit.equals(LIST_LENGTH_LIMITS[i][0])?" selected ":""%>><%=LIST_LENGTH_LIMITS[i][1]%></option>
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
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Past-deadline clients...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="pastDeadlineOnly">
	<%
	
	
	for (int i=0; i<PAST_DEADLINE_ONLY_OPTIONS.length; i++) {
		%>
		<option value="<%=PAST_DEADLINE_ONLY_OPTIONS[i][0]%>" <%=pastDeadlineOnly.equals(PAST_DEADLINE_ONLY_OPTIONS[i][0])?" selected ":""%>><%=PAST_DEADLINE_ONLY_OPTIONS[i][1]%></option>
		<%
	}
	%>
	</select>
	
	
	</td>
	</tr>
	
	<%
	List backendUserChildren=User.getBackendUserChildren(currentUser.getId(), false, sessionWrapper);
	backendUserChildren=(backendUserChildren==null?new ArrayList():backendUserChildren);
	User backendUserChild;
	int backendUserChildrenSize=backendUserChildren.size();
	if (backendUserChildrenSize==0) {
		%>
		<input type="hidden" name="showClientsOfBackendUserId" value="<%=currentUser.getId()%>" />
		<%
	}
	else {
		%>
	
		<tr>
		<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
		</tr>
		<tr>
		<td align="right" nowrap="nowrap" class="bodyFont"><i>Show clients of...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
		<td colspan="8"><select class="selectText" name="showClientsOfBackendUserId">
		<%
		if (currentUser.isSuperAdmin()) {
			%>
			<option value="0">all backend users</option>
			<%
		}
		else {
			%>
			// user is site admin; trainers wouldn't get here --
			<option value="<%=currentUser.getId()%>"><%=currentUser.getUsername()%> (my clients)</option>
			<%
		}
		%>
		
	
		<%
	
		
		for (int i=0; i<backendUserChildrenSize; i++) {
			backendUserChild=(User)backendUserChildren.get(i);
			%>
			<option value="<%=backendUserChild.getId()%>" <%=backendUserChild.getId()==showClientsOfBackendUserId?" selected ":""%>><%=backendUserChild.getUsername()%> (<%=backendUserChild.getDefaultBackendUserTypeLabel().toLowerCase()%>, <%=((Site)allSitesMap.get(new Integer(backendUserChild.getSiteId()))).getLabel()%>) <%=(backendUserChild.getStatus()!=User.STATUS_ACTIVE?" [*not active*]":"")%></option>
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
		<td align="right" nowrap="nowrap" class="bodyFont"><i>Name or username contains...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
		<td colspan="8"><input type="text" name="contains" value="<%=contains%>" class="inputText" style="width:130px;" /><br/>
		
		
		</td>
		</tr>	
		<%
	}
	%>
	<tr>
	<td></td>
	<td colspan="4"><input style="margin-top:12px; " type="submit" value="view client list" class="controlPanelSmallButton"></td>
	</tr>
	</table>
	<br/>
	
	</div><br/>
	
	<%
	if (doDisplay && allUsers.size()==0) {
		%><i style="color:#ff6600;">No clients match your "view options" criteria above.<br/></i><%
	}
	else if (doDisplay && allUsers.size()>0) {
	%>
		<table border="0" cellspacing="0" cellpadding="0">
		<%=HtmlUtils.getHorizRuleTr(10, request)%>
		<tr class="headerRow" height="20">
		<%=HtmlUtils.getSingleRuleCell(request)%>
		<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
		<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;User&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;Comments <span style="font-weight:normal;">(not user-visible)</span>&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;Primary&nbsp;Photo&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td valign="middle" align="left" nowrap="nowrap"><font class="boldishColumnHeaderFont">&nbsp;Dates&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;Assigned to Backend User(s)&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;Actions&nbsp;&nbsp;&nbsp;<br /></font></td>
		
		<%=HtmlUtils.getSingleRuleCell(request)%>
		</tr>
		<%=HtmlUtils.getHorizRuleTr(10, request)%>
		
		<% 
	
		for (int i=0; i<usernames.length; i++)
		{
			%>
		
			<tr valign="top" class="<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%>" height="24">
			<%=HtmlUtils.getSingleRuleCell(request)%>
			<td align="left" valign="top"><font class="columnDataFont">&nbsp;<%=(i+1)%>.&nbsp;<br /></font></td>
			<td align="left"><font class="columnDataFont">username: <%=usernames[i]%>&nbsp;&nbsp;<br />
			<nobr>full name: <%=lastNames[i]%>, <%=firstNames[i]%>&nbsp;&nbsp;</nobr><br />
			email: <a href="mailto:<%=emailAddresses[i]%>"><%=PageUtils.truncate(emailAddresses[i],20)%></a>&nbsp;&nbsp;<br />
			status: <%
			switch (statuses[i]) {
				case User.STATUS_ACTIVE: out.print("active"); break;
				case User.STATUS_PREACTIVE: out.print("preactive"); break;
				case User.STATUS_DEACTIVATED: out.print("deactivated"); break;
				case User.STATUS_SUSPENDED: out.print("suspended"); break;
				default: out.print("unknown");
			}
			
			%>&nbsp;&nbsp;<br />
			
			<b><a href="../workouts/calorieSpreadsheet.jsp?<%=controller.getSiteIdNVPair()%>&viewUserId=<%=ids[i]%>" target="_blank">[view calorie spreadsheets]</a></b></font></td>
			<td align="left"><div id="commentsDiv<%=ids[i]%>" style="width:200px; margin-left:5px; margin-right:5px;" class="columnDataFont"><%=(comments[i].length()==0?NO_COMMENTS_INDICATOR:comments[i])%></div></td>
			<%
			if (thumbUrls[i]!=null) {
				%>
				<td align="center" nowrap="nowrap" width="62"><img src="<%=thumbUrls[i]%>" height="<%=thumbHeights[i]%>" style="margin-top:3px;"  width="<%=thumbWidths[i]%>" /></td>
				<%
			}
			else {
				%>
				<td align="center" nowrap="nowrap" width="62"><img src="../images/noThumbPhoto.gif" height="65" width="50" style="margin-top:3px;" /></td>
				<%
			}
			%>
			<td align="left"><font class="columnDataFont" nowrap="nowrap"><nobr>
			joined: <%=createdFormat.format(createDates[i])%>&nbsp;&nbsp;<br />
			last login: <%=createdFormat.format(accessedDates[i])%>&nbsp;&nbsp;<br />
			birthdate: <%=birthDates[i]==null?"<i>unknown</i>":createdFormat.format(birthDates[i])%>&nbsp;&nbsp;<br />
			</font></nobr></td>
			<td align="left" nowrap="nowrap"><font class="columnDataFont"><div style="padding:0px 3px 0px 3px;"><%
			String[] trainerIds=commaDelimitedTrainerIds[i].split(",");
			User trainerUser;
			for (int j=0; j<trainerIds.length; j++) {
				try {
					trainerUser=(User)allUsersMap.get(new Integer(Integer.parseInt(trainerIds[j])));
				}
				catch (NumberFormatException e) {
					continue;
				}
				%><nobr><%=trainerUser.getLastName()%>, <%=trainerUser.getFirstName()%> (<%=trainerUser.getUsername()%>)<br/>
				&nbsp;&nbsp;&nbsp;(<%=trainerUser.getDefaultBackendUserTypeLabel()%>,
				<%=((Site)allSitesMap.get(new Integer(trainerUser.getSiteId()))).getLabel()%>)<br/></nobr><%
			}
			%></div></font></td>
			
			<td align="left" xvalign="middle"><div style="padding:0px 3px 0px 5px;"><font class="columnDataFont">
			<%=HtmlUtils.smallCpFormButton(false, "view/edit", "location.href='user.jsp?"+controller.getSiteIdNVPair()+"&id="+ids[i]+"'", request)%></font></div></td>
		
			<%=HtmlUtils.getSingleRuleCell(request)%>
			</tr> 
			<%=HtmlUtils.getHorizRuleTr(10, request)%>
			<%
		}
		
		%>
		
		</table><br />
	<%
	}
	
	%><br/><br/>
	<%=HtmlUtils.cpFormButton(false, "to main menu", "location.href=('menu.jsp?"+controller.getSiteIdNVPair()+"')", request)%><br />
	
	<%=HtmlUtils.doubleLB(request)%><br />
	
	
	<br /></font>
	
	</form>
	</div>
	
	<%@ include file="/global/bodyClose.jsp" %>
	
	</html><%
}
finally {
	SessionWrapper.closeIfNotNested(sessionWrapper);
}
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

