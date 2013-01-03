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
			b_search = b_search + "kupci.`sif_kupca` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`naziv` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`naslov` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`posta` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`kraj` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`kont_oseba` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`tel_st1` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`tel_st2` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`fax` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`razred` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`sif_rac` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`opomba` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "skup.tekst LIKE '%" + kw + "%' OR ";
			b_search = b_search + "uporabniki.ime_in_priimek LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		if(pSearch.indexOf('*') >0){
			pSearch = pSearch.replace('*',' ').trim();
		}else{
			pSearch = "%" + pSearch;
		}
		b_search = b_search + "kupci.`sif_kupca` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`naziv` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`naslov` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`posta` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`kraj` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`kont_oseba` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`tel_st1` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`tel_st2` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`fax` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`razred` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`sif_rac` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "`opomba` LIKE '" + pSearch + "%' OR ";
		b_search = b_search + "skup.tekst LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "uporabniki.ime_in_priimek LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("kupci_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("kupci_REC", new Integer(startRec));
}else{
	if (session.getAttribute("kupci_searchwhere") != null)
		searchwhere = (String) session.getAttribute("kupci_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("kupci_searchwhere", searchwhere);
		session.removeAttribute("kupci_OB");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("kupci_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("kupci_REC", new Integer(startRec));
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
	if (session.getAttribute("kupci_OB") != null &&
		((String) session.getAttribute("kupci_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("kupci_OT")).equals("ASC")) {
			session.setAttribute("kupci_OT", "DESC");
		}else{
			session.setAttribute("kupci_OT", "ASC");
		}
	}else{
		session.setAttribute("kupci_OT", "ASC");
	}
	session.setAttribute("kupci_OB", OrderBy);
	session.setAttribute("kupci_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("kupci_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("kupci_OB", OrderBy);
		session.setAttribute("kupci_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT *, skup.tekst, uporabniki.ime_in_priimek FROM kupci, skup, uporabniki ";
whereClause = " kupci.skupina = skup.skupina AND uporabniki.sif_upor = kupci.potnik AND ";
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

String stranke = (String) session.getAttribute("vse");
String strankeQueryFilter = "";
if(stranke.equals("0")){
	strankeQueryFilter = "potnik = " + session.getAttribute("papirservis1_status_UserID");
}

String enote = (String) session.getAttribute("enote");
String enoteQueryFilter = "";
if(enote.equals("0")){
	enoteQueryFilter = " kupci.sif_enote = " + session.getAttribute("papirservis1_status_Enota");
}

String subQuery ="";

if(strankeQueryFilter.length() > 0 || enoteQueryFilter.length() > 0){
	subQuery += " WHERE " + strankeQueryFilter;
	if(strankeQueryFilter.length() > 0 && enoteQueryFilter.length() > 0){
		subQuery += " AND " + enoteQueryFilter;
	}else{
		subQuery += enoteQueryFilter;
	}
}


//Filter by user
if (whereClause.length() > 0) {

	strsql += " AND (kupci.sif_kupca in (select kupci.sif_kupca from kupci,uporabniki  " + subQuery + "))" ;
}
else{
	strsql += " WHERE (kupci.sif_kupca in (select kupci.sif_kupca from kupci,uporabniki "  + subQuery +   "))" ;
}

if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("kupci_OT");
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
	session.setAttribute("kupci_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("kupci_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("kupci_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("kupci_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("kupci_REC") != null)
		startRec = ((Integer) session.getAttribute("kupci_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("kupci_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: kupci</span></p>
<form action="kupcilist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="kupcilist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
	<!-- tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr-->
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="kupciadd.jsp">Dodaj nov zapis</a></td></tr>
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
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>">Šifra kupca&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("naziv","UTF-8") %>">Naziv&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("naziv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naslov")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("naslov","UTF-8") %>">Naslov&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("naslov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naslov")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("posta")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("posta","UTF-8") %>">Pošta&nbsp;<% if (OrderBy != null && OrderBy.equals("posta")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("posta")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kraj")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("kraj","UTF-8") %>">Kraj&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("kraj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kraj")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kont_oseba")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("kont_oseba","UTF-8") %>">Kontakt oseba&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("kont_oseba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kont_oseba")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("tel_st1")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("tel_st1","UTF-8") %>">tel št 1.&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("tel_st1")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("tel_st1")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("tel_st2")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("tel_st2","UTF-8") %>">tel št 2&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("tel_st2")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("tel_st2")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("fax")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("fax","UTF-8") %>">fax&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("fax")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("fax")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("potnik")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("potnik","UTF-8") %>">Potnik&nbsp;<% if (OrderBy != null && OrderBy.equals("potnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("potnik")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("razred")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("razred","UTF-8") %>">Razred&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("razred")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("razred")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("bala")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("bala","UTF-8") %>">Bala&nbsp;<% if (OrderBy != null && OrderBy.equals("bala")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("bala")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("blokada")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("blokada","UTF-8") %>">Blokada&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("blokada")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("blokada")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_rac")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("sif_rac","UTF-8") %>">Šifra rač.&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_rac")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_rac")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("opomba")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("opomba","UTF-8") %>">Opomba&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("opomba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opomba")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("skupina")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("skupina","UTF-8") %>">Skupina&nbsp;<% if (OrderBy != null && OrderBy.equals("skupina")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("skupina")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("sif_enote","UTF-8") %>">Šifra enote&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_enote")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_enote")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("pogodba")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("pogodba","UTF-8") %>">Pogodba&nbsp;<% if (OrderBy != null && OrderBy.equals("pogodba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("pogodba")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("davcna")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("davcna","UTF-8") %>">Davčna&nbsp;<% if (OrderBy != null && OrderBy.equals("davcna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("davcna")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("maticna")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("maticna","UTF-8") %>">Matična&nbsp;<% if (OrderBy != null && OrderBy.equals("maticna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("maticna")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dejavnost")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("dejavnost","UTF-8") %>">Dejavnost&nbsp;<% if (OrderBy != null && OrderBy.equals("dejavnost")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dejavnost")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("opomba1")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("opomba1","UTF-8") %>">Opomba 1&nbsp;<% if (OrderBy != null && OrderBy.equals("opomba1")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opomba1")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("opomba2")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("opomba2","UTF-8") %>">Opomba 2&nbsp;<% if (OrderBy != null && OrderBy.equals("opomba2")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opomba2")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("opomba3")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("opomba3","UTF-8") %>">Opomba 3&nbsp;<% if (OrderBy != null && OrderBy.equals("opomba3")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opomba3")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("opomba4")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("opomba4","UTF-8") %>">Opomba 4&nbsp;<% if (OrderBy != null && OrderBy.equals("opomba4")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opomba4")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("opomba5")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("opomba5","UTF-8") %>">Opomba 5&nbsp;<% if (OrderBy != null && OrderBy.equals("opomba5")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opomba5")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("analiza")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("analiza","UTF-8") %>">Analiza&nbsp;<% if (OrderBy != null && OrderBy.equals("analiza")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("analiza")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("datum","UTF-8") %>">Datum&nbsp;<% if (OrderBy != null && OrderBy.equals("datum")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_prenos")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("arso_prenos","UTF-8") %>">Arso prenos&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_prenos")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_prenos")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_pslj_st")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("arso_pslj_st","UTF-8") %>">Arso št.&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_pslj_st")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_pslj_st")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_pslj_status")) ? "<b>" : ""%>
<a href="kupcilist.jsp?order=<%= java.net.URLEncoder.encode("arso_pslj_status","UTF-8") %>">Arso status&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_pslj_status")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_pslj_status")) ? "</b>" : ""%>
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
	String x_naziv = "";
	String x_naslov = "";
	String x_posta = "";
	String x_kraj = "";
	String x_kont_oseba = "";
	String x_tel_st1 = "";
	String x_tel_st2 = "";
	String x_fax = "";
	String x_potnik = "";
	String x_razred = "";
	String x_bala = "";
	int x_blokada = 0;
	String x_sif_rac = "";
	String x_opomba = "";
	String x_skupina = "";
	String x_sif_enote = "";

	String x_pogodba  = "";
	String x_davcna = "";
	String x_maticna = "";
	String x_dejavnost = "";
	String x_opomba1 = "";
	String x_opomba2 = "";
	String x_opomba3 = "";
	String x_opomba4 = "";
	String x_opomba5 = "";
	String x_analiza = "";
	String x_datum = "";
	int x_arso_prenos = 0;
	String x_arso_pslj_st = "";
	String x_arso_pslj_status = "";

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

	// kont_oseba
	if (rs.getString("kont_oseba") != null){
		x_kont_oseba = rs.getString("kont_oseba");
	}else{
		x_kont_oseba = "";
	}

	// tel_st1
	if (rs.getString("tel_st1") != null){
		x_tel_st1 = rs.getString("tel_st1");
	}else{
		x_tel_st1 = "";
	}

	// tel_st2
	if (rs.getString("tel_st2") != null){
		x_tel_st2 = rs.getString("tel_st2");
	}else{
		x_tel_st2 = "";
	}

	// fax
	if (rs.getString("fax") != null){
		x_fax = rs.getString("fax");
	}else{
		x_fax = "";
	}

	// potnik
	x_potnik = String.valueOf(rs.getLong("potnik"));

	// razred
	if (rs.getString("razred") != null){
		x_razred = rs.getString("razred");
	}else{
		x_razred = "";
	}

	// bala
	x_bala = String.valueOf(rs.getLong("bala"));

	// blokada
	x_blokada = rs.getInt("blokada");

	// sif_rac
	if (rs.getString("sif_rac") != null){
		x_sif_rac = rs.getString("sif_rac");
	}else{
		x_sif_rac = "";
	}

	// opomba
	if (rs.getString("opomba") != null){
		x_opomba = rs.getString("opomba");
	}else{
		x_opomba = "";
	}



	// pogodba
	if (rs.getString("pogodba") != null){
		x_pogodba = rs.getString("pogodba");
	}else{
		x_pogodba = "";
	}

	// davcna
	if (rs.getString("davcna") != null){
		x_davcna = rs.getString("davcna");
	}else{
		x_davcna = "";
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

	// opomba1
	if (rs.getString("opomba1") != null){
		x_opomba1 = rs.getString("opomba1");
	}else{
		x_opomba1 = "";
	}

	// opomba2
	if (rs.getString("opomba2") != null){
		x_opomba2 = rs.getString("opomba2");
	}else{
		x_opomba2 = "";
	}

	// opomba3
	if (rs.getString("opomba3") != null){
		x_opomba3 = rs.getString("opomba3");
	}else{
		x_opomba3 = "";
	}

	// opomba4
	if (rs.getString("opomba4") != null){
		x_opomba4 = rs.getString("opomba4");
	}else{
		x_opomba4 = "";
	}

	// opomba5
	if (rs.getString("opomba5") != null){
		x_opomba5 = rs.getString("opomba5");
	}else{
		x_opomba5 = "";
	}

	// analiza
	if (rs.getString("analiza") != null){
		x_analiza = rs.getString("analiza");
	}else{
		x_analiza = "";
	}


	// datum
	if (rs.getString("datum") != null){
		x_datum = rs.getString("datum");
	}else{
		x_datum = "";
	}

	// arso_prenos
	x_arso_prenos = rs.getInt("arso_prenos");

	// arso_pslj_st
	if (rs.getString("arso_pslj_st") != null){
		x_arso_pslj_st = rs.getString("arso_pslj_st");
	}else{
		x_arso_pslj_st = "";
	}

	// arso_pslj_status
	if (rs.getString("arso_pslj_status") != null){
		x_arso_pslj_status = rs.getString("arso_pslj_status");
	}else{
		x_arso_pslj_status = "";
	}

	
	
	
	// skupina
	x_skupina = String.valueOf(rs.getLong("skupina"));

	// sif_enote
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));
%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_kupca"); 
if (key != null && key.length() > 0) { 
	out.print("kupciview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_kupca"); 
if (key != null && key.length() > 0) { 
	out.print("kupciedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_kupca"); 
if (key != null && key.length() > 0) { 
	out.print("kupciadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Briši</span></td>
<% } %>
		<td><% out.print(x_sif_kupca); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td><% out.print(x_naslov); %>&nbsp;</td>
		<td><% out.print(x_posta);  %>&nbsp;</td>
		<td><% out.print(x_kraj); %>&nbsp;</td>
		<td><% out.print(x_kont_oseba); %>&nbsp;</td>
		<td><% out.print(x_tel_st1); %>&nbsp;</td>
		<td><% out.print(x_tel_st2); %>&nbsp;</td>
		<td><% out.print(x_fax); %>&nbsp;</td>
		<td><%
if (x_potnik!=null && ((String)x_potnik).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`sif_upor` = " + x_potnik;
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
		<td><% out.print(x_razred); %>&nbsp;</td>
		<td><% out.print(x_bala); %>&nbsp;</td>
		<td><% out.print((x_blokada == 1 ? "DA" : "NE")); %>&nbsp;</td>
		<td><% out.print(x_sif_rac); %>&nbsp;</td>
		<td><% out.print(x_opomba); %>&nbsp;</td>
		<td><%
if (x_skupina!=null && ((String)x_skupina).length() > 0) {
	String sqlwrk_where = "";
	sqlwrk_where = "`skupina` = " + x_skupina;
	String sqlwrk = "SELECT `skupina`, `tekst` FROM `skup`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("tekst"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
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
		<td><% out.print(x_pogodba ); %>&nbsp;</td>
		<td><% out.print(x_davcna); %>&nbsp;</td>
		<td><% out.print(x_maticna); %>&nbsp;</td>
		<td><% out.print(x_dejavnost); %>&nbsp;</td>
		<td><% out.print(x_opomba1); %>&nbsp;</td>
		<td><% out.print(x_opomba2);  %>&nbsp;</td>
		<td><% out.print(x_opomba3); %>&nbsp;</td>
		<td><% out.print(x_opomba4); %>&nbsp;</td>
		<td><% out.print(x_opomba5); %>&nbsp;</td>
		<td><% out.print(EW_FormatNumber("" + x_analiza, 4, 1, 1, 1,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_datum,7,locale)); %>&nbsp;</td>
		<td><% out.print((x_arso_prenos == 1 ? "DA" : "NE")); %>&nbsp;</td>
		<td><% out.print(x_arso_pslj_st); %>&nbsp;</td>
		<td><% out.print(x_arso_pslj_status); %>&nbsp;</td>

	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='kupcidelete.jsp';this.form.submit();"></p>
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
	<td><a href="kupcilist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="kupcilist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="kupcilist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="kupcilist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>