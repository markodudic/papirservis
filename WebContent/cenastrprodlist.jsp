<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" isErrorPage="true"%>
<%@ page contentType="text/html; charset=utf-8" %>
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
int [] ew_SecTable = new int[3+1];
ew_SecTable[0] = 15;
ew_SecTable[1] = 13;
ew_SecTable[2] = 15;
ew_SecTable[3] = 8;

// get current table security
int ewCurSec = 0; // initialise
ewCurSec = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();
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
			b_search = b_search + "`cenastrprod`.`sif_kupca` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`cenastrprod`.`material_koda` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "skup.tekst LIKE '%" + kw + "%' OR ";
			b_search = b_search + "kupci.naziv LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`cenastrprod`.`sif_kupca` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`cenastrprod`.`material_koda` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "skup.tekst LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "kupci.naziv LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("cenastrprod_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("cenastrprod_REC", new Integer(startRec));
}else{
	if (session.getAttribute("cenastrprod_searchwhere") != null)
		searchwhere = (String) session.getAttribute("cenastrprod_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("cenastrprod_searchwhere", searchwhere);
		session.removeAttribute("cenastrprod_OB");
		session.removeAttribute("cenastrprod_searchwhere1");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("cenastrprod_searchwhere", searchwhere);
		session.removeAttribute("cenastrprod_searchwhere1");
	}else if (cmd.toUpperCase().equals("TOP")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("cenastrprod_searchwhere1", " cenastrprod.sif_kupca = zadnji.sif_kupca and cenastrprod.zacetek= zadnji.datum  and cenastrprod.material_koda = zadnji.material_koda ");
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("cenastrprod_REC", new Integer(startRec));
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
	if (session.getAttribute("cenastrprod_OB") != null &&
		((String) session.getAttribute("cenastrprod_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) {
			session.setAttribute("cenastrprod_OT", "DESC");
		}else{
			session.setAttribute("cenastrprod_OT", "ASC");
		}
	}else{
		session.setAttribute("cenastrprod_OT", "ASC");
	}
	session.setAttribute("cenastrprod_OB", OrderBy);
	session.setAttribute("cenastrprod_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("cenastrprod_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("cenastrprod_OB", OrderBy);
		session.setAttribute("cenastrprod_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
String searchwhere1 = (String) session.getAttribute("cenastrprod_searchwhere1");

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;


String stranke = (String) session.getAttribute("vse");
String strankeQueryFilter = "";
if(stranke.equals("0")){
	strankeQueryFilter = "potnik = " + session.getAttribute("papirservis1_status_UserID");
}

String enote = (String) session.getAttribute("enote");
String enoteQueryFilter = "";
if(enote.equals("0")){
	enoteQueryFilter = "sif_enote = " + session.getAttribute("papirservis1_status_Enota");
}

String subQuery ="";

if(strankeQueryFilter.length() > 0 || enoteQueryFilter.length() > 0){
	subQuery += " AND " + strankeQueryFilter;
	if(strankeQueryFilter.length() > 0 && enoteQueryFilter.length() > 0){
		subQuery += " AND " + enoteQueryFilter;
	}else{
		subQuery += enoteQueryFilter;
	}
}



// Build SQL
String strsql = "SELECT  cenastrprod.*, skup.tekst, enote.naziv FROM cenastrprod left join enote on (cenastrprod.sif_enote = enote.sif_enote), kupci, skup ";

if (searchwhere1 != null && searchwhere1.length() > 0)
	strsql += " , (SELECT sif_kupca, material_koda, max(zacetek) datum FROM `cenastrprod` group by sif_kupca, material_koda) zadnji";

whereClause = "  cenastrprod.sif_kupca = kupci.sif_kupca and kupci.skupina = skup.skupina  "  + subQuery ;
if (DefaultFilter.length() > 0) {
	whereClause = whereClause + "(" + DefaultFilter + ") AND ";
}
if (dbwhere.length() > 0) {
	whereClause = whereClause + " AND (" + dbwhere + ") AND ";
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
	strsql = strsql + " ORDER BY " + OrderBy + " " + (String) session.getAttribute("cenastrprod_OT");
} else {
	strsql = strsql + " ORDER BY sif_kupca";
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
	session.setAttribute("cenastrprod_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("cenastrprod_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("cenastrprod_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("cenastrprod_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("cenastrprod_REC") != null)
		startRec = ((Integer) session.getAttribute("cenastrprod_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("cenastrprod_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Tabela: cena stranke prodaja</span></p>
<form action="cenastrprodlist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="cenastrprodlist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
		<td><span class="jspmaker">
		&nbsp;&nbsp;<a href="cenastrprodlist.jsp?cmd=top">Prikaži zadnje</a>
		</span></td>
	</tr>
	<!-- tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr -->
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="cenastrprodadd.jsp">Dodaj nov zapis</a></td></tr>
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
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","utf-8") %>">Šifra kupca (*)&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kupci.naziv")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("kupci.naziv","utf-8") %>">Kupec&nbsp;<% if (OrderBy != null && OrderBy.equals("kupci.naziv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kupci.naziv")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("skup.tekst")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("skup.tekst","utf-8") %>">Skupina&nbsp;<% if (OrderBy != null && OrderBy.equals("skup.tekst")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("skup.tekst")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("material_koda")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("material_koda","utf-8") %>">Šifra material koda&nbsp;<% if (OrderBy != null && OrderBy.equals("material_koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("material_koda")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("material_koda")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("material_koda","utf-8") %>">Material koda&nbsp;<% if (OrderBy != null && OrderBy.equals("material_koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("material_koda")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("cena")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("cena","utf-8") %>">Cena&nbsp;<% if (OrderBy != null && OrderBy.equals("cena")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("cena")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("sif_enote","utf-8") %>">Šifra enote&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_enote")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("sif_enote","utf-8") %>">Enota&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_enote")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("veljavnost")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("veljavnost","UTF-8") %>">Veljavnost&nbsp;<% if (OrderBy != null && OrderBy.equals("veljavnost")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("veljavnost")) ? "</b>" : ""%>
		</td>
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("zacetek","utf-8") %>">Začetek&nbsp;<% if (OrderBy != null && OrderBy.equals("zacetek")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "</b>" : ""%>
		</td>
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "<b>" : ""%>
<a href="cenastrprodlist.jsp?order=<%= java.net.URLEncoder.encode("uporabnik","utf-8") %>">Uporabnik&nbsp;<% if (OrderBy != null && OrderBy.equals("uporabnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("cenastrprod_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("cenastrprod_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
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
	String x_sif_kupca = "";
	String x_material_koda = "";
	String x_skupina = "";
	String x_cena = "";
	String x_sif_enote = "";
	String x_naziv = "";
	Object x_zacetek = null;
	String x_uporabnik = "";
	Object x_veljavnost = null;

	// Load Key for record
	String key = "";
	if(rs.getString("sif_kupca") != null){
		key = rs.getString("sif_kupca");
	}

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}

	// material_koda
	if (rs.getString("material_koda") != null){
		x_material_koda = rs.getString("material_koda");
	}else{
		x_material_koda = "";
	}

	// skupina
	if (rs.getString("tekst") != null){
		x_skupina = rs.getString("tekst");
	}else{
		x_skupina = "";
	}

	
	// cena
	x_cena = String.valueOf(rs.getDouble("cena"));

	// sif_Enote
	if (rs.getString("sif_Enote") != null){
		x_sif_enote = rs.getString("sif_Enote");
	}else{
		x_sif_enote = "";
	}

	// naziv
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}
	
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
	out.print("cenastrprodview.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("cenastrprodedit.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("cenastrprodadd.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Delete</span></td>
<% } %>
		<td><% out.print(x_sif_kupca); %>&nbsp;</td>
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
		<td><% out.print(x_skupina); %>&nbsp;</td>
		<td><% out.print(x_material_koda); %>&nbsp;</td>
		<td><%
if (x_material_koda!=null && ((String)x_material_koda).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_material_koda;
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
%>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_cena, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(x_sif_enote); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_veljavnost,7,locale)); %>&nbsp;</td>
		<td nowrap><% out.print(EW_FormatDateTime(x_zacetek,7,locale)); %>&nbsp;</td>
		<td nowrap><%
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
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='cenastrproddelete.jsp';this.form.submit();"></p>
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
	<td><a href="cenastrprodlist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="cenastrprodlist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="cenastrprodlist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="cenastrprodlist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
	<span class="jspmaker">Ne obstajajo zapisi</span>
	<% }else{ %>
	<span class="jspmaker">Nimate dovoljenja</span>
	<% } %>
<p>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
<a href="cenastrprodadd.jsp"><img src="images/addnew.gif" alt="Dodaj" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
