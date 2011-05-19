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

if ((ewCurSec & ewAllowView) != ewAllowView) {
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
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("materialilist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
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
Object x_zacetek = null;
String x_uporabnik = "";
Object x_veljavnost = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `materiali` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("materialilist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// koda

		if (rs.getString("koda") != null){
			x_koda = rs.getString("koda");
		}else{
			x_koda = "";
		}

		// material
		if (rs.getString("material") != null){
			x_material = rs.getString("material");
		}else{
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

<p><span class="jspmaker">Pregled: materiali<br><br><a href="materialilist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_koda); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Material&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_material); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">pc nizka&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_pc_nizka, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">str dv&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_str_dv, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit sort&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_sit_sort, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit zaup&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_sit_zaup, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit smet&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_sit_smet, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Ravnanje&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_ravnanje, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz 1&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_prevoz1, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz 2&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_prevoz2, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz 3&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_prevoz3, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz 4&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_prevoz4, 4, 1, 1, 1,locale)); %>&nbsp;</td>
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
