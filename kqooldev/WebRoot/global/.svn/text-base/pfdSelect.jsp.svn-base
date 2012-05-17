<%@ page import="java.util.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.pfd.*" %>

<%
PfdProperties pfdProps=(PfdProperties)request.getAttribute("pfdProps");
CurrentPfdData currentData=(CurrentPfdData)request.getAttribute("currentData");
String fieldName=(String)request.getAttribute("fieldName");
String subhead=pfdProps.getQuestion(fieldName);
LinkedHashMap<String,String> valuesToLabels=pfdProps.getOptionsItemValueLabelMap(fieldName);
%>

<b><%=subhead%></b><br />
<select name="<%=fieldName%>" class="selectText" style="width:215px;">
<%
Iterator<String> values=valuesToLabels.keySet().iterator();
String value;
String label;
boolean selected;
while (values.hasNext()) {
	value=values.next();
	label=valuesToLabels.get(value);
	selected=currentData.getCurrentItemValue(fieldName).equals(value);
	%>
	<option value="<%=value%>" <%=selected?"selected=\"selected\"":""%>><%=label%></option>
	<%
}
%>
</select>
