<%@ page import="java.util.*, javax.mail.*, javax.mail.internet.*" %>
<%
  Properties props = new Properties();
  props.put("mail.smtp.host", "127.0.0.1");
  Session s = Session.getInstance(props,null);

  MimeMessage message = new MimeMessage(s);
  String fromAddress = request.getParameter("from");
  InternetAddress from = new InternetAddress(fromAddress);
  message.setFrom(from);
  String toAddress =request.getParameter("to");
  InternetAddress to = new InternetAddress(toAddress);
  message.addRecipient(Message.RecipientType.TO, to);
String subject = request.getParameter("subject");
String text = request.getParameter("message");
message.setSubject(subject);
 
  message.setText(text);

  Transport.send(message);
%>
<html>
<p align="center">The Message has been sent.<br />Check your inbox.</p>

</html>