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
			b_search = b_search + "`material_koda` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`okolje_koda` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`material_koda` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`okolje_koda` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("material_koda_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("material_koda_REC", new Integer(startRec));
}else{
	if (session.getAttribute("material_koda_searchwhere") != null)
		searchwhere = (String) session.getAttribute("material_koda_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("material_koda_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("material_koda_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("material_koda_REC", new Integer(startRec));
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
String DefaultOrder = "";
String DefaultOrderType = "";

// No Default Filter
String DefaultFilter = "";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("material_koda_OB") != null &&
		((String) session.getAttribute("material_koda_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("material_koda_OT")).equals("ASC")) {
			session.setAttribute("material_koda_OT", "DESC");
		}else{
			session.setAttribute("material_koda_OT", "ASC");
		}
	}else{
		session.setAttribute("material_koda_OT", "ASC");
	}
	session.setAttribute("material_koda_OB", OrderBy);
	session.setAttribute("material_koda_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("material_koda_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("material_koda_OB", OrderBy);
		session.setAttribute("material_koda_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `material_koda`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("material_koda_OT");
}

//out.println(strsql);
rs = stmt.executeQuery(strsql);
rs.last();
totalRecs = rs.getRow();
rs.beforeFirst();
startRec = 0;
int pageno = 0;

// Check for a START parameter
if (request.getParameter("start") != null && Integer.parseInt(request.getParameter("start")) > 0) {
	startRec = Integer.parseInt(request.getParameter("start"));
	session.setAttribute("material_koda_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("material_koda_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("material_koda_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("material_koda_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("material_koda_REC") != null)
		startRec = ((Integer) session.getAttribute("material_koda_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("material_koda_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABLE: material koda</span></p>
<form action="material_kodalist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Quick Search (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="GO">
		&nbsp;&nbsp;<a href="material_kodalist.jsp?cmd=reset">Show all</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr>
</table>
</form>
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
		<td>
<a href="material_kodalist.jsp?order=<%= java.net.URLEncoder.encode("material_koda","utf-8") %>">material koda&nbsp;<% if (OrderBy != null && OrderBy.equals("material_koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("material_koda_OT")).equals("ASC")) { %>5<% }else if (((String) session.getAttribute("material_koda_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</td>
		<td>
<a href="material_kodalist.jsp?order=<%= java.net.URLEncoder.encode("okolje_koda","utf-8") %>">okolje koda&nbsp;<% if (OrderBy != null && OrderBy.equals("okolje_koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("material_koda_OT")).equals("ASC")) { %>5<% }else if (((String) session.getAttribute("material_koda_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	String x_material_koda = "";
	String x_okolje_koda = "";

	// Load Key for record
	String key = "";
	key = String.valueOf(rs.getLong("id"));

	// id
	x_id = String.valueOf(rs.getLong("id"));

	// material_koda
	if (rs.getString("material_koda") != null){
		x_material_koda = rs.getString("material_koda");
	}else{
		x_material_koda = "";
	}

	// okolje_koda
	if (rs.getString("okolje_koda") != null){
		x_okolje_koda = rs.getString("okolje_koda");
	}else{
		x_okolje_koda = "";
	}
%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("material_kodaview.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">View</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("material_kodaedit.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Edit</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("material_kodaadd.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Copy</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Delete</span></td>
<% } %>
		<td><%
if (x_material_koda!=null && ((String)x_material_koda).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_material_koda;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`material` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `material` FROM `materiali`";
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
		<td><%
if (x_okolje_koda!=null && ((String)x_okolje_koda).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_okolje_koda;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`material` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `material` FROM `okolje`";
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
	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="DELETE SELECTED" onClick="this.form.action='material_kodadelete.jsp';this.form.submit();"></p>
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
	<table border="0" cellspacing="0" cellpadding="0"><tr><td><span class="jspmaker">Page</span>&nbsp;</td>
<!--first page button-->
	<% if (startRec==1) { %>
	<td><img src="images/firstdisab.gif" alt="First" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="material_kodalist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="material_kodalist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="material_kodalist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="material_kodalist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="material_kodaadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
<% } %>
	<td><span class="jspmaker">&nbsp;of <%=(totalRecs-1)/displayRecs+1%></span></td>
	</td></tr></table>
</form>
	<% if (startRec > totalRecs) { startRec = totalRecs;}
	stopRec = startRec + displayRecs - 1;
	recCount = totalRecs - 1;
	if (rsEof) { recCount = totalRecs;}
	if (stopRec > recCount) { stopRec = recCount;} %>
	<span class="jspmaker">Records <%= startRec %> to <%= stopRec %> of <%= totalRecs %></span>
<% }else{ %>
	<% if ((ewCurSec & ewAllowList) == ewAllowList) { %>
	<span class="jspmaker">No records found</span>
	<% }else{ %>
	<span class="jspmaker">No Permission</span>
	<% } %>
<p>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
<a href="material_kodaadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
