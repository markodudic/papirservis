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


public class ArsoPrepareXMLServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
	
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public ArsoPrepareXMLServlet() {
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
		doPost(request, response);
	}

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest arg0,
	 *      HttpServletResponse arg1)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String tabela = (String) request.getParameter("tabela");
		String keyChecked = (String) request.getParameter("keyChecked");
		

		response.setContentType("text/xml");
		response.setHeader("Content-disposition", "attachment; filename=arso.xml");
		OutputStream out = null;
		try {
			
			String xml = getEVL(keyChecked, tabela);
			System.out.println("XML="+xml);
			
			out = response.getOutputStream();	
			out.write(xml.getBytes("utf-8"));
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
	

	private String getEVL(String keyChecked, String tabela) {

    	Statement stmt = null;
    	ResultSet rs = null;

	    try {
	    	connectionMake();

	    	String query = 	"SELECT * " +
	    					"FROM " + tabela +
							" WHERE st_dob IN ("+keyChecked+")";

	    	
	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	String xml = "";
	    	while (rs.next()) {
	    		xml += "\"" + rs.getString("st_dob") + "\"\n";
	    	}
	    	
	    	return xml;
	    	
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
