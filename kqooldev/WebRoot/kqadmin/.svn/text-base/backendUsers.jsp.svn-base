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
	{"25","25 backend users"},
	{"50","50 backend users"},
	{"100","100 backend users"},
	{"200","200 backend users"},
};




static final String[][] STATUSES={
	{"0","all backend users"},
	{""+User.STATUS_ACTIVE,"active backend users only"},
	{""+User.STATUS_SUSPENDED,"suspended backend users only"},
	{""+User.STATUS_DEACTIVATED,"deactivated backend users only"},


};


public static String getCommaDelimitedClientIds(User user) {
	StringBuilder b=new StringBuilder(128);
	List mappings=ClientToBackendUserMapping.getByBackendUserId(user.getId());
	mappings=(mappings==null?new ArrayList(0):mappings);
	Iterator it=mappings.iterator();
	ClientToBackendUserMapping mapping;
	int c=0;
	while (it.hasNext()) {
		if (c>0) {
			b.append(",");
		}
		mapping=(ClientToBackendUserMapping)it.next();
		b.append(mapping.getClientUserId());
		c++;
	}
	return b.toString();
}

static DateFormat createdFormat=new SimpleDateFormat("MM/dd/yy");
static DateFormat accessedFormat=new SimpleDateFormat("MM/dd/yy");

%>

<%

boolean doDisplay=(request.getParameter("doDisplay")!=null && request.getParameter("doDisplay").equals("true"));

boolean showAll=controller.getParamAsBoolean("showAll",true);
String mode=controller.getParam("mode","");
int userStatusInt=controller.getParamAsInt("userStatus",0);

Map allUsersMap=User.getAllAsMap();

List allSites=Site.getAll();
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
String userStatus=request.getParameter("userStatus");
userStatus=(userStatus!=null?userStatus:""+User.STATUS_ACTIVE);

boolean sortAscending=(sortOrder.equals("asc"));
int maxListLength=Integer.parseInt(listLengthLimit);
int showSuperviseesOfBackendUserId=controller.getParamAsInt("showSuperviseesOfBackendUserId", currentUser.getId());

