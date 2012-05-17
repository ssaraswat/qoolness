<%@ page import="java.util.*, com.theavocadopapers.apps.kqool.*, com.theavocadopapers.apps.kqool.pfd.*, com.theavocadopapers.apps.kqool.control.*,com.theavocadopapers.apps.kqool.entity.*, com.theavocadopapers.apps.kqool.util.*" %>
<%!
static final String[] MONTH_LABELS={"January","February","March","April","May","June","July","August","September","October","November","December",};
PfdProperties pfdProps=new PfdProperties();
java.text.DateFormat dateFormat=new java.text.SimpleDateFormat("MMMM d, yyyy");

%>

<%
try {
Controller controller=(Controller)request.getAttribute("controller");
User user=(User)request.getAttribute("user");
boolean userFound=(user!=null);
CurrentPfdData currentData=CurrentPfdData.getByUserId(user.getId(), user.getId());


String tagline=(String)request.getAttribute("tagline");
String introText=(String)request.getAttribute("introText");

boolean weightFieldsOnly=controller.getAttrAsBoolean("weightFieldsOnly", false);


// make this available to all includes:
request.setAttribute("currentData", currentData);
request.setAttribute("pfdProps", pfdProps);

%>
<div id="mainDiv">
<span>

	
 
	
	

	
	<font class="bodyFont">
	<%
	if (userFound) {
		%>
	
	<%
	if (tagline!=null) {
		// then introText is also not null, so:
		%>
		<span class="firstSentenceFont"><%=tagline%></span><br />
		<%=introText%><br /><br /><br />		
		<%
	}
	%>

<%

//Need to set selected's for first few menus on this pg
Date birthdate=user.getBirthDate();

%>
	<%
	if (!weightFieldsOnly) {
		%>
		<b><%=pfdProps.getQuestion("birthDate")%></b> <%=dateFormat.format(birthdate)%><br /><br />
	
		<b><%=pfdProps.getQuestion("height")%></b> <%=currentData.getHeightFeet()%>' <%=currentData.getHeightInches()%>"<br /><br />
			
		<%
	}
	%>
	<b><%=pfdProps.getQuestion("weight")%></b> <%=currentData.getWeight()%><br /><br />
	
	<b><%=pfdProps.getQuestion("targetWeight")%></b> <%=currentData.getTargetWeight()%><br /><br />

	<%
	if (!weightFieldsOnly) {
		request.setAttribute("viewSuffix", "_view");
		pageContext.include("pfdGuts.jsp");
	}
	%>




      
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
	</font>

  </span>

</div>
<%
}
catch (Exception e) {
	throw e;
}
%>
