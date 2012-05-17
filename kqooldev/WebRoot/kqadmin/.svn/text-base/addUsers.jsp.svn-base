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
static final int NUM_USERS_ADD_AT_ONCE=10;
static final int MALE=User.MALE;
static final int FEMALE=User.FEMALE;

static void removeDuplicatesAndSort(List list) {
	Set set=new HashSet(list);
	list=new ArrayList(set);
	Collections.sort(list);
}
%>

<%

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

boolean single=controller.getParamAsBoolean("single", false);
boolean singleUserExists;

String existingUserFullname=null;
String existingUserUsername=null;

if (single) {
	User testUser=null;
	try {
		testUser=User.getByUsername(controller.getParam("username"));
		if (testUser==null) {
			throw new RuntimeException("User not found.");
		}
		singleUserExists=true;
		existingUserFullname=testUser.getFirstName()+" "+testUser.getLastName();
		existingUserUsername=testUser.getUsername();
	}
	catch (RuntimeException e) {
		singleUserExists=false;
	}
}
else {
	singleUserExists=false;
}

if (!single || !singleUserExists) {
String singleFirstName=null;
String singleLastName=null;
String singleUsername=null;
String singleEmailAddress=null;
int singleGender=FEMALE;

String fullname=null;
if (single) {
	singleFirstName=controller.getParam("firstName");
	singleLastName=controller.getParam("lastName");
	singleEmailAddress=controller.getParam("emailAddress");
	singleGender=controller.getParamAsInt("gender",FEMALE);
	singleUsername=controller.getParam("username");
	fullname=singleFirstName+" "+singleLastName;
	numUsersToAdd=1;
}


User user=controller.getSessionInfo().getUser();



String[] usernames=new String[numUsersToAdd];
String[] firstNames=new String[numUsersToAdd];
String[] lastNames=new String[numUsersToAdd];
String[] emailAddresses=new String[numUsersToAdd];
int[] genders=new int[numUsersToAdd];
String[] comments=new String[numUsersToAdd];
int[] trainerIds=new int[numUsersToAdd];
int[] siteIds=new int[numUsersToAdd];


for (int i=0; i<numUsersToAdd; i++)
{
	if (single) {
		usernames[i]=singleUsername;
		firstNames[i]=singleFirstName;
		lastNames[i]=singleLastName;
		emailAddresses[i]=singleEmailAddress;
		genders[i]=singleGender;
		comments[i]="";
		trainerIds[i]=-1;
		siteIds[i]=-1;
	}
	else {
		usernames[i]="";
		firstNames[i]="";
		lastNames[i]="";
		emailAddresses[i]="";
		genders[i]=FEMALE;
		comments[i]="";
		trainerIds[i]=-1;
		siteIds[i]=-1;
	}

}

List availableBackendUsers=User.getBackendUserChildren(currentUser.getId(), true);
availableBackendUsers=(availableBackendUsers==null?new ArrayList():availableBackendUsers);
// add the current user:
availableBackendUsers.add(0, currentUser);

removeDuplicatesAndSort(availableBackendUsers);
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

var availableBackendUserIdsToSiteIds=[]

<%

for (int i=0; i<availableBackendUsers.size(); i++) {
	User tempUsr=(User)availableBackendUsers.get(i);
	%>
	availableBackendUserIdsToSiteIds[<%=tempUsr.getId()%>]=<%=tempUsr.getSiteId()%>
	<%
}
%>
// add the current user:
availableBackendUserIdsToSiteIds[<%=currentUser.getId()%>]=<%=currentUser.getSiteId()%>




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
	var userSiteId=availableBackendUserIdsToSiteIds[userId]
	return (parseInt(userSiteId)==parseInt(siteId))
}


