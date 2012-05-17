<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ARTICLES,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%


User user=controller.getSessionInfo().getUser();

List allArticles=Article.getAll();
String retParam=URLEncoder.encode(GeneralUtils.getRequestURL(request, controller.getSiteIdInt()).toString(), "UTF-8");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

</script> 

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">


<font class="bodyFont">
<span style="width:250px; display:block;">


  


<div style="width:250px;">
<span class="firstSentenceFont">Whoever said...</span><br />
..."reading's not for athletes," never visited Kqool.com.<br /><br />
Expand your fitness knowledge along with your biceps. Browse our current collection of health and fitness articles &mdash; and bookworms, don't fret! There will be more to come in the following months.<%=HtmlUtils.doubleLB(request)%><br />
</div>
<%
for (int i=0; i<allArticles.size(); i++) {
	Article article=(Article)allArticles.get(i);
	String articleLink;
	boolean blankTarget;
	if (article.isExternalLink()) {
		articleLink=article.getExternalUrl();
		blankTarget=true;
	}
	else {
		articleLink="article.jsp?"+controller.getSiteIdNVPair()+"&id="+article.getId()+"&ret="+retParam;
		blankTarget=false;
	}
	%>
	<b><a <%=blankTarget?"target=_blank":""%> href="<%=articleLink%>"><%=article.getTitle().trim()%></a></b><br />
	<i>By <%=article.getAuthor().trim()%></i><br />
	<%=article.getAbstractText().trim()%><br />
	<a <%=blankTarget?"target=\"_blank\"":""%> href="<%=articleLink%>"><img src="../images/smallButtons/readIt_arrow.gif" height="19" width="64" border="0" vspace="4" /></a><br /><br /><br />
	<%
}
%>
</span>
<br />




<br />




</div>

<%=HtmlUtils.doubleLB(request)%><br />


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

