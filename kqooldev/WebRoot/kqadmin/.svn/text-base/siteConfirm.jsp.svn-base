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

static String getVerboseUiTypeFromUiType(int uiType) {
	String uiTypeStr=""+uiType;
	for (int i=0; i<UI_TYPES.length; i++) {
		if (uiTypeStr.equals(UI_TYPES[i][0])) {
			return UI_TYPES[i][1];
		}
	}
	return "";
}
%>

<%

User user=controller.getSessionInfo().getUser();

// we should not encounter this under normal curcumstances:
if (!user.isSuperAdmin()) {
	throw new RuntimeException("This page is only accessable to super admins.  This user is not a super admin.");
}


int id=controller.getParamAsInt("id",0);
String label=null;
int uiType=0;
boolean canShareClients=false;
String domainPrefix=null;
String comments=null;
int primaryContactUserId=0;


Site site=null;

// possible modes: add, edit:
String mode=controller.getParam("mode","add");

if (true) {
	try {
		site=Site.getById(id);
		label=PageUtils.nonNull(site.getLabel());
		uiType=site.getUiType();
		canShareClients=site.isCanShareClients();
		domainPrefix=PageUtils.nonNull(site.getDomainPrefix());
		comments=PageUtils.nonNull(site.getComments());
		primaryContactUserId=site.getPrimaryContactUserId();
	}
	catch (Exception e) {}
	

}
else {
	throw new RuntimeException("Unrecognized mode.");
}

User primaryContactUser=User.getById(primaryContactUserId);

boolean success=controller.getParamAsBoolean("success");




%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">






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
if (mode.equals("add") && success) {
	%>
	<span class="firstSentenceFont">The site was successfully added.</span><br />
	Details appear below.  This site does not yet have any site admins or trainers associated with it.  To associate site admins or trainers with this site, go <a href="addBackendUsers.jsp?siteId=<%=controller.getSiteId()%>">here</a>.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}
else if (mode.equals("add") && !success) {
	%>
	<span class="firstSentenceFont">The site MAY NOT have been successfully added.</span><br />
	Details appear below.  Please contact the developer of this site.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}
else if (mode.equals("edit") && success) {
	%>
	<span class="firstSentenceFont">The site was successfully edited.</span><br />
	Details appear below.  To associate site admins or trainers with this site, go <a href="addBackendUsers.jsp?siteId=<%=controller.getSiteId()%>">here</a>.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}
else if (mode.equals("edit") && !success) {
	%>
	<span class="firstSentenceFont">The site MAY NOT have been successfully edited.</span><br />
	Details appear below.  Please contact the developer of this site.</span><%=HtmlUtils.doubleLB(request)%>
	<%
}

%>




<span class="boldishFont">Site Name:</span> <%=label%><br />
<br />

<span class="boldishFont">Domain Prefix:</span> <%=domainPrefix%><br />
<br />

<span class="boldishFont">Primary Contact:</span> <%=primaryContactUser.getFormattedNameAndUsername()%><br />
<br />


<span class="boldishFont">UI Type: </span><%=getVerboseUiTypeFromUiType(uiType)%><br />
<br />

<span class="boldishFont">Can Share Clients: </span><%=canShareClients?"yes":"no"%><br />
<br/>

<span class="boldishFont">Comments:</span><br />
<blockquote>
<%=comments==null || comments.trim().length()==0?"[none]":comments%>
</blockquote><br /><br />




<br />


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

