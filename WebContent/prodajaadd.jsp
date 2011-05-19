<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage ="prodajalist.jsp"%>
<%@ page contentType="text/html; charset=utf-8" %>
<% Locale locale = Locale.getDefault();
response.setLocale(locale);%>
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
	response.sendRedirect("prodajalist.jsp"); 
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
Object x_id = null;
Object x_st_dob = null;
Object x_pozicija = null;
Object x_datum = null;
Object x_sif_kupca = null;
Object x_koda = null;
Object x_ewc = null;
Object x_reg_st = null;
Object x_kol_n = null;
Object x_kol_p = null;
Object x_st_bal = null;
Object x_sif_enote = null;

StringBuffer x_sif_kupcaList = null;
StringBuffer x_sif_enoteList = null;
StringBuffer x_kodaList = null;
StringBuffer x_ewcList = null;

StringBuffer sif_ewc = new StringBuffer();


try{
	Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rs = null;
		String strsql = "SELECT IFNULL(max(st_dob) + 1,1) cnt FROM " + session.getAttribute("letoTabelaProdaja") + " prodaja";
		rs = stmt1.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt1.close();
			stmt1 = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("prodajalist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

	// Get the field contents
	x_st_dob = String.valueOf(rs.getLong("cnt"));
	x_pozicija = "1";//avtomati�no se pove�a ua 1 ob kopiranju
	rs.close();
	rs = null;
	stmt1.close();
	stmt1 = null;
	//conn.close();
	//conn = null;


} catch(Exception e){
	System.out.println(e.toString());
}




// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabelaProdaja") + " prodaja WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("prodajalist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_id = String.valueOf(rs.getLong("id"));
	x_st_dob = String.valueOf(rs.getLong("st_dob"));
	x_pozicija = String.valueOf(rs.getLong("pozicija") + 1);
	if (rs.getTimestamp("datum") != null){
		x_datum = rs.getTimestamp("datum");
	}else{
		x_datum = null;
	}
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}
	if (rs.getString("ewc") != null){
		x_ewc = rs.getString("ewc");
	}else{
		x_ewc = "";
	}
	if (rs.getString("reg_st") != null){
		x_reg_st = rs.getString("reg_st");
	}else{
		x_reg_st = "";
	}
	x_kol_n = String.valueOf(rs.getLong("kol_n"));
	x_kol_p = String.valueOf(rs.getLong("kol_p"));
	x_st_bal = String.valueOf(rs.getLong("st_bal"));
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_st_dob") != null){
			x_st_dob = (String) request.getParameter("x_st_dob");
		}else{
			x_st_dob = "";
		}
		if (request.getParameter("x_pozicija") != null){
			x_pozicija = (String) request.getParameter("x_pozicija");
		}else{
			x_pozicija = "";
		}
		if (request.getParameter("x_datum") != null){
			x_datum = (String) request.getParameter("x_datum");
		}else{
			x_datum = "";
		}
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = request.getParameter("x_sif_kupca");
		}
		if (request.getParameter("x_koda") != null){
			x_koda = request.getParameter("x_koda");
		}
		if (request.getParameter("x_ewc_ll") != null){
			x_ewc = request.getParameter("x_ewc_ll");
		}
		if (request.getParameter("x_reg_st") != null){
			x_reg_st = (String) request.getParameter("x_reg_st");
		}else{
			x_reg_st = "";
		}
		if (request.getParameter("x_kol_n") != null){
			x_kol_n = (String) request.getParameter("x_kol_n");
		}else{
			x_kol_n = "";
		}
		if (request.getParameter("x_kol_p") != null){
			x_kol_p = (String) request.getParameter("x_kol_p");
		}else{
			x_kol_p = "";
		}
		if (request.getParameter("x_st_bal") != null){
			x_st_bal = (String) request.getParameter("x_st_bal");
		}else{
			x_st_bal = "";
		}
		if (request.getParameter("x_sif_enote") != null){
			x_sif_enote = request.getParameter("x_sif_enote");
		}else{
			x_sif_enote = "";
		}




		// Open record
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabelaProdaja") + " prodaja WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field st_dob
		tmpfld = ((String) x_st_dob).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("st_dob");
		} else {
			rs.updateInt("st_dob",Integer.parseInt(tmpfld));
		}

		// Field pozicija
		tmpfld = ((String) x_pozicija).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("pozicija");
		} else {
			rs.updateInt("pozicija",Integer.parseInt(tmpfld));
		}

		// Field datum
		if (IsDate((String) x_datum,"EURODATE", locale)) {
			rs.updateTimestamp("datum", EW_UnFormatDateTime((String)x_datum,"EURODATE", locale));
		}else{
			rs.updateNull("datum");
		}

		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kupca");
		}else{
			rs.updateString("sif_kupca", tmpfld);
		}

		// Field koda
		tmpfld = ((String) x_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("koda");
		}else{
			rs.updateString("koda", tmpfld);
		}

		// Field ewc
		tmpfld = ((String) x_ewc);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("ewc");
		}else{
			rs.updateString("ewc", tmpfld);
		}

		// Field reg_st
		tmpfld = ((String) x_reg_st);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("reg_st");
		}else{
			rs.updateString("reg_st", tmpfld);
		}

		// Field kol_n
		tmpfld = ((String) x_kol_n).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_n");
		} else {
			rs.updateInt("kol_n",Integer.parseInt(tmpfld));
		}

		// Field kol_p
		tmpfld = ((String) x_kol_p).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("kol_p");
		} else {
			rs.updateInt("kol_p",Integer.parseInt(tmpfld));
		}

		// Field st_bal
		tmpfld = ((String) x_st_bal).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("st_bal");
		} else {
			rs.updateInt("st_bal",Integer.parseInt(tmpfld));
		}

		// Field sif_enote
		tmpfld = ((String) x_sif_enote).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("sif_enote");
		} else {
			rs.updateInt("sif_enote",Integer.parseInt(tmpfld));
		}
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("prodajalist.jsp");
		response.flushBuffer();
		return;
	}


