<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="skuplist.jsp"%>
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
	response.sendRedirect("skuplist.jsp"); 
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
Object x_skupina = null;
Object x_tekst = null;
Object x_pr1 = null;
boolean x_ravnanje = false;
boolean x_prevoz_kamion = false;
boolean x_prevoz_material = false;


// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `skup` WHERE `skupina`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("skuplist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_skupina = String.valueOf(rs.getLong("skupina"));
	if (rs.getString("tekst") != null){
		x_tekst = rs.getString("tekst");
	}else{
		x_tekst = "";
	}
	if (rs.getString("pr1") != null){
		x_pr1 = rs.getString("pr1");
	}else{
		x_pr1 = "";
	}

	x_ravnanje = rs.getBoolean("ravnanje");
	x_prevoz_kamion = rs.getBoolean("prevoz_kamion");
	x_prevoz_material = rs.getBoolean("prevoz_material");


		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_skupina") != null){
			x_skupina = (String) request.getParameter("x_skupina");
		}else{
			x_skupina = "";
		}
		if (request.getParameter("x_tekst") != null){
			x_tekst = (String) request.getParameter("x_tekst");
		}else{
			x_tekst = "";
		}
		if (request.getParameter("x_pr1") != null){
			x_pr1 = (String) request.getParameter("x_pr1");
		}else{
			x_pr1 = "";
		}
		
		if (request.getParameter("x_ravnanje") != null){
			x_ravnanje = true;
		}

		if (request.getParameter("x_prevoz_kamion") != null){
			x_prevoz_kamion = true;
		}
		if (request.getParameter("x_prevoz_material") != null){
			x_prevoz_material = true;
		}

		
		// Open record
		String strsql = "SELECT * FROM `skup` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field skupina
		tmpfld = ((String) x_skupina).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("skupina");
		} else {
		String srchfld = tmpfld;
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM `skup` WHERE `skupina` = " + srchfld;
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				Exception ex = new com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException();
				throw ex;
			}
			rschk.close();
			rschk = null;
			rs.updateInt("skupina",Integer.parseInt(tmpfld));
		}

		// Field tekst
		tmpfld = ((String) x_tekst);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("tekst");
		}else{
			rs.updateString("tekst", tmpfld);
		}

		// Field pr1
		tmpfld = ((String) x_pr1);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("pr1");
		}else{
			rs.updateString("pr1", tmpfld);
		}

		rs.updateBoolean("ravnanje",x_ravnanje);
		rs.updateBoolean("prevoz_kamion",x_prevoz_kamion);
		rs.updateBoolean("prevoz_material",x_prevoz_material);

		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("skuplist.jsp");
		response.flushBuffer();
		return;
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
<p><span class="jspmaker">Dodaj v: skup<br><br><a href="skuplist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) {
if (EW_this.x_skupina && !EW_hasValue(EW_this.x_skupina, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_skupina, "TEXT", "Napačna številka - skupina"))
                return false; 
        }
if (EW_this.x_skupina && !EW_checkinteger(EW_this.x_skupina.value)) {
        if (!EW_onError(EW_this, EW_this.x_skupina, "TEXT", "Napačna številka - skupina"))
            return false; 
        }
if (EW_this.x_tekst && !EW_hasValue(EW_this.x_tekst, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_tekst, "TEXT", "Napačan vnos - tekst"))
                return false; 
        }
if (EW_this.x_pr1 && !EW_hasValue(EW_this.x_pr1, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_pr1, "TEXT", "Napačan vnos - pr 1"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form accept-charset="UTF-8"  onSubmit="return EW_checkMyForm(this);"  action="skupadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_skupina" size="30" value="<%= HTMLEncode((String)x_skupina) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">tekst&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_tekst" size="30" maxlength="255" value="<%= HTMLEncode((String)x_tekst) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">pr 1&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_pr1" size="30" maxlength="255" value="<%= HTMLEncode((String)x_pr1) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Ravnanje&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_ravnanje" <%= x_ravnanje ? "checked" : "" %>></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz kamion&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_prevoz_kamion" <%= x_prevoz_kamion ? "checked" : "" %> ></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz material&nbsp;</td>
		<td class="ewTableAltRow"><input type="checkbox" name="x_prevoz_material" <%= x_prevoz_material ? "checked" : "" %> ></td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>