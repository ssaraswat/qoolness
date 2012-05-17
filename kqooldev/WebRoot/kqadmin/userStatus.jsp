<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.*" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%


User u=User.getById(controller.getParamAsInt("id"));
int status=u.getStatus();

boolean showPage=true;

String name=u.getFormattedNameAndUsername();
	
String retUrl=request.getParameter("retUrl");
if (status==User.STATUS_PREACTIVE || status==User.STATUS_SUSPENDED || status==User.STATUS_DEACTIVATED) {
	// only one status to switch to if user is any of these, which is to activete (or re-activate):
	int previousStatus=u.getStatus();
	u.setStatus(User.STATUS_ACTIVE);
	u.store();
	MailUtils.sendActivationNotification(u, previousStatus, pageContext, controller);
	showPage=false;
	//controller.redirect("users.jsp?"+controller.getSiteIdNVPair()+"&name="+URLEncoder.encode(name)+"&statusAction="+User.STATUS_ACTIVE+"&id="+controller.getParamAsInt("id")+"");
	controller.redirect(retUrl);
}

%>
<%
if (showPage) {
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">


function isValidAssignForm(formObj)
{
	var els=formObj.elements
	if (els["userId"].selectedIndex==0) {
		errorAlert("You have not chosen a user to assign this routine to; please fix and try again.",els["userId"])
		return false		
	}

	hidePageAndShowPleaseWait()
	return true
}


</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardAdminTextBlockWidth">

<form name="mainForm" id="mainForm" method="post" action="processUserStatus.jsp?<%=controller.getSiteIdNVPair()%>">
<input type="hidden" name="id" value=<%=controller.getParamAsInt("id")%> />
<input type="hidden" name="name" value="<%=name%>" />
<input type="hidden" name="retUrl" value="<%=retUrl%>" />



<input type="hidden" name="action" value="" />


<font class="bodyFont">



<span class="firstSentenceFont"><%=name%>'s account is currently active.</span><br />
You may set this 
account's status to either "suspended" or "deactivated."  Either way, this
user will no longer be able to log in.  Suspension is intended for users whose
accounts are temporarily being turned off (for example, for non-payment of
fees); deactivation is intended for users who are permanently being removed from
the site.  However, deactivated users may be reactivated at any point.  There is
no functional difference between suspension and deactivation aside from the fact
that suspended users who attempt to log in will be told that their accounts
have been suspended, while as far as deactivated users can tell, 
the site will not recognize them at all.<br /><br />

Please choose suspension or deactivation, or press the "cancel" button to leave
this user's status as "active".<br /><br />

(Note that the suspended or deactivated user will not receive an automated
email from the site informing him or her of this change; mail may be sent to 
this user at <a href="mailto:<%=u.getEmailAddress()%>"><%=u.getEmailAddress()%></a>):<br /><br />
<br />
<nobr>
<%=HtmlUtils.cpFormButton(false, "suspend", "document.forms['mainForm'].elements.action.value='suspend'; document.forms['mainForm'].submit(); return false;", request)%>
<%=HtmlUtils.cpFormButton(false, "deactivate", "document.forms['mainForm'].elements.action.value='deactivate'; document.forms['mainForm'].submit(); return false;", request)%>
<%=HtmlUtils.cpFormButton(false, "cancel", "location.href='"+request.getParameter("retUrl")+"'", request)%><br />
</nobr>
</font>

</form></span>
</div>

<%@ include file="/global/bodyClose.jsp" %>

</html>
<%
} // END if showPage
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

