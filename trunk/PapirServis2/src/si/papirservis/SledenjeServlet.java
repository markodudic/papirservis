package si.papirservis;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Locale;
import java.util.Vector;
import java.net.*;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.*;

import org.apache.commons.httpclient.HttpException;


import si.papirservis.InitServlet;
import java.sql.Connection;
import java.sql.SQLException;


public class SledenjeServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
	
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public SledenjeServlet() {
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

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest arg0,
	 *      HttpServletResponse arg1)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("SERVLET");		
		try
		{
			//preberem lokacijo sledenja serverja
			String url = (String) getServletConfig().getInitParameter("SledenjeServerURL");
			System.out.println("url="+url);		


			//preberemo parametre
			String x_sif_kupca = (String) request.getParameter("x_sif_kupca");
			String x_sif_enote = (String) request.getParameter("x_sif_enote");
			String x_sif_skupine = (String) request.getParameter("x_sif_skupine");
			String datum = (String) request.getParameter("datum");
			
			if ((x_sif_kupca == null) || (x_sif_kupca.equals(""))) x_sif_kupca = "-1";
			if ((x_sif_enote == null) || (x_sif_enote.equals(""))) x_sif_enote = "-1";
			if ((x_sif_skupine == null) || (x_sif_skupine.equals(""))) x_sif_skupine = "-1";
			System.out.println(x_sif_kupca+"  "+x_sif_enote+"  "+x_sif_skupine+"  "+datum);		

			//dobimo podatke iz baze
			Vector data = getData(x_sif_kupca, x_sif_enote, x_sif_skupine, datum);
			System.out.println("DATA="+data);	

			//posljemo na server sledenja
			Vector result = null;
			if ((data != null) && (data.size() > 0))
			{
				result = getSledenje(url, datum, data);
				System.out.println("RESULT="+result);	
			}
			
			//vrnemo rezultat
			HttpSession session = request.getSession(true);
			session.setAttribute("data", data);
			session.setAttribute("result", result);
			response.sendRedirect("sledenjeResult.jsp"); 
			response.flushBuffer(); 
			return;

			
		}
		catch (Exception e)
		{
			e.printStackTrace();
			
		}
	
	}	
	

	private Vector getData(String x_sif_kupca, String x_sif_enote, String x_sif_skupine, String datum) {
    	Vector dataVector = new Vector();

//    	Connection conn = null;
    	ResultSet rs = null;
	    Statement stmt = null;

	    try {
	    	connectionMake();
//	    	conn = DbManager.dbManager.getDS().getConnection();
//	    	System.out.println("conn="+conn);

			String datumFormat = EW_UnFormatDateTime((String)datum,"EURODATE", locale).toString();	
	    	
	    	String query = 	"select dob.st_dob st_dob, stranke.sif_str stranke_sif_str, stranke.naziv stranke_naziv, " +
	    					" 		stranke.x_koord stranke_x_koord, stranke.y_koord stranke_y_koord, stranke.radij stranke_radij, stranke.vtez stranke_vtez, " +
	    					"		enote.x_koord enote_x_koord, enote.y_koord enote_y_koord, enote.radij enote_radij, kamion.registrska kamion " +
	    				   	"from (select *, max(dob.zacetek) from dob where dob.datum = CAST('" + datumFormat + "' AS DATE) group by st_dob) dob, " + 
	    				   	"	 (select st.* from stranke st, (SELECT sif_str, max(zacetek) z  from stranke group by sif_str) s " +
	    				   	"	   where st.sif_str = s.sif_str and st.zacetek = s.z) stranke, " +
	    				   	"	enote, " +
	    					"	kupci, " +
	    					"	kamion " +
	    					"where  ((dob.sif_str = " + x_sif_kupca + ")  or (-1 = " + x_sif_kupca + "))  and " +
	    					"		((dob.skupina = " + x_sif_skupine + ")  or (-1 = " + x_sif_skupine + "))  and " +
	    					"		(dob.`sif_str` = stranke.`sif_str`) and " +
							"		(dob.`sif_kupca` = kupci.`sif_kupca`) and " +
							"		((kupci.sif_enote = " + x_sif_enote + ")  or (-1 = " + x_sif_enote + ")) and " +
							"		(kupci.sif_enote = enote.sif_enote) and " +
							"		(dob.sif_kam = kamion.sif_kam)";

	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);

	    	while (rs.next()) {
	    		String st_dob = rs.getString("st_dob");
	    		String stranke_sif_str = rs.getString("stranke_sif_str");
	    		String stranke_naziv = rs.getString("stranke_naziv");
	    		String stranke_x_koord = rs.getString("stranke_x_koord");
	    		String stranke_y_koord = rs.getString("stranke_y_koord");
	    		String stranke_radij = rs.getString("stranke_radij");
	    		String stranke_vtez = rs.getString("stranke_vtez");
	    		String enote_x_koord = rs.getString("enote_x_koord");
	    		String enote_y_koord = rs.getString("enote_y_koord");
	    		String enote_radij = rs.getString("enote_radij");
	    		String kamion = rs.getString("kamion");

	    		if ((st_dob == null) || (stranke_x_koord == null) || (stranke_y_koord == null) ||
	    			(stranke_radij == null) || (stranke_vtez == null) || (enote_x_koord == null) || 
	    			(enote_y_koord == null) || (enote_radij == null) || (kamion == null))
	    			continue;
	    		
		    	Vector dataRecord = new Vector(11);
	    		dataRecord.add(st_dob);
	    		dataRecord.add(stranke_sif_str);
	    		dataRecord.add(stranke_naziv);
	    		dataRecord.add(stranke_x_koord);
	    		dataRecord.add(stranke_y_koord);
	    		dataRecord.add(stranke_radij);
	    		dataRecord.add(stranke_vtez);
	    		dataRecord.add(enote_x_koord);
	    		dataRecord.add(enote_y_koord);
	    		dataRecord.add(enote_radij);    		
	    		dataRecord.add(kamion);
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
/*				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}*/
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

	   	String serv =  server;
    	Vector vectin = null;
    	try 
    	{
          URL  url = new URL(serv);
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
    	}
    	
    	return vectin;
       
	}


	
	
	private java.sql.Timestamp EW_UnFormatDateTime(String ADate,String dateFormat, Locale locale){
		if (ADate == null) return null;
		DateFormat df = DateFormat.getInstance();
		String format = "";
		ADate = ADate.trim().replaceAll("  ", " ");

		String [] arDateTime = ADate.split(" ");
		if (arDateTime.length == 0) {
			return null;
		}
		if (dateFormat.equals("USDATE")){format = "MM/dd/yyyy";}
		else if (dateFormat.equals("DATE")){format = "yyyy/MM/dd";}
		else if (dateFormat.equals("EURODATE")){format = "dd.MM.yyyy";}

		try{
			if (format.length() > 0) {
				df = new SimpleDateFormat(format, locale);
				return new java.sql.Timestamp(((SimpleDateFormat) df).parse(ADate).getTime());
			}else{
				return new java.sql.Timestamp(df.parse(ADate).getTime());
			}
		}catch (Exception e){
			return null;
		}
	}
}
