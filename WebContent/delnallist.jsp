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
			b_search = b_search + "`stranka` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`sif_sof` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`sofer` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`opom` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`opom2` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`opom3` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`stranka` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`sif_sof` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`sofer` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`opom` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`opom2` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`opom3` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("delnal_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("delnal_REC", new Integer(startRec));
}else{
	if (session.getAttribute("delnal_searchwhere") != null)
		searchwhere = (String) session.getAttribute("delnal_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("delnal_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("delnal_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("delnal_REC", new Integer(startRec));
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
	if (session.getAttribute("delnal_OB") != null &&
		((String) session.getAttribute("delnal_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("delnal_OT")).equals("ASC")) {
			session.setAttribute("delnal_OT", "DESC");
		}else{
			session.setAttribute("delnal_OT", "ASC");
		}
	}else{
		session.setAttribute("delnal_OT", "ASC");
	}
	session.setAttribute("delnal_OB", OrderBy);
	session.setAttribute("delnal_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("delnal_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("delnal_OB", OrderBy);
		session.setAttribute("delnal_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `delnal`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("delnal_OT");
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
	session.setAttribute("delnal_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("delnal_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("delnal_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("delnal_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("delnal_REC") != null)
		startRec = ((Integer) session.getAttribute("delnal_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("delnal_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABLE: delnal</span></p>
<form action="delnallist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Quick Search (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="GO">
		&nbsp;&nbsp;<a href="delnallist.jsp?cmd=reset">Show all</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="delnallist.jsp?order=<%= java.net.URLEncoder.encode("datum","UTF-8") %>" style="color: #FFFFFF;">datum&nbsp;<% if (OrderBy != null && OrderBy.equals("datum")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("delnal_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("delnal_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="delnallist.jsp?order=<%= java.net.URLEncoder.encode("sif_str","UTF-8") %>" style="color: #FFFFFF;">sif str&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_str")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("delnal_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("delnal_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="delnallist.jsp?order=<%= java.net.URLEncoder.encode("stranka","UTF-8") %>" style="color: #FFFFFF;">stranka&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("stranka")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("delnal_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("delnal_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="delnallist.jsp?order=<%= java.net.URLEncoder.encode("sif_sof","UTF-8") %>" style="color: #FFFFFF;">sif sof&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_sof")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("delnal_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("delnal_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="delnallist.jsp?order=<%= java.net.URLEncoder.encode("sofer","UTF-8") %>" style="color: #FFFFFF;">sofer&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sofer")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("delnal_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("delnal_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="delnallist.jsp?order=<%= java.net.URLEncoder.encode("opom","UTF-8") %>" style="color: #FFFFFF;">opom&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("opom")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("delnal_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("delnal_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="delnallist.jsp?order=<%= java.net.URLEncoder.encode("opom3","UTF-8") %>" style="color: #FFFFFF;">opom 3&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("opom3")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("delnal_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("delnal_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	Object x_datum = null;
	String x_sif_str = "";
	String x_stranka = "";
	String x_sif_sof = "";
	String x_sofer = "";
	String x_opom = "";
	String x_opom2 = "";
	String x_opom3 = "";

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

	// sif_sof
	if (rs.getString("sif_sof") != null){
		x_sif_sof = rs.getString("sif_sof");
	}else{
		x_sif_sof = "";
	}

	// sofer
	if (rs.getString("sofer") != null){
		x_sofer = rs.getString("sofer");
	}else{
		x_sofer = "";
	}

	// opom
	if (rs.getString("opom") != null){
		x_opom = rs.getString("opom");
	}else{
		x_opom = "";
	}

	// opom2
	if (rs.getClob("opom2") != null) {
		long length = rs.getClob("opom2").length();
		x_opom2 = rs.getClob("opom2").getSubString((long) 1, (int) length);
	}else{
		x_opom2 = "";
	}

	// opom3
	if (rs.getString("opom3") != null){
		x_opom3 = rs.getString("opom3");
	}else{
		x_opom3 = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(EW_FormatDateTime(x_datum,5,locale)); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sif_str); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_stranka); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sif_sof); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_sofer); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_opom); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_opom3); %></span>&nbsp;</td>
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
	<td><a href="delnallist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="delnallist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="delnallist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="delnallist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
