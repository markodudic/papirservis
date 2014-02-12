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


public class XLSCreateServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
	private static int rownum = 0;
	private static HSSFWorkbook wb;
	private static HSSFSheet s;
	private static String[] rowNames = {"Št. dobavnice", "Pozicija", "Datum", "Šifra stranke", "Naziv stranke",
										"Šifra kupca", "Naziv kupca", "Matična", "Skupina", "Enota", "Prevoz", "Koda", "Material", "EWC Koda", "Material", "Kamion",
										"Količina", "Cena", "Stroški", "Dod. stroški", "KM strošek", "Ure strošek", "Skupaj strošek"};
	private static String[] rowTypes = {"S", "N", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "N", "D", "D", "D", "D", "D", "D"};
	 
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public XLSCreateServlet() {
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

		String sql = (String) request.getParameter("sql").replace("XX", "'").replace("YY", "%");
		try{
			int l = sql.indexOf("LIMIT");
			int ll = sql.indexOf(")", l);
			sql = sql.substring(0, l) + sql.substring(ll);
			
			getXLS(sql);
			
			response.setContentType("application/octet-stream");
			response.setHeader("Content-disposition", "attachment; filename=dobavnice.xls");
			
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

			SimpleDateFormat from = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat to = new SimpleDateFormat("dd.MM.yyyy");
			
	    	stmt = con.createStatement();   	
	    	rs = stmt.executeQuery(sql);
	    	while (rs.next()) {
	    		String[] dobavnica = {rs.getString("st_dob"), rs.getString("pozicija"), to.format(from.parse(rs.getString("datum"))),
	    							  rs.getString("sif_str"), rs.getString("stranka"), rs.getString("sif_kupca"),
	    							  rs.getString("naziv"), rs.getString("maticna"), rs.getString("skupina_text"), rs.getString("naziv_enote"), rs.getInt("sif_kam")==0 ? "NE": "DA", 
	    							  rs.getString("koda"), rs.getString("material"), rs.getString("ewc"), rs.getString("okoljemat"), rs.getString("kamion"), 
	    							  rs.getString("kolicina"), rs.getString("cena"), rs.getString("stroski"), rs.getString("dod_stroski"), 
	    							  String.valueOf(rs.getDouble("stev_km")*rs.getDouble("cena_km")), String.valueOf(rs.getDouble("stev_ur")*rs.getDouble("cena_ura")),
	    							  String.valueOf(rs.getDouble("stroski")+rs.getDouble("dod_stroski")+(rs.getDouble("stev_km")*rs.getDouble("cena_km"))+(rs.getDouble("stev_ur")*rs.getDouble("cena_ura")))};
	    		createRow(dobavnica);
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
		
		for (int n=0; n<rowNames.length;n++) {
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
		for (int n=0; n<rowNames.length;n++) {
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
