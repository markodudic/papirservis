<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"  %>
<%@ page contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<% Locale locale = Locale.getDefault();
/*response.setLocale(locale);  errorPage="dobavnicalist.jsp"*/%>
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
	response.sendRedirect("dobavnicalist.jsp"); 
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
Object x_cena_km = null;
Object x_cena_ura = null;
Object x_c_km = null;
Object x_c_ura = null;
Object x_stev_km = null;
Object x_stev_ur = null;
Object x_stroski = null;
Object x_koda = null;
Object x_kolicina = null;
Object x_cena = null;
Object x_kg_zaup = null;
Object x_sit_zaup = null;
Object x_kg_sort = null;
Object x_sit_sort = null;
Object x_sit_smet = null;
Object x_skupina = null;
Object x_skupina_text = null;
Object x_opomba = null;
Object x_stev_km_sled = null;
Object x_stev_ur_sled = null;
Object x_zacetek = null;
Object x_uporabnik = null;
Object x_kamion = null;
Object x_stev_km_norm = null;
Object x_stev_ur_norm = null;

StringBuffer x_sif_strList = null;
StringBuffer x_sif_kupcaList = null;
StringBuffer x_sif_kamList = null;
StringBuffer x_kodaList = null;
StringBuffer x_sif_sofList = null;
StringBuffer x_skupinaList = null;

