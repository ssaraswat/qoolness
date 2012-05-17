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
static final int NUM_USERS_ADD_AT_ONCE=3;
static final int MALE=User.MALE;
static final int FEMALE=User.FEMALE;

static void removeDuplicatesAndSort(List list) {
	if (list==null) {
		return;
	}
	Set set=new HashSet(list);
	list=new ArrayList(set);
	Collections.sort(list);
}

static void removeTrainers(List availableBackendParentUsers) {
	if (availableBackendParentUsers==null) {
		return;
	}
	Iterator i=availableBackendParentUsers.iterator();
	User user;
	while (i.hasNext()) {
		user=(User)i.next();
		if (user.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER) {
			i.remove();
		}
	}
}
%>

<%
boolean isTrainer=currentUser.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER;
boolean isSiteAdmin=currentUser.getBackendUserType()==User.BACKENDUSER_TYPE_SITE_ADMIN;
boolean isSuperAdmin=currentUser.getBackendUserType()==User.BACKENDUSER_TYPE_SUPER_ADMIN;

if (isTrainer) {
	// won't be thrown under normal circumstances:
	throw new JspException("Trainers should not reach this page.");
}
List allSites;
if (currentUser.isSuperAdmin()) {
	allSites=Site.getAll();
}
else {
	allSites=new ArrayList();
	allSites.add(Site.getById(currentUser.getSiteId()));
}
Map allSiteLabelsMap=new HashMap();
Iterator it=allSites.iterator();
while (it.hasNext()) {
	Site site=(Site)it.next();
	allSiteLabelsMap.put(new Integer(site.getId()), site.getLabel());
}

int numUsersToAdd=NUM_USERS_ADD_AT_ONCE;

User user=controller.getSessionInfo().getUser();



String[] usernames=new String[numUsersToAdd];
String[] firstNames=new String[numUsersToAdd];
String[] lastNames=new String[numUsersToAdd];
String[] emailAddresses=new String[numUsersToAdd];
int[] genders=new int[numUsersToAdd];
String[] comments=new String[numUsersToAdd];
int[] backendUserParentIds=new int[numUsersToAdd];
int[] backendUserTypes=new int[numUsersToAdd];
int[] siteIds=new int[numUsersToAdd];


for (int i=0; i<numUsersToAdd; i++)
{
	usernames[i]="";
	firstNames[i]="";
	lastNames[i]="";
	emailAddresses[i]="";
	genders[i]=FEMALE;
	comments[i]="";
	backendUserParentIds[i]=-1;
	backendUserTypes[i]=User.BACKENDUSER_TYPE_TRAINER;
	siteIds[i]=-1;
}

List availableBackendParentUsers=User.getBackendUserChildren(currentUser.getId(), true);
if (availableBackendParentUsers==null) {
	availableBackendParentUsers=new ArrayList();
}
removeTrainers(availableBackendParentUsers); // trainers can't add other backend users
removeDuplicatesAndSort(availableBackendParentUsers);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

var backendUserTypeTrainer=<%=User.BACKENDUSER_TYPE_TRAINER%>
var backendUserTypeSiteAdmin=<%=User.BACKENDUSER_TYPE_SITE_ADMIN%>
var backendUserTypeSuperAdmin=<%=User.BACKENDUSER_TYPE_SUPER_ADMIN%>

var backendUserIdsToSiteIds=[]
var backendUserIdsToTypes=[]
<%

for (int i=0; i<availableBackendParentUsers.size(); i++) {
	User tempUsr=(User)availableBackendParentUsers.get(i);
	%>
	backendUserIdsToSiteIds[<%=tempUsr.getId()%>]=<%=tempUsr.getSiteId()%>
	backendUserIdsToTypes[<%=tempUsr.getId()%>]=<%=tempUsr.getBackendUserType()%>
	<%
}
%>
// add the current user:
backendUserIdsToSiteIds[<%=currentUser.getId()%>]=<%=currentUser.getSiteId()%>
backendUserIdsToTypes[<%=currentUser.getId()%>]=<%=currentUser.getBackendUserType()%>

// add superadmins (types only):
backendUserIdsToTypes[<%=User.BACKEND_USER_PARENT_USER_ID_SUPERADMIN_PARENT%>]=<%=User.BACKENDUSER_TYPE_SUPER_ADMIN%>	