if(request.getParameter("prikaz_kupca")!= null){
	session.setAttribute("prodaja_kupci_show",  request.getParameter("prikaz_kupca"));
}

if(request.getParameter("prikaz_material")!= null){
 	session.setAttribute("prodaja_prikaz_material", request.getParameter("prikaz_material"));
}
if(request.getParameter("prikaz_okolje")!= null){
 	session.setAttribute("prodaja_prikaz_okolje", request.getParameter("prikaz_okolje"));
}

String cbo_x_sif_kupca_js = "";
x_sif_kupcaList = new StringBuffer("<select name=\"x_sif_kupca\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci`  where blokada = 0 and potnik = " + session.getAttribute("papirservis1_status_UserID")  + " ORDER BY `" + (String)session.getAttribute("prodaja_kupci_show") + "` ASC";
Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
	int rowcntwrk_x_sif_kupca = 0;
	while (rswrk_x_sif_kupca.next()) {
		//x_sif_kupcaList += "<option value=\"" + HTMLEncode(rswrk_x_sif_kupca.getString((String)session.getAttribute("prodaja_kupci_show"))) + "\"";
		String tmpSifra = rswrk_x_sif_kupca.getString("sif_kupca");
		x_sif_kupcaList.append("<option value=\"").append(tmpSifra).append("\"");
		if (tmpSifra.equals(x_sif_kupca)) {
			x_sif_kupcaList.append(" selected");
		}
		String tmpValue_x_sif_kupca = "";
		String tmpNaziv = null;
		if (!((String)session.getAttribute("dob_kupci_show")).equals("vse"))
			tmpNaziv = rswrk_x_sif_kupca.getString((String)session.getAttribute("prodaja_kupci_show"));
		else
			tmpNaziv = rswrk_x_sif_kupca.getString("sif_kupca") + " " + rswrk_x_sif_kupca.getString("naziv") + " " + rswrk_x_sif_kupca.getString("naslov");
		
		if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
		x_sif_kupcaList.append(">").append(tmpValue_x_sif_kupca).append("</option>");
		rowcntwrk_x_sif_kupca++;
	}
rswrk_x_sif_kupca.close();
rswrk_x_sif_kupca = null;
stmtwrk_x_sif_kupca.close();
stmtwrk_x_sif_kupca = null;
x_sif_kupcaList.append("</select>");


String cbo_x_sif_enote_js = "";
x_sif_enoteList = new StringBuffer("<select name=\"x_sif_enote\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_enote = "SELECT DISTINCT `sif_enote`, `naziv`, `lokacija` FROM `enote`";
Statement stmtwrk_x_sif_enote = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_enote = stmtwrk_x_sif_enote.executeQuery(sqlwrk_x_sif_enote);
	int rowcntwrk_x_sif_enote = 0;
	while (rswrk_x_sif_enote.next()) {
		x_sif_enoteList.append("<option value=\"").append(HTMLEncode(rswrk_x_sif_enote.getString("sif_enote"))).append("\"");
		if (rswrk_x_sif_enote.getString("sif_enote").equals(x_sif_enote)) {
			x_sif_enoteList.append(" selected");
		}
		String tmpValue_x_sif_enote = "";
		if (rswrk_x_sif_enote.getString("naziv")!= null) tmpValue_x_sif_enote = rswrk_x_sif_enote.getString("naziv");
		x_sif_enoteList.append(">").append(tmpValue_x_sif_enote).append(", ").append(rswrk_x_sif_enote.getString("lokacija")).append("</option>");
		rowcntwrk_x_sif_enote++;
	}
rswrk_x_sif_enote.close();
rswrk_x_sif_enote = null;
stmtwrk_x_sif_enote.close();
stmtwrk_x_sif_enote = null;
x_sif_enoteList.append("</select>");

String cbo_x_koda_js = "";
x_kodaList = new StringBuffer("<select onchange = \"updateKoda(this);\" name=\"x_koda\"><option value=\"\">Izberi</option>");
String sqlwrk_x_koda = "SELECT `materiali`.`koda`, `material`, material_okolje.okolje_koda " +
	"FROM `materiali` " +
	"		left join material_okolje on (materiali.koda = material_okolje.material_koda), " +
	" (select koda, max(zacetek) as zacetek from materiali group by koda) as m " +
	"WHERE materiali.koda = m.koda and materiali.zacetek = m.zacetek "+
	"ORDER BY `"  + session.getAttribute("prodaja_prikaz_material") + "` ASC";

Statement stmtwrk_x_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_koda = stmtwrk_x_koda.executeQuery(sqlwrk_x_koda);
	int rowcntwrk_x_koda = 0;
	while (rswrk_x_koda.next()) {
		x_kodaList.append("<option value=\"").append(rswrk_x_koda.getString("koda")).append("\"");
		if (rswrk_x_koda.getString("koda").equals(x_koda)) {
			x_kodaList.append(" selected");
		}
		String tmpValue_x_koda = "";
		if (rswrk_x_koda.getString("material")!= null) tmpValue_x_koda = rswrk_x_koda.getString("material");
		x_kodaList.append(">").append(rswrk_x_koda.getString("koda") + "  ").append(tmpValue_x_koda).append("</option>");

		sif_ewc.append("sif_ewc[").append(rowcntwrk_x_koda).append("]='").append(String.valueOf(rswrk_x_koda.getString("okolje_koda"))).append("';");

		rowcntwrk_x_koda++;
	}
rswrk_x_koda.close();
rswrk_x_koda = null;
stmtwrk_x_koda.close();
stmtwrk_x_koda = null;
x_kodaList.append("</select>");


String cbo_x_ewc_js = "";
x_ewcList = new StringBuffer("<select name=\"x_ewc_ll\" ><option value=\"\">Izberi</option>");
String sqlwrk_x_ewc = "SELECT `koda`, `material` " +
		"FROM `okolje` "+
		"ORDER BY `" + session.getAttribute("prodaja_prikaz_okolje") + "` ASC";

Statement stmtwrk_x_ewc = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_ewc = stmtwrk_x_ewc.executeQuery(sqlwrk_x_ewc);
	int rowcntwrk_x_ewc = 0;
	while (rswrk_x_ewc.next()) {
		x_ewcList.append("<option value=\"").append(rswrk_x_ewc.getString("koda")).append("\"");
		if (rswrk_x_ewc.getString("koda").equals(x_ewc)) {
			x_ewcList.append(" selected");
		}
		String tmpValue_x_ewc = "";
		if (rswrk_x_ewc.getString("material")!= null) tmpValue_x_ewc = rswrk_x_ewc.getString("material");
		x_ewcList.append(">").append(rswrk_x_ewc.getString("koda") + "   ").append(tmpValue_x_ewc).append("</option>");

		rowcntwrk_x_ewc++;
	}
rswrk_x_ewc.close();
rswrk_x_ewc = null;
stmtwrk_x_ewc.close();
stmtwrk_x_ewc = null;
x_ewcList.append("</select>");

}
catch (com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException ex){
	out.println("Morate spremeniti šifro!!!");
}
catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: prodaja<br><br><a href="prodajalist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript
var sif_ewc = new Array();
<%=sif_ewc%>

function updateKoda(EW_this){
	if (sif_ewc[document.prodajaadd.x_koda.selectedIndex-1] != "null")
		document.prodajaadd.x_ewc_ll.value = sif_ewc[document.prodajaadd.x_koda.selectedIndex-1];
	else
		document.prodajaadd.x_ewc_ll.selectedIndex = 0;
}

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_st_dob && !EW_hasValue(EW_this.x_st_dob, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "Napačna številka - st dob"))
                return false; 
        }
