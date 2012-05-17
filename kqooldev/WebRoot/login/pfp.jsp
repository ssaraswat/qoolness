<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_PERSONAL_FITNESS_PROFILE,request); %>
<% PageUtils.setShowTopNav(false,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%@ include file="includes/pfpItemsDef.jsp" %>

<%

User user=null;
boolean userFound;
try {
	user=User.getByUsername(controller.getParam("n"));
	if (user==null) {
		throw new RuntimeException("User not found.");
	}
	userFound=true;
}
catch (RuntimeException e) {
	userFound=false;
}



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

// this page may load in a frame (e.g. on the "list" page), so don't allow that:

if (top.frames.length>0)
{
	top.location.replace(""+location.href)
}

function isValidForm(formObj)
{

	hidePageAndShowPleaseWait();
	return true;
}

</script>

<style type="text/css">
 
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id=<%=isPopup?"popupMainDiv":"mainDiv"%>>
<span style="width:300px;">

	

	
	
	<form action="processPfp.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 
	<input type="hidden" name="userId" value="<%=user.getId()%>" />
	<font class="bodyFont">
	<%
	if (userFound) {
		%>
	<span class="firstSentenceFont">Tell us about yourself.</span><br />
	Please provide us with the information requested below.  We need it to formulate 
	a workout program that's specifically tailored to your fitness needs and goals.<br /><br />

	<i>Note: None of the following questions are for diagnostic or treatment purposes.</i><br /><br />

	<b>Your age?</b><br />
	<input type="text" name="pfp_age" class="inputText" style="width:63px;" /><br /><br />

	<b>Your height?</b><br />
	<input type="text" name="pfp_height" class="inputText" style="width:100px;" /><br /><br />

	<b>Your weight?</b><br />
	<input type="text" name="pfp_weight" class="inputText" style="width:100px;" /><br /><br />

	
	<b>What is your level of physical activity?</b><br />
	<select name="pfp_activityLevel" class="selectText" style="width:215px;">
	<option value="">...</option>
	<option value="Not very active at all">Not very active at all</option>
	<option value="Moderately active">Moderately active</option>
	<option value="About average">About average</option>
	<option value="Very active">"Very active</option>
	<option value="Extremely active">Extremely active</option>
	</select><br /><br />
 
	<b>Do you currently exercise?</b><br />
	<select name="pfp_currentlyExercise" class="selectText" style="width:215px;">
	<option value="">...</option>
	<option value="No">No</option>
	<option value="Yes, less than once a week">Yes, less than once a week</option>
	<option value="Yes, once a week">Yes, once a week</option>
	<option value="Yes, twice a week">Yes, twice a week</option>
	<option value="Yes, three or four times a week">Yes, three or four times a week</option>
	<option value="Yes, five or six times a week">Yes, five or six times a week</option>
	<option value="Yes, seven or more times a week">Yes, seven or more times a week</option>
	</select><br /><br />

	<b>If "yes," for how much per day?</b><br />
	<select name="pfp_howLongExercise" class="selectText" style="width:215px;">
	<option value="">...</option>
	<option value="">Fifteen minutes</option>
	<option value="">Half an hour</option>
	<option value="">Forty-five minutes</option>
	<option value="">An hour</option>
	<option value="">An hour and a half</option>
	<option value="">Two hours</option>
	<option value="">Two and a half hours</option>
	<option value="">Three hours</option>
	<option value="">More than three hours</option>
	</select><br /><br />
	
	<table border="0" cellspacing="0" width="300" cellspacing="0" cellpadding="0">
	<% 
	request.setAttribute("currGroup",PAST_EXERCISE);
	request.setAttribute("subhead",null);
	request.setAttribute("postNote",null);
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(true));
	pageContext.include("includes/pfpItemsGroup.jsp");
	%>
	
	<tr>
	<td colspan="3"><br />
	<%
	request.setAttribute("subhead","If you currently exercise, what exercises does your workout include?");
	request.setAttribute("fieldName","pfp_currentWorkout");
	pageContext.include("includes/pfpTextarea.jsp");
	%>
	</td>
	</tr>

	<tr>
	<td colspan="3">
	<%
	request.setAttribute("subhead","What are your short and long term goals for exercise, health and fitness?");
	request.setAttribute("fieldName","pfp_goals");
	pageContext.include("includes/pfpTextarea.jsp");
	%>
	</td>
	</tr>

	<tr>
	<td colspan="3">
	<%
	request.setAttribute("subhead","Do you have any other comments regarding your level of fitness or your fitness needs?");
	request.setAttribute("fieldName","pfp_comments");
	pageContext.include("includes/pfpTextarea.jsp");
	%>
	</td>
	</tr>


	<% 
	request.setAttribute("currGroup",MED_CONDITIONS_1);
	request.setAttribute("subhead","Have you ever been diagnosed with, or suffered from:");
	request.setAttribute("postNote","If you answered \"yes\" to any of the above conditions you <i>must have medical clearance before joining any exercise program.</i>");
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(false));
	pageContext.include("includes/pfpItemsGroup.jsp");
	%>
	
	<tr>
	<td colspan="3"><br /></td>
	</tr>

	<% 
	request.setAttribute("currGroup",MED_CONDITIONS_2);
	request.setAttribute("subhead","Have you ever been diagnosed with or do you have any of the following:");
	request.setAttribute("postNote",null);
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(false));
	pageContext.include("includes/pfpItemsGroup.jsp");
	%>
	
	<tr>
	<td colspan="3"><br /><br /></td>
	</tr>

	<% 
	request.setAttribute("currGroup",MED_CONDITIONS_3);
	request.setAttribute("subhead","Do you frequently experience any of the following:");
	request.setAttribute("postNote",null);
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(false));
	pageContext.include("includes/pfpItemsGroup.jsp");
	%>
	
	<tr>
	<td colspan="3"><br /><br /></td>
	</tr>

	<% 
	request.setAttribute("currGroup",MED_CONDITIONS_4);
	request.setAttribute("subhead",null);
	request.setAttribute("postNote",null);
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(true));
	pageContext.include("includes/pfpItemsGroup.jsp");
	%>
	

	<tr>
	<td colspan="3"><br />
	<%
	request.setAttribute("subhead","Are you currently taking any medications? If so please specify.");
	request.setAttribute("fieldName","pfp_takingMedications");
	pageContext.include("includes/pfpTextarea.jsp");
	%>
	</td>
	</tr>

	<tr>
	<td colspan="3">
	<%
	request.setAttribute("subhead","Are you currently on a special diet? If yes, please explain.");
	request.setAttribute("fieldName","pfp_specialDiet");
	pageContext.include("includes/pfpTextarea.jsp");
	%>
	</td>
	</tr>

	<tr>
	<td colspan="3">
	<%
	request.setAttribute("subhead","Do you have any physical condition, impairment or disability that might affect your ability to under take an exercise program?");
	request.setAttribute("fieldName","pfp_specialPhysicalConditions");
	pageContext.include("includes/pfpTextarea.jsp");
	%>
	</td>
	</tr>


	
	
	</table>
	
	<b>What prompted you to pursue online training?</b><br />
	<select name="pfp_whyOnlineTraining" class="selectText" style="width:300px;">
	<option value="">...</option>
	<option value="I want to look and feel better">I want to look and feel better</option>
	<option value="Gym prices are expensive">Gym prices are expensive</option>
	<option value="I like to train on my own">I like to train on my own</option>
	<option value="I decided to try it to motivate myself">I decided to try it to motivate myself</option>
	<option value="I am responding to a promotion or ad">I am responding to a promotion or ad</option>
	<option value="A friend suggested it">A friend suggested it</option>
	</select><br /><br />
	
	<b>What do you value most about personal training?</b><br />
	<select name="pfp_whatMotivatesAboutPersonalTraining" class="selectText" style="width:300px;">
	<option value="">...</option>
	<option value="The discipline">The discipline</option>
	<option value="The education">The education</option>
	<option value="The motivation">The motivation</option>
	<option value="The results">The results</option>
	<option value="The time I save by working out more efficiently">The time I save by working out more efficiently</option>
	<option value="I am new to training">I am new to training</option>
	</select><br /><br />
	

	<b>What aspect of your health and well-being has improved the most from personal training?</b><br />
	<select name="pfp_whatsImprovedMost" class="selectText" style="width:300px;">
	<option value="">...</option>
	<option value="My appearance">My appearance</option>
	<option value="My flexibility">My flexibility</option>
	<option value="My stamina and aerobic fitness">My stamina and aerobic fitness</option>
	<option value="My strength and lean body mass">My strength and lean body mass</option>
	<option value="I am new to training">I am new to training</option>

	</select><br /><br />

	<br />
Thank you for telling us who you are.  Now, get ready to change that for the better. Click "submit" below.<br /><br /><br />

<%=HtmlUtils.formButton(true,"submit",null,request)%>
<br />



      
		<%
	}
	else {
		%>
			<span class="firstSentenceFont">Hmm...</span><br />
	There's a problem.  We don't recognize the username "<%=controller.getParam("n")%>".  Not to worry: please <a href="#" onclick="launchFeedback(false); return false">contact us</a>
	 and we'll get to the bottom of it.<br /><br />
		
		<%
	}
	
	%>
	<br /><br /></font>

	</form>
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

