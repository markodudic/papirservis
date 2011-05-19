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
			b_search = b_search + "`sif_kupca` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`sif_sof` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`sif_kam` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`koda` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`sif_kupca` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`sif_sof` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`sif_kam` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`koda` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("dobmi_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("dobmi_REC", new Integer(startRec));
}else{
	if (session.getAttribute("dobmi_searchwhere") != null)
		searchwhere = (String) session.getAttribute("dobmi_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("dobmi_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("dobmi_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("dobmi_REC", new Integer(startRec));
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
	if (session.getAttribute("dobmi_OB") != null &&
		((String) session.getAttribute("dobmi_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {
			session.setAttribute("dobmi_OT", "DESC");
		}else{
			session.setAttribute("dobmi_OT", "ASC");
		}
	}else{
		session.setAttribute("dobmi_OT", "ASC");
	}
	session.setAttribute("dobmi_OB", OrderBy);
	session.setAttribute("dobmi_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("dobmi_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("dobmi_OB", OrderBy);
		session.setAttribute("dobmi_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `dobmi`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("dobmi_OT");
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
	session.setAttribute("dobmi_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("dobmi_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("dobmi_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("dobmi_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("dobmi_REC") != null)
		startRec = ((Integer) session.getAttribute("dobmi_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("dobmi_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABLE: dobmi</span></p>
<form action="dobmilist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Quick Search (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="GO">
		&nbsp;&nbsp;<a href="dobmilist.jsp?cmd=reset">Show all</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("st_dob","UTF-8") %>" style="color: #FFFFFF;">st dob&nbsp;<% if (OrderBy != null && OrderBy.equals("st_dob")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("pozicija","UTF-8") %>" style="color: #FFFFFF;">pozicija&nbsp;<% if (OrderBy != null && OrderBy.equals("pozicija")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("datum","UTF-8") %>" style="color: #FFFFFF;">datum&nbsp;<% if (OrderBy != null && OrderBy.equals("datum")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("sif_str","UTF-8") %>" style="color: #FFFFFF;">sif str&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_str")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>" style="color: #FFFFFF;">sif kupca&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("sif_sof","UTF-8") %>" style="color: #FFFFFF;">sif sof&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_sof")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("sif_kam","UTF-8") %>" style="color: #FFFFFF;">sif kam&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_kam")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("stev_km","UTF-8") %>" style="color: #FFFFFF;">stev km&nbsp;<% if (OrderBy != null && OrderBy.equals("stev_km")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("stev_ur","UTF-8") %>" style="color: #FFFFFF;">stev ur&nbsp;<% if (OrderBy != null && OrderBy.equals("stev_ur")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("stroski","UTF-8") %>" style="color: #FFFFFF;">stroski&nbsp;<% if (OrderBy != null && OrderBy.equals("stroski")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("koda","UTF-8") %>" style="color: #FFFFFF;">koda&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("kol_n","UTF-8") %>" style="color: #FFFFFF;">kol n&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_n")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("psp_kg","UTF-8") %>" style="color: #FFFFFF;">psp kg&nbsp;<% if (OrderBy != null && OrderBy.equals("psp_kg")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("opomba","UTF-8") %>" style="color: #FFFFFF;">opomba&nbsp;<% if (OrderBy != null && OrderBy.equals("opomba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("kg_zaup","UTF-8") %>" style="color: #FFFFFF;">kg zaup&nbsp;<% if (OrderBy != null && OrderBy.equals("kg_zaup")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("sit_zaup","UTF-8") %>" style="color: #FFFFFF;">sit zaup&nbsp;<% if (OrderBy != null && OrderBy.equals("sit_zaup")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("kg_sort","UTF-8") %>" style="color: #FFFFFF;">kg sort&nbsp;<% if (OrderBy != null && OrderBy.equals("kg_sort")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("sit_sort","UTF-8") %>" style="color: #FFFFFF;">sit sort&nbsp;<% if (OrderBy != null && OrderBy.equals("sit_sort")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("sit_smet","UTF-8") %>" style="color: #FFFFFF;">sit smet&nbsp;<% if (OrderBy != null && OrderBy.equals("sit_smet")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("skupina","UTF-8") %>" style="color: #FFFFFF;">skupina&nbsp;<% if (OrderBy != null && OrderBy.equals("skupina")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="dobmilist.jsp?order=<%= java.net.URLEncoder.encode("znes_rv","UTF-8") %>" style="color: #FFFFFF;">znes rv&nbsp;<% if (OrderBy != null && OrderBy.equals("znes_rv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobmi_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("dobmi_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	String x_st_dob = "";
	String x_pozicija = "";
	Object x_datum = null;
	String x_sif_str = "";
	String x_sif_kupca = "";
	String x_sif_sof = "";
	String x_sif_kam = "";
	String x_stev_km = "";
	String x_stev_ur = "";
	String x_stroski = "";
	String x_koda = "";
	String x_kol_n = "";
	String x_psp_kg = "";
	String x_opomba = "";
	String x_kg_zaup = "";
	String x_sit_zaup = "";
	String x_kg_sort = "";
	String x_sit_sort = "";
	String x_sit_smet = "";
	String x_skupina = "";
	String x_znes_rv = "";

	// Load Key for record
	String key = "";

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

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}

	// sif_sof
	if (rs.getString("sif_sof") != null){
		x_sif_sof = rs.getString("sif_sof");
	}else{
		x_sif_sof = "";
	}

	// sif_kam
	if (rs.getString("sif_kam") != null){
		x_sif_kam = rs.getString("sif_kam");
	}else{
		x_sif_kam = "";
	}

	// stev_km
	x_stev_km = String.valueOf(rs.getLong("stev_km"));

	// stev_ur
	x_stev_ur = String.valueOf(rs.getLong("stev_ur"));

	// stroski
	x_stroski = String.valueOf(rs.getLong("stroski"));

	// koda
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}

	// kol_n
	x_kol_n = String.valueOf(rs.getLong("kol_n"));

	// psp_kg
	x_psp_kg = String.valueOf(rs.getLong("psp_kg"));

	// opomba
	x_opomba = String.valueOf(rs.getLong("opomba"));

	// kg_zaup
	x_kg_zaup = String.valueOf(rs.getLong("kg_zaup"));

	// sit_zaup
	x_sit_zaup = String.valueOf(rs.getLong("sit_zaup"));

	// kg_sort
	x_kg_sort = String.valueOf(rs.getLong("kg_sort"));

	// sit_sort
	x_sit_sort = String.valueOf(rs.getLong("sit_sort"));

	// sit_smet
	x_sit_smet = String.valueOf(rs.getLong("sit_smet"));

	// skupina
	x_skupina = String.valueOf(rs.getLong("skupina"));

	// znes_rv
	x_znes_rv = String.valueOf(rs.getLong("znes_rv"));
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_st_dob); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_pozicija); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(EW_FormatDateTime(x_datum,5,locale)); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sif_str); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sif_kupca); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sif_sof); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sif_kam); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_stev_km); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_stev_ur); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_stroski); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_koda); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_kol_n); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_psp_kg); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_opomba); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_kg_zaup); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sit_zaup); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_kg_sort); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sit_sort); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sit_smet); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skupina); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_znes_rv); %></span>&nbsp;</td>
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
	<td><a href="dobmilist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobmilist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobmilist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobmilist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
