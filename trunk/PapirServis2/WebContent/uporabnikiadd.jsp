<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="uporabnikilist.jsp"%>
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

if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("uporabnikilist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<% String userid = (String) session.getAttribute("papirservis1_status_UserID"); 
Integer userlevel = (Integer) session.getAttribute("papirservis1_status_UserLevel"); 
if (userid == null && userlevel != null && (userlevel.intValue() != -1) ) {	response.sendRedirect("login.jsp");
	response.flushBuffer(); 
	return; 
}%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("UTF-8");
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
Object x_sif_upor = null;
Object x_ime_in_priimek = null;
Object x_uporabnisko_ime = null;
Object x_geslo = null;
Object x_email = null;
Object x_tip = null;
Object x_sif_enote = null;
Object x_sif_kupca = null;
Object x_meni = null;
boolean x_aktiven = false;
boolean x_porocila = false;
Object x_narocila = null;
boolean x_narocila_potrjevanje = false;
boolean x_arso = false;
boolean x_arso_popravljanje = false;
boolean x_vse = false;
boolean x_enote = false;
StringBuffer x_sif_kupcaList = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `uporabniki` WHERE `sif_upor`=" + tkey;
		Integer userLevel = (Integer) session.getAttribute("papirservis1_status_UserLevel");
/*
    	if (userLevel != null && userLevel.intValue() != -1) { // Non system admin
			rs.updateString("sif_upor", (String) session.getAttribute("papirservis1_status_UserID"));
		}
*/
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("uporabnikilist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_sif_upor = String.valueOf(rs.getLong("sif_upor"));
	if (rs.getString("ime_in_priimek") != null){
		x_ime_in_priimek = rs.getString("ime_in_priimek");
	}else{
		x_ime_in_priimek = "";
	}
	if (rs.getString("uporabnisko_ime") != null){
		x_uporabnisko_ime = rs.getString("uporabnisko_ime");
	}else{
		x_uporabnisko_ime = "";
	}
	if (rs.getString("geslo") != null){
		x_geslo = rs.getString("geslo");
	}else{
		x_geslo = "";
	}
	if (rs.getString("email") != null){
		x_email = rs.getString("email");
	}else{
		x_email = "";
	}
	if (rs.getString("tip") != null){
		x_tip = rs.getString("tip");
	}else{
		x_tip = "";
	}

	if (rs.getString("meni") != null){
		x_meni = rs.getString("meni");
	}else{
		x_meni = "";
	}

	x_aktiven = rs.getBoolean("aktiven");
	x_porocila = rs.getBoolean("porocila");
	if (rs.getString("narocila") != null){
		x_narocila = rs.getString("narocila");
	}else{
		x_narocila = "";
	}
	x_narocila_potrjevanje = rs.getBoolean("narocila_potrjevanje");
	x_arso = rs.getBoolean("arso");
	x_arso_popravljanje = rs.getBoolean("arso_popravljanje");
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
	x_sif_kupca = String.valueOf(rs.getLong("sif_kupca"));

		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add
		// Get fields from form
		if (request.getParameter("x_sif_upor") != null){
			x_sif_upor = request.getParameter("x_sif_upor");
		}
		if (request.getParameter("x_ime_in_priimek") != null){
			x_ime_in_priimek = (String) request.getParameter("x_ime_in_priimek");
		}else{
			x_ime_in_priimek = "";
		}
		if (request.getParameter("x_uporabnisko_ime") != null){
			x_uporabnisko_ime = (String) request.getParameter("x_uporabnisko_ime");
		}else{
			x_uporabnisko_ime = "";
		}
		if (request.getParameter("x_geslo") != null){
			x_geslo = (String) request.getParameter("x_geslo");
		}else{
			x_geslo = "";
		}
		if (request.getParameter("x_email") != null){
			x_email = (String) request.getParameter("x_email");
		}else{
			x_email = "";
		}


		int pravice = 0;		
		
		if (request.getParameter("x_tip5") != null){
			pravice++;
		}

		pravice <<= 1;

		if (request.getParameter("x_tip4") != null){
			pravice++;
		}
		pravice <<= 1;

		if (request.getParameter("x_tip3") != null){
			pravice++;
		}
		pravice <<= 1;

		if (request.getParameter("x_tip2") != null){
			pravice++;
		}
		pravice <<= 1;

		if (request.getParameter("x_tip1") != null){
			pravice++;
		}

		x_tip = "" + pravice;


		int meni = 0;		
		
		if (request.getParameter("x_meni5") != null){
			meni++;
		}

		meni<<= 1;

		if (request.getParameter("x_meni4") != null){
			meni++;
		}
		meni<<= 1;

		if (request.getParameter("x_meni3") != null){
			meni++;
		}
		meni <<= 1;

		if (request.getParameter("x_meni2") != null){
			meni++;
		}
		meni <<= 1;

		if (request.getParameter("x_meni1") != null){
			meni++;
		}

		x_meni = "" + meni;


		if (request.getParameter("x_aktiven") != null){
			x_aktiven = true;
		}
		if (request.getParameter("x_porocila") != null){
			x_porocila = true;
		}
		if (request.getParameter("x_narocila") != null){
			x_narocila = request.getParameter("x_narocila");
		}
		if (request.getParameter("x_narocila_potrjevanje") != null){
			x_narocila_potrjevanje = true;
		}
		if (request.getParameter("x_arso") != null){
			x_arso = true;
		}
		if (request.getParameter("x_arso_popravljanje") != null){
			x_arso_popravljanje = true;
		}

		if (request.getParameter("x_vse") != null){
			x_vse = true;
		}
		if (request.getParameter("x_enote") != null){
			x_enote = true;
		}

		if (request.getParameter("x_sif_enote") != null){
			x_sif_enote = request.getParameter("x_sif_enote");
		}
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = request.getParameter("x_sif_kupca");
		}
		// Open record
		String strsql = "SELECT * FROM `uporabniki` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field ime_in_priimek
		tmpfld = ((String) x_ime_in_priimek);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("ime_in_priimek");
		}else{
			rs.updateString("ime_in_priimek", tmpfld);
		}

		// Field uporabnisko_ime
		tmpfld = ((String) x_uporabnisko_ime);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("uporabnisko_ime");
		}else{
			rs.updateString("uporabnisko_ime", tmpfld);
		}

		// Field geslo
		tmpfld = ((String) x_geslo);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("geslo");
		}else{
			rs.updateString("geslo", tmpfld);
		}

		// Field email
		tmpfld = ((String) x_email);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("email");
		}else{
			rs.updateString("email", tmpfld);
		}

		// Field tip
		tmpfld = ((String) x_tip);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("tip");
		}else{
			rs.updateString("tip", tmpfld);
		}


		// Field meni
		tmpfld = ((String) x_meni);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("meni");
		}else{
			rs.updateString("meni", tmpfld);
		}


		rs.updateBoolean("aktiven",x_aktiven);
		rs.updateBoolean("porocila",x_porocila);
		// Field tip
		tmpfld = ((String) x_narocila);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("narocila");
		}else{
			rs.updateString("narocila", tmpfld);
		}
		rs.updateBoolean("narocila_potrjevanje",x_narocila_potrjevanje);
		rs.updateBoolean("arso",x_arso);
		rs.updateBoolean("arso_popravljanje",x_arso_popravljanje);
		rs.updateBoolean("vse",x_vse);
		rs.updateBoolean("enote",x_enote);

		// Field sif_enote
		tmpfld = ((String) x_sif_enote).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sif_enote");
		} else {
			rs.updateInt("sif_enote",Integer.parseInt(tmpfld));
		}

		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sif_kupca");
		} else {
			rs.updateInt("sif_kupca",Integer.parseInt(tmpfld));
		}

		Integer userLevel = (Integer) session.getAttribute("papirservis1_status_UserLevel");
