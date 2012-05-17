<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%>	<% /*
	Copyright (c) Steve Schneider 2002-2005..
	All rights reserved.
	*/ 

		// these brackets end the if clauses opened in one of the topIncludes:
		} // END if (!invalidRequestMethod && !PageUtils.isCompileOnly(request))
	} // END if (executePage)
	logger.info("JSP "+((Servlet)pageContext.getPage()).getClass()+" completed successfully.");
} // END try block opened in topInclude.jsp
catch (Throwable pageEx)
{
	pageException=pageEx;
	logger.error("JSP "+((Servlet)pageContext.getPage()).getClass()+" DID NOT COMPLETE successfully.", pageException);

} 
boolean suppressRenderedTimeComment=(request.getAttribute("suppressRenderedTimeComment")!=null && request.getAttribute("suppressRenderedTimeComment").equals("true"));
long endTimeMillis=new Date().getTime();
//String timeMsg=request.getRequestURI()+" rendered in "+(endTimeMillis-startTimeMillis)+" milliseconds.";
String timeMsg=((Servlet)pageContext.getPage()).getClass().getName()+" rendered in "+(endTimeMillis-startTimeMillis)+" milliseconds.";
logger.info(timeMsg);
if (!suppressRenderedTimeComment) {
	out.println("<!-- "+timeMsg+" -->");
	%> 
	<%
}
%>