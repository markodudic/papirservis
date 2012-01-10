package si.papirservis;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.HttpException;

/**
 * Servlet implementation class TimerServlet
 */
@WebServlet("/TimerServlet")
public class TimerServlet extends InitServlet implements Servlet {
	Locale locale = Locale.getDefault();
	
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TimerServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    public void init() throws ServletException
    {
          /// Automatically java script can run here
          System.out.println("************");
          System.out.println("*** Timer Initialized successfully ***..");
          System.out.println("***********");
          
          // repeat every sec. 
          int period = Integer.parseInt((String) getServletConfig().getInitParameter("period"));
          int delay = 30000;   // delay for 30 sec.
          Timer timer = new Timer();

          timer.scheduleAtFixedRate(new TimerTask() {
                  public void run() {
	                	Calendar runTime = Calendar.getInstance();
	        			System.out.println("Sledenje sinhronization at: " + runTime.toString());
	        			Vector data = getData();
	        			System.out.println("DATA="+data);	
	
	        			//posljemo na server sledenja
	        			try
	        			{
		        			if ((data != null) && (data.size() > 0))
		        			{
		        				//String url = (String) getServletContext().getInitParameter("SledenjeServerURL");
		        				String url = "http://localhost:8080/papirservis/SledenjeServer";
		        				
		        				String datum = runTime.get(Calendar.DATE)+"."+(runTime.get(Calendar.MONTH)+1)+"."+runTime.get(Calendar.YEAR);
		        				
			        			Vector result = null;
		        				for (int i=0; i<data.size(); i++) {
		        					Map res = (Map) data.get(i);
		        					result = getSledenje(url, datum, (Vector) res.get("data"));
		        					if (result == null) {
			        					System.out.println("Napaka pri povezavi na seldenje. Počakam time out.");	
		        						break;
		        					}
		        					System.out.println("RESULT="+result);	
		        					setSledenjeData(result, (String) res.get("st_dob"));
		        				}
		        			}
	        			}
	        			catch (Exception e)
	        			{
	        				e.printStackTrace();
	        				
	        			}        			
                  }
              }, delay, period);          

    }
    
    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	
	private Vector getData() {
    	Vector dataVector = new Vector();

    	ResultSet rs = null;
	    Statement stmt = null;

	    try {
	    	connectionMake();

			int dobLeto = Calendar.getInstance().get(Calendar.YEAR);
	    	
	    	String query = 	"select distinct dob.st_dob st_dob, dob.datum datum, stranke.sif_str stranke_sif_str, stranke.naziv stranke_naziv, " +
	    					" 		stranke.x_koord stranke_x_koord, stranke.y_koord stranke_y_koord, stranke.radij stranke_radij, stranke.vtez stranke_vtez, " +
	    					"		enote.x_koord enote_x_koord, enote.y_koord enote_y_koord, enote.radij enote_radij, kamion.registrska kamion " +
	    				   	"from (select *, max(dob.zacetek) from dob" + dobLeto + " as dob where DATE_FORMAT(dob.datum, '%Y-%m-%d') <= DATE_FORMAT(now(), '%Y-%m-%d') group by st_dob) dob, " + 
	    				   	"	 (select st.* from stranke st, (SELECT sif_str, max(zacetek) z  from stranke group by sif_str) s " +
	    				   	"	   where st.sif_str = s.sif_str and st.zacetek = s.z) stranke, " +
	    				   	"	enote, " +
	    					"	kupci, " +
	    					"	(SELECT kamion.* " +
	    					"			FROM kamion, (SELECT sif_kam, max(zacetek) datum FROM kamion WHERE DATE_FORMAT(zacetek, '%Y-%m-%d') <= DATE_FORMAT(now(), '%Y-%m-%d') group by sif_kam) zadnji " +
	    					"			WHERE kamion.sif_kam = zadnji.sif_kam and " +
	    					"			      kamion.zacetek = zadnji.datum) kamion " +
	    					"where  ((dob.stev_km_sled is null) OR (dob.stev_ur_sled is null)) and " +
	    					"		(dob.`sif_str` = stranke.`sif_str`) and " +
							"		(dob.`sif_kupca` = kupci.`sif_kupca`) and " +
							"		(kupci.sif_enote = enote.sif_enote) and " +
							"		(dob.sif_kam = kamion.sif_kam) and " +
							"		((dob.stev_km_sled is null) or (dob.stev_ur_sled is null)) and " +
							"		(dob.error = 0)";

	    	//System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);

	    	while (rs.next()) {
	    		String st_dob = rs.getString("st_dob");
	    		String stranke_sif_str = rs.getString("stranke_sif_str");
	    		//String stranke_naziv = rs.getString("stranke_naziv");
	    		//String stranke_x_koord = rs.getString("stranke_x_koord");
	    		//String stranke_y_koord = rs.getString("stranke_y_koord");
	    		//String stranke_radij = rs.getString("stranke_radij");
	    		//String stranke_vtez = rs.getString("stranke_vtez");
	    		String enote_x_koord = rs.getString("enote_x_koord");
	    		String enote_y_koord = rs.getString("enote_y_koord");
	    		//String enote_radij = rs.getString("enote_radij");
	    		String datum = rs.getString("datum");
	    		String kamion = rs.getString("kamion");

/*	    		if ((st_dob == null) || (stranke_x_koord == null) || (stranke_y_koord == null) ||
	    			(stranke_radij == null) || (stranke_vtez == null) || (enote_x_koord == null) || 
	    			(enote_y_koord == null) || (enote_radij == null) || (kamion == null))
	    			continue;
*/
	    		if ((enote_x_koord == null) || (enote_y_koord == null) || (datum == null) || (kamion == null))
		    			continue;

		    	Vector dataRecord = new Vector(11);
	    		//dataRecord.add(st_dob);
	    		dataRecord.add(stranke_sif_str);
	    		//dataRecord.add(stranke_naziv);
	    		//dataRecord.add(stranke_x_koord);
	    		//dataRecord.add(stranke_y_koord);
	    		//dataRecord.add(stranke_radij);
	    		//dataRecord.add(stranke_vtez);
	    		dataRecord.add(enote_x_koord);
	    		dataRecord.add(enote_y_koord);
	    		//dataRecord.add(enote_radij);    		
	    		dataRecord.add(datum);
	    		dataRecord.add(kamion);
				Map inputs = new HashMap();
				inputs.put("st_dob", st_dob);
				inputs.put("data", dataRecord);
	    		dataVector.add(inputs);
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
	private Vector getSledenje(String server, String datum, Vector data) throws FileNotFoundException, IOException, HttpException {

	   	Vector vectin = new Vector();
    	try 
    	{
          URL  url = new URL(server);
          URLConnection con = url.openConnection();

          con.setDoInput(true);
          con.setDoOutput(true);
          con.setUseCaches(false);
          con.setDefaultUseCaches(false);
          con.setRequestProperty("Content-Type", "application/java");

          ObjectOutputStream out = new ObjectOutputStream(con.getOutputStream());
          out.writeObject(datum);
          out.writeObject(data);
          out.flush();
          out.close();
    		
          ObjectInputStream in = new ObjectInputStream(con.getInputStream());
          Object o = in.readObject();
          vectin = (Vector)o;

          in.close();
    	}
    	catch(Exception e) 
    	{ 
    		System.out.println(e); 
    		return null;
    	}
    	
    	return vectin;
       
	}


	
	
	
	private void setSledenjeData(Vector result, String st_dob) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			int pot = (Integer.parseInt((String)result.get(0)))/1000;
			String cas = (String) result.get(1);
			int ura = Integer.parseInt(cas) / 3600;	
			int min = (Integer.parseInt(cas) / 60) % 60;
			if (min <= 30) cas = Integer.toString(ura);
			else cas = Integer.toString(ura) + ".5";
			
			int dobLeto = Calendar.getInstance().get(Calendar.YEAR);

			String sql = "update dob" + dobLeto + " " +
						 "set " +
						 "	stev_km_sled = " + pot + 
						 ", stev_ur_sled = " + cas +
						 " where st_dob = " + st_dob;
			//System.out.println("UPDATE SLEDENJE="+sql);
			stmt.executeUpdate(sql);
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
	
}
