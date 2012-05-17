<!-- Arvixe  -->
<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>
<% 
// on this page, we will get the siteId from the subdomain:
PageUtils.setSkipSiteIdCheck(request); %>



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
	var url="login/forgotPassword.jsp?siteId=<%=controller.getSiteId()%>&username="+escape(document.forms["mainForm"].elements["username"].value)
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


function openBox(x) {
    //alert("openBox: " + x)
    document.getElementById(x).style.display = 'block';
}


function closeBox(x) {
    //alert("closeBox: " + x)
        document.getElementById(x).style.display = 'none';
}

</script>


<script type="text/javascript">


function isValidForm(formObj)
{
	try {
		var els=formObj.elements
	
		if (trim(els["firstName"].value).length==0)
		{
			errorAlert("You have not entered a first name.  Please enter one and try again.",els["firstName"])
			return false
		}
		if (trim(els["lastName"].value).length==0)
		{
			errorAlert("You have not entered a last name.  Please enter one and try again.",els["lastName"])
			return false
		}
		if (els["emailAddress"].value.length==0)
		{
			errorAlert("You have not entered an email address.  Please enter one and try again.",els["emailAddress"])
			return false
		}
		if (els["username"].value.length==0)
		{
			errorAlert("You have not entered the username you'd like to have.  Please enter one and try again.",els["username"])
			return false
		}
	
		
		
		
		if (!isValidEmail(els["emailAddress"].value)) {
			errorAlert("The email address you have entered is not valid.  'john@mymail.com' is an example of a valid email address.  Please enter one and try again.",els["emailAddress"])
			return false
		}
		if (!isValidUsername(els["username"].value)) {
			errorAlert("The username you have entered is not valid.  Usernames must be between four and 16 characters long and may contain only letters, numerals, underscores, hyphens, and periods. Please fix and try again.",els["username"])
			return false
		}
		if (els["comments"].value.length>800) {
			errorAlert("The comments you have entered are "+els["comments"].value.length+" characters long; the maximum is 800 characters.  Please fix and try again.",els["comments"])
			return false
		}
		var gender=0
		for (var i=0; i<els.length; i++) {
			if (els[i].name=="gender" && els[i].checked) {
				gender=els[i].value
				break
			}
		}
		if (gender==0) {
			errorAlert("You have not indicated your gender.  Please fix and try again.",els["gender"])
			return false
		}
	
		hidePageAndShowPleaseWait()
		return true
	}
	catch (e) {
		return true;
	}
}

</script>

<script type="text/javascript">
function validate_required(field,alerttxt)
{
with (field)
{
if (value==null||value=="")
  {alert(alerttxt);return false;}
else {return true}
}
}

function validate_email(field,alerttxt)
{
with (field)
{
apos=value.indexOf("@");
dotpos=value.lastIndexOf(".");
if (apos<1||dotpos-apos<2) 
  {alert(alerttxt);return false;}
else {return true;}
}
}

function validate_match(field,alerttxt)
{
var obja = document.getElementById('email')
with (field)
{
if (value!=obja.value)
  {alert(alerttxt);return false;}
else {return true}
}
}

function validate_checkbox(field,alerttxt)
{
with (field)
{
if (document.contact_form.privacy.checked == false)
  {alert(alerttxt);return false;}
else {return true}
}
}

function validate_form(thisform)
{
with (thisform)
{
if (validate_required(firstName,"Please enter your first name")==false)
  {firstName.focus();return false;}
if (validate_required(lastName,"Please enter your last name")==false)
  {lastName.focus();return false;}
if (validate_required(address1,"Please enter your address")==false)
  {email.focus();return false;}
if (validate_required(city,"Please enter your city")==false)
  {city.focus();return false;}
if (validate_required(state,"Please enter your state")==false)
  {state.focus();return false;}
if (validate_required(country,"Please enter your country")==false)
  {country.focus();return false;}
if (validate_required(zip,"Please enter your postal code")==false)
  {zip.focus();return false;}
if (validate_email(email,"Please enter a valid e-mail address")==false)
  {email.focus();return false;}
if (validate_required(phone,"Please enter your phone number")==false)
  {phone.focus();return false;}
//if (validate_required(re_email,"Please re-enter your email address")==false)
 // {re_email.focus();return false;}
//if (validate_match(re_email,"The email fields do not match")==false)
  //{re_email.focus();return false;}
//if (validate_required(re_email,"Please select a request type")==false)
  //{re_email.focus();return false;}
//if (validate_checkbox(privacy,"You must agree to the Privacy Policy")==false)
  //{privacy.focus();return false;}

}
}