StringBuffer sif_kupac = new StringBuffer();
StringBuffer sif_skupina = new StringBuffer();
StringBuffer kupac = new StringBuffer();
StringBuffer skupina = new StringBuffer();
StringBuffer stranka_cena = new StringBuffer();
StringBuffer stranka_stev_km_norm = new StringBuffer();
StringBuffer stranka_stev_ur_norm = new StringBuffer();

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;




	if (a.equals("C") || a.equals("I")) {
		//Update st_dob@dob_bianco
		
		try{
			Statement stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
				String strsql2 = "update dob_bianco set st_dob = st_dob + 1 where id = '" + session.getAttribute("letoTabela") + "'";
				stmt2.executeUpdate(strsql2);
			// Get the field contents
		
			stmt2.close();
			stmt2 = null;
			//conn.close();
			//conn = null;
		
		
		} catch(Exception e){
			//System.out.println(e.toString());
		}

	}
	
	if (!a.equals("A")) {
		try{
			

		

		Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				String strsql = "SELECT max(st_dob) cnt FROM `dob_bianco` where id = '" + session.getAttribute("letoTabela") + "'";
				rs = stmt1.executeQuery(strsql);
				if (!rs.next()){
					rs.close();
					rs = null;
					stmt1.close();
					stmt1 = null;
					//conn.close();
					conn = null;
					out.clear();
					response.sendRedirect("doblist.jsp");
					response.flushBuffer();
					return;
				}
				rs.first();
		
			// Get the field contents
			x_st_dob = String.valueOf(rs.getLong("cnt"));
			if(a.equals("D")){
				x_st_dob = request.getParameter("st_dob");;
			}
			x_pozicija = "1";//avtomati�no se pove�a ua 1 ob kopiranju
			rs.close();
			rs = null;
			stmt1.close();
			stmt1 = null;
			//conn.close();
			//conn = null;
		
		
		} catch(Exception e){
			//System.out.println(e.toString());
		}
		
	}


	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT *, (select max(st_dob) FROM `dob_bianco` where id = '" + session.getAttribute("letoTabela") + "') ct " +
						"FROM " + session.getAttribute("letoTabela") + " dob WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			////conn.close();
			//conn = null;
			out.clear();
			response.sendRedirect("dobavnicalist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
		x_st_dob = String.valueOf(rs.getLong("ct"));
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
		if (rs.getString("kamion") != null){
			x_kamion = rs.getString("kamion");
		}else{
			x_kamion = "";
		}
		x_cena_km = String.valueOf(rs.getLong("cena_km"));
		x_cena_ura = String.valueOf(rs.getLong("cena_ura"));
		x_c_km = String.valueOf(rs.getLong("c_km"));
		x_c_ura = String.valueOf(rs.getLong("c_ura"));
		x_stev_km = String.valueOf(rs.getLong("stev_km"));
		x_stev_ur = String.valueOf(rs.getLong("stev_ur"));
		x_stroski = String.valueOf(rs.getLong("stroski"));
		if (rs.getString("koda") != null){
			x_koda = rs.getString("koda");
		}else{
			x_koda = "";
		}
		x_kolicina = String.valueOf(rs.getLong("kolicina"));
		x_cena = String.valueOf(rs.getDouble("cena"));
		x_kg_zaup = String.valueOf(rs.getLong("kg_zaup"));
		x_sit_zaup = String.valueOf(rs.getLong("sit_zaup"));
		x_kg_sort = String.valueOf(rs.getLong("kg_sort"));
		x_sit_sort = String.valueOf(rs.getLong("sit_sort"));
		x_sit_smet = String.valueOf(rs.getLong("sit_smet"));
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
		x_stev_km_sled = String.valueOf(rs.getLong("stev_km_sled"));
		x_stev_ur_sled = String.valueOf(rs.getLong("stev_ur_sled"));
		if (rs.getTimestamp("zacetek") != null){
			x_zacetek = rs.getTimestamp("zacetek");
		}else{
			x_zacetek = null;
		}
		x_uporabnik = String.valueOf(rs.getLong("uporabnik"));

		x_stev_km_norm = String.valueOf(rs.getDouble("stev_km_norm"));
		x_stev_ur_norm = String.valueOf(rs.getDouble("stev_ur_norm"));

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
			x_sif_sof = (String) request.getParameter("x_sif_sof");
		}else{
			x_sif_sof = "";
		}
		if (request.getParameter("x_sofer") != null){
			x_sofer = (String) request.getParameter("x_sofer");
		}else{
			x_sofer = "";
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
		if (request.getParameter("x_opomba") != null){
			x_opomba = (String) request.getParameter("x_opomba");
		}else{
			x_opomba = "";
		}
		if (request.getParameter("x_stev_km_sled") != null){
			x_stev_km_sled = (String) request.getParameter("x_stev_km_sled");
		}else{
			x_stev_km_sled = "";
		}
		if (request.getParameter("x_stev_ur_sled") != null){
			x_stev_ur_sled = (String) request.getParameter("x_stev_ur_sled");
		}else{
			x_stev_ur_sled = "";
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

		// Open record


		String strsql = "insert into " + session.getAttribute("letoTabela") + " (st_dob, pozicija, sif_sof, sif_str, sif_kupca, skupina, cena, opomba, uporabnik, datum, stev_km_norm, stev_ur_norm) values (";
//		String strsql = "insert into dob (st_dob, pozicija, sif_sof, sif_str, sif_kupca, skupina, cena, opomba, uporabnik, datum) values (" + x_st_dob + ", 1, ";
		
		// Field st_dob
		tmpfld = ((String) x_st_dob).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			//rs.updateNull("sif_str");
		} else {
			strsql += tmpfld + ", 1, ";
		}


		// Field sif_sof
		tmpfld = ((String) x_sif_sof);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			//rs.updateNull("sif_sof");
		}else{
			strsql += tmpfld + ",";
		}

		// Field sif_str
		tmpfld = ((String) x_sif_str).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			//rs.updateNull("sif_str");
		} else {
			strsql += tmpfld + ",";
		}

		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			//rs.updateNull("sif_str");
		} else {
			strsql += tmpfld + ",";
		}

		// Field skupina
		tmpfld = ((String) x_skupina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			//rs.updateNull("sif_str");
		} else {
			strsql += tmpfld + ",";
		}


		// Field skupina
		tmpfld = ((String) x_cena).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			//rs.updateNull("sif_str");
		} else {
			strsql += tmpfld + ",";
		}

		// Field opomba
		tmpfld = ((String) x_opomba);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		strsql += "'" + tmpfld + "'," + (String) session.getAttribute("papirservis1_status_UserID") + ", '" + (EW_UnFormatDateTime((String) x_datum ,"EURODATE", locale)).toString() + "',";


		// Field stev_km_norm
		tmpfld = ((String) x_stev_km_norm).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ", ";

		// Field stev_ur_norm
		tmpfld = ((String) x_stev_ur_norm).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + ") ";

		Statement stmt1 = conn.createStatement();
		stmt1.executeUpdate(strsql);
		stmt1.close();
		stmt1 = null;


		
		out.clear();
		response.sendRedirect("dobavnicalist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}

if(request.getParameter("prikaz_stranke")!= null){
	session.setAttribute("dobavnica_stranke_show",  request.getParameter("prikaz_stranke"));
}

if(request.getParameter("prikaz_kupca")!= null){
	session.setAttribute("dobavnica_kupci_show",  request.getParameter("prikaz_kupca"));
}

if(request.getParameter("prikaz_kamion")!= null){
 	session.setAttribute("dobavnica_kamion_show", request.getParameter("prikaz_kamion"));
}

if(request.getParameter("prikaz_sofer")!= null){
 	session.setAttribute("dobavnica_sofer_show", request.getParameter("prikaz_sofer"));
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
/*		
		if (!((String)session.getAttribute("dob_kupci_show")).equals("vse"))
			tmpNaziv = rswrk_x_sif_kupca.getString((String)session.getAttribute("dobavnica_kupci_show"));
		else
*/
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
String fiftyBlanks ="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
x_sif_strList = new StringBuffer("<select onchange = \"updateDropDowns(this);\" name=\"x_sif_str\" STYLE=\"font-family : monospace;  font-size : 12pt\"><option value=\"\">Izberi</option>");
//String sqlwrk_x_sif_str = "SELECT `sif_str`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina FROM `stranke` s, `osnovna` o, `kupci` k, `skup` sk where s.sif_os = o.sif_os and k.sif_kupca = s.sif_kupca and k.skupina = sk.skupina  and k.blokada = 0 " + subQuery   + " ORDER BY `" + session.getAttribute("dobavnica_stranke_show") + "` ASC";
String sqlwrk_x_sif_str = "SELECT `sif_str`, `cena`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina, s.stev_km_norm, s.stev_ur_norm  "+
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
	" ORDER BY `" + session.getAttribute("dobavnica_stranke_show") + "` ASC";

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


		String tmpValue_x_sif_str = "";
		String find = (String)session.getAttribute("dobavnica_stranke_show");
		//String tmpNaziv = tmpNaziv = rswrk_x_sif_str.getString("naziv") + ", " + rswrk_x_sif_str.getString("sif_str") + ", " + rswrk_x_sif_str.getString("naslov") + ", " + rswrk_x_sif_str.getString("osnovna")  + ", " + rswrk_x_sif_str.getString("kol_os");
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

String cbo_x_sif_sof_js = "";
x_sif_sofList = new StringBuffer("<select name=\"x_sif_sof\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_sof = "SELECT `sif_sof`, `sofer` FROM `sofer` order by " + session.getAttribute("dobavnica_sofer_show") + " asc";
Statement stmtwrk_x_sif_sof = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_sof = stmtwrk_x_sif_sof.executeQuery(sqlwrk_x_sif_sof);
	int rowcntwrk_x_sif_sof = 0;
	while (rswrk_x_sif_sof.next()) {
		x_sif_sofList.append("<option value=\"").append(rswrk_x_sif_sof.getString("sif_sof")).append("\"");
		if (rswrk_x_sif_sof.getString("sif_sof").equals(x_sif_sof)) {
			x_sif_sofList.append(" selected");
		}
		String tmpValue_x_sif_sof = "";
		String tmpSofer = rswrk_x_sif_sof.getString((String)session.getAttribute("dobavnica_sofer_show"));
		
		if (tmpSofer!= null) tmpValue_x_sif_sof = tmpSofer;
		x_sif_sofList.append(">").append(tmpValue_x_sif_sof).append("</option>");
		rowcntwrk_x_sif_sof++;
	}
rswrk_x_sif_sof.close();
rswrk_x_sif_sof = null;
stmtwrk_x_sif_sof.close();
stmtwrk_x_sif_sof = null;
x_sif_sofList.append("</select>");

%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: Delovni nalogi<br><br><a href="dobavnicalist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">

var sif_kupac = new Array();
<%=sif_kupac%>
var sif_skupina = new Array();
<%=sif_skupina%>
var kupac = new Array();
<%=kupac%>
var skupina = new Array();
<%=skupina%>
var stranka_cena = new Array();
<%=stranka_cena%>
var stranka_stev_ur_norm = new Array();
<%=stranka_stev_ur_norm%>
var stranka_stev_km_norm = new Array();
<%=stranka_stev_km_norm%>

function updateDropDowns(EW_this){
/*
	alert(document.dobedit.x_sif_str.value);
	alert(sif_skupina[document.dobedit.x_sif_str.value]);
	alert(skupina[sif_skupina[document.dobedit.x_sif_str.value]]);
*/
	document.dobavnicaadd.x_sif_kupca_ll.selectedIndex = 1 + kupac[sif_kupac[document.dobavnicaadd.x_sif_str.value]];
	document.dobavnicaadd.x_sif_kupca.value = sif_kupac[document.dobavnicaadd.x_sif_str.value];
	document.dobavnicaadd.x_skupina_ll.selectedIndex = 1 + skupina[sif_skupina[document.dobavnicaadd.x_sif_str.value]];
	document.dobavnicaadd.x_skupina.value = sif_skupina[document.dobavnicaadd.x_sif_str.value];

	document.dobavnicaadd.x_cena.value = stranka_cena[document.dobavnicaadd.x_sif_str.value];

	document.dobavnicaadd.x_stev_km_norm.value = stranka_stev_km_norm[document.dobavnicaadd.x_sif_str.value];
	document.dobavnicaadd.x_stev_ur_norm.value = stranka_stev_ur_norm[document.dobavnicaadd.x_sif_str.value];

}

function disableSome(){
	document.dobavnicaadd.x_sif_kupca_ll.disabled=true;
	document.dobavnicaadd.x_skupina_ll.disabled=true;
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
if(EW_this.x_datum.value.length == 0 ){
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum"))
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
            if (!EW_onError(EW_this, EW_this.x_sif_kupca, "SELECT", "Napačan vnos - sif kupca"))
                return false; 
        }
if (EW_this.x_sif_kupca && !EW_hasValue(EW_this.x_sif_sof, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_sof, "SELECT", "Napačan vnos - sif sof"))
                return false; 
        }
if (EW_this.x_cena_km && !EW_checkinteger(EW_this.x_cena_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_km, "TEXT", "Napačna številka - cena km"))
            return false; 
        }
if (EW_this.x_cena_ura && !EW_checkinteger(EW_this.x_cena_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_ura, "TEXT", "Napačna številka - cena ura"))
            return false; 
        }
if (EW_this.x_c_km && !EW_checkinteger(EW_this.x_c_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_km, "TEXT", "Napačna številka - c km"))
            return false; 
        }
