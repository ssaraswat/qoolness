<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
  
 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>     
 
<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>
<% PageUtils.setShowTopNav(false,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%> 

<%


boolean error=controller.getParamAsBoolean("error");

SessionInfo sessionInfo=controller.getSessionInfo();

boolean isRecognizedUser=false;
User user=user=new User();
try {
	user=User.getByUsername(request.getParameter("username"));
	if (user==null) {
		throw new RuntimeException("User not found.");
	}
	isRecognizedUser=true;
}
catch (RuntimeException e) {}


boolean secretQuestionOnFile=false;

int secretQuestion=0;

String questionText="";

if (isRecognizedUser)
{
	secretQuestion=user.getSecretQuestion();
	if (secretQuestion>0)
	{
		secretQuestionOnFile=true;
		for (int i=0; i<AppConstants.SECRET_QUESTION_LABELS.length; i++)
		{
			if (secretQuestion==AppConstants.SECRET_QUESTION_VALUES[i])
			{
				questionText=AppConstants.SECRET_QUESTION_LABELS[i];
				break;
			}
		}
	}
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
	var els=formObj.elements

	if (trim(els["secretAnswer"].value).length==0)
	{
		errorAlert("You have not entered an answer.  Please enter one and try again.",els["secretAnswer"])
		return false
	}
	hidePageAndShowPleaseWait()
	return true
}

</script>

<style type="text/css">
 
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id=<%=isPopup?"popupMainDiv":"mainDiv"%>>
<span class="standardTextBlockWidth">

<%
if (error)
{	
	%>
	<div class="errorDiv"><font class="bodyFont">
	The answer that you gave to your secret question was not the same answer you entered when you originally entered your answer.  Please try again, making sure that you've typed exactly what you typed before.
	</font></div><br />
	<%
}
%>


	<%
	if (!isRecognizedUser)
	{
		%>
		<form action="#" onsubmit="return false">
		<font class="bodyFont">    
		<span class="firstSentenceFont">Hmmm...</span><br />"<%=controller.getParam("username")%>" is not a recognized username.  Please click "back" and try again.<br /><br />
		
		<%=HtmlUtils.formButton(false, "back", "history.go(-1)", request)%><br />

		</font>


		</form>
		<%
	}
	else if (!secretQuestionOnFile)
	{
		%>
		<form action="#" onsubmit="return false">
		<font class="bodyFont">    
		<span class="firstSentenceFont">Hmmm...</span><br />Kqool does not have a secret question/answer combination on file for user "<%=controller.getParam("username")%>". Please send mail <a href="mailto:<%=siteProps.getCommentsEmailAddress()%>">here</a> for assistance.<br /><br />

		<%=HtmlUtils.formButton(false, "back", "history.go(-1)", request)%><br />

		</font>


		</form>
		<%
	}
	else
	{
		%>
		<form action="processSecretQuestion.jsp?<%=controller.getSiteIdNVPair()%>&isPopup=<%=isPopup%>" method="post" onsubmit="return isValidForm(this)">
		<input type="hidden" name="username" id="username" value="<%=controller.getParam("username")%>">
		<font class="bodyFont">    
		<span class="firstSentenceFont">Your secret question is...</span><br />"<%=questionText%>"  Please type your answer below, then click "submit." Be aware, you must type the answer exactly as you did when you originally answered this question:<br /><br />
		<span class="boldishFont">Answer to secret question</span><br />
		<input type="text" class="inputText" name="secretAnswer" id="secretAnswer" size="26"><%=HtmlUtils.doubleLB(request)%><br />
		<%=HtmlUtils.formButton("submit", request)%><br />
		<br /><br />

		

		</font>


		</form>
		<%
	}
	%>

      
      
      
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

