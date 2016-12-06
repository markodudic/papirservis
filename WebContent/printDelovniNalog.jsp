<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,
		     java.util.*,java.sql.Connection,java.sql.DriverManager,
		     net.sf.jasperreports.engine.JRException,
			net.sf.jasperreports.engine.JRExporterParameter,	
			net.sf.jasperreports.engine.JasperCompileManager,
			net.sf.jasperreports.engine.JasperFillManager,
			net.sf.jasperreports.engine.JasperPrint,
			net.sf.jasperreports.engine.JasperReport,
			net.sf.jasperreports.engine.design.JasperDesign,
			net.sf.jasperreports.engine.export.JRHtmlExporter,
			net.sf.jasperreports.engine.export.JRHtmlExporterParameter,
			net.sf.jasperreports.engine.export.JRPdfExporter,
			net.sf.jasperreports.engine.export.JRPdfExporterParameter,
			net.sf.jasperreports.engine.export.JRRtfExporter,
			net.sf.jasperreports.engine.export.JRXlsExporterParameter,
			net.sf.jasperreports.engine.export.JRXlsExporter,
			net.sf.jasperreports.engine.JasperRunManager,
			net.sf.jasperreports.engine.xml.JRXmlLoader,
			java.io.ByteArrayOutputStream"%>

<html>
<head>
<title>Print delovni nalog</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="GENERATOR" content="Rational Application Developer">
</head>
<body>

