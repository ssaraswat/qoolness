<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.WorkoutComparator" %>

<% PageUtils.jspStart(request); %>



<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%! 

%>

<%

%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>

<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>

<script type="text/javascript">

function init() {

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
<span class="firstSentenceFont">Your nutritionist says...</span><br />
<!--
...Actually your nutritionist doesn't say anything yet, but coming soon to
kqool.com: nutritionist services.  Stay tuned!<br/>
<br />
-->

<% 
	User user=controller.getSessionInfo().getUser(); 
%>

<% if (!user.isNutritionist()) { %>
You have not hired a nutritionist to help you figure your meal plan out. <br/>
For $10 a month you can add this option to your account. <br/>

<a href="processAddNutritionist.jsp">
<img src="../images/btn_newnut.jpg" width="95" height="24" alt="Add Nutritionist" border="0"/>
</a>
<% } else { 
	NutritionPlan np = NutritionPlan.getByUserId(user.getId());
	if (np == null) np = new NutritionPlan();
%>	

        <table border="0" width="100%" cellpadding="0" cellspacing="0" class="days">
                <tr>
        		<td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#DFD0FF">Sunday</td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#FFFFCC">Monday</td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#B2E5E5">Tuesday</td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#DEFFBE">Wednesday</td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#FFD2A5">Thursday</td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#D1A3BA">Friday</td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#B8E3FF">Saturday</td>
                        <td width="1%">&nbsp;</td>
                </tr>
                <tr>
        		<td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#DFD0FF"><%=np.getSundayRec()%></td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#FFFFCC"><%=np.getMondayRec()%></td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#B2E5E5"><%=np.getTuesdayRec()%></td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#DEFFBE"><%=np.getWednesdayRec()%></td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#FFD2A5"><%=np.getThursdayRec()%></td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#D1A3BA"><%=np.getFridayRec()%></td>
                        <td width="1%">&nbsp;</td>
                        <td width="15%" align="center" bgcolor="#B8E3FF"><%=np.getSaturdayRec()%></td>
                        <td width="1%">&nbsp;</td>
                </tr>
        </table>
	<br/>
	Instructions: <%=np.getInstructions()%>


<%
   }
%>

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

