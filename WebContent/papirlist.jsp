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
			b_search = b_search + "`koda` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`papir` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`papir2` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`koda_st` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`koda` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`papir` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`papir2` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`koda_st` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("papir_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("papir_REC", new Integer(startRec));
}else{
	if (session.getAttribute("papir_searchwhere") != null)
		searchwhere = (String) session.getAttribute("papir_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("papir_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("papir_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("papir_REC", new Integer(startRec));
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
	if (session.getAttribute("papir_OB") != null &&
		((String) session.getAttribute("papir_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("papir_OT")).equals("ASC")) {
			session.setAttribute("papir_OT", "DESC");
		}else{
			session.setAttribute("papir_OT", "ASC");
		}
	}else{
		session.setAttribute("papir_OT", "ASC");
	}
	session.setAttribute("papir_OB", OrderBy);
	session.setAttribute("papir_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("papir_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("papir_OB", OrderBy);
		session.setAttribute("papir_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `papir`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("papir_OT");
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
	session.setAttribute("papir_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("papir_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("papir_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("papir_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("papir_REC") != null)
		startRec = ((Integer) session.getAttribute("papir_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("papir_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABLE: papir</span></p>
<form action="papirlist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Quick Search (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="GO">
		&nbsp;&nbsp;<a href="papirlist.jsp?cmd=reset">Show all</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("koda","UTF-8") %>" style="color: #FFFFFF;">koda&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("papir","UTF-8") %>" style="color: #FFFFFF;">papir&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("papir")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("papir2","UTF-8") %>" style="color: #FFFFFF;">papir 2&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("papir2")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("pc_nizka","UTF-8") %>" style="color: #FFFFFF;">pc nizka&nbsp;<% if (OrderBy != null && OrderBy.equals("pc_nizka")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("koda_st","UTF-8") %>" style="color: #FFFFFF;">koda st&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("koda_st")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("str_dv","UTF-8") %>" style="color: #FFFFFF;">str dv&nbsp;<% if (OrderBy != null && OrderBy.equals("str_dv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp0","UTF-8") %>" style="color: #FFFFFF;">skp 0&nbsp;<% if (OrderBy != null && OrderBy.equals("skp0")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp1","UTF-8") %>" style="color: #FFFFFF;">skp 1&nbsp;<% if (OrderBy != null && OrderBy.equals("skp1")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp2","UTF-8") %>" style="color: #FFFFFF;">skp 2&nbsp;<% if (OrderBy != null && OrderBy.equals("skp2")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp3","UTF-8") %>" style="color: #FFFFFF;">skp 3&nbsp;<% if (OrderBy != null && OrderBy.equals("skp3")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp4","UTF-8") %>" style="color: #FFFFFF;">skp 4&nbsp;<% if (OrderBy != null && OrderBy.equals("skp4")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp5","UTF-8") %>" style="color: #FFFFFF;">skp 5&nbsp;<% if (OrderBy != null && OrderBy.equals("skp5")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp6","UTF-8") %>" style="color: #FFFFFF;">skp 6&nbsp;<% if (OrderBy != null && OrderBy.equals("skp6")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp7","UTF-8") %>" style="color: #FFFFFF;">skp 7&nbsp;<% if (OrderBy != null && OrderBy.equals("skp7")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="papirlist.jsp?order=<%= java.net.URLEncoder.encode("skp8","UTF-8") %>" style="color: #FFFFFF;">skp 8&nbsp;<% if (OrderBy != null && OrderBy.equals("skp8")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("papir_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("papir_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
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
	String x_koda = "";
	String x_papir = "";
	String x_papir2 = "";
	String x_pc_nizka = "";
	String x_koda_st = "";
	String x_str_dv = "";
	String x_skp0 = "";
	String x_skp1 = "";
	String x_skp2 = "";
	String x_skp3 = "";
	String x_skp4 = "";
	String x_skp5 = "";
	String x_skp6 = "";
	String x_skp7 = "";
	String x_skp8 = "";

	// Load Key for record
	String key = "";
	if(rs.getString("koda") != null){
		key = rs.getString("koda");
	}

	// koda
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}

	// papir
	if (rs.getString("papir") != null){
		x_papir = rs.getString("papir");
	}else{
		x_papir = "";
	}

	// papir2
	if (rs.getString("papir2") != null){
		x_papir2 = rs.getString("papir2");
	}else{
		x_papir2 = "";
	}

	// pc_nizka
	x_pc_nizka = String.valueOf(rs.getLong("pc_nizka"));

	// koda_st
	if (rs.getString("koda_st") != null){
		x_koda_st = rs.getString("koda_st");
	}else{
		x_koda_st = "";
	}

	// str_dv
	x_str_dv = String.valueOf(rs.getLong("str_dv"));

	// skp0
	x_skp0 = String.valueOf(rs.getLong("skp0"));

	// skp1
	x_skp1 = String.valueOf(rs.getLong("skp1"));

	// skp2
	x_skp2 = String.valueOf(rs.getLong("skp2"));

	// skp3
	x_skp3 = String.valueOf(rs.getLong("skp3"));

	// skp4
	x_skp4 = String.valueOf(rs.getLong("skp4"));

	// skp5
	x_skp5 = String.valueOf(rs.getLong("skp5"));

	// skp6
	x_skp6 = String.valueOf(rs.getLong("skp6"));

	// skp7
	x_skp7 = String.valueOf(rs.getLong("skp7"));

	// skp8
	x_skp8 = String.valueOf(rs.getLong("skp8"));
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_koda); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_papir); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_papir2); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_pc_nizka); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_koda_st); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_str_dv); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp0); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp1); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp2); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp3); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp4); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp5); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp6); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp7); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_skp8); %></span>&nbsp;</td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("koda"); 
if (key != null && key.length() > 0) { 
	out.print("papirview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">View</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("koda"); 
if (key != null && key.length() > 0) { 
	out.print("papiredit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Edit</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("koda"); 
if (key != null && key.length() > 0) { 
	out.print("papiradd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Copy</a></span></td>
<td><span class="jspmaker"><a href="<% key =  rs.getString("koda"); 
if (key != null && key.length() > 0) { 
	out.print("papirdelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Delete</a></span></td>
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
	<td><a href="papirlist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="papirlist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="papirlist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="papirlist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
	<td><a href="papiradd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<p>
<a href="papiradd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
