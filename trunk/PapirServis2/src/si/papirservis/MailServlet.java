package si.papirservis;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperRunManager;


public class MailServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
    private static String reportDir;
    private static String logoPdf;
    private static String report;
    private static String smtpServer;
    private static String subject;
    private static String user;
    private static String pass;
    private static String mail_smtp_auth;
    private static String mail_smtp_port;
    private static String mail_smtp_socketFactory_port;
    private static String mail_smtp_starttls_enable;
    private static String mail_transport_protocol;
    private static String use_ssl;
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public MailServlet() {
		super();
	}

    public void init() throws ServletException
    {
		reportDir = getServletContext().getInitParameter("reportDir");
		logoPdf = getServletContext().getInitParameter("logoPdf");
    	report = (String) getServletConfig().getInitParameter("report");
        
    	smtpServer = (String) getServletConfig().getInitParameter("smtpServer");
    	subject = (String) getServletConfig().getInitParameter("subject");
    	user = (String) getServletConfig().getInitParameter("user");
    	pass = (String) getServletConfig().getInitParameter("pass");
    	mail_smtp_auth = (String) getServletConfig().getInitParameter("mail_smtp_auth");
    	mail_smtp_port = (String) getServletConfig().getInitParameter("mail_smtp_port");
    	mail_smtp_socketFactory_port = (String) getServletConfig().getInitParameter("mail_smtp_socketFactory_port");
    	mail_smtp_starttls_enable = (String) getServletConfig().getInitParameter("mail_smtp_starttls_enable");
    	mail_transport_protocol = (String) getServletConfig().getInitParameter("mail_transport_protocol");
    	use_ssl = (String) getServletConfig().getInitParameter("use_ssl");
    }     
     /*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest arg0,
	 *      HttpServletResponse arg1)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("SERVLET GET");	
		doPost(request, response);
	}

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest arg0,
	 *      HttpServletResponse arg1)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//request.setCharacterEncoding("UTF-8");

		String receiver = (String) request.getParameter("receiver");
		String msg = (String) request.getParameter("msg");
		String user = (String) request.getParameter("user");
		String sender = (String) request.getParameter("sender");
		String key = (String) request.getParameter("key");
		String keys[] = key.split(",");
		String tabela = (String) request.getParameter("tabela");
		
		try{
			String[] destFiles = new String[keys.length];
			for (int i=0; i<keys.length; i++) {
				destFiles[i] = createPdf(keys[i], tabela);
				
			}
			sendMail(receiver, msg, sender, destFiles);
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.write("Mail uspešno poslan");
			
			//pobrisem file
			for (int i=0; i<destFiles.length; i++) {
		          File file = new File(destFiles[i]);
		          file.delete();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			OutputStream out = response.getOutputStream();
			out.write("Napaka pri pripravi podatkov.".getBytes("utf-8"));
			out.flush();
			out.close();
		}
	
	}	

	
	private static void sendMail(String to, String body, String sender, String[] destFiles)
    {
        try
        {
          Properties props = System.getProperties();
          props.setProperty("mail.transport.protocol", mail_transport_protocol);
          props.put("mail.smtp.host", smtpServer);
          props.put("mail.smtp.auth", mail_smtp_auth);
          props.put("mail.smtp.port", mail_smtp_port);
          props.put("mail.smtp.starttls.enable",mail_smtp_starttls_enable);

          if (use_ssl.equals("true")) {
              props.put("mail.smtp.socketFactory.port", mail_smtp_socketFactory_port);
              props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
              props.put("mail.smtp.socketFactory.fallback", "false");
          }
          props.setProperty("mail.smtp.quitwait", "false");

          Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() 
          {
            protected PasswordAuthentication getPasswordAuthentication()
            { return new PasswordAuthentication(user,pass);    }
          });
            
          //Session session = Session.getDefaultInstance(props, null);
          Message msg = new MimeMessage(session);
          if (sender!=null && !sender.equals("null") && !sender.equals("")) {
        	  msg.setFrom(new InternetAddress(sender));
          }
          if (to.indexOf(',') > 0) 
                msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
          else
              msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));

          msg.setSubject(subject);
          msg.setSentDate(new Date());
          
       // Create the message part 
          BodyPart messageBodyPart = new MimeBodyPart();

          // Fill the message
          messageBodyPart.setText(body);
          
          // Create a multipar message
          Multipart multipart = new MimeMultipart();

          // Set text message part
          multipart.addBodyPart(messageBodyPart);

          // Part two is attachment
          for (int i=0; i<destFiles.length; i++) {
	          messageBodyPart = new MimeBodyPart();
	          String filename = destFiles[i];
	          DataSource source = new FileDataSource(filename);
	          messageBodyPart.setDataHandler(new DataHandler(source));
	          messageBodyPart.setFileName(filename.substring(filename.indexOf("/")+1));
	          multipart.addBodyPart(messageBodyPart);
          }
          
          // Send the complete message parts
          msg.setContent(multipart );

          Transport.send(msg);
          System.out.println("Message sent OK.");
        }
        catch (Exception ex)
        {
          ex.printStackTrace();
        }
    }
	
	private String createPdf(String stDob, String tabela) {
		String destFile = reportDir+"/"+stDob+".pdf";
		try {
		    Map parameters = new HashMap();
		    parameters.put("st_dob", new Integer(stDob));
		    parameters.put("dobLeto", tabela);
			parameters.put("SUBREPORT_DIR", reportDir);	    
	    	parameters.put("picture", logoPdf);
	    	
	    	InputStream reportStream = getServletConfig().getServletContext().getResourceAsStream(report);
			//response.setContentType("application/pdf");
			Connection conn = connectionMake();
    	
			JasperRunManager.runReportToPdfFile(reportDir+"/"+report, destFile, parameters, conn);
			//JasperRunManager.runReportToPdfStream(reportStream, response.getOutputStream(), parameters, conn );

	        //response.getOutputStream().flush();
	        //response.getOutputStream().close();			
		} catch (JRException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		return destFile;
	}
	
}
