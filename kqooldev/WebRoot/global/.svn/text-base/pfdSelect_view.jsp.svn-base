<%@ page import="java.util.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.pfd.*" %>

<%
try {
	PfdProperties pfdProps=(PfdProperties)request.getAttribute("pfdProps");
	CurrentPfdData currentData=(CurrentPfdData)request.getAttribute("currentData");
	String fieldName=(String)request.getAttribute("fieldName");
	String subhead=pfdProps.getQuestion(fieldName);
	LinkedHashMap<String,String> valuesToLabels=pfdProps.getOptionsItemValueLabelMap(fieldName);
	%>
	<b><%=subhead%></b> <%=valuesToLabels.get(currentData.getCurrentItemValue(fieldName))%>
	
	<%
}
catch (Exception e) {
}

%>