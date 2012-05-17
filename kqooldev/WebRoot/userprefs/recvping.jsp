<%@ page import="java.io.File" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
       
<%!
static void processPing(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String data="at x..."+new Date()+"\n\n";
    Enumeration names=request.getHeaderNames();
    while (names.hasMoreElements()) {
        String name=(String)names.nextElement();
        String value=request.getHeader(name);
        data+=name+"="+value+"\n";
    } 
    data+="\nlocalName="+request.getLocalName()+"\n";
    data+="\nlocalAddr="+request.getLocalAddr()+"\n";
    File file=new File("/home/z0067456/workroll.com/pinginfo.html");
    FileWriter writer=new FileWriter(file);
    writer.write("<pre>"+data+"</pre>");
    writer.close();
}
%>
<%
processPing(request, response);
%>