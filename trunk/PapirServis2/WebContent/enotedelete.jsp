<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="enotelist.jsp"%>
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
	response.sendRedirect("enotelist.jsp"); 
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
	response.sendRedirect("enotelist.jsp");
	response.flushBuffer();
	return;
}
for (int i = 0; i < arRecKey.length; i++){
	String reckey = arRecKey[i].trim();
	reckey = reckey.replaceAll("'",escapeString);

	// Build the SQL
	sqlKey +=  "(";
	sqlKey +=  "`sif_enote`=" + "" + reckey + "" + " AND ";
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
		String strsql = "SELECT * FROM `enote` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("enotelist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		try{
		String strsql = "DELETE FROM `enote` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("enotelist.jsp");
		response.flushBuffer();
		return;
		}catch (SQLException ex){
			out.println("<table><tr><td><h2>Ni mogoče pobrisati izbrani zapis!!!</h2></td></tr></table>");
			String strsql1 = "SELECT * FROM `enote` WHERE " + sqlKey;
			rs = stmt.executeQuery(strsql1);
			if (!rs.next()) {
				response.sendRedirect("enotelist.jsp");
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

<p><span class="jspmaker">Izbriši iz: enote<br><br><a href="enotelist.jsp">Nazaj na pregled</a></span></p>
<form action="enotedelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Naziv&nbsp;</td>
		<td>Lokacija&nbsp;</td>
		<td>Dovoljenje&nbsp;</td>
		<td>X koordinata&nbsp;</td>
		<td>Y koordinate&nbsp;</td>
		<td>Radij&nbsp;</td>
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
	String x_sif_enote = "";
	String x_naziv = "";
	String x_lokacija = "";
	String x_dovoljenje = "";
	String x_x_koord = "";
	String x_y_koord = "";
	String x_radij = "";

	// sif_enote
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));

	// naziv
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}
	else{
		x_naziv = "";
	}

	// lokacija
	if (rs.getString("lokacija") != null){
		x_lokacija = rs.getString("lokacija");
	}
	else{
		x_lokacija = "";
	}

	// dovoljenje
	if (rs.getString("dovoljenje") != null){
		x_dovoljenje = rs.getString("dovoljenje");
	}
	else{
		x_dovoljenje = "";
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
%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_naziv); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_lokacija); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_dovoljenje); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_x_koord); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_y_koord); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_radij); %>&nbsp;</td>
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
