<%
String redir="menu.jsp?siteId="+request.getParameter("siteId");
%>
<script type="text/javascript">
location.replace("<%=redir%>");
</script>
