<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
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
			b_search = b_search + "`stranke`.`sif_str` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`naziv` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`naslov` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`posta` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`kraj` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`telefon` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`telefax` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`kont_os` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`del_cas` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`sif_os` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`opomba` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`sif_kupca` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`stranke`.`najem` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`stranke`.`sif_str` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`naziv` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`naslov` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`posta` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`kraj` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`telefon` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`telefax` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`kont_os` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`del_cas` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`sif_os` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`opomba` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`sif_kupca` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`stranke`.`najem` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("stranke_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("stranke_REC", new Integer(startRec));	
}else{
	if (session.getAttribute("stranke_searchwhere") != null)
		searchwhere = (String) session.getAttribute("stranke_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("stranke_searchwhere", searchwhere);
		session.removeAttribute("stranke_OB");		
		session.removeAttribute("stranke_searchwhere1");		
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("stranke_searchwhere", searchwhere);
		session.removeAttribute("stranke_searchwhere1");		
	}else if (cmd.toUpperCase().equals("TOP")) {
		searchwhere = " stranke.sif_str = zadnji.ss and stranke.zacetek = zadnji.datum"; // Reset search criteria
		session.setAttribute("stranke_searchwhere1", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("stranke_REC", new Integer(startRec));
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
String DefaultFilter = " stranke.sif_kupca = k.sif_kupca ";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("stranke_OB") != null &&
		((String) session.getAttribute("stranke_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("stranke_OT")).equals("ASC")) {
			session.setAttribute("stranke_OT", "DESC");
		}else{
			session.setAttribute("stranke_OT", "ASC");
		}
	}else{
		session.setAttribute("stranke_OT", "ASC");
	}
	session.setAttribute("stranke_OB", OrderBy);
	session.setAttribute("stranke_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("stranke_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("stranke_OB", OrderBy);
		session.setAttribute("stranke_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
String searchwhere1 = (String) session.getAttribute("stranke_searchwhere1");

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;


// Build SQL
String strsql = "SELECT stranke.*, skup.tekst FROM `stranke`, `kupci` k left join skup on (k.skupina = skup.skupina)";
whereClause = " ";



String stranke = (String) session.getAttribute("vse");
String strankeQueryFilter = "";
if(stranke.equals("0")){
	strankeQueryFilter = " k.potnik = " + session.getAttribute("papirservis1_status_UserID");
}

String enote = (String) session.getAttribute("enote");
String enoteQueryFilter = "";
if(enote.equals("0")){
	enoteQueryFilter = "k.sif_enote = " + session.getAttribute("papirservis1_status_Enota");
}

String subQuery ="";

if(strankeQueryFilter.length() > 0 || enoteQueryFilter.length() > 0){
	subQuery += " " + strankeQueryFilter;
	if(strankeQueryFilter.length() > 0 && enoteQueryFilter.length() > 0){
		subQuery += " and " + enoteQueryFilter;
	}else{
		subQuery += enoteQueryFilter;
	}
}

if(subQuery.length() > 0)
	subQuery += " and ";
subQuery += "stranke.sif_kupca = k.sif_kupca";

if (searchwhere1 != null && searchwhere1.length() > 0)
	strsql += " , (SELECT sif_str ss , max(zacetek) datum FROM `stranke`group by sif_str) zadnji ";

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


if (whereClause.length() > 0) {
	if (searchwhere1 != null && searchwhere1.length() > 0)
	if(stranke.equals("0")){
		strsql = strsql + " and " + subQuery;		
	}
		
}
else {
	if (searchwhere1 != null && searchwhere1.length() > 0)
		if(stranke.equals("0")){
			strsql = strsql + " WHERE " + subQuery ;		
		}
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("stranke_OT");
}else{
	strsql = strsql + " ORDER BY sif_str ";
}
//Filter by stranke

rs = stmt.executeQuery(strsql);
rs.last();
totalRecs = rs.getRow();
rs.beforeFirst();
startRec = 0;
int pageno = 0;

// Check for a START parameter
if (request.getParameter("start") != null && Integer.parseInt(request.getParameter("start")) > 0) {
	startRec = Integer.parseInt(request.getParameter("start"));
	session.setAttribute("stranke_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("stranke_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("stranke_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("stranke_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("stranke_REC") != null)
		startRec = ((Integer) session.getAttribute("stranke_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("stranke_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Pregled: stranke</span></p>
<form action="strankelist.jsp" name="strankelist" id="strankelist" method='post'>
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="strankelist.jsp?cmd=reset">Prikaži vse</a>
		&nbsp;&nbsp;<a href="strankelist.jsp?cmd=top">Prikaži zadnje</a>
		</span></td>
	</tr>
	<tr>
		<td><span class="jspmaker">Izvoz podatkov o strankah(csv)</span></td>
		<td><span class="jspmaker">
			<button type="button" onclick='strankeExport();'>Izvoz</button>
			<INPUT type="radio" id="vsi" name="tipizvoza" value="1" checked>Vsi
    		<INPUT type="radio" id="novi" name="tipizvoza" value="2">Nove
		</span></td>
	</tr>	
	<tr>
		<td><span class="jspmaker">Uvoz podatkov o strankah(csv)</span></td>
		<td><span class="jspmaker">
			<input type="file" name="csvfile" id="csvfile">
		</span></td>
	</tr>
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="strankeadd.jsp">Dodaj nov zapis</a></td></tr>
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
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("sif_str")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("sif_str","UTF-8") %>">Šifra stranke&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_str")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_str")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("naziv","UTF-8") %>">Naziv&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("naziv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naslov")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("naslov","UTF-8") %>">Naslov&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("naslov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naslov")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("posta")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("posta","UTF-8") %>">Pošta&nbsp;<% if (OrderBy != null && OrderBy.equals("posta")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("posta")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kraj")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("kraj","UTF-8") %>">Kraj&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("kraj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kraj")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("telefon")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("telefon","UTF-8") %>">telefon&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("telefon")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("telefon")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("telefax")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("telefax","UTF-8") %>">telefax&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("telefax")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("telefax")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kont_os")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("kont_os","UTF-8") %>">Kontakt oseba&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("kont_os")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kont_os")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("del_cas","UTF-8") %>">Delovni čas&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("del_cas")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_os")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("sif_os","UTF-8") %>">Šifra OS&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_os")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_os")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_os")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("sif_os","UTF-8") %>">Naziv OS&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_os")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_os")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_os")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("kol_os","UTF-8") %>">Kol osnove&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_os")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_os")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("opomba")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("opomba","UTF-8") %>">Opomba&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("opomba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opomba")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>">Šifra kupca&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>">Kupac&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("tekst")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("tekst","UTF-8") %>">Skupina&nbsp;<% if (OrderBy != null && OrderBy.equals("tekst")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("tekst")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("stroskovno_mesto")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("stroskovno_mesto","UTF-8") %>">Stroškovno mesto&nbsp;<% if (OrderBy != null && OrderBy.equals("stroskovno_mesto")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("stroskovno_mesto")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("rok_placila")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("rok_placila","UTF-8") %>">Rok plačila&nbsp;<% if (OrderBy != null && OrderBy.equals("rok_placila")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("rok_placila")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("cena")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("cena","UTF-8") %>">Cena&nbsp;<% if (OrderBy != null && OrderBy.equals("cena")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("cena")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("najem")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("najem","UTF-8") %>">Najem&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("najem")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("najem")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("cena_naj")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("cena_naj","UTF-8") %>">Cena naj&nbsp;<% if (OrderBy != null && OrderBy.equals("cena_naj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("cena_naj")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("pon")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("pon","UTF-8") %>">pon&nbsp;<% if (OrderBy != null && OrderBy.equals("pon")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("pon")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("tor")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("tor","UTF-8") %>">tor&nbsp;<% if (OrderBy != null && OrderBy.equals("tor")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("tor")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sre")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("sre","UTF-8") %>">sre&nbsp;<% if (OrderBy != null && OrderBy.equals("sre")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sre")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("cet")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("cet","UTF-8") %>">cet&nbsp;<% if (OrderBy != null && OrderBy.equals("cet")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("cet")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("pet")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("pet","UTF-8") %>">pet&nbsp;<% if (OrderBy != null && OrderBy.equals("pet")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("pet")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sob")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("sob","UTF-8") %>">sob&nbsp;<% if (OrderBy != null && OrderBy.equals("sob")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sob")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("ned")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("ned","UTF-8") %>">ned&nbsp;<% if (OrderBy != null && OrderBy.equals("ned")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("ned")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("veljavnost")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("veljavnost","UTF-8") %>">Veljavnost&nbsp;<% if (OrderBy != null && OrderBy.equals("veljavnost")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("veljavnost")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("x_koord")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("x_koord","UTF-8") %>">X koordinata&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("x_koord")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("x_koord")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("y_koord")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("y_koord","UTF-8") %>">Y koordinata&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("y_koord")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("y_koord")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("radij")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("radij","UTF-8") %>">Radij&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("radij")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("radij")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("vtez")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("vtez","UTF-8") %>">Vtez&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("radij")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("vtez")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("obracun_km")) ? "<b>" : ""%>
<a href="doblist.jsp?order=<%= java.net.URLEncoder.encode("obracun_km","UTF-8") %>">Obračun km&nbsp;<% if (OrderBy != null && OrderBy.equals("obracun_km")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dob_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dob_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("obracun_km")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("stev_km_norm")) ? "<b>" : ""%>
<a href="doblist.jsp?order=<%= java.net.URLEncoder.encode("stev_km_norm","UTF-8") %>">Število km normativ&nbsp;<% if (OrderBy != null && OrderBy.equals("stev_km_norm")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dob_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dob_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("stev_km_norm")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("stev_ur_norm")) ? "<b>" : ""%>
<a href="doblist.jsp?order=<%= java.net.URLEncoder.encode("stev_ur_norm","UTF-8") %>">Število ur normativ&nbsp;<% if (OrderBy != null && OrderBy.equals("stev_ur_norm")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dob_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dob_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("stev_ur_norm")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("zacetek","UTF-8") %>">Začetek&nbsp;<% if (OrderBy != null && OrderBy.equals("zacetek")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("uporabnik","UTF-8") %>">Uporabnik&nbsp;<% if (OrderBy != null && OrderBy.equals("uporabnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("stranke_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("stranke_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_odp_loc_id")) ? "<b>" : ""%>
<a href="strankelist.jsp?order=<%= java.net.URLEncoder.encode("arso_odp_loc_id","UTF-8") %>">Arso št.&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_odp_loc_id")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_odp_loc_id")) ? "</b>" : ""%>
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
	String x_sif_str = "";
	String x_naziv = "";
	String x_naslov = "";
	String x_posta = "";
	String x_kraj = "";
	String x_telefon = "";
	String x_telefax = "";
	String x_kont_os = "";
	String x_del_cas = "";
	String x_sif_os = "";
	String x_kol_os = "";
	String x_opomba = "";
	String x_sif_kupca = "";
	String x_stroskovno_mesto = "";
	String x_rok_placila = "";
	String x_cena = "";
	String x_najem = "";
	String x_cena_naj = "";
	Object x_zacetek = null;
	String x_uporabnik = "";
	String x_pon = "";
	String x_tor = "";
	String x_sre = "";
	String x_cet = "";
	String x_pet = "";
	String x_sob = "";
	String x_ned = "";
	Object x_veljavnost = null;
	String x_x_koord = "";
	String x_y_koord = "";
	String x_radij = "";	
	String x_vtez = "";	
	String x_obracun_km = "";
	String x_stev_km_norm = "";
	String x_stev_ur_norm = "";
	String x_skupina = "";
	String x_arso_odp_loc_id = "";
	
	// Load Key for record
	String key = "";
	key = String.valueOf(rs.getLong("sif_str"));

	// sif_str
	x_sif_str = String.valueOf(rs.getLong("sif_str"));

	// naziv
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}

	// naslov
	if (rs.getString("naslov") != null){
		x_naslov = rs.getString("naslov");
	}else{
		x_naslov = "";
	}

	// posta
	if (rs.getString("posta") != null){
		x_posta = rs.getString("posta");
	}else{
		x_posta = "";
	}

	// kraj
	if (rs.getString("kraj") != null){
		x_kraj = rs.getString("kraj");
	}else{
		x_kraj = "";
	}

	// telefon
	if (rs.getString("telefon") != null){
		x_telefon = rs.getString("telefon");
	}else{
		x_telefon = "";
	}

	// telefax
	if (rs.getString("telefax") != null){
		x_telefax = rs.getString("telefax");
	}else{
		x_telefax = "";
	}

	// kont_os
	if (rs.getString("kont_os") != null){
		x_kont_os = rs.getString("kont_os");
	}else{
		x_kont_os = "";
	}

	// del_cas
	if (rs.getString("del_cas") != null){
		x_del_cas = rs.getString("del_cas");
	}else{
		x_del_cas = "";
	}

	// sif_os
	if (rs.getString("sif_os") != null){
		x_sif_os = rs.getString("sif_os");
	}else{
		x_sif_os = "";
	}

	// kol_os
	x_kol_os = String.valueOf(rs.getLong("kol_os"));

	// opomba
	if (rs.getString("opomba") != null){
		x_opomba = rs.getString("opomba");
	}else{
		x_opomba = "";
	}

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}

	// sif_kupca
	if (rs.getString("tekst") != null){
		x_skupina = rs.getString("tekst");
	}else{
		x_skupina = "";
	}

	// stroskovno_mesto
	if (rs.getString("stroskovno_mesto") != null){
		x_stroskovno_mesto = rs.getString("stroskovno_mesto");
	}else{
		x_stroskovno_mesto = "";
	}

	// rok_placila
	x_rok_placila = String.valueOf(rs.getInt("rok_placila"));

	
	// cena
	x_cena = String.valueOf(rs.getDouble("cena"));

	// najem
	if (rs.getString("najem") != null){
		x_najem = rs.getString("najem");
	}else{
		x_najem = "";
	}

	// cena_naj
	x_cena_naj = String.valueOf(rs.getDouble("cena_naj"));

	// zacetek
	if (rs.getTimestamp("zacetek") != null){
		x_zacetek = rs.getTimestamp("zacetek");
	}else{
		x_zacetek = "";
	}
	// uporabnik
	x_uporabnik = String.valueOf(rs.getLong("uporabnik"));

	// pon
	if (rs.getString("pon")!= null){
		x_pon = rs.getString("pon");
		if (x_pon.equals("0")) x_pon = "ni odvoza"; 
		if (x_pon.equals("1")) x_pon = "sodi"; 
		if (x_pon.equals("2")) x_pon = "lihi"; 
		if (x_pon.equals("3")) x_pon = "vsak";
	}else{
		x_pon = "";
	}

	// tor
	if (rs.getString("tor")!= null){
		x_tor = rs.getString("tor");
		if (x_tor.equals("0")) x_tor = "ni odvoza"; 
		if (x_tor.equals("1")) x_tor = "sodi"; 
		if (x_tor.equals("2")) x_tor = "lihi"; 
		if (x_tor.equals("3")) x_tor = "vsak";
	}else{
		x_tor = "";
	}

	// sre
	if (rs.getString("sre")!= null){
		x_sre = rs.getString("sre");
		if (x_sre.equals("0")) x_sre = "ni odvoza"; 
		if (x_sre.equals("1")) x_sre = "sodi"; 
		if (x_sre.equals("2")) x_sre = "lihi"; 
		if (x_sre.equals("3")) x_sre = "vsak";

	}else{
		x_sre = "";
	}

	// cet
	if (rs.getString("cet")!= null){
		x_cet = rs.getString("cet");
		if (x_cet.equals("0")) x_cet = "ni odvoza"; 
		if (x_cet.equals("1")) x_cet = "sodi"; 
		if (x_cet.equals("2")) x_cet = "lihi"; 
		if (x_cet.equals("3")) x_cet = "vsak";
	}else{
		x_cet = "";
	}

	// pet
	if (rs.getString("pet")!= null){
		x_pet = rs.getString("pet");
		if (x_pet.equals("0")) x_pet = "ni odvoza"; 
		if (x_pet.equals("1")) x_pet = "sodi"; 
		if (x_pet.equals("2")) x_pet = "lihi"; 
		if (x_pet.equals("3")) x_pet = "vsak";
	}else{
		x_pet = "";
	}

	// sob
	if (rs.getString("sob")!= null){
		x_sob = rs.getString("sob");
		if (x_sob.equals("0")) x_sob = "ni odvoza"; 
		if (x_sob.equals("1")) x_sob = "sodi"; 
		if (x_sob.equals("2")) x_sob = "lihi"; 
		if (x_sob.equals("3")) x_sob = "vsak";
	}else{
		x_sob = "";
	}

	// ned
	if (rs.getString("ned")!= null){
		x_ned = rs.getString("ned");
		if (x_ned.equals("0")) x_ned = "ni odvoza"; 
		if (x_ned.equals("1")) x_ned = "sodi"; 
		if (x_ned.equals("2")) x_ned = "lihi"; 
		if (x_ned.equals("3")) x_ned = "vsak";

	}else{
		x_ned = "";
	}

	// veljavnost
	if (rs.getTimestamp("veljavnost") != null){
		x_veljavnost = rs.getTimestamp("veljavnost");
	}else{
		x_veljavnost = "";
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
	
	// lokacija
	if (rs.getString("vtez") != null){
		x_vtez = rs.getString("vtez");
	}else{
		x_vtez = "";
	}	


	// obracun_km
	x_obracun_km = String.valueOf(rs.getDouble("obracun_km"));

	// stev_km_norm
	x_stev_km_norm = String.valueOf(rs.getDouble("stev_km_norm"));

	// stev_ur_norm
	x_stev_ur_norm = String.valueOf(rs.getDouble("stev_ur_norm"));

	// arso_odp_loc_id
	if (rs.getString("arso_odp_loc_id") != null){
		x_arso_odp_loc_id = rs.getString("arso_odp_loc_id");
	}else{
		x_arso_odp_loc_id = "";
	}

%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("strankeview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("strankeedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("strankeadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Briši</span></td>
<% } %>
		<td nowrap><% out.print(x_sif_str); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td><% out.print(x_naslov); %>&nbsp;</td>
		<td><% out.print(x_posta); %>&nbsp;</td>
		<td><% out.print(x_kraj); %>&nbsp;</td>
		<td><% out.print(x_telefon); %>&nbsp;</td>
		<td><% out.print(x_telefax); %>&nbsp;</td>
		<td><% out.print(x_kont_os); %>&nbsp;</td>
		<td><% out.print(x_del_cas); %>&nbsp;</td>
		<td><% out.print(x_sif_os); %>&nbsp;</td>
		<td><%
if (x_sif_os!=null && ((String)x_sif_os).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_os;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_os` = '" + tmpfld + "'";
	String sqlwrk = "SELECT DISTINCT `sif_os`, `osnovna` FROM `osnovna`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("osnovna"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
		<td><% out.print(x_kol_os); %>&nbsp;</td>
		<td><% out.print(x_opomba); %>&nbsp;</td>
		<td><% out.print(x_sif_kupca); %>&nbsp;</td>
		<td><%
if (x_sif_kupca!=null && ((String)x_sif_kupca).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_sif_kupca;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`sif_kupca` = '" + tmpfld + "'";
	String sqlwrk = "SELECT DISTINCT `sif_kupca`, `naziv` FROM `kupci`";
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
		<td><% out.print(x_stroskovno_mesto); %>&nbsp;</td>
		<td><% out.print(x_rok_placila); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_cena, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(x_najem); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_cena_naj, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><%out.print(x_pon);%>&nbsp;</td>
		<td><%out.print(x_tor);%>&nbsp;</td>
		<td><%out.print(x_sre);%>&nbsp;</td>
		<td><%out.print(x_cet);%>&nbsp;</td>
		<td><%out.print(x_pet);%>&nbsp;</td>
		<td><%out.print(x_sob);%>&nbsp;</td>
		<td><%out.print(x_ned);%>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_veljavnost,7,locale)); %>&nbsp;</td>
		<td><% out.print(x_x_koord); %>&nbsp;</td>
		<td><% out.print(x_y_koord); %>&nbsp;</td>
		<td><% out.print(x_radij); %>&nbsp;</td>
		<td><% out.print(x_vtez); %>&nbsp;</td>
		<td><% out.print(x_obracun_km); %>&nbsp;</td>
		<td><% out.print(x_stev_km_norm); %>&nbsp;</td>
		<td><% out.print(x_stev_ur_norm); %>&nbsp;</td>
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
		<td><% out.print(x_arso_odp_loc_id); %>&nbsp;</td>

	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='strankedelete.jsp';this.form.submit();"></p>
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
	<td><a href="strankelist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="strankelist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="strankelist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="strankelist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<a href="strankeadd.jsp">Dodaj nov zapis</a>
<% } %>
</p>
<% } %>
</td></tr></table>

<script language="JavaScript" src="papirservis.js"></script>

<%@ include file="footer.jsp" %>