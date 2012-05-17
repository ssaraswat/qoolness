<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_FAQ,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%!
static final String[] getQuestions(Controller controller)  {
	String[] questions= {
	"Membership and Fees",
	"How much does a Kqool membership cost?",
	"Are there any fees other than the monthly membership fee?",
	"Does Kqool charge a startup fee when I open an account?",
	"How do I pay for Kqool?",
	"Can several people share an account?",
	"Do I have to look at any ads or popups or anything on Kqool.com?",
	"Does Kqool offer a group discount?",
	"I'm going to Finland for the summer.  Can I suspend my account?",
	
	"Privacy and Security",
	"Is my personal information stored securely?",
	"What does Kqool do with my personal information?",
	"Does Kqool have access to the information I enter on the site?",
	"What about credit-card information; do Kqool staff have access to that?",
	"What is the meaning of life?",
	
	"Technical Stuff",
	"What kind of browser do I need to use Kqool?",
	"What do I need to view the videos?",
	"Emails from Kqool keep ending up in my spam folder; what can I do about that?",
	"When I enter my username and password and then click the \"log in\" button, I keep returning to the login screen, but there are no error messages telling me what I did wrong.  What's up with that?",
	"Why does the text go from left to right?",
	"I have popup-blocker software on my browser.  Why does it keep blocking popups from Kqool?  I thought Kqool didn't have any ads on it.",
	"How do I make a shortcut to Kqool.com on my desktop, so that in the event of an emergency, I can get to Kqool.com with minimal delay?",
	"Kqool keeps logging me out.  I don't like that.",
	
	"Your Account",
	"I can't log on because it asks me for a password, but I don't know what my password is.",
	"What if my email address, phone number, or other personal information changes?",
	"I want to change my password.  My old one doesn't reflect the new, smokingly hot me.",
	"I'm tired of my username. Can I change it?",
	"What do I do if I forget my password?",
	"What about my username?  What if I forget that?",
	"How do I change my secret question, or my answer to it?",
	"I'm trying to log onto Kqool.com, but it's telling me that I haven't paid yet.",
	"How do I log out?",
	"How do I cancel my account?",
	"Are muscles better than bones?",
	
	"Exercises, Routines, and Workouts",
	"My legs fell off after performing the routine you assigned to me.  Is that normal?",
	"I'm tired of entering my workout every day; it takes a lot of time.",
	"What's the difference between a \"routine\" and a \"workout\"?",
	"I just joined Kqool; how come Kqool hasn't assigned a routine to me yet?",
	"What if I don't know how to do the exercises?",
	"What if I don't know which exercises to do?",
	"What if I don't know how hard to do the exercises?",
	"I don't normally take my laptop to the gym; how do I remember what I did so I can record it on Kqool.com later?",
	"How do I know when Kqool has assigned a new routine to me?",
	"How does Kqool monitor my progress?",
	"What if there's an exercise that I do a lot and want to record in my workouts, but it's not in the Kqool database?",
	"What is a \"Phase IV Harrington Maneuver\"?",
	
	"Etc.",
	"There's a feature I'd love to see that's not currently a part of Kqool.",
	"What's coming soon on Kqool?",
	"Where is Kqool.com located?",
	};
	return questions;

};

