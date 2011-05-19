<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="dobavnicalist.jsp"%>
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
int [] ew_SecTable = new int[3+1];
ew_SecTable[0] = 15;
ew_SecTable[1] = 13;
ew_SecTable[2] = 15;
ew_SecTable[3] = 8;

// get current table security
int ewCurSec = 0; // initialise
ewCurSec = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();

if ((ewCurSec & ewAllowDelete) != ewAllowDelete) {
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

// Multiple delete records
String key = "";
String [] arRecKey = request.getParameterValues("key");
String sqlKey = "";
if (arRecKey == null || arRecKey.length == 0 ) {
	response.sendRedirect("dobavnicalist.jsp");
	response.flushBuffer();
	return;
}
for (int i = 0; i < arRecKey.length; i++){
	String reckey = arRecKey[i].trim();
	reckey = reckey.replaceAll("'",escapeString);

	// Build the SQL
	sqlKey +=  "(";
	sqlKey +=  "`id`=" + "" + reckey + "" + " AND ";
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
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabela") + " WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("dobavnicalist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM " + session.getAttribute("letoTabela") + " WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("dobavnicalist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Izbriši iz: Delovni nalog<br><br><a href="dobavnicalist.jsp">Nazaj na pregled</a></span></p>
<form action="dobavnicadelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Številka dobavnice&nbsp;</td>
		<!--td>Pozicija&nbsp;</td -->
		<td>Datum&nbsp;</td>
		<td>Stranke&nbsp;</td>
		<!--td>stranka&nbsp;</td-->
		<td>Šifra kupca&nbsp;</td>
		<td>Šofer&nbsp;</td>
		<!--td>sofer&nbsp;</td>
		<td>sif kam&nbsp;</td>
		<td>kamion&nbsp;</td>
		<td>Cena km&nbsp;</td>
		<td>Cena ura&nbsp;</td>
		<td>c km&nbsp;</td>
		<td>c ura&nbsp;</td>
		<td>Štev km&nbsp;</td>
		<td>Štev ur&nbsp;</td>
		<td>stroski&nbsp;</td>
		<td>koda&nbsp;</td>
		<td>Kolicina&nbsp;</td>
		<td>Cena&nbsp;</td>
		<td>kg zaup&nbsp;</td>
		<td>sit zaup&nbsp;</td>
		<td>kg sort&nbsp;</td>
		<td>sit sort&nbsp;</td>
		<td>sit smet&nbsp;</td-->
		<td>Skupina&nbsp;</td>
		<!--td>Skupina text&nbsp;</td-->
		<td>Opomba&nbsp;</td>
		<!--td>Štev km sled&nbsp;</td>
		<td>Štev ur sled&nbsp;</td-->
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
	String x_id = "";
	String x_st_dob = "";
	String x_pozicija = "";
	Timestamp x_datum = null;
	String x_sif_str = "";
	String x_stranka = "";
	String x_sif_kupca = "";
	String x_sif_sof = "";
	String x_sofer = "";
	String x_sif_kam = "";
	String x_kamion = "";
	String x_cena_km = "";
	String x_cena_ura = "";
	String x_c_km = "";
	String x_c_ura = "";
	String x_stev_km = "";
	String x_stev_ur = "";
	String x_stroski = "";
	String x_koda = "";
	String x_kolicina = "";
	String x_cena = "";
	String x_kg_zaup = "";
	String x_sit_zaup = "";
	String x_kg_sort = "";
	String x_sit_sort = "";
	String x_sit_smet = "";
	String x_skupina = "";
	String x_skupina_text = "";
	String x_opomba = "";
	String x_stev_km_sled = "";
	String x_stev_ur_sled = "";
	Timestamp x_zacetek = null;
	
	String x_uporabnik = "";

	// id
	x_id = String.valueOf(rs.getLong("id"));

	// st_dob
	x_st_dob = String.valueOf(rs.getLong("st_dob"));

	// pozicija
	x_pozicija = String.valueOf(rs.getLong("pozicija"));

	// datum
	if (rs.getTimestamp("datum") != null){
		x_datum = rs.getTimestamp("datum");
	}
	else{
		x_datum = null;
	}

	// sif_str
	x_sif_str = String.valueOf(rs.getLong("sif_str"));

	// stranka
	if (rs.getString("stranka") != null){
		x_stranka = rs.getString("stranka");
	}
	else{
		x_stranka = "";
	}

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}
	else{
		x_sif_kupca = "";
	}

	// sif_sof
	if (rs.getString("sif_sof") != null){
		x_sif_sof = rs.getString("sif_sof");
	}
	else{
		x_sif_sof = "";
	}

	// sofer
	if (rs.getString("sofer") != null){
		x_sofer = rs.getString("sofer");
	}
	else{
		x_sofer = "";
	}

	// sif_kam
	if (rs.getString("sif_kam") != null){
		x_sif_kam = rs.getString("sif_kam");
	}
	else{
		x_sif_kam = "";
	}

	// kamion
	if (rs.getString("kamion") != null){
		x_kamion = rs.getString("kamion");
	}
	else{
		x_kamion = "";
	}

	// cena_km
	x_cena_km = String.valueOf(rs.getLong("cena_km"));

	// cena_ura
	x_cena_ura = String.valueOf(rs.getLong("cena_ura"));

	// c_km
	x_c_km = String.valueOf(rs.getLong("c_km"));

	// c_ura
	x_c_ura = String.valueOf(rs.getLong("c_ura"));

	// stev_km
	x_stev_km = String.valueOf(rs.getLong("stev_km"));

	// stev_ur
	x_stev_ur = String.valueOf(rs.getLong("stev_ur"));

	// stroski
	x_stroski = String.valueOf(rs.getLong("stroski"));

	// koda
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}
	else{
		x_koda = "";
	}

	// kolicina
	x_kolicina = String.valueOf(rs.getLong("kolicina"));

	// cena
	x_cena = String.valueOf(rs.getLong("cena"));

	// kg_zaup
	x_kg_zaup = String.valueOf(rs.getLong("kg_zaup"));

	// sit_zaup
	x_sit_zaup = String.valueOf(rs.getLong("sit_zaup"));

	// kg_sort
	x_kg_sort = String.valueOf(rs.getLong("kg_sort"));

	// sit_sort
	x_sit_sort = String.valueOf(rs.getLong("sit_sort"));

	// sit_smet
	x_sit_smet = String.valueOf(rs.getLong("sit_smet"));

	// skupina
	x_skupina = String.valueOf(rs.getLong("skupina"));

	// skupina_text
	if (rs.getString("skupina_text") != null){
		x_skupina_text = rs.getString("skupina_text");
	}
	else{
		x_skupina_text = "";
	}

	// opomba
	if (rs.getString("opomba") != null){
		x_opomba = rs.getString("opomba");
	}
	else{
		x_opomba = "";
	}

	// stev_km_sled
	x_stev_km_sled = String.valueOf(rs.getLong("stev_km_sled"));

	// stev_ur_sled
	x_stev_ur_sled = String.valueOf(rs.getLong("stev_ur_sled"));

	// zacetek
	if (rs.getTimestamp("zacetek") != null){
		x_zacetek = rs.getTimestamp("zacetek");
	}
	else{
		x_zacetek = null;
	}

	// uporabnik
	x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_st_dob); %>&nbsp;</td>
		<!--  td class="<%= rowclass %>"><% out.print(x_pozicija); %>&nbsp;</td -->
		<td class="<%= rowclass %>"><% out.print(EW_FormatDateTime(x_datum,7,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><%
if (x_sif_str!=null && ((String)x_sif_str).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_str` = " + x_sif_str;
	String sqlwrk = "SELECT `sif_str`, `naziv` FROM `stranke`";
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
		<td><%
if (x_sif_kupca!=null && ((String)x_sif_kupca).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_kupca;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_kupca` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `naziv` FROM `kupci`";
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
		<td class="<%= rowclass %>"><%
if (x_sif_sof!=null && ((String)x_sif_sof).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_sof;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_sof` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `sif_sof`, `sofer` FROM `sofer`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("sofer"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>









		<!--td><% out.print(x_kamion); %>&nbsp;</td>
		<td><% out.print(x_cena_km); %>&nbsp;</td>
		<td><% out.print(x_cena_ura); %>&nbsp;</td>
		<td><% out.print(x_c_km); %>&nbsp;</td>
		<td><% out.print(x_c_ura); %>&nbsp;</td>
		<td><% out.print(x_stev_km); %>&nbsp;</td>
		<td><% out.print(x_stev_ur); %>&nbsp;</td>
		<td><% out.print(x_stroski); %>&nbsp;</td>
		<td--><%
/*
if (x_koda!=null && ((String)x_koda).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_koda;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`koda` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `koda`, `material` FROM `materiali`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("material"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
*/
%>
&nbsp;</td-->
		<!--td><% out.print(x_kolicina); %>&nbsp;</td>
		<td><% out.print(x_cena); %>&nbsp;</td>
		<td><% out.print(x_kg_zaup); %>&nbsp;</td>
		<td><% out.print(x_sit_zaup); %>&nbsp;</td>
		<td><% out.print(x_kg_sort); %>&nbsp;</td>
		<td><% out.print(x_sit_sort); %>&nbsp;</td>
		<td><% out.print(x_sit_smet); %>&nbsp;</td-->
		<!--td><% out.print(x_skupina); %>&nbsp;</td-->
		<td><%
if (x_skupina!=null && ((String)x_skupina).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`skupina` = " + x_skupina;
	String sqlwrk = "SELECT `tekst` FROM `skup`";
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
		<!--td><% out.print(x_skupina_text); %>&nbsp;</td-->
		<td><% out.print(x_opomba); %>&nbsp;</td>
		<!--td><% out.print(EW_FormatDateTime(x_zacetek,7,locale)); %>&nbsp;</td>
		<td><%
if (x_uporabnik!=null && ((String)x_uporabnik).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_upor` = " + x_uporabnik;
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
		
		<td><% out.print(x_stev_km_sled); %>&nbsp;</td>
		<td><% out.print(x_stev_ur_sled); %>&nbsp;</td-->
	</tr>











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
