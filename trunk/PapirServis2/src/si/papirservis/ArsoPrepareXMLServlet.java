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
		String sif_upor = (String) request.getParameter("sif_upor");
		String keyChecked = (String) request.getParameter("keyChecked");
		
		String ZAVEZANEC_ST = (String) getServletConfig().getInitParameter("ZAVEZANEC_ST");
		String ZAVEZANEC_MATICNA_ST = (String) getServletConfig().getInitParameter("ZAVEZANEC_MATICNA_ST");

		OutputStream out = null;
		try {
			
			int ret = createArsoPaket(keyChecked, sif_upor, tabela);
			if (ret == -1) {
				throw new Exception("napaka");
			}
			String xml = getEVL(keyChecked, tabela, ret+"", ZAVEZANEC_ST, ZAVEZANEC_MATICNA_ST);
			System.out.println("XML="+xml);
			
			response.setContentType("text/xml");
			response.setHeader("Content-disposition", "attachment; filename=arso_paket_"+ret+".xml");

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
	

	private String getEVL(String keyChecked, String tabela, String PAKET_INT_ID, String ZAVEZANEC_ST, String ZAVEZANEC_MATICNA_ST) {

    	Statement stmt = null;
    	ResultSet rs = null;

	    try {
	    	String xml = "";
	    	connectionMake();

	    	String query = 	"SELECT date_format(" + tabela + ".datum, '%d.%m.%Y') as datum_odaje, " + tabela + ".*, " +
	    					"	kupci.maticna kupci_maticna, kupci.arso_pslj_st, kupci.arso_pslj_status, " +
	    					"	enote.maticna enote_maticna, enote.arso_prjm_st, enote.arso_prjm_status, enote.arso_odp_locpr_id,  " +
	    					"	kamion.maticna kamion_maticna, kamion.arso_prvz_st, kamion.arso_prvz_status, " +
	    					"	str.arso_odp_loc_id, " +
	    					"	mat.arso_odp_locpr_id material_arso_odp_locpr_id " +
	    					" FROM " + tabela + 
	    					" LEFT JOIN kupci ON (" + tabela + ".sif_kupca = kupci.sif_kupca) " +
	    					" LEFT JOIN enote on (kupci.sif_enote = enote.sif_enote) " +
	    					" LEFT JOIN kamion ON (" + tabela + ".sif_kam = kamion.sif_kam) " +
	    					" LEFT JOIN (select stranke.* " +
	    					"			from stranke, (select sif_str, max(zacetek) zac from stranke group by sif_str) zadnji " +
	    					"			where stranke.sif_str = zadnji.sif_str and stranke.zacetek = zadnji.zac) str " +
	    					"		ON (" + tabela + ".sif_str = str.sif_str) " +
	    					" LEFT JOIN (select materiali.* " +
	    					"			from materiali, (select koda, max(zacetek) zac from materiali group by koda) zadnji1 " +
	    					"			where materiali.koda = zadnji1.koda and materiali.zacetek = zadnji1.zac) mat " +
							"		ON (" + tabela + ".koda = mat.koda) " +
	    					" WHERE concat(" + tabela + ".id,'-',st_dob,'-',pozicija) IN ("+keyChecked+")";

	    	
	    	xml = PAKET_INT_ID + ";" + ZAVEZANEC_ST + ";" + ZAVEZANEC_MATICNA_ST + ";\"\n";
	    		
	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	while (rs.next()) {
	    		//EVLS_INT_ID
	    		xml += "" + rs.getString("st_dob") + "\n";

	    		//POSILJATELJ
	    		xml += "" + rs.getString("arso_pslj_st")+ ";" + rs.getString("kupci_maticna") + ";" + rs.getString("arso_pslj_status") + "\n";

	    		//PREJEMNIK
	    		xml += "" + rs.getString("arso_prjm_st")+ ";" + rs.getString("enote_maticna") + ";" + rs.getString("arso_prjm_status") + "\n";
	    		
	    		//PREVOZNIK
	    		//CE JE VOZILO PRIPELJALI SAMI JE PREVOZNIK = POSILJATELJ
	    		xml += "" + rs.getString("arso_prvz_st")+ ";" + rs.getString("kamion_maticna") + ";" + rs.getString("arso_prvz_status") + "\n";

	    		//DATUM_ODDAJE
	    		xml += "" + rs.getString("datum_odaje") + "\n";
	    			
	    		//KRAJ_ODDAJE
	    		xml += "STALNA;" + rs.getString("enote_maticna") + "\n";
	    		
	    		//KRAJ_PREJEMA
	    		xml += "STALNA;" + rs.getString("arso_odp_locpr_id") + "\n";
	    		
	    		//DATUM_PREJEMA
	    		xml += "" + rs.getString("datum_odaje") + "\n";

	    		//PRVZ_SREDSTVO
	    		xml += "C\n";

	    		//IND_POOBLASTILO_OBSTAJA
	    		xml += "D\n";

	    		//ODPADEK
	    		//Ce je MATERIAL.ODP_LOCPR_ID prazno se uporabi podatek iz baze enote, če pa ni prazno se uporabi podatek iz baze materiali
	    		String material_arso_odp_locpr_id = rs.getString("material_arso_odp_locpr_id");
	    		xml += "" + rs.getString("ewc")+ ";" + 
	    					rs.getString("kolicina") + ";D;" + 
	    					rs.getString("arso_odp_embalaza") + ";" + 
	    					rs.getString("arso_emb_st_enot") + ";" + 
	    					rs.getString("arso_odp_embalaza_shema") + ";" + 
	    					rs.getString("arso_odp_fiz_last") + ";" + 
	    					rs.getString("arso_odp_tip") + ";" + 
	    					rs.getString("arso_odp_dej_nastanka") + ";" + 
	    					rs.getString("arso_odp_loc_id") + ";" + 
	    					rs.getString("arso_aktivnost_pslj") + ";" + 
	    					(material_arso_odp_locpr_id != null? material_arso_odp_locpr_id : rs.getString("arso_odp_locpr_id")) + ";" + 
	    					rs.getString("arso_aktivnost_prjm") + ";" + 
	    					"\n";
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
	
	private int createArsoPaket(String keyChecked, String sif_upor, String tabela) {

    	Statement stmt = null;
    	ResultSet rs = null;

	    try {
	    	connectionMake();

	    	//preberem id paketa
	    	String query = 	"select max(sifra)+1 as sifra from arso_paketi";
	    	
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	int sifra = 0;
	    	while (rs.next()) {
	    		sifra = rs.getInt("sifra");
	    	}
			
	    	
	    	//kreiram nov paket
	    	query = 	"insert into arso_paketi (sifra, datum, potrjen, sif_upor, xml) " +
	    				"values (" + sifra + ",now(),0," + sif_upor + ",'" + keyChecked.replaceAll("'", "") + "')";
	    	
	    	System.out.println(query);
			stmt = con.createStatement();   	
			stmt.executeUpdate(query);

			
	    	//updatetam vse dobavnice v paketu
	    	query = 	"update  " + tabela +
	    				" set arso_status = 1 " + 
						" WHERE concat(id,'-',st_dob,'-',pozicija) IN ("+keyChecked+")";
	    	
	    	System.out.println(query);
			stmt = con.createStatement();   	
			stmt.executeUpdate(query);
			
			return sifra;
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
		
		
		return -1;
	}
	
}
