<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*,java.net.*" isErrorPage="true"%>
<%@ page contentType="text/html; charset=utf-8" %>
<% Locale locale = Locale.getDefault();
NumberFormat nf_ge = NumberFormat.getInstance(Locale.GERMAN);
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
int displayRecs = 30;
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

String sif_kupca = request.getParameter("sif_kupca");
if (sif_kupca!=null && sif_kupca.equals("null")) sif_kupca=null;
%>
<%

String a = request.getParameter("Submit");
if (a != null && a.equals("Potrdi")) {
	Enumeration<String> parameterNames = request.getParameterNames();
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
    while (parameterNames.hasMoreElements()) {
        String paramName = parameterNames.nextElement();
        if (paramName.equals("start") || paramName.equals("psearch") || paramName.equals("sif_kupca") || paramName.equals("Submit")) continue;
        String[] pKeys = paramName.split(":");
	  	String[] paramValues = request.getParameterValues(paramName);
        for (int i = 0; i < paramValues.length; i++) {
            String paramValue = paramValues[i].replace(".", "").replace(",", ".");
            if (paramValue.equals("")||paramValue.equals("0")) paramValue=null;
            if (pKeys[2].equals("zdruzi")) {
	            if (paramValue!=null) {
					String sqlquery = "update komunale_kolicine" + 
							" set " + pKeys[2] + " = '" + paramValue + "'," +
							"		uporabnik = "+ Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")) +
							" WHERE sif_kupca = " + pKeys[0] + " AND koda = '" + pKeys[1] + "'";
					//out.println(sqlquery);
					stmt.executeUpdate(sqlquery);
	            }
            }
            else {
	            if (paramValue!=null && !paramValue.matches("-?\\d+(\\.\\d+)?")) {
	            	out.println("Neveljavna vrednost za: "+ paramValue+"<br>");
	            	continue;
	            }
				String sqlquery = "update komunale_kolicine" + 
						" set " + pKeys[2] + " = " + paramValue + "," +
						"		uporabnik = "+ Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")) +
						" WHERE sif_kupca = " + pKeys[0] + " AND koda = '" + pKeys[1] + "'";
				stmt.executeUpdate(sqlquery);
            }
        }
    }


  	stmt.close();
	stmt = null;
}
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
			b_search = b_search + "a.sif_kupca LIKE '%" + kw + "%' OR ";
			b_search = b_search + "b.naziv LIKE '%" + kw + "%' OR ";
			b_search = b_search + "c.material LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "a.sif_kupca LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "b.naziv LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "c.material LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("komunalekolicine_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("komunalekolicine_REC", new Integer(startRec));
}else{
	if (session.getAttribute("komunalekolicine_searchwhere") != null)
		searchwhere = (String) session.getAttribute("komunalekolicine_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("komunalekolicine_searchwhere", searchwhere);
		session.removeAttribute("komunalekolicine_OB");
		session.removeAttribute("komunalekolicine_searchwhere1");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("komunalekolicine_searchwhere", searchwhere);
		session.removeAttribute("komunalekolicine_searchwhere1");
	}else if (cmd.toUpperCase().equals("TOP")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("komunalekolicine_searchwhere1", "");
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("komunalekolicine_REC", new Integer(startRec));
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
	if (session.getAttribute("komunalekolicine_OB") != null &&
		((String) session.getAttribute("komunalekolicine_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) {
			session.setAttribute("komunalekolicine_OT", "DESC");
		}else{
			session.setAttribute("komunalekolicine_OT", "ASC");
		}
	}else{
		session.setAttribute("komunalekolicine_OT", "ASC");
	}
	session.setAttribute("komunalekolicine_OB", OrderBy);
	session.setAttribute("komunalekolicine_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("komunalekolicine_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("komunalekolicine_OB", OrderBy);
		session.setAttribute("komunalekolicine_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
String searchwhere1 = (String) session.getAttribute("komunalekolicine_searchwhere1");

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;
String subQuery ="";

// Build SQL
String strsql = "select a.*, b.naziv, c.material, uporabniki.uporabnisko_ime " +
				"from komunale_kolicine as a " +
				"left join kupci as b on a.sif_kupca = b.sif_kupca " +
				"left join okolje as c on a.koda = c.koda " +
				"left join uporabniki on a.uporabnik = sif_upor ";

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
if (sif_kupca!=null && !sif_kupca.equals("-1") && !sif_kupca.equals("")) {
	if(whereClause.length() > 0)
		strsql = strsql + " AND a.sif_kupca = " + sif_kupca;
	else {
		strsql = strsql + " WHERE a.sif_kupca = " + sif_kupca;
	}
}


if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY " + OrderBy + " " + (String) session.getAttribute("komunalekolicine_OT");
} else {
	strsql = strsql + " ORDER BY a.sif_kupca, a.koda";
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
	session.setAttribute("komunalekolicine_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("komunalekolicine_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("komunalekolicine_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("komunalekolicine_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("komunalekolicine_REC") != null)
		startRec = ((Integer) session.getAttribute("komunalekolicine_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("komunalekolicine_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Tabela: recikel embalaznina</span></p>
<form action="komunalekolicinelist.jsp" method="post">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="hidden" name="start" value="1">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="komunalekolicinelist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
	
	<tr>
		<td class="jspmaker">Komunala&nbsp;</td>
		<td class="jspmaker"><%
				String cbo_x_komunale_js = "";
				String x_komunaleList = "<select onchange = \"this.form.submit();\" name=\"sif_kupca\"><option value=\"\">Izberi</option>";
				String sqlwrk_x_komunale = "SELECT kupci.sif_kupca, naziv FROM komunale left join kupci on (komunale.sif_kupca = kupci.sif_kupca) ORDER BY naziv ASC";
				Statement stmtwrk_x_komunale = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_komunale = stmtwrk_x_komunale.executeQuery(sqlwrk_x_komunale);
					int rowcntwrk_x_komunale = 0;
					while (rswrk_x_komunale.next()) {
						x_komunaleList += "<option value=\"" + HTMLEncode(rswrk_x_komunale.getString("sif_kupca")) + "\"";
						if (rswrk_x_komunale.getString("sif_kupca").equals(sif_kupca)) {
							x_komunaleList += " selected";
						}
						String tmpValue_x_komunale = "";
						if (rswrk_x_komunale.getString("naziv")!= null) tmpValue_x_komunale = rswrk_x_komunale.getString("naziv");
						x_komunaleList += ">" + tmpValue_x_komunale
				 + "</option>";
						rowcntwrk_x_komunale++;		
					}
				rswrk_x_komunale.close();
				rswrk_x_komunale = null;
				stmtwrk_x_komunale.close();
				stmtwrk_x_komunale = null;
				x_komunaleList += "</select>";
				out.println(x_komunaleList);
%>
&nbsp;</td>
	</tr>	
		
</table>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td>
		<a href="komunalekolicineadd.jsp">Dodaj nov zapis</a>
		<input type="Submit" name="Submit" value="Potrdi">
	</td></tr>
<% } %>
</table>

<table class="ewTable">
	<tr class="ewTableHeader">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td>&nbsp;</td>
<% }  if (sif_kupca==null || sif_kupca.equals("-1") || sif_kupca.equals("")) {%>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>">Šifra komunale&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("naziv","UTF-8") %>">Naziv&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("naziv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "</b>" : ""%>
		</td>
<% } %>		
		<td>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("koda","utf-8") %>">Koda&nbsp;<% if (OrderBy != null && OrderBy.equals("koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("koda")) ? "</b>" : ""%>
		</td>
		<!-- td>
<%=(OrderBy != null && OrderBy.equals("material")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("material","utf-8") %>">Material&nbsp;<% if (OrderBy != null && OrderBy.equals("material")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("material")) ? "</b>" : ""%>
		</td-->
		<td>
<%=(OrderBy != null && OrderBy.equals("zdruzi")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("zdruzi","utf-8") %>">Združi&nbsp;<% if (OrderBy != null && OrderBy.equals("zdruzi")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("zdruzi")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("delez")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("delez","utf-8") %>">Delež&nbsp;<% if (OrderBy != null && OrderBy.equals("delez")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("delez")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jan")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_jan","utf-8") %>">Kol jan&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jan")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jan")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_feb")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_feb","utf-8") %>">Kol feb&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_feb")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_feb")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_mar")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_mar","utf-8") %>">Kol mar&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_mar")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_mar")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_apr")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_apr","utf-8") %>">Kol apr&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_apr")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_apr")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_maj")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_maj","utf-8") %>">Kol maj&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_maj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_maj")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jun")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_jun","utf-8") %>">Kol jun&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jun")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jun")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jul")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_jul","utf-8") %>">Kol jul&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jul")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jul")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_avg")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_avg","utf-8") %>">Kol avg&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_avg")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_avg")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_sep")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_sep","utf-8") %>">Kol sep&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_sep")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_sep")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_okt")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_okt","utf-8") %>">Kol okt&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_okt")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_okt")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_nov")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_nov","utf-8") %>">Kol nov&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_nov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_nov")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_dec")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_dec","utf-8") %>">Kol dec&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_dec")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_dec")) ? "</b>" : ""%>
		</td>
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("zacetek","utf-8") %>">Začetek&nbsp;<% if (OrderBy != null && OrderBy.equals("zacetek")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "</b>" : ""%>
		</td>
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("uporabnik","utf-8") %>">Uporabnik&nbsp;<% if (OrderBy != null && OrderBy.equals("uporabnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
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
			
	String x_zdruzi = "";
	float x_delez = 0;
	float x_kol_jan = 0;
	float x_kol_feb = 0;
	float x_kol_mar = 0;
	float x_kol_apr = 0;
	float x_kol_maj = 0;
	float x_kol_jun = 0;
	float x_kol_jul = 0;
	float x_kol_avg = 0;
	float x_kol_sep = 0;
	float x_kol_okt = 0;
	float x_kol_nov = 0;
	float x_kol_dec = 0;

	String x_sif_kupca = "";
	String x_naziv = "";
	String x_koda = "";
	String x_material = "";
	
	Object x_zacetek = null;
	String x_uporabnik = "";

	// Load Key for record
	String key = "";
	if(rs.getString("id") != null){
		key = rs.getString("id");
	}
	
	
	if (rs.getString("zdruzi") != null){
		x_zdruzi = rs.getString("zdruzi");
	}else{
		x_zdruzi = "";
	}	
	
	if (rs.getString("delez") != null){
		x_delez = rs.getFloat("delez");
	}else{
		x_delez = 0;
	}	
	
	if (rs.getString("kol_jan") != null){
		x_kol_jan = rs.getFloat("kol_jan");
	}else{
		x_kol_jan = 0;
	}	
	
	if (rs.getString("kol_feb") != null){
		x_kol_feb = rs.getFloat("kol_feb");
	}else{
		x_kol_feb = 0;
	}	
	
	if (rs.getString("kol_mar") != null){
		x_kol_mar = rs.getFloat("kol_mar");
	}else{
		x_kol_mar = 0;
	}	
	
	if (rs.getString("kol_apr") != null){
		x_kol_apr = rs.getFloat("kol_apr");
	}else{
		x_kol_apr = 0;
	}	
	
	if (rs.getString("kol_maj") != null){
		x_kol_maj = rs.getFloat("kol_maj");
	}else{
		x_kol_maj = 0;
	}		
	if (rs.getString("kol_jun") != null){
		x_kol_jun = rs.getFloat("kol_jun");
	}else{
		x_kol_jun = 0;
	}

	if (rs.getString("kol_jul") != null){
		x_kol_jul = rs.getFloat("kol_jul");
	}else{
		x_kol_jul = 0;
	}
	
	if (rs.getString("kol_avg") != null){
		x_kol_avg = rs.getFloat("kol_avg");
	}else{
		x_kol_avg = 0;
	}
	
	if (rs.getString("kol_sep") != null){
		x_kol_sep = rs.getFloat("kol_sep");
	}else{
		x_kol_sep = 0;
	}
	
	if (rs.getString("kol_okt") != null){
		x_kol_okt = rs.getFloat("kol_okt");
	}else{
		x_kol_okt = 0;
	}	

	
	if (rs.getString("kol_nov") != null){
		x_kol_nov = rs.getFloat("kol_nov");
	}else{
		x_kol_nov = 0;
	}	
	
	if (rs.getString("kol_dec") != null){
		x_kol_dec = rs.getFloat("kol_dec");
	}else{
		x_kol_dec = 0;
	}		

	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}	
	
	// sif_kupca
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}

	// kraj_naslov
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}

	// skupina
	if (rs.getString("material") != null){
		x_material = rs.getString("material");
	}else{
		x_material = "";
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
	out.print("komunalekolicineview.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("komunalekolicineedit.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Delete</span></td>
<% } if (sif_kupca==null || sif_kupca.equals("-1") || sif_kupca.equals("")) {
	%>
	
		<td><% out.print(x_sif_kupca); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td nowrap><% out.print(x_koda); %>&nbsp;</td>
		<!-- td><% out.print(x_material); %>&nbsp;</td-->

	
		<td nowrap><% out.print(x_zdruzi); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_delez)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_jan)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_feb)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_mar)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_apr)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_maj)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_jun)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_jul)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_avg)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_sep)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_okt)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_nov)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_kol_dec)); %>&nbsp;</td>
