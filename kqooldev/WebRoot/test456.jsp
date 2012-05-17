<%@ page import="java.net.*" %>
<%
String s="%7B%22calories%22%3A%2281.36%22%2C%22calcium%22%3A%2268.93%22%2C%22carb%22%3A%223.0736%22%2C%22cholesterol%22%3A%224.52%22%2C%22fat%22%3A%221.1526%22%2C%22fiber%22%3A%220.0%22%2C%22protein%22%3A%2214.0007%22%2C%22satfat%22%3A%220.72885%22%2C%22sodium%22%3A%22458.78%22%2C%22sugar%22%3A%223.0736%22%2C%22chosenFood%22%3A%22Low%2BFat%252C%2B1%2525%2BMilk%2BFat%22%2C%22name%22%3A%22serving%2B%25284%2Boz%2529%22%7D";
String d=URLDecoder.decode(s, "UTF-8");
d=URLDecoder.decode(d, "UTF-8");


String s1="%7B%22calories%22%3A%2281.36%22%2C%22calcium%22%3A%2268.93%22%2C%22carb%22%3A%223.0736%22%2C%22cholesterol%22%3A%224.52%22%2C%22fat%22%3A%221.1526%22%2C%22fiber%22%3A%220.0%22%2C%22protein%22%3A%2214.0007%22%2C%22satfat%22%3A%220.72885%22%2C%22sodium%22%3A%22458.78%22%2C%22sugar%22%3A%223.0736%22%2C%22chosenFood%22%3A%22Low%2BFat%252C%2B1%2525%2BMilk%2BFat%22%2C%22name%22%3A%22serving%2B%25284%2Boz%2529%22%7D";
String d1=URLDecoder.decode(s1, "UTF-8").replaceAll("\\+", "%20");
d1=URLDecoder.decode(d1, "UTF-8");


%>
<%=d%><br/>
<%=d1%><br/>




