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


public class XLSCreateKomunalaServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
	private static int rownum = 0;
	private static HSSFWorkbook wb;
	private static HSSFSheet s;
	private static String[] rowNames = {"Šifra", "Naziv", "Koda", "Združi", "Delež", 
								"Napoved jan", "Napoved feb", "Napoved mar", "Napoved apr", "Napoved maj", "Napoved jun", "Napoved jul", "Napoved avg", "Napoved sep", "Napoved okt", "Napoved nov", "Napoved dec",
								"Dejansko jan", "Dejansko feb", "Dejansko mar", "Dejansko apr", "Dejansko maj", "Dejansko jun", "Dejansko jul", "Dejansko avg", "Dejansko sep", "Dejansko okt", "Dejansko nov", "Dejansko dec",
								"Prevzeto nalogi", "Plan prevzema", "Trenutno za prevzeti"};
	private static String[] rowTypes = {"S", "S", "S", "S", "D", 
								"D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D",
								"D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D",
								"D", "D", "D"
								};
	 
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public XLSCreateKomunalaServlet() {
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

		String param1 = (String) request.getParameter("param1");
		String datum_od = (String) request.getParameter("datum_od");
		String datum_fm = (String) request.getParameter("datum_fm");
		String mesec = (String) request.getParameter("mesec");
		String dodatni_mesec = (String) request.getParameter("dodatni_mesec");
		
		String caseStr = " CASE month(CAST('"+datum_od+"' AS DATE)) " +
				" WHEN 1 THEN 0 " +
				" WHEN 2 THEN IFNULL(((IFNULL(dej_jan,kol_jan)) * delez/100),0)  " +
				" WHEN 3 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)) * delez/100),0)  " +
				" WHEN 4 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)) * delez/100),0)  " +
				" WHEN 5 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)+ IFNULL(dej_apr,kol_apr)) * delez/100),0)  " +
				" WHEN 6 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)+ IFNULL(dej_apr,kol_apr)+ IFNULL(dej_maj,kol_maj)) * delez/100),0) " +
				" WHEN 7 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)+ IFNULL(dej_apr,kol_apr)+ IFNULL(dej_maj,kol_maj)+ IFNULL(dej_jun,kol_jun)) * delez/100),0)  " +
				" WHEN 8 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)+ IFNULL(dej_apr,kol_apr)+ IFNULL(dej_maj,kol_maj)+ IFNULL(dej_jun,kol_jun)+ IFNULL(dej_jul,kol_jul)) * delez/100),0) " +
				" WHEN 9 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)+ IFNULL(dej_apr,kol_apr)+ IFNULL(dej_maj,kol_maj)+ IFNULL(dej_jun,kol_jun)+ IFNULL(dej_jul,kol_jul)+ IFNULL(dej_avg,kol_avg)) * delez/100),0)  " +
				" WHEN 10 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)+ IFNULL(dej_apr,kol_apr)+ IFNULL(dej_maj,kol_maj)+ IFNULL(dej_jun,kol_jun)+ IFNULL(dej_jul,kol_jul)+ IFNULL(dej_avg,kol_avg)+ IFNULL(dej_sep,kol_sep)) * delez/100),0)  " +
				" WHEN 11 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)+ IFNULL(dej_apr,kol_apr)+ IFNULL(dej_maj,kol_maj)+ IFNULL(dej_jun,kol_jun)+ IFNULL(dej_jul,kol_jul)+ IFNULL(dej_avg,kol_avg)+ IFNULL(dej_sep,kol_sep)+ IFNULL(dej_okt,kol_okt)) * delez/100),0)  " +
				" WHEN 12 THEN IFNULL(((IFNULL(dej_jan,kol_jan)+ IFNULL(dej_feb,kol_feb)+ IFNULL(dej_mar,kol_mar)+ IFNULL(dej_apr,kol_apr)+ IFNULL(dej_maj,kol_maj)+ IFNULL(dej_jun,kol_jun)+ IFNULL(dej_jul,kol_jul)+ IFNULL(dej_avg,kol_avg)+ IFNULL(dej_sep,kol_sep)+ IFNULL(dej_okt,kol_okt)+ IFNULL(dej_nov,kol_nov)) * delez/100),0) " +
				" END prevzeto_od, ";

		String caseStr1 = " CASE if(month(CAST('"+datum_fm+"' AS DATE)) + " + dodatni_mesec + " > 12, 12, month(CAST('"+datum_fm+"' AS DATE)) + " + dodatni_mesec + ") "+
				" WHEN 1 THEN IFNULL(((if("+mesec+"=1,ifnull(dej_jan,kol_jan),kol_jan)) * delez/100),0) " +
				" WHEN 2 THEN IFNULL(((ifnull(dej_jan,kol_jan)+if("+mesec+"=1,ifnull(dej_feb,kol_feb),kol_feb)) * delez/100),0) " +
				" WHEN 3 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+if("+mesec+"=1,ifnull(dej_mar,kol_mar),kol_mar)) * delez/100),0) " +
				" WHEN 4 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+if("+mesec+"=1,ifnull(dej_apr,kol_apr),kol_apr)) * delez/100),0) " +
				" WHEN 5 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+if("+mesec+"=1,ifnull(dej_maj,kol_maj),kol_maj)) * delez/100),0) " +
				" WHEN 6 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+if("+mesec+"=1,ifnull(dej_jun,kol_jun),kol_jun)) * delez/100),0) " +
				" WHEN 7 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+if("+mesec+"=1,ifnull(dej_jul,kol_jul),kol_jul)) * delez/100),0) " +
				" WHEN 8 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+if("+mesec+"=1,ifnull(dej_avg,kol_avg),kol_avg)) * delez/100),0) " +
				" WHEN 9 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+ifnull(dej_avg,kol_avg)+if("+mesec+"=1,ifnull(dej_sep,kol_sep),kol_sep)) * delez/100),0) " +
				" WHEN 10 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+ifnull(dej_avg,kol_avg)+ifnull(dej_sep,kol_sep)+if("+mesec+"=1,ifnull(dej_okt,kol_okt),kol_okt)) * delez/100),0) " +
				" WHEN 11 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+ifnull(dej_avg,kol_avg)+ifnull(dej_sep,kol_sep)+ifnull(dej_okt,kol_okt)+if("+mesec+"=1,ifnull(dej_nov,kol_nov),kol_nov)) * delez/100),0) " +
				" WHEN 12 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+ifnull(dej_avg,kol_avg)+ifnull(dej_sep,kol_sep)+ifnull(dej_okt,kol_okt)+ifnull(dej_nov,kol_nov)+if("+mesec+"=1,ifnull(dej_dec,kol_dec),kol_dec)) * delez/100),0) " +
				" END prevzeto ";

		
		try{
			String sql = param1.replaceAll("caseStr1", caseStr1);
			sql = sql.replaceAll("caseStr", caseStr);
			System.out.println(sql);
			getXLS(sql);
			
			response.setContentType("application/octet-stream");
			response.setHeader("Content-disposition", "attachment; filename=komunale.xls");
			
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
	    		String[] vrstica = {rs.getString("sif_kupca"), rs.getString("naziv"), rs.getString("koda"), rs.getString("zdruzi"), rs.getString("delez"), 
	    							  rs.getString("kol_jan"), rs.getString("kol_feb"), rs.getString("kol_mar"), rs.getString("kol_apr"), rs.getString("kol_maj"), rs.getString("kol_jun"), rs.getString("kol_jul"), rs.getString("kol_avg"), rs.getString("kol_sep"), rs.getString("kol_okt"), rs.getString("kol_nov"), rs.getString("kol_dec"), 
	    							  rs.getString("dej_jan"), rs.getString("dej_feb"), rs.getString("dej_mar"), rs.getString("dej_apr"), rs.getString("dej_maj"), rs.getString("dej_jun"), rs.getString("dej_jul"), rs.getString("dej_avg"), rs.getString("dej_sep"), rs.getString("dej_okt"), rs.getString("dej_nov"), rs.getString("dej_dec"), 
	    							  rs.getString("zbrano"), rs.getString("prevzeto"), rs.getString("za_prevzeti")};

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
