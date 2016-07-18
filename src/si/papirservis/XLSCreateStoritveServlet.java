package si.papirservis;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Locale;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.w3c.dom.Document;


public class XLSCreateStoritveServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
	private static int rownum = 0;
	private static HSSFWorkbook wb;
	private static HSSFSheet s;
	private static String[] rowNames = {"Šifra", "Naziv", "Naslov", "Pošta", "Kraj", 
								"Datum opr. storitve", "Rok plačila", "Stroškovno mesto", "Odvoz cena", 
								"Uničevanje kol.", "Uničevanje cena", "Uničevanje vrednost", 
								"Odstrani kol.", "Odstrani cena", "Odstrani vrednost", 
								"Najem kol.", "Najem cena", "Najem vrednost" 
								};
	private static String[] rowTypes = {"S", "S", "S", "S", "S", 
								"S", "S", "S", "D", 
								"D", "D", "D", 
								"D", "D", "D", 
								"D", "D", "D"
								};
	 
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public XLSCreateStoritveServlet() {
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
		//request.setCharacterEncoding("UTF-8");
		System.out.println("POST");

		String datum_do = (String) request.getParameter("do_datum");
		String datum_od = (String) request.getParameter("od_datum");
		String sif_kupca = (String) request.getParameter("sif_kupca");
		if (sif_kupca == null || sif_kupca.equals(""))
			sif_kupca = "-1";
		String nadenota = (String) request.getParameter("nadenota");
		if (nadenota == null || nadenota.equals(""))
			nadenota = "Vse nadenote";
		String sif_enote = (String) request.getParameter("sif_enote");
		if (sif_enote == null || sif_enote.equals(""))
			sif_enote = "-1";
		String sif_skupine = (String) request.getParameter("sif_skupine");
		if (sif_skupine == null || sif_skupine.equals(""))
			sif_skupine = "-1";
		String leto = (String) request.getParameter("leto");
		

		
		String sql = "SELECT kupci.`sif_kupca` AS sif_kupca, " +
					     "kupci.`naziv` AS kupci_naziv, " +
					     "kupci.`naslov` AS kupci_naslov, " +
					     "kupci.`posta` AS kupci_posta, " +
					     "kupci.`kraj` AS kupci_kraj, " +
					     "kupci.`rok_placila` AS rok_placila, " +
					     "kupci.`stroskovno_mesto` AS stroskovno_mesto, " +
					     "'" + datum_do + "' datum_storitve," +
					     "sum(dob_unici.`cena`) AS odvoz_cena,  " +
						  "sum(dob_unici.`kg_zaup`) AS unici_kolicina, " + 
						  "SUM(dob_unici.`kg_zaup` * dob_unici.`sit_zaup`) / sum(dob_unici.`kg_zaup`) AS unici_cena,  " +
						  "SUM(dob_unici.`kg_zaup` * dob_unici.`sit_zaup`) AS unici_vrednost, " +
						  "sum(dob_odstrani.`kolicina`) AS odstrani_kolicina,  " +
						  "SUM(dob_odstrani.`kolicina` * dob_odstrani.`sit_smet`) / sum(dob_odstrani.`kolicina`) AS odstrani_cena,  " +
						  "SUM(dob_odstrani.`kolicina` * dob_odstrani.`sit_smet`) AS odstrani_vrednost, " +
						  "avg(najam.stranke_kom) as najem_kolicina, " +
						  "avg(najam.stranke_najem) as najem_cena, " +
						  "avg(najam.stranke_kom * najam.stranke_najem) as najem_vrednost		 " +
					"FROM kupci, skup, enote, dob"+leto+" dob_unici, dob"+leto+" dob_odstrani, (SELECT st_dob, pozicija, max(zacetek) datum  " +
																		"FROM dob"+leto+" dob  " +
																		"WHERE obdelana > 0 " +
																		"	AND dob.datum >= CAST('"+datum_od+"' AS DATE)  " +
																		"	AND dob.datum <= CAST('"+datum_do+"' AS DATE) " +
																		"group by st_dob, pozicija) zadnji, " +
					 			"(SELECT stranke.sif_kupca, " +
								"    			SUM(stranke.kol_os) as stranke_kom, " +
								"				SUM(stranke.cena_naj) as stranke_najem, " +
								"				SUM(stranke.kol_os * stranke.cena_naj) as stranke_vrednost " +
								"			FROM (SELECT stranke.* " +
								"				FROM stranke, (SELECT sif_str, max(zacetek) datum FROM stranke " +
								"			 	group by sif_str ) zadnji " +
								"				WHERE stranke.sif_str = zadnji.sif_str and " +
								"				      stranke.zacetek = zadnji.datum) stranke " +
								"			WHERE stranke.najem = 'D' " +
								"			group by sif_kupca) as najam	 " +											
					"WHERE ((kupci.sif_kupca = "+sif_kupca+") or (("+sif_kupca+" = -1))) and  " +
					"     kupci.skupina = skup.skupina and " +
					"     ((enote.nadenota = '"+nadenota+"') OR ('"+nadenota+"' = 'Vse nadenote')) and " +
					"	((enote.sif_enote = "+sif_enote+") or ("+sif_enote+" = -1)) and " +
					"	kupci.sif_enote = enote.sif_enote and " +
					"     ((skup.skupina = "+sif_skupine+") or ("+sif_skupine+" = -1)) and " +
					"     dob_unici.sif_kupca = kupci.sif_kupca and " +
					"	   dob_unici.st_dob = zadnji.st_dob and " +
					"      dob_unici.pozicija = zadnji.pozicija and " +
					"      dob_unici.zacetek = zadnji.datum and " +
					"	  dob_odstrani.sif_kupca = kupci.sif_kupca and " +
					"	  	dob_odstrani.st_dob = zadnji.st_dob and " +
					"      dob_odstrani.pozicija = zadnji.pozicija and " +
					"      dob_odstrani.zacetek = zadnji.datum and " +
					"      dob_odstrani.sit_smet != 0 and " +
					"		najam.sif_kupca = kupci.sif_kupca";


		
		try{
			System.out.println(sql);
			getXLS(sql);
			
			response.setContentType("application/octet-stream");
			response.setHeader("Content-disposition", "attachment; filename=zaracunavamo_storitve.xls");
			
			OutputStream out = response.getOutputStream();
			wb.write(out);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			e.printStackTrace();
			OutputStream out = response.getOutputStream();
			out.write("Napaka pri pripravi podatkov.".getBytes("utf-8"));
			out.flush();
			out.close();
		}
	
	}	
	

	private Document getXLS(String sql) {

    	Statement stmt = null;
    	ResultSet rs = null;

	    try {
	    	String xml = "";
	    	connectionMake();
	    	
			wb = new HSSFWorkbook();
			s = wb.createSheet();
			createXls();

			stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(sql);
	    	while (rs.next()) {
	    		String[] vrstica = {rs.getString("sif_kupca"), rs.getString("kupci_naziv"), rs.getString("kupci_naslov"), rs.getString("kupci_posta"), rs.getString("kupci_kraj"), 
	    							  rs.getString("rok_placila"), rs.getString("stroskovno_mesto"), rs.getString("datum_storitve"), rs.getString("odvoz_cena"), 
	    							  rs.getString("unici_kolicina"), rs.getString("unici_cena"), rs.getString("unici_vrednost"), 
	    							  rs.getString("odstrani_kolicina"), rs.getString("odstrani_cena"), rs.getString("odstrani_vrednost"), 
	    							  rs.getString("najem_kolicina"), rs.getString("najem_cena"), rs.getString("najem_vrednost")};

	    		createRow(vrstica);
	    	}
	    	
	    	return null;
	    	
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
	
	public static byte [] createRow(String[] rowData) throws Exception {
		HSSFRow r = null;
		// declare a cell object reference
		HSSFCell c = null;


		// write data
		r = s.createRow(rownum);
		
		for (short n=0; n<rowNames.length;n++) {
			c = r.createCell(n);

			HSSFCellStyle cs = wb.createCellStyle();
			HSSFDataFormat df = wb.createDataFormat();
			if (rowTypes[n].equals("D"))
				cs.setDataFormat(df.getFormat("#,##0.00"));
			else
				cs.setDataFormat(df.getFormat("#,##0"));

			c.setCellStyle(cs);
			Object v = rowData[n];
			if (v != null) {
				if (rowTypes[n].equals("S"))
					c.setCellValue(v.toString());
				else if (rowTypes[n].equals("N"))
					c.setCellValue(Integer.parseInt(v.toString()));
				else if (rowTypes[n].equals("D"))
					c.setCellValue(Double.parseDouble(v.toString()));
			} else {
				c.setCellValue("");
			}
		}
//		c.setCellStyle(cs);
		
		rownum++;

		return null;
	}

	public static byte [] createXls() throws Exception {
		// declare a row object reference
		HSSFRow r = null;
		// declare a cell object reference
		HSSFCell c = null;
		// create 2 cell styles
		HSSFCellStyle cs = wb.createCellStyle();
		//HSSFCellStyle cs2 = wb.createCellStyle();
		//HSSFDataFormat df = wb.createDataFormat();

		// create 2 fonts objects
		HSSFFont f = wb.createFont();
		//HSSFFont f2 = wb.createFont();

		// Set font 1 to 12 point type, blue and bold
		f.setFontHeightInPoints((short) 12);
		//f.setColor( HSSFColor.RED.index );
		f.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

		// Set font 2 to 10 point type, red and bold
		//f2.setFontHeightInPoints((short) 10);
		//f2.setColor( HSSFColor.RED.index );
		//f2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

		// Set cell style and formatting
		cs.setFont(f);
		//cs.setDataFormat(df.getFormat("#,##0.0"));

		// Set the other cell style and formatting
		//cs2.setBorderBottom(cs2.BORDER_THIN);
		//cs2.setDataFormat(HSSFDataFormat.getBuiltinFormat("text"));
		//cs2.setFont(f2);

		rownum = 0;
		
		// Define a few rows
		//Object[] mun = (Object[]) municipality.keySet().toArray();
		// write header
		r = s.createRow(rownum);
		for (short n=0; n<rowNames.length;n++) {
			c = r.createCell(n);
			c.setCellStyle(cs);
			if (rowNames[n].equals(""))
				c.setCellValue(new HSSFRichTextString("Neznano"));
			else	
				c.setCellValue(new HSSFRichTextString(rowNames[n]));
		}
		rownum++;		
		
		return null;

	}
}
