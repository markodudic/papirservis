<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
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

// get current table security
int ewCurSec = 0; // initialise
ewCurSec = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();

if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
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
Object x_zacetek = null;
Object x_uporabnik = null;
String x_arso_odp_embalaza = "";
String x_arso_emb_st_enot = "1";
String x_arso_odp_fiz_last = "";
String x_arso_odp_tip = "";
String x_arso_aktivnost_pslj = "";
String x_arso_prjm_status = "";
String x_arso_aktivnost_prjm = "";
String x_arso_odp_embalaza_shema = "";
String x_arso_odp_dej_nastanka = "";
String x_arso_prenos = "";


StringBuffer x_sif_strList = null;
StringBuffer x_sif_kupcaList = null;
StringBuffer x_kodaList = null;
StringBuffer x_ewcList = null;
StringBuffer x_sif_sofList = null;
StringBuffer x_sif_kamList = null;
StringBuffer x_skupinaList = null;
StringBuffer x_enoteList = null;
StringBuffer cena_km = new StringBuffer();
StringBuffer cena_ura = new StringBuffer();
StringBuffer cena_kg = new StringBuffer();
StringBuffer c_km = new StringBuffer();
StringBuffer c_ura = new StringBuffer();

StringBuffer material_sit_sort = new StringBuffer();
StringBuffer material_sit_zaup = new StringBuffer();
StringBuffer material_sit_smet = new StringBuffer();
StringBuffer sif_ewc = new StringBuffer();
StringBuffer arso_prenos = new StringBuffer();
StringBuffer dovoljenje = new StringBuffer();

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabela") + " dob WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
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
		}
		rs.first();
	
		// Get the field contents
		x_st_dob = String.valueOf(rs.getLong("st_dob"));
		
		//dolocim max pozicije in povecam za 1
		Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
		ResultSet rs1 = null;
		String strsql1 = "SELECT max(pozicija)+1 as pozicija FROM " + session.getAttribute("letoTabela") + " dob WHERE st_dob=" + x_st_dob;
		rs1 = stmt1.executeQuery(strsql1);
		if (rs1.next()){
			x_pozicija = String.valueOf(rs1.getLong("pozicija"));
			
			rs1.close();
			rs1 = null;
			stmt1.close();
			stmt1 = null;
		}
			
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
	//	x_cena = String.valueOf(rs.getDouble("cena"));
		x_cena = "0.0";
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
	//	x_stev_km_sled = String.valueOf(rs.getDouble("stev_km_sled"));
	//	x_stev_ur_sled = String.valueOf(rs.getDouble("stev_ur_sled"));
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
	
		// arso_prjm_status
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


		// arso_prenos
		if (rs.getString("arso_prenos") != null){
			x_arso_prenos = rs.getString("arso_prenos");
		}else{
			x_arso_prenos = "";
		}
		
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add
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
		if (request.getParameter("x_skupina") != null){
			x_skupina = request.getParameter("x_skupina");
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
		if (request.getParameter("x_zacetek") != null){
			x_zacetek = (String) request.getParameter("x_zacetek");
		}else{
			x_zacetek = "";
		}
		if (request.getParameter("x_uporabnik") != null){
			x_uporabnik = request.getParameter("x_uporabnik");
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
			x_arso_odp_dej_nastanka = (String) request.getParameter("x_arso_odp_dej_nastanka");
		}else{
			x_arso_odp_dej_nastanka = "";
		}
		if (request.getParameter("x_arso_prenos") != null){
			x_arso_prenos = (String) request.getParameter("x_arso_prenos");
		}else{
			x_arso_prenos = "";
		}		
		

		String strsql = "insert into " + session.getAttribute("letoTabela") + " (st_dob, pozicija, datum, sif_str, stranka, sif_kupca, sif_sof, sofer, sif_kam, kamion	, cena_km, cena_ura, c_km, c_ura, stev_km, stev_ur, stroski, koda, ewc, kolicina, cena, kg_zaup, sit_zaup, kg_sort, sit_sort, sit_smet, skupina, skupina_text, sif_enote, naziv_enote, opomba, obdelana, arso_odp_embalaza, arso_emb_st_enot, arso_odp_fiz_last, arso_odp_tip, arso_aktivnost_pslj, arso_prjm_status, arso_aktivnost_prjm, arso_odp_embalaza_shema, arso_odp_dej_nastanka, arso_prenos, uporabnik) values (";


		// Field st_dob
		tmpfld = ((String) x_st_dob).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		strsql += tmpfld + ", ";

		// Field pozicija
		tmpfld = ((String) x_pozicija).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
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
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";



		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
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
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field sofer
		tmpfld = ((String) x_sofer);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
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
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field kamion
		tmpfld = ((String) x_kamion);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
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


		// Field stev_km
		tmpfld = ((String) x_stev_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field stev_ur
		tmpfld = ((String) x_stev_ur).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field stroski
		tmpfld = ((String) x_stroski).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field koda
		tmpfld = ((String) x_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
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
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field kolicina
		tmpfld = ((String) x_kolicina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field cena
		tmpfld = ((String) x_cena).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";


		// Field kg_zaup
		tmpfld = ((String) x_kg_zaup).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field sit_zaup
		tmpfld = ((String) x_sit_zaup).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field kg_sort
		tmpfld = ((String) x_kg_sort).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field sit_sort
		tmpfld = ((String) x_sit_sort).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field sit_smet
		tmpfld = ((String) x_sit_smet).trim();
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
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field enota
		tmpfld = ((String) x_sif_enote).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";
		
		// Field naziv enote
		tmpfld = ((String) x_enote);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
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
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		strsql += "1, "; //obdelana
		

		// Field arso_odp_embalaza
		tmpfld = ((String) x_arso_odp_embalaza).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field arso_emb_st_enot
		tmpfld = ((String) x_arso_emb_st_enot).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field arso_odp_fiz_last
		tmpfld = ((String) x_arso_odp_fiz_last).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field arso_odp_tip
		tmpfld = ((String) x_arso_odp_tip).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field arso_aktivnost_pslj
		tmpfld = ((String) x_arso_aktivnost_pslj).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field arso_prjm_status
		tmpfld = ((String) x_arso_prjm_status).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";
		
		// Field arso_aktivnost_prjm
		tmpfld = ((String) x_arso_aktivnost_prjm).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field dod_stroski
		tmpfld = ((String) x_arso_odp_embalaza_shema).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";

		// Field arso_odp_dej_nastanka
		tmpfld = ((String) x_arso_odp_dej_nastanka).trim();
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";
		
		// Field arso_prenos
		tmpfld = ((String) x_arso_prenos);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if(tmpfld != null)
			strsql += "'" + tmpfld + "', ";
		else
			strsql += tmpfld + ", ";
		
		//Uporabnik
		strsql += session.getAttribute("papirservis1_status_UserID") + ")";

	
		Statement stmt1 = conn.createStatement();

		stmt1.executeUpdate(strsql);
		stmt1.close();
		stmt1 = null;


		conn = null;
		out.clear();
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
x_sif_kupcaList = new StringBuffer("<select disabled name=\"x_sif_kupca\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci`  where blokada = 0 and potnik = " + session.getAttribute("papirservis1_status_UserID")  + " ORDER BY `naziv` ASC";
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
	strankeQueryFilter = " k.potnik = " + session.getAttribute("papirservis1_status_UserID");
}

String enote = (String) session.getAttribute("enote");
String enoteQueryFilter = "";
if(enote.equals("0")){
	enoteQueryFilter = "k.sif_enote = " + session.getAttribute("papirservis1_status_Enota");
}

String subQuery ="";

if(strankeQueryFilter.length() > 0 || enoteQueryFilter.length() > 0){
	subQuery += " and " + strankeQueryFilter;
	if(strankeQueryFilter.length() > 0 && enoteQueryFilter.length() > 0){
		subQuery += " AND " + enoteQueryFilter;
	}else{
		subQuery += enoteQueryFilter;
	}
}


String cbo_x_sif_str_js = "";
x_sif_strList = new StringBuffer("<select disabled name=\"x_sif_str_list\"><option value=\"\">Izberi</option>");
//String sqlwrk_x_sif_str = "SELECT `sif_str`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina FROM `stranke` s, `osnovna` o, `kupci` k, `skup` sk where s.sif_os = o.sif_os and k.sif_kupca = s.sif_kupca and k.skupina = sk.skupina  and k.blokada = 0 " + subQuery   + " ORDER BY `" + session.getAttribute("dob_stranke_show") + "` ASC";
String sqlwrk_x_sif_str = "SELECT `sif_str`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina  "+
	"FROM (SELECT stranke.* "+
	"	FROM stranke, (SELECT sif_str, max(zacetek) datum FROM stranke group by sif_str ) zadnji "+
	"	WHERE stranke.sif_str = zadnji.sif_str and "+
	"      	stranke.zacetek = zadnji.datum) s,  "+
	"	(SELECT osnovna.* "+
	"		FROM osnovna, (SELECT sif_os, max(zacetek) datum FROM osnovna group by sif_os ) zadnji1 "+
	"		WHERE osnovna.sif_os = zadnji1.sif_os and "+
	"		      osnovna.zacetek = zadnji1.datum) o, "+
	"	`kupci` k, `skup` sk  "+
	"where s.sif_os = o.sif_os and k.sif_kupca = s.sif_kupca and "+ 
	"k.skupina = sk.skupina  and k.blokada = 0 " + subQuery  + 
	" ORDER BY `" + session.getAttribute("dob_stranke_show") + "` ASC";

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
		String tmpValue_x_sif_str = "";
		String find = (String)session.getAttribute("dob_stranke_show");
		String tmpNaziv = tmpNaziv = rswrk_x_sif_str.getString("naziv") + ", " + rswrk_x_sif_str.getString("sif_str") + ", " + rswrk_x_sif_str.getString("naslov") + ", " + rswrk_x_sif_str.getString("osnovna")  + ", " + rswrk_x_sif_str.getString("kol_os");
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
x_sif_kamList = new StringBuffer("<select disabled " + (a.equals("C") ? "readonly" : "") + " onchange = \"updateSubfileds(this);\" name=\"x_sif_kam\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_kam = "SELECT `kamion`.`sif_kam`, `kamion`, `cena_km`, `cena_ura`, `cena_kg`, `c_km`, `c_ura` "+
	"FROM `kamion`, (select sif_kam, max(zacetek) as zacetek from kamion group by sif_kam) as k "+
	"where kamion.sif_kam = k.sif_kam and kamion.zacetek = k.zacetek "+
	"order by " + session.getAttribute("dob_kamion_show") + " asc";
//	"order by `kamion`.kamion asc";

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
x_kodaList = new StringBuffer("<select  onchange = \"updateKoda(this);\" name=\"x_koda\"><option value=\"\">Izberi</option>");
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
		if (rswrk_x_koda.getString("koda").equals(x_koda)) {
			x_kodaList.append(" selected");
		}
		String tmpValue_x_koda = "";
		if (rswrk_x_koda.getString("material")!= null) tmpValue_x_koda = rswrk_x_koda.getString("material");
		x_kodaList.append(">").append(rswrk_x_koda.getString("koda") + "   ").append(tmpValue_x_koda).append("</option>");

		material_sit_sort.append("material_sit_sort[").append(rowcntwrk_x_koda).append("]=").append(String.valueOf(rswrk_x_koda.getDouble("sit_sort"))).append(";");
		material_sit_zaup.append("material_sit_zaup[").append(rowcntwrk_x_koda).append("]=").append(String.valueOf(rswrk_x_koda.getDouble("sit_zaup"))).append(";");
		material_sit_smet.append("material_sit_smet[").append(rowcntwrk_x_koda).append("]=").append(String.valueOf(rswrk_x_koda.getDouble("sit_smet"))).append(";");

		sif_ewc.append("sif_ewc[").append(rowcntwrk_x_koda).append("]='").append(String.valueOf(rswrk_x_koda.getString("okolje_koda"))).append("';");

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
x_sif_sofList = new StringBuffer("<select disabled name=\"x_sif_sof\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_sof = "SELECT `sif_sof`, `sofer` FROM `sofer` order by `sofer` asc";
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
x_skupinaList = new StringBuffer("<select name=\"x_skupina\"><option value=\"\">Izberi</option>");
String sqlwrk_x_skupina = "SELECT `skupina`, `tekst` FROM `skup`";
Statement stmtwrk_x_skupina = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_skupina = stmtwrk_x_skupina.executeQuery(sqlwrk_x_skupina);
	int rowcntwrk_x_skupina = 0;
	while (rswrk_x_skupina.next()) {
		x_skupinaList.append("<option value=\"").append(HTMLEncode(rswrk_x_skupina.getString("skupina"))).append("\"");
		if (rswrk_x_skupina.getString("skupina").equals(x_skupina)) {
			x_skupinaList.append(" selected");
		}
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
x_enoteList = new StringBuffer("<select onchange = \"updateSubfileds2(this);\" name=\"x_enote_ll\"><option value=\"\">Izberi</option>");

String sqlwrk_x_enota = "SELECT `sif_enote`, `naziv` FROM `enote`";
Statement stmtwrk_x_enota = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_enota = stmtwrk_x_enota.executeQuery(sqlwrk_x_enota);
	int rowcntwrk_x_enota = 0;
	while (rswrk_x_enota.next()) {
		x_enoteList.append("<option value=\"").append(HTMLEncode(rswrk_x_enota.getString("sif_enote"))).append("\"");
		if (rswrk_x_enota.getString("sif_enote").equals(x_sif_enote)) {
			x_enoteList.append(" selected");
		}


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


String sqlwrk_x_dovoljenje = "SELECT enote.sif_enote, if(ewc_kontrola=0, 0, ifnull(ewc,0)) ewc FROM dovoljenje right join enote on (dovoljenje.sif_enote = enote.sif_enote)";
Statement stmtwrk_x_dovoljenje = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_dovoljenje = stmtwrk_x_dovoljenje.executeQuery(sqlwrk_x_dovoljenje);
	dovoljenje.append(";");
	while (rswrk_x_dovoljenje.next()) {
		dovoljenje.append(rswrk_x_dovoljenje.getString("sif_enote")+";"+rswrk_x_dovoljenje.getString("ewc")+";");
	}
rswrk_x_dovoljenje.close();
rswrk_x_dovoljenje = null;
stmtwrk_x_dovoljenje.close();
stmtwrk_x_dovoljenje = null;

}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: dobavnice<br><br><a href="doblist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript
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


var sif_ewc = new Array();
<%=sif_ewc%>
var material_sit_sort = new Array();
<%=material_sit_sort%>
var material_sit_zaup = new Array();
<%=material_sit_zaup%>
var material_sit_smet = new Array();
<%=material_sit_smet%>
var dovoljenje = "<%=dovoljenje%>";

function disableSome(EW_this){
}

function updateSubfileds(EW_this){
<%if(!a.equals("C")){%>
document.dobadd.x_c_km.value = c_km[document.dobadd.x_sif_kam.value];
document.dobadd.x_c_ura.value = c_ura[document.dobadd.x_sif_kam.value];
document.dobadd.x_cena_km.value = cena_km[document.dobadd.x_sif_kam.value];
document.dobadd.x_cena_ura.value = cena_ura[document.dobadd.x_sif_kam.value];
document.dobadd.x_cena_kg.value = cena_kg[document.dobadd.x_sif_kam.value];
<%}%>
}


function updateKoda(EW_this){
	document.dobadd.x_sit_sort.value = material_sit_sort[document.dobadd.x_koda.selectedIndex - 1];
	document.dobadd.x_sit_zaup.value = material_sit_zaup[document.dobadd.x_koda.selectedIndex - 1];
	document.dobadd.x_sit_smet.value = material_sit_smet[document.dobadd.x_koda.selectedIndex - 1];

	if (sif_ewc[document.dobadd.x_koda.selectedIndex-1] != "null")
		document.dobadd.x_ewc_ll.value = sif_ewc[document.dobadd.x_koda.selectedIndex-1];
	else
		document.dobadd.x_ewc_ll.selectedIndex = 0;
}

function  EW_checkMyForm(EW_this) {
	if ((dovoljenje.indexOf(";" + EW_this.x_enote_ll.value + ";" + EW_this.x_ewc_ll.value + ";") < 0) &&
		(dovoljenje.indexOf(";" + EW_this.x_enote_ll.value + ";0;") < 0))	{
		alert("EWC koda ne ustreza dovoljenju na tej kodi");	
        return false; 
    }

	
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
if (EW_this.x_datum && !EW_checkeurodate(EW_this.x_datum.value) && !EW_hasValue(EW_this.x_datum, "TEXT" )) {
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum"))
            return false; 
        }
if (EW_this.x_sif_str && !EW_hasValue(EW_this.x_sif_str, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_str, "SELECT", "Napačna številka - sif str"))
                return false; 
        }
if (EW_this.x_sif_kupca && !EW_hasValue(EW_this.x_sif_kupca, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kupca, "SELECT", "Napačan vnos - sif kupca"))
                return false; 
        }
if (EW_this.x_sif_kam && !EW_hasValue(EW_this.x_sif_kam, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kam, "SELECT", "Napačan vnos - sif kam"))
                return false; 
        }
if (EW_this.x_cena_km && !EW_checknumber(EW_this.x_cena_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_km, "TEXT", "Napačna številka - cena km"))
            return false; 
        }
if (EW_this.x_cena_ura && !EW_checknumber(EW_this.x_cena_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_ura, "TEXT", "Napačna številka - cena ura"))
            return false; 
        }
if (EW_this.x_c_km && !EW_checknumber(EW_this.x_c_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_km, "TEXT", "Napačna številka - c km"))
            return false; 
        }
if (EW_this.x_c_ura && !EW_checknumber(EW_this.x_c_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_ura, "TEXT", "Napačna številka - c ura"))
            return false; 
        }
if (EW_this.x_stev_km && !EW_checknumber(EW_this.x_stev_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_km, "TEXT", "Napačna številka - stev km"))
            return false; 
        }