function validate_contactForm(thisform)
{
with (thisform)
{
if (validate_required(firstName,"Please enter your first name")==false)
  {firstName.focus();return false;}
if (validate_required(lastName,"Please enter your last name")==false)
	{lastName.focus();return false;}
if (validate_email(email,"Please enter a valid e-mail address")==false)
  {email.focus();return false;}

}
}

</script>

<style type="text/css">

#pleaseWaitDiv {position:absolute; top:306px; left:20px; display:none;}
<%
if (currentlyLoggedIn) {
	%>body {background:#ffffff url(images/loggedInHomeBg.gif) repeat-x top left}
	<%
}
%>


#tour,
#trial,
#contact {
	width:840px;
	height:432px;
	border:1px solid #aaaaaa;
	position:absolute;
	z-index:1000;
	left:17px;
	top:215px;
}

#trial {
	background:#fff;
}

.tournav,
.trialnav {
	width:840px;
	height:50px;
}

.trialnav {
	background:url("images/nav_trial.gif") no-repeat;
}

#whosBehind .tournav {
	background:url("images/nav_whosBehind.gif") no-repeat #fff;
}

#dimensional .tournav {
	background:url("images/nav_dimensional.gif") no-repeat #fff;
}

#inside .tournav {
	background:url("images/nav_inside.gif") no-repeat #fff;
}

.content {
	width:840px;
	height:382px;
}

#whosBehind .content,
#dimensional .content,
#inside .content,
#signup .content,
#trial .content,
#contact .content {
	position:absolute;
	top:50px;
	left:0px;
}

#whosBehind .content {
	background:url("images/content_whosBehind.jpg") top left no-repeat;
}

#dimensional .content {
	background:url("images/content_dimensional.jpg") top left no-repeat;
}

#inside .content,
#signup .content,
#contact .content {
	background:#fff;
}


#whosBehind .text,
#dimensional .text,
#inside .text,
#signup .text,
#trial .text,
#contactForm .text {
	width:405px;
	height:272px;
	position:relative;
	top:53px;
	left:25px;
}

#whosBehind .text {
	background:url("images/bg_text_whosbehind.png") no-repeat;
}

#dimensional .text {
	width:330px;
}


.tournav a,
.trialnav a {
	text-indent:-4000px;
	font-size:1px;
	display:block;
	padding-top:50px;
	float:left;
}

.tournav a.whosBehind {
	margin-left:12px;
	width:152px;
}

.tournav a.dimensional {
	width:189px;
}

.tournav a.inside {
	width:129px;
}

.tournav a.close,
.trialnav a.close {
	float:right;
	width:36px;
	padding-top:36px;
	position:relative;
	left:-6px;
	top:10px;
}

#whosBehind .text p,
#dimensional .text p,
#inside .text p,
#trial .text p,
#contact .text p {
	font-family:arial;
	font-size:11px;
	line-height:11px;
	color:#000;
	padding:10px 3px 5px 9px;
}

#whosBehind .text a,
#dimensional .text a,
#inside .text a,
#trial .text a {
	color:#33f;
}

.orange {
	color:#f60;
}

.kqool {
	font-weight:bold;
	color:#666;
}

#trial input,
#contactForm input {
	width:166px;
	float:left;
	clear:left;
	margin:0px 20px 6px 0px;
}

#signup,
#contactForm {

	font-family:arial;
	font-size:11px;
	color:#999;
}

</style>


<!--[if IE 7]>

<style type="text/css">

#tour,
#contact {
	height:434px;
}

#trial {
	height:450px;
}

</style>

<![endif]-->


<script type="text/javascript">