static final String[] getAnswers(Controller controller)  {
	String[] answers= {
	null,
	"A Kqool.com membership costs $39.95 per month.",
	"No.  And there is no fee to join Kqool either.  Nor is there a fee to suspend your membership, or to cancel it.",
	"No.  Just the monthly membership fee.",
	"You pay for Kqool with your credit or debit card (via PayPal) which Kqool charges once a month.  You will receive e-mail every month reminding you of this.",
	"Afraid not: accounts are for use by one person only.",
	"No.  Kqool didn't think it would be fair to charge you a monthly membership fee and then also make you look at ads.  Not fair, and also sort of cheesy.",
	"Depends.  Wanna make us an offer we can't refuse? <a href=\"#\" onclick=\"launchFeedback(false); return false;\">Talk to us</a>.",
	"Yes, you may suspend your account, because you're going to Finland or for any other reason, on a per-month basis.  Your account will be waiting for you when you get back (send us an email letting us know that you're back).  You just need to let us know <i>beforehand</i> that you want to suspend your account.  Not allowed: being too busy to log into Kqool for two months and then asking for an after-the-fact suspension.  Please don't ask, because we'll have to say no.",
	
	null,
	"Yes.  Kqool stores all of your information in a secure database, and sensitive information such as passwords is encrypted before storage.  And Kqool doesn't even know about your credit-card information, since payment for Kqool is processed via PayPal, the online payment service owned by Ebay.",
	"Nothing &mdash; or at least nothing sneaky.  We don't sell it to anyone, or share it with anyone, ever.  We need to know things like your height, weight, age, gender, medical history, and so on, so that we can tailor your routines to you, and help you to meet your fitness goals.  And this information is stored in a secure database.  See our <a href=\"privacy.jsp?"+controller.getSiteIdNVPair()+"\">privacy policy</a> for further details.",
	"Yes, with the exception of your password and the answer to your \"secret question\" (these are also encrypted before being stored in the database).  Kqool needs the workout information that you enter, for example, to continue to tailor your routines to your abilities and needs.",
	"Payments for Kqool membership are processed via PayPal, the online-payments company owned by Ebay.  Therefore, Kqool does not have access to your credit-card information, since you never actually enter this information into the Kqool site (you enter it into the PayPal site).",
	"After you're born, you are \"alive,\" which lasts for perhaps sixty-five to 100 years. Then you die. Not sure if that answers the question.",
	
	null,
	"You need to have Microsoft Internet Explorer 5.0 or higher, or Netscape 6.0 or higher, for Windows of Macintosh.  You can download Internet Explorer <a href=\"http://www.microsoft.com/downloads/details.aspx?FamilyID=1e1550cb-5e5d-48f5-b02b-20b602228de6&displaylang=en\" target=_blank>here</a>, or Netscape <a href=\"http://channels.netscape.com/ns/browsers/download.jsp\" target=_blank>here</a>.  Kqool will probably also work fine for you if you use Firefox, Opera, or Safari, but we're not making any promises.  You also need to have both JavaScript and session-based cookies enabled on your browser.  Both of these are enabled by default.",
	"You'll need Quicktime.  If you have a Macintosh, you've already got it; if you use Windows, you may or may not have it.  It's free, and is available for download <a href=\"http://www.apple.com/quicktime/download/\" target=_blank>here</a>.",
	"The subject line of all email messages from Kqool starts with \"[kqool]\".  Because of this, if you have spam-blocker software, you can tell it that messages whose subjects begin with \"[kqool]\" are not spam.  You can also use this subject-line prefix to filter messages from Kqool into a different folder.  Consult your email program's manual (and/or your spam-blocker's manual) for details.",
	"You need to enable \"session-based\" cookies on your browser.  These are not the sort of cookies that some web sites use to track your activity online; they are deleted when you close your browser.  But Kqool needs them to keep track of whether or not you're logged in.  To enable session-based cookies on Internet Explorer 6.0 for Windows, choose the \"Internet Options\" item from the \"Tools\" menu, click the \"Privacy\" tab, click the \"Advanced\" button, and make sure the \"Override automatic cookie handling\" checkbox and the \"Always allow session cookies\" checkbox are both checked.  (If you're concerned about the other kind of cookies &mdash; non-session-based ones &mdash; click \"Block\" or \"Prompt\" under the First-Party and Third-Party Cookies headings.)  For other browsers, consult your browser's documentation.",
	"Because otherwise you'd have to read it in a mirror, which most users are simply not willing to do.",
	"Kqool is 100% ad free.  Kqool does use popup windows, though; for example, if you make an error when you're filling out a form, Kqool tells you this with a popup.  And when you click on a routine's name, Kqool shows you the routine in a popup window.  You can keep your popup-blocking software from blocking Kqool popups by telling it to allow popups from Kqool.com.  Consult your popup-blocker's documentation for further details.  (We're sorry that we keep saying \"please consult your software's documentation.\"  There are simply too many email programs, spam filters, popup blockers, and web browsers out there for us to be able to cover all the bases.)",
	"See the \"location bar\" above, where you enter the web address of the site you want to visit. There's a little icon just to the left of the address; most browsers will let you drag-and-drop that icon to your desktop.  Doing so will create a shortcut to Kqool.com.",
	"The site logs you out automatically if you don't interact with it for a certain period of time.",
	
	null,
	"If you're logging on for the first time, you don't need a password (and you won't be able to log in if you use one).  If you had a password but forgot it, see \"What do I do if I forget my password.\"",
	"Click \"my account\" on any page and enter the new, correct information.",
	"Click \"my account\" on any page; you can change your password there.",
	"You're pretty much stuck with your username once you've chosen it.  If you really, really, really don't like it, <a href=\"#\" onclick=\"launchFeedback(false); return false;\">contact us</a> and we'll change it for you.",
	"Go to the Kqool.com homepage and click the \"forgot your password?\" link.  Assuming you can provide the correct answer to the secret question you chose when you signed up, we'll tell you what your password is.  If you can't remember the answer to your secret question, contact Kqool <a href=\"#\" onclick=\"launchFeedback(false); return false;\">here</a>.  (Also, if you're logging in for the first time, you don't <i>have</i> a password yet, so you shouldn't enter one.  Just enter your username.)",
	"Your username is \"PrematureAlzheimers.\"  Not really.  Let's see: you chose your username when you signed up.  It's between six and sixteen characters long.  (It is <i>not</i> your email address, by the way.)  If you've forgotten your username, contact Kqool <a href=\"#\" onclick=\"launchFeedback(false); return false;\">here</a>.  Oh, and we also emailed you your username when you signed up, so it might still be in your inbox.",
	"You can't.  If you've forgotten the answer to your secret question and need it because you've forgotten your password, <a href=\"#\" onclick=\"launchFeedback(false); return false;\">let us know</a>.  We can't tell you what your password is because for your security, we don't have access to it.  But, we <i>can</i> reset your password for you.",
	"Well, that's no good: contact Kqool <a href=\"#\" onclick=\"launchFeedback(false); return false;\">here</a> and we'll sort it out.  (It will help us to sort it out if you include your PayPal subscription number, which PayPal emailed to you after you set up monthly Kqool payments.)",
	"Click the \"logout\" link at the bottom of the page.  (If you're not logged in, you won't see this link.)",
	"If you'd like to cancel your Kqool account, let us <a href=\"#\" onclick=\"launchFeedback(false); return false;\">know</a> (also let us know why, if you like).  You'll also want to log into your PayPal account and cancel your monthly subscription payment to us; we can't do that for you.",
	"Usually. Muscles tend to be softer than bones.  But bones are less susceptible to bruising than bones are.  It's sort of a toss-up.",
	
	null,
	"No, and in all seriousness, you should consult your doctor before undertaking an exercise program, especially if you have a pre-existing medical condition.",
	"There's a way around that. In the Fitness Tracker section, whenever you see a list of routines or workouts, there's a \"copy\" button next to each list item.  Choose the routine you just used and click the \"copy\" button next to it.  This lets you create a workout using the routine as a starting point.   It's similar to using \"Save As\" in many software programs.  (You can also record a workout using a recent workout as a starting point; again, click the appropriate \"copy\" button.)",
	"They look the same, but a routine is a list of exercises you're <i>going</i> to do, whereas a workout is a list of exercises you've <i>done</i>.  Kqool assigns personalized routines to you.  (You can also assign routines to yourself.)  When you've completed all the exercises in the routine, you enter them into Kqool and save them as a <i>workout</i>.",
	"It may take a few days for Kqool to formulate a routine for you.  Kqool routines really are assigned to you by an actual person, and this person needs to have time to review your personal-fitness information.  If you're impatient and want your routine <i>now</i>, please <a href=\"#\" onclick=\"launchFeedback(false); return false;\">contact Kqool</a>.You may also assign yourself a routine by going to the Fitness Tracker section of the site.",
	"No problem: Kqool has about 200 videos on file; they show you how to perform most exercises.  Most exercises are also accompanied by instructional text.  You'll be fine.",
	"This is where the \"personalized\" part comes in.  Kqool.com assigns you exercise routines tailored to your needs and goals.  Whenever Kqool assigns you a new routine, you'll receive an email telling you that, but if you missed it, you can always go to the Fitness Tracker section and click on the \"Kqool-assigned\" link.  Here, you'll see one or more routines created for you by Kqool.  (If you don't see any routines there, <a href=\"#\" onclick=\"launchFeedback(false); return false;\">let us know</a>.)",
	"Kqool doesn't just assign a list of exercises to you; Kqool also tells you how many of each one to do, how much weight to do each one with, how long to do each one, etc. ",
	"Kqool makes it easy for you to leave your laptop at home.  Before you head to the gym, log onto Kqool.com and print out a printer-friendly version of your routine and take it to the gym with you.  This printer-friendly routine-sheet-thing even has spaces for exercises you did that weren't originally part of the routine.  We've thought of everything, honestly.",
	"Because you get an email!  This email has a link in it; you click the link and then you see the new routine.",
	"Kqool gets an email every time you record a workout.  This way, we always know how you're progressing with the routines we assign you, and can continue to tailor these routines to your current needs.",
	"Please let us <a href=\"#\" onclick=\"launchFeedback(false); return false;\">know</a>.",
	"It's an exercise that involves not being able to walk for a while.  It's totally fun though, if you enjoy being debilitated by the type of pain that will harm your psyche in a fundamental way.",
	
	null,
	"Let us <a href=\"#\" onclick=\"launchFeedback(false); return false;\">know</a>!  Feedback from users plays a large part in determining what features are added to the site.",
	"Oh, all <i>kinds</i> of stuff.  We can't make any promises as to when, or as to specifics.  But for example, we plan in the future to let you record your daily nutrition on Kqool.  You'll be able to track your calories, fat grams, carbs, and so on; we know all about those, and we're building a database that will tell you automatically how many of these are in what you've eaten.  You'll also be able to keep track of your weight, and view your progress with tools like graphs and bar charts.  And we're always adding more videos and articles to our databases.  We'll keep you posted.  In the meantime, <a href=\"#\" onclick=\"launchFeedback(false); return false;\">let us know</a> what you'd like to see on Kqool.",
	"So you're hung up on this whole geography thing: how quaint; how 1991.  Kqool isn't really \"located\" anywhere.  If you have a computer and it's connected to the internet, then you can use Kqool.  Kqool will assign personalized routines to you, and help you to keep track of your progress, regardless of where you live.  Kqool has several members in <a href=\" http://www.cia.gov/cia/publications/factbook/geos/kz.html\" target=_blank>Kazakhstan</a>, actually.  (That's an exaggeration.)  But you want more: okay, so one could reasonably argue that Kqool is located on a rather long island, just east of New York City, whose area code is 516.  <i>The Great Gatsby</i>.  Joey Buttafuoco.  That's it: sorry.  No more hints.",
	};
	return answers;
}
%>

