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
int displayRecs = 1000;
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
String od_datum = request.getParameter("od_datum");
String do_datum = request.getParameter("do_datum");
String skupina = request.getParameter("skupina");
//out.println(skupina);
if (od_datum != null && od_datum.length() > 0)
	session.setAttribute("od_datum", od_datum);
else
	od_datum = (String) session.getAttribute("od_datum");
if (do_datum != null && do_datum.length() > 0)
	session.setAttribute("do_datum", do_datum);
else
	do_datum = (String) session.getAttribute("do_datum");
if (skupina != null && skupina.length() > 0)
	session.setAttribute("skupina", skupina);
else
	skupina = (String) session.getAttribute("skupina");

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
			b_search = b_search + "`dob`.`stranka` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`st_dob` LIKE '" + kw + "' OR ";
			b_search = b_search + "`dob`.`datum` = STR_TO_DATE('" + kw + "', '%d.%m.%Y') OR ";
			b_search = b_search + "`dob`.`koda` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`ewc` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`dob`.`stranka` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`st_dob` LIKE '" + pSearch + "' OR ";
		b_search = b_search + "`dob`.`datum` = STR_TO_DATE('" + pSearch + "', '%d.%m.%Y') OR ";
		b_search = b_search + "`dob`.`koda` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`ewc` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("arso_new_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("arso_new_REC", new Integer(startRec));
}else{
	if (session.getAttribute("arso_new_searchwhere") != null)
		searchwhere = (String) session.getAttribute("arso_new_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("arso_new_searchwhere", searchwhere);
		session.removeAttribute("arso_new_OB");
		od_datum = null;
		do_datum = null;
		skupina = null;
		session.setAttribute("od_datum", od_datum);
		session.setAttribute("do_datum", do_datum);
		session.setAttribute("skupina", skupina);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("arso_new_searchwhere", searchwhere);
		od_datum = null;
		do_datum = null;
		skupina = null;
		session.setAttribute("od_datum", od_datum);
		session.setAttribute("do_datum", do_datum);
		session.setAttribute("skupina", skupina);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("arso_new_REC", new Integer(startRec));
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
	if (session.getAttribute("arso_new_OB") != null &&
		((String) session.getAttribute("arso_new_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) {
			session.setAttribute("arso_new_OT", "DESC");
		}else{
			session.setAttribute("arso_new_OT", "ASC");
		}
	}else{
		session.setAttribute("arso_new_OT", "ASC");
	}
	session.setAttribute("arso_new_OB", OrderBy);
	session.setAttribute("arso_new_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("arso_new_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("arso_new_OB", OrderBy);
		session.setAttribute("arso_new_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
//String strsql = "SELECT dob.*, kupci.naziv " +
//					 "FROM (select *, max(dob.zacetek) from " + session.getAttribute("letoTabela") + " dob group by st_dob) dob " +
//					 "left join kupci on (dob.sif_kupca = kupci.sif_kupca) ";
String strsql = 	"SELECT date_format(dob.datum, '%d.%m.%Y') as datum_odaje, dob.*, " +
						"	kupci.naziv, kupci.maticna kupci_maticna, kupci.arso_pslj_st, kupci.arso_pslj_status, " +
						"	enote.maticna enote_maticna, enote.arso_prjm_st, enote.arso_prjm_status, enote.arso_odp_locpr_id,  " +
						"	kamion.maticna kamion_maticna, kamion.arso_prvz_st, kamion.arso_prvz_status, " +
						"	str.arso_odp_loc_id, " +
						"	mat.arso_odp_locpr_id material_arso_odp_locpr_id " +
						" FROM (select *, max(dob.zacetek) from " + session.getAttribute("letoTabela") + " dob group by st_dob, pozicija) dob " + 
						" LEFT JOIN kupci ON (dob.sif_kupca = kupci.sif_kupca) " +
						" LEFT JOIN enote on (kupci.sif_enote = enote.sif_enote) " +
						" LEFT JOIN ( " +
						"		SELECT kamion.* " +
						"		FROM kamion, ( " +
						"		SELECT sif_kam, MAX(zacetek) zac " +
						"		FROM kamion " +
						"		GROUP BY sif_kam) zadnji " +
						"		WHERE kamion.sif_kam = zadnji.sif_kam AND kamion.zacetek = zadnji.zac) kamion ON (dob.sif_kam = kamion.sif_kam) " +
						" LEFT JOIN (select stranke.* " +
						"			from stranke, (select sif_str, max(zacetek) zac from stranke group by sif_str) zadnji " +
						"			where stranke.sif_str = zadnji.sif_str and stranke.zacetek = zadnji.zac) str " +
						"		ON (dob.sif_str = str.sif_str) " +
						" LEFT JOIN (select materiali.* " +
						"			from materiali, (select koda, max(zacetek) zac from materiali group by koda) zadnji1 " +
						"			where materiali.koda = zadnji1.koda and materiali.zacetek = zadnji1.zac) mat " +
						"		ON (dob.koda = mat.koda) ";

whereClause = " arso_status = 0 AND dob.arso_prenos = 0 AND obdelana = 1 AND kolicina > 0 AND ";
if (od_datum != null && od_datum.length() > 0) {
	whereClause = whereClause + " dob.datum >= '" + (EW_UnFormatDateTime((String)od_datum,"EURODATE", locale)).toString() + "' AND ";
}
if (do_datum != null && do_datum.length() > 0) {
	whereClause = whereClause + " dob.datum <= '" + (EW_UnFormatDateTime((String)do_datum,"EURODATE", locale)).toString() + "' AND ";
}
if (skupina != null && skupina.length() > 0 && !skupina.equals("-1")) {
	whereClause = whereClause + " dob.skupina = " + skupina + " AND ";
}
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("arso_new_OT");
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
	session.setAttribute("arso_new_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("arso_new_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("arso_new_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("arso_new_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("arso_new_REC") != null)
		startRec = ((Integer) session.getAttribute("arso_new_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("arso_new_REC", new Integer(startRec));
	}
}



%>
<%@ include file="header.jsp" %>
<script language="JavaScript" src="papirservis.js"></script>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: arso paketi</span></p>
<form action="arsopaketinew.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="arsopaketinew.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
</table>
</form>
<form method="post" id="arsopaketinew">
<table class="ewTable">
	<tr class="ewTableHeader">
<td nowrap>
<img src="images/checkall.gif" alt="Vsi" width="20" height="20" border="0" onClick='izberiVse2(true);'>
<img src="images/uncheckall.gif" alt="Noben" width="20" height="20" border="0" onClick='izberiVse2(false);'>
</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("st_dob")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("st_dob","UTF-8") %>">Številka dobavnice(*)&nbsp;<% if (OrderBy != null && OrderBy.equals("st_dob")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("st_dob")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("pozicija")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("pozicija","UTF-8") %>">Pozicija&nbsp;<% if (OrderBy != null && OrderBy.equals("pozicija")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("pozicija")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("datum","UTF-8") %>">Datum(*)&nbsp;<% if (OrderBy != null && OrderBy.equals("datum")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_str")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("sif_str","UTF-8") %>">Šifra stranke&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_str")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_str")) ? "</b>" : ""%>
		</td>
		<td id="td1">
<%=(OrderBy != null && OrderBy.equals("stranka")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("stranka","UTF-8") %>">Stranka&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("stranka")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("stranka")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>">Šifra kupca&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td id="td1">
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>">Kupac&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("koda","UTF-8") %>">Koda&nbsp;<% if (OrderBy != null && OrderBy.equals("koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("ewc")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("koda","UTF-8") %>">EWC&nbsp;<% if (OrderBy != null && OrderBy.equals("ewc")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("ewc")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kolicina")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("kolicina","UTF-8") %>">Količina&nbsp;<% if (OrderBy != null && OrderBy.equals("kolicina")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kolicina")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_odp_embalaza")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_odp_embalaza","UTF-8") %>">Arso vrts emb.&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_odp_embalaza")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_odp_embalaza")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_emb_st_enot")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_emb_st_enot","UTF-8") %>">Arso št. enot emb.&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_emb_st_enot")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_emb_st_enot")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_odp_fiz_last")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_odp_fiz_last","UTF-8") %>">Arso fizikalna lastnost&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_odp_fiz_last")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_odp_fiz_last")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_odp_tip")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_odp_tip","UTF-8") %>">Arso tip odpadka&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_odp_tip")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_odp_tip")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_aktivnost_pslj")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_aktivnost_pslj","UTF-8") %>">Arso aktivnost nastanka&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_aktivnost_pslj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_aktivnost_pslj")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_prjm_status")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_prjm_status","UTF-8") %>">Arso status prejemnika&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_prjm_status")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_prjm_status")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_aktivnost_prjm")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_aktivnost_prjm","UTF-8") %>">Arso postopek ravnanja&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_aktivnost_prjm")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_aktivnost_prjm")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_odp_embalaza_shema")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_odp_embalaza_shema","UTF-8") %>">Arso embalaža shema&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_odp_embalaza_shema")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_odp_embalaza_shema")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_odp_dej_nastanka")) ? "<b>" : ""%>
<a href="arsopaketinew.jsp?order=<%= java.net.URLEncoder.encode("arso_odp_dej_nastanka","UTF-8") %>">Arso dejavnost nastanka&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_odp_dej_nastanka")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_new_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_new_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_odp_dej_nastanka")) ? "</b>" : ""%>
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
	//
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
	String x_st_dob = "";
	String x_pozicija = "";
	Object x_datum = null;
	String x_sif_str = "";
	String x_stranka = "";
	String x_sif_kupca = "";
	String x_koda = "";
	String x_ewc = "";
	String x_kolicina = "";
	String x_arso_odp_embalaza = "";
	String x_arso_emb_st_enot = "";
	String x_arso_odp_fiz_last = "";
	String x_arso_odp_tip = "";
	String x_arso_aktivnost_pslj = "";
	String x_arso_aktivnost_prjm = "";
	String x_arso_prjm_status = "";
	String x_arso_odp_embalaza_shema = "";
	String x_arso_odp_dej_nastanka = "";

	// Load Key for record
	String key = "";
	key = String.valueOf(rs.getLong("id"))+"-"+String.valueOf(rs.getLong("st_dob"))+"-"+String.valueOf(rs.getLong("pozicija"));

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

	// sif_str
	x_sif_str = String.valueOf(rs.getLong("sif_str"));

	// stranka
	if (rs.getString("stranka") != null){
		x_stranka = rs.getString("stranka");
	}else{
		x_stranka = "";
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
	
	// kolicina
	x_kolicina = String.valueOf(rs.getLong("kolicina"));


	// arso_odp_embalaza
	if (rs.getString("arso_odp_embalaza") != null){
		x_arso_odp_embalaza = rs.getString("arso_odp_embalaza");
	}else{
		x_arso_odp_embalaza = "";
	}

	// arso_emb_st_enot
	if (rs.getString("arso_emb_st_enot") != null){
		x_arso_emb_st_enot = rs.getString("arso_emb_st_enot");
	}else{
		x_arso_emb_st_enot = "";
	}

	// arso_odp_fiz_last
	if (rs.getString("arso_odp_fiz_last") != null){
		x_arso_odp_fiz_last = rs.getString("arso_odp_fiz_last");
	}else{
		x_arso_odp_fiz_last = "";
	}

	// arso_odp_tip
	if (rs.getString("arso_odp_tip") != null){
		x_arso_odp_tip = rs.getString("arso_odp_tip");
	}else{
		x_arso_odp_tip = "";
	}

	// arso_aktivnost_pslj
	if (rs.getString("arso_aktivnost_pslj") != null){
		x_arso_aktivnost_pslj = rs.getString("arso_aktivnost_pslj");
	}else{
		x_arso_aktivnost_pslj = "";
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

	// arso_odp_embalaza_shema
	if (rs.getString("arso_odp_embalaza_shema") != null){
		x_arso_odp_embalaza_shema = rs.getString("arso_odp_embalaza_shema");
	}else{
		x_arso_odp_embalaza_shema = "";
	}

	// arso_odp_dej_nastanka
	if (rs.getString("arso_odp_dej_nastanka") != null){
		x_arso_odp_dej_nastanka = rs.getString("arso_odp_dej_nastanka");
	}else{
		x_arso_odp_dej_nastanka = "";
	}



%>
	<tr class=<% out.print(rowclass); %> >
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" id="key" value="<%=key %>" class="jspmaker">Izberi</span></td>
<% } else {%>
<td></td>
<% } %>
		<td><% out.print(x_st_dob); %>&nbsp;</td>
		<td><% out.print(x_pozicija); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_datum,7,locale)); %>&nbsp;</td>
		<td><% out.print(x_sif_str);%>&nbsp;</td>
		<td><%out.print(rs.getString("stranka"));%>&nbsp;</td>
		<td><%out.print(x_sif_kupca);%>&nbsp;</td>
		<td><%out.print(rs.getString("kupci.naziv"));%>&nbsp;</td>	
		<td><%out.print(rs.getString("dob.koda"));%>&nbsp;</td>
		<td><%out.print(rs.getString("dob.ewc"));%>&nbsp;</td>
		<td><% out.print(x_kolicina); %>&nbsp;</td>
		<td><% out.print(x_arso_odp_embalaza); %>&nbsp;</td>
		<td><% out.print(x_arso_emb_st_enot); %>&nbsp;</td>
		<td><% out.print(x_arso_odp_fiz_last); %>&nbsp;</td>
		<td><% out.print(x_arso_odp_tip); %>&nbsp;</td>
		<td><% out.print(x_arso_aktivnost_pslj); %>&nbsp;</td>
		<td><% out.print(x_arso_prjm_status); %>&nbsp;</td>
		<td><% out.print(x_arso_aktivnost_prjm); %>&nbsp;</td>
		<td><% out.print(x_arso_odp_embalaza_shema); %>&nbsp;</td>
		<td><% out.print(x_arso_odp_dej_nastanka); %>&nbsp;</td>
	</tr>
<%

//	}
}
}
%>
</table>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Potrdi izbrane" onClick='arsoPrepareXML(this.form.key, "<%out.print(session.getAttribute("letoTabela")); %>", "<%out.print(session.getAttribute("papirservis1_status_UserID")); %>", "<%out.print(EW_UnFormatDateTime((String)od_datum,"EURODATE", locale)); %>", "<%out.print(EW_UnFormatDateTime((String)do_datum,"EURODATE", locale)); %>", "<%out.print(skupina); %>", "<%out.print(session.getAttribute("papirservis1_status_User")); %>", false ) '></p>
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
	<td><a href="arsopaketinew.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="arsopaketinew.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="arsopaketinew.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="arsopaketinew.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
</p>
<% } %>
</td></tr></table>


<%@ include file="footer.jsp" %>