if (EW_this.x_stev_ur && !EW_checknumber(EW_this.x_stev_ur.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_ur, "TEXT", "Napačna številka - stev ur"))
            return false; 
        }
if (EW_this.x_stroski && !EW_checknumber(EW_this.x_stroski.value)) {
        if (!EW_onError(EW_this, EW_this.x_stroski, "TEXT", "Napačna številka - stroski"))
            return false; 
        }
if (EW_this.x_koda && !EW_hasValue(EW_this.x_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_koda, "SELECT", "Napačan vnos - koda"))
                return false; 
        }
if (EW_this.x_ewc && !EW_hasValue(EW_this.x_ewc, "SELECT" )) {
    if (!EW_onError(EW_this, EW_this.x_ewc, "SELECT", "Napačan vnos - ewc"))
        return false; 
}
if (EW_this.x_kolicina && !EW_checkinteger(EW_this.x_kolicina.value)) {
        if (!EW_onError(EW_this, EW_this.x_kolicina, "TEXT", "Napačna številka - kolicina"))
            return false; 
        }
if (EW_this.x_cena && !EW_checknumber(EW_this.x_cena.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena, "TEXT", "Napačna številka - cena"))
            return false; 
        }
if (EW_this.x_kg_zaup && !EW_checkinteger(EW_this.x_kg_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_kg_zaup, "TEXT", "Napačna številka - kg zaup"))
            return false; 
        }
