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

<script language="JavaScript">

function disableSome(EW_this){
}

function  EW_checkMyForm(EW_this) 
{
	if (EW_this.od_datum && !EW_checkeurodate(EW_this.od_datum.value)) {
	        if (!EW_onError(EW_this, EW_this.od_datum, "TEXT", "Napačn datum (dd.mm.yyyy) - datum od"))
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

	String datum = request.getParameter("od_datum");
	String type = request.getParameter("type");
		
	String userID = (String)session.getAttribute("papirservis1_status_UserID");
	String enotaID = (String)session.getAttribute("papirservis1_status_Enota");

	if ((datum != null) && (type != null))
	{ 
		try
		{	
		    String x_sif_enote = request.getParameter("x_sif_enote");

			String datumEU = (EW_UnFormatDateTime((String)datum,"EURODATE", locale)).toString();
			String[] days = {"NED", "PON", "TOR", "SRE", "CET", "PET", "SOB"}; 
			
			//določim kateri dan v tednu je
			String sqlD = "SELECT DAYOFWEEK('" + datumEU + "');";
			Statement stmtD = conn.createStatement();
			ResultSet rsD = stmtD.executeQuery(sqlD);
		
			int dayId = 1;
			while (rsD.next()) {
				dayId = rsD.getInt(1);
			}
			String day = days[dayId-1];
			                  
			rsD.close();
			rsD = null;
			stmtD.close();
			stmtD = null;		
			
			//generiram delovne naloge
	//		String sql = "SELECT sif_str FROM stranke WHERE " + day + " = " + type + " or " + day + " = 3";
			String sql = "SELECT sif_str, st.cena, kupci.sif_kupca, kupci.skupina, st.stev_km_norm, st.stev_ur_norm, arso_prjm_status, arso_aktivnost_prjm, arso_odp_embalaza_shema, arso_odp_dej_nastanka "+
						 "FROM (SELECT stranke.* "+
						 "		FROM stranke, (SELECT sif_str, max(zacetek) datum FROM stranke group by sif_str ) zadnji "+
						 "		WHERE stranke.sif_str = zadnji.sif_str and "+
						 "		      stranke.zacetek = zadnji.datum) st, "+
						 "		(select sif_kupca, skupina, sif_enote " +
						 "		from kupci " +
						 "		where ((potnik = " +userID + ") || (" + stranke + " = 1)) and " +
						 "			  (kupci.sif_enote = " + x_sif_enote + ")) kupci, " +
						 "		enote, skup  " +
						 "WHERE st.sif_kupca = kupci.sif_kupca and (" + day + " = " + type + " or " + day + " = 3) " +
						 "		 and kupci.sif_enote = enote.sif_enote and kupci.skupina = skup.skupina";

			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
	
			Statement stmtwrk_bianco = conn.createStatement();
			ResultSet rswrk_bianco = null;
			Statement stmtwrk_bianco_u = conn.createStatement();
				
			Statement stmtI = conn.createStatement();
			int i = 0;
	
			while (rs.next()) {
				String sif = rs.getString("sif_str");
				String cena = rs.getString("cena");
				String sif_kupca = rs.getString("sif_kupca");
				String skupina = rs.getString("skupina");
				String stev_km_norm = rs.getString("stev_km_norm");
				String stev_ur_norm = rs.getString("stev_ur_norm");
				String arso_prjm_status = rs.getString("arso_prjm_status");
				String arso_aktivnost_prjm = rs.getString("arso_aktivnost_prjm");
				String arso_odp_embalaza_shema = rs.getString("arso_odp_embalaza_shema");
				if (arso_odp_embalaza_shema != null) arso_odp_embalaza_shema = "'"+arso_odp_embalaza_shema+"'";
				String arso_odp_dej_nastanka = rs.getString("arso_odp_dej_nastanka");
				
				//povecam prvo stevilko za 1
				String sqlwrk_bianco_u = "UPDATE dob_bianco set st_dob = st_dob + 1 where id = '" + session.getAttribute("letoTabela") + "'";
				stmtwrk_bianco_u.executeUpdate(sqlwrk_bianco_u);					

				//dolocim st_dob iz tabele dob_bianco
				int biancoSifra = 0;
				String sqlwrk_bianco = "SELECT st_dob FROM dob_bianco where id = '" + session.getAttribute("letoTabela") + "'";
				rswrk_bianco = stmtwrk_bianco.executeQuery(sqlwrk_bianco);
				
				int rowcntwrk_x_sif_kupca = 0;
				while (rswrk_bianco.next()) {
					biancoSifra = rswrk_bianco.getInt(1);
				}
				
					
				//Vpisem generirane delovne naloge
				String sqlI = "insert into " + session.getAttribute("letoTabela") + "(st_dob, pozicija, datum, sif_str, cena, uporabnik, sif_kupca, skupina, stev_ur_norm, stev_km_norm, arso_prjm_status, arso_aktivnost_prjm, arso_odp_embalaza_shema, arso_odp_dej_nastanka) " +
							" VALUES (" + biancoSifra + ", 1, CAST('" + datumEU + "' AS DATE), " + sif + ",  " + cena + ", " + userID + ", '" + sif_kupca + "', " + skupina + ", " + stev_ur_norm + ", " + stev_km_norm + ", '" + arso_prjm_status + "', '" + arso_aktivnost_prjm + "', " + arso_odp_embalaza_shema + ", '" + arso_odp_dej_nastanka + "')";

				stmtI.executeUpdate(sqlI);
				i++;
			}
			out.println("Pripravljeno je " + i + " delovna/ih nalogov");
			
			rswrk_bianco.close();
			rswrk_bianco = null;
			stmtwrk_bianco.close();
			stmtwrk_bianco = null;
			stmtwrk_bianco_u.close();
			stmtwrk_bianco_u = null;		
	
			stmtI.close();
			stmtI = null;		
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;		
		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.out.println("NAPAKA="+e);
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
	
	
	StringBuffer x_sif_enoteList = new StringBuffer("<select name=\"x_sif_enote\">");
	String sqlwrk_x_sif_enote = "SELECT * FROM enote WHERE (sif_enote = " + enotaID + ") || (" + enote + " = 1) ORDER BY `naziv` ASC";
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
	
%>




<p><span class="jspmaker">Delovni nalogi priprava: izbor parametrov</span></p>
<form onSubmit="return EW_checkMyForm(this);" action="" name="priprava">

<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Izberite parametre za pripravo delovnih nalogov</span></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Enota&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_enoteList);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum:&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="text" name="od_datum" value="<%= EW_FormatDateTime(od_datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum od" onClick="popUpCalendar(this, this.form.od_datum,'dd.mm.yyyy');return false;">&nbsp;
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Tip tedna:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="type" value="1" checked>Sod
    		<INPUT type="radio" name="type" value="2">Lih
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
