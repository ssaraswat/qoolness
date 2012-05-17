<%

String subhead=(String)request.getAttribute("subhead");
String fieldName=(String)request.getAttribute("fieldName");

%>
<font class=bodyFont><b><%=subhead%></b><br/></font>
<textarea name=<%=fieldName%> rows=5 cols=30 class=textareaText style="width:300px; height:60px;"></textarea><br/><br/>