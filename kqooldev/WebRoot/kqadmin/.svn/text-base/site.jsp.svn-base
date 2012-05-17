<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.ExerciseComparator" %>

<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_OTHER,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!
static final String[][] UI_TYPES={
	{""+Site.UI_TYPE_KQOOL_PROPER, "Kqool.com proper"},
	{""+Site.UI_TYPE_SKINNABLE_LITE, "skinnable lite"},
	{""+Site.UI_TYPE_SKINNABLE_MEDIUM, "skinnable medium"},
	{""+Site.UI_TYPE_SKINNABLE_FULL, "fully skinnable"},
};
%>

<%

User user=controller.getSessionInfo().getUser();

// we should not encounter this under normal curcumstances:
if (!user.isSuperAdmin()) {
	throw new RuntimeException("This page is only accessable to super admins.  This user is not a super admin.");
}


int id=controller.getParamAsInt("id",0);
String label;
int uiType;
boolean canShareClients;
String domainPrefix;
String comments;
int primaryContactUserId;


Site site=null;

// possible modes: add, edit:
String mode=controller.getParam("mode","add");


if (mode.equals("add")) {
	label="";
	uiType=Site.UI_TYPE_SKINNABLE_LITE;
	primaryContactUserId=0;
	canShareClients=true;
	domainPrefix="";
	comments="";
}
else if (mode.equals("edit")) {
	site=Site.getById(id);
	label=PageUtils.nonNull(site.getLabel());
	uiType=site.getUiType();
	primaryContactUserId=site.getPrimaryContactUserId();
	canShareClients=site.isCanShareClients();
	domainPrefix=PageUtils.nonNull(site.getDomainPrefix());
	comments=PageUtils.nonNull(site.getComments());
	

}
else {
	throw new RuntimeException("Unrecognized mode.");
}

List allSitesExceptCurrent=Site.getAll();
List allLabelsExceptCurrent=new ArrayList(allSitesExceptCurrent.size());
List allDomainPrefixesExceptCurrent=new ArrayList(allSitesExceptCurrent.size());


