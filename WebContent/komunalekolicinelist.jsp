<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*,java.net.*" isErrorPage="true"%>
<%@ page contentType="text/html; charset=utf-8" %>

<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript" src="papirservis.js"></script>

<% Locale locale = Locale.getDefault();
NumberFormat nf_ge = NumberFormat.getInstance(Locale.GERMAN);
NumberFormat nf_ge1 = NumberFormat.getInstance(Locale.GERMAN);
nf_ge1.setMaximumFractionDigits(0);
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

String datum = request.getParameter("datum");
int mesec = 0;
if ((request.getParameter("mesec") == null) || request.getParameter("mesec").equals("izbrani")) {
	mesec = 1;
}
String sif_kupca = request.getParameter("sif_kupca");
if (sif_kupca!=null && sif_kupca.equals("null")) sif_kupca=null;

out.println("="+session.getAttribute("papirservis1_komunale_sif_kupca"));

if (sif_kupca == null && session.getAttribute("papirservis1_komunale_sif_kupca") != null) {
	sif_kupca = (String) session.getAttribute("papirservis1_komunale_sif_kupca");
}
else {
	session.setAttribute("papirservis1_komunale_sif_kupca", sif_kupca);
}
out.println("="+session.getAttribute("papirservis1_komunale_sif_kupca"));

%>
<%

