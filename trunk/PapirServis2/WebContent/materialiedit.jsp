<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="materialilist.jsp"%>
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
	response.sendRedirect("materialilist.jsp"); 
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
	response.sendRedirect("materialilist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_koda = null;
Object x_material = null;
Object x_pc_nizka = null;
Object x_str_dv = null;
Object x_sit_sort = null;
Object x_sit_zaup = null;
Object x_sit_smet = null;
Object[] x_ravnanje = {null,null,null,null,null,null,null,null,null};
Object x_prevoz1 = null;
Object x_prevoz2 = null;
Object x_prevoz3 = null;
Object x_prevoz4 = null;
Object x_zacetek = null;
Object x_uporabnik = null;
Object x_veljavnost = null;
String x_arso_odp_locpr_id = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `materiali` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("materialilist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("koda") != null){
				x_koda = rs.getString("koda");
			}else{
				x_koda = "";
			}
			if (rs.getString("material") != null){
				x_material = rs.getString("material");
			}else{
				x_material = "";
			}
	x_pc_nizka = String.valueOf(rs.getDouble("pc_nizka"));
	x_str_dv = String.valueOf(rs.getDouble("str_dv"));
	x_sit_sort = String.valueOf(rs.getDouble("sit_sort"));
	x_sit_zaup = String.valueOf(rs.getDouble("sit_zaup"));
	x_sit_smet = String.valueOf(rs.getDouble("sit_smet"));
	for (int i=1; i<10; i++) {
		x_ravnanje[i-1] = String.valueOf(rs.getDouble("ravnanje"+i));
	}
	x_prevoz1 = String.valueOf(rs.getDouble("prevoz1"));
	x_prevoz2 = String.valueOf(rs.getDouble("prevoz2"));
	x_prevoz3 = String.valueOf(rs.getDouble("prevoz3"));
	x_prevoz4 = String.valueOf(rs.getDouble("prevoz4"));
			//Veljavnost	
			if (rs.getTimestamp("veljavnost") != null){
				x_veljavnost = rs.getTimestamp("veljavnost");
			}else{
				x_veljavnost = null;
			}

			if (rs.getTimestamp("zacetek") != null){
				x_zacetek = rs.getTimestamp("zacetek");
			}else{
				x_zacetek = null;
			}
			x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
			// arso_odp_locpr_id
			if (rs.getString("arso_odp_locpr_id") != null){
				x_arso_odp_locpr_id = rs.getString("arso_odp_locpr_id");
			}else{
				x_arso_odp_locpr_id = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_koda") != null){
			x_koda = (String) request.getParameter("x_koda");
		}else{
			x_koda = "";
		}
		if (request.getParameter("x_material") != null){
			x_material = (String) request.getParameter("x_material");
		}else{
			x_material = "";
		}
		if (request.getParameter("x_pc_nizka") != null){
			x_pc_nizka = (String) request.getParameter("x_pc_nizka");
		}else{
			x_pc_nizka = "";
		}
		if (request.getParameter("x_str_dv") != null){
			x_str_dv = (String) request.getParameter("x_str_dv");
		}else{
			x_str_dv = "";
		}
		if (request.getParameter("x_sit_sort") != null){
			x_sit_sort = (String) request.getParameter("x_sit_sort");
		}else{
			x_sit_sort = "";
		}
		if (request.getParameter("x_sit_zaup") != null){
			x_sit_zaup = (String) request.getParameter("x_sit_zaup");
		}else{
			x_sit_zaup = "";
		}
		if (request.getParameter("x_sit_smet") != null){
			x_sit_smet = (String) request.getParameter("x_sit_smet");
		}else{
			x_sit_smet = "";
		}
		for (int i=1; i<10; i++) {
			if (request.getParameter("x_ravnanje"+i) != null){
				x_ravnanje[i-1] = (String) request.getParameter("x_ravnanje"+i);
			}else{
				x_ravnanje[i-1] = "";
			}
		}
		if (request.getParameter("x_prevoz1") != null){
			x_prevoz1 = (String) request.getParameter("x_prevoz1");
		}else{
			x_prevoz1 = "";
		}
		if (request.getParameter("x_prevoz2") != null){
			x_prevoz2 = (String) request.getParameter("x_prevoz2");
		}else{
			x_prevoz2 = "";
		}
		if (request.getParameter("x_prevoz3") != null){
			x_prevoz3 = (String) request.getParameter("x_prevoz3");
		}else{
			x_prevoz3 = "";
		}
		if (request.getParameter("x_prevoz4") != null){
			x_prevoz4 = (String) request.getParameter("x_prevoz4");
		}else{
			x_prevoz4 = "";
		}

		if (request.getParameter("x_veljavnost") != null){
			x_veljavnost = (String) request.getParameter("x_veljavnost");
		}else{
			x_veljavnost = "";
		}

		if (request.getParameter("x_arso_odp_locpr_id") != null){
			x_arso_odp_locpr_id = (String) request.getParameter("x_arso_odp_locpr_id");
		}else{
			x_arso_odp_locpr_id = "";
		}


		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `materiali` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("materialilist.jsp");
			response.flushBuffer();
			return;
		}

		// Field koda
		tmpfld = ((String) x_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("koda");
		}else{
			rs.updateString("koda", tmpfld);
		}

		// Field material
		tmpfld = ((String) x_material);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("material");
		}else{
			rs.updateString("material", tmpfld);
		}

		// Field pc_nizka
		tmpfld = ((String) x_pc_nizka).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("pc_nizka");
		} else {
			rs.updateDouble("pc_nizka",Double.parseDouble(tmpfld));
		}

		// Field str_dv
		tmpfld = ((String) x_str_dv).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("str_dv");
		} else {
			rs.updateDouble("str_dv",Double.parseDouble(tmpfld));
		}

		// Field sit_sort
		tmpfld = ((String) x_sit_sort).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sit_sort");
		} else {
			rs.updateDouble("sit_sort",Double.parseDouble(tmpfld));
		}

		// Field sit_zaup
		tmpfld = ((String) x_sit_zaup).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sit_zaup");
		} else {
			rs.updateDouble("sit_zaup",Double.parseDouble(tmpfld));
		}

		// Field sit_smet
		tmpfld = ((String) x_sit_smet).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sit_smet");
		} else {
			rs.updateDouble("sit_smet",Double.parseDouble(tmpfld));
		}

		// Field ravnanje
		for (int i=1; i<10; i++) {
			tmpfld = ((String) x_ravnanje[i-1]).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("ravnanje"+i);
			} else {
				rs.updateDouble("ravnanje"+i,Double.parseDouble(tmpfld));
			}
		}

		// Field prevoz1
		tmpfld = ((String) x_prevoz1).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("prevoz1");
		} else {
			rs.updateDouble("prevoz1",Double.parseDouble(tmpfld));
		}

		// Field prevoz2
		tmpfld = ((String) x_prevoz2).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("prevoz2");
		} else {
			rs.updateDouble("prevoz2",Double.parseDouble(tmpfld));
		}

		// Field prevoz3
		tmpfld = ((String) x_prevoz3).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("prevoz3");
		} else {
			rs.updateDouble("prevoz3",Double.parseDouble(tmpfld));
		}

		// Field prevoz4
		tmpfld = ((String) x_prevoz4).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("prevoz4");
		} else {
			rs.updateDouble("prevoz4",Double.parseDouble(tmpfld));
		}
		
		// Field veljavnost
		if (IsDate((String) x_veljavnost,"EURODATE", locale)) {
			rs.updateTimestamp("veljavnost", EW_UnFormatDateTime((String)x_veljavnost,"EURODATE", locale));
		}else{
			rs.updateNull("veljavnost");
		}

		//Uporabnik
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
		
		// Field arso_odp_locpr_id
		tmpfld = ((String) x_arso_odp_locpr_id);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_odp_locpr_id");
		}else{
			rs.updateString("arso_odp_locpr_id", tmpfld);
		}

		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("materialilist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : materiali<br><br><a href="materialilist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_koda && !EW_hasValue(EW_this.x_koda, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_koda, "TEXT", "Napačan vnos - koda"))
                return false; 
        }
