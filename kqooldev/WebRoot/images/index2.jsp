<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>



<%@ include file="global/topInclude.jsp" %>

<%!

%>

<%

SessionInfo sessionInfo=controller.getSessionInfo();

controller.getSessionInfo().setShowDisplayPasswordPage(false);

String currentLoginStatus=PageUtils.nonNull(sessionInfo.getLoginStatus()).trim().toLowerCase();

boolean currentlyLoggedIn=(currentLoginStatus.equals("user") || currentLoginStatus.equals("backenduser"));


String username=controller.getParam("username").trim();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
<%@ include file="global/headInclude.jsp" %>
<%@ include file="global/validationJs.jsp" %>


<script type="text/javascript">


// Macromedia flash detection:
var MM_contentVersion = 5;
var plugin = (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"]) ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
if ( plugin ) {
		var words = navigator.plugins["Shockwave Flash"].description.split(" ");
	    for (var i = 0; i < words.length; ++i)
	    {
		if (isNaN(parseInt(words[i])))
		continue;
		var MM_PluginVersion = words[i]; 
	    }
	var MM_FlashCanPlay = MM_PluginVersion >= MM_contentVersion;
}

else if (navigator.userAgent && navigator.userAgent.indexOf("MSIE")>=0 
   && (navigator.appVersion.indexOf("Win") != -1)) {
	document.write('<SCR' + 'IPT LANGUAGE=VBScript\> \n'); //FS hide this from IE4.5 Mac by splitting the tag
	document.write('on error resume next \n');
	document.write('MM_FlashCanPlay = ( IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash." & MM_contentVersion)))\n');
	document.write('</SCR' + 'IPT\> \n');
}


function writeKey(keyNum) {
	if (MM_FlashCanPlay) {
		document.write('<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"');
		document.write('  codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" ');
		document.write(' ID="touchtones'+keyNum+'" WIDTH="22" HEIGHT="22">');
		document.write(' <PARAM NAME=movie VALUE="swf/keys/'+keyNum+'.swf"> <PARAM NAME=loop VALUE=false> <PARAM NAME=quality VALUE=high> <PARAM NAME=bgcolor VALUE=#ffffff>  '); 
		document.write(' <EMBED src="swf/keys/'+keyNum+'.swf" loop=false quality=high bgcolor=#ffffff  ');
		document.write(' swLiveConnect=true WIDTH="22" HEIGHT="22" NAME="touchtones" ALIGN=""');
		document.write(' TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer">');
		document.write(' </EMBED>');
		document.write(' </OBJECT>');
	}
	else {
		document.write('<a href="#" onclick="goToUrlFromKeyPress('+keyNum+'); return false"><img src=images/phonebuttons/'+keyNum+'.gif height=22 width=22 border="0" /></a>')
	}

}

function phoneButtonClick(keyNum) {
	goToUrlFromKeyPress(keyNum)
}


function forgotPassword() {
	var url="login/forgotPassword.jsp?<%=controller.getSiteIdNVPair()%>&username="+escape(document.forms["mainForm"].elements["username"].value)
	location.href=url
}


function isValidForm(formObj)
{
	var els=formObj.elements

	if (trim(els["username"].value).length==0)
	{
		errorAlert("You have not entered a username.  Please enter one and try again.",els["username"])
		return false
	}
	hidePageAndShowPleaseWait()
	return true
}


function needUsernameAlert()
{
	generalAlert("If you do not have a Kqool account and would like one created for you, please contact <a href=\"mailto:"+adminEmail+"\">"+adminEmail+"</a>.")
}

function gotoUrl(url)
{
	top.location.href=url
}

function hidePageAndShowPleaseWait() {}
</script>

<style type="text/css">

#pleaseWaitDiv {position:absolute; top:306px; left:20px; display:none;}
<%
if (currentlyLoggedIn) {
	%>body {background:#ffffff url(images/loggedInHomeBg.gif) repeat-x top left}
	<%
}
%>


#tour {
	width:840px;
	height:432px;
	border:1px solid #aaaaaa;
	position:absolute;
	z-index:1000;
	left:17px;
	top:215px;
}

.tournav {
	width:840px;
	height:50px;
}
	
#whosBehind .tournav {
	background:url("images/nav_whosBehind.gif") no-repeat #fff;
}