var username=<%=controller.getParam("username")==null?"null":"\""+controller.getParam("username")+"\""%>

var numUsersToAdd=<%=numUsersToAdd%>


<% pageContext.include("includes/writeAllUsernamesArray.jsp?jsVarName=allUsernames"); %>

function backendUserSiteMatchesSite(userSelectObj, siteSelectObj) {
	var userId=userSelectObj.options[userSelectObj.selectedIndex].value
	if (userId==0) {
		// user is super admin; any site is fine --
		return true;
	}
	var siteId=siteSelectObj.options[siteSelectObj.selectedIndex].value
	var userSiteId=backendUserIdsToSiteIds[userId]
	return (parseInt(userSiteId)==parseInt(siteId))
}

// note: returns an error message if not valid; else returns null (null means valid user type):
function validUserType(userSelectObj, newUserType, rowNumber) {
	var supervisingUserId=userSelectObj.options[userSelectObj.selectedIndex].value
	var supervisingUserType
	if (supervisingUserId==0) {
		supervisingUserType=backendUserTypeSuperAdmin
	}
	else {
		// remaining choice is site admin (trainer is not a possibility) --
		supervisingUserType=backendUserTypeSiteAdmin
	}
	if (parseInt(newUserType)==backendUserTypeTrainer) {
		// will never be problem here; only siteadmins and superadmins appear in the pulldown
		return null
	}
	else {
		// chosen user type for new user is site admin; just need to make sure that 
		// a super admin has been chosen
		if (supervisingUserType!=backendUserTypeSuperAdmin) {
			return "On row "+rowNumber+", you have chosen a site admin as the supervising backend user for a site admin.  Site admins cannot supervise other site admins.  Site admins can only supervise trainers.  Please change either the new user's user type or choose 'super admin' as the supervising backend user.";
		}
		else {
			return null;
		}
	}
}

function isValidForm(formObj)
{
	try {
		if (noUsersEntered(formObj,numUsersToAdd))
		{
			return false
		}
		var els=formObj.elements
		// we have at least one user; make sure that all users entered have all fields entered:
		var activeUsersAdded=0;
		var noProjectUserFound=false
		for (var i=0; i<numUsersToAdd; i++)
		{
			if (emptyRow(els, i)) {
				continue;
			}
			if (trim(els["username"+i].value).length>0)
			{ 
	
				var username=els["username"+i].value
				
				var rowSpecifier=rowSpecifier=" on row "+(i+1)+" (for username '"+username+"')"
	
				if (username.length==0)
				{				
					errorAlert("You have not entered a username"+rowSpecifier+"; please fix and try again.",els["username"+i])
					return false
				}			
				if (trim(els["firstName"+i].value).length==0)
				{				
					errorAlert("You have not entered a first name"+rowSpecifier+"; please fix and try again.",els["firstName"+i])
					return false
				}
				if (trim(els["lastName"+i].value).length==0)
				{
					errorAlert("You have not entered a last name"+rowSpecifier+"; please fix and try again.",els["lastName"+i])
					return false
				}
				if (els["emailAddress"+i].value.length==0)
				{
					errorAlert("You have not entered an email address"+rowSpecifier+"; please fix and try again.",els["emailAddress"+i])
					return false
				}
				if (!backendUserSiteMatchesSite(els["backendUserParentId"+i], els["siteId"+i])) {
					errorAlert("The supervising backend user's site"+rowSpecifier+" does not match the site you've chosen on that row; please change one or the other and try again.",els["backendUserParentId"+i])
					return false				
				}
				var newUserType
				var userTypeCheckboxObjTrainer=document.getElementById("backendUserType"+backendUserTypeTrainer+""+i)
				var userTypeCheckboxObjSiteAdmin=document.getElementById("backendUserType"+backendUserTypeSiteAdmin+""+i)
				if (userTypeCheckboxObjSiteAdmin==null) {
					// there's only one choice (trainer)
					newUserType=backendUserTypeTrainer
				}
				else {
					// else which one is checked? --
					newUserType=(userTypeCheckboxObjTrainer.checked?backendUserTypeTrainer:backendUserTypeSiteAdmin)
				}
				var validUserTypeMessage=validUserType(els["backendUserParentId"+i], newUserType, (i+1))
				if (validUserTypeMessage!=null) {
					errorAlert(validUserTypeMessage,els["backendUserParentId"+i])
					return false				
				}
			}
		}
	
		// user tried to add a username that was already in the db:
		if (duplicateUsernameFound(formObj,numUsersToAdd,username))
		{
			return false
		}
		// user tried to add two users with the same username:
		if (duplicateUsernamesInForm(formObj,numUsersToAdd))
		{
			return false
		}	
		if (badUsernameFound(formObj,numUsersToAdd))
		{
			return false
		}
		if (badEmailFound(formObj,numUsersToAdd))
		{
			return false
		}
		hidePageAndShowPleaseWait()
		return true
	}
	catch (e) {
		alert("JavaScript error validating form: "+e.message+".")
		return false;
	}
}

