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

if ((ewCurSec & ewAllowView) != ewAllowView) {
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
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("kupcilist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_sif_kupca = "";
String x_naziv = "";
String x_naslov = "";
String x_posta = "";
String x_kraj = "";
String x_kont_oseba = "";
String x_tel_st1 = "";
String x_tel_st2 = "";
String x_fax = "";
String x_potnik = "";
String x_razred = "";
String x_bala = "";
int x_blokada = 0;
String x_sif_rac = "";
String x_opomba = "";
String x_skupina = "";
String x_sif_enote = "";
String x_pogodba  = "";
String x_maticna = "";
String x_opomba1 = "";
String x_opomba2 = "";
String x_opomba3 = "";
String x_opomba4 = "";
String x_opomba5 = "";
String x_analiza = "";
String x_datum = "";



// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kupci` WHERE `sif_kupca`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("kupcilist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// sif_kupca

		if (rs.getString("sif_kupca") != null){
			x_sif_kupca = rs.getString("sif_kupca");
		}else{
			x_sif_kupca = "";
		}

		// naziv
		if (rs.getString("naziv") != null){
			x_naziv = rs.getString("naziv");
		}else{
			x_naziv = "";
		}

		// naslov
		if (rs.getString("naslov") != null){
			x_naslov = rs.getString("naslov");
		}else{
			x_naslov = "";
		}

		// posta
		if (rs.getString("posta") != null){
			x_posta = rs.getString("posta");
		}else{
			x_posta = "";
		}

		// kraj
		if (rs.getString("kraj") != null){
			x_kraj = rs.getString("kraj");
		}else{
			x_kraj = "";
		}

		// kont_oseba
		if (rs.getString("kont_oseba") != null){
			x_kont_oseba = rs.getString("kont_oseba");
		}else{
			x_kont_oseba = "";
		}

		// tel_st1
		if (rs.getString("tel_st1") != null){
			x_tel_st1 = rs.getString("tel_st1");
		}else{
			x_tel_st1 = "";
		}

		// tel_st2
		if (rs.getString("tel_st2") != null){
			x_tel_st2 = rs.getString("tel_st2");
		}else{
			x_tel_st2 = "";
		}

		// fax
		if (rs.getString("fax") != null){
			x_fax = rs.getString("fax");
		}else{
			x_fax = "";
		}

		// potnik
		x_potnik = String.valueOf(rs.getLong("potnik"));

		// razred
		if (rs.getString("razred") != null){
			x_razred = rs.getString("razred");
		}else{
			x_razred = "";
		}

		// bala
		x_bala = String.valueOf(rs.getLong("bala"));

		// blokada
		x_blokada = rs.getInt("blokada");

		// sif_rac
		if (rs.getString("sif_rac") != null){
			x_sif_rac = rs.getString("sif_rac");
		}else{
			x_sif_rac = "";
		}

		// opomba
		if (rs.getString("opomba") != null){
			x_opomba = rs.getString("opomba");
		}else{
			x_opomba = "";
		}


	// pogodba
	if (rs.getString("pogodba") != null){
		x_pogodba = rs.getString("pogodba");
	}else{
		x_pogodba = "";
	}

	// maticna
	if (rs.getString("maticna") != null){
		x_maticna = rs.getString("maticna");
	}else{
		x_maticna = "";
	}

	// opomba1
	if (rs.getString("opomba1") != null){
		x_opomba1 = rs.getString("opomba1");
	}else{
		x_opomba1 = "";
	}

	// opomba2
	if (rs.getString("opomba2") != null){
		x_opomba2 = rs.getString("opomba2");
	}else{
		x_opomba2 = "";
	}

	// opomba3
	if (rs.getString("opomba3") != null){
		x_opomba3 = rs.getString("opomba3");
	}else{
		x_opomba3 = "";
	}

	// opomba4
	if (rs.getString("opomba4") != null){
		x_opomba4 = rs.getString("opomba4");
	}else{
		x_opomba4 = "";
	}

	// opomba5
	if (rs.getString("opomba5") != null){
		x_opomba5 = rs.getString("opomba5");
	}else{
		x_opomba5 = "";
	}

	// analiza
	if (rs.getString("analiza") != null){
		x_analiza = rs.getString("analiza");
	}else{
		x_analiza = "";
	}


	// datum
	if (rs.getString("datum") != null){
		x_datum = rs.getString("datum");
	}else{
		x_datum = "";
	}



		// skupina
		x_skupina = String.valueOf(rs.getLong("skupina"));

		// sif_enote
		x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
	}
%>
<%@ include file="header.jsp" %>

<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: kupci<br><br><a href="kupcilist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_sif_kupca); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_naziv); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naslov&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_naslov); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pošta&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_posta!=null && ((String)x_posta).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_posta;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`posta` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `posta`, `kraj` FROM `poste`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("kraj"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kraj&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kraj); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kontakt oseba&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kont_oseba); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">tel št 1.&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_tel_st1); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">tel št 2&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_tel_st2); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">fax&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_fax); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Potnik&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_potnik!=null && ((String)x_potnik).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_upor` = " + x_potnik;
	String sqlwrk = "SELECT `sif_upor`, `ime_in_priimek` FROM `uporabniki`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("ime_in_priimek"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Razred&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_razred); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Bala&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_bala); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Blokada&nbsp;</td>
		<td class="ewTableAltRow"><% out.print((x_blokada == 1 ? "DA" : "NE")); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra rač.&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_sif_rac); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_opomba); %>&nbsp;</td>
	</tr>

	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_skupina!=null && ((String)x_skupina).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`skupina` = " + x_skupina;
	String sqlwrk = "SELECT `skupina`, `tekst` FROM `skup`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("tekst"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra enote&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_sif_enote!=null && ((String)x_sif_enote).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_enote` = " + x_sif_enote;
	String sqlwrk = "SELECT `sif_enote`, `naziv` FROM `enote`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("naziv"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pogodba&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_pogodba); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Davčna&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_opomba); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 1&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_opomba1); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 2&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_opomba2); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 3&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_opomba3); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 4&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_opomba4); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba 5&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_opomba5); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Analiza&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_analiza, 1, 1,1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatDateTime(x_datum,7,locale)); %>&nbsp;</td>
	</tr>
</table>
</form>
<p>
<%
	rs.close();
	rs = null;
	stmt.close();
	stmt = null;
	//conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="footer.jsp" %>