Iterator it=allSitesExceptCurrent.iterator();
Site allSitesSite;
while (it.hasNext()) {
	allSitesSite=(Site)it.next();
	if (allSitesSite.getId()==id) {
		it.remove();
	}
	else {
		allLabelsExceptCurrent.add(allSitesSite.getLabel());
		allDomainPrefixesExceptCurrent.add(allSitesSite.getDomainPrefix());
	}
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">





var mode="<%=mode%>"
var id="<%=id%>"
var kqoolProperUiType=<%=Site.UI_TYPE_KQOOL_PROPER%>
var kqoolProperSiteId=1

var allLabelsExceptCurrent=[]
var allDomainPrefixesExceptCurrent=[]
<%
for (int j=0; j<allLabelsExceptCurrent.size(); j++) {
	%>
	allLabelsExceptCurrent[<%=j%>]="<%=allLabelsExceptCurrent.get(j)%>";
	allDomainPrefixesExceptCurrent[<%=j%>]="<%=allDomainPrefixesExceptCurrent.get(j)%>";
	<%
}
%>

function isValidForm(formObj)
{
	try {
		var els=formObj.elements
		if (els["label"].value.length==0)
		{
			errorAlert("You have not entered a label for this site; please fix and try again.",els["label"])
			return false
		}
		if (els["domainPrefix"].value.length==0)
		{
			errorAlert("You have not entered a domain prefix for this site; please fix and try again.",els["domainPrefix"])
			return false
		}
		if (els["uiType"].options[els["uiType"].selectedIndex].value==kqoolProperUiType && id!=kqoolProperSiteId)
		{
			errorAlert("Only the main kqool.com site may have the UI type 'Kqool.com proper'.  Please fix and try again.",els["uiType"])
			return false
		}
		if (els["uiType"].options[els["uiType"].selectedIndex].value!=kqoolProperUiType && id==kqoolProperSiteId)
		{
			errorAlert("The main kqool.com site is not 'skinnable' and therefore must have the UI type 'Kqool.com proper'.  Please fix and try again.",els["uiType"])
			return false
		}
		
		if (els["comments"].value.length>255)
		{
			errorAlert("Comments may be a maximum of 255 characters; please fix and try again.",els["comments"])
			return false
		}
		for (var i=0; i<allLabelsExceptCurrent.length; i++) {
			if (els["label"].value==allLabelsExceptCurrent[i]) {
				if (!confirm("You have specified '"+allLabelsExceptCurrent[i]+"' as a label, but a site already exists with this name; are you sure you want to proceed?")) {
					els["label"].focus()
					return false;
				}
			}
		}
		for (var i=0; i<allDomainPrefixesExceptCurrent.length; i++) {
			if (els["domainPrefix"].value==allDomainPrefixesExceptCurrent[i]) {
				errorAlert("You have specified '"+allDomainPrefixesExceptCurrent[i]+"' as a subdomain prefix, but a site already exists with that subdomain prefix; please fix and try again.",els["domainPrefix"])
				return false
			}
		}
	
		if (mode=="edit" && !confirm("*** IMPORTANT! ***\n\nEDITING AN EXISTING SITE CAN HAVE SERIOUS CONSEQUENCES.  DOING SO IMPROPERLY MAY MAKE THE SITE UNUSABLE BY CLIENTS.  UNLESS YOU ARE *ABSOLUTELY* SURE OF WHAT YOU ARE DOING, YOU SHOULD NOT CONTINUE.\n\nOK TO CONTINUE?")) {
			return false
		}
		
		
		hidePageAndShowPleaseWait()
		return true
	}
	catch (e) {
		alert("JavaScript error validating form: "+e.message)
		return false;
	}
}




<% pageContext.include("js/js.jsp"); %>
</script>


</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<form action="processSite.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="id" value="<%=id%>" />
<input type="hidden" name="mode" value="<%=mode%>" />

<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">


<%
if (mode.equals("add")) {
	%>
	<span class="firstSentenceFont">Add a new site here.</span><br />
	<br/><i>Please do not proceed unless you are sure that you really want to create a new site which will be part of the kqool.com network.
	There may be serious unforseen consequences if you add a site without having meant to.</i><br/><br/>
	Please complete the form below and then click the "add" button.  If you do not wish to create a new site,
	click the "cancel" button.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}
else if (mode.equals("edit")) {
	%>
	<span class="firstSentenceFont">Here are settings for the "<%=label%>" site.</span><br />
	<br/><i>Please do not proceed unless you are sure that you really want to edit this site.  
	There may be serious unforseen consequences of editing an existing site.</i><br/><br/>
	After making revisions below, please click the "submit" button. If you do not wish to edit this site,
	click the "cancel" button.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}
%>




<span class="boldishFont">Site Name</span><br />
<input class="inputText" type="text" style="width:350px;" name="label" id="label" value="<%=label%>"><br /><br />

<span class="boldishFont">Domain Prefix</span><br />
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td><input class="inputText" type="text" style="width:100px;" name="domainPrefix" id="domainPrefix" value="<%=domainPrefix%>"></td>
<td class="bodyFont">.kqool.com</td>
</tr>
</table><br />


<span class="boldishFont">Primary Contact</span><br />
<select  class="selectText"  name="primaryContactUserId" id="primaryContactUserId"  style="width:350px;" >

<%
List primaryContactUsers=User.getBackendUserChildren(currentUser.getId(), true);
primaryContactUsers=(primaryContactUsers==null?new ArrayList():primaryContactUsers);
it=primaryContactUsers.iterator();
User primaryContactUser;
while (it.hasNext()) {
	primaryContactUser=(User)it.next();
	if (primaryContactUser.getSiteId()!=id) {
		it.remove();
	}
}

if (currentUser.isSuperAdmin()) {
	primaryContactUsers.addAll(0, User.getAllSuperAdmins(true));
}
else {
	primaryContactUsers.add(0, currentUser);
}
it=primaryContactUsers.iterator();
while (it.hasNext()) {
	primaryContactUser=(User)it.next();
	%>
	<option value="<%=primaryContactUser.getId()%>" <%=primaryContactUser.getId()==primaryContactUserId?"selected":""%>><%=primaryContactUser.getFormattedNameAndUsername()%> (<%=primaryContactUser.getDefaultBackendUserTypeLabel()%>)</option>
	<%
}
%>
</select><br /><br />


<span class="boldishFont">UI Type</span><br />
<select  class="selectText"  name="uiType" id="uiType"  style="width:350px;" >
<%
for (int i=0; i<UI_TYPES.length; i++) {
	%>
	<option value="<%=UI_TYPES[i][0]%>" <%=UI_TYPES[i][0].equals(""+uiType)?"selected":""%>><%=UI_TYPES[i][1]%></option>
	<%
}
%>
</select><br /><br />

<span class="boldishFont">Can Share Clients</span><br />
<input type="radio" name="canShareClients" id="canShareClientstrue" value="true" <%=canShareClients?"checked":""%> /><label for="canShareClientstrue">Yes</label>
<input type="radio" name="canShareClients" id="canShareClientsfalse" value="false" <%=canShareClients?"":"checked"%> /><label for="canShareClientsfalse">No</label><br /><br />


<span class="boldishFont">Comments</span><br />
<textarea  class="inputText"  name="comments" id="comments"  style="width:350px; height:50px;" rows="3" cols="30" ><%=comments%></textarea><br /><br />




<br />

<%=HtmlUtils.cpFormButton(true, (mode.equals("add")?"add":"submit"), null, request)%>
<%=HtmlUtils.cpFormButton(false, "cancel", "location.replace('menu.jsp?"+controller.getSiteIdNVPair()+"')", request)%><br />

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

