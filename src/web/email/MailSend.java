package web.email;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.parking.member.model.service.MemberService;
import com.parking.member.model.vo.Member;

public class MailSend {

	public static String SendingMail(String email) {
		Properties prop = System.getProperties();
		prop.put("mail.smtp.starttls.enable", "true");
		prop.put("mail.smtp.host", "smtp.gmail.com");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.port", "587");

		Authenticator auth = new MailAuth();

		Session session = Session.getDefaultInstance(prop, auth);
		
		MimeMessage msg = new MimeMessage(session);
		String host = "https://rclass.iptime.org/Parking/";
//		System.out.println("email :" +email);
		String code = new AES256E().encrypt(email, "hi");
		String htmlcode = "<h3> Please click the <a href='" +host+ "views/member/emailverificationpopup.jsp?code=" +code +"&email=" +email+"'>link</a> to activate your account</h3>";
		 
		

		try {
			msg.setSentDate(new Date());
			msg.setFrom(new InternetAddress("94hojun@gmaizl.com", "Illegal Parking"));
			InternetAddress to = new InternetAddress(email);
			msg.setRecipient(Message.RecipientType.TO, to);
			msg.setSubject("제목", "UTF-8");
			msg.setContent(htmlcode, "text/html");
			Transport.send(msg);

		} catch (AddressException ae) {
			System.out.println("AddressException : " + ae.getMessage());
		} catch (MessagingException me) {
			System.out.println("MessagingException : " + me.getMessage());
		} catch (UnsupportedEncodingException e) {
			System.out.println("UnsupportedE/`codingException : " + e.getMessage());
	}
		return code;
		


	}
	
	
	
	
	
	
	
}