function isValidForm(formObj, single)
{
	if (!single && noUsersEntered(formObj,numUsersToAdd))
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
		if (single || els["username"+i].value.length>0)
		{ 

			var username=els["username"+i].value
			
			var rowSpecifier=""
			if (!single) {
				rowSpecifier=" on row "+(i+1)+" (for username '"+username+"')"
			}

			if (username.length==0)
			{				
				errorAlert("You have not entered a username"+rowSpecifier+"; please fix and try again.",els["username"+i])
				return false
			}			
			if (els["firstName"+i].value.length==0)
			{				
				errorAlert("You have not entered a first name"+rowSpecifier+"; please fix and try again.",els["firstName"+i])
				return false
			}
			if (els["lastName"+i].value.length==0)
			{
				errorAlert("You have not entered a last name"+rowSpecifier+"; please fix and try again.",els["lastName"+i])
				return false
			}
			if (els["emailAddress"+i].value.length==0)
			{
				errorAlert("You have not entered an email address"+rowSpecifier+"; please fix and try again.",els["emailAddress"+i])
				return false
			}
			if (!backendUserSiteMatchesSite(els["trainerId"+i], els["siteId"+i])) {
				errorAlert("The site of the backend user you've assigned the client to"+rowSpecifier+" does not match the site you've chosen on that row; please change one or the other and try again.",els["trainerId"+i])
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

<form action="processAddUsers.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this, <%=single%>)" name="mainForm" id="mainForm">
<input type="hidden" name="numUsers" id="numUsers" value="<%=usernames.length%>">
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">

<%
if (single) {
	%>
	<span class="firstSentenceFont">Create an account for <%=fullname%> here.</span><br />
	If <%=user.getGender()==User.MALE?"he":"she"%> has already made payment arrangements 
	(probably via PayPal, in which case
	you will have received email from PayPal with a subject such as
	"You have a new subscriber to Kqool.com standard membership"),
	then you should set <%=user.getGender()==User.MALE?"his":"her"%> status to "active."  Otherwise,
	you should set <%=user.getGender()==User.MALE?"his":"her"%> status to "preactive," and then follow up 
	with <%=user.getGender()==User.MALE?"him":"her"%> regarding payment.<%=HtmlUtils.doubleLB(request)%>
	
	Also, please indicate if this
	user should receive an email notifying <%=user.getGender()==User.MALE?"him":"her"%> that 
<%=user.getGender()==User.MALE?"his":"her"%> account has been
	created.  If <%=user.getGender()==User.MALE?"his":"her"%> status is "preactive," 
	then the email will 
	contain instructions about how to set up PayPal subscription payments.  If
	the status is "active," then the email will simply tell <%=user.getGender()==User.MALE?"him":"her"%> 
	that <%=user.getGender()==User.MALE?"he":"she"%> may now log into the site.</span><%=HtmlUtils.doubleLB(request)%>
	
	Please review the information below, then click the "add" button to create this user's account.<%=HtmlUtils.doubleLB(request)%><br />
	
	<%
}
else {
	%>
	<span class="firstSentenceFont">Add clients here.</span><br />
	Clients may sign up for a membership, pay for the membership with PayPal, and start
	using the site with no backend-user action needed.  However, sometimes you may wish to
	proactively create a client's account (for "special-case" clients who have made alternate payment
	arrangements, for example); do that here.  Note that you must specify whether each client you
	create is "preactive" or "active."  Preactive clients are clients who have not yet made payment arrangements
	for their site membership; active clients have.  Active clients may therefore start using their accounts
	immediately, while preactive clients are not allowed to log in until their status has been switched to
	"active" (presumably after they have made payment arrangements for their accounts).<br /><br />
	You may add up to 
<%=numUsersToAdd%> clients at a time. If you need to add fewer than that, 
leave the unneeded rows blank. </span><%=HtmlUtils.doubleLB(request)%><br />
	
	<%
}

if (single) {
%>
	

		<%=HtmlUtils.getSingleRuleCell(request)%>
		
		<font class="boldishFont">Username:</font><br />
		<input class="inputText" type="text" style="width:240px;" name="username0" id="username0" value="<%=usernames[0]%>"><%=HtmlUtils.doubleLB(request)%>
		
		<font class="boldishFont">First Name:</font><br />
		<input class="inputText" type="text" style="width:240px;" name="firstName0" id="firstName0" value="<%=firstNames[0]%>"><%=HtmlUtils.doubleLB(request)%>
		
		<font class="boldishFont">Last Name:</font><br />
		<input class="inputText" type="text" style="width:240px;" name="lastName0" id="lastName0" value="<%=lastNames[0]%>"><%=HtmlUtils.doubleLB(request)%>
		
		<font class="boldishFont">Email Address:</font><br />
		<input class="inputText" type="text" style="width:240px;" name="emailAddress0" id="emailAddress0" value="<%=emailAddresses[0]%>"><%=HtmlUtils.doubleLB(request)%><br />


	

	<span class="boldishFont">Initial User Status:</span><br />
	<input type="radio" name="status0" id="statusPreactive" value="preactive" checked="checked" /><label for="statusPreactive">preactive (payments not set up)</label><br />
	<input type="radio" name="status0" id="statusActive" value="active" /><label for="statusActive">active (payments set up)</label><br />
	<br />

	<span class="boldishFont">Gender:</span><br />
	<input type="radio" name="gender0" id="genderMale" value="<%=MALE%>" <%=singleGender==MALE?"checked":""%> /><label for="genderMale">male</label><br />
	<input type="radio" name="gender0" id="genderFemale" value="<%=FEMALE%>" <%=singleGender==FEMALE?"checked":""%>  /><label for="genderFemale">female</label><br />
	<br />
	
	<span class="boldishFont">Notification:</span><br />
	<input type="checkbox" name="sendMail0" value="true" id="sendMailTrue" checked="checked" /><label for="sendMailTrue">send notification email</label><br /><br />
	


	<span class="boldishFont">Site:</span><br />
	<select  name="siteId0" class="selectText">
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
	</select><br /><br />		

	

	

	<span class="boldishFont">Assign to Backend User:</span><br />
	<select  name="trainerId0" value="true" class="selectText">
	<%
	it=availableBackendUsers.iterator();
	User availableBackendUser;

	String siteLabel;
	while (it.hasNext()) {
		availableBackendUser=(User)it.next();
		siteLabel=(String)allSiteLabelsMap.get(new Integer(availableBackendUser.getSiteId()));
		%>
		<option value="<%=availableBackendUser.getId()%>"><%=availableBackendUser.getUsername()%> (<%=siteLabel%>)</option>
		<%
	}
	%>	
	</select><br /><br />



	<span class="boldishFont">Comments</span> (not visible to user):<br />	
	<textarea class="inputText" style="width:240px; height:100px;" rows="4" cols="20" name="comments0"><%=comments[0]%></textarea><br /><br />
<%
}


else { // not single:
%>
	
	<table border="0" cellspacing="0" cellpadding="0">
<%=HtmlUtils.getHorizRuleTr(13, request)%>
<tr class="headerRow" height="20">
<%=HtmlUtils.getSingleRuleCell(request)%>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Username&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;First&nbsp;Name&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Last&nbsp;Name&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Email&nbsp;Addr.&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Status&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Gender&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Email&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Site&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Assign&nbsp;to&nbsp;Backend&nbsp;User&nbsp;<br /></font></td>
<td valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Comments&nbsp;<br /></font></td>

<%=HtmlUtils.getSingleRuleCell(request)%>
</tr>
<%=HtmlUtils.getHorizRuleTr(13, request)%>

	 
	
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
		<td align="left"><font class="columnDataFont"><nobr>
		&nbsp;<input type="radio" name="status<%=i%>" id="statusPreactive<%=i%>" value="preactive" checked="checked" /><label for="statusPreactive<%=i%>">preactive</label>&nbsp;&nbsp;&nbsp;<br />
		&nbsp;<input type="radio" name="status<%=i%>" id="statusActive<%=i%>" value="active" /><label for="statusActive<%=i%>">active</label></nobr></font></td>
		<td align="left"><font class="columnDataFont"><nobr>
		&nbsp;<input type="radio" name="gender<%=i%>" id="genderMale<%=i%>" value="<%=MALE%>" <%=genders[i]==MALE?"checked":""%> /><label for=genderMale<%=i%>>male</label>&nbsp;&nbsp;&nbsp;<br />
		&nbsp;<input type="radio" name="gender<%=i%>" id="genderFemale<%=i%>" value="<%=FEMALE%>" <%=genders[i]==FEMALE?"checked":""%>  /><label for="genderFemale<%=i%>">female</label>&nbsp;&nbsp;&nbsp;</nobr></font></td>
		<td align="left"><font class="columnDataFont"><nobr><input type="checkbox" name="sendMail<%=i%>" value="true" id="sendMailTrue<%=i%>" checked="checked" /><label for="sendMailTrue<%=i%>">send</labe></nobr></font></td>
		<td align="left"><font class="columnDataFont"><select style="margin-left:14px;"  name="siteId<%=i%>" class="selectText">
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
		<td align="left"><font class="columnDataFont"><select class="selectText" style="margin-left:8px;" name="trainerId<%=i%>">
		<%
		it=availableBackendUsers.iterator();
		User availableBackendUser;
		String siteLabel;
		while (it.hasNext()) {
			availableBackendUser=(User)it.next();
			siteLabel=(String)allSiteLabelsMap.get(new Integer(availableBackendUser.getSiteId()));
			%>
			<option value="<%=availableBackendUser.getId()%>"><%=availableBackendUser.getUsername()%> (<%=availableBackendUser.getDefaultBackendUserTypeLabel().toLowerCase()%>, <%=siteLabel%>)</option>
			<%
		}
		%>
		</select><br /></font></td>
		<td align="left"><font class="columnDataFont"><textarea class="inputText" style="margin-left:5px; margin-top:2px; margin-bottom:2px; margin-right:3px;width:140px; height:50px;" rows="4" cols="20" name="comments<%=i%>"><%=comments[i]%></textarea><br /></font></td>
		
		<%=HtmlUtils.getSingleRuleCell(request)%>
		</tr>
		<%=HtmlUtils.getHorizRuleTr(13, request)%>
		<%
	}
	
	%>
	
	</table><br /><br />
	

<%
}
%>

<br />
<input type="hidden" name="single" value="<%=single%>" />
<%=HtmlUtils.cpFormButton(true, "add", null, request)%><br />

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form>
</div>

<%@ include file="/global/bodyClose.jsp" %>

</html>

<%
} // end if !single || !singleUserExists

else {
	controller.redirect("userExists.jsp?"+controller.getSiteIdNVPair()+"&n="+URLEncoder.encode(existingUserFullname)+"&u="+URLEncoder.encode(existingUserUsername));
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

