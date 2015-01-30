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
			b_search = b_search + "`st_pogodbe` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`naziv` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`st_pogodbe` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`naziv` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("recikelzavezanci_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("recikelzavezanci_REC", new Integer(startRec));
}else{
	if (session.getAttribute("recikelzavezanci_searchwhere") != null)
		searchwhere = (String) session.getAttribute("recikelzavezanci_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("recikelzavezanci_searchwhere", searchwhere);
		session.removeAttribute("recikelzavezanci_OB");
		session.removeAttribute("recikelzavezanci_searchwhere1");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("recikelzavezanci_searchwhere", searchwhere);
		session.removeAttribute("recikelzavezanci_searchwhere1");
	}else if (cmd.toUpperCase().equals("TOP")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("recikelzavezanci_searchwhere1", "");
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("recikelzavezanci_REC", new Integer(startRec));
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
	if (session.getAttribute("recikelzavezanci_OB") != null &&
		((String) session.getAttribute("recikelzavezanci_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) {
			session.setAttribute("recikelzavezanci_OT", "DESC");
		}else{
			session.setAttribute("recikelzavezanci_OT", "ASC");
		}
	}else{
		session.setAttribute("recikelzavezanci_OT", "ASC");
	}
	session.setAttribute("recikelzavezanci_OB", OrderBy);
	session.setAttribute("recikelzavezanci_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("recikelzavezanci_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("recikelzavezanci_OB", OrderBy);
		session.setAttribute("recikelzavezanci_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
String searchwhere1 = (String) session.getAttribute("recikelzavezanci_searchwhere1");

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;
String subQuery ="";

// Build SQL
String strsql = "select * from recikel_zavezanci" + session.getAttribute("leto") + " left join uporabniki on uporabnik = sif_upor";

whereClause = subQuery ;
if (DefaultFilter.length() > 0) {
	whereClause = whereClause + "(" + DefaultFilter + ") AND ";
}
if (dbwhere.length() > 0) {
	whereClause = whereClause + " (" + dbwhere + ") AND ";
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


if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY " + OrderBy + " " + (String) session.getAttribute("recikelzavezanci_OT");
} else {
	strsql = strsql + " ORDER BY st_pogodbe";
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
	session.setAttribute("recikelzavezanci_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("recikelzavezanci_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("recikelzavezanci_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("recikelzavezanci_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("recikelzavezanci_REC") != null)
		startRec = ((Integer) session.getAttribute("recikelzavezanci_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("recikelzavezanci_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Tabela: recikel zavezanci</span></p>
<form action="recikelzavezancilist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="recikelzavezancilist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="recikelzavezanciadd.jsp">Dodaj nov zapis</a></td></tr>
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
<%=(OrderBy != null && OrderBy.equals("st_pogodbe")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("st_pogodbe","utf-8") %>">Št. pogodbe(*)&nbsp;<% if (OrderBy != null && OrderBy.equals("st_pogodbe")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("st_pogodbe")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("naziv","utf-8") %>">Naziv&nbsp;<% if (OrderBy != null && OrderBy.equals("naziv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naslov")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("naslov","utf-8") %>">Naslov&nbsp;<% if (OrderBy != null && OrderBy.equals("naslov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naslov")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kraj")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("kraj","utf-8") %>">Kraj&nbsp;<% if (OrderBy != null && OrderBy.equals("kraj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kraj")) ? "</b>" : ""%>
		</td>
		
		<td>
<%=(OrderBy != null && OrderBy.equals("posta")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("posta","utf-8") %>">Pošta&nbsp;<% if (OrderBy != null && OrderBy.equals("posta")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("posta")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("davcna")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("davcna","utf-8") %>">Davčna&nbsp;<% if (OrderBy != null && OrderBy.equals("davcna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("davcna")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("maticna")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("maticna","utf-8") %>">Matična&nbsp;<% if (OrderBy != null && OrderBy.equals("maticna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("maticna")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("mail")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("mail","utf-8") %>">Mail&nbsp;<% if (OrderBy != null && OrderBy.equals("mail")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("mail")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("dejavnost")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("dejavnost","utf-8") %>">Dejavnost&nbsp;<% if (OrderBy != null && OrderBy.equals("dejavnost")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dejavnost")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("naslov_posiljanje")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("naslov_posiljanje","utf-8") %>">Naslov pošiljanje&nbsp;<% if (OrderBy != null && OrderBy.equals("naslov_posiljanje")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naslov_posiljanje")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("kraj_posiljanje")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("kraj_posiljanje","utf-8") %>">Kraj pošiljanje&nbsp;<% if (OrderBy != null && OrderBy.equals("kraj_posiljanje")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kraj_posiljanje")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("posta_posiljanje")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("posta_posiljanje","utf-8") %>">Pošta pošiljanje&nbsp;<% if (OrderBy != null && OrderBy.equals("posta_posiljanje")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("posta_posiljanje")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("skrbnik")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("skrbnik","utf-8") %>">Skrbnik&nbsp;<% if (OrderBy != null && OrderBy.equals("skrbnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("skrbnik")) ? "</b>" : ""%>
		</td>
	
	    <td>
<%=(OrderBy != null && OrderBy.equals("vrsta_zavezanca")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("vrsta_zavezanca","utf-8") %>">Vrsta zavezanca&nbsp;<% if (OrderBy != null && OrderBy.equals("vrsta_zavezanca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("vrsta_zavezanca")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("interval_pavsala")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("interval_pavsala","utf-8") %>">Interval pavšala&nbsp;<% if (OrderBy != null && OrderBy.equals("interval_pavsala")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("interval_pavsala")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("datum_pricetka_pogodbe")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("datum_pricetka_pogodbe","utf-8") %>">Datum pričetka pogodbe&nbsp;<% if (OrderBy != null && OrderBy.equals("datum_pricetka_pogodbe")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("datum_pricetka_pogodbe")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("datum_sklenitve_pogodbe")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("datum_sklenitve_pogodbe","utf-8") %>">Datum sklenitve pogodbe&nbsp;<% if (OrderBy != null && OrderBy.equals("datum_sklenitve_pogodbe")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("datum_sklenitve_pogodbe")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("kontaktna_oseba")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("kontaktna_oseba","utf-8") %>">Kontaktna oseba&nbsp;<% if (OrderBy != null && OrderBy.equals("kontaktna_oseba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kontaktna_oseba")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("telefon_kontaktna")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("telefon_kontaktna","utf-8") %>">Telefon kontaktna&nbsp;<% if (OrderBy != null && OrderBy.equals("telefon_kontaktna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("telefon_kontaktna")) ? "</b>" : ""%>
		</td>		
	    <td>
<%=(OrderBy != null && OrderBy.equals("mail_kontaktna")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("mail_kontaktna","utf-8") %>">Mail kontaktna&nbsp;<% if (OrderBy != null && OrderBy.equals("mail_kontaktna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("mail_kontaktna")) ? "</b>" : ""%>
		</td>
	    <td nowrap>
<%=(OrderBy != null && OrderBy.equals("opombe_kontaktna")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("opombe_kontaktna","utf-8") %>">Opombe kontaktna&nbsp;<% if (OrderBy != null && OrderBy.equals("opombe_kontaktna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opombe_kontaktna")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("odgovorna_oseba")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("odgovorna_oseba","utf-8") %>">Odgovorna oseba&nbsp;<% if (OrderBy != null && OrderBy.equals("odgovorna_oseba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("odgovorna_oseba")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("telefon_odgovorna")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("telefon_odgovorna","utf-8") %>">Telefon odgovorna&nbsp;<% if (OrderBy != null && OrderBy.equals("telefon_odgovorna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("telefon_odgovorna")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("mail_odgovorna")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("mail_odgovorna","utf-8") %>">Mail odgovorna&nbsp;<% if (OrderBy != null && OrderBy.equals("mail_odgovorna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("mail_odgovorna")) ? "</b>" : ""%>
		</td>
	    <td nowrap>
<%=(OrderBy != null && OrderBy.equals("opombe_odgovorna")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("opombe_odgovorna","utf-8") %>">Opombe odgovorna&nbsp;<% if (OrderBy != null && OrderBy.equals("opombe_odgovorna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opombe_odgovorna")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("valuta")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("valuta","utf-8") %>">Valuta&nbsp;<% if (OrderBy != null && OrderBy.equals("valuta")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("valuta")) ? "</b>" : ""%>
		</td>
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("zacetek","utf-8") %>">Začetek&nbsp;<% if (OrderBy != null && OrderBy.equals("zacetek")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "</b>" : ""%>
		</td>
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "<b>" : ""%>
<a href="recikelzavezancilist.jsp?order=<%= java.net.URLEncoder.encode("uporabnik","utf-8") %>">Uporabnik&nbsp;<% if (OrderBy != null && OrderBy.equals("uporabnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelzavezanci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelzavezanci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
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
	String x_id = "";
	String x_st_pogodbe = "";
	String x_naziv = "";
	String x_naslov = "";
	String x_kraj = "";
	
	String x_posta = "";
	String x_davcna = "";
	String x_maticna = "";
	String x_mail = "";
	String x_dejavnost = "";
	String x_naslov_posiljanje = "";
	String x_kraj_posiljanje = "";
	String x_posta_posiljanje = "";
	String x_skrbnik = "";
	String x_vrsta_zavezanca = "";
	String x_interval_pavsala = "";
	Object x_datum_pricetka_pogodbe = "";
	Object x_datum_sklenitve_pogodbe = "";
	String x_valuta = "";
	String x_kontaktna_oseba = "";
	String x_telefon_kontaktna = "";
	String x_mail_kontaktna = "";
	String x_opombe_kontaktna = "";
	String x_odgovorna_oseba = "";
	String x_telefon_odgovorna = "";
	String x_mail_odgovorna = "";
	String x_opombe_odgovorna = "";
	
	Object x_zacetek = null;
	String x_uporabnik = "";

	// Load Key for record
	String key = "";
	if(rs.getString("id") != null){
		key = rs.getString("id");
	}
	
	if (rs.getString("st_pogodbe") != null){
		x_st_pogodbe = rs.getString("st_pogodbe");
	}else{
		x_st_pogodbe = "";
	}
	
	// sif_kupca
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}

	// kraj_naslov
	if (rs.getString("kraj") != null){
		x_kraj = rs.getString("kraj");
	}else{
		x_kraj = "";
	}

	// skupina
	if (rs.getString("naslov") != null){
		x_naslov = rs.getString("naslov");
	}else{
		x_naslov = "";
	}
	
	if (rs.getString("posta") != null){
		x_posta = rs.getString("posta");
	}else{
		x_posta = "";
	}

	if (rs.getString("davcna") != null){
		x_davcna = rs.getString("davcna");
	}else{
		x_davcna = "";
	}

	if (rs.getString("maticna") != null){
		x_maticna = rs.getString("maticna");
	}else{
		x_maticna = "";
	}

	if (rs.getString("mail") != null){
		x_mail = rs.getString("mail");
	}else{
		x_mail = "";
	}

	if (rs.getString("dejavnost") != null){
		x_dejavnost = rs.getString("dejavnost");
	}else{
		x_dejavnost = "";
	}
	
	if (rs.getString("naslov_posiljanje") != null){
		x_naslov_posiljanje = rs.getString("naslov_posiljanje");
	}else{
		x_naslov_posiljanje = "";
	}
	
	if (rs.getString("kraj_posiljanje") != null){
		x_kraj_posiljanje = rs.getString("kraj_posiljanje");
	}else{
		x_kraj_posiljanje = "";
	}
	
	if (rs.getString("posta_posiljanje") != null){
		x_posta_posiljanje = rs.getString("posta_posiljanje");
	}else{
		x_posta_posiljanje = "";
	}
	
	if (rs.getString("skrbnik") != null){
		x_skrbnik = rs.getString("skrbnik");
	}else{
		x_skrbnik = "";
	}
	
	if (rs.getString("vrsta_zavezanca") != null){
		x_vrsta_zavezanca = rs.getString("vrsta_zavezanca");
	}else{
		x_vrsta_zavezanca = "";
	}	
	
	if (rs.getString("interval_pavsala") != null){
		x_interval_pavsala = rs.getString("interval_pavsala");
	}else{
		x_interval_pavsala = "";
	}	
	
	if (rs.getTimestamp("datum_pricetka_pogodbe") != null){
		x_datum_pricetka_pogodbe = rs.getTimestamp("datum_pricetka_pogodbe");
	}else{
		x_datum_pricetka_pogodbe = "";
	}	
	
	if (rs.getTimestamp("datum_sklenitve_pogodbe") != null){
		x_datum_sklenitve_pogodbe = rs.getTimestamp("datum_sklenitve_pogodbe");
	}else{
		x_datum_sklenitve_pogodbe = "";
	}	
	
	if (rs.getString("valuta") != null){
		x_valuta = rs.getString("valuta");
	}else{
		x_valuta = "";
	}	
	
	if (rs.getString("kontaktna_oseba") != null){
		x_kontaktna_oseba = rs.getString("kontaktna_oseba");
	}else{
		x_kontaktna_oseba = "";
	}	
	
	if (rs.getString("telefon_kontaktna") != null){
		x_telefon_kontaktna = rs.getString("telefon_kontaktna");
	}else{
		x_telefon_kontaktna = "";
	}	
	
	if (rs.getString("mail_kontaktna") != null){
		x_mail_kontaktna = rs.getString("mail_kontaktna");
	}else{
		x_mail_kontaktna = "";
	}	
	
	if (rs.getString("opombe_kontaktna") != null){
		x_opombe_kontaktna = rs.getString("opombe_kontaktna");
	}else{
		x_opombe_kontaktna = "";
	}	
	
	if (rs.getString("odgovorna_oseba") != null){
		x_odgovorna_oseba = rs.getString("odgovorna_oseba");
	}else{
		x_odgovorna_oseba = "";
	}	
	
	if (rs.getString("telefon_odgovorna") != null){
		x_telefon_odgovorna = rs.getString("telefon_odgovorna");
	}else{
		x_telefon_odgovorna = "";
	}	
	
	if (rs.getString("mail_odgovorna") != null){
		x_mail_odgovorna = rs.getString("mail_odgovorna");
	}else{
		x_mail_odgovorna = "";
	}	
	
	if (rs.getString("opombe_odgovorna") != null){
		x_opombe_odgovorna = rs.getString("opombe_odgovorna");
	}else{
		x_opombe_odgovorna = "";
	}	


	// zacetek
	if (rs.getTimestamp("zacetek") != null){
		x_zacetek = rs.getTimestamp("zacetek");
	}else{
		x_zacetek = "";
	}

	// veljavnost
	if (rs.getString("uporabnisko_ime") != null){
		x_uporabnik = rs.getString("uporabnisko_ime");
	}else{
		x_uporabnik = "";
	}

%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("recikelzavezanciview.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("recikelzavezanciedit.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("recikelzavezanciadd.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Delete</span></td>
<% } %>
		<td><% out.print(x_st_pogodbe); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td><% out.print(x_naslov); %>&nbsp;</td>
		<td><% out.print(x_kraj); %>&nbsp;</td>

		<td><% out.print(x_posta); %>&nbsp;</td>
		<td><% out.print(x_davcna); %>&nbsp;</td>
		<td><% out.print(x_maticna); %>&nbsp;</td>
		<td><% out.print(x_mail); %>&nbsp;</td>
		<td><% out.print(x_dejavnost); %>&nbsp;</td>
		<td><% out.print(x_naslov_posiljanje); %>&nbsp;</td>
		<td><% out.print(x_kraj_posiljanje); %>&nbsp;</td>
		<td><% out.print(x_posta_posiljanje); %>&nbsp;</td>
		<td><% out.print(x_skrbnik); %>&nbsp;</td>
		<td><% out.print(x_vrsta_zavezanca); %>&nbsp;</td>
		<td><% out.print(x_interval_pavsala); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_datum_pricetka_pogodbe,7,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_datum_sklenitve_pogodbe,7,locale)); %>&nbsp;</td>
		<td><% out.print(x_kontaktna_oseba); %>&nbsp;</td>
		<td><% out.print(x_telefon_kontaktna); %>&nbsp;</td>
		<td><% out.print(x_mail_kontaktna); %>&nbsp;</td>
		<td><% out.print(x_opombe_kontaktna); %>&nbsp;</td>
		<td><% out.print(x_odgovorna_oseba); %>&nbsp;</td>
		<td><% out.print(x_telefon_odgovorna); %>&nbsp;</td>
		<td><% out.print(x_mail_odgovorna); %>&nbsp;</td>
		<td><% out.print(x_opombe_odgovorna); %>&nbsp;</td>
		<td><% out.print(x_valuta); %>&nbsp;</td>
	
		<td><% out.print(EW_FormatDateTime(x_zacetek,7,locale)); %>&nbsp;</td>
		<td nowrap><% out.print(EW_FormatDateTime(x_uporabnik,7,locale)); %>&nbsp;</td>
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
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='recikelzavezancidelete.jsp';this.form.submit();"></p>
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
	<td><a href="recikelzavezancilist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="recikelzavezancilist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="recikelzavezancilist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="recikelzavezancilist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<a href="recikelzavezanciadd.jsp"><img src="images/addnew.gif" alt="Dodaj" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
