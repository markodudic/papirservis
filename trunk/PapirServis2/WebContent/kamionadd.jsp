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

if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("kamionlist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%;
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
Object x_sif_kam = null;
Object x_kamion = null;
Object x_naziv = null;
Object x_naslov = null;
Object x_posta = null;
Object x_kraj = null;
Object x_davcna = null;
String x_maticna = "";
String x_dejavnost = "";
Object x_registrska = null;
Object x_cena_km = "0";
Object x_cena_ura = "0";
Object x_cena_kg = "0";
Object x_c_km = "0";
Object x_c_ura = "0";
Object x_zacetek = null;
Object x_uporabnik = null;
Object x_veljavnost = null;
String x_arso_prvz_st = "";
String x_arso_prvz_status = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kamion` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
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
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}
	if (rs.getString("naslov") != null){
		x_naslov = rs.getString("naslov");
	}else{
		x_naslov = "";
	}
	if (rs.getString("posta") != null){
		x_posta = rs.getString("posta");
	}else{
		x_posta = "";
	}
	if (rs.getString("kraj") != null){
		x_kraj = rs.getString("kraj");
	}else{
		x_kraj = "";
	}
	if (rs.getString("davcna") != null){
		x_davcna = rs.getString("davcna");
	}else{
		x_davcna = "";
	}

	// maticna
	if (rs.getString("maticna") != null){
		x_maticna = rs.getString("maticna");
	}else{
		x_maticna = "";
	}

	// dejavnost
	if (rs.getString("dejavnost") != null){
		x_dejavnost = rs.getString("dejavnost");
	}else{
		x_dejavnost = "";
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
	if (rs.getTimestamp("veljavnost") != null){
		x_veljavnost = rs.getTimestamp("veljavnost");
	}else{
		x_veljavnost = null;
	}
	// arso_prvz_st
	if (rs.getString("arso_prvz_st") != null){
		x_arso_prvz_st = rs.getString("arso_prvz_st");
	}else{
		x_arso_prvz_st = "";
	}

	// arso_prvz_status
	if (rs.getString("arso_prvz_status") != null){
		x_arso_prvz_status = rs.getString("arso_prvz_status");
	}else{
		x_arso_prvz_status = "";
	}

		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

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
		if (request.getParameter("x_naziv") != null){
			x_naziv = (String) request.getParameter("x_naziv");
		}else{
			x_naziv = "";
		}
		if (request.getParameter("x_naslov") != null){
			x_naslov = (String) request.getParameter("x_naslov");
		}else{
			x_naslov = "";
		}
		if (request.getParameter("x_posta") != null){
			x_posta = request.getParameter("x_posta");
		}
		if (request.getParameter("x_kraj") != null){
			x_kraj = (String) request.getParameter("x_kraj");
		}else{
			x_kraj = "";
		}
		if (request.getParameter("x_davcna") != null){
			x_davcna = (String) request.getParameter("x_davcna");
		}else{
			x_davcna = "";
		}
		if (request.getParameter("x_maticna") != null){
			x_maticna = (String) request.getParameter("x_maticna");
		}else{
			x_maticna = "";
		}
		if (request.getParameter("x_dejavnost") != null){
			x_dejavnost = (String) request.getParameter("x_dejavnost");
		}else{
			x_dejavnost = "";
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
		if (request.getParameter("x_zacetek") != null){
			x_zacetek = (String) request.getParameter("x_zacetek");
		}else{
			x_zacetek = "";
		}
		if (request.getParameter("x_uporabnik") != null){
			x_uporabnik = request.getParameter("x_uporabnik");
		}
		if (request.getParameter("x_veljavnost") != null){
			x_veljavnost = (String) request.getParameter("x_veljavnost");
		}else{
			x_veljavnost = "";
		}
		if (request.getParameter("x_arso_prvz_st") != null){
			x_arso_prvz_st = (String) request.getParameter("x_arso_prvz_st");
		}else{
			x_arso_prvz_st = "";
		}
		if (request.getParameter("x_arso_prvz_status") != null){
			x_arso_prvz_status = (String) request.getParameter("x_arso_prvz_status");
		}else{
			x_arso_prvz_status = "";
		}

		// Open record
		//insert into kamion (sif_kam, kamion,cena_km, cena_ura, cena_kg, c_km,c_ura, zacetek, uporabnik) values('wow!','wow!wow', 5,3022,4343,6,7, '07-09-07',1)
		String strsql = "insert into kamion (sif_kam, kamion, naziv, naslov, posta, kraj, davcna, maticna, dejavnost, registrska, cena_km, cena_ura, cena_kg, c_km, c_ura, veljavnost, arso_prvz_st, arso_prvz_status, uporabnik) values(";


		// Field sif_kam
		tmpfld = ((String) x_sif_kam);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kam");
		}else{
		String srchfld = "'" + tmpfld + "'";
			srchfld = srchfld.replaceAll("'","\\\\'");
			String selectSql = "SELECT * FROM `kamion` WHERE `sif_kam` = '" + srchfld +"'";
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(selectSql);
			if (rschk.next()) {
				out.print("Duplicate key for sif_kam, value = " + tmpfld + "<br>");
				out.print("Press [Previous Page] key to continue!");
				return;
			}
			rschk.close();
			rschk = null;
			
			strsql += "'" + tmpfld + "'," ;
		}

		// Field kamion
		tmpfld = ((String) x_kamion);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("kamion");
		}else{
			strsql += "'" + tmpfld + "'," ;
		}

		// Field naziv
		tmpfld = ((String) x_naziv);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			strsql += tmpfld + ",";
		}else{
			strsql += "'" + tmpfld + "',";
		}

		// Field naslov
		tmpfld = ((String) x_naslov);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			strsql += tmpfld + ",";
		}else{
			strsql += "'" + tmpfld + "',";
		}

		// Field posta
		tmpfld = ((String) x_posta);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			strsql += tmpfld + ",";
		}else{
			strsql += "'" + tmpfld + "',";
		}

		// Field kraj
		tmpfld = ((String) x_kraj);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			strsql += tmpfld + ",";
		}else{
			strsql += "'" + tmpfld + "',";
		}

		// Field davcna
		tmpfld = ((String) x_davcna);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			strsql += tmpfld + ",";
		}else{
			strsql += "'" + tmpfld + "',";
		}

		// Field maticna
		tmpfld = ((String) x_maticna);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			strsql += tmpfld + ",";
		}else{
			strsql += "'" + tmpfld + "',";
		}

		// Field dejavnost
		tmpfld = ((String) x_dejavnost);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			strsql += tmpfld + ",";
		}else{
			strsql += "'" + tmpfld + "',";
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
			strsql += tmpfld + "," ;
		}

		// Field cena_ura
		tmpfld = ((String) x_cena_ura).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena_ura");
		} else {
			strsql += tmpfld + "," ;
		}


			strsql += "0," ;


		// Field c_km
		tmpfld = ((String) x_c_km).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("c_km");
		} else {
			strsql += tmpfld + "," ;
		}

		// Field c_ura
		tmpfld = ((String) x_c_ura).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + "," ;

		// Field veljavnost
		if (!IsDate((String) x_veljavnost,"EURODATE", locale)) {
			rs.updateTimestamp("veljavnost", EW_UnFormatDateTime((String)x_veljavnost,"EURODATE", locale));
		}else{
			strsql += "'" + EW_UnFormatDateTime((String)x_veljavnost,"EURODATE", locale) + "'," ;
		}

		// Field arso_prvz_st
		tmpfld = ((String) x_arso_prvz_st);
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		strsql += tmpfld + "," ;

		// Field arso_prvz_status
		tmpfld = ((String) x_arso_prvz_status);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			strsql += tmpfld + ",";
		}else{
			strsql += "'" + tmpfld + "',";
		}


////BUDŽENJE
strsql += (String) session.getAttribute("papirservis1_status_UserID") + ")";

//out.println(strsql);
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		out.clear();

		response.sendRedirect("kamionlist.jsp");
		response.flushBuffer();
		return;
		
				
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: kamion<br><br><a href="kamionlist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
	if (EW_this.x_sif_kam && !EW_hasValue(EW_this.x_sif_kam, "TEXT" )) {
        if (!EW_onError(EW_this, EW_this.x_sif_kam, "TEXT", "Napačan vnos - sif kam"))
            return false; 
        }
	if (EW_this.x_kamion && !EW_hasValue(EW_this.x_kamion, "TEXT" )) {
        if (!EW_onError(EW_this, EW_this.x_kamion, "TEXT", "Napačan vnos - kamion"))
            return false; 
        } 
   	if (EW_this.x_registrska && !EW_hasValue(EW_this.x_registrska, "TEXT" )) {
        if (!EW_onError(EW_this, EW_this.x_registrska, "TEXT", "Napačan vnos - registrska"))
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
	if (EW_this.x_c_km && !EW_checknumber(EW_this.x_c_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_km, "TEXT", "Napačna številka - c km"))
            return false; 
        }
	if (EW_this.x_c_ura && !EW_checknumber(EW_this.x_c_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_ura, "TEXT", "Napačna številka - c ura"))
            return false; 
        }
	if (EW_this.x_veljavnost && !EW_hasValue(EW_this.x_veljavnost, "TEXT" ) ) {
        if (!EW_onError(EW_this, EW_this.x_veljavnost, "TEXT", "Napačen datum (dd.mm.yyyy) - veljavnost"))
            return false; 
        }
return true;
}

</script>
<form onSubmit="return EW_checkMyForm(this);"  action="kamionadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
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
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naziv" size="30" maxlength="255" value="<%= HTMLEncode((String)x_naziv) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naslov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naslov" size="30" maxlength="255" value="<%= HTMLEncode((String)x_naslov) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pošta&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_posta_js = "";
String x_postaList = "<select name=\"x_posta\"><option value=\"\">Izberi</option>";
String sqlwrk_x_posta = "SELECT `posta`, `kraj` FROM `poste`" + " ORDER BY `kraj` ASC";
Statement stmtwrk_x_posta = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_posta = stmtwrk_x_posta.executeQuery(sqlwrk_x_posta);
	int rowcntwrk_x_posta = 0;
	while (rswrk_x_posta.next()) {
		x_postaList += "<option value=\"" + HTMLEncode(rswrk_x_posta.getString("posta")) + "\"";
		if (rswrk_x_posta.getString("posta").equals(x_posta)) {
			x_postaList += " selected";
		}
		String tmpValue_x_posta = "";
		if (rswrk_x_posta.getString("kraj")!= null) tmpValue_x_posta = rswrk_x_posta.getString("kraj");
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
		<td class="ewTableHeader">Kraj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kraj" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kraj) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Davčna&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_davcna" size="12" maxlength="10" value="<%= HTMLEncode((String)x_davcna) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Matična&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_maticna" size="12" maxlength="10" value="<%= HTMLEncode((String)x_maticna) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejavnost&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dejavnost" size="12" maxlength="10" value="<%= HTMLEncode((String)x_dejavnost) %>">&nbsp;</td>
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
	<tr>
		<td class="ewTableHeader">Arso št.&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_arso_prvz_st" size="12" maxlength="10" value="<%= HTMLEncode((String)x_arso_prvz_st) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso status&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_prvz_status">
			<%
				String sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'kamion' AND COLUMN_NAME = 'arso_prvz_status'";
				Statement stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_prvz_status)) {
								x_arso_listOption += " selected";
							}
							x_arso_listOption += ">" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "</option>";
							out.println(x_arso_listOption);			
						}
					}
				rswrk_x_arso_status.close();
				rswrk_x_arso_status = null;
				stmtwrk_x_arso_status.close();
				stmtwrk_x_arso_status = null;
			%>
			</select>
		</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
