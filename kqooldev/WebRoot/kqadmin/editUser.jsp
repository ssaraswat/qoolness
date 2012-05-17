<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%
List states=AmericanState.getAll();
Collections.sort(states);

int userId=controller.getParamAsInt("id");
int addressId=controller.getParamAsInt("addressId");
User user=User.getById(userId);
Address address=Address.getByUserId(userId);
if (address==null) {
	address=new Address();
	address.setUserId(userId);
	address.setAddressLine1("");
	address.setAddressLine2("");
	address.setCity("");
	address.setCountryCode("");
	address.setStateProvinceCode("");
	address.setPostalCode("");
	address.setHomeTelephone("");
	address.setWorkTelephone("");
	address.setMobileTelephone("");
	address.store();
}
addressId=address.getId();



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">



function isValidForm(formObj)
{
	try {
		var els=formObj.elements
	
		if (els["firstName"].value.length==0) {
			errorAlert("You have not entered a first name; please fix and try again.",els["firstName"])
			return false
		}
		if (els["lastName"].value.length==0) {
			errorAlert("You have not entered a last name; please fix and try again.",els["lastName"])
			return false
		}
		if (els["emailAddress"].value.length==0) {
			errorAlert("You have not entered an email address; please fix and try again.",els["emailAddress"])
			return false
		}
		if (trim(els["addressLine1"].value).length==0) {
			errorAlert("You have not entered the first line of the user's address; please fix and try again.",els["addressLine1"])
			return false
		}
		if (trim(els["city"].value).length==0) {
			errorAlert("You have not entered a city; please fix and try again.",els["city"])
			return false
		}
		if (trim(els["postalCode"].value).length==0) {
			errorAlert("You have not entered a ZIP/postal code; please fix and try again.",els["postalCode"])
			return false
		}
		if (trim(els["emergencyContact"].value).length==0) {
			errorAlert("You have not entered an emergency contact; please fix and try again.",els["emergencyContact"])
			return false
		}
		return true
	}
	catch (e) {
		alert("JavaScript error validating form: "+e.message)
		return false;
	}
}



<% pageContext.include("js/js.jsp"); %>
</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>
<a name="top"></a>
<div id="mainDiv">

<form action="processEditUser.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">
<input type="hidden" name="id" value="<%=userId%>" />
<input type="hidden" name="addressId" value="<%=addressId%>" />
<input type="hidden" name="retUrl" value="<%=controller.getParam("retUrl","none")%>" />
<font class="bodyFont"> 
<span class="standardAdminTextBlockWidth">
<span class="firstSentenceFont">Edit <%=user.getFormattedNameAndUsername()%>'s details here.</span><br />
Make changes, then press "save" below.</span><br />

<span class="boldishFont">First Name</span><br/>
<input type="text" class="inputText" name="firstName" value="<%=PageUtils.nonNull(user.getFirstName())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Last Name</span><br/>
<input type="text" class="inputText" name="lastName" value="<%=PageUtils.nonNull(user.getLastName())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Email Address</span><br/>
<input type="text" class="inputText" name="emailAddress" value="<%=PageUtils.nonNull(user.getEmailAddress())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>
<br/>

<span class="boldishFont">Address Line 1</span><br/>
<input type="text" class="inputText" name="addressLine1" value="<%=PageUtils.nonNull(address.getAddressLine1())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Address Line 2</span><br/>
<input type="text" class="inputText" name="addressLine2" value="<%=PageUtils.nonNull(address.getAddressLine2())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">City</span><br/>
<input type="text" class="inputText" name="city" value="<%=PageUtils.nonNull(address.getCity())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">State</span><br/>
<select class="selectText"  style="width:230px;"  name="stateProvinceCode" id="stateProvinceCode">
<%
AmericanState state;
for (int i=0; i<states.size(); i++) {
	state=(AmericanState)states.get(i);
	%><option <%=state.getUspsCode().equals(address.getStateProvinceCode())?"selected":""%> value="<%=state.getUspsCode()%>"><%=state.getName()%></option>
	<%
}
%>
</select>
<%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">ZIP/Postal Code</span><br/>
<input type="text" class="inputText" name="postalCode" value="<%=PageUtils.nonNull(address.getPostalCode())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>
<br/>


<span class="boldishFont">Home Phone</span><br/>
<input type="text" class="inputText" name="homeTelephone" value="<%=PageUtils.nonNull(address.getHomeTelephone())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Work Phone</span><br/>
<input type="text" class="inputText" name="workTelephone" value="<%=PageUtils.nonNull(address.getWorkTelephone())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>

<span class="boldishFont">Mobile Phone</span><br/>
<input type="text" class="inputText" name="mobileTelephone" value="<%=PageUtils.nonNull(address.getMobileTelephone())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>
<br/>

<span class="boldishFont">Emergency Contract</span><br/>
<input type="text" class="inputText" name="emergencyContact" value="<%=PageUtils.nonNull(user.getEmergencyContact())%>" style="width:230px;" />
<%=HtmlUtils.doubleLB(request)%>
<br/>


<span class="boldishFont">Comments</span> (not visible to user)<br/>
<textarea class="inputText" name="commentsUserHidden" style="width:230px; height:140px;" rows="40" cols="40"><%=PageUtils.nonNull(user.getCommentsUserHidden())%></textarea>
<%=HtmlUtils.doubleLB(request)%>
<br/>

<span class="boldishFont">Gender</span><br/>
<input type="radio" name="gender" value="<%=User.MALE%>" id="gendermale" <%=user.getGender()==User.MALE?"checked":""%>><label for="gendermale">male</label>
<input type="radio" name="gender" value="<%=User.FEMALE%>" id="genderfemale" <%=user.getGender()==User.FEMALE?"checked":""%>><label for="genderfemale">female</label>
<%=HtmlUtils.doubleLB(request)%>
<br/>





<br/>
<%=HtmlUtils.cpFormButton(true, "save", null, request)%>

<%=HtmlUtils.doubleLB(request)%><br />
<a name="bottom"></a>

<br /></font>

</form>
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