List rawAllUsers=new ArrayList();
List allUsers=new ArrayList();
if (doDisplay) {
	User supervisingBackendUser=User.getById(showSuperviseesOfBackendUserId);
	if (supervisingBackendUser==null) {
		supervisingBackendUser=new User();
	}
	rawAllUsers=null;
	if (supervisingBackendUser.getId()==0 || supervisingBackendUser.isSuperAdmin()) {
		rawAllUsers=User.getAllBackendUsers(false);
	}
	else {
		rawAllUsers=User.getBackendUserChildren(showSuperviseesOfBackendUserId, false);
		rawAllUsers=(rawAllUsers==null?new ArrayList():rawAllUsers);
		//rawAllUsers.add(0, User.getById(showSuperviseesOfBackendUserId));
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
	while (it.hasNext()) {
		User user=(User)it.next();
		if (
			(userStatusInt==0 || userStatusInt==user.getStatus())
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
String[] emailAddresses=new String[allUsers.size()];
Date[] createDates=new Date[allUsers.size()];
Date[] accessedDates=new Date[allUsers.size()];
int[] ids=new int[allUsers.size()];
int[] statuses=new int[allUsers.size()];
String[] commaDelimitedClientIds=new String[allUsers.size()];
int[] genders=new int[allUsers.size()];
Date[] birthDates=new Date[allUsers.size()];

for (int i=0; i<allUsers.size(); i++)
{
	User user=(User)allUsers.get(i);
	usernames[i]=user.getUsername();
	firstNames[i]=user.getFirstName();
	lastNames[i]=user.getLastName();
	comments[i]=user.getCommentsUserHidden();
	emailAddresses[i]=user.getEmailAddress();
	createDates[i]=user.getJoinDate();
	accessedDates[i]=user.getLastAccessDate();
	ids[i]=user.getId();
	statuses[i]=user.getStatus();
	commaDelimitedClientIds[i]=getCommaDelimitedClientIds(user);
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
		case 3 : status="suspended"; break;
		case 4 : status="deactivated"; break;
		default : status="unknown"
	}
	if (generalConfirm(fullname+"'s account status is \""+status+"\"; about to re-activate and send notification email.  Okay to proceed?")) {
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
		if (els["username"+i].value.length>0)
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
	top.location.href="backendUsers.jsp?<%=controller.getSiteIdNVPair()%>&showAll="+(showAll?"true":"false");
}

<% pageContext.include("js/js.jsp"); %>

</script>

<style type="text/css">

.actionFormButton {margin:2px; margin-bottom:1px; font-size:11px; font-family:arial,helvetica; width:40px; background-color:#ff6600; border:1px solid #000000; color:#ffffff; }

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
  
<form action="backendUsers.jsp" method="get" onsubmit="return true" name="mainForm" id="mainForm">
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
	<i>Your additions have been made; you may view backend users below.</i></div><br />
	
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

<span class="firstSentenceFont">View all backend users here.</span><br />
<%
if (!doDisplay) {
	// user hadn't entered any display criteria yet:
	%>
	To view backend users (trainers and/or site admins), please choose view options below, and then press the "view backend users" button.
	<%
}
else {
	%>You may view or edit backend users' (trainers' and/or site admins') data by clicking the
appropriate "view/edit" button below.  To re-sort or filter this list, please choose new view options below, and then press the "view backend users" button.<%
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
<td align="right" nowrap="nowrap" class="bodyFont"><i>Sort users by...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
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


<%
List backendUserChildren=User.getBackendUserChildren(currentUser.getId(), false);
backendUserChildren=(backendUserChildren==null?new ArrayList():backendUserChildren);
User backendUserChild;
int backendUserChildrenSize=backendUserChildren.size();
if (backendUserChildrenSize==0) {
	%>
	<input type="hidden" name="showSuperviseesOfBackendUserId" value="<%=currentUser.getId()%>" />
	<%
}
else {
	%>

	<tr>
	<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
	</tr>
	<tr>
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Show backend users supervised by...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="showSuperviseesOfBackendUserId">
	<%
	if (currentUser.isSuperAdmin()) {
		%>
		<option value="0">anyone</option>
		<%
	}
	else {
		%>
		// user is site admin; trainers wouldn't get here --
		<option value="<%=currentUser.getId()%>"><%=currentUser.getUsername()%> (users I supervise)</option>
		<%
	}
	%>
	

	<%

	
	for (int i=0; i<backendUserChildrenSize; i++) {
		backendUserChild=(User)backendUserChildren.get(i);
		if (backendUserChild.getBackendUserType()!=User.BACKENDUSER_TYPE_TRAINER) { // trainers don't supervise anyone, so don't show them here --
			%>
			<option value="<%=backendUserChild.getId()%>" 
			<%=backendUserChild.getId()==showSuperviseesOfBackendUserId?" selected ":""%>><%=backendUserChild.getUsername()%> 
			(<%=backendUserChild.getDefaultBackendUserTypeLabel().toLowerCase()%>, 
			<%=((Site)allSitesMap.get(new Integer(backendUserChild.getSiteId()))).getLabel()%>) 
			<%=(backendUserChild.getStatus()!=User.STATUS_ACTIVE?" [*not active*]":"")%></option>
			<%
		}
	}
	%>
	</select>
	
	
	</td>
	</tr>	
	<%
}
%>
<tr>
<td></td>
<td colspan="4"><input style="margin-top:12px; " type="submit" value="view backend users" class="controlPanelSmallButton"></td>
</tr>
</table>
<br/>

</div><br/>

<%
if (doDisplay && allUsers.size()==0) {
	%><i style="color:#ff6600;">No backend users match your "view options" criteria above.<br/></i><%
}
else if (doDisplay && allUsers.size()>0) {
%>
	<table border="0" cellspacing="0" cellpadding="0">
	<%=HtmlUtils.getHorizRuleTr(9, request)%>
	<tr class="headerRow" height="20">
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
	<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;User&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;Comments <span style="font-weight:normal;">(not user-visible)</span>&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;Dates&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;Clients&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td valign="middle" align="left"><font class="boldishColumnHeaderFont">&nbsp;Actions&nbsp;&nbsp;&nbsp;<br /></font></td>
	
	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr>
	<%=HtmlUtils.getHorizRuleTr(9, request)%>
	
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
			case User.STATUS_DEACTIVATED: out.print("deactivated"); break;
			case User.STATUS_SUSPENDED: out.print("suspended"); break;
			default: out.print("unknown");
		}
		
		%>&nbsp;&nbsp;<br />
		
		</font></td>
		<td align="left"><div id="commentsDiv<%=ids[i]%>" style="width:200px; margin-left:5px; margin-right:5px;" class="columnDataFont"><%=(comments[i].length()==0?NO_COMMENTS_INDICATOR:comments[i])%></div></td>
		<td align="left" nowrap="nowrap"><nobr><font class="columnDataFont">
		joined: <%=createdFormat.format(createDates[i])%>&nbsp;&nbsp;<br />
		last login: <%=createdFormat.format(accessedDates[i])%>&nbsp;&nbsp;<br />
		birthdate: <%=birthDates[i]==null?"<i>unknown</i>":createdFormat.format(birthDates[i])%>&nbsp;&nbsp;<br />
		</font></nobr></td>
		<td align="left"><font class="columnDataFont"><div style="padding:0px 3px 0px 3px;"><%
		if (commaDelimitedClientIds[i]==null) {
			commaDelimitedClientIds[i]="";
		}
		String[] clientIds=commaDelimitedClientIds[i].split(",");
		User clientUser;
		for (int j=0; j<clientIds.length; j++) {
			try {	
				clientUser=(User)allUsersMap.get(new Integer(Integer.parseInt(clientIds[j])));
			}
			catch (NumberFormatException e) {
				continue;
			}
			if (clientUser==null) {
				continue;
			}
			%><nobr><%=clientUser.getFormattedNameAndUsername()%>
			(<%=((Site)allSitesMap.get(new Integer(clientUser.getSiteId()))).getLabel()%>)<br/></nobr><%
		}
		%></div></font></td>
		
		<td align="left"><font class="columnDataFont"><%

		%><img src="../images/spacer.gif" height="3" width="1"><br />
		<div style="padding:0px 3px 0px 5px;"><%=HtmlUtils.smallCpFormButton(false, "view/edit", "location.href='backendUser.jsp?"+controller.getSiteIdNVPair()+"&id="+ids[i]+"'", request)%></div><br /><br/>
	<img src="../images/spacer.gif" height="3" width="1"><br /></font></td>
	
		<%=HtmlUtils.getSingleRuleCell(request)%>
		</tr> 
		<%=HtmlUtils.getHorizRuleTr(9, request)%>
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

