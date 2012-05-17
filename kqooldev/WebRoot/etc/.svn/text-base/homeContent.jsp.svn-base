<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_HOME_CONTENT,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

int homepageSection=controller.getParamAsInt("s");

String currentLoginStatus=PageUtils.nonNull(controller.getSessionInfo().getLoginStatus()).trim().toLowerCase();
boolean currentlyLoggedIn=(currentLoginStatus.equals("user") || currentLoginStatus.equals("backenduser"));
PageUtils.setShowTopNav(currentlyLoggedIn,request);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>


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
		document.write(' <PARAM NAME=movie VALUE="../swf/keys/'+keyNum+'.swf"> <PARAM NAME=loop VALUE=false> <PARAM NAME=quality VALUE=high> <PARAM NAME=bgcolor VALUE=#ffffff>  '); 
		document.write(' <EMBED src="../swf/keys/'+keyNum+'.swf" loop=false quality=high bgcolor=#ffffff  ');
		document.write(' swLiveConnect=true WIDTH="22" HEIGHT="22" NAME="touchtones" ALIGN=""');
		document.write(' TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer">');
		document.write(' </EMBED>');
		document.write(' </OBJECT>');
	}
	else {
		document.write('<a href="#" onclick="goToUrlFromKeyPress('+keyNum+'); return false"><img src=../images/phonebuttons/'+keyNum+'.gif height=22 width=22 border="0" /></a>')
	}

}

function phoneButtonClick(keyNum) {
	goToUrlFromKeyPress(keyNum)
}



function goToUrlFromKeyPress(keyNum) {
	keyNum=parseInt(keyNum)
	var url
	if (keyNum<9) {
		if (keyNum!=5) {
			url="homeContent.jsp?s="+keyNum
		}
		else {
			launchFeedback(false);
			return
		}
	}
	else {
		url="../index.jsp?<%=controller.getSiteIdNVPair()%>#keysTop"
	}
	location.href=url

}

</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<span class="standardTextBlockWidth" style="display:block;">

