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
			b_search = b_search + "`tekst` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`pr1` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`ravnanje` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`prevoz_kamion` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`prevoz_material` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`tekst` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`pr1` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`ravnanje` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`prevoz_kamion` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`prevoz_material` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("skup_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("skup_REC", new Integer(startRec));
}else{
	if (session.getAttribute("skup_searchwhere") != null)
		searchwhere = (String) session.getAttribute("skup_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("skup_searchwhere", searchwhere);
		session.removeAttribute("skup_OB");	
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("skup_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("skup_REC", new Integer(startRec));
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
	if (session.getAttribute("skup_OB") != null &&
		((String) session.getAttribute("skup_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("skup_OT")).equals("ASC")) {
			session.setAttribute("skup_OT", "DESC");
		}else{
			session.setAttribute("skup_OT", "ASC");
		}
	}else{
		session.setAttribute("skup_OT", "ASC");
	}
	session.setAttribute("skup_OB", OrderBy);
	session.setAttribute("skup_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("skup_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("skup_OB", OrderBy);
		session.setAttribute("skup_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `skup`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("skup_OT");
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
	session.setAttribute("skup_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("skup_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("skup_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("skup_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("skup_REC") != null)
		startRec = ((Integer) session.getAttribute("skup_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("skup_REC", new Integer(startRec));
	}
} 
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Pregled: skup</span></p>
<form action="skuplist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="skuplist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
	<!-- tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Exact phrase&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">All words&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Any word</span></td></tr-->
</table>
</form>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td><a href="skupadd.jsp">Dodaj nov zapis</a></td></tr>
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
<%=(OrderBy != null && OrderBy.equals("skupina")) ? "<b>" : ""%>
<a href="skuplist.jsp?order=<%= java.net.URLEncoder.encode("skupina","UTF-8") %>">Skupina&nbsp;<% if (OrderBy != null && OrderBy.equals("skupina")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("skup_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("skup_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("skupina")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("tekst")) ? "<b>" : ""%>
<a href="skuplist.jsp?order=<%= java.net.URLEncoder.encode("tekst","UTF-8") %>">Tekst&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("tekst")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("skup_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("skup_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("tekst")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("pr1")) ? "<b>" : ""%>
<a href="skuplist.jsp?order=<%= java.net.URLEncoder.encode("pr1","UTF-8") %>">pr 1&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("pr1")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("skup_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("skup_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("pr1")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("ravnanje")) ? "<b>" : ""%>
<a href="skuplist.jsp?order=<%= java.net.URLEncoder.encode("ravnanje","UTF-8") %>">Ravnanje&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("ravnanje")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("skup_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("skup_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("ravnanje")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("prevoz_kamion")) ? "<b>" : ""%>
<a href="skuplist.jsp?order=<%= java.net.URLEncoder.encode("prevoz_kamion","UTF-8") %>">Prevoz kamion&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("prevoz_kamion")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("skup_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("skup_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("prevoz_kamion")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("prevoz_material")) ? "<b>" : ""%>
<a href="skuplist.jsp?order=<%= java.net.URLEncoder.encode("prevoz_material","UTF-8") %>">Prevoz material&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("prevoz_material")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("skup_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("skup_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("prevoz_material")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_odp_embalaza_shema")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("arso_odp_embalaza_shema","UTF-8") %>">Arso emb. shema&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_odp_embalaza_shema")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_odp_embalaza_shema")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("arso_dej_nastanka")) ? "<b>" : ""%>
<a href="materialilist.jsp?order=<%= java.net.URLEncoder.encode("arso_dej_nastanka","UTF-8") %>">Arso dej. nastanka&nbsp;<% if (OrderBy != null && OrderBy.equals("arso_dej_nastanka")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("kupci_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("kupci_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("arso_dej_nastanka")) ? "</b>" : ""%>
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
	String x_skupina = "";
	String x_tekst = "";
	String x_pr1 = "";
	String x_ravnanje = "";
	String x_prevoz_kamion = "";
	String x_prevoz_material = "";
	String x_arso_odp_embalaza_shema = "";
	String x_arso_odp_dej_nastanka = "";

	// Load Key for record
	String key = "";
	key = String.valueOf(rs.getLong("skupina"));

	// skupina
	x_skupina = String.valueOf(rs.getLong("skupina"));

	// tekst
	if (rs.getString("tekst") != null){
		x_tekst = rs.getString("tekst");
	}else{
		x_tekst = "";
	}

	// pr1
	if (rs.getString("pr1") != null){
		x_pr1 = rs.getString("pr1");
	}else{
		x_pr1 = "";
	}

	// ravnanje
	if (rs.getString("ravnanje") != null){
		x_ravnanje = rs.getString("ravnanje");
	}else{
		x_ravnanje = "";
	}

	// prevoz_kamion
	if (rs.getBoolean("prevoz_kamion")){
		x_prevoz_kamion = "X";
	}else{
		x_prevoz_kamion = "";
	}

	// prevoz_material
	if (rs.getBoolean("prevoz_material")){
		x_prevoz_material = "X";
	}else{
		x_prevoz_material = "";
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
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("skupina"); 
if (key != null && key.length() > 0) { 
	out.print("skupview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("skupina"); 
if (key != null && key.length() > 0) { 
	out.print("skupedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("skupina"); 
if (key != null && key.length() > 0) { 
	out.print("skupadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Briši</span></td>
<% } %>
		<td nowrap><% out.print(x_skupina); %>&nbsp;</td>
		<td><% out.print(x_tekst); %>&nbsp;</td>
		<td><% out.print(x_pr1); %>&nbsp;</td>
		<td><% out.print(x_ravnanje);%>&nbsp;</td>
		<td><% out.print(x_prevoz_kamion);%>&nbsp;</td>
		<td><% out.print(x_prevoz_material);%>&nbsp;</td>
		<td><% out.print(x_arso_odp_embalaza_shema); %>&nbsp;</td>
		<td><% out.print(x_arso_odp_dej_nastanka); %>&nbsp;</td>
	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='skupdelete.jsp';this.form.submit();"></p>
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
	<td><a href="skuplist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="skuplist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="skuplist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="skuplist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<a href="skupadd.jsp">Dodaj nov zapis</a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>