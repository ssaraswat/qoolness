<%
String redir="login.jsp?siteId="+request.getParameter("siteId");
%>
<script type="text/javascript">
location.replace("<%=redir%>");
</script>