if (EW_this.x_sit_zaup && !EW_checknumber(EW_this.x_sit_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_zaup, "TEXT", "Napačna številka - sit zaup"))
            return false; 
        }
if (EW_this.x_kg_sort && !EW_checkinteger(EW_this.x_kg_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_kg_sort, "TEXT", "Napačna številka - kg sort"))
            return false; 
        }
if (EW_this.x_sit_sort && !EW_checknumber(EW_this.x_sit_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_sort, "TEXT", "Napačna številka - sit sort"))
            return false; 
        }
if (EW_this.x_sit_smet && !EW_checknumber(EW_this.x_sit_smet.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_smet, "TEXT", "Napačna številka - sit smet"))
            return false; 
        }
if (EW_this.x_skupina && !EW_hasValue(EW_this.x_skupina, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_skupina, "SELECT", "Napačna številka - skupina"))
                return false; 
        }
/*if (EW_this.x_stev_km_sled && !EW_checknumber(EW_this.x_stev_km_sled.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_km_sled, "TEXT", "Napačna številka - stev km sled"))
            return false; 
        }
if (EW_this.x_stev_ur_sled && !EW_checknumber(EW_this.x_stev_ur_sled.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_ur_sled, "TEXT", "Napačna številka - stev ur sled"))
            return false; 
        }*/
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="dobadd" action="dobadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<input type="hidden" name="x_sif_str" size="30" value="<%= HTMLEncode((String)x_sif_str) %>">
<input type="hidden" name="x_sif_kupca" size="30" value="<%= HTMLEncode((String)x_sif_kupca) %>">
<input type="hidden" name="x_sif_sof" size="30" value="<%= HTMLEncode((String)x_sif_sof) %>">
<input type="hidden" name="x_sif_kam" size="30" value="<%= HTMLEncode((String)x_sif_kam) %>">
<!-- input type="hidden" name="x_skupina" size="30" value="<%= HTMLEncode((String)x_skupina) %>"-->
<input type="hidden" name="x_st_dob" size="30" value="<%= HTMLEncode((String)x_st_dob) %>">
<input type="hidden" name="x_pozicija" size="30" value="<%= HTMLEncode((String)x_pozicija) %>">

