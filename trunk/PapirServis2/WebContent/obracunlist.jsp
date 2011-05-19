<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
response.setDateHeader("Expires", 0); // date in the past
response.addHeader("Cache-Control", "no-store, no-cache, must-revalidate"); // HTTP/1.1 
response.addHeader("Cache-Control", "post-check=0, pre-check=0"); 
response.addHeader("Pragma", "no-cache"); // HTTP/1.0 
%>
<% Locale locale = Locale.getDefault();
response.setLocale(locale);%>
<% session.setMaxInactiveInterval(30*60); %>
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
			b_search = b_search + "`naziv` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`naslov` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`kraj` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`telefon` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`telefax` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`kont_os` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`del_cas` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`sif_os` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`opomba` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`opomba2` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`opomba3` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`sif_kupca` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`najem` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`naziv` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`naslov` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`kraj` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`telefon` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`telefax` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`kont_os` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`del_cas` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`sif_os` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`opomba` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`opomba2` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`opomba3` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`sif_kupca` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`najem` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("obracun_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("obracun_REC", new Integer(startRec));
}else{
	if (session.getAttribute("obracun_searchwhere") != null)
		searchwhere = (String) session.getAttribute("obracun_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("obracun_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("obracun_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("obracun_REC", new Integer(startRec));
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
	if (session.getAttribute("obracun_OB") != null &&
		((String) session.getAttribute("obracun_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {
			session.setAttribute("obracun_OT", "DESC");
		}else{
			session.setAttribute("obracun_OT", "ASC");
		}
	}else{
		session.setAttribute("obracun_OT", "ASC");
	}
	session.setAttribute("obracun_OB", OrderBy);
	session.setAttribute("obracun_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("obracun_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("obracun_OB", OrderBy);
		session.setAttribute("obracun_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `obracun`";
whereClause = "";
if (DefaultFilter.length() > 0) {
	whereClause = whereClause + "(" + DefaultFilter + ") AND ";
}
if (dbwhere.length() > 0) {
	whereClause = whereClause + "(" + dbwhere + ") AND ";
}
if (whereClause.length() > 5 && whereClause.substring(whereClause.length()-5, whereClause.length()).equals(" AND ")) {
	whereClause = whereClause.substring(0, whereClause.length()-5);
}
if (whereClause.length() > 0) {
	strsql = strsql + " WHERE " + whereClause;
}
if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("obracun_OT");
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
	session.setAttribute("obracun_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("obracun_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("obracun_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("obracun_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("obracun_REC") != null)
		startRec = ((Integer) session.getAttribute("obracun_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("obracun_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABLE: obracun</span></p>
<form action="obracunlist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Quick Search (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="GO">
		&nbsp;&nbsp;<a href="obracunlist.jsp?cmd=reset">Show all</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("sif_str","UTF-8") %>" style="color: #FFFFFF;">sif str&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_str")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("naziv","UTF-8") %>" style="color: #FFFFFF;">naziv&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("naziv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("naslov","UTF-8") %>" style="color: #FFFFFF;">naslov&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("naslov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("posta","UTF-8") %>" style="color: #FFFFFF;">posta&nbsp;<% if (OrderBy != null && OrderBy.equals("posta")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("kraj","UTF-8") %>" style="color: #FFFFFF;">kraj&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("kraj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("telefon","UTF-8") %>" style="color: #FFFFFF;">telefon&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("telefon")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("telefax","UTF-8") %>" style="color: #FFFFFF;">telefax&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("telefax")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("kont_os","UTF-8") %>" style="color: #FFFFFF;">kont os&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("kont_os")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("del_cas","UTF-8") %>" style="color: #FFFFFF;">del cas&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("del_cas")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("sif_os","UTF-8") %>" style="color: #FFFFFF;">sif os&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_os")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("kol_os","UTF-8") %>" style="color: #FFFFFF;">kol os&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_os")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("dan","UTF-8") %>" style="color: #FFFFFF;">dan&nbsp;<% if (OrderBy != null && OrderBy.equals("dan")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("perioda","UTF-8") %>" style="color: #FFFFFF;">perioda&nbsp;<% if (OrderBy != null && OrderBy.equals("perioda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("opomba","UTF-8") %>" style="color: #FFFFFF;">opomba&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("opomba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("opomba2","UTF-8") %>" style="color: #FFFFFF;">opomba 2&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("opomba2")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("opomba3","UTF-8") %>" style="color: #FFFFFF;">opomba 3&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("opomba3")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>" style="color: #FFFFFF;">sif kupca&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("cena","UTF-8") %>" style="color: #FFFFFF;">cena&nbsp;<% if (OrderBy != null && OrderBy.equals("cena")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("najem","UTF-8") %>" style="color: #FFFFFF;">najem&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("najem")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="obracunlist.jsp?order=<%= java.net.URLEncoder.encode("cena_naj","UTF-8") %>" style="color: #FFFFFF;">cena naj&nbsp;<% if (OrderBy != null && OrderBy.equals("cena_naj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("obracun_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("obracun_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
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
	String bgcolor = "#FFFFFF"; // Set row color
%>
<%
	if (recCount%2 != 0) { // Display alternate color for rows
		bgcolor = "#F5F5F5";
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
	String x_dan = "";
	String x_perioda = "";
	String x_opomba = "";
	String x_opomba2 = "";
	String x_opomba3 = "";
	String x_sif_kupca = "";
	String x_cena = "";
	String x_najem = "";
	String x_cena_naj = "";

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
	x_posta = String.valueOf(rs.getLong("posta"));

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

	// dan
	x_dan = String.valueOf(rs.getLong("dan"));

	// perioda
	x_perioda = String.valueOf(rs.getLong("perioda"));

	// opomba
	if (rs.getString("opomba") != null){
		x_opomba = rs.getString("opomba");
	}else{
		x_opomba = "";
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

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}

	// cena
	x_cena = String.valueOf(rs.getLong("cena"));

	// najem
	if (rs.getString("najem") != null){
		x_najem = rs.getString("najem");
	}else{
		x_najem = "";
	}

	// cena_naj
	x_cena_naj = String.valueOf(rs.getLong("cena_naj"));
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_sif_str); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_naziv); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_naslov); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_posta); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_kraj); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_telefon); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_telefax); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_kont_os); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_del_cas); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sif_os); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_kol_os); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_dan); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_perioda); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_opomba); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_opomba2); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_opomba3); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sif_kupca); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_cena); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_najem); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_cena_naj); %></span>&nbsp;</td>
	</tr>
<%

//	}
}
}
%>
</table>
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
	<td><a href="obracunlist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="obracunlist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="obracunlist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="obracunlist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
	<span class="jspmaker">No records found</span>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
