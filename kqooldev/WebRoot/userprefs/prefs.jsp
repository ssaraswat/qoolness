<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_USER_PREFS,request); %>

<%@ include file="/global/topInclude.jsp" %>
<%@ include file="includes/prefsInclude.jsp" %>


<%



User user=controller.getSessionInfo().getUser();

String lastName=user.getLastName();
String firstName=user.getFirstName();
String emailAddress=user.getEmailAddress();
String emergencyContact=user.getEmergencyContact();
	
Address address=Address.getByUserId(user.getId());
address=(address==null?new Address():address);

String addressLine1=PageUtils.nonNull(address.getAddressLine1());
String addressLine2=PageUtils.nonNull(address.getAddressLine2());
String city=PageUtils.nonNull(address.getCity());
String stateProvinceCode=PageUtils.nonNull(address.getStateProvinceCode());
String postalCode=PageUtils.nonNull(address.getPostalCode());
String homeTelephone=PageUtils.nonNull(address.getHomeTelephone());
String workTelephone=PageUtils.nonNull(address.getWorkTelephone());
String mobileTelephone=PageUtils.nonNull(address.getMobileTelephone());

List states=AmericanState.getAll();
Collections.sort(states);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

function isValidForm(formObj)
{
	var els=formObj.elements

	if (trim(els["firstName"].value).length==0)
	{
		errorAlert("You have not supplied a first name; this field is required. Please fix and try again.",els["firstName"])
		return false
	}

	if (trim(els["lastName"].value).length==0)
	{
		errorAlert("You have not supplied a last name; this field is required. Please fix and try again.",els["lastName"])
		return false
	}

	if (els["emailAddress"].value.length==0)
	{
		errorAlert("You have not supplied an email address; this field is required. Please fix and try again.",els["emailAddress"])
		return false
	}

	if (trim(els["emergencyContact"].value).length==0)
	{
		errorAlert("You have not supplied emergency contact; this field is required. Please fix and try again.",els["emergencyContact"])
		return false
	}


	var password=els["password"].value
	var retypepassword=els["retypepassword"].value
	if (""+password!=""+retypepassword)
	{
		errorAlert("The password and the retyped password do not match.  Please fix and try again. (Note that you should leave these two fields blank unless you wish to change your password.)",els["retypepassword"])
		return false
	}
	



 	
 	// If we've gotten this far, then we know that all fields that should have something in
 	// them do; now make sure all field values are valid:
 	

	if (els["password"].value.length>0 && !isValidPassword(els["password"].value))
	{
		errorAlert("The password \""+els["password"].value+"\" is not valid; passwords may contain only letters, numbers, underscores, dashes, and periods, and must be between "+PASSWORD_MIN_LENGTH+" and "+PASSWORD_MAX_LENGTH+" characters long. Please fix and try again. (Note that you should leave these two fields blank unless you wish to change your password.)",els["password"])
		return false
	}

	if (!isValidEmail(els["emailAddress"].value))
	{
		errorAlert("The email address \""+els["emailAddress"].value+"\" is not valid; 'john@mymail.com'is an example of a valid email address.  Please fix and try again.",els["emailAddress"])
		return false
	}
	if (trim(els["addressLine1"].value).length==0)
	{
		errorAlert("You have not entered an address.  Please enter one and try again.",els["addressLine1"])
		return false
	}
	if (trim(els["city"].value).length==0)
	{
		errorAlert("You have not entered a city.  Please enter one and try again.",els["city"])
		return false
	}
	if (selectValue(els["stateProvinceCode"])==null || selectValue(els["stateProvinceCode"])=="")
	{
		errorAlert("You have not chosen a state.  Please choose one and try again.",els["stateProvinceCode"])
		return false
	}	
	if (trim(els["postalCode"].value).length==0)
	{
		errorAlert("You have not entered a ZIP code.  Please enter one and try again.",els["postalCode"])
		return false
	}
	if (trim(els["homeTelephone"].value).length==0 && trim(els["workTelephone"].value).length==0 && trim(els["mobileTelephone"].value).length==0)
	{
		errorAlert("You have not entered a home, work, or mobile telephone; at least one of these is required.  Please fix and try again.",els["homeTelephone"])
		return false
	}
	if (!isValidZIP(trim(els["postalCode"].value))) {
		errorAlert("The ZIP code you have entered is not valid.  Please enter your five-digit ZIP code and try again.",els["postalCode"])
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

<div id="mainDiv">
<span class="standardTextBlockWidth">
<form action="processPrefs.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">

<font class="bodyFont">
<span class="standardTextBlockWidth">
<span class="firstSentenceFont">Here's who you've told us you are.</span><br />
If you'd like, you can make changes below, and tell us who you <i>really</i> are. 
Then press the "change" button.<%=HtmlUtils.doubleLB(request)%>
To view, upload, or change your photos, go <a href="photos.jsp?<%=controller.getSiteIdNVPair()%>">here</a>.
To update your fitness profile, go <a href="pfd.jsp?<%=controller.getSiteIdNVPair()%>">here</a>.<%=HtmlUtils.doubleLB(request)%><br />
</span>



<span class="boldishFont">First Name</span><br />
<input style="width:250px;" type="text" class="inputText" name="firstName" id="firstName" value="<%=firstName%>" size="16"><%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Last Name</span><br />
<input style="width:250px;" type="text" class="inputText" name="lastName" id="lastName" value="<%=lastName%>" size="50"><%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Email Address</span><br />
<input style="width:250px;" type="text" class="inputText" name="emailAddress" id="emailAddress" value="<%=emailAddress%>" size="50"><%=HtmlUtils.doubleLB(request)%>


	
	<span class="boldishFont">Address Line 1</span><br />
	<input class="inputText" type="text"  style="width:250px;"  name="addressLine1" id="addressLine1" value="<%=addressLine1%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">Address Line 2</span><br />
	<input class="inputText" type="text"  style="width:250px;"  name="addressLine2" id="addressLine2" value="<%=addressLine2%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">City</span><br />
	<input class="inputText" type="text"  style="width:250px;"  name="city" id="city" value="<%=city%>"><%=HtmlUtils.doubleLB(request)%>
	
	<span class="boldishFont">State</span><br />
	<select class="selectText"  style="width:190px;"  name="stateProvinceCode" id="stateProvinceCode">
	<option value="">...</option>
	<%

	for (int i=0; i<states.size(); i++) {
		AmericanState state=(AmericanState)states.get(i);
		%><option <%=state.getUspsCode().equals(stateProvinceCode)?"selected":""%> value="<%=state.getUspsCode()%>"><%=state.getName()%></option>
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



<span class="boldishFont">Emergency Contact</span> (name, relationship, telephone)<br />
<input style="width:250px;" type="text" class="inputText" name="emergencyContact" id="emergencyContact" value="<%=emergencyContact%>" size="50"><%=HtmlUtils.doubleLB(request)%>
<%=HtmlUtils.doubleLB(request)%>
<span class="boldishFont">New Password</span> (leave blank unless you want to change your password)<br />
<input style="width:95px;" type="password" class="inputText" name="password" id="password" value="" size="16"><%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Retype New Password</span> (leave blank unless you want to change your password)<br />
<input style="width:95px;" type="password" class="inputText" name="retypepassword" id="retypepassword" value="" size="16"><%=HtmlUtils.doubleLB(request)%>
<%=HtmlUtils.doubleLB(request)%>




 
<br />
<%=HtmlUtils.formButton("change", request)%><br /><br />

<br />




</div>

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

</form></span>
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