if (EW_this.x_pc_nizka && !EW_checknumber(EW_this.x_pc_nizka.value)) {
        if (!EW_onError(EW_this, EW_this.x_pc_nizka, "TEXT", "Napačna številka - pc nizka"))
            return false; 
        }
if (EW_this.x_str_dv && !EW_checknumber(EW_this.x_str_dv.value)) {
        if (!EW_onError(EW_this, EW_this.x_str_dv, "TEXT", "Napačna številka - str dv"))
            return false; 
        }
if (EW_this.x_sit_sort && !EW_checknumber(EW_this.x_sit_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_sort, "TEXT", "Napačna številka - sit sort"))
            return false; 
        }
if (EW_this.x_sit_zaup && !EW_checknumber(EW_this.x_sit_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_zaup, "TEXT", "Napačna številka - sit zaup"))
            return false; 
        }
if (EW_this.x_sit_smet && !EW_checknumber(EW_this.x_sit_smet.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_smet, "TEXT", "Napačna številka - sit smet"))
            return false; 
        }
for (int i=1; i<10; i++) {
if (EW_this.x_ravnanje[i-1] && !EW_checknumber(EW_this.x_ravnanje[i-1].value)) {
        if (!EW_onError(EW_this, EW_this.x_ravnanje[i-1], "TEXT", "Napačna številka - ravnanje "+1))
            return false; 
        }
}
if (EW_this.x_prevoz1 && !EW_checknumber(EW_this.x_prevoz1.value)) {
        if (!EW_onError(EW_this, EW_this.x_prevoz1, "TEXT", "Napačna številka - prevoz 1"))
            return false; 
        }