/*
		if (userLevel != null && userLevel.intValue() != -1) { // Non system admin
				rs.updateString("sif_upor", ((String) session.getAttribute("papirservis1_status_UserID")));
		}
*/		
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("uporabnikilist.jsp");
		response.flushBuffer();
		return;
	}
	
	
	String cbo_x_sif_kupca_js = "";
	x_sif_kupcaList = new StringBuffer("<select name=\"x_sif_kupca\"><option value=\"\">Izberi</option>");
	String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv` FROM `kupci` ORDER BY `naziv` ASC";
	Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
		int rowcntwrk_x_sif_kupca = 0;
		while (rswrk_x_sif_kupca.next()) {
			x_sif_kupcaList.append("<option value=\"" + HTMLEncode(rswrk_x_sif_kupca.getString("sif_kupca")) + "\"");
			if (rswrk_x_sif_kupca.getString("sif_kupca").equals(x_sif_kupca)) {
				x_sif_kupcaList.append(" selected");
			}
			String tmpValue_x_sif_kupca = "";
			if (rswrk_x_sif_kupca.getString("naziv")!= null) tmpValue_x_sif_kupca = rswrk_x_sif_kupca.getString("naziv");
			x_sif_kupcaList.append(">" + tmpValue_x_sif_kupca + "</option>");
			rowcntwrk_x_sif_kupca++;
		}
	rswrk_x_sif_kupca.close();
	rswrk_x_sif_kupca = null;
	stmtwrk_x_sif_kupca.close();
	stmtwrk_x_sif_kupca = null;
	x_sif_kupcaList.append("</select>");
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: uporabniki<br><br><a href="uporabnikilist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function disableSome(EW_this){
}


function  EW_checkMyForm(EW_this) {
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="uporabnikiadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">ime in priimek&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_ime_in_priimek" size="30" maxlength="255" value="<%= HTMLEncode((String)x_ime_in_priimek) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">uporabnisko ime&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_uporabnisko_ime" size="30" maxlength="255" value="<%= HTMLEncode((String)x_uporabnisko_ime) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">geslo&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_geslo" size="30" maxlength="255" value="<%= HTMLEncode((String)x_geslo) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">email&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_email" size="30" maxlength="255" value="<%= HTMLEncode((String)x_email) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">tip&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="checkbox" name="x_tip1"  value="<%= x_tip != null && (Integer.parseInt(x_tip.toString()) & 1) > 0 ? "checked" : "" %>">dodaj&nbsp;
			<input type="checkbox" name="x_tip2"  value="<%= x_tip != null && (Integer.parseInt(x_tip.toString()) & 2) > 0 ? "checked" : "" %>">brisanje&nbsp;
			<input type="checkbox" name="x_tip3"  value="<%= x_tip != null && (Integer.parseInt(x_tip.toString()) & 4) > 0 ? "checked" : "" %>">popravki&nbsp;
			<input type="checkbox" name="x_tip4"  value="<%= x_tip != null && (Integer.parseInt(x_tip.toString()) & 8) > 0 ? "checked" : "" %>">vpogled&nbsp;
			<input type="checkbox" name="x_tip5"  value="<%= x_tip != null && (Integer.parseInt(x_tip.toString()) & 16) > 0 ? "checked" : "" %>">administracia&nbsp;
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">meniji&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="checkbox" name="x_meni1"  value="<%= x_meni != null && (Integer.parseInt(x_meni.toString()) & 1) > 0 ? "checked" : "" %>">šifranti&nbsp;
			<input type="checkbox" name="x_meni2"  value="<%= x_meni != null && (Integer.parseInt(x_meni.toString()) & 2) > 0 ? "checked" : "" %>">odvoz&nbsp;
			<input type="checkbox" name="x_meni3"  value="<%= x_meni != null && (Integer.parseInt(x_meni.toString()) & 4) > 0 ? "checked" : "" %>">prodaja&nbsp;
			<input type="checkbox" name="x_meni4"  value="<%= x_meni != null && (Integer.parseInt(x_meni.toString()) & 8) > 0 ? "checked" : "" %>">obračuni&nbsp;
			<input type="checkbox" name="x_meni5"  value="<%= x_meni != null && (Integer.parseInt(x_meni.toString()) & 16) > 0 ? "checked" : "" %>">kalkulacije&nbsp;
	</tr>
	<tr>
		<td class="ewTableHeader">aktiven&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_aktiven"  <%= x_aktiven ? "checked" : "" %>></td>
	</tr>
	<tr>
		<td class="ewTableHeader">poročila&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_porocila"  <%= x_porocila? "checked" : "" %>></td>
	</tr>
	<tr>
		<td class="ewTableHeader">naročila&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="x_narocila" value="0" checked>Ni dostopa
    		<INPUT type="radio" name="x_narocila" value="1">Kupec
    		<INPUT type="radio" name="x_narocila" value="2">Zaposlen
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">naročila&nbsp;potrjevanje&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_narocila_potrjevanje"  <%= x_narocila_potrjevanje? "checked" : "" %>></td>
	</tr>
	<tr>
		<td class="ewTableHeader">arso&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_arso"  <%= x_arso? "checked" : "" %>></td>
	</tr>
	<tr>
		<td class="ewTableHeader">arso&nbsp;popravljanje</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_arso_popravljanje"  <%= x_arso_popravljanje? "checked" : "" %>></td>
	</tr>
	<tr>
		<td class="ewTableHeader">vse&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_vse"  <%= x_vse ? "checked" : "" %>></td>
	</tr>
	<tr>
		<td class="ewTableHeader">enote&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_enote"  <%= x_enote ? "checked" : "" %>></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra enote&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_sif_enote_js = "";
String x_sif_enoteList = "<select name=\"x_sif_enote\"><option value=\"\">Izberi</option>";
String sqlwrk_x_sif_enote = "SELECT `sif_enote`, `naziv` FROM `enote` ORDER BY `naziv` ASC";
Statement stmtwrk_x_sif_enote = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_enote = stmtwrk_x_sif_enote.executeQuery(sqlwrk_x_sif_enote);
	int rowcntwrk_x_sif_enote = 0;
	while (rswrk_x_sif_enote.next()) {
		x_sif_enoteList += "<option value=\"" + HTMLEncode(rswrk_x_sif_enote.getString("sif_enote")) + "\"";
		if (rswrk_x_sif_enote.getString("sif_enote").equals(x_sif_enote)) {
			x_sif_enoteList += " selected";
		}
		String tmpValue_x_sif_enote = "";
		if (rswrk_x_sif_enote.getString("naziv")!= null) tmpValue_x_sif_enote = rswrk_x_sif_enote.getString("naziv");
		x_sif_enoteList += ">" + tmpValue_x_sif_enote
 + "</option>";
		rowcntwrk_x_sif_enote++;
	}
rswrk_x_sif_enote.close();
rswrk_x_sif_enote = null;
stmtwrk_x_sif_enote.close();
stmtwrk_x_sif_enote = null;
x_sif_enoteList += "</select>";
out.println(x_sif_enoteList);
%>
&nbsp;</td>
	</tr>	
	
	<tr>
		<td class="ewTableHeader">Podjetje&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%>&nbsp;</td>
	</tr>	



	
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
