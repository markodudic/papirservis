<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="kamionlist.jsp"%>
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
	response.sendRedirect("kamionlist.jsp"); 
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
	response.sendRedirect("kamionlist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_sif_kam = null;
Object x_kamion = null;
Object x_registrska = null;
Object x_cena_km = null;
Object x_cena_ura = null;
Object x_cena_kg = null;
Object x_c_km = null;
Object x_c_ura = null;
Object x_zacetek = null;
Object x_uporabnik = null;
Object x_veljavnost = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kamion` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("kamionlist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("sif_kam") != null){
				x_sif_kam = rs.getString("sif_kam");
			}else{
				x_sif_kam = "";
			}
			if (rs.getString("kamion") != null){
				x_kamion = rs.getString("kamion");
			}else{
				x_kamion = "";
			}

			//Veljavnost	
			if (rs.getTimestamp("veljavnost") != null){
				x_veljavnost = rs.getTimestamp("veljavnost");
			}else{
				x_veljavnost = null;
			}

			// registrska
			if (rs.getString("registrska") != null){
				x_registrska = rs.getString("registrska");
			}else{
				x_registrska = "";
			}
	x_cena_km = String.valueOf(rs.getDouble("cena_km"));
	x_cena_ura = String.valueOf(rs.getDouble("cena_ura"));
	x_cena_kg = String.valueOf(rs.getDouble("cena_kg"));
	x_c_km = String.valueOf(rs.getDouble("c_km"));
	x_c_ura = String.valueOf(rs.getDouble("c_ura"));
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
		if (request.getParameter("x_sif_kam") != null){
			x_sif_kam = (String) request.getParameter("x_sif_kam");
		}else{
			x_sif_kam = "";
		}
		if (request.getParameter("x_kamion") != null){
			x_kamion = (String) request.getParameter("x_kamion");
		}else{
			x_kamion = "";
		}
		if (request.getParameter("x_registrska") != null){
			x_registrska = (String) request.getParameter("x_registrska");
		}else{
			x_registrska = "";
		}
		if (request.getParameter("x_cena_km") != null){
			x_cena_km = (String) request.getParameter("x_cena_km");
		}else{
			x_cena_km = "";
		}
		if (request.getParameter("x_cena_ura") != null){
			x_cena_ura = (String) request.getParameter("x_cena_ura");
		}else{
			x_cena_ura = "";
		}
		if (request.getParameter("x_cena_kg") != null){
			x_cena_kg = (String) request.getParameter("x_cena_kg");
		}else{
			x_cena_kg = "";
		}
		if (request.getParameter("x_c_km") != null){
			x_c_km = (String) request.getParameter("x_c_km");
		}else{
			x_c_km = "";
		}
		if (request.getParameter("x_c_ura") != null){
			x_c_ura = (String) request.getParameter("x_c_ura");
		}else{
			x_c_ura = "";
		}

		if (request.getParameter("x_veljavnost") != null){
			x_veljavnost = (String) request.getParameter("x_veljavnost");
		}else{
			x_veljavnost = "";
		}


		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kamion` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("kamionlist.jsp");
			response.flushBuffer();
			return;
		}

		// Field sif_kam
		tmpfld = ((String) x_sif_kam);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kam");
		}else{
			rs.updateString("sif_kam", tmpfld);
		}

		// Field kamion
		tmpfld = ((String) x_kamion);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("kamion");
		}else{
			rs.updateString("kamion", tmpfld);
		}

		// Field registrska
		tmpfld = ((String) x_registrska);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("registrska");
		}else{
			strsql += "'" + tmpfld + "'," ;
		}
		
		// Field cena_km
		tmpfld = ((String) x_cena_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena_km");
		} else {
			rs.updateDouble("cena_km",Double.parseDouble(tmpfld));
		}

		// Field cena_ura
		tmpfld = ((String) x_cena_ura).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena_ura");
		} else {
			rs.updateDouble("cena_ura",Double.parseDouble(tmpfld));
		}

		// Field cena_kg