<%

String currentLoginStatus=PageUtils.nonNull(controller.getSessionInfo().getLoginStatus()).trim().toLowerCase();
boolean currentlyLoggedIn=(currentLoginStatus.equals("user") || currentLoginStatus.equals("backenduser"));
PageUtils.setShowTopNav(currentlyLoggedIn,request);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>


<script type="text/javascript">

</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<span class="standardTextBlockWidth">

<font class="bodyFont">


 


<span class="firstSentenceFont">Got questions?</span><br />
We've got answers.  In fact, we've got both. <br />
<br />
<a name="qTop"></a>
<%
String[] questions=getQuestions(controller);
String[] answers=getAnswers(controller);
for (int i=0; i<questions.length; i++) {
	if (answers[i]==null) {
		if (i>0) {
			%><br /><br /><%
		}
		%><b><%=questions[i]%></b><br />
		<img src="../images/spacer.gif" height="6" width="1" border="0" /><br /><%
	}
	else {
		%><span class="bodyFont"><a href="#ans<%=i%>"><%=questions[i]%></a></span><br />
		<img src="../images/spacer.gif" height="6" width="1" border="0" /><br /><%
	}
}
%>


<br /><br /><br />

<%
for (int i=0; i<questions.length; i++) {
	if (answers[i]==null) {
		continue;
	}
	%><a name="ans<%=i%>"></a><span class="boldishFont"><%=questions[i]%></span><br />
	<%=answers[i]%><br />
	<a href="#qTop"><img src="../images/smallButtons/backToTop.gif" height="19" width="81" vspace="6" border="0" /></a><br />
	<br />
	<%
}
%>


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

