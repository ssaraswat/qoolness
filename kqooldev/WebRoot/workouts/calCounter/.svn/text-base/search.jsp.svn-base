<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ page import="com.theavocadopapers.apps.kqool.food.*" %>

<%@ include file="/global/topInclude.jsp" %>

<%!


%>

<%



User user=controller.getSessionInfo().getUser();



%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
<TITLE></TITLE>

<script type="text/javascript">

document.domain="<%=new com.theavocadopapers.apps.kqool.GenericProperties().getJavascriptDocumentDomain()%>"

function trim(str)
{
	s=new String(str)
	while (s.charAt(0)==" ")
	{
		s=s.substring(1,s.length)
	}
	while (s.charAt(s.length-1)==" ")
	{
		s=s.substring(0,s.length-1)
	}
	return ""+s
}


 

</script>

<%@ include file="/global/calCounterJs.jsp" %>

<style type="text/css">
body, td {font-size:11px; font-family:arial,helvetica; color:#333333;}
.inputText {background-color:#eeeeee; padding-top:1px; padding-bottom:1px; padding-left:2px; height:18px; border: 1px solid #666666; font-size:11px; font-family:arial,helvetica; }
</style>

</HEAD>



<BODY BGCOLOR="#FFFFFF" TEXT="#000000" LINK="#99cc00" VLINK="#99cc00" ALINK="#99cc00">



<div id="hiddenIframeDiv" style="position:absolute; top:0px; left:0px; z-index:100; width:1px; height:1px;">
<iframe id="hiddenIframe" name="hiddenIframe" style="width:1px; height:1px; " frameborder="0" framespacing="0" src="blank.html"></iframe>
</div> 

<div id="moreFoodConfirmMain" style="background-color:#ffffff; padding:4px; border:2px solid #000000; 
text-align:center; display:none; width:191px; height:75px; position:absolute; top:268px; left:198px; 
z-index:40">
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
<tr>
<td valign="middle" align="center">
Food item saved to the database. Add another?<br/>
<a href="#" id="addMoreYesButton" onclick="addMore(); return false;"><img style="margin-top:12px;" border="0" src="../../images/smallerButtons/yes.gif" width="49" height="19" /></a>
<a href="#" onclick="doneAdding(); return false;"><img style="margin-top:12px;" border="0" src="../../images/smallerButtons/no.gif" width="49" height="19" /></a>
</td>
</tr>
</table>

</div>
<div id="moreFoodConfirmShadow" style="padding:4px; border:2px solid #999999; width:191px; 
display:none; position:absolute; height:75px; top:270px; left:200px; z-index:39">
&nbsp;
</div>

<div id="moreFoodConfirmUndermask" style="width:800px; 
display:none; position:absolute; height:800px; top:0px; left:0px; z-index:38">
<img  border="0" onselectstart="return false" ondragstart="return false" src="../../images/moreFoodsUndermask.png" width="800" height="800" />
</div>

<div style="position:absolute; top:8px; left:8px; z-index:10">
<div style="width:100%; font-size:14px; font-weight:bold;  border-bottom:1px solid #000000; padding-bottom:5px; margin-bottom:10px;">What'd You Eat?</div>
<form action="searchResults.jsp" target="hiddenIframe" onsubmit="return doSearch();" style="display:inline;margin:0px; padding:0px;">
<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr valign="top">
<td>
<b>1. Search for what you ate</b> (for example, "milk" or "chicken"):<br/>
<table border="0" cellspacing="0" cellpadding="0">
<tr vaign="top">
<td><input style="width:260px;" type="text" class="inputText" name="kqfoodquery" id="kqfoodquery" value="" /><br/></td>
<td><input style="padding-left:3px ;margin-top:1px;" type="image" border="0" src="../../images/smallerButtons/find.gif" width="49" height="19" /><br/></td>
</tr>
</table>
</td>
<td align="right">
<% // Note: it's fine that the following image lives on prod; not a problem:
	%>
<img id="ckLogo" src="../../images/cklogo.gif" style="xmargin-top:15px;" /><br/>
</td>
</tr>
</table>
</form>

<div id="searchResultsDiv" style="width:580px; height:170px; xborder:1px solid #ff9900; overflow:auto;">
</div> 
<div id="servingsDiv" style="margin-top:8px;width:580px; height:40px; xborder:1px solid #ff9900; overflow:auto;">
</div>
<div style="width:100%; border-top:1px solid #000000;padding-top:10px; margin-top:17px; text-align:center;">
<a href="#" onclick="cancelSearch(); return false;"><img border="0" src="../../images/smallerButtons/cancel.gif" width="49" height="19" /></div>



</div>

<%@ include file="/global/trackingCode.jsp" %>



</BODY>
</HTML>






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

