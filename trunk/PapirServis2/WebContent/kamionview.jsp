<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="kamionlist.jsp"%>
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
	response.sendRedirect("kamionlist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("kamionlist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_sif_kam = "";
String x_kamion = "";
String x_registrska = "";
String x_cena_km = "";
String x_cena_ura = "";
String x_cena_kg = "";
String x_c_km = "";
String x_c_ura = "";
Object x_zacetek = null;
String x_uporabnik = "";
Object x_veljavnost = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kamion` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("kamionlist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// sif_kam

		if (rs.getString("sif_kam") != null){
			x_sif_kam = rs.getString("sif_kam");
		}else{
			x_sif_kam = "";
		}

		// kamion
		if (rs.getString("kamion") != null){
			x_kamion = rs.getString("kamion");
		}else{
			x_kamion = "";
		}

		// registrska
		if (rs.getString("registrska") != null){
			x_registrska = rs.getString("registrska");
		}else{
			x_registrska = "";
		}
		
		// cena_km
		x_cena_km = String.valueOf(rs.getLong("cena_km"));

		// cena_ura
		x_cena_ura = String.valueOf(rs.getLong("cena_ura"));

		// cena_kg
		x_cena_kg = String.valueOf(rs.getLong("cena_kg"));

		// c_km
		x_c_km = String.valueOf(rs.getLong("c_km"));

		// c_ura
		x_c_ura = String.valueOf(rs.getLong("c_ura"));

		// zacetek
		if (rs.getTimestamp("zacetek") != null){
			x_zacetek = rs.getTimestamp("zacetek");
		}else{
			x_zacetek = "";
		}
		// veljavnost
		if (rs.getTimestamp("veljavnost") != null){
			x_veljavnost = rs.getTimestamp("veljavnost");
		}else{
			x_veljavnost = "";
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

<p><span class="jspmaker">Pregled: kamion<br><br><a href="kamionlist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra kamiona&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_sif_kam); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kamion); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Registrska&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_registrska); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na km&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_cena_km, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na uro&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_cena_ura, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Cena kg&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_cena_kg, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr-->
	<tr>
		<td class="ewTableHeader">c km&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_c_km, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">c ura&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_c_ura, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Veljavnost&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatDateTime(x_veljavnost,7,locale)); %>&nbsp;</td>
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
