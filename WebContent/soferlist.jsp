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
			b_search = b_search + "`sif_sof` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`sofer` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`sif_sof` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`sofer` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("sofer_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("sofer_REC", new Integer(startRec));	
}else{
	if (session.getAttribute("sofer_searchwhere") != null)
		searchwhere = (String) session.getAttribute("sofer_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("sofer_searchwhere", searchwhere);
		session.removeAttribute("sofer_OB");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("sofer_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("TOP")) {
		searchwhere = " zacetek = k.z and sif_kam = k.sk"; // Reset search criteria
		session.setAttribute("kamion_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("sofer_REC", new Integer(startRec));
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
	if (session.getAttribute("sofer_OB") != null &&
		((String) session.getAttribute("sofer_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("sofer_OT")).equals("ASC")) {
			session.setAttribute("sofer_OT", "DESC");
		}else{
			session.setAttribute("sofer_OT", "ASC");
		}
	}else{
		session.setAttribute("sofer_OT", "ASC");
	}
	session.setAttribute("sofer_OB", OrderBy);
	session.setAttribute("sofer_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("sofer_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("sofer_OB", OrderBy);
		session.setAttribute("sofer_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `sofer`";
whereClause = "";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("sofer_OT");
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
	session.setAttribute("sofer_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("sofer_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("sofer_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("sofer_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("sofer_REC") != null)
		startRec = ((Integer) session.getAttribute("sofer_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("sofer_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Pregled: sofer</span></p>
<form action="soferlist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="soferlist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
	<!-- tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr-->
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="soferadd.jsp">Dodaj nov zapis</a></td></tr>
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
<%=(OrderBy != null && OrderBy.equals("sif_sof")) ? "<b>" : ""%>
<a href="soferlist.jsp?order=<%= java.net.URLEncoder.encode("sif_sof","UTF-8") %>">Šifra šoferja&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_sof")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("sofer_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("sofer_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_sof")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sofer")) ? "<b>" : ""%>
<a href="soferlist.jsp?order=<%= java.net.URLEncoder.encode("sofer","UTF-8") %>">Šofer&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sofer")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("sofer_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("sofer_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sofer")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kljuc")) ? "<b>" : ""%>
<a href="soferlist.jsp?order=<%= java.net.URLEncoder.encode("kljuc","UTF-8") %>">Ključ&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("kljuc")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("sofer_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("sofer_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kljuc")) ? "</b>" : ""%>
		</td>
		<!--td>
<%=(OrderBy != null && OrderBy.equals("ure")) ? "<b>" : ""%>
<a href="soferlist.jsp?order=<%= java.net.URLEncoder.encode("ure","UTF-8") %>">Ure&nbsp;<% if (OrderBy != null && OrderBy.equals("ure")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("sofer_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("sofer_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("ure")) ? "</b>" : ""%>
		</td-->
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
	String x_sif_sof = "";
	String x_sofer = "";
	String x_kljuc = "";
	String x_ure = "";

	// Load Key for record
	String key = "";
	if(rs.getString("sif_sof") != null){
		key = rs.getString("sif_sof");
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

	// sofer
	if (rs.getString("kljuc") != null){
		x_kljuc = rs.getString("kljuc");
	}else{
		x_kljuc = "";
	}

	// ure
	x_ure = String.valueOf(rs.getLong("ure"));
%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_sof"); 
if (key != null && key.length() > 0) { 
	out.print("soferview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_sof"); 
if (key != null && key.length() > 0) { 
	out.print("soferedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("sif_sof"); 
if (key != null && key.length() > 0) { 
	out.print("soferadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Briši</span></td>
<% } %>
		<td nowrap><% out.print(x_sif_sof); %>&nbsp;</td>
		<td><% out.print(x_sofer); %>&nbsp;</td>
		<td><% out.print(x_kljuc); %>&nbsp;</td>
		<!--td><% out.print(x_ure); %>&nbsp;</td-->
	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='soferdelete.jsp';this.form.submit();"></p>
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
	<td><a href="soferlist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="soferlist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="soferlist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="soferlist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<a href="soferadd.jsp">Dodaj nov zapis</a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>