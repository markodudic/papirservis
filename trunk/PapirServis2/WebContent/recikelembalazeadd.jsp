<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" errorPage="recikelembalazelist.jsp"%>
<%@ page contentType="text/html; charset=utf-8" %>
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
int [] ew_SecTable = new int[3+1];
ew_SecTable[0] = 15;
ew_SecTable[1] = 13;
ew_SecTable[2] = 15;
ew_SecTable[3] = 8;

// get current table security
int ewCurSec = 0; // initialise
ewCurSec = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();
if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("recikelembalazelist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("utf-8");

// Get action
String a = request.getParameter("a");
String key = "";
if (a == null || a.length() == 0) {
	key = request.getParameter("key");
	if (key != null && key.length() > 0) {
		a = "C"; // Copy record
	} else {
		a = "I"; // Display blank record
	}
}
String x_tar_st = "";
String x_naziv = "";
String x_koda = "";
String x_porocilo = "";
Object x_zacetek = null;
String x_uporabnik = "";
String x_material = "";

StringBuffer x_kodaList = null;

// Open Connection to the database
try{ 
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM recikel_embalaze" + session.getAttribute("leto") + " WHERE `id`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("recikelembalazelist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
		if (rs.getString("tar_st") != null){
			x_tar_st = rs.getString("tar_st");
		}else{
			x_tar_st = "";
		}
		if (rs.getString("naziv") != null){
			x_naziv = rs.getString("naziv");
		}else{
			x_naziv = "";
		}
		if (rs.getString("porocilo") != null){
			x_porocilo = rs.getString("porocilo");
		}else{
			x_porocilo = "";
		}
		if (rs.getString("ewc_koda") != null){
			x_koda = rs.getString("ewc_koda");
		}else{
			x_koda = "";
		}
		if (rs.getTimestamp("zacetek") != null){
			x_zacetek = rs.getTimestamp("zacetek");
		}else{
			x_zacetek = null;
		}
		x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_tar_st") != null){
			x_tar_st = request.getParameter("x_tar_st");
		}
		if (request.getParameter("x_koda") != null){
			x_koda = request.getParameter("x_koda");
		}
		if (request.getParameter("x_naziv") != null){
			x_naziv = (String) request.getParameter("x_naziv");
		}else{
			x_naziv = "";
		}
		if (request.getParameter("x_porocilo") != null){
			x_porocilo = (String) request.getParameter("x_porocilo");
		}else{
			x_porocilo = "";
		}
		if (request.getParameter("x_zacetek") != null){
			x_zacetek = (String) request.getParameter("x_zacetek");
		}else{
			x_zacetek = "";
		}
		if (request.getParameter("x_uporabnik") != null){
			x_uporabnik = request.getParameter("x_uporabnik");
		}

		// Open record
		String strsql = "SELECT * FROM recikel_embalaze" + session.getAttribute("leto") + " WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field sif_kupca
		tmpfld = ((String) x_tar_st);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("tar_st");
		}else{
			String srchfld = "'" + tmpfld + "'";
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM recikel_embalaze" + session.getAttribute("leto") + " WHERE `id` = '" + srchfld +"'";
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				out.print("Duplicate key for id, value = " + tmpfld + "<br>");
				out.print("Press [Previous Page] key to continue!");
				return;
			}
			rschk.close();
			rschk = null;
			rs.updateString("tar_st", tmpfld);
		}

		// Field koda
		tmpfld = ((String) x_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("ewc_koda");
		}else{
			rs.updateString("ewc_koda", tmpfld);
		}

		// Field cena
		tmpfld = ((String) x_naziv).trim();
		if (tmpfld == null) {
			rs.updateNull("naziv");
		} else {
			rs.updateString("naziv",tmpfld);
		}

		tmpfld = ((String) x_porocilo).trim();
		if (tmpfld == null) {
			rs.updateNull("porocilo");
		} else {
			rs.updateString("porocilo",tmpfld);
		}
		
		
		//Uporabnik
		rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
		
		try{
			rs.insertRow();
		}
		catch(java.sql.SQLException e){
			System.out.println(e.getMessage());
		}
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("recikelembalazelist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}


if(request.getParameter("prikaz_koda")!= null){
	session.setAttribute("recikelembalaze_koda",  request.getParameter("prikaz_koda"));
}




String cbo_x_koda_js = "";
x_kodaList = new StringBuffer("<select name=\"x_koda\"><option value=\"\">Izberi</option>");
String sqlwrk_x_koda = "SELECT `koda`, `material` " +
								"FROM `okolje` " +
								"order by " + session.getAttribute("recikelembalaze_koda") + " asc";
Statement stmtwrk_x_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_koda = stmtwrk_x_koda.executeQuery(sqlwrk_x_koda);
	int rowcntwrk_x_koda = 0;
	while (rswrk_x_koda.next()) {
		x_kodaList.append("<option value=\"").append(rswrk_x_koda.getString("koda")).append("\"");
		if (rswrk_x_koda.getString("koda").equals(x_koda)) {
			x_kodaList.append(" selected");
		}
		String tmpValue_x_koda = "";
		String tmpNaziv = rswrk_x_koda.getString((String)session.getAttribute("recikelembalaze_koda"));
		if (tmpNaziv != null) tmpValue_x_koda = tmpNaziv;
		x_kodaList.append(">").append(tmpValue_x_koda).append("</option>");
		rowcntwrk_x_koda++;
	}
rswrk_x_koda.close();
rswrk_x_koda = null;
stmtwrk_x_koda.close();
stmtwrk_x_koda = null;
x_kodaList.append("</select>");


%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Dodaj v: recikel embalaže<br><br><a href="recikelembalazelist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>

<form onSubmit="return EW_checkMyForm(this);"  action="recikelembalazeadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Tar št.&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_tar_st" size="30" value="<%= HTMLEncode((String)x_tar_st) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Naziv&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_naziv" size="30" value="<%= HTMLEncode((String)x_naziv) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Poročilo&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="x_porocilo">
			<%
				String sqlwrk_x_arso_status = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'recikel_embalaze" + session.getAttribute("leto") + "' AND COLUMN_NAME = 'porocilo'";
				Statement stmtwrk_x_arso_status = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rswrk_x_arso_status = stmtwrk_x_arso_status.executeQuery(sqlwrk_x_arso_status);
					if (rswrk_x_arso_status.next()) {
						String x_arso_listEnum = HTMLEncode(rswrk_x_arso_status.getString("COLUMN_TYPE"));
						x_arso_listEnum = x_arso_listEnum.substring(5, x_arso_listEnum.length()-1);
						String[] x_arso_list = x_arso_listEnum.split(",");
						for (int i=0; i<x_arso_list.length; i++) {
							String x_arso_listOption = "<option value=\"" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "\"";
							if (HTMLEncode(x_arso_list[i].replaceAll("'", "")).equals(x_porocilo)) {
								x_arso_listOption += " selected";
							}
							x_arso_listOption += ">" + HTMLEncode(x_arso_list[i].replaceAll("'", "")) + "</option>";
							out.println(x_arso_listOption);			
						}
					}
				rswrk_x_arso_status.close();
				rswrk_x_arso_status = null;
				stmtwrk_x_arso_status.close();
				stmtwrk_x_arso_status = null;
			%>
			</select>
		</td>	
	</tr>	
	<tr>
		<td class="ewTableHeader">Material koda&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_kodaList);%><span class="jspmaker"><a href="<%out.print("recikelembalazeadd.jsp?prikaz_koda=koda");%>">koda</a>&nbsp;<a href="<%out.print("recikelembalazeadd.jsp?prikaz_koda=material");%>">material</a>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Dodaj">
</form>
<%@ include file="footer.jsp" %>
