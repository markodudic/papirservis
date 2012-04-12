package si.papirservis;

import it.sauronsoftware.cron4j.Scheduler;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
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
    private double distanceLocation;
    private double distanceCustomer;
    private String query_limit;
    private String scheduler_pattern;
	
	private static final int ERROR_NO_STOPS_IN_SLEDENJE = 1;
	private static final int ERROR_NO_DATA_IN_SLEDENJE = 2;
	private static final int ERROR_NO_FINISH_LOCATION_IN_SLEDENJE = 3;
	private static final int ERROR_VEHICLE_NOT_IN_SLEDENJE = 4;
	private static final int ERROR_OTHER_POSITION = 5;
	private static final int ERROR_HISTORY_POSITION = 6;
	private static final int ERROR_DATA_LASTNE_POTREBE = 8;
	private static final int ERROR_DATA_OK = 9;
	private static final String PREVOZ_ZA_LASTNE_POTREBE = "PREVOZ ZA LASTNE POTREBE";

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
          
          query_limit = (String) getServletConfig().getInitParameter("query_limit");
          scheduler_pattern = (String) getServletConfig().getInitParameter("scheduler_pattern");
          
          String http_username = (String) getServletContext().getInitParameter("http_username");
          String http_password = (String) getServletContext().getInitParameter("http_password");
          sledenje_username = (String) getServletContext().getInitParameter("sledenje_username");
          sledenje_password = (String) getServletContext().getInitParameter("sledenje_password");
          distanceCustomer = Double.parseDouble((String) getServletContext().getInitParameter("distance_customer"));
          distanceLocation = Double.parseDouble((String) getServletContext().getInitParameter("distance_location"));
			
          
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
          
          Scheduler s = new Scheduler();
	  	  // Schedule a once-a-minute task.
	  	  s.schedule(scheduler_pattern, new Runnable() {
	  		  public void run() {
	  			scheduleRun();
	  	  	}
	  	  });
	  	  // Starts the scheduler.
	  	  s.start();
  		
          // timer 
          /*int period = Integer.parseInt((String) getServletConfig().getInitParameter("period"));
          int delay = 10000000;   // delay for 30 sec.
          Timer timer = new Timer();
          timer.scheduleAtFixedRate(new TimerTask() {
                  public void run() {
                	  scheduleRun();
                  }}, delay, period);    
                  */      
    }
    
    
    public void scheduleRun() {
    	Calendar runTime = Calendar.getInstance();
	    SimpleDateFormat df = new SimpleDateFormat("dd.MM.yyyy kk:mm:ss");
	    SimpleDateFormat dfTime = new SimpleDateFormat("kk:mm:ss");
		SimpleDateFormat dfYear=new SimpleDateFormat("yyyy");
		System.out.println("**********************Sledenje sinhronization start at: " + df.format(runTime.getTime()));
		try
		{
			//pridobim vsa vozila iz sledenja za papir servis
			Map vozila = getSledenjeVozila();
			if ((vozila == null) || (vozila.size() == 0)) {
				System.out.println("Ni vozil. Počakam time out.");	
				return;
			}
			//vsa vozila, ki niso v sledenjeu oznacim z error ERROR_VEHICLE_NOT_IN_SLEDENJE
			String vozilaSledenje = "";
			Iterator it = vozila.keySet().iterator();
			while (it.hasNext()) {
				String vozilo = (String)it.next();
				vozilaSledenje += "'" + vozilo + "%'";
				if (it.hasNext())
					vozilaSledenje += ",";
			}
			if (vozila.size()>0) {
				//setVozilaNiVSledenju(vozilaSledenje, runTime.get(Calendar.YEAR), ERROR_VEHICLE_NOT_IN_SLEDENJE);
			}
			
		    
			//pridobim vse datume in vozila, ki imajo dobavnice
			List ordersDates = getDateData();
			if (ordersDates.size() == 0) return;
			//za vsa takšna vozila in datume resetiram podatke
			resetSledenjeData(ordersDates, runTime.get(Calendar.YEAR));
			//pridobim vse dobavnice, ki so še brez podatkov o sledenju
			String kamioniDatumi = "";
			for (int i=0; i<ordersDates.size(); i++) {
				Order ordersDate = (Order) ordersDates.get(i);
				String kamion = ordersDate.getSif_kam();
				String datumDob = ordersDate.getDatum();
				kamioniDatumi += "(" + kamion + ",'" + datumDob + "')";
				if (i<(ordersDates.size()-1))
					kamioniDatumi += ",";
			}
			List ordersAll = getOrderData(kamioniDatumi);
			//vse pozicije, ki niso 1, jim dam error=8
			setOrdersOtherPositions(runTime.get(Calendar.YEAR), ERROR_OTHER_POSITION);

			System.out.println("SIZE="+ordersAll.size()+"-"+ordersDates.size());	           
			if ((ordersAll != null) && (ordersAll.size() > 0))
			{
    			Vector result = null;
				for (int i=0; i<ordersDates.size(); i++) {
					//preverim ali vozilo z dobavnico obstaja v sistemu sledenja
					Order ordersDate = (Order) ordersDates.get(i);
					String ident = (String) vozila.get(ordersDate.getKamion());
					//če vozila ni v sistemu sledenja mu zapišem ERROR_VEHICLE_NOT_IN_SLEDENJE
					if (ident == null) {
						System.out.println("NI VOZILA V SLEDENJU ZA="+ordersDate.getKamion()+" "+ordersDate.getDatum());
						setDobError(ordersDate.getSif_kam(), ordersDate.getDatum().substring(0, 4), null, ERROR_VEHICLE_NOT_IN_SLEDENJE);
						continue;
					}
					System.out.println("******************START="+ordersDate.getKamion() + " " +  ordersDate.getZacetek()+" "+ordersDate.getKonec()+" "+ident);	
					
					//za vozilo in datum poiščem njegove postanke
					TravelOrderRelation[] relations = getSledenje(ordersDate.getZacetek(), ordersDate.getKonec(), ident);
					if (relations == null) {
    					System.out.println("Napaka pri povezavi na seldenje. Počakam time out.");	
						break;
					}
					
					//Če ni relacij za vozilo za izbrani dan, grem na drugo vozilo, za to vozilo pa vpišem error ERROR_NO_DATA_IN_SLEDENJE
					if (relations.length == 0) {
						System.out.println("NI RELACIJ ZA="+ordersDate.getKamion()+" "+ordersDate.getDatum());
						setDobError(ordersDate.getSif_kam(), ordersDate.getDatum().substring(0, 4), ordersDate.getDatum(), ERROR_NO_DATA_IN_SLEDENJE);
						continue;
					}
					
					//poiščem vse dobavnice in podatke, ki so bile izvedene za ta kamion na ta dan
					List ordersForDateVehicle = new ArrayList();
					for (int j=0; j<ordersAll.size(); j++) {
    					Order order = (Order) ordersAll.get(j);
    					if ((order.getZacetek().equals(ordersDate.getZacetek())) && (order.getSif_kam().equals(ordersDate.getSif_kam()))) {
    						System.out.println("ORDER="+order.getStDob());
    						ordersForDateVehicle.add(order);
						}	        					
					}
					
					//Če ni orderjev za kamion v določenem dnevu, grem na drugo vozilo, vse take dobavnice označim z error = 3
					if (ordersForDateVehicle.size() == 0) {
						System.out.println("NI ORDERJEV ZA="+ordersDate.getSif_kam()+ordersDate.getKamion()+" "+ordersDate.getDatum());
						//setDobError(ordersDate.getSif_kam(), ordersDate.getDatum(), "3");
						continue;
					}
					
					
					boolean start_find = true;
					int meters = 0;
					//long time = 0;
					int km_norm_sum = 0;
					double ur_norm_sum = 0d;
					boolean useNormValues = true;
					int metersLastnePotrebe = 0;
					long casLastnePotrebe = 0L;
					Date time_from = new Date();
					Date time_to = new Date();
					List orders_with_data = new ArrayList(); 
					List finalOrders = new ArrayList();
					List orders_relations = new ArrayList();
					
					//primerjam podatke o lokacijah iz dobavnice in izhodišča s podatki iz sledenja
					for (int ii=0; ii<relations.length; ii++) {
						TravelOrderRelation relation = relations[ii];
						System.out.println("relation="+relation.getAvg_sdo_x() + " " + relation.getAvg_sdo_y() + " " + relation.getTime_from() + " " + relation.getTime_to() + " " + relation.getDist_km() + " " + relation.getTime_diff());
						meters += relation.getDist_km();
						
						//poiscem ujemanje tock
						for (int j=0; j<ordersForDateVehicle.size(); j++) {
							Order order = (Order) ordersForDateVehicle.get(j);
							
							//razdalja do enote izhodisca
        					Double dist_x_enota = Math.abs(relation.getAvg_sdo_x() - Double.parseDouble(order.getEnote_x_koord()));
        					Double dist_y_enota = Math.abs(relation.getAvg_sdo_y() - Double.parseDouble(order.getEnote_y_koord()));
        					
        					if ((dist_x_enota < distanceLocation) && (dist_y_enota < distanceLocation)) {
								//kamion je na izhodiscu
	        					System.out.println("IZHODISCE="+"-"+meters);
	        					
    							time_from = df.parse(relation.getTime_from().trim());
    							
    							//ce je naslednji postanek tudi na izhodiscu vzamem tega, metre in cas pa prisetjem v PREVOZ ZA LASTNE POTREBE
								if (start_find) {
									//vozilo je se na izhodiscu
									metersLastnePotrebe += meters;
									//zracun razliko casa v sekundah
									if (ii>0) {
										casLastnePotrebe += (time_from.getTime() - time_to.getTime()) / 1000;
										if (casLastnePotrebe < 0) casLastnePotrebe = 0;
									}
								} else {
									//vozilo je prislo nazaj na izhodisce, obdelam krozno voznji
									long cas = (time_from.getTime() - time_to.getTime()) / 1000;
									Map finalOrder = new HashMap();
    								finalOrder.put("dob", orders_relations);
									finalOrder.put("km", meters);
									finalOrder.put("km_norm_sum", km_norm_sum);
									finalOrder.put("sec", cas);
									finalOrder.put("ur_norm_sum", ur_norm_sum);
									finalOrder.put("driver_key", relation.getDriver_key());
									//ce je cas manjsi od 0, vozilo ni imelo izhodisca na startu
									if (cas >= 0)
										finalOrder.put("tip", 0);
									else 
										finalOrder.put("tip", -1);
									finalOrders.add(finalOrder);
									
									orders_relations = new ArrayList();
								}
								
    							time_to = df.parse(relation.getTime_to().trim());
								start_find = true;
								meters=0;
								//time = 0L;
								km_norm_sum = 0;
								ur_norm_sum = 0D;
								useNormValues = true;
								break;
							}		        							
							
							
							//ce je order ze najden in ce se ne isce izhodisce preskocim
							if (order.isChecked()) continue;
							
							//razdalja do tocke
        					Double dist_x = Math.abs(relation.getAvg_sdo_x() - Double.parseDouble(order.getStranke_x_koord()));
        					Double dist_y = Math.abs(relation.getAvg_sdo_y() - Double.parseDouble(order.getStranke_y_koord()));
        							
							if ((dist_x < distanceCustomer) && (dist_y < distanceCustomer)) {
			        			//kamion je pri stranki
								System.out.println("STRANKA="+order.getStDob()+"-"+relation.getTime_from()+"-"+meters+"-"+relation.getDriver_key());
								start_find = false;
								order.setChecked(true);
								ordersForDateVehicle.set(j, order);
								orders_with_data.add(order.getStDob());
								
								
								//dodam dobavnico
								orders_relations.add(order);
								//dolocim skupne normativne vrednosti. ce ena od vrednosti manjka ne uporabljam normativne vrednosti
								if (useNormValues) {
    								if (order.getStev_km_norm() != 0 && order.getStev_ur_norm() != 0) {
    									km_norm_sum += order.getStev_km_norm();
    									ur_norm_sum += order.getStev_ur_norm();
    								} else {
    									km_norm_sum = 0;
    									ur_norm_sum = 0;
    									useNormValues = false;
    								}
								}
							}
							
						}
					}
					
					
					//če zadnja relacija ni bila izhodiše ima pa orderje, jih označim kot tiste ki se niso vrnili na izhodišče
					if ((orders_relations.size()>0) && (!start_find)) {
						Map finalOrder = new HashMap();
						finalOrder.put("dob", orders_relations);
						finalOrder.put("km", 0);
						finalOrder.put("km_norm_sum", 0);
						finalOrder.put("sec", 0L);
						finalOrder.put("ur_norm_sum", 0D);
						finalOrder.put("driver_key", "0");
						finalOrder.put("tip", -1);
						finalOrders.add(finalOrder);
					}
					
					for (int l=0; l<finalOrders.size(); l++) {
						Map finalOrder = (Map) finalOrders.get(l);
						System.out.println("ORDER="+((List)finalOrder.get("dob")).size()+"-"+finalOrder.get("km")+"-"+finalOrder.get("km_norm_sum")+"-"+finalOrder.get("sec")+"-"+finalOrder.get("ur_norm_sum")+"-"+finalOrder.get("tip")+"-"+finalOrder.get("driver_key"));
						
						if ((Integer)finalOrder.get("tip") == -1) {
							//tisti ki nimajo izhodisca na koncu, nastavim error
							List orders = (List)finalOrder.get("dob");
							for (int f=0; f<orders.size(); f++) {
								Order order = (Order)orders.get(f);
								setDobOkError(order.getStDob(), dfYear.format(df.parse(order.getZacetek())), ERROR_NO_FINISH_LOCATION_IN_SLEDENJE);
							}
						} else {
							List orders = (List)finalOrder.get("dob");
							String sofer = (String)finalOrder.get("driver_key");
							int km = (Integer)finalOrder.get("km");
							int sum_km_norm = (Integer)finalOrder.get("km_norm_sum");
							long sec = (Long)finalOrder.get("sec");
							double sum_ur_norm = (Double)finalOrder.get("ur_norm_sum");
							
							for (int f=0; f<orders.size(); f++) {
								Order order = (Order)orders.get(f);
								int km_norm = km / orders.size();
								if (sum_km_norm > 0)
									km_norm = km * order.getStev_km_norm() / sum_km_norm;
									
								long sec_norm = Math.round(sec / orders.size());
								if (sum_ur_norm > 0)
									sec_norm = Math.round(sec * order.getStev_ur_norm() / sum_ur_norm);
								
								System.out.println("final="+order.getStDob() + " " + km + " " + km_norm + " " + sec + " " + sec_norm);
								setSledenjeData(order.getStDob(), km_norm, sec_norm, sofer, dfYear.format(df.parse(order.getZacetek())));
							
							}
							
						}
					}
					
					//za dobavnice, ki nimajo podatkov (niso v orders_relations) dam error ERROR_NO_STOPS_IN_SLEDENJE
    				for (int m=0; m<ordersForDateVehicle.size(); m++) {
    					Order order = (Order) ordersForDateVehicle.get(m);
    					if (!orders_with_data.contains(order.getStDob())) {
    						setDobOkError(order.getStDob(), order.getDatum(), ERROR_NO_STOPS_IN_SLEDENJE);
    					}
    				}

					//nastavim podatke za PREVOZ ZA LASTNE POTREBE
					setPrevozLastnePotrebe(ordersDate.getSif_kam(), ordersDate.getDatum(), metersLastnePotrebe, casLastnePotrebe);

				}
				
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
			
		}  
		
    	runTime = Calendar.getInstance();
		System.out.println("**********************Sledenje sinhronization end at: " + df.format(runTime.getTime()));
	        			
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

	public int getSecondsSinceMidnight(Date date) {         
	    DateFormat dateFormat = new SimpleDateFormat();      
	    
	    dateFormat = new SimpleDateFormat("HH");
	    int hour = Integer.parseInt(dateFormat.format(date));         

	    dateFormat = new SimpleDateFormat("mm");
	    int minute = Integer.parseInt(dateFormat.format(date));

	    dateFormat = new SimpleDateFormat("ss");
	    int second = Integer.parseInt(dateFormat.format(date));   

	    return (hour* 3600) + (minute * 60) + second;      
	 }
	
	private void resetSledenjeData(List ordersDates, int datum) {
	    	ResultSet rs = null;
	    	Statement stmt = null;
	    	Statement stmt1 = null;

		    try {
		    	connectionMake();
				stmt = con.createStatement();   	

				for (int i=0; i<ordersDates.size(); i++) {
					Order ordersDate = (Order) ordersDates.get(i);
					String kamion = ordersDate.getSif_kam();
					String datumDob = ordersDate.getDatum();

					String sql = "select max(zacetek) zacetek, st_dob, pozicija " +
							"from dob" + datum + " " +
							"where pozicija = 1 and " +
							"		sif_kam = " + kamion + " and " +
							"		datum = '" + datumDob + "' " +
							"group by st_dob, pozicija";
			
			    	rs = stmt.executeQuery(sql);
			
			    	stmt1 = con.createStatement();   	
			    	while (rs.next()) {
			    			sql = "update dob" + datum + " " +
								"set stev_km_sled=null, stev_ur_sled=null, error = 0 " +
								" where st_dob = " + rs.getString("st_dob") + " and " +
								"		pozicija = 1 and " +
								"		zacetek = '" + rs.getString("zacetek") + "'";
				
			    			System.out.println("resetData="+sql);
			    			stmt1.executeUpdate(sql);
			    	}
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
		    		if (stmt1 != null) {
		    			stmt1.close();
		    		}
				} catch (Exception e) {
				}
		    }
	}					
					
	private List getOrderData(String kamioniDatumi) {
    	ResultSet rs = null;
	    Statement stmt = null;
	    List orders = new ArrayList();

	    try {
	    	connectionMake();

			int dobLeto = Calendar.getInstance().get(Calendar.YEAR);
	    	
	    	String query = 	"SELECT distinct dob.st_dob st_dob, dob.datum datum, dob.stev_km_norm stev_km_norm, dob.stev_ur_norm stev_ur_norm, " +
	    					"		stranke.sif_str stranke_sif_str, stranke.naziv stranke_naziv, " +
	    					" 		stranke.x_koord stranke_x_koord, stranke.y_koord stranke_y_koord, " +
	    					"		enote.x_koord enote_x_koord, enote.y_koord enote_y_koord, " +
	    					"		kamion.sif_kam sif_kam, kamion.registrska kamion, " +
	    					"		DATE_FORMAT(dob.datum, '%d.%m.%Y 00:00:00') zacetek " +
	    					"FROM " +
	    				   	"	(SELECT db.st_dob, db.datum, db.stev_km_norm, db.stev_ur_norm, db.error, db.sif_str, db.sif_kupca, db.sif_kam " +
	    				   	"	 FROM dob" + dobLeto + " as db , (SELECT st_dob, max(dob.zacetek) z " +
	    				   	"	 				   				  FROM dob" + dobLeto + " as dob " +
	    				   	"	 				   				  WHERE datum < NOW()-1 AND " +
	    				   	"											pozicija = 1 and" +
	    				   	"											sif_kam is not null and " +
	    				   	"											((dob.stev_km_sled is null) OR (dob.stev_ur_sled is null))" +
	    				   	"									  GROUP BY st_dob) d " + 
	    				   	"	 WHERE db.st_dob = d.st_dob and db.zacetek = d.z and db.error = 0) dob " +
	    				   	"RIGHT JOIN " +
	    				   	"	(SELECT st.sif_str, st.naziv, st.x_koord, st.y_koord " +
	    				   	"	 FROM stranke st, (SELECT sif_str, max(zacetek) z  " +
	    				   	"					   FROM stranke " +
	    				   	"					   WHERE stranke.x_koord IS NOT NULL AND " +
	    				   	"		   					stranke.y_koord IS NOT NULL " +
	    				   	"					   GROUP BY sif_str) s " +
	    				   	"	 WHERE st.sif_str = s.sif_str and st.zacetek = s.z) stranke " +
	    				   	"ON  (dob.sif_str = stranke.sif_str) " +
	    				   	"LEFT JOIN " +
	    				   	"	(SELECT kamion.sif_kam, kamion.registrska " +
	    					"	 FROM kamion, (SELECT sif_kam, max(zacetek) z " +
	    					"				   FROM kamion " +
	    					"				   GROUP BY sif_kam) zadnji " +
	    					"	 WHERE kamion.sif_kam = zadnji.sif_kam and " +
	    					"	       kamion.zacetek = zadnji.z) kamion " +
	    					"ON  (dob.sif_kam = kamion.sif_kam) " +
	    					"LEFT JOIN	 kupci ON (dob.sif_kupca = kupci.sif_kupca) " +
	    					"LEFT JOIN 	 enote ON (kupci.sif_enote = enote.sif_enote) " + 
	    					"WHERE  (dob.sif_kam, dob.datum) in (" + kamioniDatumi + ")";

	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	
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
		    	order.setStev_km_norm(rs.getInt("stev_km_norm"));
		    	order.setStev_ur_norm(rs.getDouble("stev_ur_norm"));
		    	
		    	orders.add(order);
	    	}
	    	
	    	
	    } catch (Exception theException) {
	    	System.out.println("ERROR="+theException.getMessage());	  
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
	    	
	    	String query = 	"SELECT DISTINCT dob.datum datum, " +
	    					"		DATE_FORMAT(dob.datum, '%d.%m.%Y 00:00:00') zacetek, " +
	    					"		DATE_FORMAT(dob.datum, '%d.%m.%Y 23:59:59') konec, " +
	    					"		kamion.sif_kam sif_kam, " +
	    					"		kamion.registrska kamion " +
	    				   	"FROM " +
	    				   	"	(SELECT db.datum, db.error, db.sif_kam, db.sif_str " +
	    				   	"	 FROM dob" + dobLeto + " as db , (SELECT st_dob, max(dob.zacetek) z " +
	    				   	"	 				   				  FROM dob" + dobLeto + " as dob " +
	    				   	"	 				   				  WHERE datum < NOW()-1 AND " +
	    				   	"											pozicija = 1 and" +
	    				   	"											sif_kam is not null and " +
	    				   	"											((dob.stev_km_sled is null) OR (dob.stev_ur_sled is null))" +
	    				   	"									  GROUP BY st_dob) d " + 
	    				   	"	 WHERE db.st_dob = d.st_dob and db.zacetek = d.z and db.error = 0) dob " +
	    				   	"RIGHT JOIN " +
	    				   	"	(SELECT st.sif_str, st.naziv, st.x_koord, st.y_koord " +
	    				   	"	 FROM stranke st, (SELECT sif_str, max(zacetek) z  " +
	    				   	"					   FROM stranke " +
	    				   	"					   WHERE stranke.x_koord IS NOT NULL AND " +
	    				   	"		   					stranke.y_koord IS NOT NULL " +
	    				   	"					   GROUP BY sif_str) s " +
	    				   	"	 WHERE st.sif_str = s.sif_str and st.zacetek = s.z) stranke " +
	    				   	"ON  (dob.sif_str = stranke.sif_str) " +
	    				   	"LEFT JOIN " +
	    				   	"	(SELECT kamion.sif_kam, kamion.registrska " +
	    					"	 FROM kamion, (SELECT sif_kam, max(zacetek) z " +
	    					"				   FROM kamion " +
	    					"				   GROUP BY sif_kam) zadnji " +
	    					"	 WHERE kamion.sif_kam = zadnji.sif_kam and " +
	    					"	       kamion.zacetek = zadnji.z) kamion " +
	    					"ON  (dob.sif_kam = kamion.sif_kam) " +
							"LIMIT " + query_limit;

	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);

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

	
	private void setOrdersOtherPositions(int datum, int error) {

    	ResultSet rs = null;
    	Statement stmt = null;
    	Statement stmt1 = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			String sql = "select max(zacetek) zacetek, st_dob, pozicija " +
						"from dob" + datum + ", (select st_dob st from dob" + datum + " where pozicija > 1 and error = 0) as d " + 
						"where pozicija > 1 and " +
						"		st_dob in (d.st) " +
						"group by st_dob, pozicija ";
			
	    	rs = stmt.executeQuery(sql);

	    	stmt1 = con.createStatement();   	
	    	while (rs.next()) {
	    		sql = "update dob" + datum + " " +
	    				"set error = " + error +
	    				" where st_dob = " + rs.getString("st_dob") +
	    				"	and pozicija = " + rs.getString("pozicija") +
	    				"	and zacetek = '" + rs.getString("zacetek") + "'";
			
	    		System.out.println("setOrdersOtherPositions="+sql);
	    		stmt1.executeUpdate(sql);
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
	    		if (stmt1 != null) {
	    			stmt1.close();
	    		}
			} catch (Exception e) {
			}
	    }
		
		
		return;
	}
	
	
	private void setSledenjeData(String st_dob, int meters, long cas, String sofer, String year) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			double metersD = meters;
			long pot = Math.round(metersD/1000);
			
			long ura = cas / 3600;	
			long min = (cas / 60) % 60;
			String ur;
			//if (min <= 15) ur = ura + "";
			//else if (min <= 45) ur = ura + ".5";
			//else ur = (ura + 1) + "";
			ur = ura + "." + min;
			
	    	String	sql = "update dob" + year + " " +
						 "set " +
						 "	stev_km_sled = " + pot + 
						 ", stev_ur_sled = " + ur +
						 ", sofer_sled = " + (sofer==null || sofer.equals("0") ? null : sofer) +
						 ", error = " + ERROR_DATA_OK +
						 " where pozicija = 1 and " +
						 "		st_dob = " + st_dob + " and " +
						 "		zacetek = '" + getZadnjaDobavnica(st_dob, year) + "'";
	    		
			System.out.println("UPDATE SLEDENJE="+sql);
			stmt.executeUpdate(sql);
	    } catch (Exception theException) {
	    	System.out.println("NAPAKA UPDATE SLEDENJE="+theException.getMessage());
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
	
	private void setDobError(String sif_kam, String dobLeto, String datum, int error) {

    	ResultSet rs = null;
    	Statement stmt = null;
    	Statement stmt1 = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			String sql = "select max(zacetek) zacetek, st_dob, pozicija " +
						"from dob" + dobLeto + " " +
						"where pozicija = 1 and " +
						"		error = 0 and " +
						"		sif_kam = " + sif_kam;
			if (datum != null)
				sql += " and datum = '" + datum + "'";
			sql += " group by st_dob, pozicija";
		
	    	rs = stmt.executeQuery(sql);
			
	    	stmt1 = con.createStatement();   	
	    	while (rs.next()) {
				sql = "update dob" + dobLeto + " " +
						 "set error = " + error +
						 " where st_dob = " + rs.getString("st_dob") + " and " +
						 "		pozicija = 1 and " +
						 "		zacetek = '" + rs.getString("zacetek") + "' and " +
						 "		error = 0";
				if (datum != null)
					sql += " and datum = '" + datum + "'";
				
				System.out.println("setDobError="+sql);
				stmt1.executeUpdate(sql);
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
	    		if (stmt1 != null) {
	    			stmt1.close();
	    		}
			} catch (Exception e) {
			}
	    }	
		
		return;
	}

	private void setVozilaNiVSledenju(String vozila, int dobLeto, int error) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			String sql = "update dob" + dobLeto + " " +
						 "set error = " + error +
						 " where pozicija = 1 and " +
						 "		sif_kam not in (" + vozila + ") and " +
						 "		error = 0";
			
			System.out.println("setVozilaNiVSledenju="+sql);
			//stmt.executeUpdate(sql);
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

	
	private void setDobOkError(String st_dob, String datum, int error) {

    	Statement stmt = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

	    	String	sql = "update dob" + datum.substring(0, 4) + " " +
						 "set error = " + error +
						 " where pozicija = 1 and " +
						 "		st_dob = " + st_dob + " and " +
			 			 "		error = 0 and " +
						 "		zacetek = '" + getZadnjaDobavnica(st_dob, datum.substring(0, 4)) + "'";
	    		
    		System.out.println("setDobOkError="+sql);
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
	
	private String getZadnjaDobavnica(String st_dob, String datum) {

    	ResultSet rs = null;
    	Statement stmt = null;
    	
	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			String sql = "select max(zacetek) zacetek " +
					"from dob" + datum.substring(0, 4) + " " + 
					"where st_dob = " + st_dob + 
					" and pozicija = 1";

	    	rs = stmt.executeQuery(sql);

	    	if (rs.next()) {
	    		return rs.getString("zacetek");
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
		
		return null;
	}
	
	//nastavim podatke za PREVOZ ZA LASTNE POTREBE
	// za tiste lastne potrebe, ki nimajo podatka ze dolocenega error!=9
	private void setPrevozLastnePotrebe(String sifKam, String datum, int metersLastnePotrebe, long casLastnePotrebe) {

    	Statement stmt = null;
    	ResultSet rs = null;

	    try {
	    	connectionMake();
			stmt = con.createStatement();   	

			
			String sql = "SELECT count(*) as cnt " +
						"from dob" + datum.substring(0, 4) + " " +
						"WHERE stranka LIKE '%"+PREVOZ_ZA_LASTNE_POTREBE+"%' AND " +
						"	error != 9 AND " +
						"	pozicija = 1 AND " +	
						"	sif_kam = " + sifKam + " and " +		
						"	datum = '" + datum + "'";
				 
	    	System.out.println(sql);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(sql);
	    	int cnt = 1;
	    	
	    	if (rs.next()) {
	    		cnt = rs.getInt("cnt");
	    	}
	    	
	    	if (cnt > 0) {
				double metersD = metersLastnePotrebe / cnt;
				long pot = Math.round(metersD/1000);
				
				long ura = casLastnePotrebe / (3600 * cnt);	
				long min = (casLastnePotrebe / 60) % 60;
				String ur;
				if (min <= 15) ur = ura + "";
				else if (min <= 45) ur = ura + ".5";
				else ur = (ura + 1) + "";
	
				sql = "update dob" + datum.substring(0, 4) + " " +
						 "set " +
						 "	stev_km_sled = " + pot + 
						 ", stev_ur_sled = " + ur +
						 ", error = " + ERROR_DATA_LASTNE_POTREBE + " " +
						 " where stranka like '%"+PREVOZ_ZA_LASTNE_POTREBE+"%' and " +
						 "		error != " + ERROR_DATA_OK + " and " +
						 "		pozicija = 1 and " +
						 "		sif_kam = " + sifKam + " and " +
						 "		datum = '" + datum + "'";
				
				System.out.println("setPrevozLastnePotrebe="+sql);
				stmt.executeUpdate(sql);
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
		
		return;
	}		
}
