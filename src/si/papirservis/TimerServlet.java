package si.papirservis;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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

import com.sledenje.ws.AuToken;
import com.sledenje.ws.SledenjeAuTokenWS;
import com.sledenje.ws.SledenjeTravelOrdersWS;
import com.sledenje.ws.TravelOrderRelation;

/**
 * Servlet implementation class TimerServlet
 */
@WebServlet("/TimerServlet")
public class TimerServlet extends InitServlet implements Servlet {
	Locale locale = Locale.getDefault();
    private SledenjeAuTokenWS sledenjeAuTokenWS = null;
    private SledenjeTravelOrdersWS sledenjeTravelOrdersWS = null;
    private String sledenje_username;
    private String sledenje_password;
    private double distance;
    
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
          
          String http_username = (String) getServletContext().getInitParameter("http_username");
          String http_password = (String) getServletContext().getInitParameter("http_password");
          sledenje_username = (String) getServletContext().getInitParameter("sledenje_username");
          sledenje_password = (String) getServletContext().getInitParameter("sledenje_password");
          distance = Double.parseDouble((String) getServletContext().getInitParameter("distance"));
			
          try {
	          sledenjeAuTokenWS = (new com.sledenje.ws.SledenjeAuTokenWSServiceLocator()).getSledenjeAuTokenWSPort();
	    	  org.apache.axis.client.Stub sledenjeAuTokenWSStub = (org.apache.axis.client.Stub)sledenjeAuTokenWS; 
	          sledenjeAuTokenWSStub.setMaintainSession(true);
	          sledenjeAuTokenWSStub.setUsername(http_username);
	          sledenjeAuTokenWSStub.setPassword(http_password);
			  
	          sledenjeTravelOrdersWS = (new com.sledenje.ws.SledenjeTravelOrdersWSServiceLocator()).getSledenjeTravelOrdersWSPort();
	    	  org.apache.axis.client.Stub sledenjeTravelOrdersWSStub = (org.apache.axis.client.Stub)sledenjeTravelOrdersWS; 
	    	  sledenjeTravelOrdersWSStub.setMaintainSession(true);
	    	  sledenjeTravelOrdersWSStub.setUsername(http_username);
	    	  sledenjeTravelOrdersWSStub.setPassword(http_password);
          } catch (Exception e) {
        	  e.printStackTrace();
          }
                    
          // repeat every sec. 
          int period = Integer.parseInt((String) getServletConfig().getInitParameter("period"));
          int delay = 10000;   // delay for 30 sec.
          Timer timer = new Timer();

