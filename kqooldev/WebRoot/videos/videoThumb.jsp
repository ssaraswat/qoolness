<%@ page import="com.theavocadopapers.apps.kqool.control.Controller" %>

<%
Controller controller=new Controller();
controller.doGlobalControl(pageContext);

String name=controller.getParam("name");
int type=controller.getParamAsInt("type");
int id=controller.getParamAsInt("id");
boolean portraitOrientation=controller.getParamAsBoolean("portraitOrientation");

String description=controller.getParam("description");
String filename=controller.getParam("filename");
String altIconImage=controller.getParam("altIconImage","");
String category=controller.getParam("category");

String iconImage=category.toLowerCase();
if (altIconImage.length()>0) {
	iconImage=altIconImage;
}

String thumbFilename=filename.substring(0,filename.lastIndexOf("."))+".jpg";


%><script>


</script><%
if (portraitOrientation) {
	int grayBarHeight=90;
	if (description.trim().length()==0) {
		grayBarHeight=47;
	}
	%><table border="0" cellspacing="0" cellpadding="0" width="111">
	<tr>
	<td colspan="4"><a href="#" onclick="getVideo(<%=id%>, '<%=filename%>'); return false;"><img src="../images/videograbs/<%=thumbFilename%>" width="111" height="83" border="0" /></a><br/>
	<img src="../images/spacer.gif" width="1" height="2" border="0" /><br/></td>
	</tr>
	
	<tr valign="top">
	<td rowspan="2"><img src="../images/videoGrayVertBar.gif" height="<%=grayBarHeight%>" width="1" /><br/></td>
	<td><img src="../images/musclegroupicons/<%=iconImage%>.gif" height="46" width="25" /><br/></td>
	<td class="videoTitle"><img src="../images/spacer.gif" width="1" height="6" border="0" /><br/>
	<%=name%><br/></td>
	<td rowspan="2"><img src="../images/spacer.gif" width="1" height="2" border="0" /><br/></td>
	</tr>
	
	<tr valign="top">
	<td colspan="2">
	<table border="0" cellspacing="0" cellpadding="0" width="107">
	<tr valign="top">
	<td><img src="../images/spacer.gif" width="1" height="1" border="0" /><br/></td>
	<td class="videoDescription"><%=description%><br/></td>
	</tr>
	<tr>
	<td nowrap="nowrap" width="4"><img src="../images/spacer.gif" width="1" height="2" border="0" /><br/></td>
	<td nowrap="nowrap" width="103"><img src="../images/spacer.gif" width="1" height="2" border="0" /><br/></td>
	</tr>
	</table>
	<br/></td>
	</tr>
	
	<tr>
	<td nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1" /><br/></td>
	<td nowrap="nowrap" width="25"><img src="../images/spacer.gif" height="1" width="1" /><br/></td>
	<td nowrap="nowrap" width="82"><img src="../images/spacer.gif" height="1" width="1" /><br/></td>
	<td nowrap="nowrap" width="3"><img src="../images/spacer.gif" height="1" width="1" /><br/></td>
	</tr>
	</table><%
	}
	else {
		// landscape:
		%>
		<table border="0" cellspacing="0" cellpadding="0" width="300">
		<tr valign="top">
		<td class="bodyFont"><img src="../images/musclegroupicons/<%=iconImage%>.gif" height="46" width="25" /><br/></td>
		<td class="bodyFont"><a href="#" onclick="getVideo(<%=id%>, '<%=filename%>'); return false;"><%=name%></a><br/>
		<%=description%><br/></td>
		<td>&nbsp;&nbsp;</td>
		<td><a href="#" onclick="getVideo(<%=id%>, '<%=filename%>'); return false;"><img src="../images/videograbs/<%=thumbFilename%>" width="111" height="83" border="0" /></a><br/></td>
		</tr>
		</table>
		<%
	}
	%>

