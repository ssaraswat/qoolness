<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("superuser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%


int id=controller.getParamAsInt("id",0);
String title;
String author;
String text;
List keywordsList;
String abstractText;
Date originalPublicationDate;
Date sitePublicationDate;
String copyrightNotice;


if(id==0) {
	// we're adding an article:
	title="";
	author="";
	text="";
	keywordsList=new ArrayList(0);
	abstractText="";
	originalPublicationDate=new Date();
	sitePublicationDate=new Date();
	copyrightNotice="";
}

else {
	// we're editing an article:
	Article article=Article.getById(id);
	title=article.getTitle();
	author=article.getAuthor();
	text=article.getText().replaceAll("<p>","\r\n<p>").replaceAll("</p>","</p>\r\n").replaceAll("<br />","<br />\r\n").replaceAll("<br />","<br />\r\n").replaceAll("<br />","<br />\r\n").replaceAll("<br />","<br />\r\n").replaceAll("©","&copy;");
	keywordsList=article.getKeywordsList();
	abstractText=article.getAbstractText();
	originalPublicationDate=article.getOriginalPublicationDate();
	sitePublicationDate=article.getSitePublicationDate();
	copyrightNotice=article.getCopyrightNotice().replaceAll("©","&copy;");
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">






</script>

<style type="text/css">
body {background-image:url(); font-size:11px; font-family:arial, helvetica; }
td {font-size:11px; font-family:arial, helvetica; }
</style>
</head>

<%@ include file="/global/x_bodyOpen.jsp" %>
<form action=x_processArticle.jsp method="post">
<blockquote><br /><br />
<input type="hidden" name="id" value="<%=id%>" /><br /><br />

Title:<br />
<input class="inputText" type="text" size=50 name=title value="<%=title%>" /><br /><br />

Abstract:<br />
<textarea class="inputText" style="height:75px;" rows=5 cols=50><%=abstractText%></textarea><br /><br />

Text:<br />
<textarea class="inputText" style="height:400px;" rows=20 cols=50><%=text%></textarea><br /><br />

Author:<br />
<input class="inputText" type="text" size=50 name=author value="<%=author%>" /><br /><br />

Original Pub Date:<br />
<input class="inputText" type="text" size=50 name=originalPublicationDate value="<%=originalPublicationDate%>" /><br /><br />

Kqool Pub Date:<br />
<input class="inputText" type="text" size=50 name=sitePublicationDate value="<%=sitePublicationDate%>" /><br /><br />

Copyright Notice:<br />
<input class="inputText" type="text" size=50 name="copyrightNotice" value="<%=copyrightNotice%>" /><br /><br />

Keywords:<br />
<%

int numKeywordFields=keywordsList.size()+20;
for (int i=0; i<numKeywordFields; i++) {
	String value=(i<keywordsList.size()?(String)keywordsList.get(i):"");
	%><input class="inputText" type="text" name="keyword" value="<%=value%>" /><br /><%
}
%>
<br /><br />
<input type="submit" value="save" class="formButton" />

</blockquote>
</form>
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

