



<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<%!

%>

<%
String callbackFunctionName=request.getParameter("cfn");
if (callbackFunctionName==null)
{
	callbackFunctionName="";
}
callbackFunctionName=callbackFunctionName.trim();

%> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
<title>Kqool&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</title>

<script type="text/javascript">

// these functions, etc., allow browsers that don't support (or support PROPERLY) modal windows:

var callbackFunctionName="<%=callbackFunctionName%>"
var doCallback=(callbackFunctionName!="")
var modalReturnValue
var focusInterval=null

function doModalClose()
{
	if (doCallback)
	{
		if (focusInterval!=null && window["clearInterval"])
		{
			clearInterval(focusInterval)
		}
		window.opener[callbackFunctionName](modalReturnValue)
		setTimeout("window.close()",300)
	}
	else
	{
		// returnValue already set; we'll just close() as if this were a normal modal win, which, if we're here in this else clause, it is:
		window.close()
	}
}

function setModalReturnValue(rVal)
{
	if (doCallback)
	{
		modalReturnValue=rVal
	}
	else
	{
		window.returnValue=rVal
	}
}


function focusWin()
{
	window.focus()
}

if (doCallback)
{
	// if we're faking a modal win, then we need to fake its being focussed constantly:
	// BAD IDEA:
	// focusInterval=setInterval(focusWin,100)
}


</script>

<style type="text/css">

</style>
</head>

<frameset rows="100%,*" border="0" frameborder="0" framespacing=0>
	<frame name=visiblecontent src="<%=request.getParameter("p")%><%=request.getParameter("u")%>" resizable=no scrolling=<%=request.getParameter("s")%>>
	<frame name=hiddensubmitter src="<%=request.getParameter("p")%>global/blank.html" resizable=no scrolling=no>
</frameset>



<body bgcolor="#FFFFFF" text="#000000" link="#FF0000" vlink="#800000" alink="#FF00FF" marginheight=10 marginwidth=10 topmargin=10 leftmargin=10>

</body>
</html>

