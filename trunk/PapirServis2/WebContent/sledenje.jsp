<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
<%@ page contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<% Locale locale = Locale.getDefault();%>
<% session.setMaxInactiveInterval(30*60); %>
<% 
String login = (String) session.getAttribute("papirservis1_status");
if (login == null || !login.equals("login")) {
response.sendRedirect("login.jsp");
response.flushBuffer(); 
return; 
}%>

<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript" src="ew.js"></script>

<script language="JavaScript" >
function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) 
{
	if (EW_this.od_datum && !EW_checkeurodate(EW_this.od_datum.value)) {
	        if (!EW_onError(EW_this, EW_this.od_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum od"))
	            return false; 
	}
	if (EW_this.do_datum && !EW_checkeurodate(EW_this.do_datum.value)) {
	        if (!EW_onError(EW_this, EW_this.do_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum do"))
	            return false; 
	}
	if (EW_this.x_sif_dob && !EW_hasValue(EW_this.x_sif_dob, "SELECT" )) {
	            if (!EW_onError(EW_this, EW_this.x_sif_dob, "SELECT", "Napačea številka - šifra dobavnice"))
	                return false; 
	}
	if (EW_this.x_stev_bianco && isNaN(EW_this.x_stev_bianco.value)) {
	            if (!EW_onError(EW_this, EW_this.x_stev_bianco, "SELECT", "Napačna številka - število dobavnic"))
	                return false; 
	}
}
</script>

<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%@ include file="header.jsp" %>
<%
	String stranke = (String) session.getAttribute("vse");
	String enote = (String) session.getAttribute("enote");
	String userID = (String)session.getAttribute("papirservis1_status_UserID");
	String enotaID = (String)session.getAttribute("papirservis1_status_Enota");

	
	Calendar dat = Calendar.getInstance(TimeZone.getDefault()); 
	String y 	= String.valueOf(dat.get(Calendar.YEAR));
	String m 	= String.valueOf(dat.get(Calendar.MONTH) + 1);
	String d  = String.valueOf(dat.get(Calendar.DAY_OF_MONTH));
	if(d.length() == 1) d = "0" + d;
	if(m.length() == 1) m = "0" + m;
	
	String s = d;
	s = s + "." + m;
	s = s + "." + y;
	
	String datum = s;

	
	//preberem vse kupce iz baze
	StringBuffer x_sif_kupcaList = null;
	
	String cbo_x_sif_kupca_js = "";

	x_sif_kupcaList = new StringBuffer("<select name=\"x_sif_kupca\"><option value=\"\">Izberi</option>");
	String sqlwrk_x_sif_kupca = "SELECT distinct stranke.sif_str, stranke.naziv " +
								"FROM stranke, kupci " +
								"WHERE (stranke.sif_kupca = kupci.sif_kupca) and " +
								"	   ((potnik = " +userID + ") || (" + stranke + " = 1)) and " +
								"	   ((kupci.sif_enote = " + enotaID + ") || (" + enote + " = 1))  " +
								"ORDER BY `naziv` ASC";
	
	Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
	
	int rowcntwrk_x_sif_kupca = 0;
	while (rswrk_x_sif_kupca.next()) {
		String tmpSifra = rswrk_x_sif_kupca.getString("sif_str");
		x_sif_kupcaList.append("<option value=\"").append(tmpSifra).append("\"");
		String tmpValue_x_sif_kupca = "";
		String tmpNaziv = rswrk_x_sif_kupca.getString("naziv");
		if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
		x_sif_kupcaList.append(">").append(tmpSifra + " " + tmpValue_x_sif_kupca).append("</option>");
		rowcntwrk_x_sif_kupca++;
	}
	rswrk_x_sif_kupca.close();
	rswrk_x_sif_kupca = null;
	stmtwrk_x_sif_kupca.close();
	stmtwrk_x_sif_kupca = null;
	x_sif_kupcaList.append("</select>");

	
	//preberem vse enote iz baze
	StringBuffer x_sif_enoteList = null;

	x_sif_enoteList = new StringBuffer("<select name=\"x_sif_enote\"><option value=\"\">Izberi</option>");
	String sqlwrk_x_sif_enote = "SELECT * FROM enote ORDER BY `naziv` ASC";
	Statement stmtwrk_x_sif_enote = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk_x_sif_enote = stmtwrk_x_sif_enote.executeQuery(sqlwrk_x_sif_enote);
	
	int rowcntwrk_x_sif_enote = 0;
	while (rswrk_x_sif_enote.next()) {
		String tmpSifra = rswrk_x_sif_enote.getString("sif_enote");
		x_sif_enoteList.append("<option value=\"").append(tmpSifra).append("\"");
		String tmpValue_x_sif_enote = "";
		String tmpNaziv = rswrk_x_sif_enote.getString("naziv");
		if (tmpNaziv!= null) tmpValue_x_sif_enote = tmpNaziv;
		x_sif_enoteList.append(">").append(tmpValue_x_sif_enote).append("</option>");
		rowcntwrk_x_sif_enote++;
	}
	rswrk_x_sif_enote.close();
	rswrk_x_sif_enote = null;
	stmtwrk_x_sif_enote.close();
	stmtwrk_x_sif_enote = null;
	x_sif_enoteList.append("</select>");


	//preberem vse skupine iz baze
	StringBuffer x_sif_skupineList = null;

	x_sif_skupineList = new StringBuffer("<select name=\"x_sif_skupine\"><option value=\"\">Izberi</option>");
	String sqlwrk_x_sif_skupine = "SELECT * FROM skup ORDER BY `tekst` ASC";
	Statement stmtwrk_x_sif_skupine = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk_x_sif_skupine = stmtwrk_x_sif_skupine.executeQuery(sqlwrk_x_sif_skupine);
	
	int rowcntwrk_x_sif_skupine = 0;
	while (rswrk_x_sif_skupine.next()) {
		String tmpSifra = rswrk_x_sif_skupine.getString("skupina");
		x_sif_skupineList.append("<option value=\"").append(tmpSifra).append("\"");
		String tmpValue_x_sif_skupine = "";
		String tmpNaziv = rswrk_x_sif_skupine.getString("tekst");
		if (tmpNaziv!= null) tmpValue_x_sif_skupine = tmpNaziv;
		x_sif_skupineList.append(">").append(tmpValue_x_sif_skupine).append("</option>");
		rowcntwrk_x_sif_skupine++;
	}
	rswrk_x_sif_skupine.close();
	rswrk_x_sif_skupine = null;
	stmtwrk_x_sif_skupine.close();
	stmtwrk_x_sif_skupine = null;
	x_sif_skupineList.append("</select>");
	
%>




<p><span class="jspmaker">Sledenje: izbor parametrov</span></p>
<form onSubmit="return EW_checkMyForm(this);" action="/papirservis/SledenjeServlet" name="porocila" method="post">

<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Izberite parametre za uvoz podatkov iz sledenja</span></td>
	</tr>
	<tr>
		<td class="ewTableHeader">&#352;ifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%>&nbsp;</td>
	</tr>

	<tr>
		<td class="ewTableHeader">Enota&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_enoteList);%>&nbsp;</td>
	</tr>

	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_skupineList);%>&nbsp;</td>
	</tr>

	<tr>
		<td class="ewTableHeader">Datum:&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="text" name="datum" value="<%= EW_FormatDateTime(datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.datum,'dd.mm.yyyy');return false;">&nbsp;
		</td>
	</tr>
	
	
	<tr>
		<td><span class="jspmaker">
			<input type="Submit" name="Submit" value="Potrdi">
		</span></td>
	</tr>
	
</table>
</form>

<%@ include file="footer.jsp" %>
