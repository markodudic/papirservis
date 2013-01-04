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
			b_search = b_search + "`sif_enote` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`naziv` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`lokacija` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dovoljenje` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`sif_enote` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`naziv` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`lokacija` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dovoljenje` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("enote_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("enote_REC", new Integer(startRec));
}else{
	if (session.getAttribute("enote_searchwhere") != null)
		searchwhere = (String) session.getAttribute("enote_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("enote_searchwhere", searchwhere);
		session.removeAttribute("enote_OB");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("enote_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("enote_REC", new Integer(startRec));
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
	if (session.getAttribute("enote_OB") != null &&
		((String) session.getAttribute("enote_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("enote_OT")).equals("ASC")) {
			session.setAttribute("enote_OT", "DESC");
		}else{
			session.setAttribute("enote_OT", "ASC");
		}
	}else{
		session.setAttribute("enote_OT", "ASC");
	}
	session.setAttribute("enote_OB", OrderBy);
	session.setAttribute("enote_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("enote_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("enote_OB", OrderBy);
		session.setAttribute("enote_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `enote`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("enote_OT");
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
	session.setAttribute("enote_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("enote_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("enote_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("enote_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("enote_REC") != null)
		startRec = ((Integer) session.getAttribute("enote_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("enote_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: enote</span></p>
<form action="enotelist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="enotelist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
	<!-- tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr-->
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="enoteadd.jsp">Dodaj nov zapis</a></td></tr>
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
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "<b>" : ""%>
<a href="enotelist.jsp?order=<%= java.net.URLEncoder.encode("sif_enote","UTF-8") %>">Šifra enote&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_enote")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("enote_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("enote_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "<b>" : ""%>
<a href="enotelist.jsp?order=<%= java.net.URLEncoder.encode("naziv","UTF-8") %>">Naziv&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("naziv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("enote_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("enote_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("lokacija")) ? "<b>" : ""%>
<a href="enotelist.jsp?order=<%= java.net.URLEncoder.encode("lokacija","UTF-8") %>">Lokacija&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("lokacija")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("enote_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("enote_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("lokacija")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("maticna")) ? "<b>" : ""%>
<a href="kamionlist.jsp?order=<%= java.net.URLEncoder.encode("maticna","UTF-8") %>">Matična&nbsp;<% if (OrderBy != null && OrderBy.equals("maticna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("maticna")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dejavnost")) ? "<b>" : ""%>
<a href="kamionlist.jsp?order=<%= java.net.URLEncoder.encode("dejavnost","UTF-8") %>">Dejavnost&nbsp;<% if (OrderBy != null && OrderBy.equals("dejavnost")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dejavnost")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dovoljenje")) ? "<b>" : ""%>
<a href="enotelist.jsp?order=<%= java.net.URLEncoder.encode("dovoljenje","UTF-8") %>">Dovoljenje&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("dovoljenje")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("enote_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("enote_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dovoljenje")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_prjm_st")) ? "<b>" : ""%>
<a href="kamionlist.jsp?order=<%= java.net.URLEncoder.encode("arso_prjm_st","UTF-8") %>">Arso št.&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_prjm_st")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_prjm_st")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_prjm_status")) ? "<b>" : ""%>
<a href="kamionlist.jsp?order=<%= java.net.URLEncoder.encode("arso_prjm_status","UTF-8") %>">Arso status&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_prjm_status")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_prjm_status")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_aktivnost_prjm")) ? "<b>" : ""%>
<a href="kamionlist.jsp?order=<%= java.net.URLEncoder.encode("arso_aktivnost_prjm","UTF-8") %>">Arso postopek ravnanja&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_aktivnost_prjm")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_aktivnost_prjm")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_odp_locpr_id")) ? "<b>" : ""%>
<a href="kamionlist.jsp?order=<%= java.net.URLEncoder.encode("arso_odp_locpr_id","UTF-8") %>">Arso lokacija ravnanja&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_odp_locpr_id")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_odp_locpr_id")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("x_koord")) ? "<b>" : ""%>
<a href="enotelist.jsp?order=<%= java.net.URLEncoder.encode("x_koord","UTF-8") %>">X koordinata&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("x_koord")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("enote_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("enote_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("x_koord")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("y_koord")) ? "<b>" : ""%>
<a href="enotelist.jsp?order=<%= java.net.URLEncoder.encode("y_koord","UTF-8") %>">Y koordinata&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("y_koord")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("enote_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("enote_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("y_koord")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("radij")) ? "<b>" : ""%>
<a href="enotelist.jsp?order=<%= java.net.URLEncoder.encode("radij","UTF-8") %>">Radij&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("radij")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("enote_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("enote_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("radij")) ? "</b>" : ""%>
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
	String x_sif_enote = "";
	String x_naziv = "";
	String x_lokacija = "";
	String x_maticna = "";
	String x_dejavnost = "";
	String x_dovoljenje = "";
	String x_arso_prjm_st = "";
	String x_arso_prjm_status = "";
	String x_arso_aktivnost_prjm = "";
	String x_arso_odp_locpr_id = "";
	String x_x_koord = "";
	String x_y_koord = "";
	String x_radij = "";

	// Load Key for record
	String key = "";
	key = String.valueOf(rs.getLong("sif_enote"));

	// sif_enote
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));

	// naziv
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}

	// lokacija
	if (rs.getString("lokacija") != null){
		x_lokacija = rs.getString("lokacija");
	}else{
		x_lokacija = "";
	}

	// maticna
	if (rs.getString("maticna") != null){
		x_maticna = rs.getString("maticna");
	}else{
		x_maticna = "";
	}

	// dejavnost
	if (rs.getString("dejavnost") != null){
		x_dejavnost = rs.getString("dejavnost");
	}else{
		x_dejavnost = "";
	}

	// arso_prjm_st
	if (rs.getString("arso_prjm_st") != null){
		x_arso_prjm_st = rs.getString("arso_prjm_st");
	}else{
		x_arso_prjm_st = "";
	}

	// arso_prjm_status
	if (rs.getString("arso_prjm_status") != null){
		x_arso_prjm_status = rs.getString("arso_prjm_status");
	}else{
		x_arso_prjm_status = "";
	}

	// arso_aktivnost_prjm
	if (rs.getString("arso_aktivnost_prjm") != null){
		x_arso_aktivnost_prjm = rs.getString("arso_aktivnost_prjm");
	}else{
		x_arso_aktivnost_prjm = "";
	}

	// arso_odp_locpr_id
	if (rs.getString("arso_odp_locpr_id") != null){
		x_arso_odp_locpr_id = rs.getString("arso_odp_locpr_id");
	}else{
		x_arso_odp_locpr_id = "";
	}

	if (rs.getString("dovoljenje") != null){
		x_dovoljenje = (String) rs.getString("dovoljenje");
	}else{
		x_dovoljenje = "";
	}
	
	// lokacija
	if (rs.getString("x_koord") != null){
		x_x_koord = rs.getString("x_koord");
	}else{
		x_x_koord = "";
	}
	
	// lokacija
	if (rs.getString("y_koord") != null){
		x_y_koord = rs.getString("y_koord");
	}else{
		x_y_koord = "";
	}
	
	
	// lokacija
	if (rs.getString("radij") != null){
		x_radij = rs.getString("radij");
	}else{
		x_radij = "";
	}
	
%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_enote"); 
if (key != null && key.length() > 0) { 
	out.print("enoteview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_enote"); 
if (key != null && key.length() > 0) { 
	out.print("enoteedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_enote"); 
if (key != null && key.length() > 0) { 
	out.print("enoteadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Briši</span></td>
<% } %>
		<td><% out.print(x_sif_enote); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td><% out.print(x_lokacija); %>&nbsp;</td>
		<td><% out.print(x_maticna); %>&nbsp;</td>
		<td><% out.print(x_dejavnost); %>&nbsp;</td>
		<td><% out.print(x_dovoljenje); %>&nbsp;</td>
		<td><% out.print(x_arso_prjm_st); %>&nbsp;</td>
		<td><% out.print(x_arso_prjm_status); %>&nbsp;</td>
		<td><% out.print(x_arso_aktivnost_prjm); %>&nbsp;</td>
		<td><% out.print(x_arso_odp_locpr_id); %>&nbsp;</td>
		<td><% out.print(x_x_koord); %>&nbsp;</td>
		<td><% out.print(x_y_koord); %>&nbsp;</td>
		<td><% out.print(x_radij); %>&nbsp;</td>
	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='enotedelete.jsp';this.form.submit();"></p>
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
	<td><a href="enotelist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="enotelist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="enotelist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="enotelist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<a href="enoteadd.jsp">Dodaj nov zapis</a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>