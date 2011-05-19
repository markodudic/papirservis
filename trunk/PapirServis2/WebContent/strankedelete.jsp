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

if ((ewCurSec & ewAllowDelete) != ewAllowDelete) {
	response.sendRedirect("strankelist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<%
String tmpfld = null;
String escapeString = "\\\\'";

// Multiple delete records
String key = "";
String [] arRecKey = request.getParameterValues("key");
String sqlKey = "";
if (arRecKey == null || arRecKey.length == 0 ) {
	response.sendRedirect("strankelist.jsp");
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
		String strsql = "SELECT * FROM `stranke` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("strankelist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		try{
		String strsql = "DELETE FROM `stranke` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("strankelist.jsp");
		response.flushBuffer();
		return;
		}catch (SQLException ex){
			out.println("<table><tr><td><h2>Ni mogoče pobrisati izbrani zapis!!!</h2></td></tr></table>");
			String strsql1 = "SELECT * FROM `stranke` WHERE " + sqlKey;
			rs = stmt.executeQuery(strsql1);
			if (!rs.next()) {
				response.sendRedirect("strankelist.jsp");
			}else{
				rs.beforeFirst();
			}
		}	
		
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Izbriši iz: stranke<br><br><a href="strankelist.jsp">Nazaj na pregled</a></span></p>
<form action="strankedelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Šifra stranke&nbsp;</td>
		<td>Naziv&nbsp;</td>
		<td>Naslov&nbsp;</td>
		<td>Pošta&nbsp;</td>
		<td>Kraj&nbsp;</td>
		<td>Telefon&nbsp;</td>
		<td>Fax&nbsp;</td>
		<td>Kontakt oseba&nbsp;</td>
		<td>Delovni čas&nbsp;</td>
		<td>Šifra OS&nbsp;</td>
		<td>Kol OS&nbsp;</td>
		<td>Opomba&nbsp;</td>
		<td>Šifra kupca&nbsp;</td>
		<td>Cena&nbsp;</td>
		<td>Najem&nbsp;</td>
		<td>Cena naj&nbsp;</td>
		<td>Veljavnost&nbsp;</td>
		<td>Začetek&nbsp;</td>
		<td>Uporabnik&nbsp;</td>
		<td>pon&nbsp;</td>
		<td>tor&nbsp;</td>
		<td>sre&nbsp;</td>
		<td>cet&nbsp;</td>
		<td>pet&nbsp;</td>
		<td>sob&nbsp;</td>
		<td>ned&nbsp;</td>
		<td>X koordinata&nbsp;</td>
		<td>Y koordinate&nbsp;</td>
		<td>Radij&nbsp;</td>
		<td>Vtez&nbsp;</td>
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
	String x_sif_str = "";
	String x_naziv = "";
	String x_naslov = "";
	String x_posta = "";
	String x_kraj = "";
	String x_telefon = "";
	String x_telefax = "";
	String x_kont_os = "";
	String x_del_cas = "";
	String x_sif_os = "";
	String x_kol_os = "";
	String x_opomba = "";
	String x_sif_kupca = "";
	String x_cena = "";
	String x_najem = "";
	String x_cena_naj = "";
	Timestamp x_zacetek = null;
	Timestamp x_veljavnost = null;
	
	String x_uporabnik = "";
	String x_pon = "";
	String x_tor = "";
	String x_sre = "";
	String x_cet = "";
	String x_pet = "";
	String x_sob = "";
	String x_ned = "";

	String x_x_koord = "";
	String x_y_koord = "";
	String x_radij = "";
	String x_vtez = "";
	
	// sif_str
	x_sif_str = String.valueOf(rs.getLong("sif_str"));

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

	// telefon
	if (rs.getString("telefon") != null){
		x_telefon = rs.getString("telefon");
	}
	else{
		x_telefon = "";
	}

	// telefax
	if (rs.getString("telefax") != null){
		x_telefax = rs.getString("telefax");
	}
	else{
		x_telefax = "";
	}

	// kont_os
	if (rs.getString("kont_os") != null){
		x_kont_os = rs.getString("kont_os");
	}
	else{
		x_kont_os = "";
	}

	// del_cas
	if (rs.getString("del_cas") != null){
		x_del_cas = rs.getString("del_cas");
	}
	else{
		x_del_cas = "";
	}

	// sif_os
	if (rs.getString("sif_os") != null){
		x_sif_os = rs.getString("sif_os");
	}
	else{
		x_sif_os = "";
	}

	// kol_os
	x_kol_os = String.valueOf(rs.getLong("kol_os"));

	// opomba
	if (rs.getString("opomba") != null){
		x_opomba = rs.getString("opomba");
	}
	else{
		x_opomba = "";
	}

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}
	else{
		x_sif_kupca = "";
	}

	// cena
	x_cena = String.valueOf(rs.getLong("cena"));

	// najem
	if (rs.getString("najem") != null){
		x_najem = rs.getString("najem");
	}
	else{
		x_najem = "";
	}

	// cena_naj
	x_cena_naj = String.valueOf(rs.getLong("cena_naj"));

	// zacetek
	if (rs.getTimestamp("zacetek") != null){
		x_zacetek = rs.getTimestamp("zacetek");
	}
	else{
		x_zacetek = null;
	}

	// veljavnost
	if (rs.getTimestamp("veljavnost") != null){
		x_veljavnost = rs.getTimestamp("veljavnost");
	}
	else{
		x_veljavnost = null;
	}
		
	// uporabnik
	x_uporabnik = String.valueOf(rs.getLong("uporabnik"));

	// pon
	if (rs.getString("pon")!= null){
		x_pon = rs.getString("pon");
		if (x_pon.equals("0")) x_pon = "ni odvoza"; 
		if (x_pon.equals("1")) x_pon = "sodi"; 
		if (x_pon.equals("2")) x_pon = "lihi"; 
		if (x_pon.equals("3")) x_pon = "vsak";
	}else{
		x_pon = "";
	}

	// tor
	if (rs.getString("tor")!= null){
		x_tor = rs.getString("tor");
		if (x_tor.equals("0")) x_tor = "ni odvoza"; 
		if (x_tor.equals("1")) x_tor = "sodi"; 
		if (x_tor.equals("2")) x_tor = "lihi"; 
		if (x_tor.equals("3")) x_tor = "vsak";
	}else{
		x_tor = "";
	}

	// sre
	if (rs.getString("sre")!= null){
		x_sre = rs.getString("sre");
		if (x_sre.equals("0")) x_sre = "ni odvoza"; 
		if (x_sre.equals("1")) x_sre = "sodi"; 
		if (x_sre.equals("2")) x_sre = "lihi"; 
		if (x_sre.equals("3")) x_sre = "vsak";

	}else{
		x_sre = "";
	}

	// cet
	if (rs.getString("cet")!= null){
		x_cet = rs.getString("cet");
		if (x_cet.equals("0")) x_cet = "ni odvoza"; 
		if (x_cet.equals("1")) x_cet = "sodi"; 
		if (x_cet.equals("2")) x_cet = "lihi"; 
		if (x_cet.equals("3")) x_cet = "vsak";
	}else{
		x_cet = "";
	}

	// pet
	if (rs.getString("pet")!= null){
		x_pet = rs.getString("pet");
		if (x_pet.equals("0")) x_pet = "ni odvoza"; 
		if (x_pet.equals("1")) x_pet = "sodi"; 
		if (x_pet.equals("2")) x_pet = "lihi"; 
		if (x_pet.equals("3")) x_pet = "vsak";
	}else{
		x_pet = "";
	}

	// sob
	if (rs.getString("sob")!= null){
		x_sob = rs.getString("sob");
		if (x_sob.equals("0")) x_sob = "ni odvoza"; 
		if (x_sob.equals("1")) x_sob = "sodi"; 
		if (x_sob.equals("2")) x_sob = "lihi"; 
		if (x_sob.equals("3")) x_sob = "vsak";
	}else{
		x_sob = "";
	}

	// ned
	if (rs.getString("ned")!= null){
		x_ned = rs.getString("ned");
		if (x_ned.equals("0")) x_ned = "ni odvoza"; 
		if (x_ned.equals("1")) x_ned = "sodi"; 
		if (x_ned.equals("2")) x_ned = "lihi"; 
		if (x_ned.equals("3")) x_ned = "vsak";

	}else{
		x_ned = "";
	}
	
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
%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_sif_str); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naziv); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naslov); %>&nbsp;</td>
		<td class="<%= rowclass %>"><%