/*
		tmpfld = ((String) x_cena_kg).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena_kg");
		} else {
			rs.updateInt("cena_kg",Integer.parseInt(tmpfld));
		}
*/
		// Field c_km
		tmpfld = ((String) x_c_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("c_km");
		} else {
			rs.updateDouble("c_km",Double.parseDouble(tmpfld));
		}

		// Field c_ura
		tmpfld = ((String) x_c_ura).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("c_ura");
		} else {
			rs.updateDouble("c_ura",Double.parseDouble(tmpfld));
		}
		
		// Field veljavnost
		if (IsDate((String) x_veljavnost,"EURODATE", locale)) {
			rs.updateTimestamp("veljavnost", EW_UnFormatDateTime((String)x_veljavnost,"EURODATE", locale));
		}else{
			rs.updateNull("veljavnost");
		}

		//Uporabnik
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
		
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("kamionlist.jsp");
		response.flushBuffer();
		return;
	}
} catch(com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException ex){
		out.println("Ni dovoljeno spreminjanje Šifre kamiona");
}
catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : kamion<br><br><a href="kamionlist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript
function disableSome(EW_this){
}


function  EW_checkMyForm(EW_this) {
if (EW_this.x_sif_kam && !EW_hasValue(EW_this.x_sif_kam, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kam, "TEXT", "Napačan vnos - sif kam"))
                return false; 
        }
if (EW_this.x_cena_km && !EW_checknumber(EW_this.x_cena_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_km, "TEXT", "Napačna številka - cena km"))
            return false; 
        }
if (EW_this.x_cena_ura && !EW_checknumber(EW_this.x_cena_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_ura, "TEXT", "Napačna številka - cena ura"))
            return false; 
        }
/*
if (EW_this.x_cena_kg && !EW_checknumber(EW_this.x_cena_kg.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_kg, "TEXT", "Napačna številka - cena kg"))
            return false; 
        }
*/
if (EW_this.x_c_km && !EW_checknumber(EW_this.x_c_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_km, "TEXT", "Napačna številka - c km"))
            return false; 
        }
if (EW_this.x_sif_kam && !EW_checknumber(EW_this.x_sif_kam.value)) {
        if (!EW_onError(EW_this, EW_this.x_sif_kam, "TEXT", "Napačna šifra kamiona"))
            return false; 
        }
if (EW_this.x_c_ura && !EW_checknumber(EW_this.x_c_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_ura, "TEXT", "Napačna številka - c ura"))
            return false; 
        }
if (EW_this.x_veljavnost && !EW_checkeurodate(EW_this.x_veljavnost.value)) {
        if (!EW_onError(EW_this, EW_this.x_veljavnost, "TEXT", "Napačen datum (dd.mm.yyyy) - veljavnost"))
            return false; 
        }


return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="kamionedit" action="kamionedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra kamiona&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_kam" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sif_kam) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kamion" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kamion) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Registrska&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_registrska" size="30" maxlength="255" value="<%= HTMLEncode((String)x_registrska) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na km&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_km" size="30" value="<%= HTMLEncode((String)x_cena_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na uro&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_ura" size="30" value="<%= HTMLEncode((String)x_cena_ura) %>">&nbsp;</td>
	</tr>
	<!--tr>
		<td class="ewTableHeader">Cena kg&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_kg" size="30" value="<%= HTMLEncode((String)x_cena_kg) %>">&nbsp;</td>
	</tr-->
	<tr>
		<td class="ewTableHeader">c km&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_c_km" size="30" value="<%= HTMLEncode((String)x_c_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">c ura&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_c_ura" size="30" value="<%= HTMLEncode((String)x_c_ura) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Veljavnost&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_veljavnost" value="<%= EW_FormatDateTime(x_veljavnost,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_veljavnost,'dd.mm.yyyy');return false;">&nbsp;</td>
	</tr>

</table>
<p>
<input type="submit" name="Action" value="Potrdi">
</form>
<%@ include file="footer.jsp" %>
