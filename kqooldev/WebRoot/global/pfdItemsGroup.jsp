<%@ page import="java.util.Hashtable" %>
<%@ page import="com.theavocadopapers.apps.kqool.util.HtmlUtils" %>
<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.pfd.*" %>
<%
PfdProperties pfdProps=new PfdProperties();
CurrentPfdData currentData=(CurrentPfdData)request.getAttribute("currentData");

String[] group=(String[])request.getAttribute("currGroup");
String subhead=(String)request.getAttribute("subhead");
String postNote=(String)request.getAttribute("postNote");
boolean indent=((Boolean)request.getAttribute("indent")).booleanValue();
boolean bold=((Boolean)request.getAttribute("bold")).booleanValue();

%>
<%
if (subhead!=null) {
	%><tr>
	<td colspan="3" class="bodyFont"><b><%=subhead%></b><br/>
	<img src="../images/spacer.gif" height="9" width="2" /><br/></td>
	</tr>
	<%
}
%>

<%

for (int i=0; i<group.length; i++) {
	%><tr>
	<td class="bodyFont"><%=bold?"<b>":""%><%=indent?"&nbsp;&nbsp;&nbsp;&nbsp;":""%><%=pfdProps.getQuestion(group[i])%><%=bold?"</b>":""%><br/></td>
	<td class="bodyFont"><br/></td>
	<td valign="top" nowrap="nowrap" width="80" class="bodyFont" align="right"><nobr><%=HtmlUtils.getYesNoRadios(currentData.getCurrentItemValue(group[i]).equals("true"), group[i])%><br/></nobr></td>
	</tr>
	<tr>
	<td colspan="3"><img src="../images/spacer.gif" height="5" width="1" /><br/></td>
	</tr>
	<%
}

if (postNote!=null) {
	%>
	<tr>
	<td colspan="3" class="bodyFont"><br/><%=postNote%><br/><br/></td>
	</tr>
	<%
}

%>