String a = request.getParameter("Submit");
if (a != null && a.equals("Potrdi")) {
	Enumeration<String> parameterNames = request.getParameterNames();
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
    while (parameterNames.hasMoreElements()) {
        String paramName = parameterNames.nextElement();
        if (paramName.equals("start") || paramName.equals("psearch") || paramName.equals("sif_kupca") || paramName.equals("Submit") || paramName.equals("datum") || paramName.equals("mesec")) continue;
        String[] pKeys = paramName.split(":");
	  	String[] paramValues = request.getParameterValues(paramName);
        for (int i = 0; i < paramValues.length; i++) {
            String paramValue = paramValues[i].replace(".", "").replace(",", ".");
            if (paramValue.equals("")||paramValue.equals("0")) paramValue=null;
            if (pKeys[2].equals("zdruzi")) {
	            if (paramValue!=null) {
					String sqlquery = "update " + session.getAttribute("letoTabelaKomunale") + 
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
				String sqlquery = "update " + session.getAttribute("letoTabelaKomunale") + 
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

if (datum==null || datum.equals("-1") || datum.equals("")) {
	Calendar dat = Calendar.getInstance(TimeZone.getDefault()); 
	String y 	= String.valueOf(dat.get(Calendar.YEAR));
	String m 	= String.valueOf(dat.get(Calendar.MONTH) + 1);
	String d  = String.valueOf(dat.get(Calendar.DAY_OF_MONTH));
	if(d.length() == 1) d = "0" + d;
	if(m.length() == 1) m = "0" + m;
	
	String s = d;
	s = s + "." + m;
	s = s + "." + y;
	
	datum = s;
}

String datum_fm = null;
if ((datum != null) && (datum != ""))
{
	datum_fm = (EW_UnFormatDateTime((String)datum,"EURODATE", locale)).toString();
}


String caseStr = " CASE month(CAST('"+datum_fm+"' AS DATE)) " +
		" WHEN 1 THEN IFNULL(((if("+mesec+"=1,ifnull(dej_jan,kol_jan),kol_jan)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 2 THEN IFNULL(((ifnull(dej_jan,kol_jan)+if("+mesec+"=1,ifnull(dej_feb,kol_feb),kol_feb)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 3 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+if("+mesec+"=1,ifnull(dej_mar,kol_mar),kol_mar)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 4 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+if("+mesec+"=1,ifnull(dej_apr,kol_apr),kol_apr)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 5 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+if("+mesec+"=1,ifnull(dej_maj,kol_maj),kol_maj)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 6 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+if("+mesec+"=1,ifnull(dej_jun,kol_jun),kol_jun)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 7 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+if("+mesec+"=1,ifnull(dej_jul,kol_jul),kol_jul)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 8 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+if("+mesec+"=1,ifnull(dej_avg,kol_avg),kol_avg)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 9 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+ifnull(dej_avg,kol_avg)+if("+mesec+"=1,ifnull(dej_sep,kol_sep),kol_sep)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 10 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+ifnull(dej_avg,kol_avg)+ifnull(dej_sep,kol_sep)+if("+mesec+"=1,ifnull(dej_okt,kol_okt),kol_okt)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 11 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+ifnull(dej_avg,kol_avg)+ifnull(dej_sep,kol_sep)+ifnull(dej_okt,kol_okt)+if("+mesec+"=1,ifnull(dej_nov,kol_nov),kol_nov)) * delez/100),0) - IFNULL(SUM(kolicina),0) " +
		" WHEN 12 THEN IFNULL(((ifnull(dej_jan,kol_jan)+ifnull(dej_feb,kol_feb)+ifnull(dej_mar,kol_mar)+ifnull(dej_apr,kol_apr)+ifnull(dej_maj,kol_maj)+ifnull(dej_jun,kol_jun)+ifnull(dej_jul,kol_jul)+ifnull(dej_avg,kol_avg)+ifnull(dej_sep,kol_sep)+ifnull(dej_okt,kol_okt)+ifnull(dej_nov,kol_nov)+if("+mesec+"=1,ifnull(dej_dec,kol_dec),kol_dec)) * delez/100),0) " +
		" END prevzeto ";

//******************************************* ZBRANO ********************
String strsql = "SELECT DISTINCT aa.id, aa.sif_kupca, aa.koda, aa.zdruzi, aa.delez,  " +
		" kol_jan, kol_feb, kol_mar, kol_apr, kol_maj, kol_jun, kol_jul, kol_avg, kol_sep, kol_okt, kol_nov, kol_dec, " +
		" dej_jan, dej_feb, dej_mar, dej_apr, dej_maj, dej_jun, dej_jul, dej_avg, dej_sep, dej_okt, dej_nov, dej_dec, " +
		" zacetek, uporabnisko_ime, naziv, material, aa.zbrano, bb.prevzeto, bb.za_prevzeti " +
		/*", prevzeto, " +
		"CASE month(CAST('"+datum_fm+"' AS DATE))  " +
		" WHEN 1 THEN (IFNULL(kol_feb,0)*delez/100+prevzeto) " +
		" WHEN 2 THEN (IFNULL(kol_mar,0)*delez/100+prevzeto) " +
		" WHEN 3 THEN (IFNULL(kol_apr,0)*delez/100+prevzeto) " +
		" WHEN 4 THEN (IFNULL(kol_maj,0)*delez/100+prevzeto) " +
		" WHEN 5 THEN (IFNULL(kol_jun,0)*delez/100+prevzeto) " +
		" WHEN 6 THEN (IFNULL(kol_jul,0)*delez/100+prevzeto) " +
		" WHEN 7 THEN (IFNULL(kol_avg,0)*delez/100+prevzeto) " +
		" WHEN 8 THEN (IFNULL(kol_sep,0)*delez/100+prevzeto) " +
		" WHEN 9 THEN (IFNULL(kol_okt,0)*delez/100+prevzeto) " +
		" WHEN 10 THEN (IFNULL(kol_nov,0)*delez/100+prevzeto) " +
		" WHEN 11 THEN (IFNULL(kol_dec,0)*delez/100+prevzeto) " +
		" WHEN 12 THEN (IFNULL(kol_jan,0)*delez/100+prevzeto) " +
		" END za_prevzeti " +*/
		"from ( " +
		"select a.*, if(a.zdruzi is null,a.koda,a.zdruzi) kkoda, b.naziv, c.material, uporabniki.uporabnisko_ime, " +
		" sum(kolicina) zbrano  " +
		//" caseStr " +
		"from " + session.getAttribute("letoTabelaKomunale") + " as a "+
		" left join kupci as b on a.sif_kupca = b.sif_kupca "+
		" left join okolje as c on a.koda = c.koda "+
		" left join uporabniki on a.uporabnik = sif_upor " +
		" left join dob"+session.getAttribute("leto")+" as d on a.sif_kupca = d.sif_kupca and a.koda = d.ewc and d.datum <= CAST('"+datum_fm+"' AS DATE) ";

if (dbwhere.length() > 0) {
	whereClause += " (" + dbwhere + ") AND ";
}
if (whereClause.length() > 5 && whereClause.substring(whereClause.length()-5, whereClause.length()).equals(" AND ")) {
	whereClause = whereClause.substring(0, whereClause.length()-5);
}
if (whereClause.length() > 0) {
	strsql += " WHERE " + whereClause;
}
if (sif_kupca!=null && !sif_kupca.equals("-1") && !sif_kupca.equals("")) {
	if(whereClause.length() > 0)
		strsql += " AND a.sif_kupca = " + sif_kupca;
	else {
		strsql += " WHERE a.sif_kupca = " + sif_kupca;
	}
}

strsql += " GROUP BY a.sif_kupca, koda";
/*
//tole je se zaradi zdruzi
strsql += " UNION ALL ";

strsql += "select a.*, null kkoda, b.naziv, c.material, uporabniki.uporabnisko_ime, " +
		" sum(kolicina) zbrano,  " +
		" caseStr " +
		"from " + session.getAttribute("letoTabelaKomunale") + " as a "+
		" left join kupci as b on a.sif_kupca = b.sif_kupca "+
		" left join okolje as c on a.koda = c.koda "+
		" left join uporabniki on a.uporabnik = sif_upor " +
		" left join dob"+session.getAttribute("leto")+" as d on a.sif_kupca = d.sif_kupca and a.koda = d.ewc and d.datum <= CAST('"+datum_fm+"' AS DATE) "+
		" where zdruzi is not null ";

if (whereClause.length() > 0) {
	strsql += " AND " + whereClause;
}
if (sif_kupca!=null && !sif_kupca.equals("-1") && !sif_kupca.equals("")) {
	strsql += " AND a.sif_kupca = " + sif_kupca;
}

strsql += " GROUP BY a.sif_kupca, a.koda";*/

//
if (OrderBy != null && OrderBy.length() > 0) {
	strsql += " ORDER BY " + OrderBy + " " + (String) session.getAttribute("komunalekolicine_OT") + ") as a";
} else {
	strsql += " ORDER BY sif_kupca, ifnull(zdruzi, a.koda), a.koda) as aa";
}


strsql += " LEFT JOIN ";

strsql += "(SELECT DISTINCT sif_kupca, ifnull(zdruzi, koda) koda, sum(zbrano) zbrano, sum(prevzeto) prevzeto, SUM(prevzeto)-SUM(zbrano) za_prevzeti " +
		/*"sum(CASE month(CAST('"+datum_fm+"' AS DATE))  " +
		" WHEN 1 THEN (IFNULL(kol_feb,0)*delez/100+prevzeto) " +
		" WHEN 2 THEN (IFNULL(kol_mar,0)*delez/100+prevzeto) " +
		" WHEN 3 THEN (IFNULL(kol_apr,0)*delez/100+prevzeto) " +
		" WHEN 4 THEN (IFNULL(kol_maj,0)*delez/100+prevzeto) " +
		" WHEN 5 THEN (IFNULL(kol_jun,0)*delez/100+prevzeto) " +
		" WHEN 6 THEN (IFNULL(kol_jul,0)*delez/100+prevzeto) " +
		" WHEN 7 THEN (IFNULL(kol_avg,0)*delez/100+prevzeto) " +
		" WHEN 8 THEN (IFNULL(kol_sep,0)*delez/100+prevzeto) " +
		" WHEN 9 THEN (IFNULL(kol_okt,0)*delez/100+prevzeto) " +
		" WHEN 10 THEN (IFNULL(kol_nov,0)*delez/100+prevzeto) " +
		" WHEN 11 THEN (IFNULL(kol_dec,0)*delez/100+prevzeto) " +
		" WHEN 12 THEN (IFNULL(kol_jan,0)*delez/100+prevzeto) " +
		" END) za_prevzeti " +*/
		"from ( " +
		"select a.*, if(a.zdruzi is null,a.koda,a.zdruzi) kkoda, b.naziv, IFNULL(SUM(kolicina),0) zbrano, " +
		" caseStr " +
		"from " + session.getAttribute("letoTabelaKomunale") + " as a "+
		" left join kupci as b on a.sif_kupca = b.sif_kupca "+
		" left join dob"+session.getAttribute("leto")+" as d on a.sif_kupca = d.sif_kupca and a.koda = d.ewc and d.datum <= CAST('"+datum_fm+"' AS DATE) ";
		
if (sif_kupca!=null && !sif_kupca.equals("-1") && !sif_kupca.equals("")) {
	if(whereClause.length() > 0)
		strsql += " AND a.sif_kupca = " + sif_kupca;
	else {
		strsql += " WHERE a.sif_kupca = " + sif_kupca;
	}
}
strsql += " GROUP BY a.sif_kupca, a.koda";
strsql += " ORDER BY sif_kupca, a.koda) as aa ";
strsql += " GROUP BY aa.sif_kupca, IFNULL(aa.zdruzi, aa.koda) ";
				
strsql += " ) AS bb ON aa.sif_kupca = bb.sif_kupca and aa.koda = bb.koda";

if (session.getAttribute("komunalekolicine_hideEmpty").equals("1") && 
		(sif_kupca==null || sif_kupca.equals("-1") || sif_kupca.equals("")))
{
	strsql += " WHERE aa.zdruzi is null OR aa.zdruzi = aa.koda";
}

strsql += " ORDER BY aa.sif_kupca, aa.koda";

String sqlParam1 = URLEncoder.encode(strsql.toString());
String sqlParam2 = URLEncoder.encode(caseStr.toString());

strsql = strsql.replaceAll("caseStr", caseStr);

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

//******************************************* ZBRANO ********************


%>
<%@ include file="header.jsp" %>
<script language="JavaScript">
function disableSome(EW_this){
}

function keyPressed(event) {
    if (event.which == 13 || event.keyCode == 13) {
    	document.getElementById("Submit").value = "Potrdi";
    	return false;
    }
    return true;
};
</script>

<p><span class="jspmaker">Tabela: recikel embalaznina</span></p>
<form id="komunalaForm" name="komunalaForm" action="komunalekolicinelist.jsp" method="post">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="hidden" name="start" value="1">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" id="Submit" value="Išči">
		&nbsp;&nbsp;<a href="komunalekolicinelist.jsp?cmd=reset">Prikaži vse</a>
			<input type="button" name="btnExport" value="Izvoz v XLS" onClick="xls_create_komunala('<%=sqlParam1%>', '<%=sqlParam2%>')";>
			<% if (sif_kupca==null || sif_kupca.equals("-1") || sif_kupca.equals("")) { %>
				<input type="Submit" name="Submit" value="Skrij/Prikaži prazne" onClick='<%if (session.getAttribute("komunalekolicine_hideEmpty").equals("0")) {session.setAttribute("komunalekolicine_hideEmpty", "1");}else{session.setAttribute("komunalekolicine_hideEmpty", "0");}%>'>
			<% } %>
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
		</td>
	</tr>	
	<tr>
		<td class="jspmaker">Datum za dejanske količine:&nbsp;</td>
		<td class="jspmaker">
			<input type="text" name="datum" value="<%= EW_FormatDateTime(datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.datum,'dd.mm.yyyy');return false;">&nbsp;
		</td>		
	</tr>	
	<!-- tr>
		<td class="jspmaker">Izbrani mesec:&nbsp;</td>
		<td class="jspmaker">
    		<INPUT type="radio" name="mesec" value="izbrani" <%if (mesec==1) out.println("checked");%>>Izbrani
    		<INPUT type="radio" name="mesec" value="prejsnji" <%if (mesec==0) out.println("checked");%>>Prejšnji
		</td>
	</tr-->
</table>
<table>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<tr></tr>
	<tr>
		<td>
			<a href="komunalekolicineadd.jsp">Dodaj nov zapis</a>
			<% if (sif_kupca!=null && !sif_kupca.equals("-1") && !sif_kupca.equals("")) {%>
				<input type="Submit" name="Submit" value="Potrdi" autofocus>
			<% } %>
		</td>
	</tr>
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
<td><a href=>Delete</a></td>
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
<a href="">Prevzeto nalogi&nbsp;</a>
		</td>
		<td>
<a href="">Plan prevzema&nbsp;</a>
		</td>
		<td>
<a href="">Trenutno za prevzeti&nbsp;</a>
		</td>

		<td>
<%=(OrderBy != null && OrderBy.equals("dej_jan")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_jan","utf-8") %>">Dej jan&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_jan")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_jan")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_feb")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_feb","utf-8") %>">Dej feb&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_feb")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_feb")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_mar")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_mar","utf-8") %>">Dej mar&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_mar")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_mar")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_apr")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_apr","utf-8") %>">Dej apr&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_apr")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_apr")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_maj")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_maj","utf-8") %>">Dej maj&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_maj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_maj")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_jun")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_jun","utf-8") %>">Dej jun&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_jun")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_jun")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_jul")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_jul","utf-8") %>">Dej jul&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_jul")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_jul")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_avg")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_avg","utf-8") %>">Dej avg&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_avg")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_avg")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_sep")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_sep","utf-8") %>">Dej sep&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_sep")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_sep")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_okt")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_okt","utf-8") %>">Dej okt&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_okt")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_okt")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_nov")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_nov","utf-8") %>">Dej nov&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_nov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_nov")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("dej_dec")) ? "<b>" : ""%>
<a href="komunaledejicinelist.jsp?order=<%= java.net.URLEncoder.encode("dej_dec","utf-8") %>">Dej dec&nbsp;<% if (OrderBy != null && OrderBy.equals("dej_dec")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunaledejicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunaledejicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("dej_dec")) ? "</b>" : ""%>
		</td>
		<td>
