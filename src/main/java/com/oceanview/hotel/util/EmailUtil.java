package com.oceanview.hotel.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

// Sends email notifications via SMTP — configure EMAIL_USER/EMAIL_PASS env vars in production
public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USER = System.getenv("EMAIL_USER") != null
            ? System.getenv("EMAIL_USER") : "noreply@oceanviewresort.com";
    private static final String SMTP_PASS = System.getenv("EMAIL_PASS") != null
            ? System.getenv("EMAIL_PASS") : "";

    private EmailUtil() {}

    public static void send(String toEmail, String subject, String body) {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            System.out.println("[EmailUtil] No email address provided — skipping.");
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);
            Transport.send(message);
            System.out.println("[EmailUtil] Email sent to: " + toEmail);
        } catch (MessagingException e) {
            System.err.println("[EmailUtil] Failed to send email: " + e.getMessage());
        }
    }
}

