package si.papirservis;

import it.sauronsoftware.cron4j.Scheduler;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Locale;
import java.util.Vector;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.httpclient.HttpException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;


public class ArsoServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
    private String scheduler_pattern;
	private String url;
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public ArsoServlet() {
		super();
	}

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest arg0,
	 *      HttpServletResponse arg1)
	 */
	protected void doGet(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

    public void init() throws ServletException {
        /// Automatically java script can run here
        System.out.println("************");
        System.out.println("*** Arso Initialized successfully ***");
        System.out.println("***********");

        //preberem lokacijo sledenja serverja
		url = (String) getServletConfig().getInitParameter("ArsoZavezanciURL");
		System.out.println("url="+url);		
        scheduler_pattern = (String) getServletConfig().getInitParameter("scheduler_pattern");

          Scheduler s = new Scheduler();
	  	  s.schedule(scheduler_pattern, new Runnable() {
	  		  public void run() {
	  			scheduleRun();
	  	  	}
	  	  });
	  	  s.start();     
    }
		
		
	public void scheduleRun() {
		try
		{
			//dobimo podatke iz baze
			Vector data = getKupecBrezIDZavezanca();
			System.out.println("DATA="+data);	

			//posljemo na server arso
			for (int i=0; i<5; i++)
			{
				Vector kupec = (Vector) data.elementAt(i);
				String xml = getArsoData(url+kupec.elementAt(2));
				System.out.println("RESULT="+xml);	
				parseXmlFile(xml);
				//parsamo in vpisemo rezultat v bazo
			}
			
			return;

			
		}
		catch (Exception e)
		{
			e.printStackTrace();
			
		}
	
	}	
	
	private void parseXmlFile(String data){
		//get the factory
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		try {

			//Using factory get an instance of document builder
			DocumentBuilder db = dbf.newDocumentBuilder();

			//parse using builder to get DOM representation of the XML file
			parseDocument(db.parse(data));


		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(IOException ioe) {
			ioe.printStackTrace();
		}
	}
	
	private void parseDocument(Document dom){
		//get the root element
		Element docEle = dom.getDocumentElement();

		//get a nodelist of  elements
		NodeList nl = docEle.getElementsByTagName("ZAVEZANEC");
		if(nl != null && nl.getLength() > 0) {
			for(int i = 0 ; i < nl.getLength();i++) {

				//get the employee element
				Element el = (Element)nl.item(i);
				String id = getTextValue(el, "ID_ZAVEZANCA");
				System.out.println("ID ZACVEZANCA="+id);
			}
		}
	}
	
	
	private String getTextValue(Element ele, String tagName) {
		String textVal = null;
		NodeList nl = ele.getElementsByTagName(tagName);
		if(nl != null && nl.getLength() > 0) {
			Element el = (Element)nl.item(0);
			textVal = el.getFirstChild().getNodeValue();
		}

		return textVal;
	}	
	private Vector getKupecBrezIDZavezanca() {
    	Vector dataVector = new Vector();

    	ResultSet rs = null;
	    Statement stmt = null;

	    try {
	    	connectionMake();
	    	String query = 	"select sif_kupca, naziv, maticna from kupci where arso_pslj_st is null and blokada = 0 and (maticna is not null and maticna != '')";

	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);

	    	while (rs.next()) {
	    		Vector dataRecord = new Vector(11);
	    		dataRecord.add(rs.getString("sif_kupca"));
	    		dataRecord.add(rs.getString("naziv"));
	    		dataRecord.add(rs.getString("maticna"));
	    		dataVector.add(dataRecord);
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
		
		
		return dataVector;
	}
	
	
	
	/**
	 * @param url
	 * @param params
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws HttpException
	 */
	private String getArsoData(String server) throws FileNotFoundException, IOException, HttpException {
		System.out.println("url="+server);		
		String result = "";
        
	   	String serv =  server;
	   	try 
    	{
          URL  url = new URL(serv);
          URLConnection con = url.openConnection();

          con.setDoInput(true);
          con.setDoOutput(true);
          con.setUseCaches(false);
          con.setDefaultUseCaches(false);

          BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));

          String inputLine;
          while ((inputLine = in.readLine()) != null) {
        	  result += inputLine;
          }
          in.close();
    	}
    	catch(Exception e) 
    	{ 
    		System.out.println(e); 
    		return null;
    	}
    	
    	return result;
       
	}

}