<a href="">Dej sum&nbsp;</a>
		</td>
		
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jan")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_jan","utf-8") %>">Nap jan&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jan")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jan")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_feb")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_feb","utf-8") %>">Nap feb&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_feb")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_feb")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_mar")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_mar","utf-8") %>">Nap mar&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_mar")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_mar")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_apr")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_apr","utf-8") %>">Nap apr&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_apr")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_apr")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_maj")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_maj","utf-8") %>">Nap maj&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_maj")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_maj")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jun")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_jun","utf-8") %>">Nap jun&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jun")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jun")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_jul")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_jul","utf-8") %>">Nap jul&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_jul")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_jul")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_avg")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_avg","utf-8") %>">Nap avg&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_avg")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_avg")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_sep")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_sep","utf-8") %>">Nap sep&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_sep")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_sep")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_okt")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_okt","utf-8") %>">Nap okt&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_okt")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_okt")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_nov")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_nov","utf-8") %>">Nap nov&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_nov")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_nov")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("kol_dec")) ? "<b>" : ""%>
<a href="komunalekolicinelist.jsp?order=<%= java.net.URLEncoder.encode("kol_dec","utf-8") %>">Nap dec&nbsp;<% if (OrderBy != null && OrderBy.equals("kol_dec")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("komunalekolicine_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("komunalekolicine_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("kol_dec")) ? "</b>" : ""%>
		</td>
		<td>
<a href="">Kol sum&nbsp;</a>
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
	float x_dej_jan = 0;
	float x_dej_feb = 0;
	float x_dej_mar = 0;
	float x_dej_apr = 0;
	float x_dej_maj = 0;
	float x_dej_jun = 0;
	float x_dej_jul = 0;
	float x_dej_avg = 0;
	float x_dej_sep = 0;
	float x_dej_okt = 0;
	float x_dej_nov = 0;
	float x_dej_dec = 0;
	float x_zbrano = 0;
	float x_prevzeto = 0;
	float x_za_prevzeti = 0;

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

	if (rs.getString("dej_jan") != null){
		x_dej_jan = rs.getFloat("dej_jan");
	}else{
		x_dej_jan = 0;
	}	
	
	if (rs.getString("dej_feb") != null){
		x_dej_feb = rs.getFloat("dej_feb");
	}else{
		x_dej_feb = 0;
	}	
	
	if (rs.getString("dej_mar") != null){
		x_dej_mar = rs.getFloat("dej_mar");
	}else{
		x_dej_mar = 0;
	}	
	
	if (rs.getString("dej_apr") != null){
		x_dej_apr = rs.getFloat("dej_apr");
	}else{
		x_dej_apr = 0;
	}	
	
	if (rs.getString("dej_maj") != null){
		x_dej_maj = rs.getFloat("dej_maj");
	}else{
		x_dej_maj = 0;
	}		
	if (rs.getString("dej_jun") != null){
		x_dej_jun = rs.getFloat("dej_jun");
	}else{
		x_dej_jun = 0;
	}

	if (rs.getString("dej_jul") != null){
		x_dej_jul = rs.getFloat("dej_jul");
	}else{
		x_dej_jul = 0;
	}
	
	if (rs.getString("dej_avg") != null){
		x_dej_avg = rs.getFloat("dej_avg");
	}else{
		x_dej_avg = 0;
	}
	
	if (rs.getString("dej_sep") != null){
		x_dej_sep = rs.getFloat("dej_sep");
	}else{
		x_dej_sep = 0;
	}
	
	if (rs.getString("dej_okt") != null){
		x_dej_okt = rs.getFloat("dej_okt");
	}else{
		x_dej_okt = 0;
	}	

	
	if (rs.getString("dej_nov") != null){
		x_dej_nov = rs.getFloat("dej_nov");
	}else{
		x_dej_nov = 0;
	}	
	
	if (rs.getString("dej_dec") != null){
		x_dej_dec = rs.getFloat("dej_dec");
	}else{
		x_dej_dec = 0;
	}		

	if (rs.getString("zbrano") != null){
		x_zbrano = rs.getFloat("zbrano");
	}else{
		x_zbrano = 0;
	}		

	if (rs.getString("prevzeto") != null){
		x_prevzeto = rs.getFloat("prevzeto");
	}else{
		x_prevzeto = 0;
	}		

	if (rs.getString("za_prevzeti") != null){
		x_za_prevzeti = rs.getFloat("za_prevzeti");
	}else{
		x_za_prevzeti = 0;
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
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=key %>" class="jspmaker"></span></td>
<% } if (sif_kupca==null || sif_kupca.equals("-1") || sif_kupca.equals("")) {
	%>
	
		<td><% out.print(x_sif_kupca); %>&nbsp;</td>
		<td><% out.print(x_naziv); %>&nbsp;</td>
		<td nowrap><% out.print(x_koda); %>&nbsp;</td>
		<!-- td><% out.print(x_material); %>&nbsp;</td-->

	
		<td nowrap><% out.print(x_zdruzi); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_delez)); %>&nbsp;</td>
		<td><% out.print(nf_ge1.format(x_zbrano)); %>&nbsp;</td>
		<% if (x_koda.equals(x_zdruzi) || x_zdruzi.equals("") || (x_zdruzi == null)) { %>
			<td><% out.print(nf_ge1.format(x_prevzeto)); %>&nbsp;</td>
			<% if(x_za_prevzeti >= 0) { %> 
				<td><% out.print(nf_ge1.format(x_za_prevzeti)); %>&nbsp;</td>
			<% } else { %>
				<td class="ewCellKomunaleUnderZero"><% out.print(nf_ge1.format(x_za_prevzeti)); %>&nbsp;</td>			
			<% } %>
		<% } else { %>
			<td class="ewCellDontConfirmedRow"><% out.print(nf_ge1.format(x_prevzeto)); %>&nbsp;</td>
			<td class="ewCellDontConfirmedRow"><% out.print(nf_ge1.format(x_za_prevzeti)); %>&nbsp;</td>
		<% } %>

		<td><% out.print(nf_ge.format(x_dej_jan)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_feb)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_mar)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_apr)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_maj)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_jun)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_jul)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_avg)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_sep)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_okt)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_nov)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_dec)); %>&nbsp;</td>
		<td><% out.print(nf_ge.format(x_dej_jan+x_dej_feb+x_dej_mar+x_dej_apr+x_dej_maj+x_dej_jun+x_dej_jul+x_dej_avg+x_dej_sep+x_dej_okt+x_dej_nov+x_dej_dec)); %>&nbsp;</td>
		
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
		<td><% out.print(nf_ge.format(x_kol_jan+x_kol_feb+x_kol_mar+x_kol_apr+x_kol_maj+x_kol_jun+x_kol_jul+x_kol_avg+x_kol_sep+x_kol_okt+x_kol_nov+x_kol_dec)); %>&nbsp;</td>

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
		<td><% out.print(nf_ge1.format(x_zbrano)); %>&nbsp;</td>
		<% if (x_koda.equals(x_zdruzi) || x_zdruzi.equals("") || (x_zdruzi == null)) { %>
			<td><% out.print(nf_ge1.format(x_prevzeto)); %>&nbsp;</td>
			<% if(x_za_prevzeti >= 0) { %> 
				<td><% out.print(nf_ge1.format(x_za_prevzeti)); %>&nbsp;</td>
			<% } else { %>
				<td class="ewCellKomunaleUnderZero"><% out.print(nf_ge1.format(x_za_prevzeti)); %>&nbsp;</td>			
			<% } %>
		<% } else { %>
			<td class="ewCellDontConfirmedRow"><% out.print(nf_ge1.format(x_prevzeto)); %>&nbsp;</td>
			<td class="ewCellDontConfirmedRow"><% out.print(nf_ge1.format(x_za_prevzeti)); %>&nbsp;</td>
		<% } %>

		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_jan" size="3" value="<% out.print(nf_ge.format(x_dej_jan)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_feb" size="3" value="<% out.print(nf_ge.format(x_dej_feb)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_mar" size="3" value="<% out.print(nf_ge.format(x_dej_mar)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_apr" size="3" value="<% out.print(nf_ge.format(x_dej_apr)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_maj" size="3" value="<% out.print(nf_ge.format(x_dej_maj)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_jun" size="3" value="<% out.print(nf_ge.format(x_dej_jun)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_jul" size="3" value="<% out.print(nf_ge.format(x_dej_jul)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_avg" size="3" value="<% out.print(nf_ge.format(x_dej_avg)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_sep" size="3" value="<% out.print(nf_ge.format(x_dej_sep)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_okt" size="3" value="<% out.print(nf_ge.format(x_dej_okt)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_nov" size="3" value="<% out.print(nf_ge.format(x_dej_nov)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:dej_dec" size="3" value="<% out.print(nf_ge.format(x_dej_dec)); %>"></td>
		<td><% out.print(nf_ge.format(x_dej_jan+x_dej_feb+x_dej_mar+x_dej_apr+x_dej_maj+x_dej_jun+x_dej_jul+x_dej_avg+x_dej_sep+x_dej_okt+x_dej_nov+x_dej_dec)); %>&nbsp;</td>
		
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_jan" size="3" value="<% out.print(nf_ge.format(x_kol_jan)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_feb" size="3" value="<% out.print(nf_ge.format(x_kol_feb)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_mar" size="3" value="<% out.print(nf_ge.format(x_kol_mar)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_apr" size="3" value="<% out.print(nf_ge.format(x_kol_apr)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_maj" size="3" value="<% out.print(nf_ge.format(x_kol_maj)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_jun" size="3" value="<% out.print(nf_ge.format(x_kol_jun)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_jul" size="3" value="<% out.print(nf_ge.format(x_kol_jul)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_avg" size="3" value="<% out.print(nf_ge.format(x_kol_avg)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_sep" size="3" value="<% out.print(nf_ge.format(x_kol_sep)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_okt" size="3" value="<% out.print(nf_ge.format(x_kol_okt)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_nov" size="3" value="<% out.print(nf_ge.format(x_kol_nov)); %>"></td>
		<td><input type="text" onKeyPress="keyPressed(event, this);" name="<% out.print(sif_kupca); %>:<% out.print(x_koda); %>:kol_dec" size="3" value="<% out.print(nf_ge.format(x_kol_dec)); %>"></td>
		<td><% out.print(nf_ge.format(x_kol_jan+x_kol_feb+x_kol_mar+x_kol_apr+x_kol_maj+x_kol_jun+x_kol_jul+x_kol_avg+x_kol_sep+x_kol_okt+x_kol_nov+x_kol_dec)); %>&nbsp;</td>
		
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

