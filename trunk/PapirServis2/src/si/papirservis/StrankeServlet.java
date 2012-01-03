package si.papirservis;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Locale;
import java.util.Vector;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class StrankeServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
	
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public StrankeServlet() {
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
		System.out.println("SERVLET post");		
		try
		{
			//preberemo parametre
			String csv = (String) request.getParameter("csv");

			String [] csvs = csv.split("\n");
			for(int i=0; i<csvs.length; i++) {
				System.out.println(csvs[i]);	
				String[] stranka = csvs[i]. split(";");
				if (stranka.length != 8) continue;
				String sif_str = stranka[0].equals("") ? "0" : stranka[0];
				String naziv = stranka[1].equals("") ? "null" : stranka[1];
				String naslov = stranka[2].equals("") ? "null" : stranka[2];
				String posta = stranka[3].equals("") ? "null" : stranka[3];
				String kraj = stranka[4].equals("") ? "null" : stranka[4];
				String km_norm = stranka[5].equals("") ? "0" : stranka[5];
				String ur_norm = stranka[6].equals("") ? "0" : stranka[6];
				
				if (updateCustomer(sif_str, naziv, naslov, posta, kraj, km_norm, ur_norm) == -1) {
					throw new Exception("napaka");
				}
				
			}
			

			
			
			//vrnemo rezultat
			OutputStream out = response.getOutputStream();
			out.write("true".getBytes("utf-8"));
			out.flush();
			out.close();

			
		}
		catch (Exception e)
		{
			OutputStream out = response.getOutputStream();
			out.write("false".getBytes("utf-8"));
			out.flush();
			out.close();
			e.printStackTrace();
			
		}
	
	}	
	

	private int updateCustomer(String sif_str, String naziv, String naslov, String posta, String kraj, String km_norm, String ur_norm) {

    	Statement stmt = null;

	    try {
	    	connectionMake();

	    	String query = 	"UPDATE stranke " +
	    					"SET naziv = '" + naziv + "', " +
	    					"	 naslov = '" + naslov + "', " +
	    					"	 posta = " + posta + ", " +
	    					"	 kraj = '" + kraj + "', " +
	    					"	 stev_km_norm = " + km_norm + ", " +
	    					"	 stev_ur_norm = " + ur_norm + " " +
	    					"WHERE sif_str = " + sif_str;

	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	return stmt.executeUpdate(query);

	    	
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
		
		
		return -1;
	}
	
	
	
}
