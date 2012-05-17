<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%>
<%

SiteProperties siteProps=new SiteProperties(Integer.parseInt(controller.getSiteId()));

try {
	
	%>
	<!--
	<%=pageException.getClass()%>: <%=pageException.getMessage()%>
	<%
	pageException.printStackTrace(new PrintWriter(out, true)); // printwriter
	%>
	-->
	<%
}
catch (Throwable t) {
	%><!-- [Exception printing stack trace: <%=t%>] --><%
}
try {
	MailUtils.sendExceptionReport(pageContext, controller, pageException);
}
catch (Throwable t) {
	%><!-- [Exception sending exception mail: <%=t%>] --><%
}
%>


<%



try
{
	%>
	
	<script>
	////////////////// ///////////////////
	var pathToAppRoot="<%=PageUtils.getPathToAppRoot(request)%>"


		msgText=escape("There was a problem on our end. We apologize 1111. Your request may or may not have been completely processed. If you wish to report this error, please send e-mail to <%=siteProps.getCommentsEmailAddress()%>.")
		//if (window.showModalDialog)
		if (false)
		{
			
			url=pathToAppRoot+"global/jspError.jsp?throwableText="+msgText
			url=url.substring(0,1500)+"&t="+new Date().getTime()
			props="dialogHeight:300px; dialogWidth:477px; center:yes; edge:raised; help:no; resizable:no; scroll:no; status:no; unadorned:no; "

			window.showModalDialog(url,null,props)

		}
		else
		{
			alert(unescape(msgText))

		}
	</script>
	<%
}
catch (Throwable t) {

}

try
{
	response.flushBuffer();
	out.flush();
}
catch (Throwable t) {}

%>



