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

if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
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
Object x_sif_enote = null;
Object x_naziv = null;
Object x_lokacija = null;
Object x_dovoljenje = null;
Object x_x_koord = null;
Object x_y_koord = null;
Object x_radij = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `enote` WHERE `sif_enote`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("enotelist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

		// Get the field contents
		x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
		if (rs.getString("naziv") != null){
			x_naziv = rs.getString("naziv");
		}else{
			x_naziv = "";
		}
		if (rs.getString("lokacija") != null){
			x_lokacija = rs.getString("lokacija");
		}else{
			x_lokacija = "";
		}
		
		// dovoljenje
		if (rs.getString("dovoljenje") != null){
			x_dovoljenje = rs.getString("dovoljenje");
		}
		else{
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
		
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_sif_enote") != null){
			x_sif_enote = (String) request.getParameter("x_sif_enote");
		}else{
			x_sif_enote = "";
		}
		if (request.getParameter("x_naziv") != null){
			x_naziv = (String) request.getParameter("x_naziv");
		}else{
			x_naziv = "";
		}
		if (request.getParameter("x_lokacija") != null){
			x_lokacija = (String) request.getParameter("x_lokacija");
		}else{
			x_lokacija = "";
		}

		if (request.getParameter("x_dovoljenje") != null){
			x_dovoljenje = (String) request.getParameter("x_dovoljenje");
		}else{
			x_dovoljenje = "";
		}

		if (request.getParameter("x_x_koord") != null){
			x_x_koord = (String) request.getParameter("x_x_koord");
		}else{
			x_x_koord = "";
		}
		if (request.getParameter("x_y_koord") != null){
			x_y_koord = (String) request.getParameter("x_y_koord");
		}else{
			x_y_koord = "";
		}
		if (request.getParameter("x_radij") != null){
			x_radij = (String) request.getParameter("x_radij");
		}else{
			x_radij = "";
		}

		// Open record
		String strsql = "SELECT * FROM `enote` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field sif_enote
		tmpfld = ((String) x_sif_enote).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("sif_enote");
		} else {
		String srchfld = tmpfld;
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM `enote` WHERE `sif_enote` = " + srchfld;
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				Exception ex = new com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException();
				throw ex;
			}
			rschk.close();
			rschk = null;
			rs.updateInt("sif_enote",Integer.parseInt(tmpfld));
		}

		// Field naziv
		tmpfld = ((String) x_naziv);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("naziv");
		}else{
			rs.updateString("naziv", tmpfld);
		}

		// Field lokacija
		tmpfld = ((String) x_lokacija);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("lokacija");
		}else{
			rs.updateString("lokacija", tmpfld);
		}
		
		// Field ddovoljenje
		tmpfld = ((String) x_dovoljenje);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("dovoljenje");
		}else{
			rs.updateString("dovoljenje", tmpfld);
		}
		
		// Field x
		tmpfld = ((String) x_x_koord);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("x_koord");
		}else{
			rs.updateString("x_koord", tmpfld);
		}

		// Field y
		tmpfld = ((String) x_y_koord);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("y_koord");
		}else{
			rs.updateString("y_koord", tmpfld);
		}

		// Field radij
		tmpfld = ((String) x_radij);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("radij");
		}else{
			rs.updateString("radij", tmpfld);
		}

		
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("enotelist.jsp");
		response.flushBuffer();
		return;
	}
}
catch (com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException ex){
	out.println("Morate spremeniti šifro!!!");
}
catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: enote<br><br><a href="enotelist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript

function disableSome(EW_this){
}


function  EW_checkMyForm(EW_this) {
	if (EW_this.x_sif_enote && !EW_hasValue(EW_this.x_sif_enote, "TEXT" )) {
	            if (!EW_onError(EW_this, EW_this.x_sif_enote, "TEXT", "Napačna številka - sif enote"))
	                return false; 
	        }
	if (EW_this.x_sif_enote && !EW_checkinteger(EW_this.x_sif_enote.value)) {
	        if (!EW_onError(EW_this, EW_this.x_sif_enote, "TEXT", "Napačna številka - sif enote"))
	            return false; 
	        }
	if (EW_this.x_x_koord && !EW_checknumber(EW_this.x_x_koord.value)) {
	        if (!EW_onError(EW_this, EW_this.x_x_koord, "TEXT", "Napačna številka - x koordinata"))
	            return false; 
	        }
	if (EW_this.x_y_koord && !EW_checknumber(EW_this.x_y_koord.value)) {
	        if (!EW_onError(EW_this, EW_this.x_y_koord, "TEXT", "Napačna številka - y koordinata"))
	            return false; 
	        }
	if (EW_this.x_radij && !EW_checkinteger(EW_this.x_radij.value)) {
	        if (!EW_onError(EW_this, EW_this.x_radij, "TEXT", "Napačna številka - radij"))
	            return false; 
	        }
	return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="enoteadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra enote&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_enote" size="30" value="<%= HTMLEncode((String)x_sif_enote) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naziv" size="30" maxlength="255" value="<%= HTMLEncode((String)x_naziv) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Lokacija&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_lokacija" size="30" maxlength="255" value="<%= HTMLEncode((String)x_lokacija) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dovoljenje&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dovoljenje" size="30" maxlength="255" value="<%= HTMLEncode((String)x_dovoljenje) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">X koordinata&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_x_koord" size="30" maxlength="255" value="<%= HTMLEncode((String)x_x_koord) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Y koordinata&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_y_koord" size="30" maxlength="255" value="<%= HTMLEncode((String)x_y_koord) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Radij&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_radij" size="30" maxlength="255" value="<%= HTMLEncode((String)x_radij) %>">&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
