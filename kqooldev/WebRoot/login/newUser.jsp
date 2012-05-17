<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
  
 
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>     

<% PageUtils.setRequiredLoginStatus("none",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_LOGIN,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%> 

<%



SessionInfo sessionInfo=controller.getSessionInfo();

User user=sessionInfo.getUser();
boolean accountCreated=controller.getParamAsBoolean("ac", false);


String firstName=null;
String lastName=null;
String emailAddress=null;
String emergencyContact=null;
int secretQuestion=-1;
String secretAnswer=null;
String addressLine1=null;
String addressLine2=null;
String city=null;
String stateProvinceCode=null;
String postalCode=null;
String homeTelephone=null;
String workTelephone=null;
String mobileTelephone=null;

if (user!=null) {
	Address address=Address.getByUserId(user.getId());
	if (address==null) {
		address=new Address();
	}
	if (request.getParameter("firstName")==null) {
		firstName=PageUtils.nonNull(user.getFirstName());
		lastName=PageUtils.nonNull(user.getLastName());
		emailAddress=PageUtils.nonNull(user.getEmailAddress());
		emergencyContact=PageUtils.nonNull(user.getEmergencyContact());
		secretQuestion=user.getSecretQuestion();
		secretAnswer=PageUtils.nonNull(user.getUnencryptedSecretAnswer());
		addressLine1=PageUtils.nonNull(address.getAddressLine1());
		addressLine2=PageUtils.nonNull(address.getAddressLine2());
		city=PageUtils.nonNull(address.getCity());
		stateProvinceCode=PageUtils.nonNull(address.getStateProvinceCode());
		postalCode=PageUtils.nonNull(address.getPostalCode());
		homeTelephone=PageUtils.nonNull(address.getHomeTelephone());
		workTelephone=PageUtils.nonNull(address.getWorkTelephone());
		mobileTelephone=PageUtils.nonNull(address.getMobileTelephone());
	}
	else {
		firstName=request.getParameter("firstName");
		lastName=request.getParameter("lastName");
		emailAddress=request.getParameter("emailAddress");
		emergencyContact=request.getParameter("emergencyContact");
		secretQuestion=Integer.parseInt(request.getParameter("secretQuestion"));
		secretAnswer=request.getParameter("secretAnswer");
		addressLine1=request.getParameter("addressLine1");
		addressLine2=request.getParameter("addressLine2");
		city=request.getParameter("city");
		stateProvinceCode=request.getParameter("stateProvinceCode");
		postalCode=request.getParameter("postalCode");
		homeTelephone=request.getParameter("homeTelephone");
		workTelephone=request.getParameter("workTelephone");
		mobileTelephone=request.getParameter("mobileTelephone");
	}
}

boolean redirectToLogin=(user==null || user.getUnencryptedPassword().trim().length()>0);

Calendar now=new GregorianCalendar();
int currYear=now.get(Calendar.YEAR);

List states=AmericanState.getAll();
Collections.sort(states);
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

	if (els["firstName"].value.length==0)
	{
		errorAlert("You have not entered a first name.  Please enter one and try again.",els["firstName"])
		return false
	}
	if (els["lastName"].value.length==0)
	{
		errorAlert("You have not entered a last name.  Please enter one and try again.",els["lastName"])
		return false
	}
	if (els["emailAddress"].value.length==0)
	{
		errorAlert("You have not entered an email address.  Please enter one and try again.",els["emailAddress"])
		return false
	}
	if (els["addressLine1"].value.length==0)
	{
		errorAlert("You have not entered an address.  Please enter one and try again.",els["addressLine1"])
		return false
	}
	if (els["city"].value.length==0)
	{
		errorAlert("You have not entered a city.  Please enter one and try again.",els["city"])
		return false
	}
	if (selectValue(els["stateProvinceCode"])==null || selectValue(els["stateProvinceCode"])=="")
	{
		errorAlert("You have not chosen a state.  Please choose one and try again.",els["stateProvinceCode"])
		return false
	}	
	if (els["postalCode"].value.length==0)
	{
		errorAlert("You have not entered a ZIP code.  Please enter one and try again.",els["postalCode"])
		return false
	}
	if (els["homeTelephone"].value.length==0 && els["workTelephone"].value.length==0 && els["mobileTelephone"].value.length==0)
	{
		errorAlert("You have not entered a home, work, or mobile telephone; at least one of these is required.  Please fix and try again.",els["homeTelephone"])
		return false
	}
	if (trim(els["emergencyContact"].value).length==0)
	{
		errorAlert("You have not entered an emergency contact.  Please enter one and try again.",els["emergencyContact"])
		return false
	}
	if (els["password"].value.length==0)
	{
		errorAlert("You have not entered a password.  Please enter one and try again.",els["password"])
		return false
	}
	if (els["passwordRetype"].value.length==0)
	{
		errorAlert("You have not retyped your password.  Please fix and try again.",els["passwordRetype"])
		return false
	}
	if (selectValue(els["secretQuestion"])==null || selectValue(els["secretQuestion"])=="")
	{
		errorAlert("You have not chosen a secret question.  Please choose one and try again.",els["secretQuestion"])
		return false
	}	

	
	
	
	if (els["secretAnswer"].value.length==0)
	{
		errorAlert("You have not entered an answer to your secret question.  Please enter one and try again.",els["secretAnswer"])
		return false
	}
	
	if (!isValidEmail(els["emailAddress"].value)) {
		errorAlert("The email address you have entered is not valid.  'john@mymail.com' is an example of a valid email address.  Please enter one and try again.",els["emailAddress"])
		return false
	}
	if (!isValidZIP(els["postalCode"].value)) {
		errorAlert("The ZIP code you have entered is not valid.  Please enter your five-digit ZIP code and try again.",els["postalCode"])
		return false
	}
	if (!isValidPassword(els["password"].value)) {
		errorAlert("The password you have entered is not valid.  Passwords must be between six and 16 characters long and may contain only letters, numerals, underscores, hyphens, and periods. Please fix and try again.",els["password"])
		return false
	}
	if (!isValidSecretAnswer(els["secretAnswer"].value)) {
		errorAlert("The secret answer you have entered is not valid.  Secret answers must be between one and 16 characters long and may contain only letters, numerals, underscores, hyphens, spaces, and periods. Please fix and try again.",els["secretAnswer"])
		return false
	}
	if (els["password"].value!=els["passwordRetype"].value) {
		errorAlert("The password and the retyped password do not match. Please fix and try again.",els["passwordRetype"])
		return false
	}
	if (!(els["termsAccepted"].checked)) {
		errorAlert("You have not agreed to the terms and conditions. Please fix and try again.",els["termsAccepted"])
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
<span style="width:300px;">

	
	<%
	if (redirectToLogin) {
		out.flush();
		response.flushBuffer();
		controller.redirect("login.jsp?"+controller.getSiteIdNVPair());
	}
	else {
	%>
	
	
	<form action="processNewUser.jsp?<%=controller.getSiteIdNVPair()%>&ac=<%=accountCreated%>&isPopup=<%=(isPopup?"true":"false")%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 
	<font class="bodyFont">
	<%
	if (accountCreated) { // if coming from PayPal payment path: 
		%>
				<span class="firstSentenceFont">Success!</span><br />
				We've received your payment.
				Your account has been created. Now it's time to create the new you.<br /><br />

Since this is your first login, please complete the registration process by supplying us with the information below.  Then press "submit."

		
		<%
	}
	else { 
		%>
				<span class="firstSentenceFont">Welcome back.</span><br />Since this is your first login, please complete the registration process by supplying us with the information below.  Then press "submit."
		
		<%
	}
	%>
	
	


	<%=HtmlUtils.doubleLB(request)%><br />

	<span class="boldishFont">First Name</span><br />
	<input class="inputText" type="text" style="width:300px;" name="firstName" id="firstName" value="<%=firstName%>"><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Last Name</span><br />
	<input class="inputText" type="text"  style="width:300px;"  name="lastName" id="lastName" value="<%=lastName%>"><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Email Address</span><br />
	<input class="inputText" type="text"  style="width:300px;"  name="emailAddress" id="emailAddress" value="<%=emailAddress%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">Address Line 1</span><br />
	<input class="inputText" type="text"  style="width:300px;"  name="addressLine1" id="addressLine1" value="<%=addressLine1%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">Address Line 2</span><br />
	<input class="inputText" type="text"  style="width:300px;"  name="addressLine2" id="addressLine2" value="<%=addressLine2%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">City</span><br />
	<input class="inputText" type="text"  style="width:300px;"  name="city" id="city" value="<%=city%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">State</span><br />
	<select class="selectText"  style="width:190px;"  name="stateProvinceCode" id="stateProvinceCode">
	<option value="">...</option>
	<%

	for (int i=0; i<states.size(); i++) {
		AmericanState state=(AmericanState)states.get(i);
		%><option value="<%=state.getUspsCode()%>"><%=state.getName()%></option>
		<%
	}
	%>
	</select><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">ZIP Code</span> (5-digit)<br />
	<input class="inputText" type="text"  style="width:95px;"  name="postalCode" id="postalCode" value="<%=postalCode%>"><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Home Telephone</span><br />
	<input class="inputText" type="text"  style="width:190px;"  name="homeTelephone" id="homeTelephone" value="<%=homeTelephone%>"><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Work Telephone</span><br />
	<input class="inputText" type="text"  style="width:190px;"  name="workTelephone" id="workTelephone" value="<%=workTelephone%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">Mobile Telephone</span><br />
	<input class="inputText" type="text"  style="width:190px;"  name="mobileTelephone" id="mobileTelephone" value="<%=mobileTelephone%>"><%=HtmlUtils.doubleLB(request)%>
<%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Birthdate</span><br />
	<%
	HtmlUtils.dateFields("birthYear", "birthMonth", "birthDate", "birthYear", "birthMonth", "birthDate", false, false, currYear-100, currYear-17, pageContext, controller);
	%><%=HtmlUtils.doubleLB(request)%>




	<span class="boldishFont">Emergency Contact</span> (name, relationship, telephone)<br />
	<input class="inputText" type="text"  style="width:300px;"  name="emergencyContact" id="emergencyContact" value="<%=emergencyContact%>"><%=HtmlUtils.doubleLB(request)%>
<br /><br />



Please choose a password for yourself (and then retype it).  You may want to write it down so you don't forget it; remember that passwords are case-sensitive.  Passwords may be between six and 16 characters long, and may contain letters, numerals, underscores, hyphens, and periods only.<%=HtmlUtils.doubleLB(request)%>	
	<span class="boldishFont">Password</span><br />
	<input maxlength="16" class="inputText" type="password" style="width:95px;" name="password" id="password" value=""><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Retype Password</span><br />
	<input maxlength="16" class="inputText" type="password" style="width:95px;" name="passwordRetype" id="passwordRetype" value=""><%=HtmlUtils.doubleLB(request)%>	

<%=HtmlUtils.doubleLB(request)%>


Please choose a "secret question" for yourself, and enter the answer.  If you ever lose your password, you will prove your identity to Kqool.com by answering this question correctly.  (Note: it will be very important that you type the anwser to your secret question exactly as you type it here, so you may want to keep the answer simple.)<%=HtmlUtils.doubleLB(request)%>	
	<span class="boldishFont">Secret Question</span><br />
	<select class="selectText"  style="width:300px;"  name="secretQuestion" id="secretQuestion">
	<option value="">...</option>
	<%
	for (int i=0; i<AppConstants.SECRET_QUESTION_LABELS.length; i++) {
		%><option value="<%=(i+1)%>" <%=(secretQuestion==i+1?" selected":"")%>><%=AppConstants.SECRET_QUESTION_LABELS[i]%></option><%
	}
	%>
	</select><%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Answer to secret question</span><br />
	<input maxlength="16" class="inputText" type="text"  style="width:300px;"  name="secretAnswer" id="secretAnswer" value="<%=secretAnswer%>"><%=HtmlUtils.doubleLB(request)%>
	<%=HtmlUtils.doubleLB(request)%>

	<span class="boldishFont">Terms and conditions:</span> please read them...<br />
	<textarea name="terms" rows="10" cols="10" style="width:300px; height:130px; " class="inputText" readonly="readonly"><%
	pageContext.include("../global/termsAndConditionsIncludeTxt.jsp");
	%></textarea><br />
	...then indicate your acceptence by checking this checkbox:<%=HtmlUtils.doubleLB(request)%>
	&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="termsAccepted" id="termsAcceptedTrue" value="true"><label for="termsAcceptedTrue">I have read the agreement, and accept it.</label><%=HtmlUtils.doubleLB(request)%><%=HtmlUtils.doubleLB(request)%>

<%=HtmlUtils.formButton(true,"submit",null,request)%>
<br />

	<br /></font>

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