          timer.scheduleAtFixedRate(new TimerTask() {
                  public void run() {
	                	Calendar runTime = Calendar.getInstance();
	        			System.out.println("**********************Sledenje sinhronization start at: " + runTime.toString());
	        			//pridobim vse dobavnice, ki so še brez podatkov o sledenju
	        			List orders = getOrderData();
	        			//pridobim vse datume in vozila, ki imajo dobavnice
	        			List ordersDates = getDateData();
	
	        			//posljemo na server sledenja
	        			try
	        			{
		        			if ((orders != null) && (orders.size() > 0))
		        			{
		        				String datum = runTime.get(Calendar.DATE)+"."+(runTime.get(Calendar.MONTH)+1)+"."+runTime.get(Calendar.YEAR);
		        				
		        				//pridobim vsa vozila iz sledenja za papir servis
		        				Map vozila = getSledenjeVozila();
	        					if ((vozila == null) || (vozila.size() == 0)) {
		        					System.out.println("Ni vozil. Počakam time out.");	
	        						return;
	        					}
		        				
			        			Vector result = null;
		        				for (int i=0; i<ordersDates.size(); i++) {
		        					//preverim ali vozilo z dobavnico obstaja v sistemu sledenja
		        					Order ordersDate = (Order) ordersDates.get(i);
		        					String ident = (String) vozila.get(ordersDate.getKamion());
		        					//če vozila ni v sistemu sledenja mu zapišem error=4
		        					if (ident == null) {
		        						System.out.println("NI VOZILA V SLEDENJU ZA="+ordersDate.getKamion()+" "+ordersDate.getDatum());
		        						setDobError(ordersDate.getSif_kam(), ordersDate.getDatum(), "4");
		        						continue;
		        					}
		        					System.out.println("******************START="+ordersDate.getKamion() + " " +  ordersDate.getZacetek()+" "+ordersDate.getKonec()+" "+ident);	
		        					
		        					//za vozilo in datum poiščem njegove postanke
		        					TravelOrderRelation[] relations = getSledenje(ordersDate.getZacetek(), ordersDate.getKonec(), ident);
		        					if (relations == null) {
			        					System.out.println("Napaka pri povezavi na seldenje. Počakam time out.");	
		        						break;
		        					}
		        					
		        					//Če ni relacij za vozilo, grem na drugo vozilo, za to vozilo pa vpišem error = 2
		        					if (relations.length == 0) {
		        						System.out.println("NI RELACIJ ZA="+ordersDate.getKamion()+" "+ordersDate.getDatum());
		        						setDobError(ordersDate.getSif_kam(), ordersDate.getDatum(), "2");
		        						continue;
		        					}
		        					
		        					//poiščem vse dobavnice in podatke, ki so bile izvedene za ta kamion na ta dan
		        					List ordersForDateVehicle = new ArrayList();
		        					for (int j=0; j<orders.size(); j++) {
			        					Order order = (Order) orders.get(j);
			        					if ((order.getZacetek().equals(ordersDate.getZacetek())) && (order.getSif_kam().equals(ordersDate.getSif_kam()))) {
			        						System.out.println("ORDER="+order.getStDob());
			        						ordersForDateVehicle.add(order);
          								}	        					
		        					}
		        					
		        					//Če ni orderjev za kamion v določenem dnevu, grem na drugo vozilo, vse take dobavnice označim z error = 3
		        					if (ordersForDateVehicle.size() == 0) {
		        						//System.out.println("NI ORDERJEV ZA="+ordersDate.getSif_kam()+ordersDate.getKamion()+" "+ordersDate.getDatum());
		        						//setDobError(ordersDate.getSif_kam(), ordersDate.getDatum(), "3");
		        						continue;
		        					}
		        					
		        					
		        					boolean start_find = false;
		        					int meters = 0;
		        					List orders_relations = new ArrayList();
		        					List orders_with_data = new ArrayList(); 
		        					//primerjam podatke o lokacijah iz dobavnice in izhodišča s podatki iz sledenja
		        					for (int ii=0; ii<relations.length; ii++) {
		        						TravelOrderRelation relation = relations[ii];
		        						System.out.println("relation="+relation.getAvg_sdo_x() + " " + relation.getAvg_sdo_y() + " " + relation.getTime_from() + " " + relation.getTime_to() + " " + relation.getDist_km());
	        							meters = meters + relation.getDist_km();
		        						
		        						//poiščem ujemanje točk
		        						for (int j=0; j<ordersForDateVehicle.size(); j++) {
		        							Order order = (Order) ordersForDateVehicle.get(j);
		        							//razdalja do tocke
				        					Double dist_x = Math.abs(relation.getAvg_sdo_x() - Double.parseDouble(order.getStranke_x_koord()));
				        					Double dist_y = Math.abs(relation.getAvg_sdo_y() - Double.parseDouble(order.getStranke_y_koord()));
				        							
		        							if ((dist_x < distance) && (dist_y < distance) && start_find) {
					        					//kamion je pri stranki
		        								System.out.println("STRANKA="+dist_x+" "+dist_y);
		        								Order order_relation = new Order();
		        								order_relation.setStDob(order.getStDob());
		        								order_relation.setZacetek(relation.getTime_from());
		        								order_relation.setMeters(meters);
		        								orders_relations.add(order_relation);
		        								start_find = false;
		        								meters = 0;
		        								break;
		        							}

		        							//razdalja do enote izhodisca
				        					Double dist_x_enota = Math.abs(relation.getAvg_sdo_x() - Double.parseDouble(order.getEnote_x_koord()));
				        					Double dist_y_enota = Math.abs(relation.getAvg_sdo_y() - Double.parseDouble(order.getEnote_y_koord()));
				        							
		        							if ((dist_x_enota < distance) && (dist_y_enota < distance) && !start_find) {
		        								//kamion je na izhodiscu
					        					System.out.println("IZHODISCE="+dist_x_enota+" "+dist_y_enota);
		        								Order order_relation = new Order();
		        								order_relation.setStDob("-1");
		        								order_relation.setZacetek(relation.getTime_from());
		        								order_relation.setMeters(meters);
		        								orders_relations.add(order_relation);
		        								start_find = true;
		        								meters = 0;
		        								break;
		        							}
		        							
		        						}
			        					//setSledenjeData(result, (String) res.get("st_dob"));*/
		        					}
		        					
		        					//zracunam podatke o casu in metrih po dobavnici. za dobavnice, ki nimajo podatkov dam error 1
		        					for (int l=0; l<orders_relations.size(); l=l+2) {
        								if (l+2>=orders_relations.size()) {
        									break;
        								}
        								Order start = (Order) orders_relations.get(l);
        								Order stranka = (Order) orders_relations.get(l+1);
        								Order cilj = (Order) orders_relations.get(l+2);
        								
        								String st_dob = stranka.getStDob();
        								int met = stranka.getMeters() + cilj.getMeters();
        								String date_end = cilj.getZacetek();
        								String date_start = start.getZacetek();
        								orders_with_data.add(st_dob);
        								
        								System.out.println("final="+st_dob + " " + met + " " + date_start +" "+date_end);
        								setSledenjeData(st_dob, met, date_start, date_end);
		        						
	        						}
		 
		        					//za dobavnice, ki nimajo podatkov (niso v orders_relations) dam error 1
			        				for (int m=0; m<ordersForDateVehicle.size(); m++) {
			        					Order order = (Order) ordersForDateVehicle.get(m);
			        					if (!orders_with_data.contains(order.getStDob())) {
			        						setDobError(order.getStDob(), order.getDatum());
			        					}
			        				}
		        				}
		        				
		        			}
	        			}
	        			catch (Exception e)
	        			{
	        				e.printStackTrace();
	        				
	        			}  
	        			
	                	runTime = Calendar.getInstance();
	        			System.out.println("**********************Sledenje sinhronization end at: " + runTime.toString());
	        			
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

	
	private List getOrderData() {
    	ResultSet rs = null;
	    Statement stmt = null;
	    List orders = new ArrayList();

	    try {
	    	connectionMake();

			int dobLeto = Calendar.getInstance().get(Calendar.YEAR);
	    	
	    	String query = 	"select distinct dob.st_dob st_dob, dob.datum datum, stranke.sif_str stranke_sif_str, stranke.naziv stranke_naziv, " +
	    					" 		stranke.x_koord stranke_x_koord, stranke.y_koord stranke_y_koord, stranke.radij stranke_radij, stranke.vtez stranke_vtez, " +
	    					"		enote.x_koord enote_x_koord, enote.y_koord enote_y_koord, enote.radij enote_radij, kamion.sif_kam sif_kam, kamion.registrska kamion, " +
	    					"		DATE_FORMAT(dob.datum, '%d.%m.%Y 00:00:00') zacetek " +
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
							"		(dob.error = 0) and " +
							"		(dob.datum < now()-1)";

	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	int i = 0;

	    	while (rs.next()) {
	    		String st_dob = rs.getString("st_dob");
	    		String stranke_sif_str = rs.getString("stranke_sif_str");
	    		String stranke_x_koord = rs.getString("stranke_x_koord");
	    		String stranke_y_koord = rs.getString("stranke_y_koord");
	    		String enote_x_koord = rs.getString("enote_x_koord");
	    		String enote_y_koord = rs.getString("enote_y_koord");
	    		String datum = rs.getString("datum");
	    		String kamion = rs.getString("kamion");
	    		String zacetek = rs.getString("zacetek");
	    		String sif_kam = rs.getString("sif_kam");

	    		if ((stranke_x_koord == null) || (stranke_y_koord == null) || (enote_x_koord == null) || (enote_y_koord == null) || (datum == null) || (kamion == null))
		    			continue;

		    	Order order = new Order();
		    	order.setStDob(st_dob);
		    	order.setStranke_sif_str(stranke_sif_str);
		    	order.setStranke_x_koord(stranke_x_koord);
		    	order.setStranke_y_koord(stranke_y_koord);
		    	order.setEnote_x_koord(enote_x_koord);
		    	order.setEnote_y_koord(enote_y_koord);
		    	order.setDatum(datum);
		    	order.setKamion(kamion);
		    	order.setZacetek(zacetek);
		    	order.setSif_kam(sif_kam);
		    	
		    	orders.add(order);
		    	i++;
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
		
		
		return orders;
	}
	

	private List getDateData() {
    	ResultSet rs = null;
	    Statement stmt = null;
	    List orders = new ArrayList();

	    try {
	    	connectionMake();

			int dobLeto = Calendar.getInstance().get(Calendar.YEAR);
	    	
	    	String query = 	"select DISTINCT dob.datum datum, DATE_FORMAT(dob.datum, '%d.%m.%Y 00:00:00') zacetek, DATE_FORMAT(dob.datum, '%d.%m.%Y 23:59:59') konec, kamion.sif_kam sif_kam, kamion.registrska kamion " +
	    				   	"from (select *, max(dob.zacetek) from dob" + dobLeto + " as dob where DATE_FORMAT(dob.datum, '%Y-%m-%d') <= DATE_FORMAT(now(), '%Y-%m-%d') group by st_dob) dob, " + 
	    				   	"	(SELECT kamion.* " +
	    					"			FROM kamion, (SELECT sif_kam, max(zacetek) datum FROM kamion WHERE DATE_FORMAT(zacetek, '%Y-%m-%d') <= DATE_FORMAT(now(), '%Y-%m-%d') group by sif_kam) zadnji " +
	    					"			WHERE kamion.sif_kam = zadnji.sif_kam and " +
	    					"			      kamion.zacetek = zadnji.datum) kamion " +
	    					"where  ((dob.stev_km_sled is null) OR (dob.stev_ur_sled is null)) and " +
	    					"		(dob.sif_kam = kamion.sif_kam) and " +
							"		((dob.stev_km_sled is null) or (dob.stev_ur_sled is null)) and " +
							"		(dob.error = 0) and " +
							"		(dob.datum < now()-1)";

	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	int i = 0;

	    	while (rs.next()) {
	    		String datum = rs.getString("datum");
	    		String zacetek = rs.getString("zacetek");
	    		String konec = rs.getString("konec");
	    		String kamion = rs.getString("kamion");
	    		String sif_kam = rs.getString("sif_kam");

	    		if ((zacetek == null) || (konec == null) || (kamion == null))
		    			continue;

		    	Order order = new Order();
		    	order.setDatum(datum);
		    	order.setZacetek(zacetek);
		    	order.setKonec(konec);
		    	order.setKamion(kamion);
		    	order.setSif_kam(sif_kam);
		    	
		    	orders.add(order);
		    	i++;
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
		
		
		return orders;
	}

	
	private Map getSledenjeVozila() throws IOException {

	   	Map vozila = new HashMap();
    	try 
    	{
          //WS
    	  Integer login = (Integer) sledenjeAuTokenWS.login(sledenje_username,sledenje_password);
    	  AuToken[] tokens = sledenjeAuTokenWS.getAuTokens(null, null, null);
    	  for (int i=0; i<tokens.length; i++) {
    		  AuToken token = tokens[i];
    		  //System.out.println(token.getVozilo_sifra()+" "+token.getIdent_naprave());
    		  vozila.put(token.getVozilo_sifra(), token.getIdent_naprave());
    	  }
    	  sledenjeAuTokenWS.logout();

    	}
    	catch(Exception e) 
    	{ 
    		System.out.println(e); 
    		e.printStackTrace();
    		return null;
    	}
    	
    	return vozila;
       
	}

	/**
	 * @param url
	 * @param params
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws HttpException
	 */
	private TravelOrderRelation[] getSledenje(String zacetek, String konec, String ident) throws FileNotFoundException, IOException, HttpException {

		TravelOrderRelation[] relations = null;
    	try 
    	{
          //WS
    	  Integer login = (Integer) sledenjeTravelOrdersWS.login("papirservis","papirvozila");
    	  relations = sledenjeTravelOrdersWS.getTravelOrderStopsIdent(zacetek, konec, ident, null, null, null, null, null);
    	  sledenjeTravelOrdersWS.logout();
    	}
    	catch(Exception e) 
    	{ 
    		System.out.println(e); 
    		e.printStackTrace();
    		return null;
    	}
    	
    	return relations;
       
	}


	private void setDobError(String sif_kam, String datum, String error) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			String sql = "update dob" + datum.substring(0, 4) + " " +
						 "set error = " + error +
						 " where sif_kam = " + sif_kam + " and " +
						 "		datum = '" + datum + "'";
			System.out.println("setDobError="+sql);
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

	
	
	private void setSledenjeData(String st_dob, int meters, String zacetek, String konec) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			int pot = meters/1000;
			
			String myFormatString = "dd.MM.yyyy kk:mm:ss";
			SimpleDateFormat df = new SimpleDateFormat(myFormatString);
			Date date1 = df.parse(zacetek);
			Date date2 = df.parse(konec);
			long cas = (date2.getTime() - date1.getTime()) / 1000;
			long ura = cas / 3600;	
			long min = (cas / 60) % 60;
			String ur;
			if (min <= 30) ur = ura + "";
			else ur = ura + ".5";

			SimpleDateFormat simpleDateformat=new SimpleDateFormat("yyyy");
			
			
			String sql = "update dob" +  simpleDateformat.format(date1) + " " +
						 "set " +
						 "	stev_km_sled = " + pot + 
						 ", stev_ur_sled = " + ur +
						 " where st_dob = " + st_dob;
			System.out.println("UPDATE SLEDENJE="+sql);
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
	
	private void setDobError(String st_dob, String datum) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			String sql = "update dob" + datum.substring(0, 4) + " " +
						 "set error = 1 " +
						 " where st_dob = " + st_dob;
			System.out.println("setDobError="+sql);
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
