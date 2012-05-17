<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
<%@ page import="com.theavocadopapers.apps.kqool.pfd.*" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>
<%@ include file="../userprefs/includes/prefsInclude.jsp" %>
<%!
static DateFormat dateFormat=new SimpleDateFormat("MM/dd/yyyy");
%>

<%

Map allUsersMap=User.getAllAsMap();

User user=controller.getSessionInfo().getUser();

List historicalPfdItems=com.theavocadopapers.apps.kqool.entity.PfdItem.getHistoricalByUserId(user.getId());
boolean hasHistoricalItems=(historicalPfdItems!=null && historicalPfdItems.size()>0);

PfdProperties pfdProps=new PfdProperties();
if (hasHistoricalItems) {
	Collections.sort(historicalPfdItems);
	Collections.reverse(historicalPfdItems);
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

</script> 

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardTextBlockWidth">

<font class="bodyFont">
<span class="standardTextBlockWidth">
<span class="firstSentenceFont">Here's what you <i>used</i> to weigh.</span><br />
Before you met us.
Your current weight data is <a href="pfd_weightFields.jsp?<%=controller.getSiteIdNVPair()%>">here</a>.<%=HtmlUtils.doubleLB(request)%><br />
</span>

</div>
 
<div style="width:550px;">
<br/>
<%
if (historicalPfdItems!=null) {
	Iterator histItemsIt=historicalPfdItems.iterator();
	PfdItem pfdItem;
	User changingUser;
	boolean isClient;
	String question;
	String value;
	String subsequentValue;
	Map optionsItemValueLabelMap;
	while (histItemsIt.hasNext()) {
		pfdItem=(PfdItem)histItemsIt.next();
		if (!pfdItem.getCode().equals(PfdConstants.CODE_WEIGHT) && !pfdItem.getCode().equals(PfdConstants.CODE_TARGET_WEIGHT)) {
			continue;
		}
		changingUser=(User)allUsersMap.get(new Integer(pfdItem.getSettingUserId()));
		isClient=changingUser.getId()==user.getId();
		// handle height as a special case; it's the only field that has two values:
		if (pfdItem.getCode().equals("heightFeet")) {
			question="What is your height? (feet)";
		}
		else if (pfdItem.getCode().equals("heightInches")) {
			question="What is your height? (inches)";
		}
		else {
			question=pfdProps.getQuestion(pfdItem.getCode());
		}
		while (question.endsWith(".")) {
			question=question.substring(0, question.length()-1);
		}
		value=pfdItem.getValue();
		subsequentValue=pfdItem.getSubsequentValue();
		if (value!=null) {
			if (value.equals("true")) {
				value="Yes";
			}
			else if (value.equals("false")) {
				value="No";
			}
			else {
				optionsItemValueLabelMap=pfdProps.getOptionsItemValueLabelMap(pfdItem.getCode());
				if (optionsItemValueLabelMap!=null) {
					String temp=(String)optionsItemValueLabelMap.get(value);
					if (temp!=null) {
						value=temp;
					}
				}
			}
		}
		if (subsequentValue!=null) {
			if (subsequentValue.equals("true")) {
				subsequentValue="Yes";
			}
			else if (subsequentValue.equals("false")) { 
				subsequentValue="No";
			}
			else {
				optionsItemValueLabelMap=pfdProps.getOptionsItemValueLabelMap(pfdItem.getCode());
				if (optionsItemValueLabelMap!=null) {
					String temp=(String)optionsItemValueLabelMap.get(subsequentValue);
					if (temp!=null) {
						subsequentValue=temp;
					}
				}
			}
		}


		%>
		<div style="margin-bottom:10px;">
		<i><%=dateFormat.format(pfdItem.getCreateDate())%>:</i> <%=changingUser.getFormattedNameAndUsername()%> 
		set <b><%=question%></b> to 
		<b><%=subsequentValue%></b> (previous value: <b><%=value%></b>).
		</div>
		<%
	}
	%>
	<br/>
 	<%
}
else {
	%><i>(No historical data found.)</i><%
}
%>









<%=HtmlUtils.doubleLB(request)%><br />

</div>
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

