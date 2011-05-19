<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="materiali_okoljelist.jsp"%>
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
	response.sendRedirect("material_okoljelist.jsp"); 
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
Object x_id = null;
Object x_material_koda = null;
Object x_okolje_koda = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `material_okolje` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("material_okoljelist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_id = String.valueOf(rs.getLong("id"));
	if (rs.getString("material_koda") != null){
		x_material_koda = rs.getString("material_koda");
	}else{
		x_material_koda = "";
	}
	if (rs.getString("okolje_koda") != null){
		x_okolje_koda = rs.getString("okolje_koda");
	}else{
		x_okolje_koda = "";
	}
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_id") != null){
			x_id = (String) request.getParameter("x_id");
		}else{
			x_id = "";
		}
		if (request.getParameter("x_material_koda") != null){
			x_material_koda = request.getParameter("x_material_koda");
		}
		if (request.getParameter("x_okolje_koda") != null){
			x_okolje_koda = request.getParameter("x_okolje_koda");
		}

		// Open record
		String strsql = "SELECT * FROM `material_okolje` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field material_koda
		tmpfld = ((String) x_material_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("material_koda");
		}else{
			rs.updateString("material_koda", tmpfld);
		}

		// Field okolje_koda
		tmpfld = ((String) x_okolje_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("okolje_koda");
		}else{
			rs.updateString("okolje_koda", tmpfld);
		}
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("material_okoljelist.jsp");
		response.flushBuffer();
		return;
	}
if(request.getParameter("prikaz_material")!= null){
 	session.setAttribute("material_okolje_prikaz_material", request.getParameter("prikaz_material"));
}

if(request.getParameter("prikaz_okolje")!= null){
 	session.setAttribute("material_okolje_prikaz_okolje", request.getParameter("prikaz_okolje"));
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
<p><span class="jspmaker">Dodaj v: material koda<br><br><a href="material_okoljelist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_material_koda && !EW_hasValue(EW_this.x_material_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_material_koda, "SELECT", "Napačan vnos - material koda"))
                return false; 
        }
if (EW_this.x_okolje_koda && !EW_hasValue(EW_this.x_okolje_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_okolje_koda, "SELECT", "Napačan vnos - okolje koda"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="material_okoljeadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Material koda&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_material_koda_js = "";
String x_material_kodaList = "<select name=\"x_material_koda\"><option value=\"\">Izberi</option>";
String sqlwrk_x_material_koda = "SELECT `materiali`.`koda`, `material` " +
								"FROM `materiali`, (select koda, max(zacetek) as zacetek from materiali group by koda) as m " +
								"WHERE materiali.koda = m.koda and materiali.zacetek = m.zacetek "+
								"ORDER BY `" + session.getAttribute("material_okolje_prikaz_material")  + "` ASC";
Statement stmtwrk_x_material_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_material_koda = stmtwrk_x_material_koda.executeQuery(sqlwrk_x_material_koda);
	int rowcntwrk_x_material_koda = 0;
	while (rswrk_x_material_koda.next()) {
		x_material_kodaList += "<option value=\"" + HTMLEncode(rswrk_x_material_koda.getString("koda")) + "\"";
		if (rswrk_x_material_koda.getString("koda").equals(x_material_koda)) {
			x_material_kodaList += " selected";
		}
		String tmpValue_x_material_koda = "";
		if (rswrk_x_material_koda.getString("material")!= null) tmpValue_x_material_koda = rswrk_x_material_koda.getString("material");
		x_material_kodaList += ">" + rswrk_x_material_koda.getString("koda") + " " + tmpValue_x_material_koda
 + "</option>";
		rowcntwrk_x_material_koda++;	
	}
rswrk_x_material_koda.close();
rswrk_x_material_koda = null;
stmtwrk_x_material_koda.close();
stmtwrk_x_material_koda = null;
x_material_kodaList += "</select>";
out.println(x_material_kodaList);
%><a href="<%out.print("material_okoljeadd.jsp?" + ((key != null && key.length() > 0) ? "key=" + key + "&" : "")  +"prikaz_material=koda");%>">koda</a>&nbsp;<a href="<%out.print("material_okoljeadd.jsp?" + ((key != null && key.length() > 0) ? "key=" + key + "&" : "")  +"prikaz_material=material");%>">material</a>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">EWC koda&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_okolje_koda_js = "";
String x_okolje_kodaList = "<select name=\"x_okolje_koda\"><option value=\"\">Izberi</option>";
String sqlwrk_x_okolje_koda = "SELECT `koda`, `material` FROM `okolje`" + " ORDER BY `" + session.getAttribute("material_okolje_prikaz_okolje") + "` ASC";
Statement stmtwrk_x_okolje_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_okolje_koda = stmtwrk_x_okolje_koda.executeQuery(sqlwrk_x_okolje_koda);
	int rowcntwrk_x_okolje_koda = 0;
	while (rswrk_x_okolje_koda.next()) {
		x_okolje_kodaList += "<option value=\"" + HTMLEncode(rswrk_x_okolje_koda.getString("koda")) + "\"";
		if (rswrk_x_okolje_koda.getString("koda").equals(x_okolje_koda)) {
			x_okolje_kodaList += " selected";
		}
		String tmpValue_x_okolje_koda = "";
		if (rswrk_x_okolje_koda.getString("material")!= null) tmpValue_x_okolje_koda = rswrk_x_okolje_koda.getString("material");
		x_okolje_kodaList += ">" + rswrk_x_okolje_koda.getString("koda") + " " + tmpValue_x_okolje_koda
 + "</option>";
		rowcntwrk_x_okolje_koda++;
	}
rswrk_x_okolje_koda.close();
rswrk_x_okolje_koda = null;
stmtwrk_x_okolje_koda.close();
stmtwrk_x_okolje_koda = null;
x_okolje_kodaList += "</select>";
out.println(x_okolje_kodaList);
%><a href="<%out.print("material_okoljeadd.jsp?" + ((key != null && key.length() > 0) ? "key=" + key + "&" : "")  +"prikaz_okolje=koda");%>">koda</a>&nbsp;<a href="<%out.print("material_okoljeadd.jsp?" + ((key != null && key.length() > 0) ? "key=" + key + "&" : "")  +"prikaz_okolje=material");%>">material</a>
&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
