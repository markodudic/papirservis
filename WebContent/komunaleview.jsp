<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="komunalelist.jsp"%>
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
	response.sendRedirect("komunalelist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("komunalelist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_sif_kupca = "";
String x_naziv = "";
String x_naslov = "";
String x_posta = "";
String x_kraj = "";




// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kupci` WHERE `sif_kupca`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("komunalelist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// sif_kupca

		if (rs.getString("sif_kupca") != null){
			x_sif_kupca = rs.getString("sif_kupca");
		}else{
			x_sif_kupca = "";
		}

		// naziv
		if (rs.getString("naziv") != null){
			x_naziv = rs.getString("naziv");
		}else{
			x_naziv = "";
		}

		// naslov
		if (rs.getString("naslov") != null){
			x_naslov = rs.getString("naslov");
		}else{
			x_naslov = "";
		}

		// posta
		if (rs.getString("posta") != null){
			x_posta = rs.getString("posta");
		}else{
			x_posta = "";
		}

		// kraj
		if (rs.getString("kraj") != null){
			x_kraj = rs.getString("kraj");
		}else{
			x_kraj = "";
		}

	}
%>
<%@ include file="header.jsp" %>

<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: komunale<br><br><a href="komunalelist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_sif_kupca); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_naziv); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naslov&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_naslov); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pošta&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_posta!=null && ((String)x_posta).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_posta;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`posta` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `posta`, `kraj` FROM `poste`";
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
	</tr>
	<tr>
		<td class="ewTableHeader">Kraj&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kraj); %>&nbsp;</td>
	</tr>
</table>
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
