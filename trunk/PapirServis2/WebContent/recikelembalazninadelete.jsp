<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"  errorPage="recikelembalazninalist.jsp"%>
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
if ((ewCurSec & ewAllowDelete) != ewAllowDelete) {
	response.sendRedirect("recikelembalazninalist.jsp"); 
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
	response.sendRedirect("recikelembalazninalist.jsp");
	response.flushBuffer();
	return;
}
for (int i = 0; i < arRecKey.length; i++){
	String reckey = arRecKey[i].trim();
	reckey = reckey.replaceAll("'",escapeString);

	// Build the SQL
	sqlKey +=  "(";
	sqlKey +=  "recikel_embalaznina" + session.getAttribute("leto") + ".id=" + "'" + reckey + "'" + " AND ";
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
		String strsql = "select recikel_embalaznina" + session.getAttribute("leto") + ".*, b.*, c.tar_st, c.naziv naziv2, c.porocilo, uporabniki.uporabnisko_ime " +
				"from recikel_embalaznina" + session.getAttribute("leto") + " " +
				"left join recikel_zavezanci" + session.getAttribute("leto") + " as b on id_zavezanca = b.id " +
				"left join recikel_embalaze" + session.getAttribute("leto") + " as c on id_embalaza = c.id " +
				"left join uporabniki on recikel_embalaznina" + session.getAttribute("leto") + ".uporabnik = sif_upor " +
				"WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("recikelembalazninalist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM recikel_embalaznina" + session.getAttribute("leto") + " WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("recikelembalazninalist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Izbriši iz tabele: recikel embalaznina<br><br><a href="recikelembalazninalist.jsp">Nazaj na pregled</a></span></p>
<form action="recikelembalazninadelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Št. pogodbe&nbsp;</td>
		<td>Naziv&nbsp;</td>
		<td>Naslov&nbsp;</td>
		<td>Kraj&nbsp;</td>
		<td>Pošta&nbsp;</td>
		
		<td>Tar. št.&nbsp;</td>
		<td>Naziv&nbsp;</td>
		<td>Poročilo&nbsp;</td>

		<td>Letna napoved&nbsp;</td>
		<td>Cena&nbsp;</td>

		<td>Začetek&nbsp;</td>
		<td>Uporabnik&nbsp;</td>
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
	String x_st_pogodbe = "";
	String x_naziv = "";
	String x_naslov = "";
	String x_kraj = "";
	String x_posta = "";
	
	String x_tar_st = "";
	String x_naziv2 = "";
	String x_porocilo = "";

	String x_letna_napoved = "";
	String x_cena = "";

	Object x_zacetek = null;
	String x_uporabnik = "";

	
	if (rs.getString("st_pogodbe") != null){
		x_st_pogodbe = rs.getString("st_pogodbe");
	}else{
		x_st_pogodbe = "";
	}	
	
	// sif_kupca
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}

	// kraj_naslov
	if (rs.getString("kraj") != null){
		x_kraj = rs.getString("kraj");
	}else{
		x_kraj = "";
	}

	// skupina
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
	
	if (rs.getString("tar_st") != null){
		x_tar_st = rs.getString("tar_st");
	}else{
		x_tar_st = "";
	}	
	
	if (rs.getString("naziv2") != null){
		x_naziv2 = rs.getString("naziv2");
	}else{
		x_naziv2 = "";
	}	
	
	if (rs.getString("porocilo") != null){
		x_porocilo = rs.getString("porocilo");
	}else{
		x_porocilo = "";
	}	
	
	if (rs.getString("letna_napoved") != null){
		x_letna_napoved = rs.getString("letna_napoved");
	}else{
		x_letna_napoved = "";
	}	
	
	if (rs.getString("cena") != null){
		x_cena = rs.getString("cena");
	}else{
		x_cena = "";
	}	
	
	// zacetek
	if (rs.getTimestamp("zacetek") != null){
		x_zacetek = rs.getTimestamp("zacetek");
	}else{
		x_zacetek = "";
	}
	
	// veljavnost
	if (rs.getString("uporabnisko_ime") != null){
		x_uporabnik = rs.getString("uporabnisko_ime");
	}else{
		x_uporabnik = "";
	}
%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_st_pogodbe); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naziv); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naslov); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_kraj); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_posta); %>&nbsp;</td>
		
		<td class="<%= rowclass %>"><% out.print(x_tar_st); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naziv2); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_porocilo); %>&nbsp;</td>

		<td class="<%= rowclass %>"><% out.print(x_letna_napoved); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_cena); %>&nbsp;</td>

		<td class="<%= rowclass %>"><% out.print(EW_FormatDateTime(x_zacetek,7,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatDateTime(x_uporabnik,7,locale)); %>&nbsp;</td>
  </tr>
<%
}
rs.close();
rs = null;
stmt.close();
stmt = null;
conn.close();
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
