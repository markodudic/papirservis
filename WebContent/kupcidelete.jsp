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


if ((ewCurSec & ewAllowDelete) != ewAllowDelete) {
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

// Multiple delete records
String key = "";
String [] arRecKey = request.getParameterValues("key");
String sqlKey = "";
if (arRecKey == null || arRecKey.length == 0 ) {
	response.sendRedirect("kupcilist.jsp");
	response.flushBuffer();
	return;
}
for (int i = 0; i < arRecKey.length; i++){
	String reckey = arRecKey[i].trim();
	reckey = reckey.replaceAll("'",escapeString);

	// Build the SQL
	sqlKey +=  "(";
	sqlKey +=  "`sif_kupca`=" + "'" + reckey + "'" + " AND ";
	if (sqlKey.substring(sqlKey.length()-5,sqlKey.length()).equals(" AND " )) { sqlKey = sqlKey.substring(0,sqlKey.length()-5);}
	sqlKey = sqlKey + ") OR ";
}
if (sqlKey.substring(sqlKey.length()-4,sqlKey.length()).equals(" OR ")) { sqlKey = sqlKey.substring(0,sqlKey.length()-4); }

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Display
		String strsql = "SELECT * FROM `kupci` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("kupcilist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		try{
		String strsql = "DELETE FROM `kupci` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("kupcilist.jsp");
		response.flushBuffer();
		return;
		}catch (SQLException ex){
			out.println("<table><tr><td><h2>Ni mogoče pobrisati izbrani zapis!!!</h2></td></tr></table>");
			String strsql1 = "SELECT * FROM `kupci` WHERE " + sqlKey;
			rs = stmt.executeQuery(strsql1);
			if (!rs.next()) {
				response.sendRedirect("kupcilist.jsp");
			}else{
				rs.beforeFirst();
			}
		}
	}
%>
<%@ include file="header.jsp" %>

<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Izbriši iz: kupci<br><br><a href="kupcilist.jsp">Nazaj na pregled</a></span></p>
<form action="kupcidelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Šifra kupca&nbsp;</td>
		<td>Naziv&nbsp;</td>
		<td>Naslov&nbsp;</td>
		<td>Pošta&nbsp;</td>
		<td>Kraj&nbsp;</td>
		<td>Kontakt oseba&nbsp;</td>
		<td>tel št 1.&nbsp;</td>
		<td>tel št 2&nbsp;</td>
		<td>fax&nbsp;</td>
		<td>Potnik&nbsp;</td>
		<td>Razred&nbsp;</td>
		<td>Bala&nbsp;</td>
		<td>Blokada&nbsp;</td>
		<td>sif rač.&nbsp;</td>
		<td>Opomba&nbsp;</td>
		<td>Skupina&nbsp;</td>
		<td>Šifra enote&nbsp;</td>
	</tr>
<%
int recCount = 0;
while (rs.next()){
	recCount ++;
	String rowclass = "ewTableRow"; // Set row color
%>
<%
	if (recCount%2 != 0 ) { // Display alternate color for rows
		rowclass = "ewTableAltRow";
	}
%>
<%
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
	int  x_blokada = 0;
	String x_sif_rac = "";
	String x_opomba = "";
	String x_skupina = "";
	String x_sif_enote = "";

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}
	else{
		x_sif_kupca = "";
	}

	// naziv
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}
	else{
		x_naziv = "";
	}

	// naslov
	if (rs.getString("naslov") != null){
		x_naslov = rs.getString("naslov");
	}
	else{
		x_naslov = "";
	}

	// posta
	if (rs.getString("posta") != null){
		x_posta = rs.getString("posta");
	}
	else{
		x_posta = "";
	}

	// kraj
	if (rs.getString("kraj") != null){
		x_kraj = rs.getString("kraj");
	}
	else{
		x_kraj = "";
	}

	// kont_oseba
	if (rs.getString("kont_oseba") != null){
		x_kont_oseba = rs.getString("kont_oseba");
	}
	else{
		x_kont_oseba = "";
	}

	// tel_st1
	if (rs.getString("tel_st1") != null){
		x_tel_st1 = rs.getString("tel_st1");
	}
	else{
		x_tel_st1 = "";
	}

	// tel_st2
	if (rs.getString("tel_st2") != null){
		x_tel_st2 = rs.getString("tel_st2");
	}
	else{
		x_tel_st2 = "";
	}

	// fax
	if (rs.getString("fax") != null){
		x_fax = rs.getString("fax");
	}
	else{
		x_fax = "";
	}

	// potnik
	x_potnik = String.valueOf(rs.getLong("potnik"));

	// razred
	if (rs.getString("razred") != null){
		x_razred = rs.getString("razred");
	}
	else{
		x_razred = "";
	}

	// bala
	x_bala = String.valueOf(rs.getLong("bala"));

	// blokada
	x_blokada = rs.getInt("blokada");

	// sif_rac
	if (rs.getString("sif_rac") != null){
		x_sif_rac = rs.getString("sif_rac");
	}
	else{
		x_sif_rac = "";
	}

	// opomba
	if (rs.getString("opomba") != null){
		x_opomba = rs.getString("opomba");
	}
	else{
		x_opomba = "";
	}

	// skupina
	x_skupina = String.valueOf(rs.getLong("skupina"));

	// sif_enote
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_sif_kupca); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naziv); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naslov); %>&nbsp;</td>
		<td class="<%= rowclass %>"><%
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
		<td class="<%= rowclass %>"><% out.print(x_kraj); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_kont_oseba); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_tel_st1); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_tel_st2); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_fax); %>&nbsp;</td>
		<td class="<%= rowclass %>"><%
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
		<td class="<%= rowclass %>"><% out.print(x_razred); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_bala); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print((x_blokada == 1 ? "DA" : "NE")); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_sif_rac); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_opomba); %>&nbsp;</td>
		<td class="<%= rowclass %>"><%
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
		<td class="<%= rowclass %>"><%
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
<%
}
rs.close();
rs = null;
stmt.close();
stmt = null;
//conn.close();
conn = null;
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
</table>
<p>
<input type="submit" name="Action" value="Potrdi brisanje">
</form>
<%@ include file="footer.jsp" %>
