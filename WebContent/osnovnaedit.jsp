<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="osnovnalist.jsp"%>
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

if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("osnovnalist.jsp"); 
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
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("osnovnalist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_sif_os = null;
Object x_osnovna = null;
Object x_cena_am = null;
Object x_kol_sk = null;
Object x_kol_mb = null;
Object x_kol_nm = null;
Object x_kol_dv = null;
Object x_zacetek = null;
Object x_uporabnik = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `osnovna` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("osnovnalist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("sif_os") != null){
				x_sif_os = rs.getString("sif_os");
			}else{
				x_sif_os = "";
			}
			if (rs.getString("osnovna") != null){
				x_osnovna = rs.getString("osnovna");
			}else{
				x_osnovna = "";
			}
	x_cena_am = String.valueOf(rs.getDouble("cena_am"));
	x_kol_sk = String.valueOf(rs.getLong("kol_sk"));
	x_kol_mb = String.valueOf(rs.getLong("kol_mb"));
	x_kol_nm = String.valueOf(rs.getLong("kol_nm"));
	x_kol_dv = String.valueOf(rs.getLong("kol_dv"));
			if (rs.getTimestamp("zacetek") != null){
				x_zacetek = rs.getTimestamp("zacetek");
			}else{
				x_zacetek = null;
			}
	x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_sif_os") != null){
			x_sif_os = (String) request.getParameter("x_sif_os");
		}else{
			x_sif_os = "";
		}
		if (request.getParameter("x_osnovna") != null){
			x_osnovna = (String) request.getParameter("x_osnovna");
		}else{
			x_osnovna = "";
		}
		if (request.getParameter("x_cena_am") != null){
			x_cena_am = (String) request.getParameter("x_cena_am");
		}else{
			x_cena_am = "";
		}
		if (request.getParameter("x_kol_sk") != null){
			x_kol_sk = (String) request.getParameter("x_kol_sk");
		}else{
			x_kol_sk = "";
		}
		if (request.getParameter("x_kol_mb") != null){
			x_kol_mb = (String) request.getParameter("x_kol_mb");
		}else{
			x_kol_mb = "";
		}
		if (request.getParameter("x_kol_nm") != null){
			x_kol_nm = (String) request.getParameter("x_kol_nm");
		}else{
			x_kol_nm = "";
		}
		if (request.getParameter("x_kol_dv") != null){
			x_kol_dv = (String) request.getParameter("x_kol_dv");
		}else{
			x_kol_dv = "";
		}

		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `osnovna` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("osnovnalist.jsp");
			response.flushBuffer();
			return;
		}

		// Field sif_os
		tmpfld = ((String) x_sif_os);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sif_os");
		}else{
			rs.updateString("sif_os", tmpfld);
		}

		// Field osnovna
		tmpfld = ((String) x_osnovna);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("osnovna");
		}else{
			rs.updateString("osnovna", tmpfld);
		}

		// Field cena_am
		tmpfld = ((String) x_cena_am).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("cena_am");
		} else {
			rs.updateDouble("cena_am",Double.parseDouble(tmpfld));
		}

		// Field kol_sk
		tmpfld = ((String) x_kol_sk).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("kol_sk");
		} else {
			rs.updateInt("kol_sk",Integer.parseInt(tmpfld));
		}

		// Field kol_mb
		tmpfld = ((String) x_kol_mb).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("kol_mb");
		} else {
			rs.updateInt("kol_mb",Integer.parseInt(tmpfld));
		}

		// Field kol_nm
		tmpfld = ((String) x_kol_nm).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("kol_nm");
		} else {
			rs.updateInt("kol_nm",Integer.parseInt(tmpfld));
		}

		// Field kol_dv
		tmpfld = ((String) x_kol_dv).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("kol_dv");
		} else {
			rs.updateInt("kol_dv",Integer.parseInt(tmpfld));
		}
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("osnovnalist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : osnovna<br><br><a href="osnovnalist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript
function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_sif_os && !EW_hasValue(EW_this.x_sif_os, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_os, "TEXT", "Napačan vnos - Šifra osebe"))
                return false; 
        }
if (EW_this.x_osnovna && !EW_hasValue(EW_this.x_osnovna, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_osnovna, "TEXT", "Napačan vnos - osnovna"))
                return false; 
        }
if (EW_this.x_cena_am && !EW_hasValue(EW_this.x_cena_am, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_cena_am, "TEXT", "Napačna številka - cena am"))
                return false; 
        }
if (EW_this.x_cena_am && !EW_checknumber(EW_this.x_cena_am.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_am, "TEXT", "Napačna številka - cena am"))
            return false; 
        }
if (EW_this.x_kol_sk && !EW_hasValue(EW_this.x_kol_sk, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_kol_sk, "TEXT", "Napačna številka - kol sk"))
                return false; 
        }
if (EW_this.x_kol_sk && !EW_checkinteger(EW_this.x_kol_sk.value)) {
        if (!EW_onError(EW_this, EW_this.x_kol_sk, "TEXT", "Napačna številka - kol sk"))
            return false; 
        }
if (EW_this.x_kol_mb && !EW_hasValue(EW_this.x_kol_mb, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_kol_mb, "TEXT", "Napačna številka - kol mb"))
                return false; 
        }
if (EW_this.x_kol_mb && !EW_checkinteger(EW_this.x_kol_mb.value)) {
        if (!EW_onError(EW_this, EW_this.x_kol_mb, "TEXT", "Napačna številka - kol mb"))
            return false; 
        }
if (EW_this.x_kol_nm && !EW_hasValue(EW_this.x_kol_nm, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_kol_nm, "TEXT", "Napačna številka - kol nm"))
                return false; 
        }
if (EW_this.x_kol_nm && !EW_checkinteger(EW_this.x_kol_nm.value)) {
        if (!EW_onError(EW_this, EW_this.x_kol_nm, "TEXT", "Napačna številka - kol nm"))
            return false; 
        }
if (EW_this.x_kol_dv && !EW_hasValue(EW_this.x_kol_dv, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_kol_dv, "TEXT", "Napačna številka - kol dv"))
                return false; 
        }
if (EW_this.x_kol_dv && !EW_checkinteger(EW_this.x_kol_dv.value)) {
        if (!EW_onError(EW_this, EW_this.x_kol_dv, "TEXT", "Napačna številka - kol dv"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="osnovnaedit" action="osnovnaedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra osnove&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_os" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sif_os) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Osnovna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_osnovna" size="30" maxlength="255" value="<%= HTMLEncode((String)x_osnovna) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena am&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_am" size="30" value="<%= HTMLEncode((String)x_cena_am) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol sk&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_sk" size="30" value="<%= HTMLEncode((String)x_kol_sk) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol mb&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_mb" size="30" value="<%= HTMLEncode((String)x_kol_mb) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol nm&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_nm" size="30" value="<%= HTMLEncode((String)x_kol_nm) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kol dv&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_dv" size="30" value="<%= HTMLEncode((String)x_kol_dv) %>">&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Potrdi">
</form>
<%@ include file="footer.jsp" %>
