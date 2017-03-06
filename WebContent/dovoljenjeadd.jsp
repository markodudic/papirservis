<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="dovoljenjelist.jsp"%>
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
	response.sendRedirect("dovoljenjelist.jsp"); 
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
Object x_sif_enote = null;
Object x_ewc = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `dovoljenje` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("dovoljenjelist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_id = String.valueOf(rs.getLong("id"));
	if (rs.getString("sif_enote") != null){
		x_sif_enote = rs.getString("sif_enote");
	}else{
		x_sif_enote = "";
	}
	if (rs.getString("ewc") != null){
		x_ewc = rs.getString("ewc");
	}else{
		x_ewc = "";
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
		if (request.getParameter("x_sif_enote") != null){
			x_sif_enote = request.getParameter("x_sif_enote");
		}
		if (request.getParameter("x_ewc") != null){
			x_ewc = request.getParameter("x_ewc");
		}

		// Open record
		String strsql = "SELECT * FROM `dovoljenje` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field sif_enote
		tmpfld = ((String) x_sif_enote);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sif_enote");
		}else{
			rs.updateString("sif_enote", tmpfld);
		}

		// Field ewc
		tmpfld = ((String) x_ewc);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("ewc");
		}else{
			rs.updateString("ewc", tmpfld);
		}
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("dovoljenjelist.jsp");
		response.flushBuffer();
		return;
	}
if(request.getParameter("prikaz_enota")!= null){
 	session.setAttribute("dovoljenje_prikaz_enota", request.getParameter("prikaz_enota"));
}

if(request.getParameter("prikaz_okolje")!= null){
 	session.setAttribute("dovoljenje_prikaz_okolje", request.getParameter("prikaz_okolje"));
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
<p><span class="jspmaker">Dodaj v: dovoljenja<br><br><a href="dovoljenjelist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_sif_enote && !EW_hasValue(EW_this.x_sif_enote, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_enote, "SELECT", "Napačan vnos - material koda"))
                return false; 
        }
if (EW_this.x_ewc && !EW_hasValue(EW_this.x_ewc, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_ewc, "SELECT", "Napačan vnos - okolje koda"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="dovoljenjeadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Šifra enote&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_sif_enote_js = "";
String x_sif_enoteList = "<select name=\"x_sif_enote\"><option value=\"\">Izberi</option>";
String sqlwrk_x_sif_enote = "SELECT sif_enote, naziv " +
								"FROM enote " +
								"ORDER BY `" + session.getAttribute("dovoljenje_prikaz_enota")  + "` ASC";
Statement stmtwrk_x_sif_enote = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_enote = stmtwrk_x_sif_enote.executeQuery(sqlwrk_x_sif_enote);
	int rowcntwrk_x_sif_enote = 0;
	while (rswrk_x_sif_enote.next()) {
		x_sif_enoteList += "<option value=\"" + HTMLEncode(rswrk_x_sif_enote.getString("sif_enote")) + "\"";
		if (rswrk_x_sif_enote.getString("sif_enote").equals(x_sif_enote)) {
			x_sif_enoteList += " selected";
		}
		String tmpValue_x_sif_enote = "";
		if (rswrk_x_sif_enote.getString("naziv")!= null) tmpValue_x_sif_enote = rswrk_x_sif_enote.getString("naziv");
		x_sif_enoteList += ">" + rswrk_x_sif_enote.getString("sif_enote") + " " + tmpValue_x_sif_enote
 + "</option>";
		rowcntwrk_x_sif_enote++;	
	}
rswrk_x_sif_enote.close();
rswrk_x_sif_enote = null;
stmtwrk_x_sif_enote.close();
stmtwrk_x_sif_enote = null;
x_sif_enoteList += "</select>";
out.println(x_sif_enoteList);
%><a href="<%out.print("dovoljenjeadd.jsp?" + ((key != null && key.length() > 0) ? "key=" + key + "&" : "")  +"prikaz_enota=sif_enote");%>">sif_enote</a>&nbsp;<a href="<%out.print("dovoljenjeadd.jsp?" + ((key != null && key.length() > 0) ? "key=" + key + "&" : "")  +"prikaz_enota=naziv");%>">naziv</a>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">EWC koda&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_ewc_js = "";
String x_ewcList = "<select name=\"x_ewc\"><option value=\"\">Izberi</option>";
String sqlwrk_x_ewc = "SELECT `koda`, `material` FROM `okolje`" + " ORDER BY `" + session.getAttribute("dovoljenje_prikaz_okolje") + "` ASC";
Statement stmtwrk_x_ewc = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_ewc = stmtwrk_x_ewc.executeQuery(sqlwrk_x_ewc);
	int rowcntwrk_x_ewc = 0;
	while (rswrk_x_ewc.next()) {
		x_ewcList += "<option value=\"" + HTMLEncode(rswrk_x_ewc.getString("koda")) + "\"";
		if (rswrk_x_ewc.getString("koda").equals(x_ewc)) {
			x_ewcList += " selected";
		}
		String tmpValue_x_ewc = "";
		if (rswrk_x_ewc.getString("material")!= null) tmpValue_x_ewc = rswrk_x_ewc.getString("material");
		x_ewcList += ">" + rswrk_x_ewc.getString("koda") + " " + tmpValue_x_ewc
 + "</option>";
		rowcntwrk_x_ewc++;
	}
rswrk_x_ewc.close();
rswrk_x_ewc = null;
stmtwrk_x_ewc.close();
stmtwrk_x_ewc = null;
x_ewcList += "</select>";
out.println(x_ewcList);
%><a href="<%out.print("dovoljenjeadd.jsp?" + ((key != null && key.length() > 0) ? "key=" + key + "&" : "")  +"prikaz_okolje=koda");%>">koda</a>&nbsp;<a href="<%out.print("dovoljenjeadd.jsp?" + ((key != null && key.length() > 0) ? "key=" + key + "&" : "")  +"prikaz_okolje=material");%>">material</a>
&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
