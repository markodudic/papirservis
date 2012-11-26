<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" isErrorPage="true"%>
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
			b_search = b_search + "`koda` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`material` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`koda` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`material` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("materiali_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("materiali_REC", new Integer(startRec));
}else{
	if (session.getAttribute("materiali_searchwhere") != null)
		searchwhere = (String) session.getAttribute("materiali_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("materiali_searchwhere", searchwhere);
		session.removeAttribute("materiali_OB");	
		session.removeAttribute("materiali_searchwhere1");	
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("materiali_searchwhere", searchwhere);
		session.removeAttribute("materiali_OB");	
		session.removeAttribute("materiali_searchwhere1");	
	}else if (cmd.toUpperCase().equals("TOP")) {
		searchwhere = " materiali.koda = zadnji.k and materiali.zacetek = zadnji.datum"; // Reset search criteria
		session.setAttribute("materiali_searchwhere1", searchwhere);
	}
	
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("materiali_REC", new Integer(startRec));
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
	if (session.getAttribute("materiali_OB") != null &&
		((String) session.getAttribute("materiali_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("materiali_OT")).equals("ASC")) {
			session.setAttribute("materiali_OT", "DESC");
		}else{
			session.setAttribute("materiali_OT", "ASC");
		}
	}else{
		session.setAttribute("materiali_OT", "ASC");
	}
	session.setAttribute("materiali_OB", OrderBy);
	session.setAttribute("materiali_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("materiali_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("materiali_OB", OrderBy);
		session.setAttribute("materiali_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
String searchwhere1 = (String) session.getAttribute("materiali_searchwhere1");

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `materiali`";
if (searchwhere1 != null && searchwhere1.length() > 0)
	strsql += " , (SELECT koda k, max(zacetek) datum FROM `materiali` group by koda) zadnji ";


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

if (whereClause.length() > 0) {
	if (searchwhere1 != null && searchwhere1.length() > 0)
		strsql = strsql + " AND " + searchwhere1;
}
else {
	if (searchwhere1 != null && searchwhere1.length() > 0)
		strsql = strsql + " WHERE " + searchwhere1;
}


// Filter by user
/*
if (whereClause.length() > 0) {
	strsql += " AND (uporabnik = " + session.getAttribute("papirservis1_status_UserID") + ")" ;
}
else{
	strsql += " WHERE (uporabnik = " + session.getAttribute("papirservis1_status_UserID") + ")" ;
}
*/

if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("materiali_OT");
}else{
	strsql = strsql + " ORDER BY koda";
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
	session.setAttribute("materiali_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("materiali_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("materiali_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("materiali_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("materiali_REC") != null)
		startRec = ((Integer) session.getAttribute("materiali_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("materiali_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>

<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: materiali</span></p>
<form action="materialilist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="materialilist.jsp?cmd=reset">Prikaži vse</a>
		&nbsp;&nbsp;<a href="materialilist.jsp?cmd=top">Prikaži zadnje</a>
		</span></td>
	</tr>
	<!-- tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr-->
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="materialiadd.jsp">Dodaj nov zapis</a></td></tr>
<% } %>
</table>
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
<%=(OrderBy != null && OrderBy.equals("koda")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("koda","UTF-8") %>">Koda&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("material")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("material","UTF-8") %>">Material&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("material")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("material")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("pc_nizka")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("pc_nizka","UTF-8") %>">pc nizka&nbsp;<% if (OrderBy != null && OrderBy.equals("pc_nizka")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("pc_nizka")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("str_dv")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("str_dv","UTF-8") %>">str dv&nbsp;<% if (OrderBy != null && OrderBy.equals("str_dv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("str_dv")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sit_sort")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("sit_sort","UTF-8") %>">sit sort&nbsp;<% if (OrderBy != null && OrderBy.equals("sit_sort")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sit_sort")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sit_zaup")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("sit_zaup","UTF-8") %>">sit zaup&nbsp;<% if (OrderBy != null && OrderBy.equals("sit_zaup")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sit_zaup")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sit_smet")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("sit_smet","UTF-8") %>">sit smet&nbsp;<% if (OrderBy != null && OrderBy.equals("sit_smet")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sit_smet")) ? "</b>" : ""%>
		</td>
<%for (int i=1; i<10; i++) {
String r = "ravnanje"+i;%>
		<td>
<%=(OrderBy != null && OrderBy.equals(r)) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode(r,"UTF-8") %>">Ravnanje <%=i%>&nbsp;<% if (OrderBy != null && OrderBy.equals(r)) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals(r)) ? "</b>" : ""%>
		</td>
<%}%>
		<td>
<%=(OrderBy != null && OrderBy.equals("prevoz1")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("prevoz1","UTF-8") %>">Prevoz 1&nbsp;<% if (OrderBy != null && OrderBy.equals("prevoz1")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("prevoz1")) ? "</b>" : "" %>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("prevoz2")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("prevoz2","UTF-8") %>">Prevoz 2&nbsp;<% if (OrderBy != null && OrderBy.equals("prevoz2")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("koprevoz2da")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("prevoz3")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("prevoz3","UTF-8") %>">Prevoz 3&nbsp;<% if (OrderBy != null && OrderBy.equals("prevoz3")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("prevoz3")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("prevoz4")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("prevoz4","UTF-8") %>">Prevoz 4&nbsp;<% if (OrderBy != null && OrderBy.equals("prevoz4")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("prevoz4")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("veljavnost")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("veljavnost","UTF-8") %>">Veljavnost&nbsp;<% if (OrderBy != null && OrderBy.equals("veljavnost")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("veljavnost")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("zacetek","UTF-8") %>">Začetek&nbsp;<% if (OrderBy != null && OrderBy.equals("zacetek")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("uporabnik","UTF-8") %>">Uporabnik&nbsp;<% if (OrderBy != null && OrderBy.equals("uporabnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("materiali_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("materiali_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "</b>" : ""%>
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
	String x_koda = "";
	String x_material = "";
	String x_pc_nizka = "";
	String x_str_dv = "";
	String x_sit_sort = "";
	String x_sit_zaup = "";
	String x_sit_smet = "";
	String[] x_ravnanje = {"","","","","","","","",""};
	String x_prevoz1 = "";
	String x_prevoz2 = "";
	String x_prevoz3 = "";
	String x_prevoz4 = "";
	Object x_zacetek = null;
	String x_uporabnik = "";
	Object x_veljavnost = null;

	// Load Key for record
	String key = "";
	if(rs.getString("koda") != null){
		key = rs.getString("koda");
	}

	// koda
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}

	// material
	if (rs.getString("material") != null){
		x_material = rs.getString("material");
	}else{
		x_material = "";
	}

	// pc_nizka
	x_pc_nizka = String.valueOf(rs.getDouble("pc_nizka"));

	// str_dv
	x_str_dv = String.valueOf(rs.getDouble("str_dv"));

	// sit_sort
	x_sit_sort = String.valueOf(rs.getDouble("sit_sort"));

	// sit_zaup
	x_sit_zaup = String.valueOf(rs.getDouble("sit_zaup"));

	// sit_smet
	x_sit_smet = String.valueOf(rs.getDouble("sit_smet"));

	// ravnanje
	for (int i=1; i<10; i++) {
		x_ravnanje[i-1] = String.valueOf(rs.getDouble("ravnanje"+i));
	}
	// prevoz1
	x_prevoz1 = String.valueOf(rs.getDouble("prevoz1"));

	// prevoz2
	x_prevoz2 = String.valueOf(rs.getDouble("prevoz2"));

	// prevoz3
	x_prevoz3 = String.valueOf(rs.getDouble("prevoz3"));

	// prevoz4
	x_prevoz4 = String.valueOf(rs.getDouble("prevoz4"));

	// zacetek
	if (rs.getTimestamp("zacetek") != null){
		x_zacetek = rs.getTimestamp("zacetek");
	}else{
		x_zacetek = "";
	}

	// veljavnost
	if (rs.getTimestamp("veljavnost") != null){
		x_veljavnost = rs.getTimestamp("veljavnost");
	}else{
		x_veljavnost = "";
	}
	// uporabnik
	x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("materialiview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("materialiedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("materialiadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Briši</span></td>
<% } %>
		<td><% out.print(x_koda); %>&nbsp;</td>
		<td><% out.print(x_material); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_pc_nizka, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_str_dv, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_sit_sort, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_sit_zaup, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_sit_smet, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<%for (int i=0; i<9; i++) {%>
			<td><% out.print(EW_FormatNumber("" + x_ravnanje[i], 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<%}%>
		<td><% out.print(EW_FormatNumber("" + x_prevoz1, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_prevoz2, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_prevoz3, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_prevoz4, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_veljavnost,7,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_zacetek,7,locale)); %>&nbsp;</td>
		<td><%
if (x_uporabnik!=null && ((String)x_uporabnik).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_upor` = " + x_uporabnik;
	String sqlwrk = "SELECT `sif_upor`, `ime_in_priimek` FROM `uporabniki`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("ime_in_priimek"));
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
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='materialidelete.jsp';this.form.submit();"></p>
<% } %>
<% } %>
</form>
<%

// Close recordset and connection
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
	<td><a href="materialilist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="materialilist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="materialilist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="materialilist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
	<td><span class="jspmaker">&nbsp;od <%=(totalRecs-1)/displayRecs+1%></span></td>
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
<a href="materialiadd.jsp">Dodaj nov zapis</a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>