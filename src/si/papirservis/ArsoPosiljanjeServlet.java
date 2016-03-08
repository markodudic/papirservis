package si.papirservis;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

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


public class ArsoPosiljanjeServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
    private static String smtpServer;
    private static String subject;
    private static String body;
    private static String user;
    private static String pass;
    private static String sender;
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
	public ArsoPosiljanjeServlet() {
		super();
	}

    public void init() throws ServletException
    {
		smtpServer = (String) getServletConfig().getInitParameter("smtpServerArso");
    	subject = (String) getServletConfig().getInitParameter("subjectArso");
    	body = (String) getServletConfig().getInitParameter("bodyArso");
    	user = (String) getServletConfig().getInitParameter("userArso");
    	pass = (String) getServletConfig().getInitParameter("passArso");
    	sender = (String) getServletConfig().getInitParameter("senderArso");
    	mail_smtp_auth = (String) getServletConfig().getInitParameter("mail_smtp_authArso");
    	mail_smtp_port = (String) getServletConfig().getInitParameter("mail_smtp_portArso");
    	mail_smtp_socketFactory_port = (String) getServletConfig().getInitParameter("mail_smtp_socketFactory_portArso");
    	mail_smtp_starttls_enable = (String) getServletConfig().getInitParameter("mail_smtp_starttls_enableArso");
    	mail_transport_protocol = (String) getServletConfig().getInitParameter("mail_transport_protocolArso");
    	use_ssl = (String) getServletConfig().getInitParameter("use_sslArso");
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
		String tempDir = this.getServletContext().getRealPath("/") + "arso/";
		String zipName = "evl_"+ (new Date()).getTime() + ".zip";
        
		System.out.println("uploadFile="+tempDir);
		FileOutputStream fos = new FileOutputStream(tempDir+"/" +zipName);
		ZipOutputStream zos = new ZipOutputStream(fos);
		OutputStream os = response.getOutputStream();
		byte[] buffer = new byte[1024];
		
		try {
			MultipartUpload mu = new MultipartUpload().decode(request, response, 20000000, tempDir+"/");
			System.out.println(mu.files);
			
			
			ArsoPDFParser arso = new ArsoPDFParser(tempDir);
			
			List<String> maticnaList = new ArrayList<String>();
					
			for (Entry<String, File> fEntry : mu.files.entrySet()) {
				maticnaList = arso.loadSavePDF(fEntry.getValue(), fEntry.getKey().replace(".pdf", ""));
				
				for (int i=1; i < maticnaList.size(); i++) {
				  String maticna = maticnaList.get(i);
				  FileInputStream fin = new FileInputStream(maticna);
			      try {
			        System.out.println("Compressing " + maticna.substring(maticna.indexOf("/")+1));
			        zos.putNextEntry(new ZipEntry(maticna.substring(maticna.indexOf("/")+1)));
		    		int len;
		    		while ((len = fin.read(buffer)) > 0) {
		    			zos.write(buffer, 0, len);
		    		}

				    //posljem mail
		    		String name = maticna.substring(maticna.indexOf("/")+1);
		    		name = name.substring(name.indexOf("_")+1).replace(".pdf", "");
		    		String email = getKupecMail(name);
		    		if (maticna.length() >= 7 && email != null) {
		    			sendMail(getKupecMail(name), maticna);
		    		}

			      } finally {
			        fin.close();
		    		//pobrisem pdf
			        File filename = new File(maticna);
			        filename.delete();
			      }
			      
				}
			}
		    zos.closeEntry();
		    zos.flush();
			zos.close();
			
			os.write((maticnaList.get(0)+"|"+"/arso/"+zipName).getBytes("utf-8"));
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		finally {
			os.flush();
			os.close();
		}


	}
	
	private String getKupecMail(String maticna) {

    	Statement stmt = null;
    	ResultSet rs = null;
    	String email = null;

	    try {
	    	connectionMake();

	    	String query = 	"select email from kupci where maticna = " + maticna;
			
			stmt = con.createStatement();   	
			rs = stmt.executeQuery(query);
			
			if (rs.next()) {
				email = rs.getString("email");
			}
	    	
	    } catch (Exception theException) {
	    	theException.printStackTrace();
	    } finally {
	    	try {
	    		if (rs != null) {
	    			rs.close();
	    		}
	    		if (stmt != null) {
	    			stmt.close();
	    		}
			} catch (Exception e) {
			}
	    }

    	
    	return email;
    }

	
	private boolean sendMail(String to, String filename)
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
          msg.setReplyTo(new javax.mail.Address[] {
       		    new javax.mail.internet.InternetAddress(sender)
       	  });
          
       // Create the message part 
          BodyPart messageBodyPart = new MimeBodyPart();

          // Fill the message
          messageBodyPart.setText(body);
          
          // Create a multipar message
          Multipart multipart = new MimeMultipart();

          // Set text message part
          multipart.addBodyPart(messageBodyPart);

          // Part two is attachment
          //for (int i=0; i<destFiles.length; i++) {
	          messageBodyPart = new MimeBodyPart();
	          //String filename = destFiles[i];
	          DataSource source = new FileDataSource(filename);
	          messageBodyPart.setDataHandler(new DataHandler(source));
	          messageBodyPart.setFileName(filename.substring(filename.indexOf("/")+1));
	          multipart.addBodyPart(messageBodyPart);
          //}
          
          // Send the complete message parts
          msg.setContent(multipart );

          Transport.send(msg);
          System.out.println("Message sent OK.");
          return true;
        }
        catch (Exception ex)
        {
          ex.printStackTrace();
          return false;
        }
    }
	
}
