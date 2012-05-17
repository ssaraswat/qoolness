<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>
<% PageUtils.setShowTopNav(false,request); %>
<%@ include file="/global/topInclude.jsp" %>

<%! 

%> 

<%



if (controller.getSessionInfo().isShowDisplayPasswordPage()) {
		String username=(String)session.getAttribute("wr.spf");
		String password=null;
		
		
		User user=User.getByUsername(username);
		password=user.getUnencryptedPassword();
		
		
		%>
		
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
		<html>
		<head>
		 
		<%@ include file="/global/headInclude.jsp" %>
		
		
		<script type="text/javascript">
		
		</script>
		
		<style type="text/css">
		
		</style>
		</head>
		
		<%@ include file="/global/bodyOpen.jsp" %>
		
		<div id="mainDiv">
		
		<span class="standardTextBlockWidth">
		<font class="bodyFont">
		
		<%
		if (password!=null)
		{
			%>
			<span class="firstSentenceFont">Excellent answer.</span><br />
			Your password is: "<%=password%>" (without the quotes). Please make a note of it (and then leave this page, so nobody else stumbles on it!). We find that post-its do well in such situations.<br /><br />

You may now log in by clicking the "login" button:<br /><br /><br />

			<%=HtmlUtils.formButton(false, "logIn", "location.replace('login.jsp?"+controller.getSiteIdNVPair()+"&username="+URLEncoder.encode(username)+"&isPopup="+isPopup+"')", request)%>

			<%
		}
		%>
		</font>
		
		</span>
		</div>
		
		<%@ include file="/global/bodyClose.jsp" %>
		
		</html>
		<%
} // END if show this page
else {
	// redirect user who shouldn't be seeing this page (including malicious uysers) to the login page:
	controller.redirect("login.jsp?"+controller.getSiteIdNVPair());
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

