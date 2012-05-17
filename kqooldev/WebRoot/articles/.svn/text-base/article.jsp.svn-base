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

Article article=Article.getById(controller.getParamAsInt("id"));



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

</script> 

<style type="text/css">
.crFont {font-size:10px; font-family:arial,helvetica; }
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">


<font class="bodyFont">
<span style="width:400px; display:block;">
<span class="firstSentenceFont"><%=article.getTitle()%></span><br />
<i><%=article.getAuthor()%><br />
<%=DateFormat.getDateInstance(DateFormat.LONG).format(article.getOriginalPublicationDate())%></i><%=HtmlUtils.doubleLB(request)%><br />


<%=article.getText()%><br /><br />

<font class="crFont"><%=article.getCopyrightNotice()%><br /></font>
<br />

<%
if (controller.getParam("ret","").length()>0) {
	%><br /><%=HtmlUtils.formButton(false, "back", "location.href='"+controller.getParam("ret")+"'", request)%><%
}
%><br /><br/>

</span>




</div>

</font>
 
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