if (EW_this.x_prevoz2 && !EW_checknumber(EW_this.x_prevoz2.value)) {
        if (!EW_onError(EW_this, EW_this.x_prevoz2, "TEXT", "Napačna številka - prevoz 2"))
            return false; 
        }
if (EW_this.x_prevoz3 && !EW_checknumber(EW_this.x_prevoz3.value)) {
        if (!EW_onError(EW_this, EW_this.x_prevoz3, "TEXT", "Napačna številka - prevoz 3"))
            return false; 
        }
if (EW_this.x_prevoz4 && !EW_checknumber(EW_this.x_prevoz4.value)) {
        if (!EW_onError(EW_this, EW_this.x_prevoz4, "TEXT", "Napačna številka - prevoz 4"))
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
<form onSubmit="return EW_checkMyForm(this);"  name="materialiedit" action="materialiedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" readonly name="x_koda" size="30" maxlength="255" value="<%= HTMLEncode((String)x_koda) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Material&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_material" size="30" maxlength="255" value="<%= HTMLEncode((String)x_material) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">pc nizka&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_pc_nizka" size="30" value="<%= HTMLEncode((String)x_pc_nizka) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">str dv&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_str_dv" size="30" value="<%= HTMLEncode((String)x_str_dv) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit sort&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_sort" size="30" value="<%= HTMLEncode((String)x_sit_sort) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit zaup&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_zaup" size="30" value="<%= HTMLEncode((String)x_sit_zaup) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit smet&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_smet" size="30" value="<%= HTMLEncode((String)x_sit_smet) %>">&nbsp;</td>
	</tr>
<%for (int i=1; i<10; i++) {%>
	<tr>
		<td class="ewTableHeader">Ravnanje&nbsp;<%=i%></td>
		<td class="ewTableAltRow"><input type="text" name="x_ravnanje<%=i%>" size="30" value="<%= HTMLEncode((String)x_ravnanje[i-1]) %>">&nbsp;</td>
	</tr>
<%}%>
	<tr>
		<td class="ewTableHeader">Prevoz 1&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_prevoz1" size="30" value="<%= HTMLEncode((String)x_prevoz1) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz 2&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_prevoz2" size="30" value="<%= HTMLEncode((String)x_prevoz2) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz 3&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_prevoz3" size="30" value="<%= HTMLEncode((String)x_prevoz3) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz 4&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_prevoz4" size="30" value="<%= HTMLEncode((String)x_prevoz4) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Veljavnost&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_veljavnost" value="<%= EW_FormatDateTime(x_veljavnost,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_veljavnost,'dd.mm.yyyy');return false;">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso št.&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_arso_odp_locpr_id" size="12" maxlength="10" value="<%= HTMLEncode((String)x_arso_odp_locpr_id) %>">&nbsp;</td>
	</tr>

</table>
<p>
<input type="submit" name="Action" value="Potrdi">
</form>
<%@ include file="footer.jsp" %>
