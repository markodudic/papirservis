<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"  errorPage="skuplist.jsp"%>
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

if ((ewCurSec & ewAllowDelete) != ewAllowDelete) {
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

// Multiple delete records
String key = "";
String [] arRecKey = request.getParameterValues("key");
String sqlKey = "";
if (arRecKey == null || arRecKey.length == 0 ) {
	response.sendRedirect("skuplist.jsp");
	response.flushBuffer();
	return;
}
for (int i = 0; i < arRecKey.length; i++){
	String reckey = arRecKey[i].trim();
	reckey = reckey.replaceAll("'",escapeString);

	// Build the SQL
	sqlKey +=  "(";
	sqlKey +=  "`skupina`=" + "" + reckey + "" + " AND ";
	if (sqlKey.substring(sqlKey.length()-5,sqlKey.length()).equals(" AND " )) { sqlKey = sqlKey.substring(0,sqlKey.length()-5);}
	sqlKey = sqlKey + ") OR ";
}
if (sqlKey.substring(sqlKey.length()-4,sqlKey.length()).equals(" OR ")) { sqlKey = sqlKey.substring(0,sqlKey.length()-4); }

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Display
		String strsql = "SELECT * FROM `skup` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("skuplist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		try{
		String strsql = "DELETE FROM `skup` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		//conn.close();
		conn = null;
		response.sendRedirect("skuplist.jsp");
		response.flushBuffer();
		return;
		}catch (SQLException ex){
			out.println("<table><tr><td><h2>Ni mogoče pobrisati izbrani zapis!!!</h2></td></tr></table>");
			String strsql1 = "SELECT * FROM `skup` WHERE " + sqlKey;
			rs = stmt.executeQuery(strsql1);
			if (!rs.next()) {
				response.sendRedirect("skuplist.jsp");
			}else{
				rs.beforeFirst();
			}
		}		
		
	}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Izbriši iz: skup<br><br><a href="skuplist.jsp">Nazaj na pregled</a></span></p>
<form action="skupdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Skupina&nbsp;</td>
		<td>tekst&nbsp;</td>
		<td>pr 1&nbsp;</td>
		<td>Ravnanje&nbsp;</td>
		<td>Prevoz kamion&nbsp;</td>
		<td>Prevoz material&nbsp;</td>
	</tr>
<%
int recCount = 0;
while (rs.next()){
	recCount ++;
	String rowclass = "ewTableRow"; // Set row color
%>
<%
	if (recCount%2 != 0 ) { // Display alternate color for rows
		rowclass = "ewTableAltRow";
	}
%>
<%
	String x_skupina = "";
	String x_tekst = "";
	String x_pr1 = "";
	String x_ravnanje = "";
	String x_prevoz_kamion = "";
	String x_prevoz_material = "";

	// skupina
	x_skupina = String.valueOf(rs.getLong("skupina"));

	// tekst
	if (rs.getString("tekst") != null){
		x_tekst = rs.getString("tekst");
	}
	else{
		x_tekst = "";
	}

	// pr1
	if (rs.getString("pr1") != null){
		x_pr1 = rs.getString("pr1");
	}
	else{
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



%>
	<tr class="<%= rowclass %>">
	<% key =  arRecKey[recCount-1]; %>
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="<%= rowclass %>"><% out.print(x_skupina); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_tekst); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(x_pr1); %>&nbsp;</td>
		<td><% out.print(x_ravnanje);%>&nbsp;</td>
		<td><% out.print(x_prevoz_kamion);%>&nbsp;</td>
		<td><% out.print(x_prevoz_material);%>&nbsp;</td>
  </tr>
<%
}
rs.close();
rs = null;
stmt.close();
stmt = null;
//conn.close();
conn = null;
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
</table>
<p>
<input type="submit" name="Action" value="Potrdi brisanje">
</form>
<%@ include file="footer.jsp" %>