if (EW_this.x_st_dob && !EW_checkinteger(EW_this.x_st_dob.value)) {
        if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "Napačna številka - st dob"))
            return false; 
        }
if (EW_this.x_pozicija && !EW_hasValue(EW_this.x_pozicija, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "Napačna številka - pozicija"))
                return false; 
        }
if (EW_this.x_pozicija && !EW_checkinteger(EW_this.x_pozicija.value)) {
        if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "Napačna številka - pozicija"))
            return false; 
        }
if (EW_this.x_datum && !EW_checkeurodate(EW_this.x_datum.value)) {
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačan datum (dd.mm.yyyy) - datum"))
            return false; 
        }
if (EW_this.x_sif_kupca && !EW_hasValue(EW_this.x_sif_kupca, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kupca, "SELECT", "Napačan vnos - sif kupca"))
                return false; 
        }
if (EW_this.x_kol_n && !EW_checkinteger(EW_this.x_kol_n.value)) {
        if (!EW_onError(EW_this, EW_this.x_kol_n, "TEXT", "Napačna številka - kol n"))
            return false; 
        }
if (EW_this.x_kol_p && !EW_checkinteger(EW_this.x_kol_p.value)) {
        if (!EW_onError(EW_this, EW_this.x_kol_p, "TEXT", "Napačna številka - kol p"))
            return false; 
        }
