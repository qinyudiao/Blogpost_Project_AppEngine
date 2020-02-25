package austinFoodTour;

import java.util.List;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class JavaMailUtil{
	public static void sendMail(String[] recepients, List<String> titles) throws Exception {
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);
		
		String titlesS = "";
		for (String title: titles) {
			titlesS = titlesS + "\"" + title + "\", ";
		}
		
		//String myAccountEmail = "qinyudiao@gmail.com";
		String myAccountEmail = "jack@blog-app-project-268600.appspotmail.com";
		Message message = prepareMessage(session, myAccountEmail, recepients, titlesS);

		Transport.send(message);
		System.out.println("Message sent");
	}

	private static Message prepareMessage(Session session, String myAccountEmail, String[] recepients, String titlesS) {
		try {
	        Address[] tos = new InternetAddress[recepients.length];
	        for (int i = 0; i < recepients.length; i++) {
	            tos[i] = new InternetAddress(recepients[i]);
	        }
	        
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(myAccountEmail, "Austin Food Tour Blog Admin"));
			message.setRecipients(Message.RecipientType.TO, tos);
			message.setSubject("Daily digest from Austin Food Tour!");
			message.setText("There are new posts, " + titlesS + "check it out!");

			System.out.println(message.getContent() + message.getSubject() + message.getAllRecipients() + message.getFrom());
			System.out.println("Message sent successfully");
			return message;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
