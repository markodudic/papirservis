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
			b_search = b_search + "`vrsta1` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`vrsta2` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`vrsta3` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`vrsta4` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`vrsta5` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`vrsta6` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`vrsta7` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`direktor` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`fakturir` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`ziro_racun` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`vrsta1` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`vrsta2` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`vrsta3` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`vrsta4` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`vrsta5` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`vrsta6` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`vrsta7` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`direktor` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`fakturir` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`ziro_racun` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("glava_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("glava_REC", new Integer(startRec));
}else{
	if (session.getAttribute("glava_searchwhere") != null)
		searchwhere = (String) session.getAttribute("glava_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("glava_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("glava_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("glava_REC", new Integer(startRec));
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
	if (session.getAttribute("glava_OB") != null &&
		((String) session.getAttribute("glava_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("glava_OT")).equals("ASC")) {
			session.setAttribute("glava_OT", "DESC");
		}else{
			session.setAttribute("glava_OT", "ASC");
		}
	}else{
		session.setAttribute("glava_OT", "ASC");
	}
	session.setAttribute("glava_OB", OrderBy);
	session.setAttribute("glava_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("glava_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("glava_OB", OrderBy);
		session.setAttribute("glava_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `glava`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("glava_OT");
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
	session.setAttribute("glava_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("glava_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("glava_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("glava_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("glava_REC") != null)
		startRec = ((Integer) session.getAttribute("glava_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("glava_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABLE: glava</span></p>
<form action="glavalist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Quick Search (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="GO">
		&nbsp;&nbsp;<a href="glavalist.jsp?cmd=reset">Show all</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("vrsta1","UTF-8") %>" style="color: #FFFFFF;">vrsta 1&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("vrsta1")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("vrsta2","UTF-8") %>" style="color: #FFFFFF;">vrsta 2&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("vrsta2")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("vrsta3","UTF-8") %>" style="color: #FFFFFF;">vrsta 3&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("vrsta3")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("vrsta4","UTF-8") %>" style="color: #FFFFFF;">vrsta 4&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("vrsta4")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("vrsta5","UTF-8") %>" style="color: #FFFFFF;">vrsta 5&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("vrsta5")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("vrsta6","UTF-8") %>" style="color: #FFFFFF;">vrsta 6&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("vrsta6")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("vrsta7","UTF-8") %>" style="color: #FFFFFF;">vrsta 7&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("vrsta7")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("direktor","UTF-8") %>" style="color: #FFFFFF;">direktor&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("direktor")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("fakturir","UTF-8") %>" style="color: #FFFFFF;">fakturir&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("fakturir")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="glavalist.jsp?order=<%= java.net.URLEncoder.encode("ziro_racun","UTF-8") %>" style="color: #FFFFFF;">ziro racun&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("ziro_racun")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("glava_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("glava_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	String x_vrsta1 = "";
	String x_vrsta2 = "";
	String x_vrsta3 = "";
	String x_vrsta4 = "";
	String x_vrsta5 = "";
	String x_vrsta6 = "";
	String x_vrsta7 = "";
	String x_direktor = "";
	String x_fakturir = "";
	String x_ziro_racun = "";

	// vrsta1
	if (rs.getString("vrsta1") != null){
		x_vrsta1 = rs.getString("vrsta1");
	}else{
		x_vrsta1 = "";
	}

	// vrsta2
	if (rs.getString("vrsta2") != null){
		x_vrsta2 = rs.getString("vrsta2");
	}else{
		x_vrsta2 = "";
	}

	// vrsta3
	if (rs.getString("vrsta3") != null){
		x_vrsta3 = rs.getString("vrsta3");
	}else{
		x_vrsta3 = "";
	}

	// vrsta4
	if (rs.getString("vrsta4") != null){
		x_vrsta4 = rs.getString("vrsta4");
	}else{
		x_vrsta4 = "";
	}

	// vrsta5
	if (rs.getString("vrsta5") != null){
		x_vrsta5 = rs.getString("vrsta5");
	}else{
		x_vrsta5 = "";
	}

	// vrsta6
	if (rs.getString("vrsta6") != null){
		x_vrsta6 = rs.getString("vrsta6");
	}else{
		x_vrsta6 = "";
	}

	// vrsta7
	if (rs.getString("vrsta7") != null){
		x_vrsta7 = rs.getString("vrsta7");
	}else{
		x_vrsta7 = "";
	}

	// direktor
	if (rs.getString("direktor") != null){
		x_direktor = rs.getString("direktor");
	}else{
		x_direktor = "";
	}

	// fakturir
	if (rs.getString("fakturir") != null){
		x_fakturir = rs.getString("fakturir");
	}else{
		x_fakturir = "";
	}

	// ziro_racun
	if (rs.getString("ziro_racun") != null){
		x_ziro_racun = rs.getString("ziro_racun");
	}else{
		x_ziro_racun = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_vrsta1); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_vrsta2); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_vrsta3); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_vrsta4); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_vrsta5); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_vrsta6); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_vrsta7); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_direktor); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_fakturir); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_ziro_racun); %></span>&nbsp;</td>
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
	<td><a href="glavalist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="glavalist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="glavalist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="glavalist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
