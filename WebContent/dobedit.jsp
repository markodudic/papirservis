<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="doblist.jsp"%>
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
	response.sendRedirect("doblist.jsp"); 
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
	response.sendRedirect("doblist.jsp");
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
Object x_cena_km = null;
Object x_cena_ura = null;
Object x_c_km = null;
Object x_c_ura = null;
Object x_stev_km = null;
Object x_stev_ur = null;
Object x_stroski = null;
Object x_koda = null;
Object x_ewc = null;
Object x_kolicina = null;
Object x_cena = null;
Object x_kg_zaup = null;
Object x_sit_zaup = null;
Object x_kg_sort = null;
Object x_sit_sort = null;
Object x_sit_smet = null;
Object x_skupina = null;
Object x_skupina_text = null;
Object x_sif_enote = null;
Object x_enote = null;
Object x_opomba = null;
//Object x_stev_km_sled = null;
//Object x_stev_ur_sled = null;
Object x_stev_km_norm = null;
Object x_stev_ur_norm = null;
Object x_dod_stroski = null;
Object x_zacetek = null;
Object x_uporabnik = null;
String x_arso_odp_embalaza = "";
String x_arso_emb_st_enot = "";
String x_arso_odp_fiz_last = "";
String x_arso_odp_tip = "";
String x_arso_aktivnost_pslj = "";
String x_arso_prjm_status = "";
String x_arso_aktivnost_prjm = "";
String x_arso_odp_embalaza_shema = "";
String x_arso_odp_dej_nastanka = "";
int x_arso_prenos = 0;
int x_arso_status = 0;


StringBuffer x_sif_strList = null;
StringBuffer x_sif_kupcaList = null;
StringBuffer x_sif_kamList = null;
StringBuffer x_kodaList = null;
StringBuffer x_ewcList = null;
StringBuffer x_sif_sofList = null;
StringBuffer x_skupinaList = null;
StringBuffer x_enoteList = null;
StringBuffer cena_km = new StringBuffer();
StringBuffer cena_ura = new StringBuffer();
StringBuffer cena_kg = new StringBuffer();
StringBuffer c_km = new StringBuffer();
StringBuffer c_ura = new StringBuffer();

