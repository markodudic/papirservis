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

if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
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
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("enotelist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_sif_enote = null;
Object x_naziv = null;
Object x_lokacija = null;
String x_maticna = "";
String x_dejavnost = "";
Object x_dovoljenje = null;
String x_nadenota = "";
String x_arso_prjm_st = "";
String x_arso_prjm_status = "";
String x_arso_aktivnost_prjm = "";
String x_arso_odp_locpr_id = "";
Object x_x_koord = null;
Object x_y_koord = null;
Object x_radij = null;
int x_strosek = 0;
int x_ewc = 0;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `enote` WHERE `sif_enote`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
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
		}else{
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


			if (rs.getString("dovoljenje") != null){
				x_dovoljenje = (String) rs.getString("dovoljenje");
			}else{
				x_dovoljenje = "";
			}
			
			// nadenota
			if (rs.getString("nadenota") != null){
				x_nadenota = rs.getString("nadenota");
			}else{
				x_nadenota = "";
			}

			x_strosek = rs.getInt("strosek_proizvodnja");
			x_ewc = rs.getInt("ewc_kontrola");

			// arso_prjm_st
			if (rs.getString("arso_prjm_st") != null){
				x_arso_prjm_st = rs.getString("arso_prjm_st");
			}else{
				x_arso_prjm_st = "";
			}
		
			// arso_prjm_status
			if (rs.getString("arso_prjm_status") != null){
				x_arso_prjm_status = rs.getString("arso_prjm_status");
			}else{
				x_arso_prjm_status = "";
			}

			
			// arso_aktivnost_prjm
			if (rs.getString("arso_aktivnost_prjm") != null){
				x_arso_aktivnost_prjm = rs.getString("arso_aktivnost_prjm");
			}else{
				x_arso_aktivnost_prjm = "";
			}
		
			// x_arso_odp_locpr_id 
			if (rs.getString("arso_odp_locpr_id") != null){
				x_arso_odp_locpr_id  = rs.getString("arso_odp_locpr_id");
			}else{
				x_arso_odp_locpr_id  = "";
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
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
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

		if (request.getParameter("x_dovoljenje") != null){
			x_dovoljenje = (String) request.getParameter("x_dovoljenje");
		}else{
			x_dovoljenje = "";
		}
		if (request.getParameter("x_nadenota") != null){
			x_nadenota = (String) request.getParameter("x_nadenota");
		}else{
			x_nadenota = "";
		}
		if (request.getParameter("x_strosek") != null){
			x_strosek = Integer.parseInt(request.getParameter("x_strosek"));
		}
		if (request.getParameter("x_ewc") != null){
			x_ewc = Integer.parseInt(request.getParameter("x_ewc"));
		}
		if (request.getParameter("x_arso_prjm_st") != null){
			x_arso_prjm_st = (String) request.getParameter("x_arso_prjm_st");
		}else{
			x_arso_prjm_st = "";
		}
		if (request.getParameter("x_arso_prjm_status") != null){
			x_arso_prjm_status = (String) request.getParameter("x_arso_prjm_status");
		}else{
			x_arso_prjm_status = "";
		}

		if (request.getParameter("x_arso_aktivnost_prjm") != null){
			x_arso_aktivnost_prjm = (String) request.getParameter("x_arso_aktivnost_prjm");
		}else{
			x_arso_aktivnost_prjm = "";
		}
		if (request.getParameter("x_arso_odp_locpr_id") != null){
			x_arso_odp_locpr_id = (String) request.getParameter("x_arso_odp_locpr_id");
		}else{
			x_arso_odp_locpr_id = "";
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
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `enote` WHERE `sif_enote`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
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

		// Field maticna
		tmpfld = ((String) x_maticna);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("maticna");
		}else{
			rs.updateString("maticna", tmpfld);
		}

		// Field dejavnost
		tmpfld = ((String) x_dejavnost);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("dejavnost");
		}else{
			rs.updateString("dejavnost", tmpfld);
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
		
		// Field nadenota
		tmpfld = ((String) x_nadenota);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("nadenota");
		}else{
			rs.updateString("nadenota", tmpfld);
		}
		
		rs.updateInt("strosek_proizvodnja",x_strosek);
		rs.updateInt("ewc_kontrola",x_ewc);

		// Field arso_prjm_st
		tmpfld = ((String) x_arso_prjm_st);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_prjm_st");
		}else{
			rs.updateString("arso_prjm_st", tmpfld);
		}

		// Field arso_prjm_status
		tmpfld = ((String) x_arso_prjm_status);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_prjm_status");
		}else{
			rs.updateString("arso_prjm_status", tmpfld);
		}

		// Field arso_aktivnost_prjm
		tmpfld = ((String) x_arso_aktivnost_prjm);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("arso_aktivnost_prjm");
		}else{
			rs.updateString("arso_aktivnost_prjm", tmpfld);
		}

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

		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("enotelist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : enote<br><br><a href="enotelist.jsp">Nazaj na pregled</a></span></p>
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
<form onSubmit="return EW_checkMyForm(this);"  name="enoteedit" action="enoteedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra enote&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sif_enote" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sif_enote) %>">&nbsp;</td>
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
		<td class="ewTableHeader">Matična&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_maticna" size="12" maxlength="10" value="<%= HTMLEncode((String)x_maticna) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Dejavnost&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dejavnost" size="12" maxlength="10" value="<%= HTMLEncode((String)x_dejavnost) %>">&nbsp;</td>
	</tr>	
	<tr>
		<td class="ewTableHeader">Dovoljenje&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_dovoljenje" size="30" maxlength="255" value="<%= HTMLEncode((String)x_dovoljenje) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Nadenota&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_nadenota">
			<%
			String sqlwrk_x_nadenota = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'enote' AND TABLE_SCHEMA='salomon' AND COLUMN_NAME = 'nadenota'";
			Statement stmtwrk_x_nadenota = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rswrk_x_nadenota = stmtwrk_x_nadenota.executeQuery(sqlwrk_x_nadenota);
				if (rswrk_x_nadenota.next()) {
					String x_nadenota_listEnum = HTMLEncode(rswrk_x_nadenota.getString("COLUMN_TYPE"));
					x_nadenota_listEnum = x_nadenota_listEnum.substring(5, x_nadenota_listEnum.length()-1);
					String[] x_nadenota_list = x_nadenota_listEnum.split(",");
					for (int i=0; i<x_nadenota_list.length; i++) {
						String x_arso_listOption = "<option value=\"" + HTMLEncode(x_nadenota_list[i].replaceAll("'", "")) + "\"";
						if (HTMLEncode(x_nadenota_list[i].replaceAll("'", "")).equals(x_nadenota)) {
							x_arso_listOption += " selected";
						}
						x_arso_listOption += ">" + HTMLEncode(x_nadenota_list[i].replaceAll("'", "")) + "</option>";
						out.println(x_arso_listOption);			
					}
				}
			rswrk_x_nadenota.close();
			rswrk_x_nadenota = null;
			stmtwrk_x_nadenota.close();
			stmtwrk_x_nadenota = null;
			%>
			</select>
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Strosek proizvodnja&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_strosek" <%= x_strosek == 0? "checked" : "" %> value = "0" >NE&nbsp;<input type="radio" name="x_strosek"  <%= x_strosek == 1? "checked" : "" %> value = "1">DA&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">EWC kontrola&nbsp;</td>
		<td class="ewTableAltRow"><input type="radio" name="x_ewc" <%= x_ewc == 0? "checked" : "" %> value = "0" >NE&nbsp;<input type="radio" name="x_ewc"  <%= x_ewc == 1? "checked" : "" %> value = "1">DA&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso št.&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_arso_prjm_st" size="12" maxlength="10" value="<%= HTMLEncode((String)x_arso_prjm_st) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso status&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_prjm_status">
			<%
				String sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'enote' AND COLUMN_NAME = 'arso_prjm_status'";
				Statement stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_prjm_status)) {
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
	<tr>
		<td class="ewTableHeader">Arso postopek ravnanja&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_arso_aktivnost_prjm">
			<%
				String sqlwrk_x_arso_aktivnost = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'enote' AND COLUMN_NAME = 'arso_aktivnost_prjm'";
				Statement stmtwrk_x_arso_aktivnost = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_arso_aktivnost = stmtwrk_x_arso_aktivnost.executeQuery(sqlwrk_x_arso_aktivnost);
					if (rswrk_x_arso_aktivnost.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_aktivnost.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",'");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_arso_aktivnost_prjm)) {
								x_arso_listOption += " selected";
							}
							x_arso_listOption += ">" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "</option>";
							out.println(x_arso_listOption);			
						}
					}
				rswrk_x_arso_aktivnost.close();
				rswrk_x_arso_aktivnost = null;
				stmtwrk_x_arso_aktivnost.close();
				stmtwrk_x_arso_status = null;
			%>
			</select>
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Arso lokacija ravnanja&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_arso_odp_locpr_id" size="12" maxlength="10" value="<%= HTMLEncode((String)x_arso_odp_locpr_id) %>">&nbsp;</td>
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
<input type="submit" name="Action" value="Potrdi">
</form>
<%@ include file="footer.jsp" %>
