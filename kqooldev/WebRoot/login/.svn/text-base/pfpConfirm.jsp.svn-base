<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_PERSONAL_FITNESS_PROFILE,request); %>
<% PageUtils.setShowTopNav(false,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 

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

<div id=<%=isPopup?"popupMainDiv":"mainDiv"%>>
<span class="standardTextBlockWidth">


<font class="bodyFont">

<span class="firstSentenceFont">Qool!</span><br />

Information received.  There's one more step here.  Please email a recent photograph of yourself as
an attachment
to <a href="mailto:<%=siteProps.getCommentsEmailAddress()%>"><%=siteProps.getCommentsEmailAddress()%></a>, in GIF, JPG, PNG, or BMP format.  This step is optional,
but will further help Kqool to tailor your workout to your physical condition.<br /><br />

If you've already got an active Kqool account, you may log in <a href="login.jsp?<%=controller.getSiteIdNVPair()%>">here</a>.  And we'll be in touch soon!<br /><br />





<br /></font>

</span>


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

