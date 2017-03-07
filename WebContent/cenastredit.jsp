<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="cenastrlist.jsp"%>
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
if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("cenastrlist.jsp"); 
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
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("cenastrlist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_sif_kupca = null;
Object x_skupina = null;
Object x_material_koda = null;
Object x_cena = null;
Object x_zacetek = null;
Object x_veljavnost = null;
Object x_uporabnik = null;
StringBuffer x_skupinaList = null;
StringBuffer x_sif_kupcaList = null;
StringBuffer x_material_kodaList = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `cenastr` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("cenastrlist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("sif_kupca") != null){
				x_sif_kupca = rs.getString("sif_kupca");
			}else{
				x_sif_kupca = "";
			}
			if (rs.getString("material_koda") != null){
				x_material_koda = rs.getString("material_koda");
			}else{
				x_material_koda = "";
			}
			if (rs.getString("skupina") != null){
				x_skupina = rs.getString("skupina");
			}else{
				x_skupina = "";
			}

			//Veljavnost	
			if (rs.getTimestamp("veljavnost") != null){
				x_veljavnost = rs.getTimestamp("veljavnost");
			}else{
				x_veljavnost = null;
			}

			x_cena = String.valueOf(rs.getDouble("cena"));
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
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = request.getParameter("x_sif_kupca");
		}
		if (request.getParameter("x_material_koda") != null){
			x_material_koda = request.getParameter("x_material_koda");
		}
		if (request.getParameter("x_skupina") != null){
			x_skupina = request.getParameter("x_skupina");
		}
		if (request.getParameter("x_cena") != null){
			x_cena = (String) request.getParameter("x_cena");
		}else{
			x_cena = "";
		}

		if (request.getParameter("x_veljavnost") != null){
			x_veljavnost = (String) request.getParameter("x_veljavnost");
		}else{
			x_veljavnost = "";
		}

		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `cenastr` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("cenastrlist.jsp");
			response.flushBuffer();
			return;
		}

		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kupca");
		}else{
			rs.updateString("sif_kupca", tmpfld);
		}

		// Field material_koda
		tmpfld = ((String) x_material_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("material_koda");
		}else{
			rs.updateString("material_koda", tmpfld);
		}

		tmpfld = ((String) x_skupina);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("skupina");
		}else{
			rs.updateString("skupina", tmpfld);
		}
		// Field cena
		tmpfld = ((String) x_cena).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("cena");
		} else {
			rs.updateDouble("cena",Double.parseDouble(tmpfld));
		}

		// Field veljavnost
		if (IsDate((String) x_veljavnost,"EURODATE", locale)) {
			rs.updateTimestamp("veljavnost", EW_UnFormatDateTime((String)x_veljavnost,"EURODATE", locale));
		}else{
			rs.updateNull("veljavnost");
		}

		//Uporabnik
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
		
		try{
			rs.updateRow();
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
		response.sendRedirect("cenastrlist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}


if(request.getParameter("prikaz_kupca")!= null){
	session.setAttribute("cenastr_kupac",  request.getParameter("prikaz_kupca"));
}

if(request.getParameter("prikaz_material_koda")!= null){
	session.setAttribute("cenastr_material_koda",  request.getParameter("prikaz_material_koda"));
}

if(request.getParameter("prikaz_skupina")!= null){
	session.setAttribute("cenastr_skupina",  request.getParameter("prikaz_skupina"));
}


String stranke = (String) session.getAttribute("vse");
String kupciQueryFilter = "";
if(stranke.equals("0")){
	kupciQueryFilter = "where potnik = " + session.getAttribute("papirservis1_status_UserID");
}

String cbo_x_sif_kupca_js = "";
x_sif_kupcaList = new StringBuffer("<select name=\"x_sif_kupca\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci`" + kupciQueryFilter + 
//									" ORDER BY `naziv` ASC";
									" order by " + session.getAttribute("cenastr_kupac") + " asc";
Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
	int rowcntwrk_x_sif_kupca = 0;
	while (rswrk_x_sif_kupca.next()) {
		//x_sif_kupcaList += "<option value=\"" + HTMLEncode(rswrk_x_sif_kupca.getString("naziv")) + "\"";
		String tmpSifra = rswrk_x_sif_kupca.getString("sif_kupca");
		x_sif_kupcaList.append("<option value=\"").append(tmpSifra).append("\"");
		if (tmpSifra.equals(x_sif_kupca)) {
			x_sif_kupcaList.append(" selected");
		}
		String tmpValue_x_sif_kupca = "";
		String tmpNaziv = rswrk_x_sif_kupca.getString((String)session.getAttribute("cenastr_kupac"));
		if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
		x_sif_kupcaList.append(">").append(tmpValue_x_sif_kupca).append("</option>");
		rowcntwrk_x_sif_kupca++;
	}
rswrk_x_sif_kupca.close();
rswrk_x_sif_kupca = null;
stmtwrk_x_sif_kupca.close();
stmtwrk_x_sif_kupca = null;
x_sif_kupcaList.append("</select>");

String cbo_x_skupina_js = "";
x_skupinaList = new StringBuffer("<select name=\"x_skupina\"><option value=\"\">Izberi</option>");
String sqlwrk_x_skupina = "SELECT skupina, tekst " +
								"FROM skup " +
								"order by " + session.getAttribute("cenastr_skupina") + " asc";
Statement stmtwrk_x_skupina = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_skupina = stmtwrk_x_skupina.executeQuery(sqlwrk_x_skupina);
	int rowcntwrk_x_skupina = 0;
	while (rswrk_x_skupina.next()) {
		x_skupinaList.append("<option value=\"").append(rswrk_x_skupina.getString("skupina")).append("\"");
		if (rswrk_x_skupina.getString("skupina").equals(x_skupina)) {
			x_skupinaList.append(" selected");
		}
		String tmpValue_x_skupina = "";
		String tmpNaziv = rswrk_x_skupina.getString((String)session.getAttribute("cenastr_skupina"));
		if (tmpNaziv != null) tmpValue_x_skupina = tmpNaziv;
		x_skupinaList.append(">").append(tmpValue_x_skupina).append("</option>");
		rowcntwrk_x_skupina++;
	}
rswrk_x_skupina.close();
rswrk_x_skupina = null;
stmtwrk_x_skupina.close();
stmtwrk_x_skupina = null;
x_skupinaList.append("</select>");


String cbo_x_material_koda_js = "";
x_material_kodaList = new StringBuffer("<select name=\"x_material_koda\"><option value=\"\">Izberi</option>");
String sqlwrk_x_material_koda = "SELECT `materiali`.`koda`, `material` " +
								"FROM `materiali`, (select koda, max(zacetek) as zacetek from materiali group by koda) as m " +
								"WHERE materiali.koda = m.koda and materiali.zacetek = m.zacetek "+
//								"ORDER BY `material` ASC";
								"order by " + session.getAttribute("cenastr_material_koda") + " asc";
Statement stmtwrk_x_material_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_material_koda = stmtwrk_x_material_koda.executeQuery(sqlwrk_x_material_koda);
	int rowcntwrk_x_material_koda = 0;
	while (rswrk_x_material_koda.next()) {
		x_material_kodaList.append("<option value=\"").append(rswrk_x_material_koda.getString("koda")).append("\"");
		if (rswrk_x_material_koda.getString("koda").equals(x_material_koda)) {
			x_material_kodaList.append(" selected");
		}
		String tmpValue_x_material_koda = "";
		String tmpNaziv = rswrk_x_material_koda.getString((String)session.getAttribute("cenastr_material_koda"));
		if (tmpNaziv != null) tmpValue_x_material_koda = tmpNaziv;
		x_material_kodaList.append(">").append(tmpValue_x_material_koda).append("</option>");
		rowcntwrk_x_material_koda++;
	}
rswrk_x_material_koda.close();
rswrk_x_material_koda = null;
stmtwrk_x_material_koda.close();
stmtwrk_x_material_koda = null;
x_material_kodaList.append("</select>");


%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Popravek v tabeli: cenastr<br><br><a href="cenastrlist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_sif_kupca && !EW_hasValue(EW_this.x_sif_kupca, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kupca, "SELECT", "Napačno polje - sif kupca"))
                return false; 
        }
if (EW_this.x_material_koda && !EW_hasValue(EW_this.x_material_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_material_koda, "SELECT", "Napačno polje - material koda"))
                return false; 
        }
if (EW_this.x_cena && !EW_checknumber(EW_this.x_cena.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena, "TEXT", "Napačna številka - cena"))
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
<form onSubmit="return EW_checkMyForm(this);"  name="cenastredit" action="cenastredit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%><span class="jspmaker"><a href="<%out.print("cenastredit.jsp?prikaz_kupca=sif_kupca&key=" + key);%>">šifra</a>&nbsp;<a href="<%out.print("cenastredit.jsp?prikaz_kupca=naziv&key=" + key );%>">naziv</a>&nbsp;<a href="<%out.print("cenastredit.jsp?prikaz_kupca=naslov&key=" + key );%>">naslov</a></span>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_skupinaList);%><span class="jspmaker"><a href="<%out.print("cenastradd.jsp?prikaz_skupina=skupina");%>">skupina</a>&nbsp;<a href="<%out.print("cenastradd.jsp?prikaz_skupina=tekst");%>">naziv</a>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Material koda&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_material_kodaList);%><span class="jspmaker"><a href="<%out.print("cenastredit.jsp?prikaz_material_koda=koda&key=" + key );%>">koda</a>&nbsp;<a href="<%out.print("cenastredit.jsp?prikaz_material_koda=material&key=" + key );%>">material</a>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena" size="30" value="<%= HTMLEncode((String)x_cena) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Veljavnost&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_veljavnost" value="<%= EW_FormatDateTime(x_veljavnost,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_veljavnost,'dd.mm.yyyy');return false;">&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Shrani">
</form>
<%@ include file="footer.jsp" %>
