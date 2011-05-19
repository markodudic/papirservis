<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="materialilist.jsp"%>
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
	response.sendRedirect("materialilist.jsp"); 
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
	response.sendRedirect("materialilist.jsp");
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
		String strsql = "SELECT * FROM `materiali` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("materialilist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `materiali` WHERE " + sqlKey;
		try{
			stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("materialilist.jsp");
		return;
		}catch (SQLException ex){
			out.println("<table><tr><td><h2>Ni mogoče pobrisati izbrani zapis!!!</h2></td></tr></table>");
			String strsql1 = "SELECT * FROM `materiali` WHERE " + sqlKey;
			rs = stmt.executeQuery(strsql1);
			if (!rs.next()) {
				response.sendRedirect("materialilist.jsp");
			}else{
				rs.beforeFirst();
			}
		}
		//response.flushBuffer();
	}
%>
<%@ include file="header.jsp" %>

<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Izbriši iz: materiali<br><br><a href="materialilist.jsp">Nazaj na pregled</a></span></p>
<form action="materialidelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>koda&nbsp;</td>
		<td>Material&nbsp;</td>
		<td>pc nizka&nbsp;</td>
		<td>str dv&nbsp;</td>
		<td>sit sort&nbsp;</td>
		<td>sit zaup&nbsp;</td>
		<td>sit smet&nbsp;</td>
		<td>Ravnanje&nbsp;</td>
		<td>Prevoz 1&nbsp;</td>
		<td>Prevoz 2&nbsp;</td>
		<td>Prevoz 3&nbsp;</td>
		<td>Prevoz 4&nbsp;</td>
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
	String x_koda = "";
	String x_material = "";
	String x_pc_nizka = "";
	String x_str_dv = "";
	String x_sit_sort = "";
	String x_sit_zaup = "";
	String x_sit_smet = "";
	String x_ravnanje = "";
	String x_prevoz1 = "";
	String x_prevoz2 = "";
	String x_prevoz3 = "";
	String x_prevoz4 = "";
	Timestamp x_zacetek = null;
	Timestamp x_veljavnost  = null;
	
	String x_uporabnik = "";

	// koda
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}
	else{
		x_koda = "";
	}

	// material
	if (rs.getString("material") != null){
		x_material = rs.getString("material");
	}
	else{
		x_material = "";
	}

	// pc_nizka
	x_pc_nizka = String.valueOf(rs.getDouble("pc_nizka"));

	// str_dv
	x_str_dv = String.valueOf(rs.getDouble("str_dv"));

	// sit_sort
	x_sit_sort = String.valueOf(rs.getDouble("sit_sort"));

	// sit_zaup
	x_sit_zaup = String.valueOf(rs.getDouble("sit_zaup"));

	// sit_smet
	x_sit_smet = String.valueOf(rs.getDouble("sit_smet"));

	// ravnanje
	x_ravnanje = String.valueOf(rs.getDouble("ravnanje"));

	// prevoz1
	x_prevoz1 = String.valueOf(rs.getDouble("prevoz1"));

	// prevoz2
	x_prevoz2 = String.valueOf(rs.getDouble("prevoz2"));

	// prevoz3
	x_prevoz3 = String.valueOf(rs.getDouble("prevoz3"));

	// prevoz4
	x_prevoz4 = String.valueOf(rs.getDouble("prevoz4"));

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
%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_koda); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_material); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_pc_nizka, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_str_dv, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_sit_sort, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_sit_zaup, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_sit_smet, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_ravnanje, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_prevoz1, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_prevoz2, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_prevoz3, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(EW_FormatNumber("" + x_prevoz4, 4, 1, 1, 1,locale)); %>&nbsp;</td>
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
