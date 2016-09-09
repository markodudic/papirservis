package si.papirservis;

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
import java.nio.charset.Charset;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Locale;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.httpclient.HttpException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;


public class UpdateKupciDataFromArso  extends Init {

    private final static String URL = "http://okolje.arso.gov.si/service/posiljatelji.zip";

    private final String NODE_ZAVEZANEC 	= "ZAVEZANEC";
	private final String ITEM_MATICNA	 	= "MATICNA_ST";
	private final String ITEM_DAVCNA	 	= "DAVCNA_ST";
	private final String ITEM_NASLOV 		= "NASLOV";
	private final String ITEM_NAZIV 		= "NAZIV";
	private final String ITEM_POSTA 		= "POSTA";
	private final String ITEM_KRAJ	 		= "KRAJ";
				
	Locale locale = Locale.getDefault();

	public static UpdateKupciDataFromArso instance;
	
	/*
	 * Preveri character set od baze z SHOW VARIABLES LIKE '%char%';
	 * če je potrebno nastavi ga v my.conf
	 * 
	 * [mysqld]
	 *	collation-server = utf8_unicode_ci
	 *	init-connect='SET NAMES utf8'
	 *	character-set-server = utf8
	 * 
	 */

	public static void main(String[] args) {
		System.out.println("*** Update Kupci start ***");
		UpdateKupciDataFromArso instance = new UpdateKupciDataFromArso();
		try {
			instance.init();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("*** Update kupci end ***");
		   
	}
	
    public void init() throws ServletException {
		String xml;
		Document doc;
		try {
			xml = getArsoZipData(URL);
			doc = parseXmlFile(xml);
			if (doc == null) {
				System.out.println("Napaka pri poizvedbi na Arso za: " + URL);
			} else {
		        getKupciIdZavezanca(doc);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	  			
   
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

				HashMap zavezanec = parseDocumentIdZavezanca(doc, maticna);
				//parsamo in vpisemo rezultat v bazo
				if (zavezanec == null) {
					neObstajajoVArsoBazi += maticna+";"+naziv+";"+naslov+";"+posta+" "+kraj+"\r\n";
				} else {
					System.out.println("UPDATE: "+maticna+":"+zavezanec.get(ITEM_NAZIV));
					updateKupec(maticna, zavezanec);
				}
			}
			System.out.println("**************** Kupci, ki ne obstajajo v arso bazi. ***********************");
			System.out.println(neObstajajoVArsoBazi);
			System.out.println("****************************************************************************");
			return;
	}	

	private Document parseXmlFile(String data){
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			return db.parse(new InputSource(new ByteArrayInputStream(data.getBytes("windows-1250"))));
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(IOException ioe) {
			ioe.printStackTrace();
		}
		
		return null;
	}
	
	private HashMap parseDocumentIdZavezanca(Document dom, String maticna){
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
					HashMap z = new HashMap();
					z.put(ITEM_NAZIV, getTextValue(el, ITEM_NAZIV));
					z.put(ITEM_DAVCNA, getTextValue(el, ITEM_DAVCNA));
					String[] naslov = getTextValue(el, ITEM_NASLOV).split(",");
					String[] mesto = naslov[1].trim().split(" ");
					z.put(ITEM_NASLOV, naslov[0].trim());					
					z.put(ITEM_POSTA, mesto[0].trim());					
					z.put(ITEM_KRAJ, mesto[1].trim());					
					return z;
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
				try {
					textVal = el.getFirstChild().getNodeValue();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
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
	    	String query = 	"select sif_kupca, naziv, naslov, posta, kraj, maticna from kupci where maticna is not null and maticna != ''";

	    	System.out.println(query);	           
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
	
	
	private void updateKupec(String maticna, HashMap kupec) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

	    	String	sql = "update kupci " +
						 "set naziv = '" + kupec.get(ITEM_NAZIV) + "'  COLLATE  utf8_general_ci," +
						 "    naslov = '" + kupec.get(ITEM_NASLOV) + "'  COLLATE  utf8_general_ci," +
						 "    posta = '" + kupec.get(ITEM_POSTA) + "'," +
						 "    kraj = '" + kupec.get(ITEM_KRAJ) + "'  COLLATE  utf8_general_ci," +
						 "    davcna = '" + kupec.get(ITEM_DAVCNA) + "'" +
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

	
	private String getArsoZipData(String server) throws FileNotFoundException, IOException, HttpException {
		System.out.println("url="+server);		
		String result = "";
		
	   	String serv =  server;
	   	try 
    	{
          URL  url = new URL(serv);
          
          InputStream is = new BufferedInputStream(url.openStream(), 20480);
          
          // this is where you start, with an InputStream containing the bytes from the zip file
          ZipInputStream zis = new ZipInputStream(is);
          ZipEntry entry;
          byte[] buffer = new byte[20480];
              // while there are entries I process them
          while ((entry = zis.getNextEntry()) != null)
          {
              System.out.println("entry: " + entry.getName() + ", " + entry.getSize());
              
              ByteArrayOutputStream fos = new ByteArrayOutputStream();

              try
              {
                  int len = 0;
                  while ((len = zis.read(buffer)) > 0)
                  {
                  	fos.write(buffer, 0, len);
                  }
              }
              finally
              {	  
            	  result = new String(fos.toByteArray(), "windows-1250");
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
