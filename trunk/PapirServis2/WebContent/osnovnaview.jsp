<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="osnovnalist.jsp"%>
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
	response.sendRedirect("osnovnalist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("osnovnalist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_sif_os = "";
String x_osnovna = "";
String x_cena_am = "";
String x_kol_sk = "";
String x_kol_mb = "";
String x_kol_nm = "";
String x_kol_dv = "";
Object x_zacetek = null;
String x_uporabnik = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `osnovna` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("osnovnalist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// sif_os

		if (rs.getString("sif_os") != null){
			x_sif_os = rs.getString("sif_os");
		}else{
			x_sif_os = "";
		}

		// osnovna
		if (rs.getString("osnovna") != null){
			x_osnovna = rs.getString("osnovna");
		}else{
			x_osnovna = "";
		}

		// cena_am
		x_cena_am = String.valueOf(rs.getLong("cena_am"));

		// kol_sk
		x_kol_sk = String.valueOf(rs.getLong("kol_sk"));

		// kol_mb
		x_kol_mb = String.valueOf(rs.getLong("kol_mb"));

		// kol_nm
		x_kol_nm = String.valueOf(rs.getLong("kol_nm"));

		// kol_dv
		x_kol_dv = String.valueOf(rs.getLong("kol_dv"));

		// zacetek
		if (rs.getTimestamp("zacetek") != null){
			x_zacetek = rs.getTimestamp("zacetek");
		}else{
			x_zacetek = "";
		}

		// uporabnik
		x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
	}
%>
<%@ include file="header.jsp" %>

<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: osnovna<br><br><a href="osnovnalist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra osnove&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_sif_os); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Osnovna&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_osnovna); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena am&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_cena_am, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol sk&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kol_sk); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol mb&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kol_mb); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol nm&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kol_nm); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol dv&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kol_dv); %>&nbsp;</td>
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