<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Številka dobavnice&nbsp;</td>
		<td class="ewTableAltRow"><% if (x_st_dob== null || ((String)x_st_dob).equals("")) {x_st_dob = "0"; } // set default value %><input type="text" name="x_st_dob_UN" size="30" value="<%= HTMLEncode((String)x_st_dob) %>" <%= a.equals("C") ? "disabled" : ""%>>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pozicija&nbsp;</td>
		<td class="ewTableAltRow"><% if (x_pozicija== null || ((String)x_pozicija).equals("")) {x_pozicija = "0"; } // set default value %><input type="text" name="x_pozicija_un" size="30" value="<%= HTMLEncode((String)x_pozicija) %>" <%= a.equals("C") ? "disabled" : ""%>>&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_datum" value="<%= EW_FormatDateTime(x_datum,7, locale) %>">&nbsp;
	<!--input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_datum,'dd.mm.yyyy');return false;">&nbsp;</td>
	</tr-->
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_strList);%><!--span class="jspmaker"><a href="<%out.print("dobadd.jsp?prikaz_stranke=sif_str");%>">šifra</a>&nbsp;<a href="<%out.print("dobadd.jsp?prikaz_stranke=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("dobadd.jsp?prikaz_stranke=naslov");%>">naslov</a>&nbsp;</span-->&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Stranka&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_stranka" size="30" maxlength="255" value="<%= HTMLEncode((String)x_stranka) %>">&nbsp;</td>
	<!--/tr-->
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%><!--span class="jspmaker"><a href="<%out.print("dobadd.jsp?prikaz_kupca=sif_kupca");%>">šifra</a>&nbsp;<a href="<%out.print("dobadd.jsp?prikaz_kupca=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("dobadd.jsp?prikaz_kupca=naslov");%>">naslov</a>&nbsp;<a href="<%out.print("dobadd.jsp?prikaz_kupca=vse");%>">vse&nbsp;</a></span-->&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_sofList);%><!--a href="<%out.print("dobadd.jsp?prikaz_sofer=sif_sof");%>">šifra</a>&nbsp;<a href="<%out.print("dobadd.jsp?prikaz_sofer=sofer");%>">šofer</a-->&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Šofer&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_sofer" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sofer) %>">&nbsp;
	<!--/td>
	</tr-->
	<tr>
		<td class="ewTableHeader">Šifra kamiona&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kamList);%><!--a href="<%out.print("dobadd.jsp?prikaz_kamion=sif_kam");%>">šifra</a>&nbsp;<a href="<%out.print("dobadd.jsp?prikaz_kamion=kamion");%>">kamion</a-->&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_kamion" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kamion) %>">&nbsp;</td>
	<!--/tr>
	<tr>
		<td class="ewTableHeader">Cena na km&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_cena_km" size="30" value="<%= a.equals("C") ? "0" : HTMLEncode((String)x_cena_km)%>" <%= a.equals("C") ? "readonly" : ""%>>&nbsp;
	<!--/td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na uro&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_cena_ura" size="30" value="<%= a.equals("C") ? "0" : HTMLEncode((String)x_cena_ura)%>" <%= a.equals("C") ? "readonly" : ""%> >&nbsp;</td>
	<!--/tr>
	<tr>
		<td class="ewTableHeader">c km&nbsp;</td>
		<td class="ewTableAltRow"--><input type="hidden" name="x_c_km" size="30" value="<%= a.equals("C") ? "0" : HTMLEncode((String)x_c_km)%>" <%= a.equals("C") ? "readonly" : ""%>>&nbsp;
	<!--/td>
	</tr>
	<tr>
		<td class="ewTableHeader">c ura&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_c_ura" size="30" value="<%= a.equals("C") ? "0" : HTMLEncode((String)x_c_ura)%>" <%= a.equals("C") ? "readonly" : ""%>>&nbsp;</td>
	<!--/tr>
	<tr>
		<td class="ewTableHeader">Število kilometrov&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_stev_km" size="30" value="<%= a.equals("C") ? "0" : HTMLEncode((String)x_stev_km)%>" <%= a.equals("C") ? "readonly" : ""%>>&nbsp;</td>
	<!--/tr>
	<tr>
		<td class="ewTableHeader">Število ur&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_stev_ur" size="30" value="<%= a.equals("C") ? "0" : HTMLEncode((String)x_stev_ur)%>" <%= a.equals("C") ? "readonly" : ""%>>&nbsp;</td>
	<!--/tr>
	<tr>
		<td class="ewTableHeader">Stroški&nbsp;</td>
		<td class="ewTableAltRow"-->
	<input type="hidden" name="x_stroski" size="30" value="<%= a.equals("C") ? "0" : HTMLEncode((String)x_stroski)%>" <%= a.equals("C") ? "readonly" : ""%>>&nbsp;</td>
	<!--/tr-->
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_kodaList);%>&nbsp;
		<a href="<%out.print("dobadd.jsp?key=" + key + "&prikaz_material=koda");%>">koda</a>&nbsp;<a href="<%out.print("dobadd.jsp?key=" + key + "&prikaz_material=material");%>">material</a></td>
	</tr>
	<tr>
		<td class="ewTableHeader">EWC&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_ewcList);%>&nbsp;
		<a href="<%out.print("dobadd.jsp?key=" + key + "&prikaz_okolje=koda");%>">ewc</a>&nbsp;<a href="<%out.print("dobadd.jsp?key=" + key + "&prikaz_okolje=material");%>">material</a></td>
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
		<td class="ewTableHeader">Enota&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_enoteList);%>&nbsp;</td>
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
		<td class="ewTableHeader">Arso staus prejemnika&nbsp;</td>
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
							x_arso_listOption += ">" + HTMLEncode(val.replaceAll("'", "")) + "</option>";
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
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+ session.getAttribute("letoTabela") + "' AND COLUMN_NAME = 'arso_odp_embalaza_shema' AND TABLE_SCHEMA='salomon'";
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
		<td class="ewTableAltRow"><input type="radio" name="x_arso_prenos"  <%= x_arso_prenos.equals("0")? "checked" : "" %> value = "0" >NE&nbsp;<input type="radio" name="x_arso_prenos"  <%= x_arso_prenos.equals("1")? "checked" : "" %> value = "1">DA&nbsp;<input type="radio" name="x_arso_prenos"  <%= x_arso_prenos.equals("2")? "checked" : "" %> value = "2">TUJINA&nbsp;</td>
	</tr>
	
	<!-- input type="hidden" name="x_skupina_text" size="30" maxlength="255" value="<%= HTMLEncode((String)x_skupina_text) %>"-->&nbsp;
	<input type="hidden" name="x_opomba" size="30" maxlength="255" value="<%= HTMLEncode((String)x_opomba) %>">&nbsp;
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
