<script>
alert("Print this sheet and take it with you when you work out, making note of the exercises you do. Then return to kqool.com and record your workout.")
location.replace("showWorkoutPrintable.jsp?id=<%=request.getParameter("id")%>&siteId=<%=request.getParameter("siteId")%>")
</script>