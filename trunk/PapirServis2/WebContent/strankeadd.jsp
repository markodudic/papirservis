<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="strankelist.jsp"%>
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

if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("strankelist.jsp"); 
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
Object x_sif_str = null;
Object x_naziv = null;
Object x_naslov = null;
Object x_posta = null;
Object x_kraj = null;
Object x_telefon = null;
Object x_telefax = null;
Object x_kont_os = null;
Object x_del_cas = null;
Object x_sif_os = null;
Object x_kol_os = null;
Object x_opomba = null;
Object x_sif_kupca = null;
Object x_cena = null;
Object x_najem = null;
Object x_cena_naj = null;
Object x_zacetek = null;
Object x_veljavnost = null;
Object x_uporabnik = null;
int x_pon = 0;
int x_tor = 0;
int x_sre = 0;
int x_cet = 0;
int x_pet = 0;
int x_sob = 0;
int x_ned = 0;
Object x_x_koord = null;
Object x_y_koord = null;
Object x_radij = null;
Object x_vtez = null;
Object x_obracun_km = null;
Object x_stev_km_norm = null;
Object x_stev_ur_norm = null;

StringBuffer x_postaList = null;
StringBuffer x_sif_osList = null;
StringBuffer x_sif_kupcaList = null;
// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `stranke` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("strankelist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_sif_str = String.valueOf(rs.getLong("sif_str"));
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
	if (rs.getString("telefon") != null){
		x_telefon = rs.getString("telefon");
	}else{
		x_telefon = "";
	}
	if (rs.getString("telefax") != null){
		x_telefax = rs.getString("telefax");
	}else{
		x_telefax = "";
	}
	if (rs.getString("kont_os") != null){
		x_kont_os = rs.getString("kont_os");
	}else{
		x_kont_os = "";
	}
	if (rs.getString("del_cas") != null){
		x_del_cas = rs.getString("del_cas");
	}else{
		x_del_cas = "";
	}
	if (rs.getString("sif_os") != null){
		x_sif_os = rs.getString("sif_os");
	}else{
		x_sif_os = "";
	}
	x_kol_os = String.valueOf(rs.getLong("kol_os"));
	if (rs.getString("opomba") != null){
		x_opomba = rs.getString("opomba");
	}else{
		x_opomba = "";
	}
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}
	x_cena = String.valueOf(rs.getDouble("cena"));
	if (rs.getString("najem") != null){
		x_najem = rs.getString("najem");
	}else{
		x_najem = "";
	}
	x_cena_naj = String.valueOf(rs.getDouble("cena_naj"));
	if (rs.getTimestamp("zacetek") != null){
		x_zacetek = rs.getTimestamp("zacetek");
	}else{
		x_zacetek = null;
	}
	if (rs.getTimestamp("veljavnost") != null){
		x_veljavnost = rs.getTimestamp("veljavnost");
	}else{
		x_veljavnost = null;
	}
 
	x_uporabnik = String.valueOf(rs.getLong("uporabnik"));

	x_pon = rs.getInt("pon");
	x_tor = rs.getInt("tor");
	x_sre = rs.getInt("sre");
	x_cet = rs.getInt("cet");
	x_pet = rs.getInt("pet");
	x_sob = rs.getInt("sob");
	x_ned = rs.getInt("ned");

	// lokacija
	if (rs.getString("x_koord") != null){
		x_x_koord = rs.getString("x_koord");
	}else{
		x_x_koord = "";
	}
	
	// lokacija
	if (rs.getString("y_koord") != null){
		x_y_koord = rs.getString("y_koord");
	}else{
		x_y_koord = "";
	}
	
	
	// lokacija
	if (rs.getString("radij") != null){
		x_radij = rs.getString("radij");
	}else{
		x_radij = "";
	}	
	
	// vtez
	if (rs.getString("vtez") != null){
		x_vtez = rs.getString("vtez");
	}else{
		x_vtez = "";
	}
	x_obracun_km = String.valueOf(rs.getDouble("obracun_km"));
	x_stev_km_norm = String.valueOf(rs.getDouble("stev_km_norm"));
	x_stev_ur_norm = String.valueOf(rs.getDouble("stev_ur_norm"));
	
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add
		
		// Get fields from form
		if (request.getParameter("x_sif_str") != null){
			x_sif_str = (String) request.getParameter("x_sif_str");
		}else{
			x_sif_str = "";
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

		if (request.getParameter("x_posta") != null){
			x_posta = request.getParameter("x_posta");
		}
		if (request.getParameter("x_kraj") != null){
			x_kraj = (String) request.getParameter("x_kraj");
		}else{
			x_kraj = "";
		}

		if (request.getParameter("x_telefon") != null){
			x_telefon = (String) request.getParameter("x_telefon");
		}else{
			x_telefon = "";
		}
		if (request.getParameter("x_telefax") != null){
			x_telefax = (String) request.getParameter("x_telefax");
		}else{
			x_telefax = "";
		}
		if (request.getParameter("x_kont_os") != null){
			x_kont_os = (String) request.getParameter("x_kont_os");
		}else{
			x_kont_os = "";
		}
		if (request.getParameter("x_del_cas") != null){
			x_del_cas = (String) request.getParameter("x_del_cas");
		}else{
			x_del_cas = "";
		}
		if (request.getParameter("x_sif_os") != null){
			x_sif_os = request.getParameter("x_sif_os");
		}
		if (request.getParameter("x_kol_os") != null){
			x_kol_os = (String) request.getParameter("x_kol_os");
		}else{
			x_kol_os = "";
		}
		if (request.getParameter("x_opomba") != null){
			x_opomba = (String) request.getParameter("x_opomba");
		}else{
			x_opomba = "";
		}
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = request.getParameter("x_sif_kupca");
		}
		if (request.getParameter("x_cena") != null){
			x_cena = (String) request.getParameter("x_cena");
		}else{
			x_cena = "";
		}
		if (request.getParameter("x_najem") != null){
			x_najem = (String) request.getParameter("x_najem");
		}else{
			x_najem = "";
		}
		if (request.getParameter("x_cena_naj") != null){
			x_cena_naj = (String) request.getParameter("x_cena_naj");
		}else{
			x_cena_naj = "";
		}
		if (request.getParameter("x_zacetek") != null){
			x_zacetek = (String) request.getParameter("x_zacetek");
		}else{
			x_zacetek = "";
		}

		if (request.getParameter("x_veljavnost") != null){
			x_veljavnost = (String) request.getParameter("x_veljavnost");
		}else{
			x_veljavnost = "";
		}

		if (request.getParameter("x_uporabnik") != null){
			x_uporabnik = request.getParameter("x_uporabnik");
		}
		if (request.getParameter("x_pon") != null){
			x_pon = Integer.parseInt(request.getParameter("x_pon"));
		}
		if (request.getParameter("x_tor") != null){
			x_tor = Integer.parseInt(request.getParameter("x_tor"));
		}
		if (request.getParameter("x_sre") != null){
			x_sre = Integer.parseInt(request.getParameter("x_sre"));
		}
		if (request.getParameter("x_cet") != null){
			x_cet = Integer.parseInt(request.getParameter("x_cet"));
		}
		if (request.getParameter("x_pet") != null){
			x_pet = Integer.parseInt(request.getParameter("x_pet"));
		}
		if (request.getParameter("x_sob") != null){
			x_sob = Integer.parseInt(request.getParameter("x_sob"));
		}
		if (request.getParameter("x_ned") != null){
			x_ned = Integer.parseInt(request.getParameter("x_ned"));
		}

		if (request.getParameter("x_x_koord") != null){
			x_x_koord = (String) request.getParameter("x_x_koord");
		}else{
			x_x_koord = "";
		}
		if (request.getParameter("x_y_koord") != null){
			x_y_koord = (String) request.getParameter("x_y_koord");
		}else{
			x_y_koord = "";
		}
		
		if (request.getParameter("x_radij") != null){
			x_radij = (String) request.getParameter("x_radij");
		}else{
			x_radij = "";
		}
		if (request.getParameter("x_vtez") != null){
			x_vtez = (String) request.getParameter("x_vtez");
		}else{
			x_vtez = "";
		}
		if (request.getParameter("x_obracun_km") != null){
			x_obracun_km = (String) request.getParameter("x_obracun_km");
		}else{
			x_obracun_km = "";
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
		
		// Open record
		String strsql = "SELECT * FROM `stranke` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field sif_str
		tmpfld = ((String) x_sif_str).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("sif_str");
		} else {
/*
		String srchfld = tmpfld;
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM `stranke` WHERE `id` = " + srchfld;
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				out.print("Duplicate key for sif_str, value = " + tmpfld + "<br>");
				out.print("Press [Previous Page] key to continue!");
				return;
			}
			rschk.close();
			rschk = null;
*/
			rs.updateInt("sif_str",Integer.parseInt(tmpfld));
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

		// Field telefon
		tmpfld = ((String) x_telefon);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("telefon");
		}else{
			rs.updateString("telefon", tmpfld);
		}

		// Field telefax
		tmpfld = ((String) x_telefax);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("telefax");
		}else{
			rs.updateString("telefax", tmpfld);
		}

		// Field kont_os
		tmpfld = ((String) x_kont_os);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("kont_os");
		}else{
			rs.updateString("kont_os", tmpfld);
		}

		// Field del_cas
		tmpfld = ((String) x_del_cas);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("del_cas");
		}else{
			rs.updateString("del_cas", tmpfld);
		}

		// Field sif_os
		tmpfld = ((String) x_sif_os);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_os");
		}else{
			rs.updateString("sif_os", tmpfld);
		}

		// Field kol_os
		tmpfld = ((String) x_kol_os).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_os");
		} else {
			rs.updateInt("kol_os",Integer.parseInt(tmpfld));
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

		// Field cena
		tmpfld = ((String) x_cena).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena");
		} else {
			rs.updateDouble("cena",Double.parseDouble(tmpfld));
		}

		// Field najem
		tmpfld = ((String) x_najem);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("najem");
		}else{
			rs.updateString("najem", tmpfld);
		}

		// Field cena_naj
		tmpfld = ((String) x_cena_naj).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena_naj");
		} else {
			rs.updateDouble("cena_naj",Double.parseDouble(tmpfld));
		}

		// Field veljavnost
		if (IsDate((String) x_veljavnost,"EURODATE", locale)) {
			rs.updateTimestamp("veljavnost", EW_UnFormatDateTime((String)x_veljavnost,"EURODATE", locale));
		}else{
			rs.updateNull("veljavnost");
		}

		// Field x
		tmpfld = ((String) x_x_koord);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("x_koord");
		}else{
			rs.updateString("x_koord", tmpfld);
		}

		// Field y
		tmpfld = ((String) x_y_koord);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("y_koord");
		}else{
			rs.updateString("y_koord", tmpfld);
		}

		// Field radij
		tmpfld = ((String) x_radij);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("radij");
		}else{
			rs.updateString("radij", tmpfld);
		}

		// Field vtez
		tmpfld = ((String) x_vtez);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("vtez");
		}else{
			rs.updateString("vtez", tmpfld);
		}
		
		// Field x_obracun_km
		tmpfld = ((String) x_obracun_km);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("obracun_km");
		}else{
			rs.updateString("obracun_km", tmpfld);
		}

		// Field x_stev_km_norm
		tmpfld = ((String) x_stev_km_norm);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("stev_km_norm");
		}else{
			rs.updateString("stev_km_norm", tmpfld);
		}
		
		
		// Field stev_ur_norm
		tmpfld = ((String) x_stev_ur_norm);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("stev_ur_norm");
		}else{
			rs.updateString("stev_ur_norm", tmpfld);
		}		

		rs.updateInt("pon",x_pon);
		rs.updateInt("tor",x_tor);
		rs.updateInt("sre",x_sre);
		rs.updateInt("cet",x_cet);
		rs.updateInt("pet",x_pet);
		rs.updateInt("sob",x_sob);
		rs.updateInt("ned",x_ned);

		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
