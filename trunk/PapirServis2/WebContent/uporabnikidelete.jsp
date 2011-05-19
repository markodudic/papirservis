<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="uporabnikilist.jsp"%>
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

if ((ewCurSec & ewAllowAdmin) != ewAllowAdmin) {
	response.sendRedirect("uporabnikilist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<% String userid = (String) session.getAttribute("papirservis1_status_UserID"); 
Integer userlevel = (Integer) session.getAttribute("papirservis1_status_UserLevel"); 
if (userid == null && userlevel != null && (userlevel.intValue() != -1) ) {	response.sendRedirect("login.jsp");
	response.flushBuffer(); 
	return; 
}%>
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
	response.sendRedirect("uporabnikilist.jsp");
	response.flushBuffer();
	return;
}
for (int i = 0; i < arRecKey.length; i++){
	String reckey = arRecKey[i].trim();
	reckey = reckey.replaceAll("'",escapeString);

	// Build the SQL
	sqlKey +=  "(";
	sqlKey +=  "`sif_upor`=" + "" + reckey + "" + " AND ";
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
		String strsql = "SELECT * FROM `uporabniki` WHERE " + sqlKey;

		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("uporabnikilist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		try{
		String strsql = "DELETE FROM `uporabniki` WHERE " + sqlKey;

		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("uporabnikilist.jsp");
		response.flushBuffer();
		return;
		}catch (SQLException ex){
			out.println("<table><tr><td><h2>Ni mogoče pobrisati izbrani zapis!!!</h2></td></tr></table>");
			String strsql1 = "SELECT * FROM `uporabniki` WHERE " + sqlKey;
			if (((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue() != -1 ) { // Non system admin
					strsql1 = strsql1 + " AND (`sif_upor` = " + (String) session.getAttribute("papirservis1_status_UserID") + ")";
			}
			rs = stmt.executeQuery(strsql1);
			if (!rs.next()) {
				response.sendRedirect("uporabnikilist.jsp");
			}else{
				rs.beforeFirst();
			}
		}	
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Izbriši iz: uporabniki<br><br><a href="uporabnikilist.jsp">Nazaj na pregled</a></span></p>
<form action="uporabnikidelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>ime in priimek&nbsp;</td>
		<td>uporabnisko ime&nbsp;</td>
		<td>geslo&nbsp;</td>
		<td>tip&nbsp;</td>
		<td>aktiven&nbsp;</td>
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
	String x_sif_upor = "";
	String x_ime_in_priimek = "";
	String x_uporabnisko_ime = "";
	String x_geslo = "";
	String x_tip = "";
	String x_aktiven = "";

	// sif_upor
	x_sif_upor = String.valueOf(rs.getLong("sif_upor"));

	// ime_in_priimek
	if (rs.getString("ime_in_priimek") != null){
		x_ime_in_priimek = rs.getString("ime_in_priimek");
	}
	else{
		x_ime_in_priimek = "";
	}

	// uporabnisko_ime
	if (rs.getString("uporabnisko_ime") != null){
		x_uporabnisko_ime = rs.getString("uporabnisko_ime");
	}
	else{
		x_uporabnisko_ime = "";
	}

	// geslo
	if (rs.getString("geslo") != null){
		x_geslo = rs.getString("geslo");
	}
	else{
		x_geslo = "";
	}

	// tip
	if (rs.getString("tip") != null){
		x_tip = rs.getString("tip");
	}
	else{
		x_tip = "";
	}

	// aktiven
	if (rs.getString("aktiven") != null){
		x_aktiven = rs.getString("aktiven");
	}
	else{
		x_aktiven = "";
	}
%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_ime_in_priimek); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_uporabnisko_ime); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_geslo); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_tip); %>&nbsp;</td>
		<td class="<%= rowclass %>"><%
String [] ar_x_aktiven= x_aktiven.split(",");
String tmpfld_x_aktiven = "";
for (int i = 0; i < ar_x_aktiven.length;i++){
	String value = ar_x_aktiven[i].trim();
}
if (tmpfld_x_aktiven.length() > 0) { tmpfld_x_aktiven = tmpfld_x_aktiven.substring(0, tmpfld_x_aktiven.length()-1); }
out.print(tmpfld_x_aktiven);
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
