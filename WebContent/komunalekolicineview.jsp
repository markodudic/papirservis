<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"  errorPage="komunalekolicinelist.jsp"%>
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
	response.sendRedirect("komunalekolicinelist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("komunalekolicinelist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_id = "";
String x_sif_kupca = "";
String x_naziv = "";
String x_koda = "";
String x_material = "";
String x_zdruzi = "";
float x_delez = 0;



// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "select komunale_kolicine.*, b.naziv, c.material, uporabniki.uporabnisko_ime " +
				"from " + session.getAttribute("letoTabelaKomunale") + " komunale_kolicine " +
				"left join kupci as b on komunale_kolicine.sif_kupca = b.sif_kupca " +
				"left join okolje as c on komunale_kolicine.koda = c.koda " +
				"left join uporabniki on komunale_kolicine.uporabnik = sif_upor " +
				"WHERE komunale_kolicine.id=" + tkey;

		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("komunalekolicinelist.jsp");
		}else{
			rs.first();
		}

		if (rs.getString("sif_kupca") != null){
			x_sif_kupca = rs.getString("sif_kupca");
		}else{
			x_sif_kupca = "";
		}	
		
		// sif_kupca
		if (rs.getString("naziv") != null){
			x_naziv = rs.getString("naziv");
		}else{
			x_naziv = "";
		}

		// kraj_naslov
		if (rs.getString("koda") != null){
			x_koda = rs.getString("koda");
		}else{
			x_koda = "";
		}

		// skupina
		if (rs.getString("material") != null){
			x_material = rs.getString("material");
		}else{
			x_material = "";
		}
		
		if (rs.getString("zdruzi") != null){
			x_zdruzi = rs.getString("zdruzi");
		}else{
			x_zdruzi = "";
		}	
		
		if (rs.getString("delez") != null){
			x_delez = rs.getFloat("delez");
		}else{
			x_delez = 0;
		}	
	}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled : komunale količine<br><br><a href="komunalekolicinelist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra komunale&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_sif_kupca); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_naziv); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_koda); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Material&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_material); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Združi&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_zdruzi); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Delež&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_delez); %>&nbsp;</td>
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
