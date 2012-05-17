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
  String toAddress2 =request.getParameter("to2");
  InternetAddress to2 = new InternetAddress(toAddress2);
  message.addRecipient(Message.RecipientType.TO, to2);
  String subject = request.getParameter("subject");
  String firstName = request.getParameter("firstName");
  String lastName = request.getParameter("lastName");
  String address1 = request.getParameter("address1");
  String address2 = request.getParameter("address2");
  String city = request.getParameter("city");
  String state = request.getParameter("state");
  String zip = request.getParameter("zip");
  String email = request.getParameter("email");
  String phone = request.getParameter("phone");
  String comments = request.getParameter("comments");
  String newtext = "First name:" + firstName + "\n\n" +  "Last name:" + lastName  + "\n\n" +  "Address:" + address1 + "\n" + address2 + "\n\n" +  "City:" + city + "\n\n" +  "State:" + state + "\n\n" + "Postal code:" + zip + "\n\n" + "Email address:" + email + "\n\n" + "Phone:" + phone + "\n\n" + "Comments:" + comments; 
  message.setSubject(subject);
 
	message.setText(newtext);
  Transport.send(message);


String redir="index.jsp";

%>

<script type="text/javascript">
location.replace("<%=redir%>");
</script>
