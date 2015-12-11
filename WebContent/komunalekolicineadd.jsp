<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="komunalekolicinelist.jsp"%>
<%@ page contentType="text/html; charset=utf-8" %>
<% Locale locale = Locale.getDefault();
/*response.setLocale(locale);*/%>
<% session.setMaxInactiveInterval(30*60); %>
<% 
String login = (String) session.getAttribute("papirservis1_status");
if (login == null || !login.equals("login")) {
response.sendRedirect("login.jsp");
response.flushBuffer(); 
return; 
}%>
<% 

// user levels
final int ewAllowAdd = 1;
final int ewAllowDelete = 2;
final int ewAllowEdit = 4;
final int ewAllowView = 8;
final int ewAllowList = 8;
final int ewAllowSearch = 8;
final int ewAllowAdmin = 16;
int [] ew_SecTable = new int[3+1];
ew_SecTable[0] = 15;
ew_SecTable[1] = 13;
ew_SecTable[2] = 15;
ew_SecTable[3] = 8;

// get current table security
int ewCurSec = 0; // initialise
ewCurSec = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();
if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("komunalekolicinelist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("utf-8");

// Get action
String a = request.getParameter("a");
String key = "";
if (a == null || a.length() == 0) {
	key = request.getParameter("key");
	if (key != null && key.length() > 0) {
		a = "C"; // Copy record
	} else {
		a = "I"; // Display blank record
	}
}
String x_id = "";

String x_sif_kupca = "";
String x_naziv = "";
String x_koda = "";
String x_material = "";
String x_zdruzi = "";
String x_delez = "";
String x_kol_jan = "";
String x_kol_feb = "";
String x_kol_mar = "";
String x_kol_apr = "";
String x_kol_maj = "";
String x_kol_jun = "";
String x_kol_jul = "";
String x_kol_avg = "";
String x_kol_sep = "";
String x_kol_okt = "";
String x_kol_nov = "";
String x_kol_dec = "";
String x_dej_jan = "";
String x_dej_feb = "";
String x_dej_mar = "";
String x_dej_apr = "";
String x_dej_maj = "";
String x_dej_jun = "";
String x_dej_jul = "";
String x_dej_avg = "";
String x_dej_sep = "";
String x_dej_okt = "";
String x_dej_nov = "";
String x_dej_dec = "";

Object x_zacetek = null;
String x_uporabnik = "";

StringBuffer x_naslovList = null;

// Open Connection to the database
try{ 
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabelaKomunale") + "  WHERE `id`=" + tkey;
		
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("komunalekolicinelist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

		if (rs.getString("sif_kupca") != null){
			x_sif_kupca = rs.getString("sif_kupca");
		}else{
			x_sif_kupca = "";
		}
		
		if (rs.getString("koda") != null){
			x_koda = rs.getString("koda");
		}else{
			x_koda = "";
		}	

		if (rs.getString("zdruzi") != null){
			x_zdruzi = rs.getString("zdruzi");
		}else{
			x_zdruzi = "";
		}	

		x_delez = String.valueOf(rs.getDouble("delez"));
		x_kol_jan = String.valueOf(rs.getDouble("kol_jan"));
		x_kol_feb = String.valueOf(rs.getDouble("kol_feb"));
		x_kol_mar = String.valueOf(rs.getDouble("kol_mar"));
		x_kol_apr = String.valueOf(rs.getDouble("kol_apr"));
		x_kol_maj = String.valueOf(rs.getDouble("kol_maj"));
		x_kol_jun = String.valueOf(rs.getDouble("kol_jun"));
		x_kol_jul = String.valueOf(rs.getDouble("kol_jul"));
		x_kol_avg = String.valueOf(rs.getDouble("kol_avg"));
		x_kol_sep = String.valueOf(rs.getDouble("kol_sep"));
		x_kol_okt = String.valueOf(rs.getDouble("kol_okt"));
		x_kol_nov = String.valueOf(rs.getDouble("kol_nov"));
		x_kol_dec = String.valueOf(rs.getDouble("kol_dec"));
		x_dej_jan = String.valueOf(rs.getDouble("dej_jan"));
		x_dej_feb = String.valueOf(rs.getDouble("dej_feb"));
		x_dej_mar = String.valueOf(rs.getDouble("dej_mar"));
		x_dej_apr = String.valueOf(rs.getDouble("dej_apr"));
		x_dej_maj = String.valueOf(rs.getDouble("dej_maj"));
		x_dej_jun = String.valueOf(rs.getDouble("dej_jun"));
		x_dej_jul = String.valueOf(rs.getDouble("dej_jul"));
		x_dej_avg = String.valueOf(rs.getDouble("dej_avg"));
		x_dej_sep = String.valueOf(rs.getDouble("dej_sep"));
		x_dej_okt = String.valueOf(rs.getDouble("dej_okt"));
		x_dej_nov = String.valueOf(rs.getDouble("dej_nov"));
		x_dej_dec = String.valueOf(rs.getDouble("dej_dec"));		

		if (rs.getTimestamp("zacetek") != null){
			x_zacetek = rs.getTimestamp("zacetek");
		}else{
			x_zacetek = null;
		}
		x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = request.getParameter("x_sif_kupca");
		}else{
			x_sif_kupca = "";
		}
		
		if (request.getParameter("x_koda") != null){
			x_koda = request.getParameter("x_koda");
		}else{
			x_koda = "";
		}	
		
		if (request.getParameter("x_delez") != null){
			x_delez = request.getParameter("x_delez");
		}else{
			x_delez = "";
		}
		
		if (request.getParameter("x_zdruzi") != null){
			x_zdruzi = request.getParameter("x_zdruzi");
		}else{
			x_zdruzi = "";
		}
		
		if (request.getParameter("x_kol_jan") != null){
			x_kol_jan = request.getParameter("x_kol_jan");
		}else{
			x_kol_jan = "";
		}	
		
		if (request.getParameter("x_kol_feb") != null){
			x_kol_feb = request.getParameter("x_kol_feb");
		}else{
			x_kol_feb = "";
		}	
		
		if (request.getParameter("x_kol_mar") != null){
			x_kol_mar = request.getParameter("x_kol_mar");
		}else{
			x_kol_mar = "";
		}	
		
		if (request.getParameter("x_kol_apr") != null){
			x_kol_apr = request.getParameter("x_kol_apr");
		}else{
			x_kol_apr = "";
		}	
		
		if (request.getParameter("x_kol_maj") != null){
			x_kol_maj = request.getParameter("x_kol_maj");
		}else{
			x_kol_maj = "";
		}		
		if (request.getParameter("x_kol_jun") != null){
			x_kol_jun = request.getParameter("x_kol_jun");
		}else{
			x_kol_jun = "";
		}

		if (request.getParameter("x_kol_jul") != null){
			x_kol_jul = request.getParameter("x_kol_jul");
		}else{
			x_kol_jul = "";
		}
		
		if (request.getParameter("x_kol_avg") != null){
			x_kol_avg = request.getParameter("x_kol_avg");
		}else{
			x_kol_avg = "";
		}
		
		if (request.getParameter("x_kol_sep") != null){
			x_kol_sep = request.getParameter("x_kol_sep");
		}else{
			x_kol_sep = "";
		}
		
		if (request.getParameter("x_kol_okt") != null){
			x_kol_okt = request.getParameter("x_kol_okt");
		}else{
			x_kol_okt = "";
		}	

		
		if (request.getParameter("x_kol_nov") != null){
			x_kol_nov = request.getParameter("x_kol_nov");
		}else{
			x_kol_nov = "";
		}	
		
		if (request.getParameter("x_kol_dec") != null){
			x_kol_dec = request.getParameter("x_kol_dec");
		}else{
			x_kol_dec = "";
		}		
		
		
		if (request.getParameter("x_dej_jan") != null){
			x_dej_jan = request.getParameter("x_dej_jan");
		}else{
			x_dej_jan = "";
		}	
		
		if (request.getParameter("x_dej_feb") != null){
			x_dej_feb = request.getParameter("x_dej_feb");
		}else{
			x_dej_feb = "";
		}	
		
		if (request.getParameter("x_dej_mar") != null){
			x_dej_mar = request.getParameter("x_dej_mar");
		}else{
			x_dej_mar = "";
		}	
		
		if (request.getParameter("x_dej_apr") != null){
			x_dej_apr = request.getParameter("x_dej_apr");
		}else{
			x_dej_apr = "";
		}	
		
		if (request.getParameter("x_dej_maj") != null){
			x_dej_maj = request.getParameter("x_dej_maj");
		}else{
			x_dej_maj = "";
		}		
		if (request.getParameter("x_dej_jun") != null){
			x_dej_jun = request.getParameter("x_dej_jun");
		}else{
			x_dej_jun = "";
		}

		if (request.getParameter("x_dej_jul") != null){
			x_dej_jul = request.getParameter("x_dej_jul");
		}else{
			x_dej_jul = "";
		}
		
		if (request.getParameter("x_dej_avg") != null){
			x_dej_avg = request.getParameter("x_dej_avg");
		}else{
			x_dej_avg = "";
		}
		
		if (request.getParameter("x_dej_sep") != null){
			x_dej_sep = request.getParameter("x_dej_sep");
		}else{
			x_dej_sep = "";
		}
		
		if (request.getParameter("x_dej_okt") != null){
			x_dej_okt = request.getParameter("x_dej_okt");
		}else{
			x_dej_okt = "";
		}	

		
		if (request.getParameter("x_dej_nov") != null){
			x_dej_nov = request.getParameter("x_dej_nov");
		}else{
			x_dej_nov = "";
		}	
		
		if (request.getParameter("x_dej_dec") != null){
			x_dej_dec = request.getParameter("x_dej_dec");
		}else{
			x_dej_dec = "";
		}		

		if (request.getParameter("x_zacetek") != null){
			x_zacetek = (String) request.getParameter("x_zacetek");
		}else{
			x_zacetek = "";
		}
		if (request.getParameter("x_uporabnik") != null){
			x_uporabnik = request.getParameter("x_uporabnik");
		}

		// Open record
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabelaKomunale") + "  WHERE 0 = 1";
		//out.println(strsql);
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();


		tmpfld = ((String) x_sif_kupca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kupca");
		}else{
			rs.updateString("sif_kupca", tmpfld);
		}

		
		tmpfld = ((String) x_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("koda");
		}else{
			rs.updateString("koda", tmpfld);
		}


		tmpfld = ((String) x_zdruzi);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("zdruzi");
		}else{
			rs.updateString("zdruzi", tmpfld);
		}
		
		tmpfld = ((String) x_delez);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("delez");
		}else{
			rs.updateDouble("delez", Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_kol_jan).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_jan");
		} else {
			rs.updateDouble("kol_jan",Double.parseDouble(tmpfld));
		}

		tmpfld = ((String) x_kol_feb).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_feb");
		} else {
			rs.updateDouble("kol_feb",Double.parseDouble(tmpfld));
		}		
		
		tmpfld = ((String) x_kol_mar).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_mar");
		} else {
			rs.updateDouble("kol_mar",Double.parseDouble(tmpfld));
		}
		tmpfld = ((String) x_kol_apr).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_apr");
		} else {
			rs.updateDouble("kol_apr",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_kol_maj).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_maj");
		} else {
			rs.updateDouble("kol_maj",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_kol_jun).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_jun");
		} else {
			rs.updateDouble("kol_jun",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_kol_jul).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_jul");
		} else {
			rs.updateDouble("kol_jul",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_kol_avg).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_avg");
		} else {
			rs.updateDouble("kol_avg",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_kol_sep).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_sep");
		} else {
			rs.updateDouble("kol_sep",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_kol_okt).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_okt");
		} else {
			rs.updateDouble("kol_okt",Double.parseDouble(tmpfld));
		}

		tmpfld = ((String) x_kol_nov).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_nov");
		} else {
			rs.updateDouble("kol_nov",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_kol_dec).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_dec");
		} else {
			rs.updateDouble("kol_dec",Double.parseDouble(tmpfld));
		}
					
		tmpfld = ((String) x_dej_jan).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_jan");
		} else {
			rs.updateDouble("dej_jan",Double.parseDouble(tmpfld));
		}

		tmpfld = ((String) x_dej_feb).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_feb");
		} else {
			rs.updateDouble("dej_feb",Double.parseDouble(tmpfld));
		}		
		
		tmpfld = ((String) x_dej_mar).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_mar");
		} else {
			rs.updateDouble("dej_mar",Double.parseDouble(tmpfld));
		}
		tmpfld = ((String) x_dej_apr).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_apr");
		} else {
			rs.updateDouble("dej_apr",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_dej_maj).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_maj");
		} else {
			rs.updateDouble("dej_maj",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_dej_jun).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_jun");
		} else {
			rs.updateDouble("dej_jun",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_dej_jul).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_jul");
		} else {
			rs.updateDouble("dej_jul",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_dej_avg).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_avg");
		} else {
			rs.updateDouble("dej_avg",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_dej_sep).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_sep");
		} else {
			rs.updateDouble("dej_sep",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_dej_okt).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_okt");
		} else {
			rs.updateDouble("dej_okt",Double.parseDouble(tmpfld));
		}

		tmpfld = ((String) x_dej_nov).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_nov");
		} else {
			rs.updateDouble("dej_nov",Double.parseDouble(tmpfld));
		}
		
		tmpfld = ((String) x_dej_dec).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dej_dec");
		} else {
			rs.updateDouble("dej_dec",Double.parseDouble(tmpfld));
		}

		//Uporabnik
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
		
		try{
			rs.insertRow();

		}
		catch(java.sql.SQLException e){
			System.out.println(e.getMessage());
		}
		
		
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("komunalekolicinelist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}


if(request.getParameter("prikaz_naslov")!= null){
	session.setAttribute("komunalekolicine_naslov",  request.getParameter("prikaz_naslov"));
}


%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: komunale kolicine<br><br><a href="komunalekolicinelist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>

<form onSubmit="return EW_checkMyForm(this);"  action="komunalekolicineadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">

	<tr>
		<td class="ewTableHeader">Komunala&nbsp;</td>
		<td class="ewTableAltRow"><%
				String cbo_x_komunale_js = "";
				String x_komunaleList = "<select name=\"x_sif_kupca\"><option value=\"\">Izberi</option>";
				String sqlwrk_x_komunale = "SELECT kupci.sif_kupca, naziv FROM komunale left join kupci on (komunale.sif_kupca = kupci.sif_kupca) ORDER BY naziv ASC";
				Statement stmtwrk_x_komunale = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_komunale = stmtwrk_x_komunale.executeQuery(sqlwrk_x_komunale);
					int rowcntwrk_x_komunale = 0;
					while (rswrk_x_komunale.next()) {
						x_komunaleList += "<option value=\"" + HTMLEncode(rswrk_x_komunale.getString("sif_kupca")) + "\"";
						if (rswrk_x_komunale.getString("sif_kupca").equals(x_sif_kupca)) {
							x_komunaleList += " selected";
						}
						String tmpValue_x_komunale = "";
						if (rswrk_x_komunale.getString("naziv")!= null) tmpValue_x_komunale = rswrk_x_komunale.getString("naziv");
						x_komunaleList += ">" + tmpValue_x_komunale
				 + "</option>";
						rowcntwrk_x_komunale++;		
					}
				rswrk_x_komunale.close();
				rswrk_x_komunale = null;
				stmtwrk_x_komunale.close();
				stmtwrk_x_komunale = null;
				x_komunaleList += "</select>";
				out.println(x_komunaleList);
%>
&nbsp;</td>
	</tr>
	
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><%
				String cbo_x_okolje_koda_js = "";
				String x_okolje_kodaList = "<select name=\"x_koda\"><option value=\"\">Izberi</option>";
				String sqlwrk_x_okolje_koda = "SELECT koda, material FROM okolje WHERE koda like '15 01%' ORDER BY `" + session.getAttribute("material_okolje_prikaz_okolje") + "` ASC";
				Statement stmtwrk_x_okolje_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_okolje_koda = stmtwrk_x_okolje_koda.executeQuery(sqlwrk_x_okolje_koda);
					int rowcntwrk_x_okolje_koda = 0;
					while (rswrk_x_okolje_koda.next()) {
						x_okolje_kodaList += "<option value=\"" + HTMLEncode(rswrk_x_okolje_koda.getString("koda")) + "\"";
						if (rswrk_x_okolje_koda.getString("koda").equals(x_koda)) {
							x_okolje_kodaList += " selected";
						}
						String tmpValue_x_okolje_koda = "";
						if (rswrk_x_okolje_koda.getString("material")!= null) tmpValue_x_okolje_koda = rswrk_x_okolje_koda.getString("material");
						x_okolje_kodaList += ">" + rswrk_x_okolje_koda.getString("koda") + " " + tmpValue_x_okolje_koda
				 + "</option>";
						rowcntwrk_x_okolje_koda++;
					}
				rswrk_x_okolje_koda.close();
				rswrk_x_okolje_koda = null;
				stmtwrk_x_okolje_koda.close();
				stmtwrk_x_okolje_koda = null;
				x_okolje_kodaList += "</select>";
				out.println(x_okolje_kodaList);
%>
&nbsp;</td>
	</tr>	
		
	<tr>
		<td class="ewTableHeader">Združi&nbsp;</td>
		<td class="ewTableAltRow"><%
				String x_okolje_kodaList2 = "<select name=\"x_zdruzi\"><option value=\"\">Izberi</option>";
				String sqlwrk_x_okolje_koda2 = "SELECT koda, material FROM okolje WHERE koda like '15 01%' ORDER BY `" + session.getAttribute("material_okolje_prikaz_zdruzi") + "` ASC";
				Statement stmtwrk_x_okolje_koda2 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_okolje_koda2 = stmtwrk_x_okolje_koda2.executeQuery(sqlwrk_x_okolje_koda2);
					int rowcntwrk_x_okolje_koda2 = 0;
					while (rswrk_x_okolje_koda2.next()) {
						x_okolje_kodaList2 += "<option value=\"" + HTMLEncode(rswrk_x_okolje_koda2.getString("koda")) + "\"";
						if (rswrk_x_okolje_koda2.getString("koda").equals(x_zdruzi)) {
							x_okolje_kodaList2 += " selected";
						}
						String tmpValue_x_okolje_koda = "";
						if (rswrk_x_okolje_koda2.getString("material")!= null) tmpValue_x_okolje_koda = rswrk_x_okolje_koda2.getString("material");
						x_okolje_kodaList2 += ">" + rswrk_x_okolje_koda2.getString("koda") + " " + tmpValue_x_okolje_koda
				 + "</option>";
						rowcntwrk_x_okolje_koda2++;
					}
				rswrk_x_okolje_koda2.close();
				rswrk_x_okolje_koda2 = null;
				stmtwrk_x_okolje_koda2.close();
				stmtwrk_x_okolje_koda2 = null;
				x_okolje_kodaList2 += "</select>";
				out.println(x_okolje_kodaList2);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Delež&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_delez" size="30" value="<%= HTMLEncode((String)x_delez) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved jan&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_jan" size="30" value="<%= HTMLEncode((String)x_kol_jan) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved feb&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_feb" size="30" value="<%= HTMLEncode((String)x_kol_feb) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved mar&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_mar" size="30" value="<%= HTMLEncode((String)x_kol_mar) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved apr&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_apr" size="30" value="<%= HTMLEncode((String)x_kol_apr) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved maj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_maj" size="30" value="<%= HTMLEncode((String)x_kol_maj) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved jun&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_jun" size="30" value="<%= HTMLEncode((String)x_kol_jun) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved jul&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_jul" size="30" value="<%= HTMLEncode((String)x_kol_jul) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved avg&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_avg" size="30" value="<%= HTMLEncode((String)x_kol_avg) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved sep&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_sep" size="30" value="<%= HTMLEncode((String)x_kol_sep) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved okt&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_okt" size="30" value="<%= HTMLEncode((String)x_kol_okt) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved nov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_nov" size="30" value="<%= HTMLEncode((String)x_kol_nov) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Napoved dec&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_dec" size="30" value="<%= HTMLEncode((String)x_kol_dec) %>">&nbsp;</td>
	</tr>

	<tr>
		<td class="ewTableHeader">Dejansko jan&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_jan" size="30" value="<%= HTMLEncode((String)x_dej_jan) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko feb&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_feb" size="30" value="<%= HTMLEncode((String)x_dej_feb) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko mar&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_mar" size="30" value="<%= HTMLEncode((String)x_dej_mar) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko apr&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_apr" size="30" value="<%= HTMLEncode((String)x_dej_apr) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko maj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_maj" size="30" value="<%= HTMLEncode((String)x_dej_maj) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko jun&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_jun" size="30" value="<%= HTMLEncode((String)x_dej_jun) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko jul&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_jul" size="30" value="<%= HTMLEncode((String)x_dej_jul) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko avg&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_avg" size="30" value="<%= HTMLEncode((String)x_dej_avg) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko sep&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_sep" size="30" value="<%= HTMLEncode((String)x_dej_sep) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko okt&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_okt" size="30" value="<%= HTMLEncode((String)x_dej_okt) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko nov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_nov" size="30" value="<%= HTMLEncode((String)x_dej_nov) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejansko dec&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dej_dec" size="30" value="<%= HTMLEncode((String)x_dej_dec) %>">&nbsp;</td>
	</tr>
	

</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
