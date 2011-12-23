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
<% String userid = (String) session.getAttribute("papirservis1_status_UserID"); 
Integer userlevel = (Integer) session.getAttribute("papirservis1_status_UserLevel"); 
if (userid == null && userlevel != null && (userlevel.intValue() != -1) ) {	response.sendRedirect("login.jsp");
	response.flushBuffer(); 
	return; 
}%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

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
			b_search = b_search + "`ime_in_priimek` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`uporabnisko_ime` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`geslo` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`tip` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`aktiven` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`ime_in_priimek` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`uporabnisko_ime` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`geslo` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`tip` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`aktiven` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("uporabniki_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("uporabniki_REC", new Integer(startRec));
}else{
	if (session.getAttribute("uporabniki_searchwhere") != null)
		searchwhere = (String) session.getAttribute("uporabniki_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("uporabniki_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("uporabniki_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("uporabniki_REC", new Integer(startRec));
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
	if (session.getAttribute("uporabniki_OB") != null &&
		((String) session.getAttribute("uporabniki_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) {
			session.setAttribute("uporabniki_OT", "DESC");
		}else{
			session.setAttribute("uporabniki_OT", "ASC");
		}
	}else{
		session.setAttribute("uporabniki_OT", "ASC");
	}
	session.setAttribute("uporabniki_OB", OrderBy);
	session.setAttribute("uporabniki_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("uporabniki_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("uporabniki_OB", OrderBy);
		session.setAttribute("uporabniki_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `uporabniki`";
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
/*
if (userlevel == null || userlevel.intValue() != -1) { // Non system admin
	whereClause = whereClause + "(`sif_upor` = " + (String) session.getAttribute("papirservis1_status_UserID") + ") AND ";
}
*/
if (whereClause.length() > 5 && whereClause.substring(whereClause.length()-5, whereClause.length()).equals(" AND ")) {
	whereClause = whereClause.substring(0, whereClause.length()-5);
}
if (whereClause.length() > 0) {
	strsql = strsql + " WHERE " + whereClause;
}
if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("uporabniki_OT");
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
	session.setAttribute("uporabniki_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("uporabniki_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("uporabniki_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("uporabniki_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("uporabniki_REC") != null)
		startRec = ((Integer) session.getAttribute("uporabniki_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("uporabniki_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Pregled: uporabniki</span></p>
<form action="uporabnikilist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="uporabnikilist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
	<!-- tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr-->
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="uporabnikiadd.jsp">Dodaj nov zapis</a></td></tr>
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

<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td>&nbsp;</td>
<% } %>
		<td>
<%=(OrderBy != null && OrderBy.equals("ime_in_priimek")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("ime_in_priimek","UTF-8") %>">ime in priimek&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("ime_in_priimek")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("ime_in_priimek")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("uporabnisko_ime")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("uporabnisko_ime","UTF-8") %>">uporabnisko ime&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("uporabnisko_ime")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("uporabnisko_ime")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("geslo")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("geslo","UTF-8") %>">geslo&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("geslo")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("geslo")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("tip")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("tip","UTF-8") %>">tip&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("tip")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("tip")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("meni")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("meni","UTF-8") %>">meni&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("meni")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("meni")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("aktiven")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("aktiven","UTF-8") %>">aktiven&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("aktiven")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("aktiven")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("porocila")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("porocila","UTF-8") %>">poročila&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("porocila")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("porocila")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("narocila")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("narocila","UTF-8") %>">naročila&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("narocila")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("narocila")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("vse")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("vse","UTF-8") %>">vse stranke&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("vse")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("vse")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("enote")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("enote","UTF-8") %>">vse enote&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("enote")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("enote")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("sif_enote","UTF-8") %>">šifra enote&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_enote")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kupec")) ? "<b>" : ""%>
<a href="uporabnikilist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupec","UTF-8") %>">podjetje&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_kupec")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("uporabniki_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("uporabniki_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupec")) ? "</b>" : ""%>
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
	String x_sif_upor = "";
	String x_ime_in_priimek = "";
	String x_uporabnisko_ime = "";
	String x_geslo = "";
	String x_tip = "";
	String x_meni = "";
	String x_aktiven = "";
	String x_porocila = "";
	String x_narocila = "";
	String x_vse = "";
	String x_enote= "";
	String x_sif_enote = "";
	String x_sif_kupca = "";

	// Load Key for record
	String key = "";
	key = String.valueOf(rs.getLong("sif_upor"));

	// sif_upor
	x_sif_upor = String.valueOf(rs.getLong("sif_upor"));

	// ime_in_priimek
	if (rs.getString("ime_in_priimek") != null){
		x_ime_in_priimek = rs.getString("ime_in_priimek");
	}else{
		x_ime_in_priimek = "";
	}

	// uporabnisko_ime
	if (rs.getString("uporabnisko_ime") != null){
		x_uporabnisko_ime = rs.getString("uporabnisko_ime");
	}else{
		x_uporabnisko_ime = "";
	}

	// geslo
	if (rs.getString("geslo") != null){
		x_geslo = rs.getString("geslo");
	}else{
		x_geslo = "";
	}

	// tip
	if (rs.getString("tip") != null){
		x_tip = rs.getString("tip");
	}else{
		x_tip = "";
	}

	// meni
	if (rs.getString("meni") != null){
		x_meni = rs.getString("meni");
	}else{
		x_meni = "";
	}

	// aktiven
	if (rs.getBoolean("aktiven")){
		x_aktiven = "X";
	}else{
		x_aktiven = "";
	}

	// porocila
	if (rs.getBoolean("porocila")){
		x_porocila = "X";
	}else{
		x_porocila = "";
	}

	// narocila
	if (rs.getBoolean("narocila")){
		x_narocila = "X";
	}else{
		x_narocila = "";
	}
	
	// vse
	if (rs.getBoolean("vse")){
		x_vse = "X";
	}else{
		x_vse = "";
	}

	// enote
	if (rs.getBoolean("enote")){
		x_enote = "X";
	}else{
		x_enote = "";
	}

	// sif_enote
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
	
	// sif_kupca
	x_sif_kupca = String.valueOf(rs.getLong("sif_kupca"));	
%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_upor"); 
if (key != null && key.length() > 0) { 
	out.print("uporabnikiview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_upor"); 
if (key != null && key.length() > 0) { 
	out.print("uporabnikiedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Briši</span></td>
<% } %>
		<td><% out.print(x_ime_in_priimek); %>&nbsp;</td>
		<td><% out.print(x_uporabnisko_ime); %>&nbsp;</td>
		<td><% out.print(x_geslo); %>&nbsp;</td>
		<td><% out.print(x_tip); %>&nbsp;</td>
		<td><% out.print(x_meni); %>&nbsp;</td>
		<td><% out.print(x_aktiven);%>&nbsp;</td>
		<td><% out.print(x_porocila);%>&nbsp;</td>		
		<td><% out.print(x_narocila);%>&nbsp;</td>		
		<td><% out.print(x_vse);%>&nbsp;</td>
		<td><% out.print(x_enote);%>&nbsp;</td>		
<td><%
if (x_sif_enote!=null && ((String)x_sif_enote).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_enote` = " + x_sif_enote;
	String sqlwrk = "SELECT `sif_enote`, `naziv` FROM `enote`";
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
<td>
<%
if (x_sif_kupca!=null && ((String)x_sif_kupca).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_kupca` = " + x_sif_kupca;
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
	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='uporabnikidelete.jsp';this.form.submit();"></p>
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
	<td><a href="uporabnikilist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="uporabnikilist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="uporabnikilist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="uporabnikilist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<a href="uporabnikiadd.jsp">Dodaj nov zapis</a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