StringBuffer sif_kupac2 = new StringBuffer();
StringBuffer sif_kupac = new StringBuffer();
StringBuffer sif_skupina = new StringBuffer();
StringBuffer sif_enote = new StringBuffer();
StringBuffer kupac = new StringBuffer();
StringBuffer skupina = new StringBuffer();
StringBuffer enote = new StringBuffer();
StringBuffer stranka_cena = new StringBuffer();
StringBuffer material_sit_sort = new StringBuffer();
StringBuffer material_sit_zaup = new StringBuffer();
StringBuffer material_sit_smet = new StringBuffer();
StringBuffer sif_ewc = new StringBuffer();
StringBuffer arso_prjm_status = new StringBuffer();
StringBuffer arso_aktivnost_prjm = new StringBuffer();
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
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabela") + " dob WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("doblist.jsp");
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
			x_cena_km = String.valueOf(rs.getDouble("cena_km"));
			x_cena_ura = String.valueOf(rs.getDouble("cena_ura"));
			x_c_km = String.valueOf(rs.getDouble("c_km"));
			x_c_ura = String.valueOf(rs.getDouble("c_ura"));
			x_stev_km = String.valueOf(rs.getDouble("stev_km"));
			x_stev_ur = String.valueOf(rs.getDouble("stev_ur"));
			x_stroski = String.valueOf(rs.getDouble("stroski"));
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
			x_cena = String.valueOf(rs.getDouble("cena"));
			x_kg_zaup = String.valueOf(rs.getLong("kg_zaup"));
			x_sit_zaup = String.valueOf(rs.getDouble("sit_zaup"));
			x_kg_sort = String.valueOf(rs.getLong("kg_sort"));
			x_sit_sort = String.valueOf(rs.getDouble("sit_sort"));
			x_sit_smet = String.valueOf(rs.getDouble("sit_smet"));
			x_skupina = String.valueOf(rs.getLong("skupina"));
			if (rs.getString("skupina_text") != null){
				x_skupina_text = rs.getString("skupina_text");
			}else{
				x_skupina_text = "";
			}
			x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
			if (rs.getString("naziv_enote") != null){
				x_enote = rs.getString("naziv_enote");
			}else{
				x_enote = "";
			}
			if (rs.getString("opomba") != null){
				x_opomba = rs.getString("opomba");
			}else{
				x_opomba = "";
			}
			
			x_dod_stroski = String.valueOf(rs.getDouble("dod_stroski"));
			//x_stev_km_sled = String.valueOf(rs.getDouble("stev_km_sled"));
			//x_stev_ur_sled = String.valueOf(rs.getDouble("stev_ur_sled"));
			x_stev_km_norm = String.valueOf(rs.getDouble("stev_km_norm"));
			x_stev_ur_norm = String.valueOf(rs.getDouble("stev_ur_norm"));
			if (rs.getTimestamp("zacetek") != null){
				x_zacetek = rs.getTimestamp("zacetek");
			}else{
				x_zacetek = null;
			}
			x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
			
			// arso_odp_embalaza
			if (rs.getString("arso_odp_embalaza") != null){
				x_arso_odp_embalaza = rs.getString("arso_odp_embalaza");
			}else{
				x_arso_odp_embalaza = "";
			}

			// arso_emb_st_enot
			if (rs.getString("arso_emb_st_enot") != null){
				x_arso_emb_st_enot = rs.getString("arso_emb_st_enot");
			}else{
				x_arso_emb_st_enot = "";
			}

			// arso_odp_fiz_last
			if (rs.getString("arso_odp_fiz_last") != null){
				x_arso_odp_fiz_last = rs.getString("arso_odp_fiz_last");
			}else{
				x_arso_odp_fiz_last = "";
			}

			// arso_odp_tip
			if (rs.getString("arso_odp_tip") != null){
				x_arso_odp_tip = rs.getString("arso_odp_tip");
			}else{
				x_arso_odp_tip = "";
			}

			// arso_aktivnost_pslj
			if (rs.getString("arso_aktivnost_pslj") != null){
				x_arso_aktivnost_pslj = rs.getString("arso_aktivnost_pslj");
			}else{
				x_arso_aktivnost_pslj = "";
			}


			// x_arso_prjm_status
			if (rs.getString("arso_prjm_status") != null){
				x_arso_prjm_status = rs.getString("arso_prjm_status");
			}else{
				x_arso_prjm_status = "";
			}
			
			// arso_aktivnost_prjm
			if (rs.getString("arso_aktivnost_prjm") != null){
				x_arso_aktivnost_prjm = rs.getString("arso_aktivnost_prjm");
			}else{
				x_arso_aktivnost_prjm = "";
			}

			// arso_odp_embalaza_shema
			if (rs.getString("arso_odp_embalaza_shema") != null){
				x_arso_odp_embalaza_shema = rs.getString("arso_odp_embalaza_shema");
			}else{
				x_arso_odp_embalaza_shema = "";
			}

			// arso_odp_dej_nastanka
			if (rs.getString("arso_odp_dej_nastanka") != null){
				x_arso_odp_dej_nastanka = rs.getString("arso_odp_dej_nastanka");
			}else{
				x_arso_odp_dej_nastanka = "";
			}
			
			// x_arso_prenos
			x_arso_prenos = rs.getInt("arso_prenos");

			x_arso_status = rs.getInt("arso_status");

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
		if (request.getParameter("x_stev_km") != null){
			x_stev_km = (String) request.getParameter("x_stev_km");
		}else{
			x_stev_km = "";
		}
		if (request.getParameter("x_stev_ur") != null){
			x_stev_ur = (String) request.getParameter("x_stev_ur");
		}else{
			x_stev_ur = "";
		}
		if (request.getParameter("x_stroski") != null){
			x_stroski = (String) request.getParameter("x_stroski");
		}else{
			x_stroski = "";
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
		if (request.getParameter("x_cena") != null){
			x_cena = (String) request.getParameter("x_cena");
		}else{
			x_cena = "";
		}
		if (request.getParameter("x_kg_zaup") != null){
			x_kg_zaup = (String) request.getParameter("x_kg_zaup");
		}else{
			x_kg_zaup = "";
		}
		if (request.getParameter("x_sit_zaup") != null){
			x_sit_zaup = (String) request.getParameter("x_sit_zaup");
		}else{
			x_sit_zaup = "";
		}
		if (request.getParameter("x_kg_sort") != null){
			x_kg_sort = (String) request.getParameter("x_kg_sort");
		}else{
			x_kg_sort = "";
		}
		if (request.getParameter("x_sit_sort") != null){
			x_sit_sort = (String) request.getParameter("x_sit_sort");
		}else{
			x_sit_sort = "";
		}
		if (request.getParameter("x_sit_smet") != null){
			x_sit_smet = (String) request.getParameter("x_sit_smet");
		}else{
			x_sit_smet = "";
		}
		if (request.getParameter("x_skupina_ll") != null){
			x_skupina = request.getParameter("x_skupina_ll");
		}else{
			x_skupina = "";
		}
		if (request.getParameter("x_skupina_text") != null){
			x_skupina_text = (String) request.getParameter("x_skupina_text");
		}else{
			x_skupina_text = "";
		}
		if (request.getParameter("x_enote_ll") != null){
			x_sif_enote = request.getParameter("x_enote_ll");
		}else{
			x_sif_enote = "";
		}
		if (request.getParameter("x_enote") != null){
			x_enote = (String) request.getParameter("x_enote");
		}else{
			x_enote = "";
		}
		if (request.getParameter("x_opomba") != null){
			x_opomba = (String) request.getParameter("x_opomba");
		}else{
			x_opomba = "";
		}
		/*if (request.getParameter("x_stev_km_sled") != null){
			x_stev_km_sled = (String) request.getParameter("x_stev_km_sled");
		}else{
			x_stev_km_sled = "";
		}		
		if (request.getParameter("x_stev_ur_sled") != null){
			x_stev_ur_sled = (String) request.getParameter("x_stev_ur_sled");
		}else{
			x_stev_ur_sled = "";
		}*/
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
		if (request.getParameter("x_dod_stroski") != null){
			x_dod_stroski = (String) request.getParameter("x_dod_stroski");
		}else{
			x_dod_stroski = "";
		}
		if (request.getParameter("x_arso_odp_embalaza") != null){
			x_arso_odp_embalaza = (String) request.getParameter("x_arso_odp_embalaza");
		}else{
			x_arso_odp_embalaza = "";
		}
		if (request.getParameter("x_arso_emb_st_enot") != null){
			x_arso_emb_st_enot = (String) request.getParameter("x_arso_emb_st_enot");
		}else{
			x_arso_emb_st_enot = "";
		}
		if (request.getParameter("x_arso_odp_fiz_last") != null){
			x_arso_odp_fiz_last = (String) request.getParameter("x_arso_odp_fiz_last");
		}else{
			x_arso_odp_fiz_last = "";
		}
		if (request.getParameter("x_arso_odp_tip") != null){
			x_arso_odp_tip = (String) request.getParameter("x_arso_odp_tip");
		}else{
			x_arso_odp_tip = "";
		}
		if (request.getParameter("x_arso_aktivnost_pslj") != null){
			x_arso_aktivnost_pslj = (String) request.getParameter("x_arso_aktivnost_pslj");
		}else{
			x_arso_aktivnost_pslj = "";
		}
		if (request.getParameter("x_arso_prjm_status") != null){
			x_arso_prjm_status = (String) request.getParameter("x_arso_prjm_status");
		}else{
			x_arso_prjm_status = "";
		}
		if (request.getParameter("x_arso_aktivnost_prjm") != null){
			x_arso_aktivnost_prjm = (String) request.getParameter("x_arso_aktivnost_prjm");
		}else{
			x_arso_aktivnost_prjm = "";
		}
		if (request.getParameter("x_arso_odp_embalaza_shema") != null){
			x_arso_odp_embalaza_shema = (String) request.getParameter("x_arso_odp_embalaza_shema");
		}else{
			x_arso_odp_embalaza_shema = "";
		}
		if (request.getParameter("x_arso_odp_dej_nastanka") != null){
			x_arso_odp_dej_nastanka = (String) request.getParameter("x_arso_odp_dej_nastanka").replace(",", ";");
		}else{
			x_arso_odp_dej_nastanka = "";
		}
		if (request.getParameter("x_arso_prenos") != null){
			x_arso_prenos = Integer.parseInt(request.getParameter("x_arso_prenos"));
		}
		
		if (request.getParameter("x_arso_status") != null){
			x_arso_status = Integer.parseInt(request.getParameter("x_arso_status"));
		}
		
		
		
		//String updateSql = "update " + session.getAttribute("letoTabela") + " set ";

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabela") + " dob WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("doblist.jsp");
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
		//updateSql += "st_dob = " + tmpfld + ", ";
		
		// Field pozicija
		tmpfld = ((String) x_pozicija).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("pozicija");
		} else {
			rs.updateInt("pozicija",Integer.parseInt(tmpfld));
		}
		//updateSql += "pozicija = " + tmpfld + ", ";

		// Field datum
		if (IsDate((String) x_datum,"EURODATE", locale)) {
			rs.updateTimestamp("datum", EW_UnFormatDateTime((String)x_datum,"EURODATE", locale));
		}else{
			rs.updateNull("datum");
		}

		/*if (IsDate((String) x_datum,"EURODATE", locale)) {
			updateSql += "datum = '" + EW_UnFormatDateTime((String)x_datum,"EURODATE", locale) + "', ";
		}*/

		// Field sif_str
		tmpfld = ((String) x_sif_str).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sif_str");
		} else {
			rs.updateInt("sif_str",Integer.parseInt(tmpfld));
		}
		//updateSql += "sif_str = " + tmpfld + ", ";

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
		//updateSql += "stranka= " + tmpfld + ", ";

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
		//updateSql += "sif_kupca= " + tmpfld + ", ";


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
		//updateSql += "sif_sof= " + tmpfld + ", ";

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
		//updateSql += "sofer= " + tmpfld + ", ";

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
		//updateSql += "sif_kam= " + tmpfld + ", ";

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
		//updateSql += "kamion= " + tmpfld + ", ";

		// Field cena_km
		tmpfld = ((String) x_cena_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena_km");
		} else {
			rs.updateDouble("cena_km",Double.parseDouble(tmpfld));
		}
		//updateSql += "cena_km= " + tmpfld + ", ";

		// Field cena_ura
		tmpfld = ((String) x_cena_ura).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena_ura");
		} else {
			rs.updateDouble("cena_ura",Double.parseDouble(tmpfld));
		}
		//updateSql += "cena_ura= " + tmpfld + ", ";

		// Field c_km
		tmpfld = ((String) x_c_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("c_km");
		} else {
			rs.updateDouble("c_km",Double.parseDouble(tmpfld));
		}
		//updateSql += "c_km= " + tmpfld + ", ";

		// Field c_ura
		tmpfld = ((String) x_c_ura).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("c_ura");
		} else {
			rs.updateDouble("c_ura",Double.parseDouble(tmpfld));
		}
		//updateSql += "c_ura= " + tmpfld + ", ";

		// Field stev_km
		tmpfld = ((String) x_stev_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("stev_km");
		} else {
			rs.updateDouble("stev_km",Double.parseDouble(tmpfld));
		}
		//updateSql += "stev_km= " + tmpfld + ", ";

		// Field stev_ur
		tmpfld = ((String) x_stev_ur).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("stev_ur");
		} else {
			rs.updateDouble("stev_ur",Double.parseDouble(tmpfld));
		}
		//updateSql += "stev_ur= " + tmpfld + ", ";

		// Field stroski
		tmpfld = ((String) x_stroski).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("stroski");
		} else {
			rs.updateDouble("stroski",Double.parseDouble(tmpfld));
		}
		//updateSql += "stroski= " + tmpfld + ", ";

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
		//updateSql += "koda= '" + tmpfld + "', ";

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
		//updateSql += "kolicina= " + tmpfld + ", ";

		// Field cena
		tmpfld = ((String) x_cena).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena");
		} else {
			rs.updateDouble("cena",Double.parseDouble(tmpfld));
		}
		//updateSql += "cena= " + tmpfld + ", ";

		// Field kg_zaup
		tmpfld = ((String) x_kg_zaup).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kg_zaup");
		} else {
			rs.updateInt("kg_zaup",Integer.parseInt(tmpfld));
		}
		//updateSql += "kg_zaup= " + tmpfld + ", ";

		// Field sit_zaup
		tmpfld = ((String) x_sit_zaup).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sit_zaup");
		} else {
			rs.updateDouble("sit_zaup",Double.parseDouble(tmpfld));
		}
		//updateSql += "sit_zaup= " + tmpfld + ", ";

		// Field kg_sort
		tmpfld = ((String) x_kg_sort).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kg_sort");
		} else {
			rs.updateInt("kg_sort",Integer.parseInt(tmpfld));
		}
		//updateSql += "kg_sort= " + tmpfld + ", ";

		// Field sit_sort
		tmpfld = ((String) x_sit_sort).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sit_sort");
		} else {
			rs.updateDouble("sit_sort",Double.parseDouble(tmpfld));
		}
		//updateSql += "sit_sort= " + tmpfld + ", ";

		// Field sit_smet
		tmpfld = ((String) x_sit_smet).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sit_smet");
		} else {
			rs.updateDouble("sit_smet",Double.parseDouble(tmpfld));
		}
		//updateSql += "sit_smet= " + tmpfld + ", ";

		// Field skupina
		tmpfld = ((String) x_skupina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skupina");
		} else {
			rs.updateInt("skupina",Integer.parseInt(tmpfld));
		}
		//updateSql += "skupina= " + tmpfld + ", ";

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

		// Field enota
		tmpfld = ((String) x_sif_enote).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sif_enote");
		} else {
			rs.updateInt("sif_enote",Integer.parseInt(tmpfld));
		}
		
		// Field naziv enote
		tmpfld = ((String) x_enote);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("naziv_enote");
		}else{
			rs.updateString("naziv_enote", tmpfld);
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
		//updateSql += "opomba= '" + tmpfld + "', ";

		// Field stev_km_sled
		/*tmpfld = ((String) x_stev_km_sled).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("stev_km_sled");
		} else {
			rs.updateDouble("stev_km_sled",Double.parseDouble(tmpfld));
		}
		updateSql += "stev_km_sled= " + tmpfld + ", ";

		// Field stev_ur_sled
		tmpfld = ((String) x_stev_ur_sled).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}

		if (tmpfld == null) {
			rs.updateNull("stev_ur_sled");
		} else {
			rs.updateDouble("stev_ur_sled",Double.parseDouble(tmpfld));
		}
		updateSql += "stev_ur_sled= " + tmpfld + ", ";
*/
		// Field stev_km_norm
		tmpfld = ((String) x_stev_km_norm).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("stev_km_norm");
		} else {
			rs.updateDouble("stev_km_norm",Double.parseDouble(tmpfld));
		}
		//updateSql += "stev_km_norm= " + tmpfld + ", ";

		// Field stev_ur_norm
		tmpfld = ((String) x_stev_ur_norm).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("stev_ur_norm");
		} else {
			rs.updateDouble("stev_ur_norm",Double.parseDouble(tmpfld));
		}
		//updateSql += "stev_ur_norm= " + tmpfld + ", ";

		// Field dod_stroski
		tmpfld = ((String) x_dod_stroski).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("dod_stroski");
		} else {
			rs.updateDouble("dod_stroski",Double.parseDouble(tmpfld));
		}
		//updateSql += "dod_stroski= " + tmpfld + ", ";


		// Field arso_odp_embalaza
		tmpfld = ((String) x_arso_odp_embalaza).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_odp_embalaza");
		} else {
			rs.updateString("arso_odp_embalaza", tmpfld);
		}
		//updateSql += "arso_odp_embalaza= " + tmpfld + ", ";

		// Field arso_emb_st_enot
		tmpfld = ((String) x_arso_emb_st_enot).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("arso_emb_st_enot");
		} else {
			rs.updateDouble("arso_emb_st_enot",Integer.parseInt(tmpfld));
		}
		//updateSql += "arso_emb_st_enot= " + tmpfld + ", ";

		// Field arso_odp_fiz_last
		tmpfld = ((String) x_arso_odp_fiz_last).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_odp_fiz_last");
		} else {
			rs.updateString("arso_odp_fiz_last", tmpfld);
		}
		//updateSql += "arso_odp_fiz_last= " + tmpfld + ", ";

		// Field arso_odp_tip
		tmpfld = ((String) x_arso_odp_tip).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_odp_tip");
		} else {
			rs.updateString("arso_odp_tip", tmpfld);
		}
		//updateSql += "arso_odp_tip= " + tmpfld + ", ";

		// Field arso_aktivnost_pslj
		tmpfld = ((String) x_arso_aktivnost_pslj).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_aktivnost_pslj");
		} else {
			rs.updateString("arso_aktivnost_pslj", tmpfld);
		}
		//updateSql += "arso_aktivnost_pslj= " + tmpfld + ", ";

		// Field x_arso_prjm_status
		tmpfld = ((String) x_arso_prjm_status).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_prjm_status");
		} else {
			rs.updateString("arso_prjm_status", tmpfld);
		}
		
		// Field arso_aktivnost_prjm
		tmpfld = ((String) x_arso_aktivnost_prjm).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_aktivnost_prjm");
		} else {
			rs.updateString("arso_aktivnost_prjm", tmpfld);
		}
		//updateSql += "arso_aktivnost_prjm= " + tmpfld + ", ";

		// Field dod_stroski
		tmpfld = ((String) x_arso_odp_embalaza_shema).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_odp_embalaza_shema");
		} else {
			rs.updateString("arso_odp_embalaza_shema", tmpfld);
		}
		//updateSql += "arso_odp_embalaza_shema= " + tmpfld + ", ";

		// Field arso_odp_dej_nastanka
		tmpfld = ((String) x_arso_odp_dej_nastanka).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_odp_dej_nastanka");
		} else {
			rs.updateString("arso_odp_dej_nastanka", tmpfld);
		}
		
		// Field x_arso_prenos
		rs.updateInt("arso_prenos",x_arso_prenos);

		rs.updateInt("arso_status",x_arso_status);
		
		//Set it as dobavnica
		//updateSql += "obdelana=1  where id = " + tkey;
		
		rs.updateBoolean("obdelana",true);
		
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));


		rs.updateRow();
		rs.close();
		rs = null;
		
		//strsql = "update kupci set sif_enote = " +  ((String) x_sif_enote).trim() + " where sif_kupca = " + ((String) x_sif_kupca).trim();
		//System.out.println(strsql);
		//stmt.executeUpdate(strsql);

		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("doblist.jsp");
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
x_sif_kupcaList = new StringBuffer("<select onchange = \"updateDropDowns2(this);\" name=\"x_sif_kupca_ll\"><option value=\"\">Izberi</option>");
//String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci`  where blokada = 0 and potnik = " + session.getAttribute("papirservis1_status_UserID")  + " ORDER BY `naziv` ASC";
String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci` where blokada = 0 ORDER BY `naziv` ASC";

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
		sif_kupac2.append("sif_kupac2[").append(rowcntwrk_x_sif_kupca).append("]=").append(rswrk_x_sif_kupca.getString("sif_kupca")).append(";");

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
String sqlwrk_x_sif_str = "SELECT `sif_str`, `cena`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina, arso_prjm_status, arso_aktivnost_prjm, arso_odp_embalaza_shema, arso_odp_dej_nastanka, arso_prenos  "+
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

		arso_prjm_status.append("arso_prjm_status[").append(tmpSif).append("]='").append(String.valueOf(rswrk_x_sif_str.getString("arso_prjm_status"))).append("';");
		arso_aktivnost_prjm.append("arso_aktivnost_prjm[").append(tmpSif).append("]='").append(String.valueOf(rswrk_x_sif_str.getString("arso_aktivnost_prjm"))).append("';");
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
//		if (rswrk_x_sif_kam.getString("kamion") != null) tmpValue_x_sif_kam = rswrk_x_sif_kam.getString("kamion");
//		x_sif_kamList.append(">").append(rswrk_x_sif_kam.getString("sif_kam") + "   ").append(tmpValue_x_sif_kam).append("</option>");
		
		cena_km.append("cena_km[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("cena_km"))).append(";");
		cena_ura.append("cena_ura[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("cena_ura"))).append(";");
		cena_kg.append("cena_kg[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("cena_kg"))).append(";");
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
		material_sit_sort.append("material_sit_sort[").append(rowcntwrk_x_koda).append("]=").append(String.valueOf(rswrk_x_koda.getDouble("sit_sort"))).append(";");
		material_sit_zaup.append("material_sit_zaup[").append(rowcntwrk_x_koda).append("]=").append(String.valueOf(rswrk_x_koda.getDouble("sit_zaup"))).append(";");
		material_sit_smet.append("material_sit_smet[").append(rowcntwrk_x_koda).append("]=").append(String.valueOf(rswrk_x_koda.getDouble("sit_smet"))).append(";");
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
x_skupinaList = new StringBuffer("<select name=\"x_skupina_ll\"><option value=\"\">Izberi</option>");

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


String cbo_x_enota_js = "";
x_enoteList = new StringBuffer("<select name=\"x_enote_ll\"><option value=\"\">Izberi</option>");

String sqlwrk_x_enota = "SELECT `sif_enote`, `naziv` FROM `enote`";
Statement stmtwrk_x_enota = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_enota = stmtwrk_x_enota.executeQuery(sqlwrk_x_enota);
	int rowcntwrk_x_enota = 0;
	while (rswrk_x_enota.next()) {
		x_enoteList.append("<option value=\"").append(HTMLEncode(rswrk_x_enota.getString("sif_enote"))).append("\"");
		if (rswrk_x_enota.getString("sif_enote").equals(x_sif_enote)) {
			x_enoteList.append(" selected");
		}


		enote.append("enota[").append(rswrk_x_enota.getString("sif_enote")).append("]=").append("'"+rswrk_x_enota.getString("naziv")+"'").append(";");

		String tmpValue_x_enota = "";
		if (rswrk_x_enota.getString("naziv")!= null) tmpValue_x_enota = rswrk_x_enota.getString("naziv");
		x_enoteList.append(">").append(tmpValue_x_enota).append("</option>");
		rowcntwrk_x_enota++;
	}
rswrk_x_enota.close();
rswrk_x_enota = null;
stmtwrk_x_enota.close();
stmtwrk_x_enota = null;
x_enoteList.append("</select>");


}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : dobavnice<br><br><a href="doblist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
var cena_km = new Array();
<%=cena_km%>
var cena_ura = new Array();
<%=cena_ura%>
var cena_kg = new Array();
<%=cena_kg%>
var c_km = new Array();
<%=c_km%>
var c_ura = new Array();
<%=c_ura%>
var sif_kupac2 = new Array();
<%=sif_kupac2%>
var sif_kupac = new Array();
<%=sif_kupac%>
var sif_skupina = new Array();
<%=sif_skupina%>
var sif_enote = new Array();
<%=sif_enote%>
var kupac = new Array();
<%=kupac%>
var skupina = new Array();
<%=skupina%>
var enota = new Array();
<%=enote%>
var stranka_cena = new Array();
<%=stranka_cena%>

var material_sit_sort = new Array();
<%=material_sit_sort%>
var material_sit_zaup = new Array();
<%=material_sit_zaup%>
var material_sit_smet = new Array();
<%=material_sit_smet%>
var sif_ewc = new Array();
<%=sif_ewc%>

var arso_prjm_status = new Array();
<%=arso_prjm_status%>
var arso_aktivnost_prjm = new Array();
<%=arso_aktivnost_prjm%>
var arso_odp_embalaza_shema = new Array();
<%=arso_odp_embalaza_shema%>
var arso_odp_dej_nastanka = new Array();
<%=arso_odp_dej_nastanka%>
var arso_prenos = new Array();
<%=arso_prenos%>

function updateSubfileds(EW_this){
	document.dobedit.x_c_km.value = c_km[document.dobedit.x_sif_kam.value];
	document.dobedit.x_c_ura.value = c_ura[document.dobedit.x_sif_kam.value];
	document.dobedit.x_cena_km.value = cena_km[document.dobedit.x_sif_kam.value];
	document.dobedit.x_cena_ura.value = cena_ura[document.dobedit.x_sif_kam.value];
	document.dobedit.x_cena_kg.value = cena_kg[document.dobedit.x_sif_kam.value];
}


function updateDropDowns(EW_this){
	//document.dobedit.x_sif_kupca_ll.selectedIndex = 1 + kupac[sif_kupac[document.dobedit.x_sif_str.value]];
	//document.dobedit.x_sif_kupca.value = sif_kupac[document.dobedit.x_sif_str.value];
	//document.dobedit.x_skupina_ll.selectedIndex = 1 + skupina[sif_skupina[document.dobedit.x_sif_str.value]];
	//document.dobedit.x_skupina.value = sif_skupina[document.dobedit.x_sif_str.value];
	
	//document.dobedit.x_enote_ll.value = sif_enote[document.dobedit.x_sif_str.value];

	document.dobedit.x_cena.value = stranka_cena[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_prjm_status.value = arso_prjm_status[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_aktivnost_prjm.value = arso_aktivnost_prjm[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_odp_embalaza_shema.value = arso_odp_embalaza_shema[document.dobedit.x_sif_str.value];
	document.dobedit.x_arso_odp_dej_nastanka.value = arso_odp_dej_nastanka[document.dobedit.x_sif_str.value];
	if(arso_prenos[document.dobadd.x_sif_str.value] == "0") {
		document.dobadd.x_arso_prenos[0].checked = true;
	} else {
		document.dobadd.x_arso_prenos[1].checked = true;		
	}

}

function updateDropDowns2(EW_this){
	document.dobedit.x_sif_str[0].selected = true;
	
	for (i=1; i<document.dobedit.x_sif_str.length; i++) {
		if (sif_kupac[document.dobedit.x_sif_str[i].value] != sif_kupac2[document.dobedit.x_sif_kupca_ll.selectedIndex-1]) {
			document.dobedit.x_sif_str[i].style.display = "none";
		}
		else {
			document.dobedit.x_sif_str[i].style.display = "block";
		}
	
	}
	
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
	//document.dobedit.x_sif_kupca_ll.disabled=true;
	//document.dobedit.x_skupina_ll.disabled=true;
}
function  EW_checkMyForm(EW_this) {
if (EW_this.x_st_dob && !EW_hasValue(EW_this.x_st_dob, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "NapaÄŤna Ĺˇtevilka - st dob"))
                return false; 
        }
if (EW_this.x_st_dob && !EW_checkinteger(EW_this.x_st_dob.value)) {
        if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "NapaÄŤna Ĺˇtevilka - st dob"))
            return false; 
        }
if (EW_this.x_pozicija && !EW_hasValue(EW_this.x_pozicija, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "NapaÄŤna Ĺˇtevilka - pozicija"))
                return false; 
        }
if (EW_this.x_pozicija && !EW_checkinteger(EW_this.x_pozicija.value)) {
        if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "NapaÄŤna Ĺˇtevilka - pozicija"))
            return false; 
        }
if (EW_this.x_datum && !EW_checkeurodate(EW_this.x_datum.value)) {
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "NapaÄŤen datum (dd.mm.yyyy) - datum"))
            return false; 
        }
if(EW_this.x_datum.value.length == 0 ){
    if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum"))
        return false; 
}
if (EW_this.x_sif_str && !EW_hasValue(EW_this.x_sif_str, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_str, "SELECT", "NapaÄŤna Ĺˇtevilka - sif str"))
                return false; 
        }
if (EW_this.x_sif_str.value.length == 0) {
    if (!EW_onError(EW_this, EW_this.x_sif_str, "SELECT", "NapaÄŤna Ĺˇtevilka - sif str"))
        return false; 
}
if (EW_this.x_sif_kupca && !EW_hasValue(EW_this.x_sif_kupca, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kupca, "SELECT", "NapaÄŤan vnos - sif kupca"))
                return false; 
        }
if (EW_this.x_sif_kam && !EW_hasValue(EW_this.x_sif_kam, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kam, "SELECT", "NapaÄŤan vnos - sif kam"))
                return false; 
        }
if (EW_this.x_sif_kam.value.length == 0) {
    if (!EW_onError(EW_this, EW_this.x_sif_kam, "SELECT", "NapaÄŤan vnos - sif kam"))
        return false; 
}
if (EW_this.x_cena_km && !EW_checknumber(EW_this.x_cena_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_km, "TEXT", "NapaÄŤna Ĺˇtevilka - cena km"))
            return false; 
        }
if (EW_this.x_cena_ura && !EW_checknumber(EW_this.x_cena_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_ura, "TEXT", "NapaÄŤna Ĺˇtevilka - cena ura"))
            return false; 
        }
if (EW_this.x_c_km && !EW_checknumber(EW_this.x_c_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_km, "TEXT", "NapaÄŤna Ĺˇtevilka - c km"))
            return false; 
        }
if (EW_this.x_c_ura && !EW_checknumber(EW_this.x_c_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_ura, "TEXT", "NapaÄŤna Ĺˇtevilka - c ura"))
            return false; 
        }
if (EW_this.x_stev_km && !EW_checknumber(EW_this.x_stev_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_km, "TEXT", "NapaÄŤna Ĺˇtevilka - stev km"))
            return false; 
        }
if (EW_this.x_stev_ur && !EW_checknumber(EW_this.x_stev_ur.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_ur, "TEXT", "NapaÄŤna Ĺˇtevilka - stev ur"))
            return false; 
        }
if (EW_this.x_stroski && !EW_checknumber(EW_this.x_stroski.value)) {
        if (!EW_onError(EW_this, EW_this.x_stroski, "TEXT", "NapaÄŤna Ĺˇtevilka - stroski"))
            return false; 
        }
if (EW_this.x_koda && !EW_hasValue(EW_this.x_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_koda, "SELECT", "NapaÄŤan vnos - koda"))
                return false; 
        }
if (EW_this.x_ewc && !EW_hasValue(EW_this.x_ewc, "SELECT" )) {
    if (!EW_onError(EW_this, EW_this.x_ewc, "SELECT", "NapaÄŤan vnos - ewc"))
        return false; 
}
if (EW_this.x_kolicina && !EW_checkinteger(EW_this.x_kolicina.value)) {
        if (!EW_onError(EW_this, EW_this.x_kolicina, "TEXT", "NapaÄŤna Ĺˇtevilka - kolicina"))
            return false; 
        }
if (EW_this.x_cena && !EW_checknumber(EW_this.x_cena.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena, "TEXT", "NapaÄŤna Ĺˇtevilka - cena"))
            return false; 
        }
if (EW_this.x_kg_zaup && !EW_checkinteger(EW_this.x_kg_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_kg_zaup, "TEXT", "NapaÄŤna Ĺˇtevilka - kg zaup"))
            return false; 
        }
if (EW_this.x_sit_zaup && !EW_checknumber(EW_this.x_sit_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_zaup, "TEXT", "NapaÄŤna Ĺˇtevilka - sit zaup"))
            return false; 
        }
if (EW_this.x_kg_sort && !EW_checkinteger(EW_this.x_kg_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_kg_sort, "TEXT", "NapaÄŤna Ĺˇtevilka - kg sort"))
            return false; 
        }
if (EW_this.x_sit_sort && !EW_checknumber(EW_this.x_sit_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_sort, "TEXT", "NapaÄŤna Ĺˇtevilka - sit sort"))
            return false; 
        }
if (EW_this.x_sit_smet && !EW_checknumber(EW_this.x_sit_smet.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_smet, "TEXT", "NapaÄŤna Ĺˇtevilka - sit smet"))
            return false; 
        }
if (EW_this.x_skupina && !EW_hasValue(EW_this.x_skupina, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_skupina, "SELECT", "NapaÄŤna Ĺˇtevilka - skupina"))
                return false; 
        }
if (EW_this.x_enote && !EW_hasValue(EW_this.x_enote, "SELECT" )) {
    if (!EW_onError(EW_this, EW_this.x_enote, "SELECT", "NapaÄŤna Ĺˇtevilka - enote"))
        return false; 
}
if (EW_this.x_stev_km_norm && !EW_checknumber(EW_this.x_stev_km_norm.value)) {
    if (!EW_onError(EW_this, EW_this.x_stev_km_norm, "TEXT", "NapaÄŤna Ĺˇtevilka - stev km normativ"))
        return false; 
    }
if (EW_this.x_stev_ur_norm && !EW_checknumber(EW_this.x_stev_ur_norm.value)) {
    if (!EW_onError(EW_this, EW_this.x_stev_ur_norm, "TEXT", "NapaÄŤna Ĺˇtevilka - stev ur normativ"))
        return false; 
    }
if (EW_this.x_dod_stroski && !EW_checknumber(EW_this.x_dod_stroski.value)) {
        if (!EW_onError(EW_this, EW_this.x_dod_stroski, "TEXT", "NapaÄŤna Ĺˇtevilka - stev ur sled"))
            return false; 
        }
        
return true;
}
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="dobedit" action="dobedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<input type="hidden" name="x_st_dob" size="30" value="<%= HTMLEncode((String)x_st_dob) %>">
<input type="hidden" name="x_pozicija" size="30" value="<%= HTMLEncode((String)x_pozicija) %>">
<input type="hidden" name="x_sif_kupca" size="30" value="<%= HTMLEncode((String)x_sif_kupca) %>">
<input type="hidden" name="x_skupina" size="30" value="<%= HTMLEncode((String)x_skupina) %>">
 
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
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%><!--span class="jspmaker"><a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_kupca=sif_kupca");%>">Ĺˇifra</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_kupca=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_kupca=naslov");%>">naslov</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_kupca=vse");%>">vse</a>&nbsp;</span-->&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td> 
		<td class="ewTableAltRow"><%out.println(x_sif_strList);%><span class="jspmaker"><a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_stranke=sif_str");%>">šifra</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_stranke=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_stranke=naslov");%>">naslov</a>&nbsp;</span>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stranka&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stranka" size="150" maxlength="255" value="<%= HTMLEncode((String)x_stranka) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_sofList);%><a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_sofer=sif_sof");%>">šifra</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_sofer=sofer");%>">šofer</a>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šofer&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sofer" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sofer) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kamiona&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kamList);%><a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_kamion=sif_kam");%>">šifra</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_kamion=kamion");%>">kamion</a>&nbsp;</td>

	</tr>
	<tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kamion" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kamion) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na km&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_km" size="30" value="<%= HTMLEncode((String)x_cena_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na uro&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_ura" size="30" value="<%= HTMLEncode((String)x_cena_ura) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">c km&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_c_km" size="30" value="<%= HTMLEncode((String)x_c_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">c ura&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_c_ura" size="30" value="<%= HTMLEncode((String)x_c_ura) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število kilometrov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_km" size="30" value="<%= HTMLEncode((String)x_stev_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_ur" size="30" value="<%= HTMLEncode((String)x_stev_ur) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stroški&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stroski" size="30" value="<%= HTMLEncode((String)x_stroski) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_kodaList);%>
		<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_material=koda");%>">koda</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_material=material");%>">material</a></td>
	</tr>
	<tr>
		<td class="ewTableHeader">EWC&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_ewcList);%>&nbsp;
		<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_okolje=koda");%>">ewc</a>&nbsp;<a href="<%out.print("dobedit.jsp?key=" + x_id + "&prikaz_okolje=material");%>">material</a></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Količina&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kolicina" size="30" value="<%= HTMLEncode((String)x_kolicina) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena" size="30" value="<%= HTMLEncode((String)x_cena) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">kg zaup&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kg_zaup" size="30" value="<%= HTMLEncode((String)x_kg_zaup) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit zaup&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_zaup" size="30" value="<%= HTMLEncode((String)x_sit_zaup) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">kg sort&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kg_sort" size="30" value="<%= HTMLEncode((String)x_kg_sort) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit sort&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_sort" size="30" value="<%= HTMLEncode((String)x_sit_sort) %>">&nbsp;</td>
	</tr>
	<tr> 
		<td class="ewTableHeader">sit smet&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_smet" size="30" value="<%= HTMLEncode((String)x_sit_smet) %>">&nbsp;</td>
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
		<td class="ewTableHeader">Enota&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_enoteList);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Enote&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_enote" size="30" maxlength="255" value="<%= HTMLEncode((String)x_enote) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba" size="30" maxlength="255" value="<%= HTMLEncode((String)x_opomba) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dodatni stroški&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dod_stroski" size="30" value="<%= HTMLEncode((String)x_dod_stroski) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število km normativ&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_km_norm" size="30" value="<%= HTMLEncode((String)x_stev_km_norm) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur normativ&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_ur_norm" size="30" value="<%= HTMLEncode((String)x_stev_ur_norm) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso vrsta emb.&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_odp_embalaza">
			<%
				String sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_odp_embalaza'";
				Statement stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_odp_embalaza)) {
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
		<td class="ewTableHeader">Arso št. enot emb.&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_arso_emb_st_enot" size="12" maxlength="10" value="<%= HTMLEncode((String)x_arso_emb_st_enot) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso fizikalne lastnosti&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_odp_fiz_last">
			<%
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_odp_fiz_last'";
				stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_odp_fiz_last)) {
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
		<td class="ewTableHeader">Arso tip odpadka&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_odp_tip">
			<%
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_odp_tip'";
				stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_odp_tip)) {
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
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_aktivnost_pslj'";
				stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split("',");
						for (int i=0; i<x_arso_list.length; i++) {
							String val = x_arso_list[i].replaceAll("'", "");
							String x_arso_listOption = "<option value=\"" + HTMLEncode(val) + "\"";
							if (HTMLEncode(val).equals(x_arso_aktivnost_pslj)) {
								x_arso_listOption += " selected";
							}
							x_arso_listOption += ">" + HTMLEncode(val) + "</option>";
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
		<td class="ewTableHeader">Arso prejemnikov status&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_prjm_status">
			<%
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_prjm_status'";
				stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_prjm_status)) {
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
		<td class="ewTableHeader">Arso postopek ravnanja&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_aktivnost_prjm">
			<%
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_aktivnost_prjm'";
				stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split("',");
						for (int i=0; i<x_arso_list.length; i++) {
							String val = x_arso_list[i].replaceAll("'", "");
							String x_arso_listOption = "<option value=\"" + HTMLEncode(val) + "\"";
							if (HTMLEncode(val).equals(x_arso_aktivnost_prjm)) {
								x_arso_listOption += " selected";
							}
							x_arso_listOption += ">" + HTMLEncode(val) + "</option>";
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
		<td class="ewTableHeader">Arso embalažna shema&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_odp_embalaza_shema">
			<%
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_odp_embalaza_shema'";
				stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_odp_embalaza_shema)) {
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
		<td nowrap class="ewTableHeader">Arso dejavnost nastanka&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_odp_dej_nastanka">
			<%
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_odp_dej_nastanka'";
				stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_odp_dej_nastanka)) {
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
		<td class="ewTableHeader">Arso prenos&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_arso_prenos"  <%= x_arso_prenos == 0? "checked" : "" %> value = "0" >NE&nbsp;<input type="radio" name="x_arso_prenos"  <%= x_arso_prenos == 1? "checked" : "" %> value = "1">DA&nbsp;<input type="radio" name="x_arso_prenos"  <%= x_arso_prenos == 2? "checked" : "" %> value = "2">TUJINA&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso status&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_arso_status"  <%= x_arso_status == 0? "checked" : "" %> value = "0" >ni poslan&nbsp;<input type="radio" name="x_arso_status"  <%= x_arso_status == 1? "checked" : "" %> value = "1">poslan ni potrjen&nbsp;<input type="radio" name="x_arso_status"  <%= x_arso_status == 2? "checked" : "" %> value = "2">poslan in potrjen&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Potrdi" tabindex=1>
</form>
<%@ include file="footer.jsp" %>
