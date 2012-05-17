<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><%@ page import="com.theavocadopapers.apps.kqool.util.*" %>
<%
boolean isAdminForTracking=false; // are we in the admin section of the site, in which case we don't want to track traffic:
try {
	String currentSectionNameForTracking=PageUtils.nonNull(PageUtils.getSection(request)).trim().toLowerCase();
	isAdminForTracking=currentSectionNameForTracking.equals("admin");
}
catch (Exception trackEx) {}

if (!isAdminForTracking) {
	%>
		<script type="text/javascript">
		var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
		document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
		</script>
		<script type="text/javascript">
		try {
		var pageTracker = _gat._getTracker("UA-9554437-1");
		pageTracker._trackPageview();
		} catch(err) {}</script>
	<%
	}
%>