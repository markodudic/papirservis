<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
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
int [] ew_SecTable = new int[3+1];
ew_SecTable[0] = 15;
ew_SecTable[1] = 13;
ew_SecTable[2] = 15;
ew_SecTable[3] = 8;

// get current table security
int ewCurSec = 0; // initialise
if (session.getAttribute("papirservis1_status_UserLevel") != null) {
	int ewCurIdx = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();
	if (ewCurIdx == -1) { // system administrator
		ewCurSec = 31;
	} else if (ewCurIdx > 0 && ewCurIdx <= 4) { 
		ewCurSec = ew_SecTable[ewCurIdx-1];
	}
}
if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("material_kodalist.jsp"); 
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
	response.sendRedirect("material_kodalist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_id = null;
Object x_material_koda = null;
Object x_okolje_koda = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `material_koda` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("material_kodalist.jsp");
			response.flushBuffer();
			return;
		}else{
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
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_material_koda") != null){
			x_material_koda = request.getParameter("x_material_koda");
		}
		if (request.getParameter("x_okolje_koda") != null){
			x_okolje_koda = request.getParameter("x_okolje_koda");
		}

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `material_koda` WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("material_kodalist.jsp");
			response.flushBuffer();
			return;
		}

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
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("material_kodalist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Edit TABLE: material koda<br><br><a href="material_kodalist.jsp">Back to List</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_material_koda && !EW_hasValue(EW_this.x_material_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_material_koda, "SELECT", "Invalid Field - material koda"))
                return false; 
        }
if (EW_this.x_okolje_koda && !EW_hasValue(EW_this.x_okolje_koda, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_okolje_koda, "SELECT", "Invalid Field - okolje koda"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="material_kodaedit" action="material_kodaedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">material koda&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_material_koda_js = "";
String x_material_kodaList = "<select name=\"x_material_koda\"><option value=\"\">Please Select</option>";
String sqlwrk_x_material_koda = "SELECT `material` FROM `materiali`" + " ORDER BY `material` ASC";
Statement stmtwrk_x_material_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_material_koda = stmtwrk_x_material_koda.executeQuery(sqlwrk_x_material_koda);
	int rowcntwrk_x_material_koda = 0;
	while (rswrk_x_material_koda.next()) {
		x_material_kodaList += "<option value=\"" + HTMLEncode(rswrk_x_material_koda.getString("material")) + "\"";
		if (rswrk_x_material_koda.getString("material").equals(x_material_koda)) {
			x_material_kodaList += " selected";
		}
		String tmpValue_x_material_koda = "";
		if (rswrk_x_material_koda.getString("material")!= null) tmpValue_x_material_koda = rswrk_x_material_koda.getString("material");
		x_material_kodaList += ">" + tmpValue_x_material_koda
 + "</option>";
		rowcntwrk_x_material_koda++;
	}
rswrk_x_material_koda.close();
rswrk_x_material_koda = null;
stmtwrk_x_material_koda.close();
stmtwrk_x_material_koda = null;
x_material_kodaList += "</select>";
out.println(x_material_kodaList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">okolje koda&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_okolje_koda_js = "";
String x_okolje_kodaList = "<select name=\"x_okolje_koda\"><option value=\"\">Please Select</option>";
String sqlwrk_x_okolje_koda = "SELECT `material` FROM `okolje`" + " ORDER BY `material` ASC";
Statement stmtwrk_x_okolje_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_okolje_koda = stmtwrk_x_okolje_koda.executeQuery(sqlwrk_x_okolje_koda);
	int rowcntwrk_x_okolje_koda = 0;
	while (rswrk_x_okolje_koda.next()) {
		x_okolje_kodaList += "<option value=\"" + HTMLEncode(rswrk_x_okolje_koda.getString("material")) + "\"";
		if (rswrk_x_okolje_koda.getString("material").equals(x_okolje_koda)) {
			x_okolje_kodaList += " selected";
		}
		String tmpValue_x_okolje_koda = "";
		if (rswrk_x_okolje_koda.getString("material")!= null) tmpValue_x_okolje_koda = rswrk_x_okolje_koda.getString("material");
		x_okolje_kodaList += ">" + tmpValue_x_okolje_koda
 + "</option>";
		rowcntwrk_x_okolje_koda++;
	}
rswrk_x_okolje_koda.close();
rswrk_x_okolje_koda = null;
stmtwrk_x_okolje_koda.close();
stmtwrk_x_okolje_koda = null;
x_okolje_kodaList += "</select>";
out.println(x_okolje_kodaList);
%>
&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="EDIT">
</form>
<%@ include file="footer.jsp" %>