function goToUrlFromKeyPress(keyNum) {
	keyNum=parseInt(keyNum)
	var url
	if (keyNum<9) {
		if (0==0) { //(keyNum!=5) {
			url="etc/homeContent.jsp?siteId=<%=controller.getSiteId()%>&s="+keyNum
		}
		else {
			launchFeedback(false);
			return
		}
	}
	else {
		url="index.jsp?siteId=<%=controller.getSiteId()%>#keysTop"
	}
	location.href=url

}

</script>





				
</head>




<%
if (!currentlyLoggedIn) {
	%>
	
		<body onload="init()" bgcolor="#FFFFFF" text="#000000" link="#99cc00" vlink="#99cc00" alink="#99cc00" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">

<script type="text/javascript" src="swfobject.js"></script>

<script type="text/javascript">

	var flashvars = {
	};

	var params = {
  	bgcolor: "#ffffff"

	};
	
	var attributes = {
	
	};

	swfobject.embedSWF("kQoolVideo.swf", "getFlash", "316", "262", "9.0.0", "expressInstall.swf", flashvars, params, attributes);
</script>

		
		
		<div id="tour" style="display:none;">
		
			<div id="whosBehind">
				<div class="tournav">
					<a class="whosBehind" href="javascript:void(0)">who's behind kqool</a>
					<a class="dimensional" href="javascript:void(0)" onClick="closeBox('whosBehind');openBox('dimensional');">kqool dimensional&#8482; training</a>
					<a class="inside" href="javascript:void(0)" onClick="closeBox('whosBehind');openBox('inside');">inside kqool.com</a>
					<a class="close" href="javascript:void(0);" onClick="closeBox('tour');">CLOSE</a>
				</div>
				<div class="content">
					<div class="text">
						<p>Andrew McCreary is a New York City based master level trainer with over ten years of experience training at top gyms. Using his unique philosophy, which he calls <span class="kqool">kqool</span> <strong class="orange">dimensional training&#8482;</strong>, Andrew has helped a wide range of clients&#8212;from professional athletes and busy executives to models and new moms-achieve their ideal bodies in less time than they thought possible.
<br /><br />
kqool <strong>dimensional training&#8482;</strong> is a superior approach to fitness that uses dynamic, constantly changing moves to target and challenge multiple muscle-groups, which leads to fast, visible results. The online <span class="kqool">kqool</span> <strong>dimensional training&#8482;</strong> program has been carefully designed to provide you with the same personal attention and constant support that Andrew generously gives to each of his clients.
<br /><br />
Certified by the National Academy of Sports Medicine (NASM), Andrew draws upon multiple fitness disciplines including aerobic training, calisthenics, plyometrics, functional movement, strength, and yoga.
<br /><br />
Andrew is currently working with <a href="http://www.womenshealthmag.com/blog/battle">Women's Health</a> magazine on a three-month study to determine the effects of training on men and women. He is also developing a new book in collaboration with Tyler Graham of <a href="http://www.bestlifeonline.com">Best Life magazine</a> and the creative agency <a href="http://www.osnovagroup.com">OSNOVA</a>.</p>
					</div>
				</div>
			</div>
			
			<div id="dimensional">
				<div class="tournav">
					<a class="whosBehind" href="javascript:void(0)" onClick="closeBox('dimensional');openBox('whosBehind');">who's behind kqool</a>
					<a class="dimensional" href="javascript:void(0)">kqool dimensional&#8482; training</a>
					<a class="inside" href="javascript:void(0)" onClick="closeBox('dimensional');openBox('inside');">inside kqool.com</a>
					<a class="close" href="javascript:void(0);" onClick="closeBox('dimensional');closeBox('tour');">CLOSE</a>
				</div>
				<div class="content">
					<div class="text">
						<p><span class="kqool">kqool</span> <strong class="orange">dimensional training&#8482;</strong> is founded on three-dimensional muscle engagement. While most training methods focus on individual muscles, linear actions, and repetitive exercises, kqool's revolutionary routines consist of multi-directional movements that challenge the body as a whole and demand intense mental focus. (Expect to burn 300 to 500 calories in a single kqool session.) Rest assured that boredom, plateaus, and burnout will not be an issue as kqool routines are creative and ever changing.
<br /><br />
After filling out a personal profile, you will be invited to speak with Andrew at length about your workout history, eating habits, and physical as well as mental goals. As a Kqool user, you will be encouraged to keep a detailed food journal here on the site, and share photos and videos of yourself as you progress. Additional consultations with Andrew are always available.
<br /><br />
Under Andrew's guidance, clients experience a powerful transformation.<br />
You will begin to see that attaining your ideal body is well within your reach. And that knowledge will help drive you to succeed in every other aspect of your life.</p>
					</div>
				</div>
			</div>
			
			<div id="inside">
				<div class="tournav">
					<a class="whosBehind" href="javascript:void(0)" onClick="closeBox('inside');closeBox('dimensional');openBox('whosBehind');">who's behind kqool</a>
					<a class="dimensional" href="javascript:void(0)" onClick="closeBox('inside');closeBox('whosBehind');openBox('dimensional');">kqool dimensional&#8482; training</a>
					<a class="inside" href="javascript:void(0)">inside kqool.com</a>
					<a class="close" href="javascript:void(0);" onClick="closeBox('inside');closeBox('tour');">CLOSE</a>
				</div>
				<div class="content">
					<div class="text">
						<p>When you sign up for kqool.com, Andrew will personally guide your training. This is not a one-size-fits-all training program&#8212;no two clients will receive the same workout. Six days a week Andrew will create a unique routine that directly reflects what you did (and didn't) do the day before.</p>
					</div>

					<div id="video" style="position:absolute; top:70px; left:450px;">
					<div id="getFlash">
					
					<p>To view this interactive feature, you must have Flash 9 installed on your computer.<br />If you do not have Flash 9, you can download it from the <a href="javascript:void(0);" onclick="window.open('/general/jump_safety.jsp?siteId=<%=controller.getSiteId()%>&url=http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash');">Adobe web site</a>.</p>
		
					</div>			
				</div>
				</div>
				
			</div>
			
		</div>
		
		<div id="trial" style="display:none;">
			<div id="signup">
				<div class="trialnav">
					<a class="close" href="javascript:void(0);" onClick="closeBox('trial');">CLOSE</a>
				</div>
				<div class="content">

					<div class="text" style="position:relative; top:-20px;">
						<p>Ready to sign up for your 7-day free trial? Fill out the form on right and you'll receive an email with your login name, temporary password, and additional instructions. Your 7 days begin the first time you sign in.
<br /><br />
After your freebie is up, you'll have the opportunity to join kqool for a fee of $39.95 per month, paid monthly via paypal. There is no long-term commitment: You can cancel or put your subscription on hold at any time.
<br /><br />
Have questions for Andrew about membership or the kqool fitness philosophy? <a href="javascript:void(0);" onClick="closeBox('trial');openBox('contact');">Click here</a> to send an email directly to his personal inbox.</p>
					</div>
					<div id="signup" style="position:absolute; top:20px; left:440px;">
						<form action="signupForm.jsp?siteId=<%=controller.getSiteId()%>" method="post" onsubmit="return validate_form(this);" name="signup" id="signup">
						<div style="width:176px; float:left;"> 
							First Name<br /><input type="text" name="firstName" id="firstName" value="">
							Last Name<br /><input type="text"  name="lastName" id="lastName" value="">
							Address Line 1<br /><input type="text" name="address1" id="address1" value="">
							Address Line 2<br /><input type="text" name="address2" id="address2" value="">
							City<br /><input type="text"  name="city" id="city" value="">
							State<br /><input type="text"  name="state" id="state" value="">
							Country<br /><input type="text"  name="country" id="country" value="">
							Postal Code<br /><input type="text" name="zip" id="zip" value="">
						</div>
						<div style="width:176px; float:left;"> 
							Email Address<br /><input type="text" name="email" id="email" value="">
							Phone number<br /><input type="text" name="phone" id="phone" value="">
							Comments (optional)<br /><textarea style="height:100px; width:166px; margin-bottom:7px;" rows="5" cols="15" name="comments" id="comments"></textarea>
							<input type="hidden" name="to" value="andrew.mccreary@gmail.com">
							<input type="hidden" name="to2" value="kqoolfit@aol.com">
							<input type="hidden" name="from" value="andrew.mccreary@gmail.com">
							<input type="hidden" name="subject" value="Free Trial Signup">
							<input type="image" src="images/sign_up_send.gif" style="width:33px; float:right;">
						</div>
							
							
							
							
						</form>

					</div>
				</div>
				
			</div>
		</div>
		
		
		<div id="contact" style="display:none;">
			<div id="signup">
				<div class="trialnav">
					<a class="close" href="javascript:void(0);" onClick="closeBox('contact');">CLOSE</a>
				</div>
				<div class="content">
					<div class="text" style="position:relative; top:-5px;"><p>What's on your mind?<br /><span class="orange">Send an email directly to Andrew.</span></p></div>
					
						
					<div id="contactForm" style="position:absolute; top:10px; left:350px;">
						<form action="contactForm.jsp?siteId=<%=controller.getSiteId()%>" method="post" onsubmit="return validate_contactForm(this);" name="contactForm" id="contactForm">

						<div style="width:186px; float:left;"> 
							First Name<br /><input type="text" name="firstName" id="firstName" value="">
							Last Name<br /><input type="text"  name="lastName" id="lastName" value="">
						</div>
						<div style="width:186px; float:left;"> 
							Email Address<br /><input type="text" name="email" id="email" value="">
							Comments (optional)<br /><textarea style="height:200px; width:176px; margin-bottom:7px;" rows="10" cols="15" name="comments" id="comments"></textarea>
							<input type="hidden" name="to" value="andrew.mccreary@gmail.com">
							<input type="hidden" name="to2" value="kqoolfit@aol.com">
							<input type="hidden" name="from" value="andrew.mccreary@gmail.com">
							<input type="hidden" name="subject" value="kqool contact form">
							<input type="image" src="images/sign_up_send.gif" style="width:33px; float:right;">
						</div>
							
						</form>

					</div>
				</div>
			</div>

		</div>
		
		<div style="z-index:10; position:absolute; top:0px; left:0px; width:100%; height:100%">
			
			
		<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
			<tr>
				<td valign="top">

					<table border="0" cellspacing="0" cellpadding="0" width="1100">
					<form action="login/processLogin.jsp?siteId=<%=controller.getSiteId()%>&isPopup=<%=(isPopup?"true":"false")%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 
					
						<tr>
							<td valign="top" colspan="4" nowrap="nowrap" height="296"><img src="images/homeLogo_new.gif" height="261" width="306" alt="Change your body. Change your life." /><br /></td>
							<td valign="bottom" nowrap="nowrap" height="296"><img src="images/homeWordStripTop.gif" height="154" width="62" /><br /></td>
						</tr>
			
						<tr valign="top">
							<td width="18"><img src="images/spacer.gif" height="1" width="18" /></td>
							<td width="385">
							<p class="bodyFont" style="xline-height:19px; width:300px; margin-top:0px; margin-bottom:45px;">
							<span class="firstSentenceFont" style="font-size:17px;">You've reached 
								stage.Kqool.com.</span><br />
								If you're already a member, Please enter your username and password and 
								press the "log in" button. If you've reached us in error, you would 
								be wise to stay. If you've come to learn more about the web's premiere 
								online-training service, you're in the right place.
							</p>
							<font class="bodyFont">
	
							<span class="boldishFont">Username</span><br />
							<input style="width:140px;" class="inputText" type="text" size="16" name="username" id="username" value="<%=username%>"><br />
								<a tabindex="-1" href="login/join.jsp?siteId=<%=controller.getSiteId()%>">Don't have one? Join now.</a><%=HtmlUtils.doubleLB(request)%>
						
							<span class="boldishFont">Password</span><br />
							<input style="width:140px;"  class="inputText" type="password" size="16" name="password" id="password" value=""><br />	
							<a tabindex="-1" href="#" onclick="forgotPassword(); return false">Forgot your password?</a><br />
							<span style="font-size:11px;">Note: if you have an account<br />
							but have never logged in,<br />
							you don't need a password.</span><%=HtmlUtils.doubleLB(request,10)%>
				
					
							<%=HtmlUtils.formButton(true, "logIn", null, request)%><%=HtmlUtils.doubleLB(request)%>
		
		
							<br /></font>
			
							</td>
							<td width="39"><img src="images/home_dashes.gif" alt="" width="39" height="453" border="0"></td>
							<td width="424">
								<div id="homeButton01">
									<a href="javascript:void(0);" onClick="openBox('tour');openBox('whosBehind');closeBox('dimensional');closeBox('inside');">
									<h2>The kqool interactive tour</h2>
									<p>How can this unique, personal program empower<br />you to achieve the lean, strong body you were born<br />to have? Click here to find out.</p>
									</a>
								</div>

							</td>
							<td><img src="images/homeWordStripBottom.gif" height="281" width="62" /><br /><br /></td>
						</tr>
	
			
						
				</form>
				</table>

			</td>
		</tr>
		<tr>
			<td  nowrap="nowrap" height="168" style="height:168px;"  bgcolor="#999999" valign="top"><%@ include file="global/bottomNav.jsp" %></td>
		</tr>
	</table>
		
		


		</div>
		
	<%@ include file="/global/trackingCode.jsp" %>

		
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
		<table border="0" cellspacing="0" cellpadding="0" height="100%" width="100%">
		<tr>
		<td valign="top" colspan="4" nowrap="nowrap" height="208"><img galleryimg="false" src="images/homeHeaderLoggedIn.gif" height="208" width="517" /><br /></td>
		<td valign="bottom" nowrap="nowrap" height="208"><br /></td>
		</tr>
		
		<tr valign="top">
		<td>&nbsp;<br /></td>
		<td><img src="images/spacer.gif" height="10" width="2" /><br />
		<img src="images/spacer.gif" height="2" width="2" /><br />
		<table border="0" cellspacing="0" cellpadding="0" width="300">
		<tr>
		<td>
		<img src="images/spacer.gif" height="20" width="2" /><br />
		<img src="images/home_welcome.gif" height="16" width="88" /><br />
		<img src="images/spacer.gif" height="42" width="2" /><br />
		<span class="bodyFont" style="xline-height:19px;">
		<%@ include file="global/homeTextPostLogin.jsp" %>
		</span>
		<br />
		</td>
		</tr>
		</table>
		<br /></span><br /></td>
		<td colspan="3" valign="bottom">
		<table border="0" cellspacing="0" cellpadding="0" width="679">
		<tr valign="top">
		<td nowrap="nowrap" width="286"><br /></td>
		<td nowrap="nowrap" width="14"><%=userStatusText%><br /></td>
		<td nowrap="nowrap" width="379"><img border="0" src="images/photo_home.jpg" height="374" width="379" galleryimg="false" /><br /></td>
		</tr>
		</table></td>
		</tr>
		
		<tr valign="top">
		<td bgcolor="#999999" nowrap="nowrap" height="168" style="height:168px;"><img src="images/spacer.gif" height="1" width="1" /><br /></td>
		<td colspan="4" bgcolor="#999999"><%@ include file="global/bottomNav.jsp" %><br /></td>
		</tr>
		
		<tr>
		<td bgcolor="#999999" style="width:20px; " nowrap="nowrap" width="20" height="1"><img src="images/spacer.gif" height="1" width="1" /><br /></td>
		<td bgcolor="#999999" style="width:258px; " nowrap="nowrap" width="258" height="1"><img src="images/spacer.gif" height="1" width="1" /><br /></td>
		<td bgcolor="#999999" style="width:82px; " nowrap="nowrap" width="82" height="1"><img src="images/spacer.gif" height="1" width="1" /><br /></td>
		<td bgcolor="#999999" style="width:298px; " nowrap="nowrap" width="298" height="1"><img src="images/spacer.gif" height="1" width="1" /><br /></td>
		<td bgcolor="#999999"><img src="images/spacer.gif" height="1" width="1" /><br /></td>
		</tr>
		</table>
		</div>
		
		
	
		
		
		<%@ include file="/global/trackingCode.jsp" %>

		
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