try{
		rs.insertRow();
} catch(Exception e) {
System.out.println(e.getMessage());

}
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
//		//conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("strankelist.jsp");
		response.flushBuffer();
		return;
	}


	if(request.getParameter("prikaz_kupca")!= null){
		session.setAttribute("stranke_kupci_show",  request.getParameter("prikaz_kupca"));
	}
	
	if(request.getParameter("prikaz_osnovna")!= null){
		session.setAttribute("stranke_osnovna_show",  request.getParameter("prikaz_osnovna"));
	}

	
	String cbo_x_posta_js = "";
	x_postaList = new StringBuffer("<select name=\"x_posta\"><option value=\"\">Izberi</option>");
	String sqlwrk_x_posta = "SELECT DISTINCT `posta`, `kraj` FROM `poste`" + " ORDER BY `kraj` ASC";
	Statement stmtwrk_x_posta = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk_x_posta = stmtwrk_x_posta.executeQuery(sqlwrk_x_posta);
		int rowcntwrk_x_posta = 0;
		while (rswrk_x_posta.next()) {
			x_postaList.append("<option value=\"").append(rswrk_x_posta.getString("posta")).append("\"");
			if (rswrk_x_posta.getString("posta").equals(x_posta)) {
				x_postaList.append(" selected");
			}
			String tmpValue_x_posta = "";
			if (rswrk_x_posta.getString("kraj")!= null) tmpValue_x_posta = rswrk_x_posta.getString("kraj");
			x_postaList.append(">").append(tmpValue_x_posta).append("</option>");
			rowcntwrk_x_posta++;
		}
	rswrk_x_posta.close();
	rswrk_x_posta = null;
	stmtwrk_x_posta.close();
	stmtwrk_x_posta = null;
	x_postaList.append("</select>");


	String cbo_x_sif_os_js = "";
	x_sif_osList = new StringBuffer("<select name=\"x_sif_os\"><option value=\"\">Izberi</option>");
	String sqlwrk_x_sif_os = "SELECT DISTINCT `osnovna`.`sif_os`, `osnovna`  " +
			"FROM `osnovna`, (select sif_os, max(zacetek) as zacetek from osnovna group by sif_os) as m " +
			"WHERE osnovna.sif_os = m.sif_os and osnovna.zacetek = m.zacetek "+
			"ORDER BY `osnovna` ASC";

	Statement stmtwrk_x_sif_os = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk_x_sif_os = stmtwrk_x_sif_os.executeQuery(sqlwrk_x_sif_os);
		int rowcntwrk_x_sif_os = 0;
		while (rswrk_x_sif_os.next()) {
			x_sif_osList.append("<option value=\"").append(rswrk_x_sif_os.getString("sif_os")).append("\"");
			if (rswrk_x_sif_os.getString("sif_os").equals(x_sif_os)) {
				x_sif_osList.append(" selected");
			}
			String tmpValue_x_sif_os = "";
			String tmpNaziv = rswrk_x_sif_os.getString((String)session.getAttribute("stranke_osnovna_show"));
			if (tmpNaziv!= null) tmpValue_x_sif_os = tmpNaziv;
			x_sif_osList.append(">").append(tmpValue_x_sif_os).append("</option>");
			rowcntwrk_x_sif_os++;
		}
	rswrk_x_sif_os.close();
	rswrk_x_sif_os = null;
	stmtwrk_x_sif_os.close();
	stmtwrk_x_sif_os = null;
	x_sif_osList.append("</select>");


