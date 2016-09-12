<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="dobnarlist.jsp"%>
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
int ewCurSec = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();

if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("dobnarlist.jsp"); 
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
	response.sendRedirect("dobnarlist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_id = null;
Object x_st_dob = null;
Object x_pozicija = null;
Object x_datum = null;
Object x_sif_str = null;
Object x_stranka = null;
Object x_sif_kupca = null;
Object x_sif_sof = null;
Object x_sofer = null;
Object x_sif_kam = null;
Object x_kamion = null;
Object x_koda = null;
Object x_ewc = null;
Object x_kolicina = null;
Object x_skupina = null;
Object x_skupina_text = null;
Object x_opomba = null;
Object x_zacetek = null;
Object x_uporabnik = null;
Object x_stev_km_norm = null;
Object x_stev_ur_norm = null;
Object x_cena = null;
Object x_cena_km = null;
Object x_cena_ura = null;
Object x_c_km = null;
Object x_c_ura = null;
String x_arso_prjm_status = "";
String x_arso_aktivnost_prjm = "";
String x_arso_aktivnost_pslj = "";
String x_arso_odp_embalaza_shema = "";
String x_arso_odp_dej_nastanka = "";
String x_arso_prenos = "";

StringBuffer x_sif_strList = null;
StringBuffer x_sif_kupcaList = null;
StringBuffer x_sif_kamList = null;
StringBuffer x_kodaList = null;
StringBuffer x_ewcList = null;
StringBuffer x_sif_sofList = null;
StringBuffer x_skupinaList = null;

StringBuffer sif_kupac = new StringBuffer();
StringBuffer sif_skupina = new StringBuffer();
StringBuffer kupac = new StringBuffer();
StringBuffer skupina = new StringBuffer();
StringBuffer sif_ewc = new StringBuffer();

StringBuffer stranka_cena = new StringBuffer();
StringBuffer stranka_stev_km_norm = new StringBuffer();
StringBuffer stranka_stev_ur_norm = new StringBuffer();
StringBuffer cena_km = new StringBuffer();
StringBuffer cena_ura = new StringBuffer();
StringBuffer c_km = new StringBuffer();
StringBuffer c_ura = new StringBuffer();
StringBuffer arso_prjm_status = new StringBuffer();
StringBuffer arso_aktivnost_prjm = new StringBuffer();
StringBuffer arso_aktivnost_pslj = new StringBuffer();
StringBuffer arso_odp_embalaza_shema = new StringBuffer();
StringBuffer arso_odp_dej_nastanka = new StringBuffer();
StringBuffer arso_prenos = new StringBuffer();

String opomba = "/";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM dob_narocila dob WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("dobnarlist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			x_id = String.valueOf(rs.getLong("id"));
			x_st_dob = String.valueOf(rs.getLong("st_dob"));
			x_pozicija = String.valueOf(rs.getLong("pozicija"));
			if (rs.getTimestamp("datum") != null){
				x_datum = rs.getTimestamp("datum");
			}else{
				x_datum = null;
			}
			x_sif_str = String.valueOf(rs.getLong("sif_str"));
			if (rs.getString("stranka") != null){
				x_stranka = rs.getString("stranka");
			}else{
				x_stranka = "";
			}
			if (rs.getString("sif_kupca") != null){
				x_sif_kupca = rs.getString("sif_kupca");
			}else{
				x_sif_kupca = "";
			}
			if (rs.getString("sif_sof") != null){
				x_sif_sof = rs.getString("sif_sof");
			}else{
				x_sif_sof = "";
			}
			if (rs.getString("sofer") != null){
				x_sofer = rs.getString("sofer");
			}else{
				x_sofer = "";
			}
			if (rs.getString("sif_kam") != null){
				x_sif_kam = rs.getString("sif_kam");
			}else{
				x_sif_kam = "";
			}
			if (rs.getString("kamion") != null){
				x_kamion = rs.getString("kamion");
			}else{
				x_kamion = "";
			}
			if (rs.getString("koda") != null){
				x_koda = rs.getString("koda");
			}else{
				x_koda = "";
			}
			if (rs.getString("ewc") != null){
				x_ewc = rs.getString("ewc");
			}else{
				x_ewc = "";
			}
			x_kolicina = String.valueOf(rs.getLong("kolicina"));
			x_skupina = String.valueOf(rs.getLong("skupina"));
			if (rs.getString("skupina_text") != null){
				x_skupina_text = rs.getString("skupina_text");
			}else{
				x_skupina_text = "";
			}
			if (rs.getString("opomba") != null){
				x_opomba = rs.getString("opomba");
			}else{
				x_opomba = "";
			}
			
			if (rs.getTimestamp("zacetek") != null){
				x_zacetek = rs.getTimestamp("zacetek");
			}else{
				x_zacetek = null;
			}
			x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
			
	
		}
		rs.close();
	}else if (a.equals("U")) {// Update
	// Get fields from form
		if (request.getParameter("x_st_dob") != null){
			x_st_dob = (String) request.getParameter("x_st_dob");
		}else{
			x_st_dob = "";
		}
		if (request.getParameter("x_pozicija") != null){
			x_pozicija = (String) request.getParameter("x_pozicija");
		}else{
			x_pozicija = "";
		}
		if (request.getParameter("x_datum") != null){
			x_datum = (String) request.getParameter("x_datum");
		}else{
			x_datum = "";
		}
		if (request.getParameter("x_sif_str") != null){
			x_sif_str = request.getParameter("x_sif_str");
		}
		if (request.getParameter("x_stranka") != null){
			x_stranka = (String) request.getParameter("x_stranka");
		}else{
			x_stranka = "";
		}
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = request.getParameter("x_sif_kupca");
		}
		if (request.getParameter("x_sif_sof") != null){
			x_sif_sof = request.getParameter("x_sif_sof");
		}
		if (request.getParameter("x_sofer") != null){
			x_sofer = (String) request.getParameter("x_sofer");
		}else{
			x_sofer = "";
		}
		if (request.getParameter("x_sif_kam") != null){
			x_sif_kam = request.getParameter("x_sif_kam");
		}
		if (request.getParameter("x_kamion") != null){
			x_kamion = (String) request.getParameter("x_kamion");
		}else{
			x_kamion = "";
		}
		if (request.getParameter("x_koda") != null){
			x_koda = request.getParameter("x_koda");
		}
		if (request.getParameter("x_ewc_ll") != null){
			x_ewc = request.getParameter("x_ewc_ll");
		}
		if (request.getParameter("x_kolicina") != null){
			x_kolicina = (String) request.getParameter("x_kolicina");
		}else{
			x_kolicina = "";
		}
		if (request.getParameter("x_skupina") != null){
			x_skupina = request.getParameter("x_skupina");
		}else{
			x_skupina = "";
		}
		if (request.getParameter("x_skupina_text") != null){
			x_skupina_text = (String) request.getParameter("x_skupina_text");
		}else{
			x_skupina_text = "";
		}
		if (request.getParameter("x_opomba") != null){
			x_opomba = (String) request.getParameter("x_opomba");
		}else{
			x_opomba = "";
		}
		
		String updateSql = "update dob_narocila set ";

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM dob_narocila dob WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("dobnarlist.jsp");
			response.flushBuffer();
			return;
		}

		// Field st_dob
		tmpfld = ((String) x_st_dob).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("st_dob");
		} else {
			rs.updateInt("st_dob",Integer.parseInt(tmpfld));
		}
		updateSql += "st_dob = " + tmpfld + ", ";
		
		// Field pozicija
		tmpfld = ((String) x_pozicija).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("pozicija");
		} else {
			rs.updateInt("pozicija",Integer.parseInt(tmpfld));
		}
		updateSql += "pozicija = " + tmpfld + ", ";

		// Field datum
		if (IsDate((String) x_datum,"EURODATE", locale)) {
			rs.updateTimestamp("datum", EW_UnFormatDateTime((String)x_datum,"EURODATE", locale));
		}else{
			rs.updateNull("datum");
		}

		if (IsDate((String) x_datum,"EURODATE", locale)) {
			updateSql += "datum = '" + EW_UnFormatDateTime((String)x_datum,"EURODATE", locale) + "', ";
		}

		// Field sif_str
		tmpfld = ((String) x_sif_str).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sif_str");
		} else {
			rs.updateInt("sif_str",Integer.parseInt(tmpfld));
		}
		updateSql += "sif_str = " + tmpfld + ", ";

		// Field stranka
		tmpfld = ((String) x_stranka);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("stranka");
		}else{
			rs.updateString("stranka", tmpfld);
		}
		updateSql += "stranka= " + tmpfld + ", ";

		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kupca");
		}else{
			rs.updateString("sif_kupca", tmpfld);
		}
		updateSql += "sif_kupca= " + tmpfld + ", ";


		// Field sif_sof
		tmpfld = ((String) x_sif_sof);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_sof");
		}else{
			rs.updateString("sif_sof", tmpfld);
		}
		updateSql += "sif_sof= " + tmpfld + ", ";

		// Field sofer
		tmpfld = ((String) x_sofer);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sofer");
		}else{
			rs.updateString("sofer", tmpfld);
		}
		updateSql += "sofer= " + tmpfld + ", ";

		// Field sif_kam
		tmpfld = ((String) x_sif_kam);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kam");
		}else{
			rs.updateString("sif_kam", tmpfld);
		}
		updateSql += "sif_kam= " + tmpfld + ", ";

		// Field kamion
		tmpfld = ((String) x_kamion);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("kamion");
		}else{
			rs.updateString("kamion", tmpfld);
		}
		updateSql += "kamion= " + tmpfld + ", ";

		// Field koda
		tmpfld = ((String) x_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("koda");
		}else{
			rs.updateString("koda", tmpfld);
		}
		updateSql += "koda= '" + tmpfld + "', ";

		// Field ewc
		tmpfld = ((String) x_ewc);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("ewc");
		}else{
			rs.updateString("ewc", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";
		
		// Field kolicina
		tmpfld = ((String) x_kolicina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kolicina");
		} else {
			rs.updateInt("kolicina",Integer.parseInt(tmpfld));
		}
		updateSql += "kolicina= " + tmpfld + ", ";

		// Field skupina
		tmpfld = ((String) x_skupina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skupina");
		} else {
			rs.updateInt("skupina",Integer.parseInt(tmpfld));
		}
		updateSql += "skupina= " + tmpfld + ", ";

		// Field skupina_text
		tmpfld = ((String) x_skupina_text);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("skupina_text");
		}else{
			rs.updateString("skupina_text", tmpfld);
		}
		updateSql += "skupina_text= " + tmpfld + ", ";

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
		updateSql += "opomba= '" + tmpfld + "', ";


		
		//Set it as dobavnica
		updateSql += "where id = " + tkey;
		
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));


		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("dobnarlist.jsp");
		response.flushBuffer();
		return;
	}else if (a.equals("C")) {// Confirm
		// Get fields from form
		if (request.getParameter("x_st_dob") != null){
			x_st_dob = (String) request.getParameter("x_st_dob");
		}else{
			x_st_dob = "";
		}
		if (request.getParameter("x_pozicija") != null){
			x_pozicija = (String) request.getParameter("x_pozicija");
		}else{
			x_pozicija = "";
		}
		if (request.getParameter("x_datum") != null){
			x_datum = (String) request.getParameter("x_datum");
		}else{
			x_datum = "";
		}
		if (request.getParameter("x_sif_str") != null){
			x_sif_str = request.getParameter("x_sif_str");
		}
		if (request.getParameter("x_stranka") != null){
			x_stranka = (String) request.getParameter("x_stranka");
		}else{
			x_stranka = "";
		}
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = request.getParameter("x_sif_kupca");
		}
		if (request.getParameter("x_sif_sof") != null){
			x_sif_sof = request.getParameter("x_sif_sof");
		}
		if (request.getParameter("x_sofer") != null){
			x_sofer = (String) request.getParameter("x_sofer");
		}else{
			x_sofer = "";
		}
		if (request.getParameter("x_sif_kam") != null){
			x_sif_kam = request.getParameter("x_sif_kam");
		}
		if (request.getParameter("x_kamion") != null){
			x_kamion = (String) request.getParameter("x_kamion");
		}else{
			x_kamion = "";
		}
		if (request.getParameter("x_koda") != null){
			x_koda = request.getParameter("x_koda");
		}
		if (request.getParameter("x_ewc_ll") != null){
			x_ewc = request.getParameter("x_ewc_ll");
		}
		if (request.getParameter("x_kolicina") != null){
			x_kolicina = (String) request.getParameter("x_kolicina");
		}else{
			x_kolicina = "";
		}
		if (request.getParameter("x_skupina") != null){
			x_skupina = request.getParameter("x_skupina");
		}
		if (request.getParameter("x_skupina_text") != null){
			x_skupina_text = (String) request.getParameter("x_skupina_text");
		}else{
			x_skupina_text = "";
		}
		if (request.getParameter("x_opomba") != null){
			x_opomba = (String) request.getParameter("x_opomba");
		}else{
			x_opomba = "";
		}
		if (request.getParameter("x_zacetek") != null){
			x_zacetek = (String) request.getParameter("x_zacetek");
		}else{
			x_zacetek = "";
		}
		if (request.getParameter("x_uporabnik") != null){
			x_uporabnik = request.getParameter("x_uporabnik");
		}
		if (request.getParameter("x_stev_km_norm") != null){
			x_stev_km_norm = (String) request.getParameter("x_stev_km_norm");
		}else{
			x_stev_km_norm = "";
		}
		if (request.getParameter("x_stev_ur_norm") != null){
			x_stev_ur_norm = (String) request.getParameter("x_stev_ur_norm");
		}else{
			x_stev_ur_norm = "";
		}
		if (request.getParameter("x_cena_km") != null){
			x_cena_km = (String) request.getParameter("x_cena_km");
		}else{
			x_cena_km = "";
		}
		if (request.getParameter("x_cena_ura") != null){
			x_cena_ura = (String) request.getParameter("x_cena_ura");
		}else{
			x_cena_ura = "";
		}
		if (request.getParameter("x_c_km") != null){
			x_c_km = (String) request.getParameter("x_c_km");
		}else{
			x_c_km = "";
		}
		if (request.getParameter("x_c_ura") != null){
			x_c_ura = (String) request.getParameter("x_c_ura");
		}else{
			x_c_ura = "";
		}
		if (request.getParameter("x_cena") != null){
			x_cena = (String) request.getParameter("x_cena");
		}else{
			x_cena = "";
		}


		String strsql = "insert into " + session.getAttribute("letoTabela") + " (st_dob, pozicija, datum, sif_str, stranka, sif_kupca, sif_sof, sofer, sif_kam, kamion, koda, ewc, kolicina, skupina, skupina_text, opomba, cena_km, cena_ura, c_km, c_ura, cena, stev_km_norm, stev_ur_norm, uporabnik, aplikacija ) values(";


		// Open record
		String strsql1 = "SELECT * FROM " + session.getAttribute("letoTabela") + " dob WHERE 0 = 1";
		rs = stmt.executeQuery(strsql1);
		rs.moveToInsertRow();

		// Field st_dob
		tmpfld = ((String) x_st_dob).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("st_dob");
		} else {
			rs.updateInt("st_dob",Integer.parseInt(tmpfld));
		}
		//strsql += tmpfld + ", ";
		strsql += tmpfld + ", ";

		// Field pozicija
		tmpfld = ((String) x_pozicija).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("pozicija");
		} else {
			rs.updateInt("pozicija",Integer.parseInt(tmpfld));
		}
		strsql += tmpfld + ", ";

		// Field datum
		if (IsDate((String) x_datum,"EURODATE", locale)) {
			strsql += "'" + EW_UnFormatDateTime((String)x_datum,"EURODATE", locale) + "'" + ", ";
		}else{
			strsql += " null, ";
		}

		// Field sif_str
		tmpfld = ((String) x_sif_str).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field stranka
		tmpfld = ((String) x_stranka);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("stranka");
		}else{
			rs.updateString("stranka", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";


		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kupca");
		}else{
			rs.updateString("sif_kupca", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field sif_sof
		tmpfld = ((String) x_sif_sof);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_sof");
		}else{
			rs.updateString("sif_sof", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field sofer
		tmpfld = ((String) x_sofer);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sofer");
		}else{
			rs.updateString("sofer", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field sif_kam
		tmpfld = ((String) x_sif_kam);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kam");
		}else{
			rs.updateString("sif_kam", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field kamion
		tmpfld = ((String) x_kamion);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("kamion");
		}else{
			rs.updateString("kamion", tmpfld);
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field koda
		tmpfld = ((String) x_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("koda");
		}else{
			rs.updateString("koda", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field ewc
		tmpfld = ((String) x_ewc);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("ewc");
		}else{
			rs.updateString("ewc", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";
		
		// Field kolicina
		tmpfld = ((String) x_kolicina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field skupina
		tmpfld = ((String) x_skupina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";


		// Field skupina_text
		tmpfld = ((String) x_skupina_text);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("skupina_text");
		}else{
			rs.updateString("skupina_text", tmpfld);
		}

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

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

		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field cena_km
		tmpfld = ((String) x_cena_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field cena_ura
		tmpfld = ((String) x_cena_ura).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field c_km
		tmpfld = ((String) x_c_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field c_ura
		tmpfld = ((String) x_c_ura).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field cena
		tmpfld = ((String) x_cena).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		
		// Field stev_km_norm
		tmpfld = ((String) x_stev_km_norm).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field stev_ur_norm
		tmpfld = ((String) x_stev_ur_norm).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";
		
		//Uporabnik
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));

		strsql += session.getAttribute("papirservis1_status_UserID") + ", 1 )"; //1 - aplikacija
		Statement stmt1 = conn.createStatement();
System.out.println(strsql);
		stmt1.executeUpdate(strsql);
		stmt1.close();
		stmt1 = null;

		strsql = "DELETE FROM dob_narocila WHERE st_dob = " + ((String) x_st_dob).trim();
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;

		conn = null;
		out.clear();
		response.sendRedirect("dobnarlist.jsp");
		response.flushBuffer();
		return;
	}


if(request.getParameter("prikaz_stranke")!= null){
	session.setAttribute("dob_stranke_show",  request.getParameter("prikaz_stranke"));
}

if(request.getParameter("prikaz_kupca")!= null){
	session.setAttribute("dob_kupci_show",  request.getParameter("prikaz_kupca"));
}

if(request.getParameter("prikaz_kamion")!= null){
 	session.setAttribute("dob_kamion_show", request.getParameter("prikaz_kamion"));
}

if(request.getParameter("prikaz_sofer")!= null){
 	session.setAttribute("dob_sofer_show", request.getParameter("prikaz_sofer"));
}

if(request.getParameter("prikaz_material")!= null){
 	session.setAttribute("dob_prikaz_material_1", request.getParameter("prikaz_material"));
}


String cbo_x_sif_kupca_js = "";
x_sif_kupcaList = new StringBuffer("<select name=\"x_sif_kupca_ll\"><option value=\"\">Izberi</option>");
//String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci`  where blokada = 0 and potnik = " + session.getAttribute("papirservis1_status_UserID")  + " ORDER BY `naziv` ASC";
String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci`  where blokada = 0 ORDER BY `naziv` ASC";

Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
	int rowcntwrk_x_sif_kupca = 0;
	while (rswrk_x_sif_kupca.next()) {
		//x_sif_kupcaList += "<option value=\"" + HTMLEncode(rswrk_x_sif_kupca.getString("naziv")) + "\"";
		String tmpSifra = rswrk_x_sif_kupca.getString("sif_kupca");
		x_sif_kupcaList.append("<option value=\"").append(tmpSifra).append("\"");
		if (tmpSifra.equals(x_sif_kupca)) {
			x_sif_kupcaList.append(" selected");
		}
		String tmpValue_x_sif_kupca = "";
		String tmpNaziv = null;
		if (!((String)session.getAttribute("dob_kupci_show")).equals("vse"))
			tmpNaziv = rswrk_x_sif_kupca.getString((String)session.getAttribute("dob_kupci_show"));
		else
			tmpNaziv = rswrk_x_sif_kupca.getString("sif_kupca") + " " + rswrk_x_sif_kupca.getString("naziv") + " " + rswrk_x_sif_kupca.getString("naslov");
		
		kupac.append("kupac[").append(rswrk_x_sif_kupca.getString("sif_kupca")).append("]=").append(String.valueOf(rowcntwrk_x_sif_kupca)).append(";");

		if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
		x_sif_kupcaList.append(">").append(tmpValue_x_sif_kupca).append("</option>");
		rowcntwrk_x_sif_kupca++;
	}
rswrk_x_sif_kupca.close();
rswrk_x_sif_kupca = null;
stmtwrk_x_sif_kupca.close();
stmtwrk_x_sif_kupca = null;
x_sif_kupcaList.append("</select>");


String stranke = (String) session.getAttribute("vse");
String strankeQueryFilter = "";
if(stranke.equals("0")){
	strankeQueryFilter = "and k.potnik = " + session.getAttribute("papirservis1_status_UserID");
}


String cbo_x_sif_str_js = "";
x_sif_strList = new StringBuffer("<select onchange = \"updateDropDowns(this);\" name=\"x_sif_str\" STYLE=\"font-family : monospace;  font-size : medium\"><option value=\"\">Izberi</option>");

//String sqlwrk_x_sif_str = "SELECT `sif_str`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina FROM `stranke` s, `osnovna` o, `kupci` k, `skup` sk where s.sif_os = o.sif_os and k.sif_kupca = s.sif_kupca and k.skupina = sk.skupina  and k.blokada = 0 " + strankeQueryFilter  + " ORDER BY `" + session.getAttribute("dob_stranke_show") + "` ASC";
String sqlwrk_x_sif_str = "SELECT `sif_str`, `cena`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina, s.stev_km_norm, s.stev_ur_norm, arso_prjm_status, arso_aktivnost_prjm, arso_aktivnost_pslj, arso_odp_embalaza_shema, arso_odp_dej_nastanka, arso_prenos  "+
	"FROM (SELECT stranke.* "+
	"	FROM stranke, (SELECT sif_str, max(zacetek) datum FROM stranke group by sif_str ) zadnji "+
	"	WHERE stranke.sif_str = zadnji.sif_str and "+
	"      	stranke.zacetek = zadnji.datum) s,  "+
	"	(SELECT osnovna.* "+
	"		FROM osnovna, (SELECT sif_os, max(zacetek) datum FROM osnovna group by sif_os ) zadnji1 "+
	"		WHERE osnovna.sif_os = zadnji1.sif_os and "+
	"		      osnovna.zacetek = zadnji1.datum) o, "+
	"	`kupci` k, `skup` sk, enote  "+
	"where s.sif_os = o.sif_os and k.sif_kupca = s.sif_kupca and k.sif_enote = enote.sif_enote and "+ 
	"k.skupina = sk.skupina  and k.blokada = 0 " + strankeQueryFilter  + 
	" ORDER BY `" + session.getAttribute("dob_stranke_show") + "` ASC";



String fiftyBlanks ="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
//String fiftyBlanks ="                                                  ";
Statement stmtwrk_x_sif_str = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_str = stmtwrk_x_sif_str.executeQuery(sqlwrk_x_sif_str);
	int rowcntwrk_x_sif_str = 0;
	while (rswrk_x_sif_str.next()) {
		//x_sif_strList += "<option value=\"" + HTMLEncode(rswrk_x_sif_str.getString("sif_str")) + "\"";
		String tmpSif = rswrk_x_sif_str.getString("sif_str");
		x_sif_strList.append("<option value=\"").append(tmpSif).append("\"");
		if (tmpSif.equals(x_sif_str)) {
			x_sif_strList.append(" selected");
		}
		
		sif_kupac.append("sif_kupac[").append(tmpSif).append("]=").append(rswrk_x_sif_str.getString("sif_kupca")).append(";");
		sif_skupina.append("sif_skupina[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_str.getLong("skupina"))).append(";");
		stranka_cena.append("stranka_cena[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_str.getDouble("cena"))).append(";");
		stranka_stev_km_norm.append("stranka_stev_km_norm[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_str.getDouble("stev_km_norm"))).append(";");
		stranka_stev_ur_norm.append("stranka_stev_ur_norm[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_str.getDouble("stev_ur_norm"))).append(";");

		arso_prjm_status.append("arso_prjm_status[").append(tmpSif).append("]='").append(String.valueOf(rswrk_x_sif_str.getString("arso_prjm_status"))).append("';");
		arso_aktivnost_prjm.append("arso_aktivnost_prjm[").append(tmpSif).append("]='").append(String.valueOf(rswrk_x_sif_str.getString("arso_aktivnost_prjm"))).append("';");
		arso_aktivnost_pslj.append("arso_aktivnost_pslj[").append(tmpSif).append("]='").append(String.valueOf(rswrk_x_sif_str.getString("arso_aktivnost_pslj"))).append("';");
		arso_odp_embalaza_shema.append("arso_odp_embalaza_shema[").append(tmpSif).append("]='").append(String.valueOf(rswrk_x_sif_str.getString("arso_odp_embalaza_shema"))).append("';");
		arso_odp_dej_nastanka.append("arso_odp_dej_nastanka[").append(tmpSif).append("]='").append(String.valueOf(rswrk_x_sif_str.getString("arso_odp_dej_nastanka"))).append("';");
		arso_prenos.append("arso_prenos[").append(tmpSif).append("]='").append(String.valueOf(rswrk_x_sif_str.getString("arso_prenos"))).append("';");


		String tmpValue_x_sif_str = "";
		String find = (String)session.getAttribute("dob_stranke_show");
		String tmpNaziv = rswrk_x_sif_str.getString("naziv").trim() + fiftyBlanks.substring(0, rswrk_x_sif_str.getString("naziv").trim().length() > 30 ? 0 : (30 - rswrk_x_sif_str.getString("naziv").trim().length())*6)
		+ rswrk_x_sif_str.getString("sif_str").trim() + fiftyBlanks.substring(0, rswrk_x_sif_str.getString("sif_str").trim().length() > 6 ? 0 : (6 - rswrk_x_sif_str.getString("sif_str").trim().length())*6)
		+ (rswrk_x_sif_str.getString("naslov") == null ? "" : rswrk_x_sif_str.getString("naslov").trim())
		+ "&nbsp;&nbsp;" + (rswrk_x_sif_str.getString("osnovna") == null ? "" : rswrk_x_sif_str.getString("osnovna").trim()) + "&nbsp;&nbsp;"
		+ (rswrk_x_sif_str.getString("kol_os") == null ? "" : rswrk_x_sif_str.getString("kol_os").trim());
		
		
		if (tmpNaziv!= null) tmpValue_x_sif_str = tmpNaziv;
		x_sif_strList.append(">").append(tmpValue_x_sif_str).append("</option>");
		rowcntwrk_x_sif_str++;
	}
rswrk_x_sif_str.close();
rswrk_x_sif_str = null;
stmtwrk_x_sif_str.close();
stmtwrk_x_sif_str = null;
x_sif_strList.append("</select>");

String cbo_x_sif_kam_js = "";
x_sif_kamList = new StringBuffer("<select onchange = \"updateSubfileds(this);\" name=\"x_sif_kam\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_kam = "SELECT `kamion`.`sif_kam`, `kamion`, `cena_km`, `cena_ura`, `cena_kg`, `c_km`, `c_ura` "+
		"FROM `kamion`, (select sif_kam, max(zacetek) as zacetek from kamion group by sif_kam) as k "+
		"where kamion.sif_kam = k.sif_kam and kamion.zacetek = k.zacetek "+
		"order by " + session.getAttribute("dob_kamion_show") + " asc";

Statement stmtwrk_x_sif_kam = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_kam = stmtwrk_x_sif_kam.executeQuery(sqlwrk_x_sif_kam);
	int rowcntwrk_x_sif_kam = 0;
	while (rswrk_x_sif_kam.next()) {
		String tmpSif = rswrk_x_sif_kam.getString("sif_kam");
		x_sif_kamList.append("<option value=\"").append(tmpSif).append("\"");
		if (tmpSif.equals(x_sif_kam)) {
			x_sif_kamList.append(" selected");
		}
		String tmpKamion = rswrk_x_sif_kam.getString((String)session.getAttribute("dob_kamion_show"));
		String tmpValue_x_sif_kam = "";
		if (tmpKamion!= null) tmpValue_x_sif_kam = tmpKamion;
		x_sif_kamList.append(">").append(tmpValue_x_sif_kam).append("</option>");

		cena_km.append("cena_km[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("cena_km"))).append(";");
		cena_ura.append("cena_ura[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("cena_ura"))).append(";");
		c_km.append("c_km[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("c_km"))).append(";");
		c_ura.append("c_ura[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("c_ura"))).append(";");

		rowcntwrk_x_sif_kam++;
	}
rswrk_x_sif_kam.close();
rswrk_x_sif_kam = null;
stmtwrk_x_sif_kam.close();
stmtwrk_x_sif_kam = null;
x_sif_kamList.append("</select>");


String cbo_x_koda_js = "";
x_kodaList = new StringBuffer("<select onchange = \"updateKoda(this);\" name=\"x_koda\"><option value=\"\">Izberi</option>");
String sqlwrk_x_koda = "SELECT `materiali`.`koda`, `material`  , `sit_sort`, `sit_zaup`, `sit_smet`, material_okolje.okolje_koda " +
			"FROM `materiali` " +
			"		left join material_okolje on (materiali.koda = material_okolje.material_koda), " +
			"		(select koda, max(zacetek) as zacetek from materiali group by koda) as m " +
			"WHERE materiali.koda = m.koda and materiali.zacetek = m.zacetek "+
			"ORDER BY `" + session.getAttribute("dob_prikaz_material_1") + "` ASC";

Statement stmtwrk_x_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_koda = stmtwrk_x_koda.executeQuery(sqlwrk_x_koda);
	int rowcntwrk_x_koda = 0;
	while (rswrk_x_koda.next()) {
		x_kodaList.append("<option value=\"").append(rswrk_x_koda.getString("koda")).append("\"");
		String tmpSif = rswrk_x_koda.getString("koda");

		if (tmpSif.equals(x_koda)) {
			x_kodaList.append(" selected");
		}
		sif_ewc.append("sif_ewc[").append(rowcntwrk_x_koda).append("]='").append(String.valueOf(rswrk_x_koda.getString("okolje_koda"))).append("';");


		String tmpValue_x_koda = "";
		if (rswrk_x_koda.getString("material")!= null) tmpValue_x_koda = rswrk_x_koda.getString("material");
		x_kodaList.append(">").append(rswrk_x_koda.getString("koda") + "   ").append(tmpValue_x_koda).append("</option>");
		rowcntwrk_x_koda++;
	}
rswrk_x_koda.close();
rswrk_x_koda = null;
stmtwrk_x_koda.close();
stmtwrk_x_koda = null;
x_kodaList.append("</select>");

String cbo_x_ewc_js = "";
x_ewcList = new StringBuffer("<select name=\"x_ewc_ll\" ><option value=\"\">Izberi</option>");
String sqlwrk_x_ewc = "SELECT `koda`, `material` " +
		"FROM `okolje` "+
		"ORDER BY `" + session.getAttribute("dob_prikaz_okolje_1") + "` ASC";

Statement stmtwrk_x_ewc = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_ewc = stmtwrk_x_ewc.executeQuery(sqlwrk_x_ewc);
	int rowcntwrk_x_ewc = 0;
	while (rswrk_x_ewc.next()) {
		x_ewcList.append("<option value=\"").append(rswrk_x_ewc.getString("koda")).append("\"");
		if (rswrk_x_ewc.getString("koda").equals(x_ewc)) {
			x_ewcList.append(" selected");
		}
		String tmpValue_x_ewc = "";
		if (rswrk_x_ewc.getString("material")!= null) tmpValue_x_ewc = rswrk_x_ewc.getString("material");
		x_ewcList.append(">").append(rswrk_x_ewc.getString("koda") + "   ").append(tmpValue_x_ewc).append("</option>");

		rowcntwrk_x_ewc++;
	}
rswrk_x_ewc.close();
rswrk_x_ewc = null;
stmtwrk_x_ewc.close();
stmtwrk_x_ewc = null;
x_ewcList.append("</select>");


String cbo_x_sif_sof_js = "";
x_sif_sofList = new StringBuffer("<select name=\"x_sif_sof\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_sof = "SELECT `sif_sof`, `sofer` FROM `sofer` order by " + session.getAttribute("dob_sofer_show") + " asc";
Statement stmtwrk_x_sif_sof = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_sof = stmtwrk_x_sif_sof.executeQuery(sqlwrk_x_sif_sof);
	int rowcntwrk_x_sif_sof = 0;
	while (rswrk_x_sif_sof.next()) {
		x_sif_sofList.append("<option value=\"").append(rswrk_x_sif_sof.getString("sif_sof")).append("\"");
		if (rswrk_x_sif_sof.getString("sif_sof").equals(x_sif_sof)) {
			x_sif_sofList.append(" selected");
		}
		String tmpValue_x_sif_sof = "";
		String tmpSofer = rswrk_x_sif_sof.getString((String)session.getAttribute("dob_sofer_show"));
		
		if (tmpSofer!= null) tmpValue_x_sif_sof = tmpSofer;
		x_sif_sofList.append(">").append(tmpValue_x_sif_sof).append("</option>");
		rowcntwrk_x_sif_sof++;
	}
rswrk_x_sif_sof.close();
rswrk_x_sif_sof = null;
stmtwrk_x_sif_sof.close();
stmtwrk_x_sif_sof = null;
x_sif_sofList.append("</select>");



String cbo_x_skupina_js = "";
x_skupinaList = new StringBuffer("<select disabled name=\"x_skupina_ll\"><option value=\"\">Izberi</option>");

String sqlwrk_x_skupina = "SELECT `skupina`, `tekst` FROM `skup`";
Statement stmtwrk_x_skupina = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_skupina = stmtwrk_x_skupina.executeQuery(sqlwrk_x_skupina);
	int rowcntwrk_x_skupina = 0;
	while (rswrk_x_skupina.next()) {
		x_skupinaList.append("<option value=\"").append(HTMLEncode(rswrk_x_skupina.getString("skupina"))).append("\"");
		if (rswrk_x_skupina.getString("skupina").equals(x_skupina)) {
			x_skupinaList.append(" selected");
		}


		skupina.append("skupina[").append(rswrk_x_skupina.getString("skupina")).append("]=").append(String.valueOf(rowcntwrk_x_skupina)).append(";");

		String tmpValue_x_skupina = "";
		if (rswrk_x_skupina.getString("tekst")!= null) tmpValue_x_skupina = rswrk_x_skupina.getString("tekst");
		x_skupinaList.append(">").append(tmpValue_x_skupina).append("</option>");
		rowcntwrk_x_skupina++;
	}
rswrk_x_skupina.close();
rswrk_x_skupina = null;
stmtwrk_x_skupina.close();
stmtwrk_x_skupina = null;
x_skupinaList.append("</select>");



}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : dobavnice naro&#269;ila<br><br><a href="dobnarlist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
var sif_kupac = new Array();
<%=sif_kupac%>
var sif_skupina = new Array();
<%=sif_skupina%>
var kupac = new Array();
<%=kupac%>
var skupina = new Array();
<%=skupina%>
var sif_ewc = new Array();
<%=sif_ewc%>
var stranka_cena = new Array();
<%=stranka_cena%>
var stranka_stev_ur_norm = new Array();
<%=stranka_stev_ur_norm%>
var stranka_stev_km_norm = new Array();
<%=stranka_stev_km_norm%>
var cena_km = new Array();
<%=cena_km%>
var cena_ura = new Array();
<%=cena_ura%>
var c_km = new Array();
<%=c_km%>
var c_ura = new Array();
<%=c_ura%>
var arso_prjm_status = new Array();
<%=arso_prjm_status%>
var arso_aktivnost_prjm = new Array();
<%=arso_aktivnost_prjm%>
var arso_aktivnost_pslj = new Array();
<%=arso_aktivnost_pslj%>
var arso_odp_embalaza_shema = new Array();
<%=arso_odp_embalaza_shema%>
var arso_odp_dej_nastanka = new Array();
<%=arso_odp_dej_nastanka%>
var arso_prenos = new Array();
<%=arso_prenos%>

function updateSubfileds(EW_this){
	updateKamion();
}


function updateKamion(){
	document.dobedit.x_c_km.value = c_km[document.dobedit.x_sif_kam.value];
	document.dobedit.x_c_ura.value = c_ura[document.dobedit.x_sif_kam.value];
	document.dobedit.x_cena_km.value = cena_km[document.dobedit.x_sif_kam.value];
	document.dobedit.x_cena_ura.value = cena_ura[document.dobedit.x_sif_kam.value];
}


function updateDropDowns(EW_this){

	document.dobedit.x_sif_kupca_ll.selectedIndex = 1 + kupac[sif_kupac[document.dobedit.x_sif_str.value]];
	document.dobedit.x_sif_kupca.value = sif_kupac[document.dobedit.x_sif_str.value];
	document.dobedit.x_skupina_ll.selectedIndex = 1 + skupina[sif_skupina[document.dobedit.x_sif_str.value]];
	document.dobedit.x_skupina.value = sif_skupina[document.dobedit.x_sif_str.value];
	
	updateStranke();
}

function updateStranke(){
	document.dobedit.x_cena.value = stranka_cena[document.dobedit.x_sif_str.value];
	document.dobedit.x_stev_km_norm.value = stranka_stev_km_norm[document.dobedit.x_sif_str.value];
	document.dobedit.x_stev_ur_norm.value = stranka_stev_ur_norm[document.dobedit.x_sif_str.value];

	document.dobedit.x_arso_prjm_status.value = arso_prjm_status[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_aktivnost_prjm.value = arso_aktivnost_prjm[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_aktivnost_pslj.value = arso_aktivnost_pslj[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_odp_embalaza_shema.value = arso_odp_embalaza_shema[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_odp_dej_nastanka.value = arso_odp_dej_nastanka[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_prenos.value = arso_prenos[document.dobedit.x_sif_str.value];
}


function updateKoda(EW_this){
	document.dobedit.x_sit_sort.value = material_sit_sort[document.dobedit.x_koda.selectedIndex - 1];
	document.dobedit.x_sit_zaup.value = material_sit_zaup[document.dobedit.x_koda.selectedIndex - 1];
	document.dobedit.x_sit_smet.value = material_sit_smet[document.dobedit.x_koda.selectedIndex - 1];

	if (sif_ewc[document.dobedit.x_koda.selectedIndex-1] != "null")
		document.dobedit.x_ewc_ll.value = sif_ewc[document.dobedit.x_koda.selectedIndex-1];
	else
		document.dobedit.x_ewc_ll.selectedIndex = 0;
}

function disableSome(){
	document.dobedit.x_sif_kupca_ll.disabled=true;
	document.dobedit.x_skupina_ll.disabled=true;
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_st_dob && !EW_hasValue(EW_this.x_st_dob, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "Napačna številka - st dob"))
                return false; 
        }
if (EW_this.x_st_dob && !EW_checkinteger(EW_this.x_st_dob.value)) {
        if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "Napačna številka - st dob"))
            return false; 
        }
if (EW_this.x_pozicija && !EW_hasValue(EW_this.x_pozicija, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "Napačna številka - pozicija"))
                return false; 
        }
if (EW_this.x_pozicija && !EW_checkinteger(EW_this.x_pozicija.value)) {
        if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "Napačna številka - pozicija"))
            return false; 
        }
if (EW_this.x_datum && !EW_checkeurodate(EW_this.x_datum.value)) {
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum"))
            return false; 
        }
if (EW_this.x_sif_str && !EW_hasValue(EW_this.x_sif_str, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_str, "SELECT", "Napačna številka - sif str"))
                return false; 
        }
if (EW_this.x_sif_kupca && !EW_hasValue(EW_this.x_sif_kupca, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kupca, "SELECT", "Napačen vnos - sif kupca"))
                return false; 
        }
if (EW_this.x_sif_kam && !EW_hasValue(EW_this.x_sif_kam, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kam, "SELECT", "Napačen vnos - sif kam"))
                return false; 
        }
if (EW_this.x_koda && !EW_hasValue(EW_this.x_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_koda, "SELECT", "Napačen vnos - koda"))
                return false; 
        }
if (EW_this.x_ewc && !EW_hasValue(EW_this.x_ewc, "SELECT" )) {
    if (!EW_onError(EW_this, EW_this.x_ewc, "SELECT", "Napačen vnos - ewc"))
        return false; 
}
if (EW_this.x_kolicina && !EW_checkinteger(EW_this.x_kolicina.value)) {
        if (!EW_onError(EW_this, EW_this.x_kolicina, "TEXT", "Napačna številka - kolicina"))
            return false; 
        }
if (EW_this.x_skupina && !EW_hasValue(EW_this.x_skupina, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_skupina, "SELECT", "Napačna številka - skupina"))
                return false; 
        }
return true;
}
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="dobedit" action="dobnaredit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<input type="hidden" name="x_st_dob" size="30" value="<%= HTMLEncode((String)x_st_dob) %>">
<input type="hidden" name="x_pozicija" size="30" value="<%= HTMLEncode((String)x_pozicija) %>">
<input type="hidden" name="x_sif_kupca" size="30" value="<%= HTMLEncode((String)x_sif_kupca) %>">
<input type="hidden" name="x_skupina" size="30" value="<%= HTMLEncode((String)x_skupina) %>">
<input type="hidden" name="x_stev_km_norm" size="30" value="<%= HTMLEncode((String)x_stev_km_norm) %>">
<input type="hidden" name="x_stev_ur_norm" size="30" value="<%= HTMLEncode((String)x_stev_ur_norm) %>">
<input type="hidden" name="x_cena" size="30" value="<%= HTMLEncode((String)x_cena) %>">
<input type="hidden" name="x_cena_km" size="30" value="<%= HTMLEncode((String)x_cena_km) %>">
<input type="hidden" name="x_cena_ura" size="30" value="<%= HTMLEncode((String)x_cena_ura) %>">
<input type="hidden" name="x_c_km" size="30" value="<%= HTMLEncode((String)x_c_km) %>">
<input type="hidden" name="x_c_ura" size="30" value="<%= HTMLEncode((String)x_c_ura) %>">
<input type="hidden" name="x_arso_prjm_status" size="30" value="<%= HTMLEncode((String)x_arso_prjm_status) %>">
<input type="hidden" name="x_arso_aktivnost_prjm" size="30" value="<%= HTMLEncode((String)x_arso_aktivnost_prjm) %>">
<input type="hidden" name="x_arso_aktivnost_pslj" size="30" value="<%= HTMLEncode((String)x_arso_aktivnost_pslj) %>">
<input type="hidden" name="x_arso_odp_embalaza_shema" size="30" value="<%= HTMLEncode((String)x_arso_odp_embalaza_shema) %>">
<input type="hidden" name="x_arso_odp_dej_nastanka" size="30" value="<%= HTMLEncode((String)x_arso_odp_dej_nastanka) %>">
<input type="hidden" name="x_arso_prenos" size="30" value="<%= HTMLEncode((String)x_arso_prenos) %>">

<table class="ewTable">
<tr><td class="ewTableAltRow">Opomba stranke:<%=opomba%></td></tr>
</table>

<table class="ewTable">
	<!-- tr>
		<td class="ewTableHeader">id&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_id); %>&nbsp;</td>
	</tr -->
	<tr>
		<td class="ewTableHeader">Številka dobavnice&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_st_dob_ll" size="30" value="<%= HTMLEncode((String)x_st_dob) %>" disabled>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pozicija&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_pozicija_ll" size="30" value="<%= HTMLEncode((String)x_pozicija) %>" disabled>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_datum" value="<%= EW_FormatDateTime(x_datum,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_datum,'dd.mm.yyyy');return false;">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_strList);%><span class="jspmaker"><a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_stranke=sif_str");%>">šifra</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_stranke=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_stranke=naslov");%>">naslov</a>&nbsp;</span>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stranka&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stranka" size="150" maxlength="255" value="<%= HTMLEncode((String)x_stranka) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%><!--span class="jspmaker"><a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_kupca=sif_kupca");%>">Ĺˇifra</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_kupca=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_kupca=naslov");%>">naslov</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_kupca=vse");%>">vse</a>&nbsp;</span-->&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_sofList);%><a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_sofer=sif_sof");%>">šifra</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_sofer=sofer");%>">šofer</a>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šofer&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sofer" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sofer) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kamiona&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kamList);%><a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_kamion=sif_kam");%>">šifra</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_kamion=kamion");%>">kamion</a>&nbsp;</td>

	</tr>
	<tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kamion" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kamion) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_kodaList);%>
		<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_material=koda");%>">koda</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_material=material");%>">material</a></td>
	</tr>
	<tr>
		<td class="ewTableHeader">EWC&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_ewcList);%>&nbsp;
		<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_okolje=koda");%>">ewc</a>&nbsp;<a href="<%out.print("dobnaredit.jsp?key=" + x_id + "&prikaz_okolje=material");%>">material</a></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Količina&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kolicina" size="30" value="<%= HTMLEncode((String)x_kolicina) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_skupinaList);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_skupina_text" size="30" maxlength="255" value="<%= HTMLEncode((String)x_skupina_text) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba" size="30" maxlength="255" value="<%= HTMLEncode((String)x_opomba) %>">&nbsp;</td>
	</tr>
	
</table>
<p>
<input type="submit" name="Action" value="Potrdi spremembo" tabindex=1>
<input type="submit" name="Action" value="Potrdi naro&#269;ilo" tabindex=1 onclick="updateKamion();updateStranke();document.dobedit.a.value='C';">
</form>
<%@ include file="footer.jsp" %>
