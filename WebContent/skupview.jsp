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

if ((ewCurSec & ewAllowView) != ewAllowView) {
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
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("skuplist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_skupina = "";
String x_tekst = "";
String x_pr1 = "";
String x_ravnanje = "";
String x_prevoz_kamion = "";
String x_prevoz_material = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `skup` WHERE `skupina`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("skuplist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// skupina

		x_skupina = String.valueOf(rs.getLong("skupina"));

		// tekst
		if (rs.getString("tekst") != null){
			x_tekst = rs.getString("tekst");
		}else{
			x_tekst = "";
		}

		// pr1
		if (rs.getString("pr1") != null){
			x_pr1 = rs.getString("pr1");
		}else{
			x_pr1 = "";
		}

		// ravnanje
		if (rs.getString("ravnanje") != null){
			x_ravnanje = rs.getString("ravnanje");
		}else{
			x_ravnanje = "";
		}
	
		// prevoz_kamion
		if (rs.getBoolean("prevoz_kamion")){
			x_prevoz_kamion = "X";
		}else{
			x_prevoz_kamion = "";
		}
	
		// prevoz_material
		if (rs.getBoolean("prevoz_material")){
			x_prevoz_material = "X";
		}else{
			x_prevoz_material = "";
		}
	}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: skup<br><br><a href="skuplist.jsp">Nazaj na pregled</a></span></p>
<p>
<form>
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_skupina); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Tekst&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_tekst); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">pr 1&nbsp;</td>
		<td class="ewTableAltRow"><% out.print(x_pr1); %>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Ravnanje&nbsp;</td>
		<td class="ewTableAltRow"><%out.print(x_ravnanje);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz kamion&nbsp;</td>
		<td class="ewTableAltRow"><%out.print(x_prevoz_kamion);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Prevoz material&nbsp;</td>
		<td class="ewTableAltRow"><%out.print(x_prevoz_material);%>&nbsp;</td>
	</tr>
</table>
</form>
<p>
<%
	rs.close();
	rs = null;
	stmt.close();
	stmt = null;
	//conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="footer.jsp" %>
