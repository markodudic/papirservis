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

if ((ewCurSec & ewAllowView) != ewAllowView) {
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
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("uporabnikilist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_sif_upor = "";
String x_ime_in_priimek = "";
String x_uporabnisko_ime = "";
String x_geslo = "";
String x_tip = "";
String x_aktiven = "";
String x_porocila = "";
String x_sif_enote = "";
String x_vse = "";
String x_enote = "";


// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `uporabniki` WHERE `sif_upor`=" + tkey;
		Integer userLevel = (Integer) session.getAttribute("papirservis1_status_UserLevel");
		if (userLevel != null && userLevel.intValue() != -1) { // Non system admin
			strsql += " AND (`sif_upor` = " + (String) session.getAttribute("papirservis1_status_UserID") + ")";
		}
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("uporabnikilist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// sif_upor

		x_sif_upor = String.valueOf(rs.getLong("sif_upor"));

		// ime_in_priimek
		if (rs.getString("ime_in_priimek") != null){
			x_ime_in_priimek = rs.getString("ime_in_priimek");
		}else{
			x_ime_in_priimek = "";
		}

		// uporabnisko_ime
		if (rs.getString("uporabnisko_ime") != null){
			x_uporabnisko_ime = rs.getString("uporabnisko_ime");
		}else{
			x_uporabnisko_ime = "";
		}

		// geslo
		if (rs.getString("geslo") != null){
			x_geslo = rs.getString("geslo");
		}else{
			x_geslo = "";
		}

		// tip
		if (rs.getString("tip") != null){
			x_tip = rs.getString("tip");
		}else{
			x_tip = "";
		}

		// aktiven
		if (rs.getBoolean("aktiven")){
			x_aktiven = "X";
		}else{
			x_aktiven = "";
		}
		// porocila
		if (rs.getBoolean("porocila")){
			x_porocila = "X";
		}else{
			x_porocila = "";
		}

		// vse
		if (rs.getBoolean("vse")){
			x_vse= "X";
		}else{
			x_vse= "";
		}
		// porocila
		if (rs.getBoolean("enote")){
			x_enote= "X";
		}else{
			x_enote= "";
		}

		// sif_enote
		x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
		
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Pregled: uporabniki<br><br><a href="uporabnikilist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">ime in priimek&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_ime_in_priimek); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">uporabnisko ime&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_uporabnisko_ime); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">geslo&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_geslo); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">tip&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_tip); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">aktiven&nbsp;</td>
		<td class="ewTableAltRow"><%out.print(x_aktiven);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">poročila&nbsp;</td>
		<td class="ewTableAltRow"><%out.print(x_porocila);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">vse&nbsp;</td>
		<td class="ewTableAltRow"><%out.print(x_vse);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">enote&nbsp;</td>
		<td class="ewTableAltRow"><%out.print(x_enote);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra enote&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_sif_enote!=null && ((String)x_sif_enote).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_enote` = " + x_sif_enote;
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
%>
&nbsp;</td>
	</tr></table>
</form>
<p>
<%
	rs.close();
	rs = null;
	stmt.close();
	stmt = null;
	//conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="footer.jsp" %>
