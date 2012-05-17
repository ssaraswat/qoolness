<%@ page import="com.theavocadopapers.apps.kqool.pfd.*" %>
<%
CurrentPfdData currentData=(CurrentPfdData)request.getAttribute("currentData");
String subhead=(String)request.getAttribute("subhead");
String fieldName=(String)request.getAttribute("fieldName");
String value=currentData.getCurrentItemValue(fieldName);
value=(value.trim().length()==0?"[no answer]":value);
%>
<font class="bodyFont"><b><%=subhead%></b> <%=value%><br/><br/><br/></font>