if (EW_this.x_st_bal && !EW_checkinteger(EW_this.x_st_bal.value)) {
        if (!EW_onError(EW_this, EW_this.x_st_bal, "TEXT", "Napačna številka - st bal"))
            return false; 
        }
if (EW_this.x_sif_enote && !EW_hasValue(EW_this.x_sif_enote, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_enote, "SELECT", "Napačna številka - sif enote"))
                return false; 
        }
if (EW_this.x_ewc && !EW_hasValue(EW_this.x_ewc, "SELECT" )) {
    if (!EW_onError(EW_this, EW_this.x_ewc, "SELECT", "Napačan vnos - ewc"))
        return false; 
}
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="prodajaadd.jsp" method="post" name="prodajaadd">
<p>
<input type="hidden" name="a" value="A">
<input type="hidden" name="x_pozicija" value="<%= HTMLEncode((String)x_pozicija) %>">
<input type="hidden" name="x_st_dob" value="<%= HTMLEncode((String)x_st_dob) %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Številka dobavnice&nbsp;</td>
		<td class="ewTableAltRow"><% if (x_st_dob == null || ((String)x_st_dob).equals("")) {x_st_dob = "0"; } // set default value %><input type="text" disabled name="x_st_dob_LL" size="30" value="<%= HTMLEncode((String)x_st_dob) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pozicija&nbsp;</td>
		<td class="ewTableAltRow"><% if (x_pozicija== null || ((String)x_pozicija).equals("")) {x_pozicija = "0"; } // set default value %><input type="text" disabled name="x_pozicija_LL" size="30" value="<%= HTMLEncode((String)x_pozicija) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_datum" value="<%= EW_FormatDateTime(x_datum,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_datum,'dd.mm.yyyy');return false;">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kupec&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%>&nbsp;<span class="jspmaker"><a href="<%out.print("prodajaadd.jsp?key=" + x_id + "&prikaz_kupca=sif_kupca");%>">šifra</a>&nbsp;<a href="<%out.print("prodajaadd.jsp?key=" + x_id + "&prikaz_kupca=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("prodajaadd.jsp?key=" + x_id + "&prikaz_kupca=naslov");%>">naslov</a>&nbsp;</a></span>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_kodaList);%>
		<a href="<%out.print("prodajaadd.jsp?key=" + x_id  + "&prikaz_material=koda");%>">koda</a>&nbsp;<a href="<%out.print("prodajaadd.jsp?key=" + x_id + "&prikaz_material=material");%>">material</a>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">EWC&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_ewcList);%>&nbsp;
		<a href="<%out.print("prodajaadd.jsp?key=" + x_id  + "prikaz_okolje=koda");%>">ewc</a>&nbsp;<a href="<%out.print("prodajaadd.jsp?key=" + x_id  + "prikaz_okolje=material");%>">material</a></td>
	</tr>	
	<tr>
		<td class="ewTableHeader">reg st&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_reg_st" size="30" maxlength="255" value="<%= HTMLEncode((String)x_reg_st) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">kol n&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_n" size="30" value="<%= HTMLEncode((String)x_kol_n) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">kol p&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kol_p" size="30" value="<%= HTMLEncode((String)x_kol_p) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">st bal&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_st_bal" size="30" value="<%= HTMLEncode((String)x_st_bal) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Enota&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_enoteList);%>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
