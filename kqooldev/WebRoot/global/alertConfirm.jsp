

<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.AppConstants" %>
<%@ page import="com.theavocadopapers.apps.kqool.util.*" %>

<%!

%>

<%
SiteProperties siteProps=new SiteProperties(Integer.parseInt(request.getParameter("siteId")));

boolean isAlert=(request.getParameter("type").trim().toLowerCase().equals("alert"));
boolean isError=(request.getParameter("error")!=null && request.getParameter("error").trim().toLowerCase().equals("true"));
String text=request.getParameter("text");
String bgColor=(isAlert?"ffffff":"ffffff");
String textColor=(isAlert?"000000":"000000");
String imgSuffix=request.getParameter("type").trim().toLowerCase();
if (isError)
{
	imgSuffix+="_error";
	bgColor="ffffff";
	textColor="000000";
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
<title><%=siteProps.getDefaultPageTitleDialog()%></title>

<%@ include file="cookieJs.jsp" %>

<script type="text/javascript">

window.returnValue=false


function checkDontShowAgain()
{
	var els=document.forms["mainForm"].elements
	if (els["dontShow"])
	{
		if (els["dontShow"].checked)
		setCookie("suppress"+els["dontShow"].value,"true",null,"/")
	}
}

function focusOkButton()
{
	if (document.all && document.all.okButtonLink && document.all.okButtonLink.focus)
	{
		document.all.okButtonLink.focus()
	}
}
function init()
{
	focusOkButton()
}

function okPressed()
{
	checkDontShowAgain()
	window.returnValue=true
	setTimeout("window.close()",1)
}
function cancelPressed()
{
	checkDontShowAgain()
	window.returnValue=false
	setTimeout("window.close()",1)
}

</script>

<style type="text/css">
a {text-decoration:none;}
<%
if (isAlert || !isAlert)
{
	%>
	input {width:75px; background-color:#A2A27A; color:#003531; border:1px solid #A2A27A; }
	<%
}

%>

.bodyFont {font-family:arial,helvetica; font-size:12px; }

</style>
</head>

<body onload="init()" bgcolor="#<%=bgColor%>" background="../images/bg_<%=imgSuffix%>.gif" text="#<%=textColor%>" link="#ff9900" vlink="#ff9900" alink="#ff9900" marginheight="0" marginwidth="15" topmargin="0" leftmargin="15" style="overflow:hidden;">
<form action="#" onsubmit="return false;" name="mainForm" id="mainForm">
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
<tr>
<td align="center" valign="middle">
	<table border="0" cellspacing="0" cellpadding="0" width="300">
	<tr>
	<td align="center">
	<img src="../images/spacer.gif" height="33" width="2"><br />
	<img src="../images/icon_<%=imgSuffix%>.gif" height="1" width="1"><br />
	<img src="../images/spacer.gif" height="8" width="2"><br />
	</tr>
	<tr>
	<td align="center"><font class="bodyFont"><%=text%><br /></font>
	</tr>
	<tr>
	<td align="center"><font class="bodyFont">
	<img src="../images/spacer.gif" height="15" width="2"><br />
	
	

	<a name="okButtonLink" id="okButtonLink" href="#" hidefocus="true" onclick="okPressed(); return false"><img src="../images/smallButtons/ok_eeeeee.gif" height="19" width="81" border="0" hidefocus="true" /></a><%
	if (!isAlert)
	{
		%>
		&nbsp;&nbsp;<a hidefocus="true" href="#" onclick="cancelPressed(); return false"><img src="../images/smallButtons/cancel_eeeeee.gif" height="19" width="81" border="0" hidefocus="true" /></a>
		<%
	}
	%><br /></font>
	</tr>
	</table>
</td>
</tr>
</table>
</form>

</body>
</html>

