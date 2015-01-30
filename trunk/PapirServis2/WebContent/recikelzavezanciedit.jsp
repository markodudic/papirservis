<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="recikelzavezancilist.jsp"%>
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
if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("recikelzavezancilist.jsp"); 
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
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("recikelzavezancilist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
String x_st_pogodbe = "";
String x_naziv = "";
String x_naslov = "";
Object x_zacetek = null;
String x_uporabnik = "";
String x_posta = "";
String x_kraj = "";

String x_davcna = "";
String x_maticna = "";
String x_mail = "";
String x_dejavnost = "";
String x_naslov_posiljanje = "";
String x_kraj_posiljanje = "";
String x_posta_posiljanje = "";
String x_skrbnik = "";
String x_vrsta_zavezanca = "";
String x_interval_pavsala = "";
String x_datum_pricetka_pogodbe = "";
String x_datum_sklenitve_pogodbe = "";
String x_valuta = "";
String x_kontaktna_oseba = "";
String x_telefon_kontaktna = "";
String x_mail_kontaktna = "";
String x_opombe_kontaktna = "";
String x_odgovorna_oseba = "";
String x_telefon_odgovorna = "";
String x_mail_odgovorna = "";
String x_opombe_odgovorna = "";

StringBuffer x_naslovList = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM recikel_zavezanci" + session.getAttribute("leto") + " WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("recikelzavezancilist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("st_pogodbe") != null){
				x_st_pogodbe = rs.getString("st_pogodbe");
			}else{
				x_st_pogodbe = "";
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
			
			if (rs.getString("davcna") != null){
				x_davcna = rs.getString("davcna");
			}else{
				x_davcna = "";
			}
	
			if (rs.getString("maticna") != null){
				x_maticna = rs.getString("maticna");
			}else{
				x_maticna = "";
			}
	
			if (rs.getString("mail") != null){
				x_mail = rs.getString("mail");
			}else{
				x_mail = "";
			}
	
			if (rs.getString("dejavnost") != null){
				x_dejavnost = rs.getString("dejavnost");
			}else{
				x_dejavnost = "";
			}
			
			if (rs.getString("naslov_posiljanje") != null){
				x_naslov_posiljanje = rs.getString("naslov_posiljanje");
			}else{
				x_naslov_posiljanje = "";
			}
			
			if (rs.getString("kraj_posiljanje") != null){
				x_kraj_posiljanje = rs.getString("kraj_posiljanje");
			}else{
				x_kraj_posiljanje = "";
			}
			
			if (rs.getString("posta_posiljanje") != null){
				x_posta_posiljanje = rs.getString("posta_posiljanje");
			}else{
				x_posta_posiljanje = "";
			}
			
			if (rs.getString("skrbnik") != null){
				x_skrbnik = rs.getString("skrbnik");
			}else{
				x_skrbnik = "";
			}
			
			if (rs.getString("vrsta_zavezanca") != null){
				x_vrsta_zavezanca = rs.getString("vrsta_zavezanca");
			}else{
				x_vrsta_zavezanca = "";
			}	
			
			if (rs.getString("interval_pavsala") != null){
				x_interval_pavsala = rs.getString("interval_pavsala");
			}else{
				x_interval_pavsala = "";
			}	
			
			if (rs.getString("datum_pricetka_pogodbe") != null){
				x_datum_pricetka_pogodbe = rs.getString("datum_pricetka_pogodbe");
			}else{
				x_datum_pricetka_pogodbe = "";
			}	
			
			if (rs.getString("datum_sklenitve_pogodbe") != null){
				x_datum_sklenitve_pogodbe = rs.getString("datum_sklenitve_pogodbe");
			}else{
				x_datum_sklenitve_pogodbe = "";
			}	
			
			if (rs.getString("valuta") != null){
				x_valuta = rs.getString("valuta");
			}else{
				x_valuta = "";
			}	
			
			if (rs.getString("kontaktna_oseba") != null){
				x_kontaktna_oseba = rs.getString("kontaktna_oseba");
			}else{
				x_kontaktna_oseba = "";
			}	
			
			if (rs.getString("telefon_kontaktna") != null){
				x_telefon_kontaktna = rs.getString("telefon_kontaktna");
			}else{
				x_telefon_kontaktna = "";
			}	
			
			if (rs.getString("mail_kontaktna") != null){
				x_mail_kontaktna = rs.getString("mail_kontaktna");
			}else{
				x_mail_kontaktna = "";
			}	
			
			if (rs.getString("opombe_kontaktna") != null){
				x_opombe_kontaktna = rs.getString("opombe_kontaktna");
			}else{
				x_opombe_kontaktna = "";
			}	
			
			if (rs.getString("odgovorna_oseba") != null){
				x_odgovorna_oseba = rs.getString("odgovorna_oseba");
			}else{
				x_odgovorna_oseba = "";
			}	
			
			if (rs.getString("telefon_odgovorna") != null){
				x_telefon_odgovorna = rs.getString("telefon_odgovorna");
			}else{
				x_telefon_odgovorna = "";
			}	
			
			if (rs.getString("mail_odgovorna") != null){
				x_mail_odgovorna = rs.getString("mail_odgovorna");
			}else{
				x_mail_odgovorna = "";
			}	
			
			if (rs.getString("opombe_odgovorna") != null){
				x_opombe_odgovorna = rs.getString("opombe_odgovorna");
			}else{
				x_opombe_odgovorna = "";
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
		if (request.getParameter("x_st_pogodbe") != null){
			x_st_pogodbe = request.getParameter("x_st_pogodbe");
		}
		if (request.getParameter("x_naslov") != null){
			x_naslov = request.getParameter("x_naslov");
		}else{
			x_naslov = "";
		}
		if (request.getParameter("x_posta") != null){
			x_posta = (String) request.getParameter("x_posta");
		}else{
			x_posta = "";
		}
		if (request.getParameter("x_naziv") != null){
			x_naziv = (String) request.getParameter("x_naziv");
		}else{
			x_naziv = "";
		}
		if (request.getParameter("x_kraj") != null){
			x_kraj = (String) request.getParameter("x_kraj");
		}else{
			x_kraj = "";
		}
		
		if (request.getParameter("x_davcna") != null){
			x_davcna = request.getParameter("x_davcna");
		}else{
			x_davcna = "";
		}

		if (request.getParameter("x_maticna") != null){
			x_maticna = request.getParameter("x_maticna");
		}else{
			x_maticna = "";
		}

		if (request.getParameter("x_mail") != null){
			x_mail = request.getParameter("x_mail");
		}else{
			x_mail = "";
		}

		if (request.getParameter("x_dejavnost") != null){
			x_dejavnost = request.getParameter("x_dejavnost");
		}else{
			x_dejavnost = "";
		}
		
		if (request.getParameter("x_naslov_posiljanje") != null){
			x_naslov_posiljanje = request.getParameter("x_naslov_posiljanje");
		}else{
			x_naslov_posiljanje = "";
		}
		
		if (request.getParameter("x_kraj_posiljanje") != null){
			x_kraj_posiljanje = request.getParameter("x_kraj_posiljanje");
		}else{
			x_kraj_posiljanje = "";
		}
		
		if (request.getParameter("x_posta_posiljanje") != null){
			x_posta_posiljanje = request.getParameter("x_posta_posiljanje");
		}else{
			x_posta_posiljanje = "";
		}
		
		if (request.getParameter("x_skrbnik") != null){
			x_skrbnik = request.getParameter("x_skrbnik");
		}else{
			x_skrbnik = "";
		}
		
		if (request.getParameter("x_vrsta_zavezanca") != null){
			x_vrsta_zavezanca = request.getParameter("x_vrsta_zavezanca");
		}else{
			x_vrsta_zavezanca = "";
		}	
		
		if (request.getParameter("x_interval_pavsala") != null){
			x_interval_pavsala = request.getParameter("x_interval_pavsala");
		}else{
			x_interval_pavsala = "";
		}	
		
		if (request.getParameter("x_datum_pricetka_pogodbe") != null){
			x_datum_pricetka_pogodbe = request.getParameter("x_datum_pricetka_pogodbe");
		}else{
			x_datum_pricetka_pogodbe = "";
		}	
		
		if (request.getParameter("x_datum_sklenitve_pogodbe") != null){
			x_datum_sklenitve_pogodbe = request.getParameter("x_datum_sklenitve_pogodbe");
		}else{
			x_datum_sklenitve_pogodbe = "";
		}	
		
		if (request.getParameter("x_valuta") != null){
			x_valuta = request.getParameter("x_valuta");
		}else{
			x_valuta = "";
		}	
		
		if (request.getParameter("x_kontaktna_oseba") != null){
			x_kontaktna_oseba = request.getParameter("x_kontaktna_oseba");
		}else{
			x_kontaktna_oseba = "";
		}	
		
		if (request.getParameter("x_telefon_kontaktna") != null){
			x_telefon_kontaktna = request.getParameter("x_telefon_kontaktna");
		}else{
			x_telefon_kontaktna = "";
		}	
		
		if (request.getParameter("x_mail_kontaktna") != null){
			x_mail_kontaktna = request.getParameter("x_mail_kontaktna");
		}else{
			x_mail_kontaktna = "";
		}	
		
		if (request.getParameter("x_opombe_kontaktna") != null){
			x_opombe_kontaktna = request.getParameter("x_opombe_kontaktna");
		}else{
			x_opombe_kontaktna = "";
		}	
		
		if (request.getParameter("x_odgovorna_oseba") != null){
			x_odgovorna_oseba = request.getParameter("x_odgovorna_oseba");
		}else{
			x_odgovorna_oseba = "";
		}	
		
		if (request.getParameter("x_telefon_odgovorna") != null){
			x_telefon_odgovorna = request.getParameter("x_telefon_odgovorna");
		}else{
			x_telefon_odgovorna = "";
		}	
		
		if (request.getParameter("x_mail_odgovorna") != null){
			x_mail_odgovorna = request.getParameter("x_mail_odgovorna");
		}else{
			x_mail_odgovorna = "";
		}	
		
		if (request.getParameter("x_opombe_odgovorna") != null){
			x_opombe_odgovorna = request.getParameter("x_opombe_odgovorna");
		}else{
			x_opombe_odgovorna = "";
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
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM recikel_zavezanci" + session.getAttribute("leto") + " WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("recikelzavezancilist.jsp");
			response.flushBuffer();
			return;
		}

		tmpfld = ((String) x_st_pogodbe);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("st_pogodbe");
		}else{
			rs.updateString("st_pogodbe", tmpfld);
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

		// Field cena
		tmpfld = ((String) x_naziv).trim();
		if (tmpfld == null) {
			rs.updateNull("naziv");
		} else {
			rs.updateString("naziv",tmpfld);
		}

		tmpfld = ((String) x_posta).trim();
		if (tmpfld == null) {
			rs.updateNull("posta");
		} else {
			rs.updateString("posta",tmpfld);
		}

		tmpfld = ((String) x_davcna).trim();
		if (tmpfld == null) {
			rs.updateNull("davcna");
		} else {
			rs.updateString("davcna",tmpfld);
		}
		
		
		tmpfld = ((String) x_maticna).trim();
		if (tmpfld == null) {
			rs.updateNull("maticna");
		} else {
			rs.updateString("maticna",tmpfld);
		}
		
		tmpfld = ((String) x_mail).trim();
		if (tmpfld == null) {
			rs.updateNull("mail");
		} else {
			rs.updateString("mail",tmpfld);
		}
		
		tmpfld = ((String) x_dejavnost).trim();
		if (tmpfld == null) {
			rs.updateNull("dejavnost");
		} else {
			rs.updateString("dejavnost",tmpfld);
		}
		
		tmpfld = ((String) x_naslov_posiljanje).trim();
		if (tmpfld == null) {
			rs.updateNull("naslov_posiljanje");
		} else {
			rs.updateString("naslov_posiljanje",tmpfld);
		}
		
		tmpfld = ((String) x_kraj_posiljanje).trim();
		if (tmpfld == null) {
			rs.updateNull("kraj_posiljanje");
		} else {
			rs.updateString("kraj_posiljanje",tmpfld);
		}
		
		tmpfld = ((String) x_posta_posiljanje).trim();
		if (tmpfld == null) {
			rs.updateNull("posta_posiljanje");
		} else {
			rs.updateString("posta_posiljanje",tmpfld);
		}
		
		tmpfld = ((String) x_skrbnik).trim();
		if (tmpfld == null) {
			rs.updateNull("skrbnik");
		} else {
			rs.updateString("skrbnik",tmpfld);
		}
		
		tmpfld = ((String) x_vrsta_zavezanca).trim();
		if (tmpfld == null) {
			rs.updateNull("vrsta_zavezanca");
		} else {
			rs.updateString("vrsta_zavezanca",tmpfld);
		}

		tmpfld = ((String) x_interval_pavsala).trim();
		if (tmpfld == null) {
			rs.updateNull("interval_pavsala");
		} else {
			rs.updateString("interval_pavsala",tmpfld);
		}
		
		
		if (IsDate((String) x_datum_pricetka_pogodbe,"EURODATE", locale)) {
			rs.updateTimestamp("datum_pricetka_pogodbe", EW_UnFormatDateTime((String)x_datum_pricetka_pogodbe,"EURODATE", locale));
		}else{
			rs.updateNull("datum_pricetka_pogodbe");
		}
		
		
		if (IsDate((String) x_datum_sklenitve_pogodbe,"EURODATE", locale)) {
			rs.updateTimestamp("datum_sklenitve_pogodbe", EW_UnFormatDateTime((String)x_datum_sklenitve_pogodbe,"EURODATE", locale));
		}else{
			rs.updateNull("datum_sklenitve_pogodbe");
		}
		
		tmpfld = ((String) x_valuta).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("valuta");
		} else {
			rs.updateInt("valuta",Integer.parseInt(tmpfld));
		}
		
		tmpfld = ((String) x_kontaktna_oseba).trim();
		if (tmpfld == null) {
			rs.updateNull("kontaktna_oseba");
		} else {
			rs.updateString("kontaktna_oseba",tmpfld);
		}
		
		tmpfld = ((String) x_telefon_kontaktna).trim();
		if (tmpfld == null) {
			rs.updateNull("telefon_kontaktna");
		} else {
			rs.updateString("telefon_kontaktna",tmpfld);
		}
		
		tmpfld = ((String) x_mail_kontaktna).trim();
		if (tmpfld == null) {
			rs.updateNull("mail_kontaktna");
		} else {
			rs.updateString("mail_kontaktna",tmpfld);
		}
		
		tmpfld = ((String) x_opombe_kontaktna).trim();
		if (tmpfld == null) {
			rs.updateNull("opombe_kontaktna");
		} else {
			rs.updateString("opombe_kontaktna",tmpfld);
		}
		
		tmpfld = ((String) x_odgovorna_oseba).trim();
		if (tmpfld == null) {
			rs.updateNull("odgovorna_oseba");
		} else {
			rs.updateString("odgovorna_oseba",tmpfld);
		}
		
		
		tmpfld = ((String) x_telefon_odgovorna).trim();
		if (tmpfld == null) {
			rs.updateNull("telefon_odgovorna");
		} else {
			rs.updateString("telefon_odgovorna",tmpfld);
		}
		
		tmpfld = ((String) x_mail_odgovorna).trim();
		if (tmpfld == null) {
			rs.updateNull("mail_odgovorna");
		} else {
			rs.updateString("mail_odgovorna",tmpfld);
		}
		
		tmpfld = ((String) x_opombe_odgovorna).trim();
		if (tmpfld == null) {
			rs.updateNull("opombe_odgovorna");
		} else {
			rs.updateString("opombe_odgovorna",tmpfld);
		}

		//Uporabnik
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
		
		try{
			rs.updateRow();
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
		response.sendRedirect("recikelzavezancilist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}


if(request.getParameter("prikaz_naslov")!= null){
	session.setAttribute("recikelzavezanci_naslov",  request.getParameter("prikaz_naslov"));
}




%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Popravek v tabeli: recikel zavezanci<br><br><a href="recikelzavezancilist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">


// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="recikelzavezanciedit" action="recikelzavezanciedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Št. pogodbe&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_st_pogodbe" size="30" value="<%= HTMLEncode((String)x_st_pogodbe) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naziv" size="30" value="<%= HTMLEncode((String)x_naziv) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naslov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naslov" size="30" value="<%= HTMLEncode((String)x_naslov) %>">&nbsp;</td>
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
		<td class="ewTableAltRow"><input type="text" name="x_kraj" size="30" value="<%= HTMLEncode((String)x_kraj) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Davčna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_davcna" size="30" value="<%= HTMLEncode((String)x_davcna) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Matična&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_maticna" size="30" value="<%= HTMLEncode((String)x_maticna) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Mail&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_mail" size="30" value="<%= HTMLEncode((String)x_mail) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Dejavnost&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dejavnost" size="30" value="<%= HTMLEncode((String)x_dejavnost) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Naslov pošiljanje&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naslov_posiljanje" size="30" value="<%= HTMLEncode((String)x_naslov_posiljanje) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Kraj pošiljanje&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kraj_posiljanje" size="30" value="<%= HTMLEncode((String)x_kraj_posiljanje) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Pošta pošiljanje&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_posta_posiljanje" size="30" value="<%= HTMLEncode((String)x_posta_posiljanje) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Skrbnik&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_skrbnik" size="30" value="<%= HTMLEncode((String)x_skrbnik) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Vrsta zavezanca&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_vrsta_zavezanca">
			<%
				String sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'recikel_zavezanci" + session.getAttribute("leto") + "' AND COLUMN_NAME = 'vrsta_zavezanca'";
				Statement stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_vrsta_zavezanca)) {
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
		<td class="ewTableHeader">Interval pavšala&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_interval_pavsala">
			<%
				sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'recikel_zavezanci" + session.getAttribute("leto") + "' AND COLUMN_NAME = 'interval_pavsala'";
				stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_interval_pavsala)) {
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
		</td>	</tr>	
	<tr>
		<td class="ewTableHeader">Datum pričetka pogodbe&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_datum_pricetka_pogodbe" value="<%= EW_FormatDateTime(x_datum_pricetka_pogodbe,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_datum_pricetka_pogodbe,'dd.mm.yyyy');return false;">&nbsp;</td>	
	</tr>	
	<tr>
		<td class="ewTableHeader">Datum sklenitve pogodbe&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_datum_sklenitve_pogodbe" value="<%= EW_FormatDateTime(x_datum_sklenitve_pogodbe,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_datum_sklenitve_pogodbe,'dd.mm.yyyy');return false;">&nbsp;</td>	
	</tr>	
	<tr>
		<td class="ewTableHeader">Kontaktna oseba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kontaktna_oseba" size="30" value="<%= HTMLEncode((String)x_kontaktna_oseba) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Telefon kontaktna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_telefon_kontaktna" size="30" value="<%= HTMLEncode((String)x_telefon_kontaktna) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Mail kontaktna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_mail_kontaktna" size="30" value="<%= HTMLEncode((String)x_mail_kontaktna) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Opombe kontaktna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opombe_kontaktna" size="30" value="<%= HTMLEncode((String)x_opombe_kontaktna) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Odgovorna oseba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_odgovorna_oseba" size="30" value="<%= HTMLEncode((String)x_odgovorna_oseba) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Telefon odgovorna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_telefon_odgovorna" size="30" value="<%= HTMLEncode((String)x_telefon_odgovorna) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Mail odgovorna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_mail_odgovorna" size="30" value="<%= HTMLEncode((String)x_mail_odgovorna) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Opombe odgovorna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opombe_odgovorna" size="30" value="<%= HTMLEncode((String)x_opombe_odgovorna) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Valuta&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_valuta" size="30" value="<%= HTMLEncode((String)x_valuta) %>">&nbsp;</td>
	</tr>	

</table>
<p>
<input type="submit" name="Action" value="Shrani">
</form>
<%@ include file="footer.jsp" %>
