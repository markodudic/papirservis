package si.papirservis;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Locale;

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
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("SERVLET GET");		
	}

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest arg0,
	 *      HttpServletResponse arg1)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String type = (String) request.getParameter("type");
		
		if (type.equals("import")) {
			try
			{
				//preberemo parametre
				String csv = (String) request.getParameter("csv");
				String [] csvs = csv.split("\r\n");
				
				for(int i=0; i<csvs.length; i++) {
					System.out.println(csvs[i].replace("\r\n", ""));	
					String[] stranka = csvs[i].replace("\r\n", "").split(";");
					if (stranka.length != 10) continue;
					String sif_str = stranka[0].equals("") ? "0" : stranka[0].replaceAll("\"", "");
					String y = stranka[1].equals("") ? "null" : stranka[1].replaceAll("\"", "").replaceAll(",", ".");
					String x = stranka[2].equals("") ? "null" : stranka[2].replaceAll("\"", "").replaceAll(",", ".");
					String naziv = stranka[3].equals("") ? "null" : stranka[3].replaceAll("\"", "");
					String naslov = stranka[4].equals("") ? "null" : stranka[4].replaceAll("\"", "");
					String posta = stranka[5].equals("") ? "null" : stranka[5].replaceAll("\"", "");
					String kraj = stranka[6].equals("") ? "null" : stranka[6].replaceAll("\"", "");
					String drzava = stranka[7].equals("") ? "null" : stranka[7].replaceAll("\"", "");
					String km_norm = stranka[8].equals("") ? "0" : stranka[8].replaceAll("\"", "");
					String ur_norm = stranka[9].equals("") || stranka[9].equals("\n") ? "0" : stranka[9].replaceAll("\"", "");
					
					if (updateCustomer(sif_str, x, y, naziv, naslov, posta, kraj, drzava, km_norm, ur_norm) == -1) {
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
		} else {
			String tipizvoza = (String) request.getParameter("tipizvoza");
			response.setContentType("text/csv");
			response.setHeader("Content-disposition", "attachment; filename=stranke.csv");
			OutputStream out = null;
			try {
				
				String csv = getCustomers(tipizvoza);
				
				out = response.getOutputStream();	
				out.write(csv.getBytes("utf-8"));
				out.flush();
				out.close();
				
			} catch (Exception e) {
				response.setContentType("text/html");
				response.setHeader("Content-disposition", null);
				try {
					e.printStackTrace();
					out.write("Prišlo je do napake pri pridobivanju podatkov.".getBytes());
					out.flush();
					out.close();
				} catch (IOException e1) {}
			} finally {
				if (out!= null) try { out.close(); } catch (IOException e) {}
			}
			
		}
	
	}	
	

	private int updateCustomer(String sif_str, String x, String y, String naziv, String naslov, String posta, String kraj, String drzava, String km_norm, String ur_norm) {

    	Statement stmt = null;

	    try {
	    	connectionMake();

	    	String query = 	"UPDATE stranke " +
	    					"SET naziv = '" + naziv + "', " +
	    					"	 x_koord = '" + x + "', " +
	    					"	 y_koord = '" + y + "', " +
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
	
	private String getCustomers(String tip) {

    	Statement stmt = null;
    	ResultSet rs = null;

	    try {
	    	connectionMake();

	    	String query = 	"SELECT stranke.sif_str, stranke.naziv, stranke.x_koord, stranke.y_koord, stranke.naslov, stranke.posta, stranke.kraj, stranke.stev_km_norm, stranke.stev_ur_norm " +
	    					"from stranke, (select max(id) as id, sif_str " +
							"				from stranke " +
							"				group by sif_str) as s " +
							"where stranke.id in (s.id) ";
	    	
	    	if (tip.equals("novi")) {
	    		query += "WHERE x_koord is null or y_koord is null";
	    	}
	    	
	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	String csv = "";
	    	while (rs.next()) {
	    		csv += "\"" + rs.getString("sif_str") + "\";";
	    		csv += "\"" + (rs.getString("y_koord")==null?"":rs.getString("y_koord")) + "\";";
	    		csv += "\"" + (rs.getString("x_koord")==null?"":rs.getString("x_koord")) + "\";";
	    		csv += "\"" + (rs.getString("naziv")==null?"":rs.getString("naziv")) + "\";";
	    		csv += "\"" + (rs.getString("naslov")==null?"":rs.getString("naslov")) + "\";";
	    		csv += "\"" + rs.getString("posta") + " " + rs.getString("kraj") + "\";";
	    		csv += "\"" + "\";";
	    		csv += "\"" + (rs.getString("stev_km_norm")==null?"":rs.getString("stev_km_norm")) + "\";";
	    		csv += "\"" + (rs.getString("stev_km_norm")==null?"":rs.getString("stev_ur_norm")) + "\"\n";
	    	}
	    	
	    	return csv;
	    	
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
		
		
		return "";
	}
	
	
}
