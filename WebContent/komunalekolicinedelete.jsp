<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"  errorPage="komunalekolicinelist.jsp"%>
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
	response.sendRedirect("komunalekolicinelist.jsp"); 
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
	response.sendRedirect("komunalekolicinelist.jsp");
	response.flushBuffer();
	return;
}
for (int i = 0; i < arRecKey.length; i++){
	String reckey = arRecKey[i].trim();
	reckey = reckey.replaceAll("'",escapeString);

	// Build the SQL
	sqlKey +=  "(";
	sqlKey +=  "komunale_kolicine.id=" + "'" + reckey + "'" + " AND ";
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
		String strsql = "select komunale_kolicine.*, b.naziv, c.material, uporabniki.uporabnisko_ime " +
				"from " + session.getAttribute("letoTabelaKomunale") + " komunale_kolicine " +
				"left join kupci as b on komunale_kolicine.sif_kupca = b.sif_kupca " +
				"left join okolje as c on komunale_kolicine.koda = c.koda " +
				"left join uporabniki on komunale_kolicine.uporabnik = sif_upor " +
				"WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("komunalekolicinelist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM " + session.getAttribute("letoTabelaKomunale") + "  WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("komunalekolicinelist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Izbriši iz tabele: komunale količine<br><br><a href="komunalekolicinelist.jsp">Nazaj na pregled</a></span></p>
<form action="komunalekolicinedelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Šifra komunale&nbsp;</td>
		<td>Naziv&nbsp;</td>
		<td>Koda&nbsp;</td>
		<td>Material&nbsp;</td>
		<td>Združi&nbsp;</td>
		<td>Delež&nbsp;</td>
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
	String x_sif_kupca = "";
	String x_naziv = "";
	String x_koda = "";
	String x_material = "";
	String x_zdruzi = "";
	float x_delez = 0;
	
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}	
	
	// sif_kupca
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}

	// kraj_naslov
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}

	// skupina
	if (rs.getString("material") != null){
		x_material = rs.getString("material");
	}else{
		x_material = "";
	}
	
	if (rs.getString("zdruzi") != null){
		x_zdruzi = rs.getString("zdruzi");
	}else{
		x_zdruzi = "";
	}	
	
	if (rs.getString("delez") != null){
		x_delez = rs.getFloat("delez");
	}else{
		x_delez = 0;
	}		
	
%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_sif_kupca); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_naziv); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_koda); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_material); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_zdruzi); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_delez); %>&nbsp;</td>
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
