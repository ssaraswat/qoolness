<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.control.*" %>

<%




String rootPath=PageUtils.getPathToAppRoot(request);



String sectionName=PageUtils.nonNull(PageUtils.getSection(request)).trim().toLowerCase();
String subsectionName=PageUtils.nonNull(PageUtils.getSubsection(request)).trim().toLowerCase();



%>


<body onload="init()" bgcolor="ffffff" text="#000000" link="#99cc00" vlink="#99cc00" alink="#99cc00" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">


<div id="genericPleaseWaitDiv" style="width:577px; z-index:200;">
<img src="<%=PageUtils.getPathToAppRoot(request)%>images/pleaseWait<%=isAdmin?"Admin":""%>.gif" width="577" height="267" /></br>
</div>




<%


if (showHeaderElements)
{
	if (!isPopup)
	{
		%>
		
		<%
		if (!isAdmin) {
			%>

			<%@ include file="topNav.jsp" %>
			
			<div style="z-index:10; position:absolute; top:0px; left:0px; width:100%; height:100%">
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
			<%
			if (layoutType==LAYOUT_GENERIC) {
				%>
				<tr valign="top">
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif" nowrap="nowrap" colspan="2" height="237" width="488" style="height:237px; width:488px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeader.gif" height="237" width="488" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" border="0"></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif" align="right" nowrap="nowrap" height="237" width="202" style="height:237px; width:202px; "><a href="<%=PageUtils.getPathToAppRoot(request)%>index.jsp?<%=controller.getSiteIdNVPair()%>" hidefocus="true"><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/mainBodyTop.jpg" height="237" width="162" border="0"></a><br/></td>
				</tr>				
				<%
			}			
			else if (layoutType==LAYOUT_WORKOUTS_HOME || layoutType==LAYOUT_WORKOUTS_INTERIOR) {
				%>
				<tr valign="top">
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif" nowrap="nowrap" colspan="2" height="237" width="488" style="height:237px; width:488px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeader.gif" height="237" width="488" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"   nowrap="nowrap"  height="237" width="202"  style="height:237px; width:202px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="1" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"  nowrap="nowrap"  height="237" width="202"  style="height:237px; width:202px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif"  height="237" width="202"  border="0"><br/></td>
				</tr>				
				<%
			}
			else if (layoutType==LAYOUT_VIDEOS_HOME) {
				%>
				<tr valign="top">
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif" nowrap="nowrap" colspan="2" height="237" width="488" style="height:237px; width:488px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeader.gif" height="237" width="488" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"   nowrap="nowrap"  height="237" width="202"  style="height:237px; width:202px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="1" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"  nowrap="nowrap" height="237" width="150" style="height:237px; width:150px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="237" width="1" border="0" /><br/></td>
				</tr>				
				<%
			}
			else if (layoutType==LAYOUT_VIDEOS_INTERIOR) {
				%>
				<tr valign="top">
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif" nowrap="nowrap" colspan="2" height="237" width="488" style="height:237px; width:488px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeader.gif" height="237" width="488" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"   nowrap="nowrap"  height="237" width="202"  style="height:237px; width:202px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="1" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"  nowrap="nowrap" height="237" width="120" style="height:237px; width:120px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="237" width="1" border="0" /><br/></td>
				</tr>				
				<%
			}
			else if (layoutType==LAYOUT_LOGIN) {
				%>
				<tr valign="top">
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif" nowrap="nowrap" colspan="2" height="237" width="488" style="height:237px; width:488px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeader.gif" height="237" width="488" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"   nowrap="nowrap"  height="237" width="202"  style="height:237px; width:202px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="1" border="0" /><br/></td>
				<td background="<%=PageUtils.getPathToAppRoot(request)%>images/mainHeaderRule.gif"  nowrap="nowrap" height="237" width="120" style="height:237px; width:120px; "><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="237" width="1" border="0" /><br/></td>
				</tr>				
				<%
			}
			%>
			
			<tr valign="top">
			<td background="<%=PageUtils.getPathToAppRoot(request)%>images/leftGrayBg.gif" nowrap="nowrap" width="230" style="width:230px; ">
				<%
				if ((sectionName.equals("workouts") || sectionName.equals("userprefs")) && (request.getParameter("viewUserId")==null || request.getParameter("viewUserId").equals("0"))) {
					// it would be nice to clean this left-nav section up sometime.
					String[][] navNamesOrImgNames_workouts={
						{"exercise",
							"trainer-created routines",
							"self-created routines",
							"create a routine",
							"save a workout",
							"saved workouts",
						},	
						{"food",
							"what'd you eat?",
							"your nutritionist says...",
						},
						{"calories",
							"calories in/out",
						},
						{"weight",
							"current",
							"past",
						},
					};
					String[][] navUrls_workouts={
						{null,
							"workoutList.jsp?"+controller.getSiteIdNVPair()+"&selfAssign=false&prescriptive=true",
							"workoutList.jsp?"+controller.getSiteIdNVPair()+"&selfAssign=true&prescriptive=true",
							"workout.jsp?"+controller.getSiteIdNVPair()+"&mode=add&prescriptive=true",
							"workout.jsp?"+controller.getSiteIdNVPair()+"&mode=add&prescriptive=false",
							"workoutList.jsp?"+controller.getSiteIdNVPair()+"&selfAssign=true&prescriptive=false",
						},
						{null,
							"caloriesIngested.jsp?"+controller.getSiteIdNVPair(),
							"nutritionist.jsp?"+controller.getSiteIdNVPair(),

						},
						{null,
							"calorieSpreadsheet.jsp?"+controller.getSiteIdNVPair(),
						},
						{null,
							"pfd_weightFields.jsp?"+controller.getSiteIdNVPair(),
							"pfdHistorical_weightFields.jsp?"+controller.getSiteIdNVPair(),
							
						},
					};
					String[][] navNamesOrImgNames_userprefs={
						{"the basics","your info","photos",},
						{"fitness profile","current profile","past data",},
					};
					String[][] navUrls_userprefs={
						{null,"prefs.jsp?"+controller.getSiteIdNVPair(),"photos.jsp?"+controller.getSiteIdNVPair(),},
						{null,"pfd.jsp?"+controller.getSiteIdNVPair(),"pfdHistorical.jsp?"+controller.getSiteIdNVPair(),},
					};
					%>
					<table border="0" cellspacing="0" cellpadding="0" width="148">
					
					<%
					String[][] navUrls=null;
					String[][] navNamesOrImgNames=null;
					if (sectionName.equals("workouts")) {
						navUrls=navUrls_workouts;
						navNamesOrImgNames=navNamesOrImgNames_workouts;
					}
					else if (sectionName.equals("userprefs")) {
						navUrls=navUrls_userprefs;
						navNamesOrImgNames=navNamesOrImgNames_userprefs;
					}
					for (int i=0; i<navUrls.length; i++) {
						String[] thisSectionUrls=navUrls[i];
						String[] thisSectionNames=navNamesOrImgNames[i];
						%>
						<tr>
						<td>&nbsp;<br/></td>
						<td colspan="2" style="font-weight:bold; font-size:14px; font-family:arial,helvetica; color:#666666;"><%=navNamesOrImgNames[i][0]%><br/>
						<img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="2" /><br/>
						</td>
						</tr>
						<%
						if (thisSectionUrls.length>1) {
							%>
							<tr>
							<td colspan="2">&nbsp;<br/></td>
							<td class="leftNavFont">
							<%
							for (int j=1; j<thisSectionUrls.length; j++) {
								%><a href="<%=thisSectionUrls[j]%>" onmouseover="this.style.textDecoration='underline'" onmouseout="this.style.textDecoration='none'" class="leftNavFont"><%=thisSectionNames[j]%></a><br/><%
							}
							%>
							<img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="18" width="2" /><br/>
							</td>
							</tr>								
							<%
						}
					}
					%>
	
					<tr>
					<td nowrap="nowrap" width="15"><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" width="1" height="1" border="0" /><br/></td>
					<td nowrap="nowrap" width="5"><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" width="1" height="1" border="0" /><br/><br/></td>
					<td nowrap="nowrap" width="128"><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" width="1" height="1" border="0" /><br/><br/></td>
					<td> 
					</tr>
					</table>					
					<%
				}
				%>

				
			&nbsp;</td>
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/headers/<%=PageUtils.getSection(request)%>.gif" height="30" width="200" /><br/>
			<img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="34" width="2" /><br/>
			<a name="contentTop"></a><%
		}
		
		else { // is admin page:
			%>
			<div style="z-index:10; position:absolute; top:0px; left:0px; width:580px; height:50px;">
			<a hidefocus="true" href="menu.jsp?<%=controller.getSiteIdNVPair()%>"><img src="../images/spacer.gif" height="50" width="580" border="0" /></a>
			</div>
			<div style="xborder:1px solid #000000; z-index:10; position:absolute; top:56px; left:11px; width:650px; ">
			
			<script>
			function getAdminUrl(selObj, selectedIndex) {
				var selectedValue=selObj.options[selectedIndex].value
				if (selectedValue.length>0) {
					location.href=selectedValue
				}
			}
			</script>
			
			<table border="0" cellspacing="0" cellpadding="0">
			<tr align="center">
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/adminNavGrayPx.gif" height="3" width="2"><br /></td>
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="2"><br /></td>
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/adminNavGrayPx.gif" height="3" width="2"><br /></td>
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="2"><br /></td>
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/adminNavGrayPx.gif" height="3" width="2"><br /></td>
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="2"><br /></td>
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/adminNavGrayPx.gif" height="3" width="2"><br /></td>
			<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" height="2" width="2"><br /></td>
			</tr>
			<tr>
			<td><div style="background-color:#ffffff; text-align:center; border:2px solid #eaeaea; padding:2px; width:160px; "><select onchange="getAdminUrl(this, this.selectedIndex)" name="users" style="background-color:#<%=PageUtils.getSubsection(request).equals(AppConstants.SUB_SECTION_USERS)?"ff6600":"99cc00"%>; color:#ffffff; font-size:11px; font-family:arial,helvetica; width:150px;" >
			<option value="">users...</option>
			<option value="addUsers.jsp?<%=controller.getSiteIdNVPair()%>">add clients</option>
			<option value="users.jsp?<%=controller.getSiteIdNVPair()%>">view/edit clients</option>
			<%
			if (currentUser!=null && currentUser.getBackendUserType()!=User.BACKENDUSER_TYPE_TRAINER) {
				// for superadmins and site admins only:
				%>
				<option value="addBackendUsers.jsp?<%=controller.getSiteIdNVPair()%>">add backend users</option>
				<option value="backendUsers.jsp?<%=controller.getSiteIdNVPair()%>">view/edit backend users</option>
				<%
			}
			%>
			<option value="pfpRequest.jsp?<%=controller.getSiteIdNVPair()%>">request pers. fit. profile</option>
			</select><br/></div></td>
			<td>&nbsp;<br/></td>
			<td><div style="background-color:#ffffff; text-align:center; border:2px solid #eaeaea; padding:2px; width:160px; "><select onchange="getAdminUrl(this, this.selectedIndex)" name="users" style="background-color:#<%=PageUtils.getSubsection(request).equals(AppConstants.SUB_SECTION_EXERCISES)?"ff6600":"99cc00"%>; color:#ffffff; font-size:11px; font-family:arial,helvetica; width:150px;" >
			<option value="">exercises...</option>
			<option value="addExercises.jsp?<%=controller.getSiteIdNVPair()%>">add</option>
			<option value="exercises.jsp?<%=controller.getSiteIdNVPair()%>">view/edit</option>
			</select><br/></div></td>
			<td>&nbsp;<br/></td>
			<td><div style="background-color:#ffffff; text-align:center; border:2px solid #eaeaea; padding:2px; width:160px; "><select onchange="getAdminUrl(this, this.selectedIndex)" name="users" style="background-color:#<%=PageUtils.getSubsection(request).equals(AppConstants.SUB_SECTION_WORKOUTS)?"ff6600":"99cc00"%>; color:#ffffff; font-size:11px; font-family:arial,helvetica; width:150px;" >
			<option value="">routines...</option>
			<option value="workout.jsp?<%=controller.getSiteIdNVPair()%>&mode=add">assign new</option>
			<option value="workoutList.jsp?<%=controller.getSiteIdNVPair()%>&mode=view&showMode=all">view/edit</option>

			</select><br/></div></td>
			<td>&nbsp;<br/></td>
			<td><div style="background-color:#ffffff; text-align:center; border:2px solid #eaeaea; padding:2px; width:160px; "><select onchange="getAdminUrl(this, this.selectedIndex)" name="users" style="background-color:#<%=PageUtils.getSubsection(request).equals(AppConstants.SUB_SECTION_OTHER)?"ff6600":"99cc00"%>; color:#ffffff; font-size:11px; font-family:arial,helvetica; width:150px;" >
			<option value="">other...</option>
			<%
			if (currentUser!=null && currentUser.getUserType()==User.USER_TYPE_BACKENDUSER && currentUser.getBackendUserType()==User.BACKENDUSER_TYPE_SUPER_ADMIN) {
				%>
				<option value="site.jsp?mode=add&<%=controller.getSiteIdNVPair()%>">add site</option>
				<option value="sites.jsp?<%=controller.getSiteIdNVPair()%>">manage sites</option>
				<%
			}
			%>
			<option value="addCalorieExpendingActivities.jsp?<%=controller.getSiteIdNVPair()%>">add calorie-exp. activities</option>
			<option value="calorieExpendingActivities.jsp?<%=controller.getSiteIdNVPair()%>">view/edit calorie-exp. act.</option>
			<option value="viewCalorieSpreadsheets.jsp?<%=controller.getSiteIdNVPair()%>">view cal. spreadsheets</option>
			<option value="menu.jsp?<%=controller.getSiteIdNVPair()%>">go to admin home</option>
			<option value="../index.jsp?<%=controller.getSiteIdNVPair()%>">go to kqool.com home</option>
			<option value="logout.jsp?<%=controller.getSiteIdNVPair()%>">log out</option>
			</select><br/></div></td>
			<td>&nbsp;<br/></td>
			</tr>
			<%
			boolean logoutPg=request.getAttribute("logoutPage")!=null && request.getAttribute("logoutPage").equals(new Boolean(true));
			if (!logoutPg && currentUser!=null) {
				%>
				<tr>
				<td colspan="5"><div id="adminYouAreLoggedIn" style="margin:5px 0px 0px 7px; font-size:12px; font-family:arial,helvetica;"><i>You are logged in as user <b><%=currentUser.getUsername()%></b>.  You are a <b><%=currentUser.getDefaultBackendUserTypeLabel().toLowerCase()%></b>. <a href="logout.jsp?<%=controller.getSiteIdNVPair()%>">Log out</a>.</i></div></td>
				</tr>
				<%
			}
			%>
			</table>
			
			
			

			</div>
			<div style="z-index:10; position:absolute; top:112px; left:20px; width:705px; ">
			<table border="0" cellspacing="0" cellpadding="0" align="right">
			<tr>
			<td align="center"><br/><%=userStatusText%><br/></td>
			<td nowrap="nowrap" width="20" align="right"><br/></td>
			</tr>
			</table>
			<%
		}
	}
	else
	{
		// page is popup:
		%> 
		<div id="popupHeaderDiv">

		<table border="0" cellspacing="0" cellpadding="0" width="300">


		<tr nowrap="nowrap" height="23"  valign="bottom">
		<td><%=HtmlUtils.spacer(2,2,request)%><br /></td>
		<td><img src="<%=PageUtils.getPathToAppRoot(request)%>images/header_<%=currentSectionName%>_popup.gif" height="18" width="165"><br /></td>
		</tr>


		</table>

		</div>
		
		<%
	}
}

if (isAdmin) {
	%><br/><%
}
%>

 