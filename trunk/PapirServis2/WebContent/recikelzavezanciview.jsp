<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"  errorPage="recikelzavezancilist.jsp"%>
<%@ page contentType="text/html; charset=utf-8" %>
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
	response.sendRedirect("recikelzavezancilist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("recikelzavezancilist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_id = "";
String x_st_pogodbe = "";
String x_naziv = "";
String x_naslov = "";
Object x_zacetek = null;
String x_uporabnik = "";
String x_kraj = "";


// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "select * from recikel_zavezanci" + session.getAttribute("leto") + " left join uporabniki on uporabnik = sif_upor WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("recikelzavezancilist.jsp");
		}else{
			rs.first();
		}

		if (rs.getString("st_pogodbe") != null){
			x_st_pogodbe = rs.getString("st_pogodbe");
		}else{
			x_st_pogodbe = "";
		}
		
		// sif_kupca
		if (rs.getString("naziv") != null){
			x_naziv = rs.getString("naziv");
		}else{
			x_naziv = "";
		}
		
		// kraj_naslov
		if (rs.getString("kraj") != null){
			x_kraj = rs.getString("kraj");
		}else{
			x_kraj = "";
		}
		
		// skupina
		if (rs.getString("naslov") != null){
			x_naslov = rs.getString("naslov");
		}else{
			x_naslov = "";
		}
		
		// zacetek
		if (rs.getTimestamp("zacetek") != null){
			x_zacetek = rs.getTimestamp("zacetek");
		}else{
			x_zacetek = "";
		}
		
		// veljavnost
		if (rs.getString("uporabnisko_ime") != null){
			x_uporabnik = rs.getString("uporabnisko_ime");
		}else{
			x_uporabnik = "";
		}
	}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled : recikel zavezanci<br><br><a href="recikelzavezancilist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Št. pogodbe&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_st_pogodbe); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_naziv); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kraj&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kraj); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naslov&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_naslov); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Začetek&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatDateTime(x_zacetek,7,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Uporabnik&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_uporabnik); %>&nbsp;</td>
	</tr>
</table>
</form>
<p>
<%
	rs.close();
	rs = null;
	stmt.close();
	stmt = null;
	conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="footer.jsp" %>