if (EW_this.x_c_ura && !EW_checkinteger(EW_this.x_c_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_ura, "TEXT", "Napačna številka - c ura"))
            return false; 
        }
if (EW_this.x_stev_km && !EW_checkinteger(EW_this.x_stev_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_km, "TEXT", "Napačna številka - stev km"))
            return false; 
        }
if (EW_this.x_stev_ur && !EW_checkinteger(EW_this.x_stev_ur.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_ur, "TEXT", "Napačna številka - stev ur"))
            return false; 
        }
if (EW_this.x_stroski && !EW_checkinteger(EW_this.x_stroski.value)) {
        if (!EW_onError(EW_this, EW_this.x_stroski, "TEXT", "Napačna številka - stroski"))
            return false; 
        }
if (EW_this.x_koda && !EW_hasValue(EW_this.x_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_koda, "SELECT", "Napačan vnos - koda"))
                return false; 
        }
if (EW_this.x_kolicina && !EW_checkinteger(EW_this.x_kolicina.value)) {
        if (!EW_onError(EW_this, EW_this.x_kolicina, "TEXT", "Napačna številka - kolicina"))
            return false; 
        }
/*
if (EW_this.x_cena && !EW_checkinteger(EW_this.x_cena.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena, "TEXT", "Napačna številka - cena"))
            return false; 
        }
*/
if (EW_this.x_kg_zaup && !EW_checkinteger(EW_this.x_kg_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_kg_zaup, "TEXT", "Napačna številka - kg zaup"))
            return false;
        }