if (x_posta!=null && ((String)x_posta).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_posta;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`posta` = '" + tmpfld + "'";
	String sqlwrk = "SELECT DISTINCT `posta`, `kraj` FROM `poste`";
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
		<td class="<%= rowclass %>"><% out.print(x_telefon); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_telefax); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_kont_os); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_del_cas); %>&nbsp;</td>
		<td class="<%= rowclass %>"><%
if (x_sif_os!=null && ((String)x_sif_os).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_os;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_os` = '" + tmpfld + "'";
	String sqlwrk = "SELECT DISTINCT `sif_os`, `osnovna` FROM `osnovna`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("osnovna"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_kol_os); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_opomba); %>&nbsp;</td>
		<td class="<%= rowclass %>"><%
if (x_sif_kupca!=null && ((String)x_sif_kupca).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_kupca;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_kupca` = '" + tmpfld + "'";
	String sqlwrk = "SELECT DISTINCT `sif_kupca`, `naziv` FROM `kupci`";
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
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_cena, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_najem); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_cena_naj, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatDateTime(x_veljavnost,7,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatDateTime(x_zacetek,7,locale)); %>&nbsp;</td>
		
		<td class="<%= rowclass %>"><%
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
		<td class="<%= rowclass %>"><% out.print(x_pon); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_tor); %>&nbsp;</td>  
		<td class="<%= rowclass %>"><% out.print(x_sre); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_cet); %>&nbsp;</td>  
		<td class="<%= rowclass %>"><% out.print(x_pet); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_sob); %>&nbsp;</td>  
		<td class="<%= rowclass %>"><% out.print(x_ned); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_x_koord); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_y_koord); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_radij); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_vtez); %>&nbsp;</td>
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
