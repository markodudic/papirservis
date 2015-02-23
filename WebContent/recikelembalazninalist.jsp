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

String id_zavezanca = request.getParameter("id_zavezanca");
if (id_zavezanca!=null && id_zavezanca.equals("null")) id_zavezanca=null;
%>
<%

String a = request.getParameter("Submit");
if (a != null && a.equals("Potrdi")) {
	Enumeration<String> parameterNames = request.getParameterNames();
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
    while (parameterNames.hasMoreElements()) {
        String paramName = parameterNames.nextElement();
        if (paramName.equals("start") || paramName.equals("psearch") || paramName.equals("id_zavezanca") || paramName.equals("Submit")) continue;
        String[] pKeys = paramName.split(":");
	  	String[] paramValues = request.getParameterValues(paramName);
        for (int i = 0; i < paramValues.length; i++) {
            String paramValue = paramValues[i].replace(".", "").replace(",", ".");
            if (paramValue.equals("")||paramValue.equals("0")) paramValue=null;
            if (paramValue!=null && !paramValue.matches("-?\\d+(\\.\\d+)?")) {
            	out.println("Neveljavna vrednost za: "+ paramValue+"<br>");
            	continue;
            }
			String sqlquery = "update recikel_embalaznina" + session.getAttribute("leto") +
					" set " + pKeys[2] + " = " + paramValue +
					" WHERE id_zavezanca = " + pKeys[0] + " AND id_embalaza = " + pKeys[1];
			stmt.executeUpdate(sqlquery);
        }
    }

	/*tole je za get http
	String queryString=URLDecoder.decode(request.getQueryString());
	//out.println();
	String[] pArray= queryString.split("&");
	String value="";                  
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	for (int i=3 ;i<pArray.length;i++) {
	  	//out.println(pArray[i]);
	  	String[] pKeys = pArray[i].split(":");
	  	String[] pValues = pKeys[2].split("=");
	  	//out.println("*"+pKeys[0]+":"+pKeys[1]+":"+pValues[0]+":"+pValues.length);
	  	String pValue = null;
	  	if (pValues.length > 1) {
	  		pValue = pValues[1];
	  		
			String sqlquery = "update recikel_embalaznina" + session.getAttribute("leto") +
							" set " + pValues[0] + " = " + pValues[1] +
							" WHERE id_zavezanca = " + pKeys[0] + " AND id_embalaza = " + pKeys[1];
			out.println("//"+sqlquery);
		  	stmt.executeUpdate(sqlquery);
	  	} else {
	  		String sqlquery = "update recikel_embalaznina" + session.getAttribute("leto") +
					" set " + pValues[0] + " = null " +
					" WHERE id_zavezanca = " + pKeys[0] + " AND id_embalaza = " + pKeys[1];
			//out.println("\\"+sqlquery);
  			stmt.executeUpdate(sqlquery);
	  	}
	}*/
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
			b_search = b_search + "st_pogodbe LIKE '%" + kw + "%' OR ";
			b_search = b_search + "c.naziv LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "st_pogodbe LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "c.naziv LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("recikelembalaznina_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("recikelembalaznina_REC", new Integer(startRec));
}else{
	if (session.getAttribute("recikelembalaznina_searchwhere") != null)
		searchwhere = (String) session.getAttribute("recikelembalaznina_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("recikelembalaznina_searchwhere", searchwhere);
		session.removeAttribute("recikelembalaznina_OB");
		session.removeAttribute("recikelembalaznina_searchwhere1");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("recikelembalaznina_searchwhere", searchwhere);
		session.removeAttribute("recikelembalaznina_searchwhere1");
	}else if (cmd.toUpperCase().equals("TOP")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("recikelembalaznina_searchwhere1", "");
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("recikelembalaznina_REC", new Integer(startRec));
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
	if (session.getAttribute("recikelembalaznina_OB") != null &&
		((String) session.getAttribute("recikelembalaznina_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) {
			session.setAttribute("recikelembalaznina_OT", "DESC");
		}else{
			session.setAttribute("recikelembalaznina_OT", "ASC");
		}
	}else{
		session.setAttribute("recikelembalaznina_OT", "ASC");
	}
	session.setAttribute("recikelembalaznina_OB", OrderBy);
	session.setAttribute("recikelembalaznina_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("recikelembalaznina_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("recikelembalaznina_OB", OrderBy);
		session.setAttribute("recikelembalaznina_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
String searchwhere1 = (String) session.getAttribute("recikelembalaznina_searchwhere1");

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;
String subQuery ="";

// Build SQL
String strsql = "select a.*, b.*, c.id id_embalaza, c.tar_st, c.naziv naziv2, c.porocilo, uporabniki.uporabnisko_ime " +
				"from recikel_embalaznina" + session.getAttribute("leto") + " as a " +
				"left join recikel_zavezanci" + session.getAttribute("leto") + " as b on id_zavezanca = b.id " +
				"left join recikel_embalaze" + session.getAttribute("leto") + " as c on id_embalaza = c.id " +
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
if (id_zavezanca!=null && !id_zavezanca.equals("-1") && !id_zavezanca.equals("")) {
	if(whereClause.length() > 0)
		strsql = strsql + " AND id_zavezanca = " + id_zavezanca;
	else {
		strsql = strsql + " WHERE id_zavezanca = " + id_zavezanca;
	}
}


if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY " + OrderBy + " " + (String) session.getAttribute("recikelembalaznina_OT");
} else {
	strsql = strsql + " ORDER BY st_pogodbe, tar_st, porocilo";
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
	session.setAttribute("recikelembalaznina_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("recikelembalaznina_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("recikelembalaznina_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("recikelembalaznina_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("recikelembalaznina_REC") != null)
		startRec = ((Integer) session.getAttribute("recikelembalaznina_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("recikelembalaznina_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>

<p><span class="jspmaker">Tabela: recikel embalaznina</span></p>
<form action="recikelembalazninalist.jsp" method="post">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="hidden" name="start" value="1">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="recikelembalazninalist.jsp?cmd=reset">Prikaži vse</a>
		</span></td>
	</tr>
	
	<tr>
		<td class="jspmaker">Zavezanec&nbsp;</td>
		<td class="jspmaker"><%
String cbo_x_posta_js = "";
String x_postaList = "<select name=\"id_zavezanca\" onchange = \"this.form.submit();\"><option value=\"\">Izberi</option>";
String sqlwrk_x_posta = "SELECT id, st_pogodbe, naziv FROM recikel_zavezanci" + session.getAttribute("leto") + " ORDER BY naziv ASC";
Statement stmtwrk_x_posta = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_posta = stmtwrk_x_posta.executeQuery(sqlwrk_x_posta);
	int rowcntwrk_x_posta = 0;
	while (rswrk_x_posta.next()) {
		x_postaList += "<option value=\"" + HTMLEncode(rswrk_x_posta.getString("id")) + "\"";
		if (rswrk_x_posta.getString("id").equals(id_zavezanca)) {
			x_postaList += " selected";
		}
		String tmpValue_x_posta = "";
		if (rswrk_x_posta.getString("naziv")!= null) tmpValue_x_posta = rswrk_x_posta.getString("naziv");
		x_postaList += ">" + tmpValue_x_posta
 + "</option>";
		rowcntwrk_x_posta++;
	}
rswrk_x_posta.close();
rswrk_x_posta = null;
stmtwrk_x_posta.close();
stmtwrk_x_posta = null;
x_postaList += "</select>";
out.println(x_postaList);
%>
&nbsp;</td>
	</tr>	
		
</table>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr><td>
		<a href="recikelembalazninaadd.jsp">Dodaj nov zapis</a>
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
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td>&nbsp;</td>
<% }  if (id_zavezanca==null || id_zavezanca.equals("-1") || id_zavezanca.equals("")) {%>
		<td>
<%=(OrderBy != null && OrderBy.equals("st_pogodbe")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("st_pogodbe","utf-8") %>">Št. pogodbe&nbsp;<% if (OrderBy != null && OrderBy.equals("st_pogodbe")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("st_pogodbe")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("naziv","utf-8") %>">Naziv&nbsp;<% if (OrderBy != null && OrderBy.equals("naziv")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naziv")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("naslov")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("naslov","utf-8") %>">Naslov&nbsp;<% if (OrderBy != null && OrderBy.equals("naslov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naslov")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kraj")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kraj","utf-8") %>">Kraj&nbsp;<% if (OrderBy != null && OrderBy.equals("kraj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kraj")) ? "</b>" : ""%>
		</td>
		
		<td>
<%=(OrderBy != null && OrderBy.equals("posta")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("posta","utf-8") %>">Pošta&nbsp;<% if (OrderBy != null && OrderBy.equals("posta")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("posta")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("skrbnik")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("skrbnik","utf-8") %>">Skrbnik&nbsp;<% if (OrderBy != null && OrderBy.equals("skrbnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("skrbnik")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("interval_pavsala")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("interval_pavsala","utf-8") %>">Interval pavšala&nbsp;<% if (OrderBy != null && OrderBy.equals("interval_pavsala")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("interval_pavsala")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("kontaktna_oseba")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kontaktna_oseba","utf-8") %>">Kontaktna oseba&nbsp;<% if (OrderBy != null && OrderBy.equals("kontaktna_oseba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kontaktna_oseba")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("telefon_kontaktna")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("telefon_kontaktna","utf-8") %>">Telefon kontaktna&nbsp;<% if (OrderBy != null && OrderBy.equals("telefon_kontaktna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("telefon_kontaktna")) ? "</b>" : ""%>
		</td>		
	    <td>
<%=(OrderBy != null && OrderBy.equals("mail_kontaktna")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("mail_kontaktna","utf-8") %>">Mail kontaktna&nbsp;<% if (OrderBy != null && OrderBy.equals("mail_kontaktna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("mail_kontaktna")) ? "</b>" : ""%>
		</td>
	    <td nowrap>
<%=(OrderBy != null && OrderBy.equals("opombe_kontaktna")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("opombe_kontaktna","utf-8") %>">Opombe kontaktna&nbsp;<% if (OrderBy != null && OrderBy.equals("opombe_kontaktna")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opombe_kontaktna")) ? "</b>" : ""%>
		</td>
<% } %>
	    <td>
<%=(OrderBy != null && OrderBy.equals("tar_st")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("tar_st","utf-8") %>">Tar št.&nbsp;<% if (OrderBy != null && OrderBy.equals("tar_st")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("tar_st")) ? "</b>" : ""%>
		</td>
	    <td>
<%=(OrderBy != null && OrderBy.equals("naziv2")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("naziv2","utf-8") %>">Naziv embalaže&nbsp;<% if (OrderBy != null && OrderBy.equals("naziv2")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("naziv2")) ? "</b>" : ""%>
		</td>
	    <td nowrap>
<%=(OrderBy != null && OrderBy.equals("porocilo")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("porocilo","utf-8") %>">Poročilo&nbsp;<% if (OrderBy != null && OrderBy.equals("porocilo")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("porocilo")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("letna_napoved")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("letna_napoved","utf-8") %>">Letna napoved&nbsp;<% if (OrderBy != null && OrderBy.equals("letna_napoved")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("letna_napoved")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("cena")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("cena","utf-8") %>">Cena&nbsp;<% if (OrderBy != null && OrderBy.equals("cena")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("cena")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jan")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_jan","utf-8") %>">Kol jan&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jan")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jan")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_feb")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_feb","utf-8") %>">Kol feb&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_feb")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_feb")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_mar")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_mar","utf-8") %>">Kol mar&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_mar")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_mar")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_apr")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_apr","utf-8") %>">Kol apr&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_apr")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_apr")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_maj")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_maj","utf-8") %>">Kol maj&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_maj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_maj")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jun")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_jun","utf-8") %>">Kol jun&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jun")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jun")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jul")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_jul","utf-8") %>">Kol jul&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jul")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jul")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_avg")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_avg","utf-8") %>">Kol avg&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_avg")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_avg")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_sep")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_sep","utf-8") %>">Kol sep&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_sep")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_sep")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_okt")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_okt","utf-8") %>">Kol okt&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_okt")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_okt")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_nov")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_nov","utf-8") %>">Kol nov&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_nov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_nov")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_dec")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("kol_dec","utf-8") %>">Kol dec&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_dec")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_dec")) ? "</b>" : ""%>
		</td>
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("zacetek","utf-8") %>">Začetek&nbsp;<% if (OrderBy != null && OrderBy.equals("zacetek")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "</b>" : ""%>
		</td>
		<td nowrap>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "<b>" : ""%>
