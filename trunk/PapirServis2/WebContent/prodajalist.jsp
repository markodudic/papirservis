<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" isErrorPage="true"%>
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

%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
int displayRecs = 20;
int recRange = 10;
%>
<%
String tmpfld = null;
String escapeString = "\\\\'";
String dbwhere = "";
String masterdetailwhere = "";
String searchwhere = "";
String a_search = "";
String b_search = "";
String whereClause = "";
int startRec = 0, stopRec = 0, totalRecs = 0, recCount = 0;
%>
<%

// Get search criteria for basic search
String pSearch = request.getParameter("psearch");
String pSearchType = request.getParameter("psearchtype");
if (pSearch != null && pSearch.length() > 0) {
	pSearch = pSearch.replaceAll("'",escapeString);
	if (pSearchType != null && pSearchType.length() > 0) {
		while (pSearch.indexOf("  ") > 0) {
			pSearch = pSearch.replaceAll("  ", " ");
		}
		String [] arpSearch = pSearch.trim().split(" ");
		for (int i = 0; i < arpSearch.length; i++){
			String kw = arpSearch[i].trim();
			b_search = b_search + "(";
			b_search = b_search + "`sif_kupca` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`koda` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`ewc` LIKE '%" + kw + "%' OR ";
			//b_search = b_search + "`reg_st` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`st_dob` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`sif_kupca` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`koda` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`ewc` LIKE '%" + pSearch + "%' OR ";
		//b_search = b_search + "`reg_st` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`st_dob` LIKE '%" + pSearch + "%' OR ";
	}
}
if (b_search.length() > 4 && b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) {b_search = b_search.substring(0, b_search.length()-4);}
if (b_search.length() > 5 && b_search.substring(b_search.length()-5,b_search.length()).equals(" AND ")) {b_search = b_search.substring(0, b_search.length()-5);}
%>
<%

// Build search criteria
if (a_search != null && a_search.length() > 0) {
	searchwhere = a_search; // Advanced search
}else if (b_search != null && b_search.length() > 0) {
	searchwhere = b_search; // Basic search
}

// Save search criteria
if (searchwhere != null && searchwhere.length() > 0) {
	session.setAttribute("prodaja_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("prodaja_REC", new Integer(startRec));
}else{
	if (session.getAttribute("prodaja_searchwhere") != null)
		searchwhere = (String) session.getAttribute("prodaja_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("prodaja_searchwhere", searchwhere);
		session.removeAttribute("prodaja_OB");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("prodaja_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("prodaja_REC", new Integer(startRec));
}

// Build dbwhere
if (masterdetailwhere != null && masterdetailwhere.length() > 0) {
	dbwhere = dbwhere + "(" + masterdetailwhere + ") AND ";
}
if (searchwhere != null && searchwhere.length() > 0) {
	dbwhere = dbwhere + "(" + searchwhere + ") AND ";
}
if (dbwhere != null && dbwhere.length() > 5) {
	dbwhere = dbwhere.substring(0, dbwhere.length()-5); // Trim rightmost AND
}
%>
<%

// Load Default Order
String DefaultOrder = "st_dob";
String DefaultOrderType = "DESC";

// No Default Filter
String DefaultFilter = "";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("prodaja_OB") != null &&
		((String) session.getAttribute("prodaja_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) {
			session.setAttribute("prodaja_OT", "DESC");
		}else{
			session.setAttribute("prodaja_OT", "ASC");
		}
	}else{
		session.setAttribute("prodaja_OT", "ASC");
	}
	session.setAttribute("prodaja_OB", OrderBy);
	session.setAttribute("prodaja_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("prodaja_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("prodaja_OB", OrderBy);
		session.setAttribute("prodaja_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM " + session.getAttribute("letoTabelaProdaja") + " prodaja";
whereClause = "";
if (DefaultFilter.length() > 0) {
	whereClause = whereClause + "(" + DefaultFilter + ") AND ";
}
if (dbwhere.length() > 0) {
	whereClause = whereClause + "(" + dbwhere + ") AND ";
}
if ((ewCurSec & ewAllowList) != ewAllowList) {
	whereClause = whereClause + "(0=1) AND ";
}
if (whereClause.length() > 5 && whereClause.substring(whereClause.length()-5, whereClause.length()).equals(" AND ")) {
	whereClause = whereClause.substring(0, whereClause.length()-5);
}
if (whereClause.length() > 0) {
	strsql = strsql + " WHERE " + whereClause;
}
if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("prodaja_OT");
}


rs = stmt.executeQuery(strsql);
rs.last();
totalRecs = rs.getRow();
rs.beforeFirst();
startRec = 0;
int pageno = 0;

// Check for a START parameter
if (request.getParameter("start") != null && Integer.parseInt(request.getParameter("start")) > 0) {
	startRec = Integer.parseInt(request.getParameter("start"));
	session.setAttribute("prodaja_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("prodaja_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("prodaja_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("prodaja_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("prodaja_REC") != null)
		startRec = ((Integer) session.getAttribute("prodaja_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("prodaja_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Pregled: prodaja</span></p>
<form action="prodajalist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="prodajalist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
</table>
</form>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
<table class="ewTable">
	<tr></tr>
	<tr><td><a href="prodajaaddnew.jsp">Dodaj nov zapis</a></td></tr>
</table>
<% } %>
<form method="post">
<table class="ewTable">
	<tr class="ewTableHeader">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td>&nbsp;</td>
<% } %>
		<td>
<%=(OrderBy != null && OrderBy.equals("st_dob")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("st_dob","utf-8") %>">Številka dobavnice&nbsp;<% if (OrderBy != null && OrderBy.equals("st_dob")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("st_dob")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("pozicija")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("pozicija","utf-8") %>">Pozicija&nbsp;<% if (OrderBy != null && OrderBy.equals("pozicija")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("pozicija")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("datum","utf-8") %>">Datum&nbsp;<% if (OrderBy != null && OrderBy.equals("datum")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","utf-8") %>">Kupec&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("koda","utf-8") %>">Koda&nbsp;<% if (OrderBy != null && OrderBy.equals("koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("koda","utf-8") %>">Material&nbsp;<% if (OrderBy != null && OrderBy.equals("koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("ewc")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("koda","UTF-8") %>">EWC&nbsp;<% if (OrderBy != null && OrderBy.equals("ewc")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("ewc")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("ewc")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("koda","UTF-8") %>">Material&nbsp;<% if (OrderBy != null && OrderBy.equals("ewc")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("ewc")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("reg_st")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("reg_st","utf-8") %>">Registracijska številka&nbsp;<% if (OrderBy != null && OrderBy.equals("reg_st")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("reg_st")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_n")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("kol_n","utf-8") %>">kol n&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_n")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_n")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_p")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("kol_p","utf-8") %>">kol p&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_p")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_p")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("st_bal")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("st_bal","utf-8") %>">st bal&nbsp;<% if (OrderBy != null && OrderBy.equals("st_bal")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("st_bal")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "<b>" : ""%>
<a href="prodajalist.jsp?order=<%= java.net.URLEncoder.encode("sif_enote","utf-8") %>">Enota&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_enote")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("prodaja_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("prodaja_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "</b>" : ""%>
		</td>
</tr>
<%

// Avoid starting record > total records
if (startRec > totalRecs) {
	startRec = totalRecs;
}

// Set the last record to display
stopRec = startRec + displayRecs - 1;

// Move to first record directly for performance reason
recCount = startRec - 1;
if (rs.next()) {
	rs.first();
	rs.relative(startRec - 1);
}
long recActual = 0;
if (startRec == 1)
   rs.beforeFirst();
else
   rs.previous();
while (rs.next() && recCount < stopRec) {
	recCount++;
	if (recCount >= startRec) {
		recActual++;
%>
<%
	String rowclass = "ewTableRow"; // Set row color
%>
<%
	if (recCount%2 != 0) { // Display alternate color for rows
		rowclass = "ewTableAltRow";
	}
%>
<%
	String x_id = "";
	String x_st_dob = "";
	String x_pozicija = "";
	Object x_datum = null;
	String x_sif_kupca = "";
	String x_koda = "";
	String x_ewc = "";
	String x_reg_st = "";
	String x_kol_n = "";
	String x_kol_p = "";
	String x_st_bal = "";
	String x_sif_enote = "";

	// Load Key for record
	String key = "";
	key = String.valueOf(rs.getLong("id"));

	// id
	x_id = String.valueOf(rs.getLong("id"));

	// st_dob
	x_st_dob = String.valueOf(rs.getLong("st_dob"));

	// pozicija
	x_pozicija = String.valueOf(rs.getLong("pozicija"));

	// datum
	if (rs.getTimestamp("datum") != null){
		x_datum = rs.getTimestamp("datum");
	}else{
		x_datum = "";
	}

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}

	// koda
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}

	// ewc
	if (rs.getString("ewc") != null){
		x_ewc = rs.getString("ewc");
	}else{
		x_ewc = "";
	}

	// reg_st
	if (rs.getString("reg_st") != null){
		x_reg_st = rs.getString("reg_st");
	}else{
		x_reg_st = "";
	}

	// kol_n
	x_kol_n = String.valueOf(rs.getLong("kol_n"));

	// kol_p
	x_kol_p = String.valueOf(rs.getLong("kol_p"));

	// st_bal
	x_st_bal = String.valueOf(rs.getLong("st_bal"));

	// sif_enote
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("prodajaview.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("prodajaedit.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("prodajaadd.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Briši</span></td>
<% } %>
<td><span class="jspmaker"><a href="printDelovniNalog.jsp?type=1&reportID=5&report=<%="/"%>reports<%="/"%>dobavnica_prodaja&x_sif_dob=<%=x_st_dob%>">Tiskaj</a></span></td>
		<td><% out.print(x_st_dob); %>&nbsp;</td>
		<td><% out.print(x_pozicija); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_datum,7,locale)); %>&nbsp;</td>
		<td><%
if (x_sif_kupca!=null && ((String)x_sif_kupca).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_kupca;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_kupca` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `sif_kupca`, `naziv` FROM `kupci`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("naziv"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
		<td><% out.print(x_koda); %>&nbsp;</td>
		<td><%
if (x_koda!=null && ((String)x_koda).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_koda;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`koda` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `koda`, `material` FROM `materiali`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("material"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
		<td><% out.print(x_ewc); %>&nbsp;</td>
		<td><%
if (x_ewc!=null && ((String)x_ewc).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_ewc;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`koda` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `koda`, `material` FROM `okolje`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("material"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
		<td><% out.print(x_reg_st); %>&nbsp;</td>
		<td><% out.print(x_kol_n); %>&nbsp;</td>
		<td><% out.print(x_kol_p); %>&nbsp;</td>
		<td><% out.print(x_st_bal); %>&nbsp;</td>
		<td><%
if (x_sif_enote!=null && ((String)x_sif_enote).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_enote` = " + x_sif_enote;
	String sqlwrk = "SELECT DISTINCT `sif_enote`, `naziv`, `lokacija` FROM `enote`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("naziv"));
		//out.print(", " + rswrk.getString("lokacija"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='prodajadelete.jsp';this.form.submit();"></p>
<% } %>
<% } %>
</form>
<%

// Close recordset and connection
rs.close();
rs = null;
stmt.close();
stmt = null;
conn.close();
conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
<table border="0" cellspacing="0" cellpadding="10"><tr><td>
<%
boolean rsEof = false;
if (totalRecs > 0) {
	rsEof = (totalRecs < (startRec + displayRecs));
	int PrevStart = startRec - displayRecs;
	if (PrevStart < 1) { PrevStart = 1;}
	int NextStart = startRec + displayRecs;
	if (NextStart > totalRecs) { NextStart = startRec;}
	int LastStart = ((totalRecs-1)/displayRecs)*displayRecs+1;
	%>
<form>
	<table border="0" cellspacing="0" cellpadding="0"><tr><td><span class="jspmaker">Stran</span>&nbsp;</td>
<!--first page button-->
	<% if (startRec==1) { %>
	<td><img src="images/firstdisab.gif" alt="First" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="prodajalist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="prodajalist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="prodajalist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="prodajalist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
	<td><span class="jspmaker">&nbsp;of <%=(totalRecs-1)/displayRecs+1%></span></td>
	</tr></table>
</form>
	<% if (startRec > totalRecs) { startRec = totalRecs;}
	stopRec = startRec + displayRecs - 1;
	recCount = totalRecs - 1;
	if (rsEof) { recCount = totalRecs;}
	if (stopRec > recCount) { stopRec = recCount;} %>
	<span class="jspmaker">Zapisi <%= startRec %> do <%= stopRec %> od <%= totalRecs %></span>
<% }else{ %>
	<% if ((ewCurSec & ewAllowList) == ewAllowList) { %>
	<span class="jspmaker">Ni vstreznih zapisov</span>
	<% }else{ %>
	<span class="jspmaker">Nimate vstreznih pravic</span>
	<% } %>
<p>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
<a href="prodajaadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