<% } else { %>
		<td nowrap><% out.print(x_koda); %>&nbsp;</td>
		<!-- td><% out.print(x_material); %>&nbsp;</td-->

	
		<td><%
				String cbo_x_okolje_koda_js = "";
				String x_okolje_kodaList = "<select name=\""+x_sif_kupca+":"+x_koda+":zdruzi\" style=\"width: 100px;\"><option value=\"\">Izberi</option>";
				String sqlwrk_x_okolje_koda = "SELECT koda, material FROM okolje WHERE koda like '15 01%' ORDER BY koda ASC";
				Statement stmtwrk_x_okolje_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_okolje_koda = stmtwrk_x_okolje_koda.executeQuery(sqlwrk_x_okolje_koda);
					int rowcntwrk_x_okolje_koda = 0;
					while (rswrk_x_okolje_koda.next()) {
						x_okolje_kodaList += "<option value=\"" + HTMLEncode(rswrk_x_okolje_koda.getString("koda")) + "\"";
						if (rswrk_x_okolje_koda.getString("koda").equals(x_zdruzi)) {
							x_okolje_kodaList += " selected";
						}
						String tmpValue_x_okolje_koda = "";
						if (rswrk_x_okolje_koda.getString("material")!= null) tmpValue_x_okolje_koda = rswrk_x_okolje_koda.getString("material");
						x_okolje_kodaList += ">" + rswrk_x_okolje_koda.getString("koda") + "</option>";
						rowcntwrk_x_okolje_koda++;
					}
				rswrk_x_okolje_koda.close();
				rswrk_x_okolje_koda = null;
				stmtwrk_x_okolje_koda.close();
				stmtwrk_x_okolje_koda = null;
				x_okolje_kodaList += "</select>";
				out.println(x_okolje_kodaList);
				%>
		</td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:delez" size="3" value="<% out.print(nf_ge.format(x_delez)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_jan" size="3" value="<% out.print(nf_ge.format(x_kol_jan)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_feb" size="3" value="<% out.print(nf_ge.format(x_kol_feb)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_mar" size="3" value="<% out.print(nf_ge.format(x_kol_mar)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_apr" size="3" value="<% out.print(nf_ge.format(x_kol_apr)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_maj" size="3" value="<% out.print(nf_ge.format(x_kol_maj)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_jun" size="3" value="<% out.print(nf_ge.format(x_kol_jun)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_jul" size="3" value="<% out.print(nf_ge.format(x_kol_jul)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_avg" size="3" value="<% out.print(nf_ge.format(x_kol_avg)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_sep" size="3" value="<% out.print(nf_ge.format(x_kol_sep)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_okt" size="3" value="<% out.print(nf_ge.format(x_kol_okt)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_nov" size="3" value="<% out.print(nf_ge.format(x_kol_nov)); %>"></td>
		<td><input type="text" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_dec" size="3" value="<% out.print(nf_ge.format(x_kol_dec)); %>"></td>
<% } %>
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
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='komunalekolicinedelete.jsp';this.form.submit();"></p>
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
	<td><a href="komunalekolicinelist.jsp?start=1&sif_kupca=<%=sif_kupca%>"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="komunalekolicinelist.jsp?start=<%=PrevStart%>&sif_kupca=<%=sif_kupca%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="komunalekolicinelist.jsp?start=<%=NextStart%>&sif_kupca=<%=sif_kupca%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="komunalekolicinelist.jsp?start=<%=LastStart%>&sif_kupca=<%=sif_kupca%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<a href="komunalekolicineadd.jsp"><img src="images/addnew.gif" alt="Dodaj" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