function emptyRow(els, i) {
	if (
		els["username"+i].value.length==0 &&
		els["firstName"+i].value.length==0 &&
		els["lastName"+i].value.length==0 &&
		els["emailAddress"+i].value.length==0 &&
		els["comments"+i].value.length==0
	) {
		return true;
	}
	return false;
}

<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<form action="processAddBackendUsers.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="numUsers" id="numUsers" value="<%=usernames.length%>">
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">


<span class="firstSentenceFont">Add backend users here.</span><br />
<%
if (isSiteAdmin) {
	%>
	User this screen to add to the list of trainers who report to you. 
	<%
}
else { // is superadmin
	%>
	User this screen to add site admins or trainers. 
	<%
}
%>
You may add up to <%=numUsersToAdd%> backend users at a time. If you need to add fewer than that, 
leave the unneeded rows blank. </span><%=HtmlUtils.doubleLB(request)%>

	<table border="0" cellspacing="0" cellpadding="0">
<%=HtmlUtils.getHorizRuleTr(12, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Username&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;First Name&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Last Name&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Email Addr.&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Gender&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;User&nbsp;Type&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Email&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Site&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Supervising&nbsp;Backend&nbsp;User&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Comments&nbsp;<br /></font></td>

<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(12, request)%>

	 
	
	<% 
	
	for (int i=0; i<numUsersToAdd; i++)
	{
		%>
		<tr valign="middle" class="<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%>" height="24">
		<%=HtmlUtils.getSingleRuleCell(request)%>
		<td align="left"><font class="columnDataFont">&nbsp;<%=(i+1)%>.<br /></font></td>
		<td align="left"><font class="columnDataFont"><input class="inputText" type="text" style="margin-left:5px; width:70px;" name="username<%=i%>" id="username<%=i%>" value="<%=usernames[i]%>"><br /></font></td>
		<td align="left"><font class="columnDataFont"><input class="inputText" type="text" style="margin-left:5px; width:70px;" name="firstName<%=i%>" id="firstName<%=i%>" value="<%=firstNames[i]%>"><br /></font></td>
		<td align="left"><font class="columnDataFont"><input class="inputText" type="text" style="margin-left:5px; width:70px;" name="lastName<%=i%>" id="lastName<%=i%>" value="<%=lastNames[i]%>"><br /></font></td>
		<td align="left"><font class="columnDataFont"><input class="inputText" type="text" style="margin-left:5px; width:70px;" name="emailAddress<%=i%>" id="emailAddress<%=i%>" value="<%=emailAddresses[i]%>"><br /></font></td>
		<input type="hidden" name="status<%=i%>" value="<%=User.STATUS_ACTIVE%>" />
		<td align="left"><font class="columnDataFont"><nobr>
		&nbsp;<input type="radio" name="gender<%=i%>" id="genderMale<%=i%>" value="<%=MALE%>" <%=genders[i]==MALE?"checked":""%> /><label for=genderMale<%=i%>>male</label>&nbsp;&nbsp;&nbsp;<br />
		&nbsp;<input type="radio" name="gender<%=i%>" id="genderFemale<%=i%>" value="<%=FEMALE%>" <%=genders[i]==FEMALE?"checked":""%>  /><label for="genderFemale<%=i%>">female</label>&nbsp;&nbsp;&nbsp;</nobr></font></td>
		
		<%
		if (isSuperAdmin) {
			%>
			<td align="left"><font class="columnDataFont"><nobr>
			&nbsp;<input type="radio" name="backendUserType<%=i%>" id="backendUserType<%=User.BACKENDUSER_TYPE_TRAINER%><%=i%>" value="<%=User.BACKENDUSER_TYPE_TRAINER%>" <%=backendUserTypes[i]==User.BACKENDUSER_TYPE_TRAINER?"checked":""%> /><label for=backendUserType<%=User.BACKENDUSER_TYPE_TRAINER%><%=i%>>trainer</label>&nbsp;&nbsp;&nbsp;<br />
			&nbsp;<input type="radio" name="backendUserType<%=i%>" id="backendUserType<%=User.BACKENDUSER_TYPE_SITE_ADMIN%><%=i%>" value="<%=User.BACKENDUSER_TYPE_SITE_ADMIN%>" <%=backendUserTypes[i]==User.BACKENDUSER_TYPE_SITE_ADMIN?"checked":""%>  /><label for="backendUserType<%=User.BACKENDUSER_TYPE_SITE_ADMIN%><%=i%>">site&nbsp;admin</label>&nbsp;&nbsp;&nbsp;</nobr></font></td>
			<%
		}
		else {
			%>
			<td align="left"><font class="columnDataFont"><nobr>
			&nbsp;<input type="radio" name="backendUserType<%=i%>" id="backendUserType<%=User.BACKENDUSER_TYPE_TRAINER%><%=i%>" value="<%=User.BACKENDUSER_TYPE_TRAINER%>" checked="checked" /><label for=backendUserType<%=User.BACKENDUSER_TYPE_TRAINER%><%=i%>>trainer</label>&nbsp;&nbsp;&nbsp;<br />
			&nbsp;<input disabled="disabled" type="radio" name="backendUserType<%=i%>" id="backendUserType<%=User.BACKENDUSER_TYPE_SITE_ADMIN%><%=i%>" value="<%=User.BACKENDUSER_TYPE_SITE_ADMIN%>"  /><span disabled="disabled" style="color:#999999;">site&nbsp;admin</span>&nbsp;&nbsp;&nbsp;</nobr></font></td>
			<%
		}
		%>
		<td align="left"><font class="columnDataFont"><nobr><input type="checkbox" name="sendMail<%=i%>" value="true" id="sendMailTrue<%=i%>" checked="checked" /><label for="sendMailTrue<%=i%>">send</labe></nobr></font></td>
		<td align="left"><font class="columnDataFont">
		<select style="margin-left:14px;"  name="siteId<%=i%>" class="selectText">
		<%
		it=allSites.iterator();
		Site availableSite;
	
		while (it.hasNext()) {
			availableSite=(Site)it.next();
			%>
			<option value="<%=availableSite.getId()%>"><%=availableSite.getLabel()%></option>
			<%
		}
		%>	
		</select><br/></font></td>
		<td align="left"><font class="columnDataFont">
		<select class="selectText" style="margin-left:8px;" name="backendUserParentId<%=i%>">
		<%
		if (isSuperAdmin) {
			%>
			<option value="<%=User.BACKEND_USER_PARENT_USER_ID_SUPERADMIN_PARENT%>">super admin</option>
			<%
		}
		else {
			%>
			<option value="<%=currentUser.getId()%>"><%=currentUser.getUsername()%> (<%=allSiteLabelsMap.get(new Integer(currentUser.getSiteId()))%>)</option>
			<%
		}

		it=availableBackendParentUsers.iterator();
		User availableBackendParentUser;
		String siteLabel;
		while (it.hasNext()) {
			availableBackendParentUser=(User)it.next();
			siteLabel=(String)allSiteLabelsMap.get(new Integer(availableBackendParentUser.getSiteId()));
			%>
			<option value="<%=availableBackendParentUser.getId()%>"><%=availableBackendParentUser.getUsername()%> (<%=availableBackendParentUser.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER?"trainer":"site admin"%>, <%=siteLabel%>)</option>
			<%
		}
		%>
		</select><br /></font></td>
		<td align="left"><font class="columnDataFont"><textarea class="inputText" style="margin-left:5px; margin-top:2px; margin-bottom:2px; margin-right:3px;width:140px; height:50px;" rows="4" cols="20" name="comments<%=i%>"><%=comments[i]%></textarea><br /></font></td>
		
		<%=HtmlUtils.getSingleRuleCell(request)%>
		</tr>
		<%=HtmlUtils.getHorizRuleTr(12, request)%>
		<%
	}
	
	%>
	
	</table><br />
	




<%=HtmlUtils.cpFormButton(true, "add", null, request)%><br />

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