String stranke = (String) session.getAttribute("vse");
String strankeQueryFilter = "";
if(stranke.equals("0")){
	strankeQueryFilter = " potnik = " + session.getAttribute("papirservis1_status_UserID");
}

String enote = (String) session.getAttribute("enote");
String enoteQueryFilter = "";
if(enote.equals("0")){
	enoteQueryFilter = "sif_enote = " + session.getAttribute("papirservis1_status_Enota");
}

String subQuery ="";

if(strankeQueryFilter.length() > 0 || enoteQueryFilter.length() > 0){
	subQuery += " where " + strankeQueryFilter;
	if(strankeQueryFilter.length() > 0 && enoteQueryFilter.length() > 0){
		subQuery += " AND " + enoteQueryFilter;
	}else{
		subQuery += enoteQueryFilter;
	}
}

	String cbo_x_sif_kupca_js = "";
	x_sif_kupcaList = new StringBuffer("<select name=\"x_sif_kupca\"><option value=\"\">Izberi</option>");
	String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci` " + subQuery + " ORDER BY `naziv` ASC";
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

			String tmpNaziv = rswrk_x_sif_kupca.getString((String)session.getAttribute("stranke_kupci_show"));
			if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
			x_sif_kupcaList.append(">").append(tmpValue_x_sif_kupca).append("</option>");
			rowcntwrk_x_sif_kupca++;
		}
	rswrk_x_sif_kupca.close();
	rswrk_x_sif_kupca = null;
	stmtwrk_x_sif_kupca.close();
	stmtwrk_x_sif_kupca = null;
	x_sif_kupcaList.append("</select>");


}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: stranke<br><br><a href="strankelist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_sif_str && !EW_hasValue(EW_this.x_sif_str, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_str, "TEXT", "Napačna številka - sif str"))
                return false; 
        }
if (EW_this.x_sif_str && !EW_checkinteger(EW_this.x_sif_str.value)) {
        if (!EW_onError(EW_this, EW_this.x_sif_str, "TEXT", "Napačna številka - sif str"))
            return false; 
        }
if (EW_this.x_posta && !EW_hasValue(EW_this.x_posta, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_posta, "SELECT", "Napačan vnos - posta"))
                return false; 
        }
if (EW_this.x_sif_os && !EW_hasValue(EW_this.x_sif_os, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_os, "SELECT", "Napačan vnos - Šifra osebe"))
                return false; 
        }
if (EW_this.x_kol_os && !EW_checkinteger(EW_this.x_kol_os.value)) {
        if (!EW_onError(EW_this, EW_this.x_kol_os, "TEXT", "Napačna številka - kol os"))
            return false; 
        }
if (EW_this.x_cena && !EW_checknumber(EW_this.x_cena.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena, "TEXT", "Napačna številka - cena"))
            return false; 
        }
if (EW_this.x_cena_naj && !EW_checknumber(EW_this.x_cena_naj.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_naj, "TEXT", "Napačna številka - cena naj"))
            return false; 
        }
if (EW_this.x_veljavnost && !EW_checkeurodate(EW_this.x_veljavnost.value)) {
        if (!EW_onError(EW_this, EW_this.x_veljavnost, "TEXT", "Napačen datum (dd.mm.yyyy) - veljavnost"))
            return false; 
        }

if (!(EW_this.x_najem.value.charAt(0) == "D" || EW_this.x_najem.value.charAt(0)  == "d" || EW_this.x_najem.value.charAt(0) == "N" || EW_this.x_najem.value.charAt(0)  == "n" || EW_this.x_najem.value.charAt(0) == "X" || EW_this.x_najem.value.charAt(0)  == "x")) {
        	alert("Napačen najem:" + EW_this.x_najem.value.charAt(0) );
            return false; 
        }
        
	if (EW_this.x_x_koord && !EW_checknumber(EW_this.x_x_koord.value)) {
	        if (!EW_onError(EW_this, EW_this.x_x_koord, "TEXT", "Napačna številka - x koordinata"))
	            return false; 
	        }
	if (EW_this.x_y_koord && !EW_checknumber(EW_this.x_y_koord.value)) {
	        if (!EW_onError(EW_this, EW_this.x_y_koord, "TEXT", "Napačna številka - y koordinata"))
	            return false; 
	        }
	if (EW_this.x_radij && !EW_checkinteger(EW_this.x_radij.value)) {
	        if (!EW_onError(EW_this, EW_this.x_radij, "TEXT", "Napačna številka - radij"))
	            return false; 
	        }
	if (EW_this.x_vtez && !EW_checkinteger(EW_this.x_vtez.value)) {
	        if (!EW_onError(EW_this, EW_this.x_vtez, "TEXT", "Napačna številka - vtez"))
	            return false; 
	        }
	if (EW_this.x_obracun_km && !EW_checknumber(EW_this.x_obracun_km.value)) {
	    if (!EW_onError(EW_this, EW_this.x_obracun_km, "TEXT", "Napačna številka - obracun km"))
	        return false; 
	    }
	if (EW_this.x_stev_km_norm && !EW_checknumber(EW_this.x_stev_km_norm.value)) {
	    if (!EW_onError(EW_this, EW_this.x_stev_km_norm, "TEXT", "Napačna številka - stev km norm"))
	        return false; 
	    }
	if (EW_this.x_stev_ur_norm && !EW_checknumber(EW_this.x_stev_ur_norm.value)) {
	    if (!EW_onError(EW_this, EW_this.x_stev_ur_norm, "TEXT", "Napačna številka - stev ur norm"))
	        return false; 
	    }

return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="strankeadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_str" size="30" value="<%= HTMLEncode((String)x_sif_str) %>">&nbsp;</td>
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
		<td class="ewTableAltRow"><%out.println(x_postaList);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kraj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kraj" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kraj) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">telefon&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_telefon" size="30" maxlength="255" value="<%= HTMLEncode((String)x_telefon) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">telefax&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_telefax" size="30" maxlength="255" value="<%= HTMLEncode((String)x_telefax) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kontakt oseba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kont_os" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kont_os) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Delovni čas&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_del_cas" size="30" maxlength="255" value="<%= HTMLEncode((String)x_del_cas) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra OS&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_osList);%>&nbsp;<span class="jspmaker"><a href="<%out.print("strankeadd.jsp?prikaz_osnovna=sif_os");%>">šifra</a>&nbsp;<a href="<%out.print("strankeadd.jsp?prikaz_osnovna=osnovna");%>">osnovna</a>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol OS&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_os" size="30" value="<%= HTMLEncode((String)x_kol_os) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba" size="150" maxlength="255" value="<%= HTMLEncode((String)x_opomba) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%><span class="jspmaker"><a href="<%out.print("strankeadd.jsp?prikaz_kupca=sif_kupca");%>">šifra</a>&nbsp;<a href="<%out.print("strankeadd.jsp?prikaz_kupca=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("strankeadd.jsp?prikaz_kupca=naslov");%>">naslov</a></span>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena" size="30" value="<%= HTMLEncode((String)x_cena) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Najem&nbsp;</td>
		<td class="ewTableAltRow">
<%
	StringBuffer x_najemList = new StringBuffer("<select name=\"x_najem\"><option value=\"\">Izberi</option>");
	x_najemList.append("<option value=\"D\"");
	if ("D".equals((String)x_najem)) {
		x_najemList.append(" selected");
	}
	x_najemList.append(">D");
	x_najemList.append("</option>");
	x_najemList.append("<option value=\"N\"");
	if ("N".equals((String)x_najem)) {
		x_najemList.append(" selected");
	}
	x_najemList.append(">N");
	x_najemList.append("</option>");
	x_najemList.append("<option value=\"X\"");
	if ("X".equals((String)x_najem)) {
		x_najemList.append(" selected");
	}
	x_najemList.append(">X");
	x_najemList.append("</option>");
	x_najemList.append("</select>");

%><%= x_najemList %>&nbsp;
</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena naj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_naj" size="30" value="<%= HTMLEncode((String)x_cena_naj) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">pon&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_pon"  <%= x_pon == 0? "checked" : "" %> value = "0" >ni odvoza&nbsp;<input type="radio" name="x_pon"  <%= x_pon == 1? "checked" : "" %> value = "1">sodi&nbsp;<input type="radio" name="x_pon"  <%= x_pon == 2? "checked" : "" %> value = "2">lihi&nbsp;<input type="radio" name="x_pon"  <%= x_pon == 3? "checked" : "" %>  value = "3">vsak</td>
	</tr>
	<tr>
		<td class="ewTableHeader">tor&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_tor"  <%= x_tor == 0? "checked" : "" %> value = "0" >ni odvoza&nbsp;<input type="radio" name="x_tor"  <%= x_tor == 1? "checked" : "" %> value = "1">sodi&nbsp;<input type="radio" name="x_tor"  <%= x_tor == 2? "checked" : "" %> value = "2">lihi&nbsp;<input type="radio" name="x_tor"  <%= x_tor == 3? "checked" : "" %>  value = "3">vsak</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sre&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_sre"  <%= x_sre == 0? "checked" : "" %> value = "0" >ni odvoza&nbsp;<input type="radio" name="x_sre"  <%= x_sre == 1? "checked" : "" %> value = "1">sodi&nbsp;<input type="radio" name="x_sre"  <%= x_sre == 2? "checked" : "" %> value = "2">lihi&nbsp;<input type="radio" name="x_sre"  <%= x_sre == 3? "checked" : "" %>  value = "3">vsak</td>
	</tr>
	<tr>
		<td class="ewTableHeader">cet&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_cet"  <%= x_cet == 0? "checked" : "" %> value = "0" >ni odvoza&nbsp;<input type="radio" name="x_cet"  <%= x_cet == 1? "checked" : "" %> value = "1">sodi&nbsp;<input type="radio" name="x_cet"  <%= x_cet == 2? "checked" : "" %> value = "2">lihi&nbsp;<input type="radio" name="x_cet"  <%= x_cet == 3? "checked" : "" %>  value = "3">vsak</td>
	</tr>
	<tr>
		<td class="ewTableHeader">pet&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_pet"  <%= x_pet == 0? "checked" : "" %> value = "0" >ni odvoza&nbsp;<input type="radio" name="x_pet"  <%= x_pet == 1? "checked" : "" %> value = "1">sodi&nbsp;<input type="radio" name="x_pet"  <%= x_pet == 2? "checked" : "" %> value = "2">lihi&nbsp;<input type="radio" name="x_pet"  <%= x_pet == 3? "checked" : "" %>  value = "3">vsak</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sob&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_sob"  <%= x_sob == 0? "checked" : "" %> value = "0" >ni odvoza&nbsp;<input type="radio" name="x_sob"  <%= x_sob == 1? "checked" : "" %> value = "1">sodi&nbsp;<input type="radio" name="x_sob"  <%= x_sob == 2? "checked" : "" %> value = "2">lihi&nbsp;<input type="radio" name="x_sob"  <%= x_sob == 3? "checked" : "" %>  value = "3">vsak</td>
	</tr>
	<tr>
		<td class="ewTableHeader">ned&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_ned"  <%= x_ned == 0? "checked" : "" %> value = "0" >ni odvoza&nbsp;<input type="radio" name="x_ned"  <%= x_ned == 1? "checked" : "" %> value = "1">sodi&nbsp;<input type="radio" name="x_ned"  <%= x_ned == 2? "checked" : "" %> value = "2">lihi&nbsp;<input type="radio" name="x_ned"  <%= x_ned == 3? "checked" : "" %>  value = "3">vsak</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Veljavnost&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_veljavnost" value="<%= EW_FormatDateTime(x_veljavnost,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_veljavnost,'dd.mm.yyyy');return false;">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">X koordinata&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_x_koord" size="30" maxlength="255" value="<%= HTMLEncode((String)x_x_koord) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Y koordinata&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_y_koord" size="30" maxlength="255" value="<%= HTMLEncode((String)x_y_koord) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Radij&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_radij" size="30" maxlength="255" value="<%= HTMLEncode((String)x_radij) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Vtez&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_vtez" size="30" maxlength="255" value="<%= HTMLEncode((String)x_vtez) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Obračun km&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_obracun_km" size="30" value="<%= HTMLEncode((String)x_obracun_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število km normativ&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_km_norm" size="30" value="<%= HTMLEncode((String)x_stev_km_norm) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur normativ&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_ur_norm" size="30" value="<%= HTMLEncode((String)x_stev_ur_norm) %>">&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
