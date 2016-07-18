<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="kupcilist.jsp"%>
<%@ page contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
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

int ewCurSec  = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();

if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("kupcilist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("UTF-8");
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("kupcilist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_sif_kupca = null;
Object x_naziv = null;
Object x_naslov = null;
Object x_posta = null;
Object x_kraj = null;
Object x_kont_oseba = null;
Object x_tel_st1 = null;
Object x_tel_st2 = null;
Object x_fax = null;
Object x_email = null;
Object x_potnik = null;
Object x_razred = null;
Object x_bala = null;
int x_blokada = 0;
Object x_sif_rac = null;
Object x_opomba = null;
Object x_skupina = null;
Object x_sif_enote = null;
Object x_stroskovno_mesto = null;
Object x_rok_placila = null;

Object x_pogodba  = null;
Object x_davcna = null;
String x_maticna = "";
String x_dejavnost = "";
Object x_opomba1 = null;
Object x_opomba2 = null;
Object x_opomba3 = null;
Object x_opomba4 = null;
Object x_opomba5 = null;
Object x_analiza = null;
Object x_datum = null;
int x_arso_prenos = 0;
String x_arso_pslj_st = "";
String x_arso_pslj_status = "";
String x_arso_aktivnost_pslj = "";


// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kupci` WHERE `sif_kupca`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("kupcilist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("sif_kupca") != null){
				x_sif_kupca = rs.getString("sif_kupca");
			}else{
				x_sif_kupca = "";
			}
			if (rs.getString("naziv") != null){
				x_naziv = rs.getString("naziv");
			}else{
				x_naziv = "";
			}
			if (rs.getString("naslov") != null){
				x_naslov = rs.getString("naslov");
			}else{
				x_naslov = "";
			}
			if (rs.getString("posta") != null){
				x_posta = rs.getString("posta");
			}else{
				x_posta = "";
			}
			if (rs.getString("kraj") != null){
				x_kraj = rs.getString("kraj");
			}else{
				x_kraj = "";
			}
			if (rs.getString("kont_oseba") != null){
				x_kont_oseba = rs.getString("kont_oseba");
			}else{
				x_kont_oseba = "";
			}
			if (rs.getString("tel_st1") != null){
				x_tel_st1 = rs.getString("tel_st1");
			}else{
				x_tel_st1 = "";
			}
			if (rs.getString("tel_st2") != null){
				x_tel_st2 = rs.getString("tel_st2");
			}else{
				x_tel_st2 = "";
			}
			if (rs.getString("fax") != null){
				x_fax = rs.getString("fax");
			}else{
				x_fax = "";
			}
			if (rs.getString("email") != null){
				x_email = rs.getString("email");
			}else{
				x_email = "";
			}
	x_potnik = String.valueOf(rs.getLong("potnik"));
			if (rs.getString("razred") != null){
				x_razred = rs.getString("razred");
			}else{
				x_razred = "";
			}
	x_bala = String.valueOf(rs.getLong("bala"));
	x_blokada = rs.getInt("blokada");

			if (rs.getString("sif_rac") != null){
				x_sif_rac = rs.getString("sif_rac");
			}else{
				x_sif_rac = "";
			}
			if (rs.getString("opomba") != null){
				x_opomba = rs.getString("opomba");
			}else{
				x_opomba = "";
			}
	x_skupina = String.valueOf(rs.getLong("skupina"));
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));


			if (rs.getString("pogodba") != null){
				x_pogodba = rs.getString("pogodba");
			}else{
				x_pogodba = "";
			}

			if (rs.getString("davcna") != null){
				x_davcna = rs.getString("davcna");
			}else{
				x_davcna = "";
			}

			// maticna
			if (rs.getString("maticna") != null){
				x_maticna = rs.getString("maticna");
			}else{
				x_maticna = "";
			}

			// dejavnost
			if (rs.getString("dejavnost") != null){
				x_dejavnost = rs.getString("dejavnost");
			}else{
				x_dejavnost = "";
			}
			// stroskovno_mesto
			if (rs.getString("stroskovno_mesto") != null){
				x_stroskovno_mesto = rs.getString("stroskovno_mesto");
			}else{
				x_stroskovno_mesto = "";
			}
			x_rok_placila = String.valueOf(rs.getInt("rok_placila"));
			if (rs.getString("opomba1") != null){
				x_opomba1 = rs.getString("opomba1");
			}else{
				x_opomba1 = "";
			}

			if (rs.getString("opomba2") != null){
				x_opomba2 = rs.getString("opomba2");
			}else{
				x_opomba2 = "";
			}

			if (rs.getString("opomba3") != null){
				x_opomba3 = rs.getString("opomba3");
			}else{
				x_opomba3 = "";
			}

			if (rs.getString("opomba4") != null){
				x_opomba4 = rs.getString("opomba4");
			}else{
				x_opomba4 = "";
			}

			if (rs.getString("opomba5") != null){
				x_opomba5 = rs.getString("opomba5");
			}else{
				x_opomba5 = "";
			}

			x_analiza = rs.getDouble("analiza");

			if (rs.getTimestamp("datum") != null){
				x_datum = rs.getTimestamp("datum");
			}else{
				x_datum = null;
			}

			// arso_prenos
			x_arso_prenos = rs.getInt("arso_prenos");

			// arso_pslj_st
			if (rs.getString("arso_pslj_st") != null){
				x_arso_pslj_st = rs.getString("arso_pslj_st");
			}else{
				x_arso_pslj_st = "";
			}

			// arso_pslj_status
			if (rs.getString("arso_pslj_status") != null){
				x_arso_pslj_status = rs.getString("arso_pslj_status");
			}else{
				x_arso_pslj_status = "";
			}

			// arso_aktivnost_pslj
			if (rs.getString("arso_aktivnost_pslj") != null){
				x_arso_aktivnost_pslj = rs.getString("arso_aktivnost_pslj");
			}else{
				x_arso_aktivnost_pslj = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = (String) request.getParameter("x_sif_kupca");
		}else{
			x_sif_kupca = "";
		}
		if (request.getParameter("x_naziv") != null){
			x_naziv = (String) request.getParameter("x_naziv");
		}else{
			x_naziv = "";
		}
		if (request.getParameter("x_naslov") != null){
			x_naslov = (String) request.getParameter("x_naslov");
		}else{
			x_naslov = "";
		}
		if (request.getParameter("x_kraj") != null){
			x_kraj = (String) request.getParameter("x_kraj");
		}else{
			x_kraj = "";
		}
		if (request.getParameter("x_posta") != null){
			x_posta = request.getParameter("x_posta");
		}
		if (request.getParameter("x_kont_oseba") != null){
			x_kont_oseba = (String) request.getParameter("x_kont_oseba");
		}else{
			x_kont_oseba = "";
		}
		if (request.getParameter("x_tel_st1") != null){
			x_tel_st1 = (String) request.getParameter("x_tel_st1");
		}else{
			x_tel_st1 = "";
		}
		if (request.getParameter("x_tel_st2") != null){
			x_tel_st2 = (String) request.getParameter("x_tel_st2");
		}else{
			x_tel_st2 = "";
		}
		if (request.getParameter("x_fax") != null){
			x_fax = (String) request.getParameter("x_fax");
		}else{
			x_fax = "";
		}
		if (request.getParameter("x_email") != null){
			x_email = (String) request.getParameter("x_email");
		}else{
			x_email = "";
		}
		if (request.getParameter("x_potnik") != null){
			x_potnik = request.getParameter("x_potnik");
		}
		if (request.getParameter("x_razred") != null){
			x_razred = (String) request.getParameter("x_razred");
		}else{
			x_razred = "";
		}
		if (request.getParameter("x_bala") != null){
			x_bala = (String) request.getParameter("x_bala");
		}else{
			x_bala = "";
		}
		if (request.getParameter("x_blokada") != null){
			x_blokada = Integer.parseInt(request.getParameter("x_blokada"));
		}
		if (request.getParameter("x_sif_rac") != null){
			x_sif_rac = (String) request.getParameter("x_sif_rac");
		}else{
			x_sif_rac = "";
		}
		if (request.getParameter("x_opomba") != null){
			x_opomba = (String) request.getParameter("x_opomba");
		}else{
			x_opomba = "";
		}
		if (request.getParameter("x_skupina") != null){
			x_skupina = request.getParameter("x_skupina");
		}
		if (request.getParameter("x_sif_enote") != null){
			x_sif_enote = request.getParameter("x_sif_enote");
		}
		if (request.getParameter("x_pogodba") != null){
			x_pogodba = (String) request.getParameter("x_pogodba");
		}else{
			x_pogodba= "";
		}
		if (request.getParameter("x_davcna") != null){
			x_davcna = (String) request.getParameter("x_davcna");
		}else{
			x_davcna = "";
		}
		if (request.getParameter("x_maticna") != null){
			x_maticna = (String) request.getParameter("x_maticna");
		}else{
			x_maticna = "";
		}
		if (request.getParameter("x_dejavnost") != null){
			x_dejavnost = (String) request.getParameter("x_dejavnost");
		}else{
			x_dejavnost = "";
		}
		if (request.getParameter("x_stroskovno_mesto") != null){
			x_stroskovno_mesto = (String) request.getParameter("x_stroskovno_mesto");
		}else{
			x_stroskovno_mesto = "";
		}
		if (request.getParameter("x_rok_placila") != null){
			x_rok_placila = (String) request.getParameter("x_rok_placila");
		}else{
			x_rok_placila = "";
		}		
		if (request.getParameter("x_opomba1") != null){
			x_opomba1 = (String) request.getParameter("x_opomba1");
		}else{
			x_opomba1 = "";
		}
		if (request.getParameter("x_opomba2") != null){
			x_opomba2 = (String) request.getParameter("x_opomba2");
		}else{
			x_opomba2 = "";
		}
		if (request.getParameter("x_opomba3") != null){
			x_opomba3 = (String) request.getParameter("x_opomba3");
		}else{
			x_opomba3 = "";
		}
		if (request.getParameter("x_opomba4") != null){
			x_opomba4 = (String) request.getParameter("x_opomba4");
		}else{
			x_opomba4 = "";
		}
		if (request.getParameter("x_opomba5") != null){
			x_opomba5 = (String) request.getParameter("x_opomba5");
		}else{
			x_opomba5 = "";
		}
		if (request.getParameter("x_analiza") != null){
			x_analiza = (String) request.getParameter("x_analiza");
		}else{
			x_analiza = "";
		}
		if (request.getParameter("x_datum") != null){
			x_datum = (String) request.getParameter("x_datum");
		}else{
			x_datum = "";
		}
		if (request.getParameter("x_arso_prenos") != null){
			x_arso_prenos = Integer.parseInt(request.getParameter("x_arso_prenos"));
		}
		if (request.getParameter("x_arso_pslj_st") != null){
			x_arso_pslj_st = (String) request.getParameter("x_arso_pslj_st");
		}else{
			x_arso_pslj_st = "";
		}
		if (request.getParameter("x_arso_pslj_status") != null){
			x_arso_pslj_status = (String) request.getParameter("x_arso_pslj_status");
		}else{
			x_arso_pslj_status = "";
		}
		if (request.getParameter("x_arso_aktivnost_pslj") != null){
			x_arso_aktivnost_pslj = (String) request.getParameter("x_arso_aktivnost_pslj");
		}else{
			x_arso_aktivnost_pslj = "";
		}
		
		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kupci` WHERE `sif_kupca`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("kupcilist.jsp");
			response.flushBuffer();
			return;
		}

		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kupca");
		}else{
			rs.updateString("sif_kupca", tmpfld);
		}

		// Field naziv
		tmpfld = ((String) x_naziv);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("naziv");
		}else{
			rs.updateString("naziv", tmpfld);
		}

		// Field naslov
		tmpfld = ((String) x_naslov);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("naslov");
		}else{
			rs.updateString("naslov", tmpfld);
		}

		// Field posta
		tmpfld = ((String) x_posta);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("posta");
		}else{
			rs.updateString("posta", tmpfld);
		}

		// Field kraj
		tmpfld = ((String) x_kraj);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("kraj");
		}else{
			rs.updateString("kraj", tmpfld);
		}


		// Field kont_oseba
		tmpfld = ((String) x_kont_oseba);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("kont_oseba");
		}else{
			rs.updateString("kont_oseba", tmpfld);
		}

		// Field tel_st1
		tmpfld = ((String) x_tel_st1);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("tel_st1");
		}else{
			rs.updateString("tel_st1", tmpfld);
		}

		// Field tel_st2
		tmpfld = ((String) x_tel_st2);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("tel_st2");
		}else{
			rs.updateString("tel_st2", tmpfld);
		}

		// Field fax
		tmpfld = ((String) x_fax);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("fax");
		}else{
			rs.updateString("fax", tmpfld);
		}

		// Field email
		tmpfld = ((String) x_email);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("email");
		}else{
			rs.updateString("email", tmpfld);
		}
		
		// Field potnik
		tmpfld = ((String) x_potnik).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("potnik");
		} else {
			rs.updateInt("potnik",Integer.parseInt(tmpfld));
		}

		// Field razred
		tmpfld = ((String) x_razred);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("razred");
		}else{
			rs.updateString("razred", tmpfld);
		}

		rs.updateInt("blokada",x_blokada);

		// Field bala
		tmpfld = ((String) x_bala).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("bala");
		} else {
			rs.updateInt("bala",Integer.parseInt(tmpfld));
		}

		// Field sif_rac
		tmpfld = ((String) x_sif_rac);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_rac");
		}else{
			rs.updateString("sif_rac", tmpfld);
		}

		// Field opomba
		tmpfld = ((String) x_opomba);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("opomba");
		}else{
			rs.updateString("opomba", tmpfld);
		}

		// Field skupina
		tmpfld = ((String) x_skupina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skupina");
		} else {
			rs.updateInt("skupina",Integer.parseInt(tmpfld));
		}

		// Field sif_enote
		tmpfld = ((String) x_sif_enote).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sif_enote");
		} else {
			rs.updateInt("sif_enote",Integer.parseInt(tmpfld));
		}

		// Field pogodba
		tmpfld = ((String) x_pogodba);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("pogodba");
		}else{
			rs.updateString("pogodba", tmpfld);
		}

		// Field davcna
		tmpfld = ((String) x_davcna);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("davcna");
		}else{
			rs.updateString("davcna", tmpfld);
		}

		// Field maticna
		tmpfld = ((String) x_maticna);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("maticna");
		}else{
			rs.updateString("maticna", tmpfld);
		}

		// Field dejavnost
		tmpfld = ((String) x_dejavnost);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("dejavnost");
		}else{
			rs.updateString("dejavnost", tmpfld);
		}
		
		// Field stroskovno_mesto
		tmpfld = ((String) x_stroskovno_mesto);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("stroskovno_mesto");
		}else{
			rs.updateString("stroskovno_mesto", tmpfld);
		}
		
		
		// Field rok_placila
		tmpfld = ((String) x_rok_placila);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("rok_placila");
		}else{
			rs.updateInt("rok_placila", Integer.parseInt(tmpfld));
		}


		// Field opomba
		tmpfld = ((String) x_opomba1);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("opomba1");
		}else{
			rs.updateString("opomba1", tmpfld);
		}

		// Field opomba2
		tmpfld = ((String) x_opomba2);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("opomba2");
		}else{
			rs.updateString("opomba2", tmpfld);
		}

		// Field opomba3
		tmpfld = ((String) x_opomba3);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("opomba3");
		}else{
			rs.updateString("opomba3", tmpfld);
		}

		// Field opomba4
		tmpfld = ((String) x_opomba4);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("opomba4");
		}else{
			rs.updateString("opomba4", tmpfld);
		}

		// Field opomba5
		tmpfld = ((String) x_opomba5);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("opomba5");
		}else{
			rs.updateString("opomba5", tmpfld);
		}

		// Field analiza
		tmpfld = ((String) x_analiza).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("analiza");
		} else {
			rs.updateDouble("analiza",Double.parseDouble(tmpfld));
		}

		// Field datum
		if (IsDate((String) x_datum,"EURODATE", locale)) {
			rs.updateTimestamp("datum", EW_UnFormatDateTime((String)x_datum,"EURODATE", locale));
		}else{
			rs.updateNull("datum");
		}

		// Field arso_prenos
		rs.updateInt("arso_prenos", x_arso_prenos);

		// Field arso_pslj_st
		tmpfld = ((String) x_arso_pslj_st);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_pslj_st");
		}else{
			rs.updateString("arso_pslj_st", tmpfld);
		}

		// Field arso_pslj_status
		tmpfld = ((String) x_arso_pslj_status);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_pslj_status");
		}else{
			rs.updateString("arso_pslj_status", tmpfld);
		}

		// Field arso_aktivnost_pslj
		tmpfld = ((String) x_arso_aktivnost_pslj);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_aktivnost_pslj");
		}else{
			rs.updateString("arso_aktivnost_pslj", tmpfld);
		}
		
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("kupcilist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : kupci<br><br><a href="kupcilist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>

<script language="JavaScript">
<!-- start Javascript
function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_sif_kupca && !EW_checkinteger(EW_this.x_sif_kupca.value)) {

            if (!EW_onError(EW_this, EW_this.x_sif_kupca, "TEXT", "Napačan vnos - sif kupca"))
                return false; 
        }
if (EW_this.x_posta && !EW_hasValue(EW_this.x_posta, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_posta, "SELECT", "Napačan vnos - posta"))
                return false; 
        }
if (EW_this.x_potnik && !EW_hasValue(EW_this.x_potnik, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_potnik, "SELECT", "Napačna številka - potnik"))
                return false; 
        }
if (EW_this.x_bala && !EW_checkinteger(EW_this.x_bala.value)) {
        if (!EW_onError(EW_this, EW_this.x_bala, "TEXT", "Napačna številka - bala"))
            return false; 
        }
if (EW_this.x_skupina && !EW_hasValue(EW_this.x_skupina, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_skupina, "SELECT", "Napačna številka - skupina"))
                return false; 
        }
if (EW_this.x_datum && !EW_checkeurodate(EW_this.x_datum.value)) {
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="kupciedit" action="kupciedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_kupca" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sif_kupca) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naziv" size="30" maxlength="255" value="<%= HTMLEncode((String)x_naziv) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naslov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naslov" size="30" maxlength="255" value="<%= HTMLEncode((String)x_naslov) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pošta&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_posta_js = "";
String x_postaList = "<select name=\"x_posta\"><option value=\"\">Izberi</option>";
String sqlwrk_x_posta = "SELECT `posta`, `kraj` FROM `poste`" + " ORDER BY `kraj` ASC";
Statement stmtwrk_x_posta = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_posta = stmtwrk_x_posta.executeQuery(sqlwrk_x_posta);
	int rowcntwrk_x_posta = 0;
	while (rswrk_x_posta.next()) {
		x_postaList += "<option value=\"" + HTMLEncode(rswrk_x_posta.getString("posta")) + "\"";
		if (rswrk_x_posta.getString("posta").equals(x_posta)) {
			x_postaList += " selected";
		}
		String tmpValue_x_posta = "";
		if (rswrk_x_posta.getString("kraj")!= null) tmpValue_x_posta = rswrk_x_posta.getString("kraj");
		x_postaList += ">" + tmpValue_x_posta
 + "</option>";
		rowcntwrk_x_posta++;
	}
rswrk_x_posta.close();
rswrk_x_posta = null;
stmtwrk_x_posta.close();
stmtwrk_x_posta = null;
x_postaList += "</select>";
out.println(x_postaList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kraj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kraj" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kraj) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kontakt oseba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kont_oseba" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kont_oseba) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">tel št 1.&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_tel_st1" size="30" maxlength="255" value="<%= HTMLEncode((String)x_tel_st1) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">tel št 2&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_tel_st2" size="30" maxlength="255" value="<%= HTMLEncode((String)x_tel_st2) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">fax&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_fax" size="30" maxlength="255" value="<%= HTMLEncode((String)x_fax) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">email&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_email" size="30" maxlength="255" value="<%= HTMLEncode((String)x_email) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Potnik&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_potnik_js = "";
String x_potnikList = "<select name=\"x_potnik\"><option value=\"\">Izberi</option>";
String sqlwrk_x_potnik = "SELECT `sif_upor`, `ime_in_priimek` FROM `uporabniki` order by `ime_in_priimek`";
Statement stmtwrk_x_potnik = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_potnik = stmtwrk_x_potnik.executeQuery(sqlwrk_x_potnik);
	int rowcntwrk_x_potnik = 0;
	while (rswrk_x_potnik.next()) {
		x_potnikList += "<option value=\"" + HTMLEncode(rswrk_x_potnik.getString("sif_upor")) + "\"";
		if (rswrk_x_potnik.getString("sif_upor").equals(x_potnik)) {
			x_potnikList += " selected";
		}
		String tmpValue_x_potnik = "";
		if (rswrk_x_potnik.getString("ime_in_priimek")!= null) tmpValue_x_potnik = rswrk_x_potnik.getString("ime_in_priimek");
		x_potnikList += ">" + tmpValue_x_potnik
 + "</option>";
		rowcntwrk_x_potnik++;
	}
rswrk_x_potnik.close();
rswrk_x_potnik = null;
stmtwrk_x_potnik.close();
stmtwrk_x_potnik = null;
x_potnikList += "</select>";
out.println(x_potnikList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Razred&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_razred" size="30" maxlength="255" value="<%= HTMLEncode((String)x_razred) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Bala&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_bala" size="30" value="<%= HTMLEncode((String)x_bala) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Blokada&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_blokada" <%= x_blokada == 0? "checked" : "" %> value = "0" >NE&nbsp;<input type="radio" name="x_blokada"  <%= x_blokada == 1? "checked" : "" %> value = "1">DA&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra rač.&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_rac" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sif_rac) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba" size="30" maxlength="255" value="<%= HTMLEncode((String)x_opomba) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_skupina_js = "";
String x_skupinaList = "<select name=\"x_skupina\"><option value=\"\">Izberi</option>";
String sqlwrk_x_skupina = "SELECT `skupina`, `tekst` FROM `skup`" + " ORDER BY `tekst` ASC";
Statement stmtwrk_x_skupina = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_skupina = stmtwrk_x_skupina.executeQuery(sqlwrk_x_skupina);
	int rowcntwrk_x_skupina = 0;
	while (rswrk_x_skupina.next()) {
		x_skupinaList += "<option value=\"" + HTMLEncode(rswrk_x_skupina.getString("skupina")) + "\"";
		if (rswrk_x_skupina.getString("skupina").equals(x_skupina)) {
			x_skupinaList += " selected";
		}
		String tmpValue_x_skupina = "";
		if (rswrk_x_skupina.getString("tekst")!= null) tmpValue_x_skupina = rswrk_x_skupina.getString("tekst");
		x_skupinaList += ">" + tmpValue_x_skupina
 + "</option>";
		rowcntwrk_x_skupina++;
	}
rswrk_x_skupina.close();
rswrk_x_skupina = null;
stmtwrk_x_skupina.close();
stmtwrk_x_skupina = null;
x_skupinaList += "</select>";
out.println(x_skupinaList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra enote&nbsp;</td>
		<td class="ewTableAltRow"><%

String enote = (String) session.getAttribute("enote");
String enoteQueryFilter = "";
if(enote.equals("0")){
 enoteQueryFilter = "where sif_enote = " + session.getAttribute("papirservis1_status_Enota");
}
 

String cbo_x_sif_enote_js = "";
String x_sif_enoteList = "<select name=\"x_sif_enote\"><option value=\"\">Izberi</option>";
String sqlwrk_x_sif_enote = "SELECT `sif_enote`, `naziv` FROM `enote`" + enoteQueryFilter + " ORDER BY `naziv` ASC";
Statement stmtwrk_x_sif_enote = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_enote = stmtwrk_x_sif_enote.executeQuery(sqlwrk_x_sif_enote);
	int rowcntwrk_x_sif_enote = 0;
	while (rswrk_x_sif_enote.next()) {
		x_sif_enoteList += "<option value=\"" + HTMLEncode(rswrk_x_sif_enote.getString("sif_enote")) + "\"";
		if (rswrk_x_sif_enote.getString("sif_enote").equals(x_sif_enote)) {
			x_sif_enoteList += " selected";
		}
		String tmpValue_x_sif_enote = "";
		if (rswrk_x_sif_enote.getString("naziv")!= null) tmpValue_x_sif_enote = rswrk_x_sif_enote.getString("naziv");
		x_sif_enoteList += ">" + tmpValue_x_sif_enote
 + "</option>";
		rowcntwrk_x_sif_enote++;
	}
rswrk_x_sif_enote.close();
rswrk_x_sif_enote = null;
stmtwrk_x_sif_enote.close();
stmtwrk_x_sif_enote = null;
x_sif_enoteList += "</select>";
out.println(x_sif_enoteList);
%>
&nbsp;</td>
	</tr>

	<tr>
		<td class="ewTableHeader">Pogodba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_pogodba" size="12" maxlength="10" value="<%= HTMLEncode((String)x_pogodba) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Davčna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_davcna" size="12" maxlength="10" value="<%= HTMLEncode((String)x_davcna) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Matična&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_maticna" size="12" maxlength="10" value="<%= HTMLEncode((String)x_maticna) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejavnost&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dejavnost" size="12" maxlength="10" value="<%= HTMLEncode((String)x_dejavnost) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stroškovno mesto&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stroskovno_mesto" size="30" value="<%= HTMLEncode((String)x_stroskovno_mesto) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Rok plačila&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_rok_placila" size="30" value="<%= HTMLEncode((String)x_rok_placila) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Opomba 1&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba1" size="65" maxlength="60" value="<%= HTMLEncode((String)x_opomba1) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 2&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba2" size="65" maxlength="60" value="<%= HTMLEncode((String)x_opomba2) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 3&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba3" size="65" maxlength="60" value="<%= HTMLEncode((String)x_opomba3) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 4&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba4" size="65" maxlength="60" value="<%= HTMLEncode((String)x_opomba4) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 5&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba5" size="65" maxlength="60" value="<%= HTMLEncode((String)x_opomba5) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Analiza&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_analiza" size="65" maxlength="60" value="<%= x_analiza %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_datum" value="<%= EW_FormatDateTime(x_datum,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_datum,'dd.mm.yyyy');return false;">&nbsp;</td>	
	</tr>
	<tr>
		<td class="ewTableHeader">Arso prenos&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_arso_prenos"  <%= x_arso_prenos == 0? "checked" : "" %> value = "0" >NE&nbsp;<input type="radio" name="x_arso_prenos"  <%= x_arso_prenos == 1? "checked" : "" %> value = "1">DA&nbsp;<input type="radio" name="x_arso_prenos"  <%= x_arso_prenos == 2? "checked" : "" %> value = "2">TUJINA&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso št.&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_arso_pslj_st" size="12" maxlength="10" value="<%= HTMLEncode((String)x_arso_pslj_st) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso status&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_pslj_status">
			<%
				String sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'kupci' AND COLUMN_NAME = 'arso_pslj_status'";
				Statement stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_pslj_status)) {
								x_arso_listOption += " selected";
							}
							x_arso_listOption += ">" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "</option>";
							out.println(x_arso_listOption);			
						}
					}
				rswrk_x_arso_status.close();
				rswrk_x_arso_status = null;
				stmtwrk_x_arso_status.close();
				stmtwrk_x_arso_status = null;
			%>
			</select>
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso aktivnost nastanka&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_aktivnost_pslj">
			<%
				String sqlwrk_x_arso_aktivnost = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'kupci' AND COLUMN_NAME = 'arso_aktivnost_pslj'";
				Statement stmtwrk_x_arso_aktivnost = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_arso_aktivnost = stmtwrk_x_arso_aktivnost.executeQuery(sqlwrk_x_arso_aktivnost);
					if (rswrk_x_arso_aktivnost.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_aktivnost.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_aktivnost_pslj)) {
								x_arso_listOption += " selected";
							}
							x_arso_listOption += ">" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "</option>";
							out.println(x_arso_listOption);			
						}
					}
				rswrk_x_arso_aktivnost.close();
				rswrk_x_arso_aktivnost = null;
				stmtwrk_x_arso_aktivnost.close();
				stmtwrk_x_arso_aktivnost = null;
			%>
			</select>
		</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Potrdi">
</form>
<%@ include file="footer.jsp" %>
