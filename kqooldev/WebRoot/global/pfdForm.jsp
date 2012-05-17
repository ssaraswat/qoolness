<%@ page import="java.util.*, com.theavocadopapers.apps.kqool.*, com.theavocadopapers.apps.kqool.pfd.*, com.theavocadopapers.apps.kqool.control.*,com.theavocadopapers.apps.kqool.entity.*, com.theavocadopapers.apps.kqool.util.*" %>
<%!
static final String[] MONTH_LABELS={"January","February","March","April","May","June","July","August","September","October","November","December",};
PfdProperties pfdProps=new PfdProperties();
%>

<%
try {
Controller controller=(Controller)request.getAttribute("controller");
User user=(User)request.getAttribute("user");
int userId=user.getId();
boolean userFound=(user!=null);
CurrentPfdData currentData=CurrentPfdData.getByUserId(user.getId(), user.getId());
String retUrl=(String)request.getAttribute("retUrl");
if (retUrl==null) {
	throw new RuntimeException("retUrl request attr not passed to this include; this is required.");
}

int settingUserId=controller.getAttrAsInt("settingUserId");
if (settingUserId==0) {
	throw new RuntimeException("settingUserId request attr not passed to this include; this is required.");
}


String tagline=(String)request.getAttribute("tagline");
String introText=(String)request.getAttribute("introText");
String medicalDisclaimer=(String)request.getAttribute("medicalDisclaimer");
boolean isAdminSection=controller.getAttrAsBoolean("isAdminSection");
boolean weightFieldsOnly=controller.getAttrAsBoolean("weightFieldsOnly", false);

String preSubmitButtonText=(String)request.getAttribute("preSubmitButtonText");
String historicalText=(String)request.getAttribute("historicalText");

// make this available to all includes:
request.setAttribute("currentData", currentData);
request.setAttribute("pfdProps", pfdProps);


%>
<%@ include file="/global/validationJs.jsp" %>
<script>
function isValidForm(formObj) {
	var els=formObj.elements
	if (els["weight"].value.length==0) {
		errorAlert("You have not entered your weight.  Please fix and try again.",els["weight"])
		return false
	}
	if (!isInteger(els["weight"].value)) {
		errorAlert("Your weight must be a whole number.  Please fix and try again.",els["weight"])
		return false
	}
	if (els["targetWeight"].value.length==0) {
		errorAlert("You have not entered your target weight.  Please fix and try again.",els["targetWeight"])
		return false
	}
	if (!isInteger(els["targetWeight"].value)) {
		errorAlert("Your target weight must be a whole number.  Please fix and try again.",els["targetWeight"])
		return false
	}
	return true
}
</script>
<div id="mainDiv">
<span>

	
 
	
	
	<form action="<%=controller.getPathToAppRoot()%>global/processPersonalFitnessData.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm"> 
	<input type="hidden" name="userId" value="<%=userId%>" />
	<input type="hidden" name="settingUserId" value="<%=settingUserId%>" />
	<input type="hidden" name="retUrl" value="<%=retUrl%>" %>
	<input type="hidden" name="noExistingData" value="<%=currentData.isNoExistingData()%>" %>
	<input type="hidden" name="showSuccessAlert" value="<%=isAdminSection%>" %>
	<input type="hidden" name="weightFieldsOnly" value="<%=weightFieldsOnly%>" %>
	
	
	
	
	
	<font class="bodyFont">
	<%
	if (userFound) {
		%>

<%
if (tagline!=null) {
	%>
	<span class="firstSentenceFont"><%=tagline%></span><br />
	<%=introText%><%
	if (historicalText!=null) {
		%>
		<%=historicalText%>
		<%
	}	
	%><br /><br />	
	<%
}



if (medicalDisclaimer!=null) {
	%>
	<i><%=medicalDisclaimer%></i><br /><br />	
	<%
}
%>



<%

// Deal with birthdate; this is the only PFD field which comes from the User object, not
// from a PfdItem instance:
Date birthdate=user.getBirthDate();
if (birthdate==null) {
	birthdate=new Date();
	birthdate.setTime(0);
}
Calendar birthCal=new GregorianCalendar();
birthCal.setTime(birthdate);
%>
	<%
	if (!weightFieldsOnly) {
		%>
		<b><%=pfdProps.getQuestion("birthDate")%></b><br />
		<select class="selectText" name="birthMonth">
		<%
		for (int i=0; i<12; i++) {
			%>
			<option value="<%=i%>" <%=birthCal.get(Calendar.MONTH)==i?"selected=\"selected\"":""%> ><%=MONTH_LABELS[i]%></option>
			<%
		}
		%>
		</select>
		<select class="selectText" name="birthDateOfMonth">
		<%
		for (int i=1; i<=31; i++) {
			%>
			<option value="<%=i%>"  <%=birthCal.get(Calendar.DATE)==i?"selected=\"selected\"":""%> ><%=i%></option> 
			<%
		}
		%>
		</select>
		<select class="selectText" name="birthYear">
		<%
		Calendar now=new GregorianCalendar();
		int startYear=now.get(Calendar.YEAR);
		int endYear=now.get(Calendar.YEAR)-100;
		for (int i=startYear; i>endYear; i--) {
			%>
			<option value="<%=i%>"  <%=birthCal.get(Calendar.YEAR)==i?"selected=\"selected\"":""%> ><%=i%></option>
			<%
		}
		%>
		</select>
		
		<br /><br />
	
		<b><%=pfdProps.getQuestion("height")%></b><br />
			<select class="selectText" name="heightFeet">
		<%
		for (int i=3; i<=9; i++) {
			%>
			<option value="<%=i%>"  <%=currentData.getHeightFeet()==i?"selected=\"selected\"":""%> ><%=i%> feet</option> 
			<%
		}
		%>
		</select>
				<select class="selectText" name="heightInches">
		<%
		for (int i=0; i<=11; i++) {
			%>
			<option value="<%=i%>"  <%=currentData.getHeightInches()==i?"selected=\"selected\"":""%> ><%=i%> inches</option> 
			<%
		}
		%>
		</select>
		
		<br /><br />
		
		<%
	}
	%>

	<b><%=pfdProps.getQuestion("weight")%></b><br />
	<input type="text" name="weight" value="<%=currentData.getWeight()==0?"":""+currentData.getWeight()%>" class="inputText" style="width:25px;" /><br /><br />

	<b><%=pfdProps.getQuestion("targetWeight")%></b><br />
	<%
	if (currentData.getTargetWeight()==0) {
		%><i>Note: you should discuss your target weight with your trainer (but this
		<a href="#" onclick="launchTargetWeightCalculator(); return false;">target-weight calculator</a> will get you started)</i><br/><%
	}
	%>
	 
	<input type="text" name="targetWeight" value="<%=currentData.getTargetWeight()==0?"":""+currentData.getTargetWeight()%>" class="inputText" style="width:25px;" />


	<%
	if (!weightFieldsOnly) {
		%><br/><br/><%
	}
	request.setAttribute("viewSuffix", "");
	if (!weightFieldsOnly) {
		pageContext.include("pfdGuts.jsp");
		%>
		<br/><br/><br/>
		<%
	}

	if (isAdminSection) {
		%>
		
		<%=HtmlUtils.cpFormButton(true,"submit",null,request)%>		
		<%
	}
	else {
		%>
		<%=preSubmitButtonText%><br /><br /><br />
		
		<%=HtmlUtils.formButton(true,"submit",null,request)%>		
		<%
	}
	%>

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
<%
}
catch (Exception e) {
	throw e;
}
%>
