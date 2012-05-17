<style type="text/css">
body, td {font-size:12px; font-family:arial,helvetica; }
</style>
<%!

	public static java.util.List sortedListFromEnumeration(java.util.Enumeration en) {
	java.util.List list=new java.util.ArrayList();
		while (en.hasMoreElements()) {
			list.add(en.nextElement());
		}
		java.util.Collections.sort(list);
		return list;
	}
	public static void writeProps(final PageContext pageContext) throws java.io.IOException {
		ServletContext appCtx=pageContext.getServletContext();
		JspWriter out=pageContext.getOut();
		java.util.Properties sysProps=System.getProperties();
		java.util.Set<Object> propNames=new java.util.TreeSet(sysProps.keySet());
		out.println("System (JVM) properties:<br/><ul>");
		for (Object propName : propNames) {
			out.println("<li>"+propName+"="+sysProps.getProperty((String)propName)+"<br/></li>");
		}
		out.println("</ul><br/><br/>");
		out.println("Application (ServletContext) attributes:<br/><ul>");
		java.util.List<String> attrNames=sortedListFromEnumeration(appCtx.getAttributeNames());
		for (String name: attrNames) {
			out.println("<li>"+name+"="+appCtx.getAttribute(name)+"<br/></li>");
		}
		out.println("</ul><br/><br/>");
		
		out.println("Application (ServletContext) init params:<br/><ul>");
		attrNames=sortedListFromEnumeration(appCtx.getInitParameterNames());

		for (String name: attrNames) {
			out.println("<li>"+name+"="+appCtx.getInitParameter(name)+"<br/></li>");
		}
		out.println("</ul><br/><br/>");
		
	
	}
%>
<%
writeProps(pageContext);
%>