if (EW_this.x_sit_zaup && !EW_checkinteger(EW_this.x_sit_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_zaup, "TEXT", "Napačna številka - sit zaup"))
            return false; 
        }
if (EW_this.x_kg_sort && !EW_checkinteger(EW_this.x_kg_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_kg_sort, "TEXT", "Napačna številka - kg sort"))
            return false; 
        }
if (EW_this.x_sit_sort && !EW_checkinteger(EW_this.x_sit_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_sort, "TEXT", "Napačna številka - sit sort"))
            return false; 
        }
if (EW_this.x_sit_smet && !EW_checkinteger(EW_this.x_sit_smet.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_smet, "TEXT", "Napačna številka - sit smet"))
            return false; 
        }
if (EW_this.x_skupina && !EW_hasValue(EW_this.x_skupina, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_skupina, "SELECT", "Napačna številka - skupina"))
                return false; 
        }
if (EW_this.x_stev_km_sled && !EW_checkinteger(EW_this.x_stev_km_sled.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_km_sled, "TEXT", "Napačna številka - stev km sled"))
            return false; 
        }
if (EW_this.x_stev_ur_sled && !EW_checkinteger(EW_this.x_stev_ur_sled.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_ur_sled, "TEXT", "Napačna številka - stev ur sled"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="dobavnicaadd" action="dobavnicaadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<input type="hidden" name="x_sif_kupca" size="30" value="<%= HTMLEncode((String)x_sif_kupca) %>">
<input type="hidden" name="x_skupina" size="30" value="<%= HTMLEncode((String)x_pozicija) %>">
<input type="hidden" name="x_stev_km_norm" size="30" value="<%= HTMLEncode((String)x_stev_km_norm) %>">
<input type="hidden" name="x_stev_ur_norm" size="30" value="<%= HTMLEncode((String)x_stev_ur_norm) %>">

<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Številka dobavnice&nbsp;</td>
		<td class="ewTableAltRow"><% if (x_st_dob== null || ((String)x_st_dob).equals("")) {x_st_dob = "0"; } // set default value %><input type="text" name="x_st_dob" size="30" value="<%= HTMLEncode((String)x_st_dob) %>" >&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Pozicija&nbsp;</td>
		<td class="ewTableAltRow"><% if (x_pozicija== null || ((String)x_pozicija).equals("")) {x_pozicija = "0"; } // set default value %><input type="text" name="x_pozicija" size="30" value="<%= HTMLEncode((String)x_pozicija) %>">&nbsp;</td>
	</tr-->
	<tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_datum" value="<%= EW_FormatDateTime(x_datum,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_datum,'dd.mm.yyyy');return false;">&nbsp;</td>
		</tr>
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_strList);%><span class="jspmaker"><a href="<%out.print("dobavnicaadd.jsp?prikaz_stranke=sif_str&a=D&st_dob=" + x_st_dob);%>">šifra</a>&nbsp;<a href="<%out.print("dobavnicaadd.jsp?prikaz_stranke=naziv&a=D&st_dob=" + x_st_dob);%>">naziv</a>&nbsp;<a href="<%out.print("dobavnicaadd.jsp?prikaz_stranke=naslov&a=D&st_dob=" + x_st_dob);%>">naslov</a></span>&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Stranka&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stranka" size="30" maxlength="255" value="<%= HTMLEncode((String)x_stranka) %>">&nbsp;</td>
	</tr-->
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%><!--span class="jspmaker"><a href="<%out.print("dobavnicaadd.jsp?prikaz_kupca=sif_kupca&a=D&st_dob=" + x_st_dob);%>">šifra</a>&nbsp;<a href="<%out.print("dobavnicaadd.jsp?prikaz_kupca=naziv&a=D&st_dob=" + x_st_dob);%>">naziv</a>&nbsp;<a href="<%out.print("dobavnicaadd.jsp?prikaz_kupca=naslov&a=D&st_dob=" + x_st_dob);%>">naslov</a></span-->&nbsp;</td>
	</tr>
	<!--tr> 
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_sof" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sif_sof) %>">&nbsp;</td>
	</tr-->
	<tr>
		<td class="ewTableHeader">Šofer&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_sofList);%><a href="<%out.print("dobavnicaadd.jsp?prikaz_sofer=sif_sof&a=D&st_dob=" + x_st_dob);%>">šifra</a>&nbsp;<a href="<%out.print("dobavnicaadd.jsp?prikaz_sofer=sofer&a=D&st_dob=" + x_st_dob);%>">šofer</a>&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Šifra kamiona&nbsp;</td>
		<td class="ewTableAltRow">&nbsp;</td>
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
		<td class="ewTableAltRow"></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Količina&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kolicina" size="30" value="<%= HTMLEncode((String)x_kolicina) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena&nbsp;</td>
		<td class="ewTableAltRow"--!>
	<input type="hidden" name="x_cena" size="30" value="<%= HTMLEncode((String)x_cena) %>">
	<!--&nbsp;/td>
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
	<tr></td>
	</tr-->
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_skupinaList);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba" size="30" maxlength="255" value="<%= HTMLEncode((String)x_opomba) %>">&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Število kilometrov sled&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_km_sled" size="30" value="<%= HTMLEncode((String)x_stev_km_sled) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur sledenja&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_ur_sled" size="30" value="<%= HTMLEncode((String)x_stev_ur_sled) %>">&nbsp;</td>
	</tr-->
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