<font class="bodyFont">
<%
			if (homepageSection==1) {
				%>
				<span class="firstSentenceFont">1: The Kqool Program.</span><%=HtmlUtils.doubleLB(request)%>
				
				Welcome to Kqool.  Prepare to look, feel, and <i>be</i> healthier.<%=HtmlUtils.doubleLB(request)%>
				
				
				It's where to go to get where you want to be. Treat your mind, body, and spirit 
				to the best possible workout, at the best possible time and location for you. Kqool
				electronically delivers to you a personalized workout regimen, devised 
				specifically for your needs by a certified personal trainer. Kqool.com is stronger, better, 
				newer, and faster than anything of its kind &mdash; and soon, you will be too.<%=HtmlUtils.doubleLB(request)%>
				
				
				Once you open an account with Kqool.com, you'll be served up with several digital 
				workout assignments a week - each hand-tailored in frequency and intensity to your 
				fitness goals by a certified personal trainer. Every workout routine will consist 
				of several exercises, each with a specified intensity and amount.  For example, 
				you may receive an assignment like:<%=HtmlUtils.doubleLB(request)%>
				
				&nbsp;&nbsp;&nbsp;Exercise: Stairmaster<br />
				&nbsp;&nbsp;&nbsp;Amount: 40 Minutes<br />
				&nbsp;&nbsp;&nbsp;Intensity: Level 13<%=HtmlUtils.doubleLB(request)%>
				
				or<%=HtmlUtils.doubleLB(request)%>
				
				&nbsp;&nbsp;&nbsp;Exercise: Chest Press<br />
				&nbsp;&nbsp;&nbsp;Amount: 3 sets of 12 reps<br />
				&nbsp;&nbsp;&nbsp;Intensity: 190 lbs<%=HtmlUtils.doubleLB(request)%>
				
				Once you get your routine, you'll be able to print it out and take it with you to the gym. 
				Record what you actually accomplish on this sheet (here's a 
				<a href="../login/sampleSheet.html" target="_blank">sample</a>) - then use it to enter your progress into 
				Kqool.com's Fitness Tracker. We'll take note of what you've done, and use that 
				information to formulate your next workout.<%=HtmlUtils.doubleLB(request)%>
				
				Pretty Kqool, eh?  We think so.  But that's not all.<%=HtmlUtils.doubleLB(request)%>
				
				Besides the personalized workouts, you'll have access to streaming instructional 
				fitness videos right on Kqool.com, as well as health and fitness-related articles.  
				And, of course, you'll always be able to <a href="#" onclick="launchFeedback(false); return false;">contact us</a> with your questions and concerns.<br /><%=HtmlUtils.doubleLB(request)%>
				
				<table border="0" cellspacing="0" cellpadding="0">

				<tr valign="middle">
				<td class="bodyFont">Press&nbsp;<br /></td>
				<td class="bodyFont" width="21" nowrap="nowrap" height="29" style="width:21px;"><script type="text/javascript">
				writeKey(9)
				</script><br /></td>
				<td class="bodyFont"><nobr>&nbsp;to return to the main menu.</nobr><br /></td>
				</tr>
				
				</table><br /><br />
				

				
				<%
			}
			else if (homepageSection==2) {
				%>
				<span class="firstSentenceFont">2: What's coming soon.</span><br />
				
				They say good things come to those who wait.  Brace yourself for an onslaught.<%=HtmlUtils.doubleLB(request)%>

				Here's a sample of what you can expect to see in coming months:
				<ul>
				<li>Calories-burned calculator</li>
				<li>Bar charts and graphs to track your workout
				progress over time</li>
				<li>Automatic PDA or mobile-phone synchronization</li>
				<li>Recent-exercises list</li>
				<li>Nutrition and diet dracker</li>
				<li>Journal to record fitness-related information</li>
				<li>More instructional videos</li>
				<li>More articles</li>
				</ul>
	
				<table border="0" cellspacing="0" cellpadding="0">
				<tr valign="middle">
				<td class="bodyFont">Press&nbsp;<br /></td>
				<td class="bodyFont" width="21" nowrap="nowrap" height="29" style="width:21px;"><script type="text/javascript">
				writeKey(9)
				</script><br /></td>
				<td class="bodyFont"><nobr>&nbsp;to return to the main menu.</nobr><br /></td>
				</tr>

				</table><br /><br />
				<%
			}
			else if (homepageSection==3) {
				%>
				<span class="firstSentenceFont">3: Payment and Account Info</span><br />
				
				It's been said that you can't put a price on good health.<%=HtmlUtils.doubleLB(request)%>
				
				We did our best to approximate.<%=HtmlUtils.doubleLB(request)%>
				
				Setting up an account with us is easy, and paying with PayPal is even 
				easier. (Parting with your money is another story.)<%=HtmlUtils.doubleLB(request)%>
				
				If you'd like to become a member of Kqool, click <a href="../login/join.jsp?<%=controller.getSiteIdNVPair()%>">here</a>. Simply fill out the membership 
				form, and you'll be guided through the payment process.  Kqool membership is US$<%=siteProps.getStandardMonthlyCost()%> a month. All Kqool.com payments are 
				billed by PayPal, the credit-card payment processor owned by Ebay. To find out more 
				about PayPal, click <a href="https://www.paypal.com" target="_blank">here</a>.
				<br />
				<%=HtmlUtils.doubleLB(request)%>

				<table border="0" cellspacing="0" cellpadding="0">
				<tr valign="middle">
				<td class="bodyFont">Press&nbsp;<br /></td>
				<td class="bodyFont" width="21" nowrap="nowrap" height="29" style="width:21px;"><script type="text/javascript">
				writeKey(9)
				</script><br /></td>
				<td class="bodyFont"><nobr>&nbsp;to return to the main menu.</nobr><br /></td>
				</tr>

				</table><br /><br />
				<%
			}
			else if (homepageSection==4) {
				%>
				<span class="firstSentenceFont">4: The Wizard of Kqool</span><br />
				
				We offered the Wizard of Kqool the finest of our livestock, the
				bounties of our harvest, and three of our most beautiful maidens. In
				return, he granted us ten minutes in his presence to ask our most
				probing and personal questions.  What follows is a transcript of 
				this exchange.<br /><br /><br />
				
				<b>Q:</b> Oh Wizard of Kqool, please tell us &mdash; where did you come from? To 
				what or whom do we owe our awe and gratitude?<br />
				
				<b>A:</b>  I sprouted up in the fields of Alabama, and ripened in the 
				barrios of Queens, New York.  As for the source of my greatness, 
				I'm sure my parents would appreciate any awe and gratitude 
				you'd like to send their way.<%=HtmlUtils.doubleLB(request)%>
				
				<b>Q:</b> How did you hone your awesome powers and skills?<br />
				
				<b>A:</b> I began my own intensive training program about 12 years ago 
				&mdash; eager to defy my genetic leaning towards being "skinny."  
				I woke up to the necessity of caring for my body when I 
				injured my spine, and realized that I needed to actively 
				build my strength and endurance in order to live a healthy 
				and enjoyable life.<%=HtmlUtils.doubleLB(request)%>
				
				<b>Q:</b> So you weren't always the picture of physical male 
				perfection that we all know and worship today?<br />
				
				<b>A:</b> No.  Believe it or not, I was never athletic growing 
				up.  I studied liberal arts and music in college, and 
				paid little attention to eating right, working out, 
				or getting enough sleep.  I was skinny and out of shape.  
				I was 6'1" and only 145lbs in college, whereas I'm the 
				same height and 192lbs today.<%=HtmlUtils.doubleLB(request)%>
				
				<b>Q:</b> How did you go about becoming such a fitness Wizard?  
				When did you start sharing your magic with others?<br />
				
				<b>A:</b> I decided to study a very old-school method of 
				bodybuilding to improve my strength and self-esteem.  
				Once I started working out, the gym became like a home 
				to me.  And, the results paid off. I started to get 
				freelance jobs as an apparel and fragrance model.  
				I was looking good, and feeling even better. People 
				began to ask me for advice on training &mdash; on how I got 
				my body to look the way it did.  It was then that 
				I realized that I had a skill that I could share.  
				People were interested in improving their physique 
				and their state of mind, and I knew that I could help 
				them to do both.<%=HtmlUtils.doubleLB(request)%>
				
				<b>Q:</b> How many people have you enlightened with your 
				divine fitness intervention?<br />
				
				<b>A:</b> Probably around 400, at this point.  I have over 
				18,000 hours of training experience &mdash; and that's 
				just counting my years as a full-time personal 
				trainer.  I was training clients part-time for about 
				7 years before I made personal training my career.<%=HtmlUtils.doubleLB(request)%>
				
				<b>Q:</b> What kinds of mystical titles and skills do you hold?<br />
				
				<b>A:</b> Well, I've been certified by the National Academy 
				of Sports Medicine (NASM) and the American Council of 
				Exercise (ACE).  I'm also trained in CPR and AED.  
				Currently, I'm studying to become a "Flexibility 
				Specialist."<%=HtmlUtils.doubleLB(request)%>
				
				<b>Q:</b> Oh Wizard! Bestow your ultimate wisdom upon us.  
				Tell us, what is the essence of the Kqool way of life?<br />
				
				<b>A:</b> The Kqool mantra is this: "If I feel good, I will 
				look good &mdash; and people will see the love I have for 
				myself in the way that I treat my body."<%=HtmlUtils.doubleLB(request)%>
				
				Kqool is about looking your best, but more importantly, 
				it's about feeling your best.  I strive to help my 
				clients reach "Kqool Inner Peace" &mdash; a state in which 
				their attitudes about themselves are reflected in how 
				they take care of their bodies, their minds, and their 
				spirits.  Adopting the Kqool way of life provides my 
				clients with a total philosophy that guides their 
				health and well being to their most mature and gratifying 
				states.
				
				  


				
				<br />
				<%=HtmlUtils.doubleLB(request)%>

				<table border="0" cellspacing="0" cellpadding="0">
				<tr valign="middle">
				<td class="bodyFont">Press&nbsp;<br /></td>
				<td class="bodyFont" width="21" nowrap="nowrap" height="29" style="width:21px;"><script type="text/javascript">
				writeKey(9)
				</script><br /></td>
				<td class="bodyFont"><nobr>&nbsp;to return to the main menu.</nobr><br /></td>
				</tr>

				</table><br /><br />
				<%
			}
			else if (homepageSection==5) {
				%>
				<span class="firstSentenceFont">5: Leave a Message</span><br />
				
				
				Questions?  Concerns?  Unabashed Praise?  Leave them here. We'll hustle to respond. <a href="javascript:launchFeedback(false)">BEEP!</a><%=HtmlUtils.doubleLB(request)%>
				
				


				<%=HtmlUtils.doubleLB(request)%>

				<table border="0" cellspacing="0" cellpadding="0">
				<tr valign="middle">
				<td class="bodyFont">Press&nbsp;<br /></td>
				<td class="bodyFont" width="21" nowrap="nowrap" height="29" style="width:21px;"><script type="text/javascript">
				writeKey(9)
				</script><br /></td>
				<td class="bodyFont"><nobr>&nbsp;to return to the main menu.</nobr><br /></td>
				</tr>

				</table><br /><br />
				<%
			}

%>
<br />
<br /><br />



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