<a href="recikelembalazninalist.jsp?order=<%= java.net.URLEncoder.encode("uporabnik","utf-8") %>">Uporabnik&nbsp;<% if (OrderBy != null && OrderBy.equals("uporabnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("recikelembalaznina_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("recikelembalaznina_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
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
			
	float x_letna_napoved = 0;
	float x_cena = 0;
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

	String x_st_pogodbe = "";
	String x_naziv = "";
	String x_naslov = "";
	String x_kraj = "";
	String x_posta = "";
	String x_skrbnik = "";
	String x_interval_pavsala = "";
	String x_kontaktna_oseba = "";
	String x_telefon_kontaktna = "";
	String x_mail_kontaktna = "";
	String x_opombe_kontaktna = "";
	
	String x_tar_st = "";
	String x_id_embalaza = "";
	String x_naziv2 = "";
	String x_porocilo = "";
	
	Object x_zacetek = null;
	String x_uporabnik = "";

	// Load Key for record
	String key = "";
	if(rs.getString("id") != null){
		key = rs.getString("id");
	}
	
	
	if (rs.getString("letna_napoved") != null){
		x_letna_napoved = rs.getFloat("letna_napoved");
	}else{
		x_letna_napoved = 0;
	}	
	
	if (rs.getString("cena") != null){
		x_cena = rs.getFloat("cena");
	}else{
		x_cena = 0;
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

	if (rs.getString("st_pogodbe") != null){
		x_st_pogodbe = rs.getString("st_pogodbe");
	}else{
		x_st_pogodbe = "";
	}	
	
	// sif_kupca
	if (rs.getString("naziv") != null){
		x_naziv = rs.getString("naziv");
	}else{
		x_naziv = "";
	}

	// kraj_naslov
	if (rs.getString("kraj") != null){
		x_kraj = rs.getString("kraj");
	}else{
		x_kraj = "";
	}

	// skupina
	if (rs.getString("naslov") != null){
		x_naslov = rs.getString("naslov");
	}else{
		x_naslov = "";
	}
	
	if (rs.getString("posta") != null){
		x_posta = rs.getString("posta");
	}else{
		x_posta = "";
	}

	if (rs.getString("skrbnik") != null){
		x_skrbnik = rs.getString("skrbnik");
	}else{
		x_skrbnik = "";
	}
	
	if (rs.getString("interval_pavsala") != null){
		x_interval_pavsala = rs.getString("interval_pavsala");
	}else{
		x_interval_pavsala = "";
	}	
	
	if (rs.getString("kontaktna_oseba") != null){
		x_kontaktna_oseba = rs.getString("kontaktna_oseba");
	}else{
		x_kontaktna_oseba = "";
	}	
	
	if (rs.getString("telefon_kontaktna") != null){
		x_telefon_kontaktna = rs.getString("telefon_kontaktna");
	}else{
		x_telefon_kontaktna = "";
	}	
	
	if (rs.getString("mail_kontaktna") != null){
		x_mail_kontaktna = rs.getString("mail_kontaktna");
	}else{
		x_mail_kontaktna = "";
	}	
	
	if (rs.getString("opombe_kontaktna") != null){
		x_opombe_kontaktna = rs.getString("opombe_kontaktna");
	}else{
		x_opombe_kontaktna = "";
	}	
	
	if (rs.getString("tar_st") != null){
		x_tar_st = rs.getString("tar_st");
	}else{
		x_tar_st = "";
	}	
	
	if (rs.getString("id_embalaza") != null){
		x_id_embalaza = rs.getString("id_embalaza");
	}else{
		x_id_embalaza = "";
	}	
	
	if (rs.getString("naziv2") != null){
		x_naziv2 = rs.getString("naziv2");
	}else{
		x_naziv2 = "";
	}	
	
	if (rs.getString("porocilo") != null){
		x_porocilo = rs.getString("porocilo");
	}else{
		x_porocilo = "";
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
	out.print("recikelembalazninaview.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Pregled</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("recikelembalazninaedit.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Spremeni</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("recikelembalazninaadd.jsp?key=" + java.net.URLEncoder.encode(key,"utf-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>">Kopiraj</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker">Delete</span></td>
<% } if (id_zavezanca==null || id_zavezanca.equals("-1") || id_zavezanca.equals("")) {
	%>
	
		<td><% out.print(x_st_pogodbe); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td><% out.print(x_naslov); %>&nbsp;</td>
		<td><% out.print(x_kraj); %>&nbsp;</td>

		<td><% out.print(x_posta); %>&nbsp;</td>
		<td><% out.print(x_skrbnik); %>&nbsp;</td>
		<td><% out.print(x_interval_pavsala); %>&nbsp;</td>
		<td><% out.print(x_kontaktna_oseba); %>&nbsp;</td>
		<td><% out.print(x_telefon_kontaktna); %>&nbsp;</td>
		<td><% out.print(x_mail_kontaktna); %>&nbsp;</td>
		<td><% out.print(x_opombe_kontaktna); %>&nbsp;</td>

		<td><% out.print(x_tar_st); %>&nbsp;</td>
		<td><% out.print(x_naziv2); %>&nbsp;</td>
		<td><% out.print(x_porocilo); %>&nbsp;</td>
	
		<td><% out.print(nf_ge.format(x_letna_napoved)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_cena)); %>&nbsp;</td>
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
		<td><% out.print(x_tar_st); %>&nbsp;</td>
		<td><% out.print(x_naziv2); %>&nbsp;</td>
		<td><% out.print(x_porocilo); %>&nbsp;</td>
	
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:letna_napoved" size="3" value="<% out.print(nf_ge.format(x_letna_napoved)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:cena" size="3" value="<% out.print(nf_ge.format(x_cena)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_jan" size="3" value="<% out.print(nf_ge.format(x_kol_jan)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_feb" size="3" value="<% out.print(nf_ge.format(x_kol_feb)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_mar" size="3" value="<% out.print(nf_ge.format(x_kol_mar)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_apr" size="3" value="<% out.print(nf_ge.format(x_kol_apr)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_maj" size="3" value="<% out.print(nf_ge.format(x_kol_maj)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_jun" size="3" value="<% out.print(nf_ge.format(x_kol_jun)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_jul" size="3" value="<% out.print(nf_ge.format(x_kol_jul)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_avg" size="3" value="<% out.print(nf_ge.format(x_kol_avg)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_sep" size="3" value="<% out.print(nf_ge.format(x_kol_sep)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_okt" size="3" value="<% out.print(nf_ge.format(x_kol_okt)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_nov" size="3" value="<% out.print(nf_ge.format(x_kol_nov)); %>"></td>
		<td><input type="text" name="<% out.print(id_zavezanca); %>:<% out.print(x_id_embalaza); %>:kol_dec" size="3" value="<% out.print(nf_ge.format(x_kol_dec)); %>"></td>
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
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='recikelembalazninadelete.jsp';this.form.submit();"></p>
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
	<td><a href="recikelembalazninalist.jsp?start=1&id_zavezanca=<%=id_zavezanca%>"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="recikelembalazninalist.jsp?start=<%=PrevStart%>&id_zavezanca=<%=id_zavezanca%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="recikelembalazninalist.jsp?start=<%=NextStart%>&id_zavezanca=<%=id_zavezanca%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="recikelembalazninalist.jsp?start=<%=LastStart%>&id_zavezanca=<%=id_zavezanca%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<a href="recikelembalazninaadd.jsp"><img src="images/addnew.gif" alt="Dodaj" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
