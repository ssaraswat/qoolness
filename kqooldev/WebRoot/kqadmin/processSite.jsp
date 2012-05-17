<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

//we should not encounter this under normal curcumstances:
if (!currentUser.isSuperAdmin()) {
	throw new RuntimeException("This page is only accessable to super admins.  This user is not a super admin.");
}

Site site;

int id=controller.getParamAsInt("id",0);
String label=controller.getParam("label");
int uiType=controller.getParamAsInt("uiType");
boolean canShareClients=controller.getParamAsBoolean("canShareClients");
String domainPrefix=controller.getParam("domainPrefix");
String comments=controller.getParam("comments");
String mode=controller.getParam("mode");
int primaryContactUserId=controller.getParamAsInt("primaryContactUserId", 0);

String successParam;

boolean siteExists=(mode.equals("edit"));
try
{
	if (siteExists) {
		site=Site.getById(id);
	}
	else {
		site=new Site();
	}
	site.setLabel(label);
	site.setUiType(uiType);
	site.setCanShareClients(canShareClients);
	site.setDomainPrefix(domainPrefix);
	site.setComments(comments);
	site.setPrimaryContactUserId(primaryContactUserId);
	if (siteExists) {
		site.store();
	}
	else {
		id=site.store();
	}

	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}


controller.redirect("siteConfirm.jsp?"+controller.getSiteIdNVPair()+"&id="+id+"&mode="+mode+"&success="+successParam);

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

