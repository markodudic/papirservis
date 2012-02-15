<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="soferlist.jsp"%>
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
	response.sendRedirect("soferlist.jsp"); 
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
Object x_sif_sof = null;
Object x_sofer = null;
Object x_kljuc = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `sofer` WHERE `sif_sof`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("soferlist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	if (rs.getString("sif_sof") != null){
		x_sif_sof = rs.getString("sif_sof");
	}else{
		x_sif_sof = "";
	}
	if (rs.getString("sofer") != null){
		x_sofer = rs.getString("sofer");
	}else{
		x_sofer = "";
	}
	if (rs.getString("kljuc") != null){
		x_kljuc = rs.getString("kljuc");
	}else{
		x_kljuc = "";
	}
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_sif_sof") != null){
			x_sif_sof = (String) request.getParameter("x_sif_sof");
		}else{
			x_sif_sof = "";
		}
		if (request.getParameter("x_sofer") != null){
			x_sofer = (String) request.getParameter("x_sofer");
		}else{
			x_sofer = "";
		}
		if (request.getParameter("x_kljuc") != null){
			x_kljuc = (String) request.getParameter("x_kljuc");
		}else{
			x_kljuc = "";
		}

		// Open record
		String strsql = "SELECT * FROM `sofer` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field sif_sof
		tmpfld = ((String) x_sif_sof);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sif_sof");
		}else{
		String srchfld = "'" + tmpfld + "'";
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM `sofer` WHERE `sif_sof` = '" + srchfld +"'";
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				out.print("Duplicate key for sif_sof, value = " + tmpfld + "<br>");
				out.print("Press [Previous Page] key to continue!");
				return;
			}
			rschk.close();
			rschk = null;
			rs.updateString("sif_sof", tmpfld);
		}

		// Field sofer
		tmpfld = ((String) x_sofer);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sofer");
		}else{
			rs.updateString("sofer", tmpfld);
		}

		// Field kljuc
		tmpfld = ((String) x_kljuc);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("kljuc");
		}else{
			rs.updateString("kljuc", tmpfld);
		}
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("soferlist.jsp");
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
<p><span class="jspmaker">Dodaj v: sofer<br><br><a href="soferlist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_sif_sof && !EW_hasValue(EW_this.x_sif_sof, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_sof, "TEXT", "Napačan vnos - sif sof"))
                return false; 
        }
if (EW_this.x_sofer && !EW_hasValue(EW_this.x_sofer, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_sofer, "TEXT", "Napačan vnos - sofer"))
                return false; 
        }
if (EW_this.x_kljuc && !EW_hasValue(EW_this.x_kljuc, "TEXT" )) {
    if (!EW_onError(EW_this, EW_this.x_kljuc, "TEXT", "Napačan vnos - ključ"))
        return false; 
		}
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="soferadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_sof" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sif_sof) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šofer&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sofer" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sofer) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Ključ&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kljuc" size="30"  maxlength="50" value="<%= HTMLEncode((String)x_kljuc) %>">&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
