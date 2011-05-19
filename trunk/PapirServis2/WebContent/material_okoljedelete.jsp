<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="materiali_okoljelist.jsp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
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
	response.sendRedirect("material_okoljelist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp"%>
<%@ include file="jspmkrfn.jsp"%>
<%
String tmpfld = null;
String escapeString = "\\\\'";

// Multiple delete records
String key = "";
String [] arRecKey = request.getParameterValues("key");
String sqlKey = "";
if (arRecKey == null || arRecKey.length == 0 ) {
	response.sendRedirect("material_okoljelist.jsp");
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
		String strsql = "SELECT * FROM `material_okolje` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("material_okoljelist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		try{
		String strsql = "DELETE FROM `material_okolje` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("material_okoljelist.jsp");
		response.flushBuffer();
		return;
		}catch (SQLException ex){
			out.println("<table><tr><td><h2>Ni mogoče pobrisati izbrani zapis!!!</h2></td></tr></table>");
			String strsql1 = "SELECT * FROM `material_okolje` WHERE " + sqlKey;
			rs = stmt.executeQuery(strsql1);
			if (!rs.next()) {
				response.sendRedirect("material_okoljelist.jsp");
			}else{
				rs.beforeFirst();
			}
		}
	}
%>
<%@ include file="header.jsp"%>

<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Izbriši iz: material koda<br>
<br>
<a href="material_okoljelist.jsp">Nazaj na pregled</a></span></p>
<form action="material_okoljedelete.jsp" method="post">
<p><input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Material koda&nbsp;</td>
		<td>EWC koda&nbsp;</td>
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
	String x_material_koda = "";
	String x_okolje_koda = "";

	// id
	x_id = String.valueOf(rs.getLong("id"));

	// material_koda
	if (rs.getString("material_koda") != null){
		x_material_koda = rs.getString("material_koda");
	}
	else{
		x_material_koda = "";
	}

	// okolje_koda
	if (rs.getString("okolje_koda") != null){
		x_okolje_koda = rs.getString("okolje_koda");
	}
	else{
		x_okolje_koda = "";
	}
%>
	<tr class="<%= rowclass %>">
		<% key =  arRecKey[recCount-1]; %>
		<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>">
		<%
if (x_material_koda!=null && ((String)x_material_koda).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_material_koda;
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
%> &nbsp;</td>
		<td class="<%= rowclass %>">
		<%
if (x_okolje_koda!=null && ((String)x_okolje_koda).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_okolje_koda;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`koda` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `koda`, `material` FROM `okolje`";
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
%> &nbsp;</td>
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
<p><input type="submit" name="Action" value="Potrdi brisanje">
</form>
<%@ include file="footer.jsp"%>
