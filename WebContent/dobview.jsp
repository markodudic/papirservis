<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"   errorPage="doblist.jsp"%>
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
	response.sendRedirect("doblist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("doblist.jsp");}

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
String x_cena_km = "";
String x_cena_ura = "";
String x_c_km = "";
String x_c_ura = "";
String x_stev_km = "";
String x_stev_ur = "";
String x_stroski = "";
String x_koda = "";
String x_ewc = "";
String x_kolicina = "";
String x_cena = "";
String x_kg_zaup = "";
String x_sit_zaup = "";
String x_kg_sort = "";
String x_sit_sort = "";
String x_sit_smet = "";
String x_skupina = "";
String x_skupina_text = "";
String x_opomba = "";
String x_stev_km_sled = "";
String x_stev_ur_sled = "";
String x_stev_km_norm = "";
String x_stev_ur_norm = "";
Object x_zacetek = null;
String x_uporabnik = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabela") + " dob WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("doblist.jsp");
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

		// cena_km
		x_cena_km = String.valueOf(rs.getDouble("cena_km"));

		// cena_ura
		x_cena_ura = String.valueOf(rs.getDouble("cena_ura"));

		// c_km
		x_c_km = String.valueOf(rs.getDouble("c_km"));

		// c_ura
		x_c_ura = String.valueOf(rs.getDouble("c_ura"));

		// stev_km
		x_stev_km = String.valueOf(rs.getDouble("stev_km"));

		// stev_ur
		x_stev_ur = String.valueOf(rs.getDouble("stev_ur"));

		// stroski
		x_stroski = String.valueOf(rs.getDouble("stroski"));

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

		// cena
		x_cena = String.valueOf(rs.getDouble("cena"));

		// kg_zaup
		x_kg_zaup = String.valueOf(rs.getLong("kg_zaup"));

		// sit_zaup
		x_sit_zaup = String.valueOf(rs.getDouble("sit_zaup"));

		// kg_sort
		x_kg_sort = String.valueOf(rs.getLong("kg_sort"));

		// sit_sort
		x_sit_sort = String.valueOf(rs.getDouble("sit_sort"));

		// sit_smet
		x_sit_smet = String.valueOf(rs.getDouble("sit_smet"));

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

		// stev_km_sled
		x_stev_km_sled = String.valueOf(rs.getDouble("stev_km_sled"));

		// stev_ur_sled
		x_stev_ur_sled = String.valueOf(rs.getDouble("stev_ur_sled"));

		// stev_km_norm
		x_stev_km_norm = String.valueOf(rs.getDouble("stev_km_norm"));

		// stev_ur_norm
		x_stev_ur_norm = String.valueOf(rs.getDouble("stev_ur_norm"));
		
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

<p><span class="jspmaker">Pregled: dobavnice<br><br><a href="doblist.jsp">Nazaj na pregled</a></span></p>
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
/*	Don't show child
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_str` = " + x_sif_str;
	String sqlwrk = "SELECT `sif_str`, `naziv` FROM `stranke`";
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
	*/
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
/*	Don't show child
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_kupca;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`naziv` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `naziv` FROM `kupci`";
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
	*/
		out.print(x_sif_kupca);
	
}
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_sif_sof!=null && ((String)x_sif_sof).length() > 0) {
/*	Don't show child
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_sof;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_sof` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `sif_sof`, `sofer` FROM `sofer`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("sofer"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
	*/
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
/*	Don't show child
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_kam;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_kam` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `sif_kam`, `kamion` FROM `kamion`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("kamion"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
	*/
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
		<td class="ewTableHeader">Cena na km&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_cena_km, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na uro&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_cena_ura, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">c km&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_c_km, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">c ura&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_c_ura, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število kilometrov&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_stev_km, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_stev_ur, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stroški&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_stroski, 4, 1, 1, 1,locale)); %>&nbsp;</td>
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
		<td class="ewTableHeader">Cena&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_cena, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">kg zaup&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kg_zaup); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit zaup&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_sit_zaup, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">kg sort&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_kg_sort); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit sort&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_sit_sort, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit smet&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(EW_FormatNumber("" + x_sit_smet, 4, 1, 1, 1,locale)); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%
if (x_skupina!=null && ((String)x_skupina).length() > 0) {
/*	Don't show child
	String sqlwrk_where = "";
	sqlwrk_where = "`skupina` = " + x_skupina;
	String sqlwrk = "SELECT `skupina` FROM `skup`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("skupina"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
*/
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
	<tr>
		<td class="ewTableHeader">Število kilometrov sledenja&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_stev_km_sled); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur sledenja&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_stev_ur_sled); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število km normativ&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_stev_km_norm); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur normativ&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_stev_ur_norm); %>&nbsp;</td>
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
