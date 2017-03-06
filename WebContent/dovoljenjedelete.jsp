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
	response.sendRedirect("dovoljenjelist.jsp"); 
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
	response.sendRedirect("dovoljenjelist.jsp");
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
		String strsql = "SELECT * FROM `dovoljenje` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("dovoljenjelist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		try{
		String strsql = "DELETE FROM `dovoljenje` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("dovoljenjelist.jsp");
		response.flushBuffer();
		return;
		}catch (SQLException ex){
			out.println("<table><tr><td><h2>Ni mogoče pobrisati izbrani zapis!!!</h2></td></tr></table>");
			String strsql1 = "SELECT * FROM `dovoljenje` WHERE " + sqlKey;
			rs = stmt.executeQuery(strsql1);
			if (!rs.next()) {
				response.sendRedirect("dovoljenjelist.jsp");
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

<p><span class="jspmaker">Izbriši iz: dovoljenja<br>
<br>
<a href="dovoljenjelist.jsp">Nazaj na pregled</a></span></p>
<form action="dovoljenjedelete.jsp" method="post">
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
	String x_sif_enote = "";
	String x_ewc = "";

	// id
	x_id = String.valueOf(rs.getLong("id"));

	// sif_enote
	if (rs.getString("sif_enote") != null){
		x_sif_enote = rs.getString("sif_enote");
	}
	else{
		x_sif_enote = "";
	}

	// ewc
	if (rs.getString("ewc") != null){
		x_ewc = rs.getString("ewc");
	}
	else{
		x_ewc = "";
	}
%>
	<tr class="<%= rowclass %>">
		<% key =  arRecKey[recCount-1]; %>
		<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>">
		<%
if (x_sif_enote!=null && ((String)x_sif_enote).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_enote;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_enote` = '" + tmpfld + "'";
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
%> &nbsp;</td>
		<td class="<%= rowclass %>">
		<%
if (x_ewc!=null && ((String)x_ewc).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_ewc;
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
