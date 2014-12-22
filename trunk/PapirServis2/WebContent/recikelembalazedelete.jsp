<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"  errorPage="recikelembalazelist.jsp"%>
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
	response.sendRedirect("recikelembalazelist.jsp"); 
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
	response.sendRedirect("recikelembalazelist.jsp");
	response.flushBuffer();
	return;
}
for (int i = 0; i < arRecKey.length; i++){
	String reckey = arRecKey[i].trim();
	reckey = reckey.replaceAll("'",escapeString);

	// Build the SQL
	sqlKey +=  "(";
	sqlKey +=  "`id`=" + "'" + reckey + "'" + " AND ";
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
		String strsql = "select * from recikel_embalaze" + session.getAttribute("leto") + " left join okolje on ewc_koda = koda  left join uporabniki on uporabnik = sif_upor WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("recikelembalazelist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM recikel_embalaze" + session.getAttribute("leto") + " WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("recikelembalazelist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Izbriši iz tabele: recikel embalaže<br><br><a href="recikelembalazelist.jsp">Nazaj na pregled</a></span></p>
<form action="recikelembalazedelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>&nbsp;</td>
		<td>Material koda&nbsp;</td>
		<td>Cena&nbsp;</td>
		<td>Veljavnost&nbsp;</td>
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
	String x_tar_st = "";
	String x_naziv = "";
	String x_koda = "";
	Object x_zacetek = null;
	String x_uporabnik = "";
	String x_material = "";
	
	
	if (rs.getString("tar_st") != null){
		x_tar_st = rs.getString("tar_st");
	}else{
		x_tar_st = "";
	}
	
	// sif_kupca
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}
	
	// material_koda
	if (rs.getString("material") != null){
		x_material = rs.getString("material");
	}else{
		x_material = "";
	}
	
	// skupina
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
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
		<td class="<%= rowclass %>"><% out.print(x_tar_st); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naziv); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_koda); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_material); %>&nbsp;</td>
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
