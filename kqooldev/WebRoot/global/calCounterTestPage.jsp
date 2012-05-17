<html>

<head>

<script>
document.domain="<%=new com.theavocadopapers.apps.kqool.GenericProperties().getJavascriptDocumentDomain()%>"
	function insertFoodItemToSpreadsheet(numServings, rawData) {}

</script>
<%@ include file="/global/calCounterJs.jsp" %>

<style type="text/css">
td, body {font-size:14px; font-family:arial,helvetica;}
</style>

</head>

<body>
<b>Calorie-Counter Test Page</b><br/><br/>

<a href="#" style="color:#cc0000;" onclick="addFood(); return false">Click to launch the calorie-counter box</a>
<div id="searchMain" style="display:none; position:absolute; top:20px; left:20px; z-index:20">
<iframe id="searchMainIframe" name="searchMainIframe" scrolling="no" style="width:600px; height:400px; border:2px solid #000000;" frameborder="0" framespacing="0" src="../workouts/calCounter/search.jsp?siteId=1"></iframe>
</div>
<div id="searchShadow" style="display:none; position:absolute; top:22px; left:22px; z-index:18">
<iframe style="width:600px; height:400px; border:2px solid #999999;" frameborder="0" framespacing="0" src="about:blank"></iframe>
</div>
</body>

</html>