<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
response.setDateHeader("Expires", 0); // date in the past
response.addHeader("Cache-Control", "no-store, no-cache, must-revalidate"); // HTTP/1.1 
response.addHeader("Cache-Control", "post-check=0, pre-check=0"); 
response.addHeader("Pragma", "no-cache"); // HTTP/1.0 
%>
<% Locale locale = Locale.getDefault();
response.setLocale(locale);%>
<% session.setMaxInactiveInterval(30*60); %>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";

// Single delete record
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("papirlist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`koda`=" + "'" + key.replaceAll("'",escapeString) + "'";

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
		String strsql = "SELECT * FROM `papir` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("papirlist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `papir` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("papirlist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Delete from TABLE: papir<br><br><a href="papirlist.jsp">Back to List</a></span></p>
<form action="papirdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">koda</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">papir</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">papir 2</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">pc nizka</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">koda st</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">str dv</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 0</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 1</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 2</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 3</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 4</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 5</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 6</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 7</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">skp 8</span>&nbsp;</td>
	</tr>
<%
int recCount = 0;
while (rs.next()){
	recCount ++;
	String bgcolor = "#FFFFFF"; // Set row color
%>
<%
	if (recCount%2 != 0 ) { // Display alternate color for rows
		bgcolor = "#F5F5F5";
	}
%>
<%
	String x_koda = "";
	String x_papir = "";
	String x_papir2 = "";
	String x_pc_nizka = "";
	String x_koda_st = "";
	String x_str_dv = "";
	String x_skp0 = "";
	String x_skp1 = "";
	String x_skp2 = "";
	String x_skp3 = "";
	String x_skp4 = "";
	String x_skp5 = "";
	String x_skp6 = "";
	String x_skp7 = "";
	String x_skp8 = "";

	// koda
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}
	else{
		x_koda = "";
	}

	// papir
	if (rs.getString("papir") != null){
		x_papir = rs.getString("papir");
	}
	else{
		x_papir = "";
	}

	// papir2
	if (rs.getString("papir2") != null){
		x_papir2 = rs.getString("papir2");
	}
	else{
		x_papir2 = "";
	}

	// pc_nizka
	x_pc_nizka = String.valueOf(rs.getLong("pc_nizka"));

	// koda_st
	if (rs.getString("koda_st") != null){
		x_koda_st = rs.getString("koda_st");
	}
	else{
		x_koda_st = "";
	}

	// str_dv
	x_str_dv = String.valueOf(rs.getLong("str_dv"));

	// skp0
	x_skp0 = String.valueOf(rs.getLong("skp0"));

	// skp1
	x_skp1 = String.valueOf(rs.getLong("skp1"));

	// skp2
	x_skp2 = String.valueOf(rs.getLong("skp2"));

	// skp3
	x_skp3 = String.valueOf(rs.getLong("skp3"));

	// skp4
	x_skp4 = String.valueOf(rs.getLong("skp4"));

	// skp5
	x_skp5 = String.valueOf(rs.getLong("skp5"));

	// skp6
	x_skp6 = String.valueOf(rs.getLong("skp6"));

	// skp7
	x_skp7 = String.valueOf(rs.getLong("skp7"));

	// skp8
	x_skp8 = String.valueOf(rs.getLong("skp8"));
%>
	<tr bgcolor="<%= bgcolor %>">
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="jspmaker"><% out.print(x_koda); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_papir); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_papir2); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_pc_nizka); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_koda_st); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_str_dv); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp0); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp1); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp2); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp3); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp4); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp5); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp6); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp7); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_skp8); %>&nbsp;</td>
  </tr>
<%
}
rs.close();
rs = null;
stmt.close();
stmt = null;
conn.close();
conn = null;
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
</table>
<p>
<input type="submit" name="Action" value="CONFIRM DELETE">
</form>
<%@ include file="footer.jsp" %>
