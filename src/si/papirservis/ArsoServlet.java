package si.papirservis;

import it.sauronsoftware.cron4j.Scheduler;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Locale;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

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
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;


public class ArsoServlet extends InitServlet implements Servlet {

	private final String NODE_ZAVEZANEC 	= "ZAVEZANEC";
	private final String ITEM_MATICNA	 	= "MATICNA_ST";
	private final String ITEM_ID_ZAVEZANCA 	= "ID_ZAVEZANCA";
	private final String NODE_LOKACIJA 		= "LOKACIJA";
	private final String ITEM_NASLOV 		= "NASLOV";
	private final String ITEM_ID_LOKACIJE 	= "LOC_ID";
				
	Locale locale = Locale.getDefault();
    private String scheduler_pattern;
	//private String url;
	private String prevoznikiURL;
	private String posiljateljiURL;
	private String prejemnikiURL;
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

        //url = (String) getServletConfig().getInitParameter("ArsoZavezanciURL");
        prevoznikiURL = (String) getServletConfig().getInitParameter("ArsoPrevoznikiURL");
        posiljateljiURL = (String) getServletConfig().getInitParameter("ArsoPosiljateljiURL");
        prejemnikiURL = (String) getServletConfig().getInitParameter("ArsoPrejemnikiURL");
		//System.out.println("url="+url);		
        scheduler_pattern = (String) getServletConfig().getInitParameter("scheduler_pattern");

       
        Scheduler s = new Scheduler();
  	  	s.schedule(scheduler_pattern, new Runnable() {
  	  		public void run() {
	  	  		try
	  			{
	  				String xml = getArsoZipData(prevoznikiURL);
	  				Document doc = parseXmlFile(xml);
	  				if (doc == null) {
	  					System.out.println("Napaka pri poizvedbi na Arso za: " + prevoznikiURL);
	  				} else {
	  			        getKupciIdZavezanca(doc);
	  				}
	
	  				xml = getArsoZipData(prejemnikiURL);
	  				doc = parseXmlFile(xml);
	  				if (doc == null) {
	  					System.out.println("Napaka pri poizvedbi na Arso za: " + prejemnikiURL);
	  				} else {
	  			        getKupciIdZavezanca(doc);
	  			        getStrankeIdLokacije(doc);
	  				}

	  				xml = getArsoZipData(posiljateljiURL);
	  				doc = parseXmlFile(xml);
	  				if (doc == null) {
	  					System.out.println("Napaka pri poizvedbi na Arso za: " + posiljateljiURL);
	  				} else {
	  			        getKupciIdZavezanca(doc);
	  			        getStrankeIdLokacije(doc);
	  				}	  			
	  			}
	  			catch (Exception e)
	  			{
	  				e.printStackTrace();
	  				
	  			}	  				
  	  		}
  	  	});
  	  	s.start();   
    }

	public void getKupciIdZavezanca(Document doc) {
			//System.out.println(xml);	

			//dobimo podatke iz baze
			Vector data = getKupecBrezIDZavezanca();
			//System.out.println("DATA="+data);	

			//posljemo na server arso
			String neObstajajoVArsoBazi = "";
			for (int i=0; i<data.size(); i++)
			{
				Vector kupec = (Vector) data.elementAt(i);
				String naziv =((String)kupec.elementAt(1)).trim();
				String naslov =((String)kupec.elementAt(2)).trim();
				String posta =((String)kupec.elementAt(3)).trim();
				String kraj =((String)kupec.elementAt(4)).trim();
				String maticna =((String)kupec.elementAt(5)).trim();

				String idZavezanca = parseDocumentIdZavezanca(doc, maticna);
				//parsamo in vpisemo rezultat v bazo
				if (idZavezanca == null) {
					neObstajajoVArsoBazi += maticna+";"+naziv+";"+naslov+";"+posta+" "+kraj+"\r\n";
				} else {
					System.out.println("PSLJ_ST: "+maticna+":"+idZavezanca);
					setIdZavezanca(maticna, idZavezanca);
				}
			}
			System.out.println("**************** Kupci, ki ne obstajajo v arso bazi. ***********************");
			System.out.println(neObstajajoVArsoBazi);
			System.out.println("****************************************************************************");
			return;
	}	


	public void getStrankeIdLokacije(Document doc) {
		try
		{
			//dobimo podatke iz baze
			Vector data = getStrankeBrezIDLokacije();
			//System.out.println("DATA="+data);	

			//posljemo na server arso
			String neObstajajoVArsoBazi = "";
			for (int i=0; i<data.size(); i++)
			{
				Vector stranka = (Vector) data.elementAt(i);
				String sif_str =((String)stranka.elementAt(0)).trim();
				String naziv =((String)stranka.elementAt(1)).trim();
				String naslov =((String)stranka.elementAt(2)).trim();
				String posta =((String)stranka.elementAt(3)).trim();
				String kraj =((String)stranka.elementAt(4)).trim();
				String maticna =((String)stranka.elementAt(5)).trim();

				String idLokacije = parseDocumentIdLokacije(doc, naslov + ", " + posta, maticna);
				//parsamo in vpisemo rezultat v bazo
				if (idLokacije == null) {
					neObstajajoVArsoBazi += maticna+";"+naziv+";"+naslov+";"+posta+" "+kraj+"\n";
				} else {
					System.out.println("LOC_ID: "+sif_str+":"+idLokacije);
					setIdLokacije(sif_str, idLokacije);
				}
			}
			System.out.println("**************** Stranka, ki ne obstajajo v arso bazi. ***********************");
			System.out.println(neObstajajoVArsoBazi);
			System.out.println("****************************************************************************");
			return;

			
		}
		catch (Exception e)
		{
			e.printStackTrace();
			
		}
	
	}
	
	
	/*	
	public void getKupciIdZavezanca() {
		try
		{
			//dobimo podatke iz baze
			Vector data = getKupecBrezIDZavezanca();
			//System.out.println("DATA="+data);	

			//posljemo na server arso
			String neObstajajoVArsoBazi = "";
			for (int i=0; i<data.size(); i++)
			{
				Vector kupec = (Vector) data.elementAt(i);
				String naziv =((String)kupec.elementAt(1)).trim();
				String naslov =((String)kupec.elementAt(2)).trim();
				String posta =((String)kupec.elementAt(3)).trim();
				String kraj =((String)kupec.elementAt(4)).trim();
				String maticna =((String)kupec.elementAt(5)).trim();
				String xml = getArsoData(url+maticna);
				//System.out.println("RESULT="+xml);
				Document doc = parseXmlFile(xml);
				if (doc == null) {
					System.out.println("Napaka pri poizvedbi na Arso za url: "+url+maticna);
					continue;
				}
				String idZavezanca = parseDocumentIdZavezanca(doc);
				//parsamo in vpisemo rezultat v bazo
				if (idZavezanca == null) {
					neObstajajoVArsoBazi += maticna+";"+naziv+";"+naslov+";"+posta+" "+kraj+"\r\n";
				} else {
					setIdZavezanca(maticna, idZavezanca);
				}
			}
			System.out.println("**************** Kupci, ki ne obstajajo v arso bazi. ***********************");
			System.out.println(neObstajajoVArsoBazi);
			System.out.println("****************************************************************************");
			return;

			
		}
		catch (Exception e)
		{
			e.printStackTrace();
			
		}
	
	}	

	public void getStrankeIdLokacije() {
		try
		{
			//dobimo podatke iz baze
			Vector data = getStrankeBrezIDLokacije();
			//System.out.println("DATA="+data);	

			//posljemo na server arso
			String neObstajajoVArsoBazi = "";
			for (int i=0; i<data.size(); i++)
			{
				Vector stranka = (Vector) data.elementAt(i);
				String sif_str =((String)stranka.elementAt(0)).trim();
				String naziv =((String)stranka.elementAt(1)).trim();
				String naslov =((String)stranka.elementAt(2)).trim();
				String posta =((String)stranka.elementAt(3)).trim();
				String kraj =((String)stranka.elementAt(4)).trim();
				String maticna =((String)stranka.elementAt(5)).trim();
				String xml = getArsoData(url+maticna);
				//System.out.println("RESULT="+xml);
				Document doc = parseXmlFile(xml);
				if (doc == null) {
					System.out.println("Napaka pri poizvedbi na Arso za url: "+url+maticna);
					continue;
				}
				String idLokacije = parseDocumentIdLokacije(doc, naslov + ", " + posta);
				//parsamo in vpisemo rezultat v bazo
				if (idLokacije == null) {
					neObstajajoVArsoBazi += maticna+";"+naziv+";"+naslov+";"+posta+" "+kraj+"\n";
				} else {
					setIdLokacije(sif_str, idLokacije);
				}
			}
			System.out.println("**************** Stranka, ki ne obstajajo v arso bazi. ***********************");
			System.out.println(neObstajajoVArsoBazi);
			System.out.println("****************************************************************************");
			return;

			
		}
		catch (Exception e)
		{
			e.printStackTrace();
			
		}
	
	}	*/

	private Document parseXmlFile(String data){
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			return db.parse(new InputSource(new ByteArrayInputStream(data.getBytes("WINDOWS-1250"))));
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(IOException ioe) {
			ioe.printStackTrace();
		}
		
		return null;
	}
	
	private String parseDocumentIdZavezanca(Document dom, String maticna){
		//get the root element
		Element docEle = dom.getDocumentElement();

		//get a nodelist of  elements
		NodeList nl = docEle.getElementsByTagName(NODE_ZAVEZANEC);
		if(nl != null && nl.getLength() > 0) {
			for(int i = 0 ; i < nl.getLength();i++) {
				//get the employee element
				Element el = (Element)nl.item(i);
				String m = getTextValue(el, ITEM_MATICNA);
				if (m.equals(maticna)) {
					String id = getTextValue(el, ITEM_ID_ZAVEZANCA);
					return id;
				}
			}
		}
		
		return null;
	}
	
	private String parseDocumentIdLokacije(Document dom, String naslovPS, String maticna){
		//get the root element
		Element docEle = dom.getDocumentElement();

		//get a nodelist of  elements
		NodeList nl = docEle.getElementsByTagName(NODE_ZAVEZANEC);
		if(nl != null && nl.getLength() > 0) {
			for(int i = 0 ; i < nl.getLength();i++) {
				Element el = (Element)nl.item(i);
				String m = getTextValue(el, ITEM_MATICNA);
				if (m.equals(maticna)) {
					//get a nodelist of  elements
					NodeList nll = el.getElementsByTagName(NODE_LOKACIJA);
					if(nll != null && nll.getLength() > 0) {
						for(int ii = 0 ; ii < nll.getLength();ii++) {
							//get the employee element
							Element ell = (Element)nll.item(ii);
							String naslovArso = getTextValue(ell, ITEM_NASLOV);
							if (naslovArso!=null && naslovArso.toUpperCase().startsWith(naslovPS.toUpperCase())) {
								return getTextValue(ell, ITEM_ID_LOKACIJE);
							}
						}
					} 
				}
			}
		}
		
		return null;
	}
	
	
	private String getTextValue(Element ele, String tagName) {
		String textVal = null;
		NodeList nl = ele.getElementsByTagName(tagName);
		if(nl != null && nl.getLength() > 0) {
			Element el = (Element)nl.item(0);
			if (el.hasChildNodes())
				textVal = el.getFirstChild().getNodeValue();
			else
				return null;
		}

		return textVal;
	}	
	private Vector getKupecBrezIDZavezanca() {
    	Vector dataVector = new Vector();

    	ResultSet rs = null;
	    Statement stmt = null;

	    try {
	    	connectionMake();
	    	String query = 	"select sif_kupca, naziv, naslov, posta, kraj, maticna from kupci where arso_pslj_st is null and (maticna is not null and maticna != '')";

	    	//System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);

	    	while (rs.next()) {
	    		Vector dataRecord = new Vector(11);
	    		dataRecord.add(rs.getString("sif_kupca"));
	    		dataRecord.add(rs.getString("naziv")+"");
	    		dataRecord.add(rs.getString("naslov")+"");
	    		dataRecord.add(rs.getString("posta")+"");
	    		dataRecord.add(rs.getString("kraj")+"");
	    		dataRecord.add(rs.getString("maticna")+"");
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
	
	
	private void setIdZavezanca(String maticna, String idZavezanca) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

	    	String	sql = "update kupci " +
						 "set arso_pslj_st = " + idZavezanca +
						 " where maticna = '" + maticna +"'";
	    		
    		//System.out.println("setIdZavezanca="+sql);
	    	disableTriggers();
    		stmt.executeUpdate(sql);
	    	enableTriggers();
	    } catch (Exception theException) {
	    	theException.printStackTrace();
	    } finally {
	    	try {
	    		if (stmt != null) {
	    			stmt.close();
	    		}
			} catch (Exception e) {
			}
	    }	
		
		return;
	}
	
	private Vector getStrankeBrezIDLokacije() {
    	Vector dataVector = new Vector();

    	ResultSet rs = null;
	    Statement stmt = null;

	    try {
	    	connectionMake();
	    	String query = 	"select stranke.sif_str, stranke.naziv, stranke.naslov, stranke.posta, stranke.kraj, maticna " +
	    					"from stranke left join kupci on (stranke.sif_kupca = kupci.sif_kupca) " + 
	    					"where arso_odp_loc_id is null and (maticna is not null and maticna != '')";

	    	//System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);

	    	while (rs.next()) {
	    		Vector dataRecord = new Vector(11);
	    		dataRecord.add(rs.getString("sif_str"));
	    		dataRecord.add(rs.getString("naziv")+"");
	    		dataRecord.add(rs.getString("naslov")+"");
	    		dataRecord.add(rs.getString("posta")+"");
	    		dataRecord.add(rs.getString("kraj")+"");
	    		dataRecord.add(rs.getString("maticna")+"");
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

	private void setIdLokacije(String sif_str, String idLokacije) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

	    	String	sql = "update stranke " +
						 "set arso_odp_loc_id = " + idLokacije +
						 " where sif_str = '" + sif_str +"'";
	    		
    		//System.out.println("setIdLokacije="+sql);
	    	disableTriggers();
    		stmt.executeUpdate(sql);
	    	enableTriggers();
	    } catch (Exception theException) {
	    	theException.printStackTrace();
	    } finally {
	    	try {
	    		if (stmt != null) {
	    			stmt.close();
	    		}
			} catch (Exception e) {
			}
	    }	
		
		return;
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

          BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream(), "WINDOWS-1250"));

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
	
	private String getArsoZipData(String server) throws FileNotFoundException, IOException, HttpException {
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
          
          InputStream is = new BufferedInputStream(url.openStream(), 20480);
          
          // this is where you start, with an InputStream containing the bytes from the zip file
          ZipInputStream zis = new ZipInputStream(is);
          ZipEntry entry;
          byte[] buffer = new byte[20480];
              // while there are entries I process them
          while ((entry = zis.getNextEntry()) != null)
          {
              System.out.println("entry: " + entry.getName() + ", " + entry.getSize());
              
              //FileOutputStream output = null;
              ByteArrayOutputStream fos = new ByteArrayOutputStream();

              try
              {
                  //output = new FileOutputStream(outpath);
                  int len = 0;
                  while ((len = zis.read(buffer)) > 0)
                  {
                	  fos.write(buffer, 0, len);
                      //result += fos.toString();
                	  //System.out.println(len);
                  }
              }
              finally
              {
                  //System.out.println(fos.toString());
                  result = fos.toString();
                  // we must always close the output file
                  //if(output!=null) output.close();
              }
              
              while (zis.available() > 0)
                  zis.read();
          }

          is.close();
    	}
    	catch(Exception e) 
    	{ 
    		System.out.println(e); 
    		return null;
    	}
    	
    	return result;
	}	

}
