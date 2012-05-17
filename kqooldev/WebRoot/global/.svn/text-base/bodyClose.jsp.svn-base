<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><%
if (!isAdmin) {
	%>
	</td>
	
	<%
	if (layoutType==LAYOUT_GENERIC) {
		%>
		<td valign="top" align="right">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><%=userStatusText%><br/></td>
		<td nowrap="nowrap" width="20"><br/></td>
		</tr>
		</table>
		</td>
		<td align="right" nowrap="nowrap" width="202" style="width:202px; "><a href="<%=PageUtils.getPathToAppRoot(request)%>index.jsp?<%=controller.getSiteIdNVPair()%>" hidefocus="true"><img galleryimg="false" src="<%=PageUtils.getPathToAppRoot(request)%>images/mainBodyBottom.jpg" height="132" width="162" border="0"></a><br/>
		<img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" width="2" height="37" border="0" /><br/>
		<img src="<%=PageUtils.getPathToAppRoot(request)%>images/rightWord_strength.gif" width="202" height="42" border="0" /><br/>
		</td>
		<%
	}
	else if (layoutType==LAYOUT_WORKOUTS_HOME || layoutType==LAYOUT_WORKOUTS_INTERIOR) {
		%>
		<td align="right" colspan="2" valign="bottom" nowrap="nowrap" width="202" style="width:202px; ">
		
		<table border="0" cellspacing="0" cellpadding="0" width="519">
		<tr valign="top">
		<td nowrap="nowrap" width="40" align="right"><%=userStatusText%><br/></td>
		<td nowrap="nowrap" width="479"><br/><br/><nobr><img style="margin-left:20px;" src="<%=PageUtils.getPathToAppRoot(request)%>images/photo_workouts_home.jpg" galleryimg="false" width="206" height="339" border="0"  /><img src="<%=PageUtils.getPathToAppRoot(request)%>images/rightWord_focus.gif" width="273" height="280" border="0" /></nobr><br/>
		</td>
		</tr>
		</table>
		
		</td>
		<%
	}
	else if (layoutType==LAYOUT_VIDEOS_HOME) {
		%>
		<td align="right" colspan="2" valign="bottom" nowrap="nowrap" width="202" style="width:202px; ">
		
		<table border="0" cellspacing="0" cellpadding="0" width="351">
		<tr valign="top">
		<td nowrap="nowrap" width="40" align="right"><%=userStatusText%><br/></td>
		<td nowrap="nowrap" width="337"><img style="margin-top:30px; margin-left:20px;" src="<%=PageUtils.getPathToAppRoot(request)%>images/photo_video_home.gif"  galleryimg="false" width="337" height="325" border="0" /><br/></td>
		</tr>
		</table>
		
		
		
		
		</td>
		<%
	}
	else if (layoutType==LAYOUT_VIDEOS_INTERIOR) {
		%>
		<td align="right" colspan="2" valign="bottom" nowrap="nowrap" width="202" style="width:202px; ">
		
		
		<table border="0" cellspacing="0" cellpadding="0" width="339">
		<tr valign="top">
		<td nowrap="nowrap" width="40" align="right"><%=userStatusText%><br/></td>
		<td nowrap="nowrap" width="299"><img src="<%=PageUtils.getPathToAppRoot(request)%>images/photo_video_interior.gif"  galleryimg="false" width="299" height="453" border="0"  /><br/>
		</td>
		</tr>
		</table>
		
		
		</td>
		<%
	}
	else if (layoutType==LAYOUT_LOGIN) {
		%>
		<td align="right" colspan="2" valign="bottom" nowrap="nowrap" width="202" style="width:202px; "><img src="<%=PageUtils.getPathToAppRoot(request)%>images/photo_login.jpg" galleryimg="false" width="382" height="366" border="0" /><br/>
		</td>
		<%
	}
	%>
	
	
	</tr>
	

	
	<tr valign="top">
	<td colspan="2" bgcolor="#999999" nowrap="nowrap" height="146" style="height:146px; "><%@ include file="bottomNav.jsp" %></td>
	<td bgcolor="#999999" nowrap="nowrap" height="146" style="height:146px; "><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" width="1" height="1" border="0" /><br/></td>
	<td bgcolor="#999999" nowrap="nowrap" height="146" style="height:146px; "><img src="<%=PageUtils.getPathToAppRoot(request)%>images/spacer.gif" width="1" height="1" border="0" /><br/></td>
	</tr>
	
	
	</table>
	
	</div>
	<%
}

else { // is an admin page:
	%>

	
	</div>
	<%
}
%>
<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<script type="text/javascript">
// do this for people who are back-buttoning to this page:
showPageAndHidePleaseWait();
</script>

<%@ include file="/global/trackingCode.jsp" %>
</body>

