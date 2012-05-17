<%@ page import="com.theavocadopapers.apps.kqool.*" %>



 

<%
String cr=System.getProperty("line.separator","\n");
GenericProperties genericProps=new GenericProperties();
%>




<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
<title>Kqool&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</title>

<script type="text/javascript">

function setCookie (name,value,expires,path,domain,secure)
{
	document.cookie = name + "=" + escape (value) +
		((expires && expires!=null) ? "; expires=" + expires.toGMTString() : "") +
		((path) ? "; path=" + path : "") +
		((domain) ? "; domain=" + domain : "") +
		((secure) ? "; secure" : "");
}


// do not call this function directly:
function _getCookieVal (offset) {
	var endstr = document.cookie.indexOf (";", offset);
	if (endstr == -1) endstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr))
}

function getCookie (name) {
	var arg = name + "=";
	var alen = arg.length;
	var clen = document.cookie.length;
	var i = 0;
	while (i < clen) { 
		var j = i + alen;
		if (document.cookie.substring(i, j) == arg) return _getCookieVal (j);
		i = document.cookie.indexOf(" ", i) + 1;
		if (i == 0) break;
	}
	return null
}
</script>





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



function init()
{
	if (document.forms[0].elements["okButton"].focus)
	{
		document.forms[0].elements["okButton"].focus()
	}
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

	input {width:75px; background-color:#A2A27A; color:#003531; border:1px solid #A2A27A; }
	#scrollingErrorMessage {width:440px; height:355px; overflow-y:auto; border:1px solid #000000; font-size:12px; padding:4px; font-family:courier new,courier,serif;}
	

.bodyFont {font-family:arial,helvetica; font-size:12px; color:#ffffff;}

</style>
</head>

<body onload="init()" bgcolor="#ff9900" background="../images/bg_alert_jsperror.gif" text="#870000" link="#ffffff" vlink="#ffffff" alink="#ffffff" marginheight="0" marginwidth="15" topmargin="0" leftmargin="15">
<form action="#" onsubmit="return false;" name="mainForm" id="mainForm">
<br />
<table border="0" cellspacing="0" cellpadding="0" >
<tr>
<td align="left" valign="middle">
	<table border="0" cellspacing="0" cellpadding="0" width="440">
	<tr>
	<td align="left">
	<img src="../images/spacer.gif" height="33" width="2"><br />
	<img src="../images/applicationErrorHeader.gif" height="21" width="290"><br />
	<img src="../images/spacer.gif" height="8" width="2"><br /></font></td>
	</tr>
	<tr>
	<td align="left"><font class="bodyFont"><br />
	There was a problem on our end. We apologize. Your request may 
	or may not have been completely processed.<br /><br />
	If you wish to report this error, please send
	e-mail to 
	<a href="mailto:<%=genericProps.getCommentsEmailAddress()%>"><%=genericProps.getCommentsEmailAddress()%></a>.
	<br /><img src="../images/spacer.gif" height="12" width="2"><br /></div>
	</font></td>
	</tr>
	<tr>
	<td align="left"><font class="bodyFont"><br />
	<br />
	<input  class="formButton" style="background-color:#999999;" type="button" value="OK" name="okButton" id="okButton" onclick="okPressed()"><br /></font></td>
	</tr>
	</table>
</td>
</tr>
</table>
</form>

<%@ include file="/global/trackingCode.jsp" %>

</body>
</html>


