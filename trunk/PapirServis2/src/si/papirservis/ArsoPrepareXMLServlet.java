package si.papirservis;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;


public class ArsoPrepareXMLServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
	private String SAVE_FILES = "";
	private String ZAVEZANEC_ST = "";
	private String ZAVEZANEC_MATICNA_ST = "";
	
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
		SAVE_FILES = (String) getServletConfig().getInitParameter("SAVE_FILES");
		ZAVEZANEC_ST = (String) getServletConfig().getInitParameter("ZAVEZANEC_ST");
		ZAVEZANEC_MATICNA_ST = (String) getServletConfig().getInitParameter("ZAVEZANEC_MATICNA_ST");

		String key = (String) request.getParameter("key");
		if (key!=null) {
			//zbrisem datoteko
			try{
	    		File file = new File(SAVE_FILES+"arso_paket_"+key+".xml");
	    		boolean f = file.delete();
    			OutputStream out = response.getOutputStream();
    			out.write((f+"").getBytes("utf-8"));
    			out.flush();
    			out.close();
	    	}catch(Exception e){
				OutputStream out = response.getOutputStream();
				out.write("false".getBytes("utf-8"));
				out.flush();
				out.close();
	    		e.printStackTrace();
	    	}			
		} else {
			String tabela = (String) request.getParameter("tabela");
			String sif_upor = (String) request.getParameter("sif_upor");
			String keyChecked = (String) request.getParameter("keyChecked");
			String od_datum = (String) request.getParameter("od_datum");
			String do_datum = (String) request.getParameter("do_datum");
			String skupina = (String) request.getParameter("skupina");
			
			try {
				
				String ret = createArsoPaket(keyChecked, sif_upor, tabela, od_datum, do_datum, skupina);
				if (ret == null) throw new Exception("napaka");
	
				//System.out.println("XML="+ret[0]);
							
				//vrnemo rezultat
				OutputStream out = response.getOutputStream();
				out.write(ret.getBytes("utf-8"));
				out.flush();
				out.close();
				
			} catch (Exception e) {
				OutputStream out = response.getOutputStream();
				out.write("false".getBytes("utf-8"));
				out.flush();
				out.close();
				e.printStackTrace();
			}
		}
	
	}	
	

	private Document getEVL(String keyChecked, String tabela, int PAKET_INT_ID) {

    	Statement stmt = null;
    	ResultSet rs = null;

	    try {
	    	String xml = "";
	    	connectionMake();

	    	String query = 	"SELECT date_format(dob.datum, '%d.%m.%Y') as datum_odaje, dob.*, " +
	    					"	kupci.maticna kupci_maticna, kupci.arso_pslj_st, kupci.arso_pslj_status, " +
	    					"	enote.maticna enote_maticna, enote.arso_prjm_st, enote.arso_prjm_status, enote.arso_odp_locpr_id,  " +
	    					"	kamion.maticna kamion_maticna, kamion.arso_prvz_st, kamion.arso_prvz_status, " +
	    					"	str.arso_odp_loc_id, " +
	    					"	mat.arso_odp_locpr_id material_arso_odp_locpr_id " +
	    					" FROM " + tabela + " as dob " +
	    					" LEFT JOIN kupci ON (dob.sif_kupca = kupci.sif_kupca) " +
	    					" LEFT JOIN enote on (kupci.sif_enote = enote.sif_enote) " +
							" LEFT JOIN ( " +
							"		SELECT kamion.* " +
							"		FROM kamion, ( " +
							"		SELECT sif_kam, MAX(zacetek) zac " +
							"		FROM kamion " +
							"		GROUP BY sif_kam) zadnji " +
							"		WHERE kamion.sif_kam = zadnji.sif_kam AND kamion.zacetek = zadnji.zac) kamion ON (dob.sif_kam = kamion.sif_kam) " +
	    					" LEFT JOIN (select stranke.* " +
	    					"			from stranke, (select sif_str, max(zacetek) zac from stranke group by sif_str) zadnji " +
	    					"			where stranke.sif_str = zadnji.sif_str and stranke.zacetek = zadnji.zac) str " +
	    					"		ON (dob.sif_str = str.sif_str) " +
	    					" LEFT JOIN (select materiali.* " +
	    					"			from materiali, (select koda, max(zacetek) zac from materiali group by koda) zadnji1 " +
	    					"			where materiali.koda = zadnji1.koda and materiali.zacetek = zadnji1.zac) mat " +
							"		ON (dob.koda = mat.koda) " +
	    					" WHERE concat(dob.id,'-',st_dob,'-',pozicija) IN ("+keyChecked+")";

	    	
	    	xml = PAKET_INT_ID + ";" + ZAVEZANEC_ST + ";" + ZAVEZANEC_MATICNA_ST + ";\"\n";
	    	    
    		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
    		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
     
    		// root elements
    		Document doc = docBuilder.newDocument();
    		Element rootElement = doc.createElement("ARSO_VHOD_DOK");
    		rootElement.setAttribute("PODROCJE", "ODPADKI");
    		rootElement.setAttribute("TIP", "EVLS_OBICAJNI_PRJMPSLJ");
    		rootElement.setAttribute("VERZIJA", "1.0.0");
    		doc.appendChild(rootElement);

    		Element evls_paket = doc.createElement("EVLS_PAKET");
    		rootElement.appendChild(evls_paket);
     	    		
    		Element paket_ind_id = doc.createElement("PAKET_INT_ID");
    		paket_ind_id.appendChild(doc.createTextNode(PAKET_INT_ID+""));
    		evls_paket.appendChild(paket_ind_id);

    		Element zavezanec_st = doc.createElement("ZAVEZANEC_ST");
    		zavezanec_st.appendChild(doc.createTextNode(ZAVEZANEC_ST));
    		evls_paket.appendChild(zavezanec_st);

    		Element zavezanec_maticna_st = doc.createElement("ZAVEZANEC_MATICNA_ST");
    		zavezanec_maticna_st.appendChild(doc.createTextNode(ZAVEZANEC_MATICNA_ST));
    		evls_paket.appendChild(zavezanec_maticna_st);

    		
	    	System.out.println(query);	           
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	while (rs.next()) {
	    		boolean prevoznikPosiljatelj = rs.getString("sif_kam").equals("0");

	    		Element ODPADKI_EVL_PODATKI_1 = doc.createElement("ODPADKI_EVL_PODATKI_1");
	    		evls_paket.appendChild(ODPADKI_EVL_PODATKI_1);
	    		
	    		Element EVLS_INT_ID = doc.createElement("EVLS_INT_ID");
	    		EVLS_INT_ID.appendChild(doc.createTextNode(rs.getString("st_dob")));
	    		ODPADKI_EVL_PODATKI_1.appendChild(EVLS_INT_ID);
	    		
	    		Element POSILJATELJ = doc.createElement("POSILJATELJ");
	    		ODPADKI_EVL_PODATKI_1.appendChild(POSILJATELJ);

	    		Element PSLJ_ST = doc.createElement("PSLJ_ST");
	    		PSLJ_ST.appendChild(doc.createTextNode(rs.getString("arso_pslj_st")));
	    		POSILJATELJ.appendChild(PSLJ_ST);

	    		Element PSLJ_MATICNA_ST = doc.createElement("PSLJ_MATICNA_ST");
	    		PSLJ_MATICNA_ST.appendChild(doc.createTextNode(rs.getString("kupci_maticna")));
	    		POSILJATELJ.appendChild(PSLJ_MATICNA_ST);

	    		Element PSLJ_STATUS = doc.createElement("PSLJ_STATUS");
	    		PSLJ_STATUS.appendChild(doc.createTextNode(rs.getString("arso_pslj_status")));
	    		POSILJATELJ.appendChild(PSLJ_STATUS);

	    		Element PREJEMNIK = doc.createElement("PREJEMNIK");
	    		ODPADKI_EVL_PODATKI_1.appendChild(PREJEMNIK);

	    		Element PRJM_ST = doc.createElement("PRJM_ST");
	    		PRJM_ST.appendChild(doc.createTextNode(rs.getString("arso_prjm_st")));
	    		PREJEMNIK.appendChild(PRJM_ST);

	    		Element PRJM_MATICNA_ST = doc.createElement("PRJM_MATICNA_ST");
	    		PRJM_MATICNA_ST.appendChild(doc.createTextNode(rs.getString("enote_maticna")));
	    		PREJEMNIK.appendChild(PRJM_MATICNA_ST);

	    		Element PRJM_STATUS = doc.createElement("PRJM_STATUS");
	    		PRJM_STATUS.appendChild(doc.createTextNode(rs.getString("arso_prjm_status")));
	    		PREJEMNIK.appendChild(PRJM_STATUS);

	    		Element PREVOZNIK = doc.createElement("PREVOZNIK");
	    		ODPADKI_EVL_PODATKI_1.appendChild(PREVOZNIK);

	    		Element PRVZ_ST = doc.createElement("PRVZ_ST");
	    		if (!prevoznikPosiljatelj)
	    			PRVZ_ST.appendChild(doc.createTextNode(rs.getString("arso_prvz_st")));
	    		else
	    			PRVZ_ST.appendChild(doc.createTextNode(rs.getString("arso_pslj_st")));
	    		PREVOZNIK.appendChild(PRVZ_ST);

	    		Element PRVZ_MATICNA_ST = doc.createElement("PRJM_MATICNA_ST");
	    		if (!prevoznikPosiljatelj)
	    			PRVZ_MATICNA_ST.appendChild(doc.createTextNode(rs.getString("kamion_maticna")));
	    		else
	    			PRVZ_MATICNA_ST.appendChild(doc.createTextNode(rs.getString("kupci_maticna")));
	    		PREVOZNIK.appendChild(PRVZ_MATICNA_ST);

	    		Element PRVZ_STATUS = doc.createElement("PRVZ_STATUS");
	    		if (!prevoznikPosiljatelj)
		    		PRVZ_STATUS.appendChild(doc.createTextNode(rs.getString("arso_prvz_status")));
	    		else
	    			PRVZ_STATUS.appendChild(doc.createTextNode("PREVOZNIK"));
	    		PREVOZNIK.appendChild(PRVZ_STATUS);

	    		Element DATUM_ODDAJE = doc.createElement("DATUM_ODDAJE");
	    		DATUM_ODDAJE.appendChild(doc.createTextNode(rs.getString("datum_odaje")));
	    		ODPADKI_EVL_PODATKI_1.appendChild(DATUM_ODDAJE);

	    		Element KRAJ_ODDAJE = doc.createElement("KRAJ_ODDAJE");
	    		ODPADKI_EVL_PODATKI_1.appendChild(KRAJ_ODDAJE);
	    		
	    		Element TIP_LOKACIJE_ODDAJE = doc.createElement("TIP_LOKACIJE_ODDAJE");
	    		TIP_LOKACIJE_ODDAJE.appendChild(doc.createTextNode("STALNA"));
	    		KRAJ_ODDAJE.appendChild(TIP_LOKACIJE_ODDAJE);

	    		Element ODP_LOC_ID = doc.createElement("ODP_LOC_ID");
	    		ODP_LOC_ID.appendChild(doc.createTextNode(rs.getString("enote_maticna")));
	    		KRAJ_ODDAJE.appendChild(ODP_LOC_ID);

	    		Element KRAJ_PREJEMA = doc.createElement("KRAJ_PREJEMA");
	    		ODPADKI_EVL_PODATKI_1.appendChild(KRAJ_PREJEMA);

	    		Element TIP_LOKACIJE_PREJEMA = doc.createElement("TIP_LOKACIJE_PREJEMA");
	    		TIP_LOKACIJE_PREJEMA.appendChild(doc.createTextNode("STALNA"));
	    		KRAJ_PREJEMA.appendChild(TIP_LOKACIJE_PREJEMA);
	    		
	    		Element ODP_LOC_ID1 = doc.createElement("ODP_LOC_ID1");
	    		ODP_LOC_ID1.appendChild(doc.createTextNode(rs.getString("arso_odp_locpr_id")));
	    		KRAJ_PREJEMA.appendChild(ODP_LOC_ID1);

	    		Element OPOMBA_VOZNIK = doc.createElement("OPOMBA_VOZNIK");
	    		ODPADKI_EVL_PODATKI_1.appendChild(OPOMBA_VOZNIK);
	    		
	    		Element DATUM_PREJEMA = doc.createElement("DATUM_PREJEMA");
	    		DATUM_PREJEMA.appendChild(doc.createTextNode(rs.getString("datum_odaje")));
	    		ODPADKI_EVL_PODATKI_1.appendChild(DATUM_PREJEMA);

	    		Element OPOMBA_PRJM = doc.createElement("OPOMBA_PRJM");
	    		ODPADKI_EVL_PODATKI_1.appendChild(OPOMBA_PRJM);

	    		Element PRVZ_SREDSTVO = doc.createElement("PRVZ_SREDSTVO");
	    		PRVZ_SREDSTVO.appendChild(doc.createTextNode("C"));
	    		ODPADKI_EVL_PODATKI_1.appendChild(PRVZ_SREDSTVO);

	    		Element IND_POOBLASTILO_OBSTAJA = doc.createElement("IND_POOBLASTILO_OBSTAJA");
	    		IND_POOBLASTILO_OBSTAJA.appendChild(doc.createTextNode("D"));
	    		ODPADKI_EVL_PODATKI_1.appendChild(PRVZ_SREDSTVO);

	    		Element SEZNAM_ODPADKOV = doc.createElement("SEZNAM_ODPADKOV");
	    		ODPADKI_EVL_PODATKI_1.appendChild(SEZNAM_ODPADKOV);

	    		Element ODPADEK = doc.createElement("ODPADEK");
	    		SEZNAM_ODPADKOV.appendChild(ODPADEK);

	    		Element ODP_ST = doc.createElement("ODP_ST");
	    		ODP_ST.appendChild(doc.createTextNode(rs.getString("ewc")));
	    		ODPADEK.appendChild(ODP_ST);

	    		Element ODP_KOLICINA = doc.createElement("ODP_KOLICINA");
	    		ODP_KOLICINA.appendChild(doc.createTextNode(rs.getString("kolicina")));
	    		ODPADEK.appendChild(ODP_KOLICINA);

	    		Element IND_SPREJETO = doc.createElement("IND_SPREJETO");
	    		IND_SPREJETO.appendChild(doc.createTextNode("D"));
	    		ODPADEK.appendChild(IND_SPREJETO);

	    		Element ODP_EMBALAZA = doc.createElement("ODP_EMBALAZA");
	    		ODP_EMBALAZA.appendChild(doc.createTextNode(rs.getString("arso_odp_embalaza")));
	    		ODPADEK.appendChild(ODP_EMBALAZA);

	    		Element ODP_EMB_ST_ENOT = doc.createElement("ODP_EMB_ST_ENOT");
	    		ODP_EMB_ST_ENOT.appendChild(doc.createTextNode(rs.getString("arso_emb_st_enot")));
	    		ODPADEK.appendChild(ODP_EMB_ST_ENOT);

	    		Element ODP_EMB_SHEMA = doc.createElement("ODP_EMB_SHEMA");
	    		ODP_EMB_SHEMA.appendChild(doc.createTextNode(rs.getString("arso_odp_embalaza_shema")));
	    		ODPADEK.appendChild(ODP_EMB_SHEMA);

	    		Element ODP_FIZ_LAST = doc.createElement("ODP_FIZ_LAST");
	    		ODP_FIZ_LAST.appendChild(doc.createTextNode(rs.getString("arso_odp_fiz_last")));
	    		ODPADEK.appendChild(ODP_FIZ_LAST);

	    		Element ODP_TIP = doc.createElement("ODP_TIP");
	    		ODP_TIP.appendChild(doc.createTextNode(rs.getString("arso_odp_tip")));
	    		ODPADEK.appendChild(ODP_TIP);

	    		Element ODP_DEJ_NASTANKA = doc.createElement("ODP_DEJ_NASTANKA");
	    		ODP_DEJ_NASTANKA.appendChild(doc.createTextNode(rs.getString("arso_odp_dej_nastanka")));
	    		ODPADEK.appendChild(ODP_DEJ_NASTANKA);

	    		Element ODP_LOCN_ID = doc.createElement("ODP_LOCN_ID");
	    		ODP_LOCN_ID.appendChild(doc.createTextNode(rs.getString("arso_odp_loc_id")));
	    		ODPADEK.appendChild(ODP_LOCN_ID);

	    		Element ODP_AKTIVNOST_PSLJ = doc.createElement("ODP_AKTIVNOST_PSLJ");
	    		ODP_AKTIVNOST_PSLJ.appendChild(doc.createTextNode(rs.getString("arso_aktivnost_pslj")));
	    		ODPADEK.appendChild(ODP_AKTIVNOST_PSLJ);

	    		Element ODP_LOCPR_ID = doc.createElement("ODP_LOCPR_ID");
	    		String material_arso_odp_locpr_id = rs.getString("material_arso_odp_locpr_id");
				if (material_arso_odp_locpr_id != null)
					ODP_LOCPR_ID.appendChild(doc.createTextNode(material_arso_odp_locpr_id));
				else	
					ODP_LOCPR_ID.appendChild(doc.createTextNode(rs.getString("arso_odp_locpr_id")));
	    		ODPADEK.appendChild(ODP_LOCPR_ID);

	    		Element ODP_AKTIVNOST_PRJM = doc.createElement("ODP_AKTIVNOST_PRJM");
	    		ODP_AKTIVNOST_PRJM.appendChild(doc.createTextNode(rs.getString("arso_aktivnost_prjm")));
	    		ODPADEK.appendChild(ODP_AKTIVNOST_PRJM);
	    	}
	    	
	    	return doc;
	    	
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
	
	private String createArsoPaket(String keyChecked, String sif_upor, String tabela, String od_datum, String do_datum, String skupina) {

    	Statement stmt = null;
    	ResultSet rs = null;

	    try {
	    	connectionMake();
	    	con.setAutoCommit(false);
	    	
	    	//preberem id paketa
	    	String query = 	"select max(sifra)+1 as sifra from arso_paketi";
	    	
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(query);
	    	int sifra = 0;
	    	while (rs.next()) {
	    		sifra = rs.getInt("sifra");
	    	}
	    	String imePaketa = "arso_paket_"+sifra+".xml";
			if (skupina.equals("-1")) skupina = null;
	    	
	    	//kreiram nov paket
	    	query = 	"insert into arso_paketi (sifra, datum, od, do, sif_skup, potrjen, sif_upor, naziv, xml) " +
	    				"values (" + sifra + ",now(),'" + od_datum + "','" + od_datum + "'," + skupina + ",0," + sif_upor + ",'"+imePaketa+"','" + keyChecked.replaceAll("'", "") + "')";
	    	
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
			
			//pripravim xml datoteko
			Document doc = getEVL(keyChecked, tabela, sifra);
			if (doc == null) throw new Exception("napaka");

			//zapisem datoteko na disk
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(doc);
			StringWriter stringWriter = new StringWriter(); 
	        transformer.transform(source, new StreamResult(stringWriter)); 
	        System.out.println(stringWriter.toString());
	        
	        FileWriter fstream = new FileWriter(SAVE_FILES+imePaketa);
			BufferedWriter outFile = new BufferedWriter(fstream);
			outFile.write(stringWriter.toString());
			outFile.close();
			
			con.commit();
			
			return imePaketa;
	    } catch (Exception theException) {
	    	try{
	   		 if(con!=null) con.rollback();
	         }catch(SQLException se2){
	            se2.printStackTrace();
	         }
	    	theException.printStackTrace();
	    } finally {
	    	try{
	    		 con.setAutoCommit(true);
		         }catch(SQLException se2){
		            se2.printStackTrace();
		         }
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
	
}