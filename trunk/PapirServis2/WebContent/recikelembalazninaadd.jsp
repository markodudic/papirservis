<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="recikelembalazninalist.jsp"%>
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
if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("recikelembalazninalist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("utf-8");

// Get action
String a = request.getParameter("a");
String key = "";
if (a == null || a.length() == 0) {
	key = request.getParameter("key");
	if (key != null && key.length() > 0) {
		a = "C"; // Copy record
	} else {
		a = "I"; // Display blank record
	}
}
String x_id = "";

String x_id_zavezanca = "";
String x_id_embalaza = "";

String x_letna_napoved = "";
String x_cena = "";
String x_kol_jan = "";
String x_kol_feb = "";
String x_kol_mar = "";
String x_kol_apr = "";
String x_kol_maj = "";
String x_kol_jun = "";
String x_kol_jul = "";
String x_kol_avg = "";
String x_kol_sep = "";
String x_kol_okt = "";
String x_kol_nov = "";
String x_kol_dec = "";

Object x_zacetek = null;
String x_uporabnik = "";

StringBuffer x_naslovList = null;

// Open Connection to the database
try{ 
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM recikel_embalaznina" + session.getAttribute("leto") + " WHERE `id`=" + tkey;
		
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("recikelembalazninalist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

		if (rs.getString("id_zavezanca") != null){
			x_id_zavezanca = rs.getString("id_zavezanca");
		}else{
			x_id_zavezanca = "";
		}
		
		if (rs.getString("id_embalaza") != null){
			x_id_embalaza = rs.getString("id_embalaza");
		}else{
			x_id_embalaza = "";
		}	

		// Get the field contents
		if (rs.getString("letna_napoved") != null){
			x_letna_napoved = rs.getString("letna_napoved");
		}else{
			x_letna_napoved = "";
		}	
		
		if (rs.getString("cena") != null){
			x_cena = rs.getString("cena");
		}else{
			x_cena = "";
		}	
		
		if (rs.getString("kol_jan") != null){
			x_kol_jan = rs.getString("kol_jan");
		}else{
			x_kol_jan = "";
		}	
		
		if (rs.getString("kol_feb") != null){
			x_kol_feb = rs.getString("kol_feb");
		}else{
			x_kol_feb = "";
		}	
		
		if (rs.getString("kol_mar") != null){
			x_kol_mar = rs.getString("kol_mar");
		}else{
			x_kol_mar = "";
		}	
		
		if (rs.getString("kol_apr") != null){
			x_kol_apr = rs.getString("kol_apr");
		}else{
			x_kol_apr = "";
		}	
		
		if (rs.getString("kol_maj") != null){
			x_kol_maj = rs.getString("kol_maj");
		}else{
			x_kol_maj = "";
		}		
		if (rs.getString("kol_jun") != null){
			x_kol_jun = rs.getString("kol_jun");
		}else{
			x_kol_jun = "";
		}

		if (rs.getString("kol_jul") != null){
			x_kol_jul = rs.getString("kol_jul");
		}else{
			x_kol_jul = "";
		}
		
		if (rs.getString("kol_avg") != null){
			x_kol_avg = rs.getString("kol_avg");
		}else{
			x_kol_avg = "";
		}
		
		if (rs.getString("kol_sep") != null){
			x_kol_sep = rs.getString("kol_sep");
		}else{
			x_kol_sep = "";
		}
		
		if (rs.getString("kol_okt") != null){
			x_kol_okt = rs.getString("kol_okt");
		}else{
			x_kol_okt = "";
		}	

		
		if (rs.getString("kol_nov") != null){
			x_kol_nov = rs.getString("kol_nov");
		}else{
			x_kol_nov = "";
		}	
		
		if (rs.getString("kol_dec") != null){
			x_kol_dec = rs.getString("kol_dec");
		}else{
			x_kol_dec = "";
		}		

		if (rs.getTimestamp("zacetek") != null){
			x_zacetek = rs.getTimestamp("zacetek");
		}else{
			x_zacetek = null;
		}
		x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		if (request.getParameter("x_id_zavezanca") != null){
			x_id_zavezanca = request.getParameter("x_id_zavezanca");
		}else{
			x_id_zavezanca = "";
		}
		
		if (request.getParameter("x_id_embalaza") != null){
			x_id_embalaza = request.getParameter("x_id_embalaza");
		}else{
			x_id_embalaza = "";
		}	

		// Get fields from form
		if (request.getParameter("x_letna_napoved") != null){
			x_letna_napoved = request.getParameter("x_letna_napoved");
		}else{
			x_letna_napoved = "";
		}	
		
		if (request.getParameter("x_cena") != null){
			x_cena = request.getParameter("x_cena");
		}else{
			x_cena = "";
		}	
		
		if (request.getParameter("x_kol_jan") != null){
			x_kol_jan = request.getParameter("x_kol_jan");
		}else{
			x_kol_jan = "";
		}	
		
		if (request.getParameter("x_kol_feb") != null){
			x_kol_feb = request.getParameter("x_kol_feb");
		}else{
			x_kol_feb = "";
		}	
		
		if (request.getParameter("x_kol_mar") != null){
			x_kol_mar = request.getParameter("x_kol_mar");
		}else{
			x_kol_mar = "";
		}	
		
		if (request.getParameter("x_kol_apr") != null){
			x_kol_apr = request.getParameter("x_kol_apr");
		}else{
			x_kol_apr = "";
		}	
		
		if (request.getParameter("x_kol_maj") != null){
			x_kol_maj = request.getParameter("x_kol_maj");
		}else{
			x_kol_maj = "";
		}		
		if (request.getParameter("x_kol_jun") != null){
			x_kol_jun = request.getParameter("x_kol_jun");
		}else{
			x_kol_jun = "";
		}

		if (request.getParameter("x_kol_jul") != null){
			x_kol_jul = request.getParameter("x_kol_jul");
		}else{
			x_kol_jul = "";
		}
		
		if (request.getParameter("x_kol_avg") != null){
			x_kol_avg = request.getParameter("x_kol_avg");
		}else{
			x_kol_avg = "";
		}
		
		if (request.getParameter("x_kol_sep") != null){
			x_kol_sep = request.getParameter("x_kol_sep");
		}else{
			x_kol_sep = "";
		}
		
		if (request.getParameter("x_kol_okt") != null){
			x_kol_okt = request.getParameter("x_kol_okt");
		}else{
			x_kol_okt = "";
		}	

		
		if (request.getParameter("x_kol_nov") != null){
			x_kol_nov = request.getParameter("x_kol_nov");
		}else{
			x_kol_nov = "";
		}	
		
		if (request.getParameter("x_kol_dec") != null){
			x_kol_dec = request.getParameter("x_kol_dec");
		}else{
			x_kol_dec = "";
		}		
		
		
		if (request.getParameter("x_zacetek") != null){
			x_zacetek = (String) request.getParameter("x_zacetek");
		}else{
			x_zacetek = "";
		}
		if (request.getParameter("x_uporabnik") != null){
			x_uporabnik = request.getParameter("x_uporabnik");
		}

		// Open record
		String strsql = "SELECT * FROM recikel_embalaznina" + session.getAttribute("leto") + " WHERE 0 = 1";
		//out.println(strsql);
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();


		tmpfld = ((String) x_id_zavezanca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("id_zavezanca");
		}else{
			rs.updateString("id_zavezanca", tmpfld);
		}

		
		tmpfld = ((String) x_id_embalaza);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("id_embalaza");
		}else{
			rs.updateString("id_embalaza", tmpfld);
		}

		
		// Field naslov
		tmpfld = ((String) x_letna_napoved);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("letna_napoved");
		}else{
			rs.updateString("letna_napoved", tmpfld);
		}

		// Field cena
		tmpfld = ((String) x_cena).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena");
		} else {
			rs.updateInt("cena",Integer.parseInt(tmpfld));
		}

		tmpfld = ((String) x_kol_jan).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_jan");
		} else {
			rs.updateInt("kol_jan",Integer.parseInt(tmpfld));
		}

		tmpfld = ((String) x_kol_feb).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_feb");
		} else {
			rs.updateInt("kol_feb",Integer.parseInt(tmpfld));
		}		
		
		tmpfld = ((String) x_kol_mar).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_mar");
		} else {
			rs.updateInt("kol_mar",Integer.parseInt(tmpfld));
		}
		tmpfld = ((String) x_kol_apr).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_apr");
		} else {
			rs.updateInt("kol_apr",Integer.parseInt(tmpfld));
		}
		
		tmpfld = ((String) x_kol_maj).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_maj");
		} else {
			rs.updateInt("kol_maj",Integer.parseInt(tmpfld));
		}
		
		tmpfld = ((String) x_kol_jun).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_jun");
		} else {
			rs.updateInt("kol_jun",Integer.parseInt(tmpfld));
		}
		
		tmpfld = ((String) x_kol_jul).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_jul");
		} else {
			rs.updateInt("kol_jul",Integer.parseInt(tmpfld));
		}
		
		tmpfld = ((String) x_kol_avg).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_avg");
		} else {
			rs.updateInt("kol_avg",Integer.parseInt(tmpfld));
		}
		
		tmpfld = ((String) x_kol_sep).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_sep");
		} else {
			rs.updateInt("kol_sep",Integer.parseInt(tmpfld));
		}
		
		tmpfld = ((String) x_kol_okt).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_okt");
		} else {
			rs.updateInt("kol_okt",Integer.parseInt(tmpfld));
		}

		tmpfld = ((String) x_kol_nov).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_nov");
		} else {
			rs.updateInt("kol_nov",Integer.parseInt(tmpfld));
		}
		
		tmpfld = ((String) x_kol_dec).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_dec");
		} else {
			rs.updateInt("kol_dec",Integer.parseInt(tmpfld));
		}
					
		//Uporabnik
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
		
		try{
			rs.insertRow();
		}
		catch(java.sql.SQLException e){
			System.out.println(e.getMessage());
		}
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("recikelembalazninalist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}


if(request.getParameter("prikaz_naslov")!= null){
	session.setAttribute("recikelembalaznina_naslov",  request.getParameter("prikaz_naslov"));
}


%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: recikel embalažnina<br><br><a href="recikelembalazninalist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>

<form onSubmit="return EW_checkMyForm(this);"  action="recikelembalazninaadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">

	<tr>
		<td class="ewTableHeader">Zavezanec&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_posta_js = "";
String x_postaList = "<select name=\"x_id_zavezanca\"><option value=\"\">Izberi</option>";
String sqlwrk_x_posta = "SELECT id, st_pogodbe, naziv FROM recikel_zavezanci" + session.getAttribute("leto") + " ORDER BY naziv ASC";
Statement stmtwrk_x_posta = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_posta = stmtwrk_x_posta.executeQuery(sqlwrk_x_posta);
	int rowcntwrk_x_posta = 0;
	while (rswrk_x_posta.next()) {
		x_postaList += "<option value=\"" + HTMLEncode(rswrk_x_posta.getString("id")) + "\"";
		if (rswrk_x_posta.getString("id").equals(x_id_zavezanca)) {
			x_postaList += " selected";
		}
		String tmpValue_x_posta = "";
		if (rswrk_x_posta.getString("naziv")!= null) tmpValue_x_posta = rswrk_x_posta.getString("naziv");
		x_postaList += ">" + tmpValue_x_posta
 + "</option>";
		rowcntwrk_x_posta++;
	}
rswrk_x_posta.close();
rswrk_x_posta = null;
stmtwrk_x_posta.close();
stmtwrk_x_posta = null;
x_postaList += "</select>";
out.println(x_postaList);
%>
&nbsp;</td>
	</tr>
	
	<tr>
		<td class="ewTableHeader">Embalaža&nbsp;</td>
		<td class="ewTableAltRow"><%
cbo_x_posta_js = "";
x_postaList = "<select name=\"x_id_embalaza\"><option value=\"\">Izberi</option>";
sqlwrk_x_posta = "SELECT id, tar_st, naziv, porocilo FROM recikel_embalaze" + session.getAttribute("leto") + " ORDER BY naziv ASC";
stmtwrk_x_posta = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
rswrk_x_posta = stmtwrk_x_posta.executeQuery(sqlwrk_x_posta);
	rowcntwrk_x_posta = 0;
	while (rswrk_x_posta.next()) {
		x_postaList += "<option value=\"" + HTMLEncode(rswrk_x_posta.getString("id")) + "\"";
		if (rswrk_x_posta.getString("id").equals(x_id_embalaza)) {
			x_postaList += " selected";
		}
		String tmpValue_x_posta = "";
		if (rswrk_x_posta.getString("naziv")!= null) tmpValue_x_posta = rswrk_x_posta.getString("tar_st") + ", " + rswrk_x_posta.getString("naziv") + ", " + rswrk_x_posta.getString("porocilo");
		x_postaList += ">" + tmpValue_x_posta
 + "</option>";
		rowcntwrk_x_posta++;
	}
rswrk_x_posta.close();
rswrk_x_posta = null;
stmtwrk_x_posta.close();
stmtwrk_x_posta = null;
x_postaList += "</select>";
out.println(x_postaList);
%>
&nbsp;</td>
	</tr>	
		
	<tr>
		<td class="ewTableHeader">Letna napoved&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_letna_napoved" size="30" value="<%= HTMLEncode((String)x_letna_napoved) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena" size="30" value="<%= HTMLEncode((String)x_cena) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol jan&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_jan" size="30" value="<%= HTMLEncode((String)x_kol_jan) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol feb&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_feb" size="30" value="<%= HTMLEncode((String)x_kol_feb) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol mar&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_mar" size="30" value="<%= HTMLEncode((String)x_kol_mar) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol apr&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_apr" size="30" value="<%= HTMLEncode((String)x_kol_apr) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol maj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_maj" size="30" value="<%= HTMLEncode((String)x_kol_maj) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol jun&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_jun" size="30" value="<%= HTMLEncode((String)x_kol_jun) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol jul&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_jul" size="30" value="<%= HTMLEncode((String)x_kol_jul) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol avg&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_avg" size="30" value="<%= HTMLEncode((String)x_kol_avg) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol sep&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_sep" size="30" value="<%= HTMLEncode((String)x_kol_sep) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol okt&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_okt" size="30" value="<%= HTMLEncode((String)x_kol_okt) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol nov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_nov" size="30" value="<%= HTMLEncode((String)x_kol_nov) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol dec&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_dec" size="30" value="<%= HTMLEncode((String)x_kol_dec) %>">&nbsp;</td>
	</tr>
	

</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
