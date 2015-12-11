<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" %>
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
Object x_sif_kupca = null;
Object x_naziv = null;
Object x_naslov = null;
Object x_posta = null;
Object x_kraj = null;

StringBuffer komunale_naslov = new StringBuffer();
StringBuffer komunale_posta = new StringBuffer();
StringBuffer komunale_kraj = new StringBuffer();


// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `kupci` WHERE `sif_kupca`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
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
		rs.first();

			// Get the field contents
		if (rs.getString("sif_kupca") != null){
			x_sif_kupca = rs.getString("sif_kupca");
		}else{
			x_sif_kupca = "";
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

		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = (String) request.getParameter("x_sif_kupca");
		}else{
			x_sif_kupca = "";
		}

		// Open record
		String strsql = "SELECT * FROM `komunale` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field sif_kupca
		tmpfld = ((String) x_sif_kupca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("sif_kupca");
		}else{
		String srchfld = "'" + tmpfld + "'";
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM `komunale` WHERE `sif_kupca` = '" + srchfld +"'";
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				out.print("Duplicate key for sif_kupca, value = " + tmpfld + "<br>");
				out.print("Press [Previous Page] key to continue!");
				return;
			}
			rschk.close();
			rschk = null;
			rs.updateString("sif_kupca", tmpfld);
		}


		try{
			rs.insertRow();

			//za vsakego novo komunalo dodamo vse kode
			strsql = "insert into " + session.getAttribute("letoTabelaKomunale") + "  (sif_kupca, koda) " +
					"SELECT "+x_sif_kupca+", koda FROM okolje WHERE koda like '15 01%'";
			out.println(strsql);
			stmt.executeUpdate(strsql);
		}
		catch(java.sql.SQLException e){
			System.out.println(e.getMessage());
		}
	
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
}catch (com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException ex){
	out.println("Morate spremeniti komunalo!!!");
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
<p><span class="jspmaker">Dodaj v: komunale<br><br><a href="komunalelist.jsp">Nazaj na pregled</a></span></p>
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
<form onSubmit="return EW_checkMyForm(this);"  name="komunalaadd"  action="komunaleadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Komunala&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_komunaleList);%></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naslov&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naslov" size="30" maxlength="255" readonly value="<%= HTMLEncode((String)x_naslov) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pošta&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_posta" size="30" maxlength="255" readonly value="<%= HTMLEncode((String)x_posta) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kraj&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kraj" size="30" maxlength="255" readonly value="<%= HTMLEncode((String)x_kraj) %>">&nbsp;</td>
	</tr>

</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
