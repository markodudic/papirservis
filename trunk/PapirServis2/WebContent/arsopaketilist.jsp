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
String a = request.getParameter("a"); //tip

String key1 = "";
if (a != null && a.length() != 0) {  //Potrdi paket
	key1 = request.getParameter("key");
	//out.println(key1);
	if (key1 != null && key1.length() > 0) {
		try {
			Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			int status = 2; //potrdi paket
			if (a.equals("D")) { // brisi paket
				status = 0;
			}
	    	String sqlquery = "update  " + session.getAttribute("letoTabela") +
						" set arso_status = " + status +
						" WHERE id IN " +
						" 		 (select CAST(ids AS CHAR(10000) CHARACTER SET utf8) from arso_paketi where sifra="+key1+")";
	    	stmt.executeUpdate(sqlquery);
	    	out.println(sqlquery);
	    	
			if (a.equals("D")) // brisi paket
		    	sqlquery = "delete from arso_paketi where sifra="+key1;
			else
		    	sqlquery = "update arso_paketi set potrjen=1 where sifra="+key1;
			//out.println(sqlquery);
	    	stmt.executeUpdate(sqlquery);
	    	stmt.close();
			stmt = null;
		}catch(SQLException ex){
			out.println(ex.toString());
		}
	}
}


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
			b_search = b_search + "`sifra` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`datum` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`ime_in_priimek` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`sifra` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`datum` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`ime_in_priimek` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("arso_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("arso_REC", new Integer(startRec));
}else{
	if (session.getAttribute("arso_searchwhere") != null)
		searchwhere = (String) session.getAttribute("arso_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("arso_searchwhere", searchwhere);
		session.removeAttribute("arso_OB");	
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("arso_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("arso_REC", new Integer(startRec));
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
	if (session.getAttribute("arso_OB") != null &&
		((String) session.getAttribute("arso_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("arso_OT")).equals("ASC")) {
			session.setAttribute("arso_OT", "DESC");
		}else{
			session.setAttribute("arso_OT", "ASC");
		}
	}else{
		session.setAttribute("arso_OT", "ASC");
	}
	session.setAttribute("arso_OB", OrderBy);
	session.setAttribute("arso_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("arso_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("arso_OB", OrderBy);
		session.setAttribute("arso_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM arso_paketi " +
				"left join uporabniki on (arso_paketi.sif_upor = uporabniki.sif_upor) " +
				"left join skup on (arso_paketi.sif_skup = skup.skupina) ";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("arso_OT");
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
	session.setAttribute("arso_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("arso_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("arso_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("arso_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("arso_REC") != null)
		startRec = ((Integer) session.getAttribute("arso_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("arso_REC", new Integer(startRec));
	}
}


Calendar dat = Calendar.getInstance(TimeZone.getDefault()); 
String y 	= String.valueOf(dat.get(Calendar.YEAR));
String m 	= String.valueOf(dat.get(Calendar.MONTH) + 1);
String d  = String.valueOf(dat.get(Calendar.DAY_OF_MONTH));
if(d.length() == 1) d = "0" + d;
if(m.length() == 1) m = "0" + m;

String s = d;
s = s + "." + m;
s = s + "." + y;

String od_datum = s;
String do_datum = s;


%>
<%@ include file="header.jsp" %>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript" src="papirservis.js"></script>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Pregled: arso paketi</span></p>
<form action="arsopaketilist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="arsopaketilist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
	<tr>
		<td class="jspmaker">Skupina&nbsp;</td>
		<td class="jspmaker"><%
String cbo_x_skupina_js = "";
String x_skupinaList = "<select name=\"skupina\"><option value=\"-1\">Izberi</option>";
String sqlwrk_x_skupina = "SELECT `skupina`, `tekst` FROM `skup` ORDER BY `tekst` ASC";
Statement stmtwrk_x_skupina = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_skupina = stmtwrk_x_skupina.executeQuery(sqlwrk_x_skupina);
	int rowcntwrk_x_skupina = 0;
	while (rswrk_x_skupina.next()) {
		x_skupinaList += "<option value=\"" + HTMLEncode(rswrk_x_skupina.getString("skupina")) + "\"";
		String tmpValue_x_skupina = "";
		if (rswrk_x_skupina.getString("tekst")!= null) tmpValue_x_skupina = rswrk_x_skupina.getString("tekst");
		x_skupinaList += ">" + tmpValue_x_skupina + "</option>";
		rowcntwrk_x_skupina++;
	}
rswrk_x_skupina.close();
rswrk_x_skupina = null;
stmtwrk_x_skupina.close();
stmtwrk_x_skupina = null;
x_skupinaList += "</select>";
out.println(x_skupinaList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td><span class="jspmaker">Kreiraj nov paket</span></td>
		<td><span class="jspmaker">
			<input type="text" name="od_datum" value="<%= EW_FormatDateTime(od_datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum od" onClick="popUpCalendar(this, this.form.od_datum,'dd.mm.yyyy');return false;">&nbsp;
			<input type="text" name="do_datum" value="<%= EW_FormatDateTime(do_datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum do" onClick="popUpCalendar(this, this.form.do_datum,'dd.mm.yyyy');return false;">&nbsp;
		&nbsp;&nbsp;<input type="button" name="btnnew" value="Potrdi" onClick="this.form.action='arsopaketinew.jsp?cmd=reset&od_datum=this.form.od_datum.value&do_datum=this.form.do_datum.value';this.form.submit();">
		</span></td>
	</tr>
</table>
</form>
<form id="arsopaketi" action="arsopaketilist.jsp" method="post">
<input type="hidden" name="a" id="a" value="C">
<input type="hidden" name="key" id="key" value="">
<table class="ewTable">
	<tr class="ewTableHeader">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td>&nbsp;</td>
<td>&nbsp;</td>
<% } %>
		<td>
<%=(OrderBy != null && OrderBy.equals("sifra")) ? "<b>" : ""%>
<a href="arsopaketilist.jsp?order=<%= java.net.URLEncoder.encode("sifra","UTF-8") %>">Sifra&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sifra")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sifra")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "<b>" : ""%>
<a href="arsopaketilist.jsp?order=<%= java.net.URLEncoder.encode("datum","UTF-8") %>">Datum&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("datum")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("od")) ? "<b>" : ""%>
<a href="arsopaketilist.jsp?order=<%= java.net.URLEncoder.encode("od","UTF-8") %>">Od&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("od")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("od")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("do")) ? "<b>" : ""%>
<a href="arsopaketilist.jsp?order=<%= java.net.URLEncoder.encode("do","UTF-8") %>">Do&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("do")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("do")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("skupina")) ? "<b>" : ""%>
<a href="arsopaketilist.jsp?order=<%= java.net.URLEncoder.encode("skupina","UTF-8") %>">Skupina&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("skupina")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("skupina")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("potrjen")) ? "<b>" : ""%>
<a href="arsopaketilist.jsp?order=<%= java.net.URLEncoder.encode("potrjen","UTF-8") %>">Potrjen&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("potrjen")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("potrjen")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "<b>" : ""%>
<a href="arsopaketilist.jsp?order=<%= java.net.URLEncoder.encode("uporabnik","UTF-8") %>">Uporabnik&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("uporabnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("arso_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("arso_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "</b>" : ""%>
		</td>
		<td>Naziv paketa&nbsp;</td>
		<td>XML&nbsp;</td>
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
	String x_sifra = "";
	Object x_datum = "";
	Object x_od = "";
	Object x_do = "";
	String x_skupina = "";
	String x_potrjen = "";
	String x_uporabnik = "";
	String x_naziv = "";
	String x_xml = "";

	// Load Key for record
	String key = "";
	if(rs.getString("sifra") != null){
		key = rs.getString("sifra");
	}

	// sifra
	if (rs.getString("sifra") != null){
		x_sifra = rs.getString("sifra");
	}else{
		x_sifra = "";
	}

	// datum
	if (rs.getTimestamp("datum") != null){
		x_datum = rs.getTimestamp("datum");
	}else{
		x_datum = "";
	}

	// od
	if (rs.getTimestamp("od") != null){
		x_od = rs.getTimestamp("od");
	}else{
		x_od = "";
	}

	
	// do
	if (rs.getTimestamp("do") != null){
		x_do = rs.getTimestamp("do");
	}else{
		x_do = "";
	}

	// skupina
	if (rs.getString("tekst") != null){
		x_skupina = rs.getString("tekst");
	}else{
		x_skupina = "";
	}

	// potrjen
	if (rs.getString("potrjen") != null){
		x_potrjen = rs.getString("potrjen");
	}else{
		x_potrjen = "";
	}
	
	// uporabnik
	if (rs.getString("ime_in_priimek") != null){
		x_uporabnik = rs.getString("ime_in_priimek");
	}else{
		x_uporabnik = "";
	}

	// naziv
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}
	
	// xml
	if (rs.getString("xml") != null){
		x_xml = rs.getString("xml");
	}else{
		x_xml = "";
	}

%>
	<tr class="<%= rowclass %>">
<td><% if (x_potrjen.equals("0")) { %>
<input type="submit" name="btnconfirm" value="Potrdi" onClick='if(!confirm("Res želite potrditi paket <%= HTMLEncode((String)key) %>?")) return false; document.getElementById("a").value="C"; document.getElementById("key").value=<%= HTMLEncode((String)key) %>;'>
<% } %>
</td>
<td><% if (x_potrjen.equals("0")) { %>
<input type="submit" name="btndelete" value="Briši" onClick='if(!confirm("Res želite zbrisati paket <%= HTMLEncode((String)key) %>?")) return false; document.getElementById("a").value="D"; document.getElementById("key").value=<%= HTMLEncode((String)key) %>; if (zbrisiPaket(<%= HTMLEncode((String)key) %>)) return false;'>
<% } %>
</td>
		<td><% out.print(x_sifra); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_datum,8,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_od,7,locale)); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_do,7,locale)); %>&nbsp;</td>
		<td><% out.print(x_skupina); %>&nbsp;</td>
		<td><% out.print(x_potrjen.equals("0") ? "NE" : "DA" ); %>&nbsp;</td>
		<td><% out.print(x_uporabnik); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td><% out.print(x_xml); %>&nbsp;</td>
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
	<td><a href="arsopaketilist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="arsopaketilist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="arsopaketilist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="arsopaketilist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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