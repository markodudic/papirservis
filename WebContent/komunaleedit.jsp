<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="komunalelist.jsp"%>
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

StringBuffer komunale_naslov = new StringBuffer();
StringBuffer komunale_posta = new StringBuffer();
StringBuffer komunale_kraj = new StringBuffer();

int ewCurSec  = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();

if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("komunalelist.jsp"); 
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
	response.sendRedirect("komunalelist.jsp");
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
Object x_naziv = null;
Object x_naslov = null;
Object x_posta = null;
Object x_kraj = null;



// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kupci` WHERE `sif_kupca`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("komunalelist.jsp");
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
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = (String) request.getParameter("x_sif_kupca");
		}else{
			x_sif_kupca = "";
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
		if (request.getParameter("x_kraj") != null){
			x_kraj = (String) request.getParameter("x_kraj");
		}else{
			x_kraj = "";
		}
		if (request.getParameter("x_posta") != null){
			x_posta = request.getParameter("x_posta");
		}
		
		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `komunale` WHERE `sif_kupca`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("komunalelist.jsp");
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

		
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("komunalelist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}

String cbo_x_komunale_js = "";
String x_komunaleList = "<select onchange = \"updateKoda(this);\" name=\"x_sif_kupca\"><option value=\"\">Izberi</option>";
String sqlwrk_x_komunale = "SELECT sif_kupca, naziv, naslov, posta, kraj FROM kupci WHERE upper(naziv) like 'KOMUNALA%' ORDER BY naziv ASC";
Statement stmtwrk_x_komunale = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_komunale = stmtwrk_x_komunale.executeQuery(sqlwrk_x_komunale);
	int rowcntwrk_x_komunale = 0;
	while (rswrk_x_komunale.next()) {
		x_komunaleList += "<option value=\"" + HTMLEncode(rswrk_x_komunale.getString("sif_kupca")) + "\"";
		if (rswrk_x_komunale.getString("sif_kupca").equals(x_sif_kupca)) {
			x_komunaleList += " selected";
		}
		String tmpValue_x_komunale = "";
		if (rswrk_x_komunale.getString("naziv")!= null) tmpValue_x_komunale = rswrk_x_komunale.getString("naziv");
		x_komunaleList += ">" + tmpValue_x_komunale
 + "</option>";
 		komunale_naslov.append("komunale_naslov[").append(rowcntwrk_x_komunale).append("]='").append(String.valueOf(rswrk_x_komunale.getString("naslov"))).append("';");
		komunale_kraj.append("komunale_kraj[").append(rowcntwrk_x_komunale).append("]='").append(String.valueOf(rswrk_x_komunale.getString("kraj"))).append("';");
		komunale_posta.append("komunale_posta[").append(rowcntwrk_x_komunale).append("]=").append(String.valueOf(rswrk_x_komunale.getString("posta"))).append(";");

		rowcntwrk_x_komunale++;		
	}
rswrk_x_komunale.close();
rswrk_x_komunale = null;
stmtwrk_x_komunale.close();
stmtwrk_x_komunale = null;
x_komunaleList += "</select>";

%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : komunale<br><br><a href="komunalelist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>

<script language="JavaScript">
var komunale_naslov = new Array();
<%=komunale_naslov%>
var komunale_posta = new Array();
<%=komunale_posta%>
var komunale_kraj = new Array();
<%=komunale_kraj%>

function updateKoda(EW_this){
	document.komunalaadd.x_naslov.value = komunale_naslov[document.komunalaadd.x_sif_kupca.selectedIndex - 1];
	document.komunalaadd.x_posta.value = komunale_posta[document.komunalaadd.x_sif_kupca.selectedIndex - 1];
	document.komunalaadd.x_kraj.value = komunale_kraj[document.komunalaadd.x_sif_kupca.selectedIndex - 1];
}
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="komunalaadd"  name="komunaleedit" action="komunaleedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Komunala&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_komunaleList);%></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naslov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naslov" size="30" maxlength="255" value="<%= HTMLEncode((String)x_naslov) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pošta&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_posta" size="30" maxlength="255" value="<%= HTMLEncode((String)x_posta) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kraj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kraj" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kraj) %>">&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Potrdi">
</form>
<%@ include file="footer.jsp" %>
