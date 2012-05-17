<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>


<%@ include file="/global/topInclude.jsp" %>



<%

User user=controller.getSessionInfo().getUser();
int id=controller.getParamAsInt("id");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

function reloadPage(radioBtn) {
	var mode=radioBtn.value
	if (radioBtn.checked) {
		var newLoc=new String(location.href)
		var paramNameAndEquals="showMode="
		if (newLoc.indexOf(paramNameAndEquals)==-1) {
			if (newLoc.indexOf("?")==-1) {
				newLoc+="?"
			}
			else {
				newLoc+="&"
			}
			newLoc+=paramNameAndEquals+mode
		}
		else {
			newLoc+="&"
			newLoc=newLoc.substring(0, newLoc.indexOf(paramNameAndEquals))
				+paramNameAndEquals+mode
		}
		location.href=newLoc
	}
}

function deleteWorkout(id, label) {
	if (generalConfirm("Are you sure that you want to delete \""+label+"\"?")) {
		location.href="processDeleteWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id="+id
	}
}


</script>

<style type="text/css">
.evenDataRow {background-color:#ffffff;}
.oddDataRow {background-color:#ffffff;}
.actionFormButton {font-size:11px; font-family:arial,helvetica; width:40px; background-color:#ff6600; border:1px solid #000000; color:#ffffff; }
</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">

<font class="bodyFont"> 
<span class="standardTextBlockWidth">


			<span class="firstSentenceFont">What Is It You Desire?</span><br />
			Do you want to...<br /><br />
			Create a new routine based on the "<%=controller.getParam("name")%>" <%=controller.getParam("srcType")%>
			 and assign it to yourself?<br /><br />
			 Or, record a recent workout using 
			"<%=controller.getParam("name")%>" as a starting point?</span><%=HtmlUtils.doubleLB(request)%>





<br />



<%=HtmlUtils.formButton(false, "newRoutine", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=copy&id="+id+"&prescriptive=true'", request)%><br />
<img src="../images/spacer.gif" height="4" width="1" /><br />
<%=HtmlUtils.formButton(false, "recordAWorkout", "location.href='workout.jsp?"+controller.getSiteIdNVPair()+"&mode=copy&id="+id+"&prescriptive=false'", request)%><br />


<%=HtmlUtils.doubleLB(request)%><br />


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

