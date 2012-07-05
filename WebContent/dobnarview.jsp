<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"   errorPage="dobnarlist.jsp"%>
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
int [] ew_SecTable = new int[3+1];
ew_SecTable[0] = 15;
ew_SecTable[1] = 13;
ew_SecTable[2] = 15;
ew_SecTable[3] = 8;

// get current table security
int ewCurSec = 0; // initialise
ewCurSec = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();

if ((ewCurSec & ewAllowView) != ewAllowView) {
	response.sendRedirect("dobnarlist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("dobnarlist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_id = "";
String x_st_dob = "";
String x_pozicija = "";
Object x_datum = null;
String x_sif_str = "";
String x_stranka = "";
String x_sif_kupca = "";
String x_sif_sof = "";
String x_sofer = "";
String x_sif_kam = "";
String x_kamion = "";
String x_koda = "";
String x_ewc = "";
String x_kolicina = "";
String x_skupina = "";
String x_skupina_text = "";
String x_opomba = "";
Object x_zacetek = null;
String x_uporabnik = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM dob_narocila dob WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("dobnarlist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// id

		x_id = String.valueOf(rs.getLong("id"));

		// st_dob
		x_st_dob = String.valueOf(rs.getLong("st_dob"));

		// pozicija
		x_pozicija = String.valueOf(rs.getLong("pozicija"));

		// datum
		if (rs.getTimestamp("datum") != null){
			x_datum = rs.getTimestamp("datum");
		}else{
			x_datum = "";
		}

		// sif_str
		x_sif_str = String.valueOf(rs.getLong("sif_str"));

		// stranka
		if (rs.getString("stranka") != null){
			x_stranka = rs.getString("stranka");
		}else{
			x_stranka = "";
		}

		// sif_kupca
		if (rs.getString("sif_kupca") != null){
			x_sif_kupca = rs.getString("sif_kupca");
		}else{
			x_sif_kupca = "";
		}

		// sif_sof
		if (rs.getString("sif_sof") != null){
			x_sif_sof = rs.getString("sif_sof");
		}else{
			x_sif_sof = "";
		}

		// sofer
		if (rs.getString("sofer") != null){
			x_sofer = rs.getString("sofer");
		}else{
			x_sofer = "";
		}

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

		// koda
		if (rs.getString("koda") != null){
			x_koda = rs.getString("koda");
		}else{
			x_koda = "";
		}

		// ewc
		if (rs.getString("ewc") != null){
			x_ewc = rs.getString("ewc");
		}else{
			x_ewc = "";
		}
		
		// kolicina
		x_kolicina = String.valueOf(rs.getLong("kolicina"));

		// skupina
		x_skupina = String.valueOf(rs.getLong("skupina"));

		// skupina_text
		if (rs.getString("skupina_text") != null){
			x_skupina_text = rs.getString("skupina_text");
		}else{
			x_skupina_text = "";
		}

		// opomba
		if (rs.getString("opomba") != null){
			x_opomba = rs.getString("opomba");
		}else{
			x_opomba = "";
		}

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

<p><span class="jspmaker">Pregled: dobavnice naro&#269;ila<br><br><a href="dobnarlist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Številka dobavnice&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_st_dob); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pozicija&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_pozicija); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatDateTime(x_datum,7,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_sif_str!=null && ((String)x_sif_str).length() > 0) {
		out.print(x_sif_str);
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stranka&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_stranka); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_sif_kupca!=null && ((String)x_sif_kupca).length() > 0) {
		out.print(x_sif_kupca);
	
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_sif_sof!=null && ((String)x_sif_sof).length() > 0) {
		out.print(x_sif_sof);
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šofer&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_sofer); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kamiona&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_sif_kam!=null && ((String)x_sif_kam).length() > 0) {
		out.print(x_sif_kam);
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kamion); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><%
			if (x_koda!=null && ((String)x_koda).length() > 0) {
					out.print(x_koda);
			}
		%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">EWC&nbsp;</td>
		<td class="ewTableAltRow"><%
			if (x_ewc!=null && ((String)x_ewc).length() > 0) {
					out.print(x_ewc);
			}
		%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Količina&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kolicina); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_skupina!=null && ((String)x_skupina).length() > 0) {
		out.print(x_skupina);

}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_skupina_text); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_opomba); %>&nbsp;</td>
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