<script language="JavaScript" src="ew.js"/>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>
<% Locale locale = Locale.getDefault(); %>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
    String report = request.getParameter("report");
	int reportID = Integer.parseInt(request.getParameter("reportID"));
	String type = request.getParameter("type");

    Map parameters = new HashMap();
    
	String potnik = (String) session.getAttribute("papirservis1_status_UserID");
	parameters.put("potnik", potnik);

	String x_sif_dob = request.getParameter("x_sif_dob");
	if ((x_sif_dob != null) && (x_sif_dob != ""))
		parameters.put("st_dob", new Integer(x_sif_dob));

    String x_sif_kupca = request.getParameter("x_sif_kupca");
    if ((x_sif_kupca != null) && (x_sif_kupca != ""))
    {
   		parameters.put("sif_str", x_sif_kupca);
    }
	else
	{
		parameters.put("sif_str", "-1");
		x_sif_kupca = "-1"; 
	}

    String sif_zavezanca = request.getParameter("x_sif_zavezanca");
    if ((sif_zavezanca != null) && (sif_zavezanca != ""))
    {
   		parameters.put("sif_zavezanca", sif_zavezanca);
    }
	else
	{
		parameters.put("sif_zavezanca", "-1");
	}
    
    String x_sif_enote = request.getParameter("x_sif_enote");
	if ((x_sif_enote != null) && (x_sif_enote != ""))
	{
		String naziv_enote = "";
		String sqlwrk_enote = "SELECT naziv FROM enote where sif_enote = " + x_sif_enote;
		Statement stmtwrk_enote = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_enote = stmtwrk_enote.executeQuery(sqlwrk_enote);
		
		while (rswrk_enote.next()) {
			naziv_enote = rswrk_enote.getString(1);
		}
		rswrk_enote.close();
		rswrk_enote = null;
		stmtwrk_enote.close();
		stmtwrk_enote = null;

		parameters.put("sif_enote", new Integer(x_sif_enote));
		parameters.put("naziv_enote", naziv_enote);
	}
	else
	{
		parameters.put("sif_enote", new Integer("-1"));
		parameters.put("naziv_enote", "Vse enote");
		x_sif_enote = "-1";
	}
		

    String x_sif_skupine = request.getParameter("x_sif_skupine");
	if ((x_sif_skupine != null) && (x_sif_skupine != ""))
	{
		String naziv_skupine = "";
		String sqlwrk_skupine = "SELECT tekst FROM skup where skupina = " + x_sif_skupine;
		Statement stmtwrk_skupine = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_skupine = stmtwrk_skupine.executeQuery(sqlwrk_skupine);
		
		while (rswrk_skupine.next()) {
			naziv_skupine = rswrk_skupine.getString(1);
		}
		rswrk_skupine.close();
		rswrk_skupine = null;
		stmtwrk_skupine.close();
		stmtwrk_skupine = null;

		parameters.put("sif_skupine", new Integer(x_sif_skupine));
		parameters.put("naziv_skupine", naziv_skupine);
	}
	else
	{
		parameters.put("sif_skupine", new Integer("-1"));
		parameters.put("naziv_skupine", "Vse skupine");
		x_sif_skupine = "-1";
	}

    String x_sif_potnik = request.getParameter("x_sif_potnik");
	if ((x_sif_potnik != null) && (x_sif_potnik != ""))
	{
		String naziv_potnika = "";
		String sqlwrk_potnik = "SELECT ime_in_priimek FROM uporabniki where sif_upor = " + x_sif_potnik;
		Statement stmtwrk_potnik = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_potnik = stmtwrk_potnik.executeQuery(sqlwrk_potnik);
		
		while (rswrk_potnik.next()) {
			naziv_potnika = rswrk_potnik.getString(1);
		}
		rswrk_potnik.close();
		rswrk_potnik = null;
		stmtwrk_potnik.close();
		stmtwrk_potnik = null;

		parameters.put("sif_potnik", new Integer(x_sif_potnik));
		parameters.put("naziv_potnik", naziv_potnika);
	}
	else
	{
		parameters.put("sif_potnik", new Integer("-1"));
		parameters.put("naziv_potnik", "Vsi potniki");
		x_sif_potnik = "-1";
	}
	
    String x_sif_osnovna = request.getParameter("x_sif_osnovna");
	if ((x_sif_osnovna != null) && (x_sif_osnovna != ""))
	{
		String naziv_osnovna = "";
		String sqlwrk_osnovna = "SELECT osnovna FROM osnovna where sif_os = '" + x_sif_osnovna + "'";
	
		Statement stmtwrk_osnovna = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_osnovna = stmtwrk_osnovna.executeQuery(sqlwrk_osnovna);
		
		while (rswrk_osnovna.next()) {
			naziv_osnovna = rswrk_osnovna.getString(1);
		}
		rswrk_osnovna.close();
		rswrk_osnovna = null;
		stmtwrk_osnovna.close();
		stmtwrk_osnovna = null;

		parameters.put("sif_osnovna", x_sif_osnovna);
		parameters.put("naziv_osnovna", naziv_osnovna);
	}
	else
	{
		parameters.put("sif_osnovna", "-1");
		parameters.put("naziv_osnovna", "Vsa osnovna");
	}

	
    String x_sif_kamioni = request.getParameter("x_sif_kamioni");
	if ((x_sif_kamioni != null) && (x_sif_kamioni != ""))
	{
		String naziv_kamion = "";
		String sqlwrk_kamioni = "SELECT kamion FROM kamion where sif_kam = '" + x_sif_kamioni + "'";
	
		Statement stmtwrk_kamioni = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_kamioni = stmtwrk_kamioni.executeQuery(sqlwrk_kamioni);
		
		while (rswrk_kamioni.next()) {
			naziv_kamion = rswrk_kamioni.getString(1);
		}
		rswrk_kamioni.close();
		rswrk_kamioni = null;
		stmtwrk_kamioni.close();
		stmtwrk_kamioni = null;

		parameters.put("sif_kamion", new Integer(x_sif_kamioni));
		parameters.put("naziv_kamion", naziv_kamion);
	}
	else
	{
		parameters.put("sif_kamion", new Integer("-1"));
		parameters.put("naziv_kamion", "Vsi kamioni");
	}


    String x_sif_vozniki = request.getParameter("x_sif_vozniki");
	if ((x_sif_vozniki != null) && (x_sif_vozniki != ""))
	{
		String naziv_vozniki = "";
		String sqlwrk_vozniki = "SELECT sofer FROM sofer where sif_sof = '" + x_sif_vozniki + "'";
	
		Statement stmtwrk_vozniki = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_vozniki = stmtwrk_vozniki.executeQuery(sqlwrk_vozniki);
		
		while (rswrk_vozniki.next()) {
			naziv_vozniki = rswrk_vozniki.getString(1);
		}
		rswrk_vozniki.close();
		rswrk_vozniki = null;
		stmtwrk_vozniki.close();
		stmtwrk_vozniki = null;

		parameters.put("sif_sofer", new Integer(x_sif_vozniki));
		parameters.put("naziv_sofer", naziv_vozniki);
	}
	else
	{
		parameters.put("sif_sofer", new Integer("-1"));
		parameters.put("naziv_sofer", "Vsi vozniki");
	}

	
	
	
    String od_datum = request.getParameter("od_datum");
    String do_datum = request.getParameter("do_datum");
	if ((od_datum != null) && (do_datum != null) && (od_datum != "")&& (do_datum != ""))
	{
		parameters.put("od_datum", (EW_UnFormatDateTime((String)od_datum,"EURODATE", locale)).toString());	
		parameters.put("do_datum", (EW_UnFormatDateTime((String)do_datum,"EURODATE", locale)).toString());
		parameters.put("od_datum_str", od_datum);	
		parameters.put("do_datum_str", do_datum);
	}

	if (reportID == 4)
	{
		parameters.put("brez_cen", "0");
	}
	else if (reportID == 15)
	{
		parameters.put("brez_cen", "1");
	}
	
	if (reportID == 20)
	{
	    String obdelana = request.getParameter("obdelana");
	    parameters.put("obdelana", obdelana);
		 if (obdelana.equals("1")) {
			 parameters.put("naziv_obdelana", "Odprti");
		 } else {
			 parameters.put("naziv_obdelana", "Vsi");
		 }
	}
	
	if (reportID == 22)
	{
	    String razred = request.getParameter("razred");
	    parameters.put("razred", razred);
	    String blokada = request.getParameter("blokada");
	    parameters.put("blokada", blokada);
		 if (blokada.equals("1")) {
			 parameters.put("blokada_naziv", "Da");
		 } else {
			 parameters.put("blokada_naziv", "Ne");
		 }
			 
	}

	if (reportID == 24)
	{
	    String brezKoda = request.getParameter("brezKoda");
	    parameters.put("brezKoda", brezKoda);
	}

	if ((reportID == 2) || (reportID == 4) || (reportID == 12) || (reportID == 14) || (reportID == 15) || (reportID == 18) || (reportID == 22) || (reportID == 24) || (reportID == 31))
	{
	    String nadenota = request.getParameter("x_sif_nadenote");
		 if ((nadenota != null) && (nadenota != "")) {
	    	parameters.put("nadenota", nadenota);
		 } else {
		    	parameters.put("nadenota", "Vse nadenote");			 
		 }
	}


	if ((reportID == 25) || (reportID == 28))
	{
	    String opravljena_storitva = request.getParameter("opravljena_storitva");
		if (opravljena_storitva != null)
		{
			parameters.put("opravljena_storitva", (EW_UnFormatDateTime((String)opravljena_storitva,"EURODATE", locale)).toString());	
			parameters.put("opravljena_storitva_str", opravljena_storitva);	
		}
	    String datum_racuna = request.getParameter("datum_racuna");
		if (datum_racuna != null)
		{
			parameters.put("datum_racuna", (EW_UnFormatDateTime((String)datum_racuna,"EURODATE", locale)).toString());	
			parameters.put("datum_racuna_str", datum_racuna);	
		}
		
	    String stroskovno_mesto = request.getParameter("stroskovno_mesto");
	    parameters.put("stroskovno_mesto", stroskovno_mesto);
		
	    String nacin_obracuna = request.getParameter("nacin_obracuna");
	    parameters.put("nacin_obracuna", nacin_obracuna);

	    String racun = request.getParameter("racun");
	    parameters.put("racun", racun);
		 if (racun.equals("0")) {
			 parameters.put("naziv_racun", "obračun");
		 } else if (racun.equals("1")) {
			 parameters.put("naziv_racun", "poračun");
		 } else {
			 parameters.put("naziv_racun", "pavšal");
		 }
		
	}

	if ((reportID == 26) || (reportID == 27) || (reportID == 29) || (reportID == 30))
	{	
	    String kumulativa = request.getParameter("kumulativa");
	    if (kumulativa!=null && kumulativa.equals("da")) {
			report += "_kumulativa";
			
	    }

	    String nacin_obracuna = request.getParameter("nacin_obracuna_list");
	    parameters.put("nacin_obracuna", nacin_obracuna);

	    od_datum="01.01." + session.getAttribute("leto");
	    do_datum="31.12." + session.getAttribute("leto");
	    String od_datum_q1="01.01." + session.getAttribute("leto");
	    String do_datum_q1="31.03." + session.getAttribute("leto");
	    String od_datum_q2="01.04." + session.getAttribute("leto");
	    String do_datum_q2="30.06." + session.getAttribute("leto");
	    String od_datum_q3="01.07." + session.getAttribute("leto");
	    String do_datum_q3="30.09." + session.getAttribute("leto");
	    String od_datum_q4="01.10." + session.getAttribute("leto");
	    String do_datum_q4="31.12." + session.getAttribute("leto");
	    
	    parameters.put("od_datum", (EW_UnFormatDateTime((String)od_datum,"EURODATE", locale)).toString());	
		parameters.put("do_datum", (EW_UnFormatDateTime((String)do_datum,"EURODATE", locale)).toString());
    	parameters.put("od_datum_q1", (EW_UnFormatDateTime((String)od_datum_q1,"EURODATE", locale)).toString());	
		parameters.put("do_datum_q1", (EW_UnFormatDateTime((String)do_datum_q1,"EURODATE", locale)).toString());
    	parameters.put("od_datum_q2", (EW_UnFormatDateTime((String)od_datum_q2,"EURODATE", locale)).toString());	
		parameters.put("do_datum_q2", (EW_UnFormatDateTime((String)do_datum_q2,"EURODATE", locale)).toString());
    	parameters.put("od_datum_q3", (EW_UnFormatDateTime((String)od_datum_q3,"EURODATE", locale)).toString());	
		parameters.put("do_datum_q3", (EW_UnFormatDateTime((String)do_datum_q3,"EURODATE", locale)).toString());
    	parameters.put("od_datum_q4", (EW_UnFormatDateTime((String)od_datum_q4,"EURODATE", locale)).toString());	
		parameters.put("do_datum_q4", (EW_UnFormatDateTime((String)do_datum_q4,"EURODATE", locale)).toString());
		
		if (Integer.parseInt(type) == 4)
			parameters.put("xls", "1");
		else
			parameters.put("xls", "0");
	}	
	
	//če je bianco dobavnica preberem naslednjo stevilko in stevilo bianco dobavnic ter obstojeco sifro povecam za stevilo
    String x_stev_bianco = request.getParameter("x_stev_bianco");
	if ((x_stev_bianco != null) && (x_stev_bianco != ""))
		parameters.put("stevBianco", new Integer(x_stev_bianco));

	int biancoSifra = 0;
	if (reportID == 1)
	{
		String sqlwrk_bianco = "SELECT st_dob FROM dob_bianco where id = '" + session.getAttribute("letoTabela") + "'";
		Statement stmtwrk_bianco = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_bianco = stmtwrk_bianco.executeQuery(sqlwrk_bianco);
		
		int rowcntwrk_x_sif_kupca = 0;
		while (rswrk_bianco.next()) {
			biancoSifra = rswrk_bianco.getInt(1);
		}
		rswrk_bianco.close();
		rswrk_bianco = null;
		stmtwrk_bianco.close();
		stmtwrk_bianco = null;
		
		String sqlwrk_bianco_u = "UPDATE dob_bianco set st_dob = st_dob + " + x_stev_bianco + " where id = '" + session.getAttribute("letoTabela") + "'";
		Statement stmtwrk_bianco_u = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		stmtwrk_bianco_u.executeUpdate(sqlwrk_bianco_u);
		stmtwrk_bianco_u.close();
		stmtwrk_bianco_u = null;		
	}
	parameters.put("biancoSifra", new Integer(biancoSifra));



	/*int evListSifra = 0;
	if (reportID == 13)
	{
		String sqlwrk_evList = "SELECT st_lista FROM evid_list";
		Statement stmtwrk_evList = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_evList = stmtwrk_evList.executeQuery(sqlwrk_evList);
		
		int rowcntwrk_x_sif_kupca = 0;
		while (rswrk_evList.next()) {
			evListSifra = rswrk_evList.getInt(1);
		}
		rswrk_evList.close();
		rswrk_evList = null;
		stmtwrk_evList.close();
		stmtwrk_evList = null;
		
		//dolocim kolk bo evidencnih listov
		String sqlwrk_evList_c  = "select count(*) "+
						"from " + session.getAttribute("letoTabela") + " dob  "+
						" left join materiali on (dob.koda = materiali.koda) "+
						" left join material_okolje on (dob.koda = material_okolje.material_koda), "+
						" kupci, skup, enote "+
						"where ((dob.sif_kupca = " + x_sif_kupca + ") or (" + x_sif_kupca + " = -1)) and "+
						"      dob.datum >= CAST('" + (EW_UnFormatDateTime((String)od_datum,"EURODATE", locale)).toString() + "' AS DATE) AND  "+
						"     dob.datum <= CAST('" + (EW_UnFormatDateTime((String)do_datum,"EURODATE", locale)).toString() + "' AS DATE) and "+
						"     dob.sif_kupca = kupci.sif_kupca and "+
						"     kupci.sif_enote = enote.sif_enote and "+
						"     ((enote.sif_enote = " + x_sif_enote + ") or (" + x_sif_enote + " = -1)) and "+
						"     kupci.skupina = skup.skupina and "+
						"     ((skup.skupina = " + x_sif_skupine + ") or (" + x_sif_skupine + " = -1)) ";

		Statement stmtwrk_evList_c = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_evList_c = stmtwrk_evList_c.executeQuery(sqlwrk_evList_c);
		
		int x_stev_evList = 0;
		while (rswrk_evList_c.next()) {
			x_stev_evList = rswrk_evList_c.getInt(1);
		}
		rswrk_evList_c.close();
		rswrk_evList_c = null;
		stmtwrk_evList_c.close();
		stmtwrk_evList_c = null;
     
		
		/*String sqlwrk_evList_u = "UPDATE evid_list set st_lista = st_lista + " + x_stev_evList;
		Statement stmtwrk_evList_u = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		stmtwrk_evList_u.executeUpdate(sqlwrk_evList_u);
		stmtwrk_evList_u.close();
		stmtwrk_evList_u = null;		
	}
	parameters.put("evListSifra", new Integer(evListSifra));*/
	
	parameters.put("leto", session.getAttribute("leto"));
	parameters.put("dobLeto", session.getAttribute("letoTabela"));
	parameters.put("prodajaLeto", session.getAttribute("letoTabelaProdaja"));
	
	/*if (reportID == 14)
	{
		String sort = request.getParameter("sort");
		parameters.put("sort", sort);
	}*/

	if ((reportID != 13) || (reportID == 19))
	{
		String reportDir = getServletContext().getInitParameter("reportDir");
		parameters.put("SUBREPORT_DIR", reportDir);
	}

	if (reportID == 23)
	{
		String sort = request.getParameter("sort");
		parameters.put("sort", sort);
	}
	
	try
    {
    	if (Integer.parseInt(type) == 1) //PDF
        {
        	if ((reportID != 25) && (reportID != 28)) {
        		parameters.put("picture", getServletContext().getInitParameter("logoPdf"));
        	}
        	else {
        		parameters.put("picture", getServletContext().getInitParameter("logoRecikelPdf"));
        	}
                  	
            if ((reportID != 13) && (reportID != 19) && (reportID != 25) && (reportID != 26) && (reportID != 27) && (reportID != 28) && (reportID != 29) && (reportID != 30))
        	{   		
                InputStream reportStream = getServletConfig().getServletContext().getResourceAsStream(report+".jasper");
				response.setContentType("application/pdf");
				JasperRunManager.runReportToPdfStream(reportStream, response.getOutputStream(), parameters, conn );				
        	}
        	else
        	{   	
                InputStream reportStream = getServletConfig().getServletContext().getResourceAsStream(report+".jrxml");
                JasperDesign jasperDesign = JRXmlLoader.load(reportStream );
                JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);
	    		JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, conn);		
                JRPdfExporter exporter = new JRPdfExporter();
				ByteArrayOutputStream pdfReport = new ByteArrayOutputStream();
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
				exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, pdfReport);
	
                try {
					exporter.exportReport();
				} catch (JRException e) {
					e.printStackTrace();
				}
	
                byte[] pdfasbytes = pdfReport.toByteArray();
				response.setContentType("application/pdf");
				response.setContentLength(pdfasbytes.length);
				ServletOutputStream ouputStream = response.getOutputStream();
				ouputStream.write(pdfasbytes, 0, pdfasbytes.length);
        	}
        }
        else if (Integer.parseInt(type) == 2) //HTML
        {
        	if ((reportID != 25) && (reportID != 28)) {
        		parameters.put("picture", getServletContext().getInitParameter("logoPdf"));
        	}
        	else {
        		parameters.put("picture", getServletContext().getInitParameter("logoRecikelPdf"));
        	}
 
			JRHtmlExporter exporter = new JRHtmlExporter();
	
	    	InputStream reportStream = getServletConfig().getServletContext().getResourceAsStream(report+".jrxml");
			JasperDesign jasperDesign = JRXmlLoader.load(reportStream );
			JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, conn);		
	    
			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_WRITER,	response.getWriter());
			exporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "UTF-8");
			
			String destino = (String) getServletConfig().getServletContext().getResource("/images").toString();

			exporter.setParameter(JRHtmlExporterParameter.IS_OUTPUT_IMAGES_TO_DIR, Boolean.TRUE);
			exporter.setParameter(JRHtmlExporterParameter.IS_USING_IMAGES_TO_ALIGN, Boolean.FALSE); 
			
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_DIR_NAME,destino); 
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, destino);
	
	  		try {
				exporter.exportReport();
			} catch (JRException e) {
				e.printStackTrace();
			}
        }
	    else if (Integer.parseInt(type) == 3) //RTF
	    {
			JRRtfExporter exporter = new JRRtfExporter();
			response.setContentType("application/rtf");
	
	    	InputStream reportStream = getServletConfig().getServletContext().getResourceAsStream(report+".jrxml");
			JasperDesign jasperDesign = JRXmlLoader.load(reportStream );
			JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, conn);		
	    
			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_WRITER,	response.getWriter());
			exporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "UTF-8");
	  		try {
				exporter.exportReport();
			} catch (JRException e) {
				e.printStackTrace();
			}
	    	
	    }
	    else if (Integer.parseInt(type) == 4) //XLS
	    {
	    	JRXlsExporter exporter = new JRXlsExporter();
			//response.setContentType("application/vnd.ms-excel");
	    	InputStream reportStream = getServletConfig().getServletContext().getResourceAsStream(report+".jrxml");
	    	JasperDesign jasperDesign = JRXmlLoader.load(reportStream );
			JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);
	  		JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, conn);		
			
			ByteArrayOutputStream output = new ByteArrayOutputStream();
	        
			exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, output);
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "UTF-8");
			
	        //Excel specific parameter
	        exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
	        exporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
	        exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
	        exporter.setParameter(JRXlsExporterParameter.SHEET_NAMES, new String[]{"porocilo"}); 
	        
	    	try {
				exporter.exportReport();

				String f = "EmabalazaPorocilo.xls";
				String kumulativa = request.getParameter("kumulativa");
			    if (kumulativa != null) {
					if (kumulativa.equals("ne")) {
				    	f = "EmabalazaPorocilo_"+sif_zavezanca.replace("/", "_").replace("-1", "vse")+".xls";
				    }
				    else {
				    	f = "EmabalazaPorocilo_kumulativa.xls";
				    }
			    }
			    else {
			    	f = "EmabalazaRekapitulacija_"+sif_zavezanca.replace("/", "_").replace("-1", "vse")+".xls";			    	
			    }
			    response.setHeader("Content-Disposition","attachment; filename=\""+f+"\"");
				response.setContentType("application/vnd.ms-excel");
		        ServletOutputStream ouputStream = response.getOutputStream();
		        ouputStream.write(output.toByteArray());
			} catch (JRException e) {
				e.printStackTrace();
			}
	    }
        
        response.getOutputStream().flush();
        response.getOutputStream().close(); 
    }
    catch (JRException e)
    {
    	e.printStackTrace();
    	// display stack trace in the browser
      StringWriter stringWriter = new StringWriter();
      PrintWriter printWriter = new PrintWriter(stringWriter);
      e.printStackTrace(printWriter);
      response.setContentType("text/plain");
      response.getOutputStream().print(stringWriter.toString());
    }
%>

</body>

</html>
