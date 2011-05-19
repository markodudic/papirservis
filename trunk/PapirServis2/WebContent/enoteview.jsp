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

if ((ewCurSec & ewAllowView) != ewAllowView) {
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
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("enotelist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_sif_enote = "";
String x_naziv = "";
String x_lokacija = "";
String x_dovoljenje = "";
String x_x_koord = "";
String x_y_koord = "";
String x_radij = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `enote` WHERE `sif_enote`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("enotelist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// sif_enote

		x_sif_enote = String.valueOf(rs.getLong("sif_enote"));

		// naziv
		if (rs.getString("naziv") != null){
			x_naziv = rs.getString("naziv");
		}else{
			x_naziv = "";
		}

		// lokacija
		if (rs.getString("lokacija") != null){
			x_lokacija = rs.getString("lokacija");
		}else{
			x_lokacija = "";
		}

		if (rs.getString("dovoljenje") != null){
			x_dovoljenje = (String) rs.getString("dovoljenje");
		}else{
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
}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: enote<br><br><a href="enotelist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra enote&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_sif_enote); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_naziv); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Lokacija&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_lokacija); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dovoljenje&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_dovoljenje); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">X koordinata&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_x_koord); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Y koordinata&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_y_koord); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Radij&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_radij); %>&nbsp;</td>
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