.content {
	width:840px;
	height:382px;
}

#whosBehind .content {
	background:url("images/content_whosBehind.jpg")
}

</style>

<script type="text/javascript">


function goToUrlFromKeyPress(keyNum) {
	keyNum=parseInt(keyNum)
	var url
	if (keyNum<9) {
		if (0==0) { //(keyNum!=5) {
			url="etc/homeContent.jsp?s="+keyNum
		}
		else {
			launchFeedback(false);
			return
		}
	}
	else {
		url="index.jsp?<%=controller.getSiteIdNVPair()%>#keysTop"
	}
	location.href=url

}

</script>

				
</head>




<%
if (!currentlyLoggedIn) {
	%>
	
		<body onload=init() bgcolor="#FFFFFF" text="#000000" link="#99cc00" vlink="#99cc00" alink="#99cc00" marginheight=0 marginwidth=0 topmargin=0 leftmargin=0>
		
		
		<div id="tour">
			<div id="whosBehind">
				<div class="tournav"></div>
				<div class="content"></div>
			</div>
		</div>
		
		
		<div style="z-index:10; position:absolute; top:0px; left:0px; width:100%; height:100%">
			
			
		<table border="0" cellspacing="0" cellpadding="0" width=100% height=100%>
			<tr>
				<td valign="top">

					<table border="0" cellspacing="0" cellpadding="0" width="1100">
					<form action=login/processLogin.jsp?isPopup=<%=(isPopup?"true":"false")%>&<%=controller.getSiteIdNVPair()%> method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 
			
						<tr>
							<td valign="top" colspan=4 nowrap="nowrap" height=296><img src="images/homeLogo_new.gif" height="261" width="306" alt="Change your body. Change your life." /><br /></td>
							<td valign=bottom nowrap="nowrap" height=296><img src=images/homeWordStripTop.gif height=154 width=62 /><br /></td>
						</tr>
			
						<tr valign="top">
							<td width="18"><img src="images/spacer.gif" height="1" width="18" /></td>
							<td width="385">
							<p class="bodyFont" style="xline-height:19px; width:300px; margin-top:0px; margin-bottom:45px;">
							<span class="firstSentenceFont" style="font-size:17px;">You've reached 
								Kqool.com.</span><br />
								If you're already a member, Please enter your username and password and 
								press the "log in" button. If you've reached us in error, you would 
								be wise to stay. If you've come to learn more about the web's premiere 
								online-training service, you're in the right place.
							</p>
							<font class="bodyFont">
	
							<span class="boldishFont">Username</span><br />
							<input style="width:140px;" class="inputText" type="text" size=16 name="username" id="username" value="<%=username%>"><br />
								<a tabindex=-1 href="login/join.jsp?<%=controller.getSiteIdNVPair()%>">Don't have one? Join now.</a><%=HtmlUtils.doubleLB(request)%>
						
							<span class="boldishFont">Password</span><br />
							<input style="width:140px;"  class="inputText" type="password" size=16 name=password id=password value=""><br />	
							<a tabindex=-1 href="#" onclick="forgotPassword(); return false">Forgot your password?</a><br />
							<span style="font-size:11px;">Note: if you have an account<br />
							but have never logged in,<br />
							you don't need a password.</span><%=HtmlUtils.doubleLB(request,10)%>
				
					
							<%=HtmlUtils.formButton(true, "logIn", null, request)%><%=HtmlUtils.doubleLB(request)%>
		
		
							<br /></font>
			
							</td>
							<td width="39"><img src="images/home_dashes.gif" alt="" width="39" height="453" border="0"></td>
							<td width="424">
								<div id="homeButton01">
									<a href="#">
									<h2>The kqool interactive tour</h2>
									<p>How can this unique, personal program empower<br />you to achieve the lean, strong body you were born<br />to have? Click here to find out.</p>
									</a>
								</div>
								<div id="homeButton02">
									<a href="#">
									<h2>7-day free trial</h2>
									<p>Don't wait. Start building your ideal body now.<br />Your first week is on us&#8212;no commitment required.</p>
									</a>
								</div>
							</td>
							<td><img src=images/homeWordStripBottom.gif height=281 width=62 /><br /><br /></td>
						</tr>
	
			
						
				</form>
				</table>

			</td>
		</tr>
		<tr>
			<td  nowrap="nowrap" height=168 style="height:168px;"  bgcolor="#999999" valign="top"><%@ include file="global/bottomNav.jsp" %></td>
		</tr>
	</table>
		
		


		</div>
		</BODY>
	<%
}
else {
	// logged in:
	%>
			<BODY onload="if (window.init) {init()}" BGCOLOR="#FFFFFF" link="#99cc00" vlink="#99cc00" alink="#99cc00" TEXT="#000000" TOPMARGIN="0" LEFTMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">

		<%@ include file="global/topNav.jsp" %>

		<div style="z-index:10; position:absolute; top:331px; left:765px; width:52px;">
		<!-- <img src=images/homeWord_zen.gif height=42 width=52 /> -->
		</div>
		<div style="z-index:5; position:absolute; top:0px; left:0px; width:100%; height:100%;">
		<table border="0" cellspacing="0" cellpadding="0" height=100% width=100%>
		<tr>
		<td valign="top" colspan=4 nowrap="nowrap" height=208><img galleryimg=false src=images/homeHeaderLoggedIn.gif height=208 width=517 /><br /></td>
		<td valign=bottom nowrap="nowrap" height=208><br /></td>
		</tr>
		
		<tr valign="top">
		<td>&nbsp;<br /></td>
		<td><img src=images/spacer.gif height=10 width="2" /><br />
		<img src=images/spacer.gif height="2" width="2" /><br />
		<table border="0" cellspacing="0" cellpadding="0" width=300>
		<tr>
		<td>
		<img src=images/spacer.gif height=20 width="2" /><br />
		<img src=images/home_welcome.gif height=16 width=88 /><br />
		<img src=images/spacer.gif height=42 width="2" /><br />
		<span class="bodyFont" style="xline-height:19px;">
		<%@ include file="global/homeTextPostLogin.jsp" %>
		</br>
		</td>
		</tr>
		</table>
		<br /></span><br /></td>
		<td colspan=3 valign=bottom>
		<table border="0" cellspacing="0" cellpadding="0" width=679>
		<tr valign="top">
		<td nowrap="nowrap" width=286><br /></td>
		<td nowrap="nowrap" width=14><%=userStatusText%><br /></td>
		<td nowrap="nowrap" width=379><img border="0" src=images/photo_home.jpg height=374 width=379 galleryimg=false /><br /></td>
		</tr>
		</table></td>
		</tr>
		
		<tr valign="top">
		<td bgcolor="#999999" nowrap="nowrap" height=168 style="height:168px;"><img src=images/spacer.gif height="1" width="1" /><br /></td>
		<td colspan=4 bgcolor="#999999"><%@ include file="global/bottomNav.jsp" %><br /></td>
		</tr>
		
		<tr>
		<td bgcolor="#999999" style="width:20px; " nowrap="nowrap" width=20 height="1"><img src=images/spacer.gif height="1" width="1" /><br /></td>
		<td bgcolor="#999999" style="width:258px; " nowrap="nowrap" width=258 height="1"><img src=images/spacer.gif height="1" width="1" /><br /></td>
		<td bgcolor="#999999" style="width:82px; " nowrap="nowrap" width=82 height="1"><img src=images/spacer.gif height="1" width="1" /><br /></td>
		<td bgcolor="#999999" style="width:298px; " nowrap="nowrap" width=298 height="1"><img src=images/spacer.gif height="1" width="1" /><br /></td>
		<td bgcolor="#999999"><img src=images/spacer.gif height="1" width="1" /><br /></td>
		</tr>
		</table>
		</div>
		</BODY>
	<%
}
%>























</html>

<%@ include file="global/bottomInclude.jsp" %>

<%
if (pageException!=null)
{
	%>
	<%@ include file="global/jspErrorDialogLaunch.jsp" %>
	<%
}
%>

<% PageUtils.jspEnd(request); %>

