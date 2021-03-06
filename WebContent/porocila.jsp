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
<script language="JavaScript" src="papirservis.js"></script>

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
	
	if ((document.porocila.reportID.value == 26) || (document.porocila.reportID.value == 27) || (document.porocila.reportID.value == 29) || (document.porocila.reportID.value == 30)) {
		if (document.porocila.nacin_obracuna_list.value == "VSI" && document.porocila.x_sif_zavezanca.value == "-1" && document.porocila.kumulativa.value == "ne") {
			alert ("Ni možno izbrati vse stranke in vse obračune");
			return false;
		}
	}
}

function updateKoda(EW_this){
	document.porocila.nacin_obracuna_list.value = zavezanci_interval[document.porocila.x_sif_zavezanca.selectedIndex - 1];
	document.porocila.nacin_obracuna.value = zavezanci_interval[document.porocila.x_sif_zavezanca.selectedIndex - 1];
	if (document.porocila.x_sif_zavezanca.selectedIndex > 0) {
		document.porocila.nacin_obracuna_list.disabled=true;
	}
	else {
		document.porocila.nacin_obracuna_list.disabled=false;		
	}
	updateRacun();
}

function updateNacin(){
	document.porocila.nacin_obracuna.value = document.porocila.nacin_obracuna_list.value;
	updateRacun();
}	

function updateRacun(){
	if ((document.porocila.nacin_obracuna.value == "MD") || (document.porocila.nacin_obracuna.value == "QD") || (document.porocila.nacin_obracuna.value == "LD")) {
		document.porocila.pavsal.style.visibility = 'hidden';
		document.porocila.obracun.style.visibility = 'visible';
		document.porocila.obracun.checked = true;
		document.porocila.poracun.style.visibility = 'hidden';
		document.getElementById("lPavsal").style.display = 'none';
		document.getElementById("lObracun").style.display = 'inline';
		document.getElementById("lPoracun").style.display = 'none';
	}
	else {
		document.porocila.pavsal.style.visibility = 'visible';
		document.porocila.pavsal.checked = true;
		document.porocila.obracun.style.visibility = 'hidden';
		document.porocila.poracun.style.visibility = 'visible';		
		document.getElementById("lPavsal").style.display = 'inline';
		document.getElementById("lObracun").style.display = 'none';
		document.getElementById("lPoracun").style.display = 'inline';
	}}	
</script>

<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%@ include file="header.jsp" %>
<%
	String stranke = (String) session.getAttribute("vse");
	String enote = (String) session.getAttribute("enote");
	String userID = (String)session.getAttribute("papirservis1_status_UserID");
	String enotaID = (String)session.getAttribute("papirservis1_status_Enota");

	StringBuffer sif_kupac2 = new StringBuffer();
	StringBuffer sif_kupac = new StringBuffer();
	StringBuffer x_sif_strList = null;
	
	
	String[] reportsList = {"/reports/dobavnica", 
							"/reports/dobavnica_bianco",
							"/reports/materiali",
							"/reports/osnovna",
							"/reports/rekapitulacija",
							"/reports/dobavnica_prodaja",
							"/reports/materiali_prodaja",
							"/reports/rekapitulacija_prodaja",
							"/reports/rekapitulacija_skupaj",
							"/reports/dobavnica_obdobje",
							//10
							"/reports/osnovna_stranke",
							"/reports/sistem_embalaza",
							"/reports/zaracunavamo_storitve",
							"/reports/evidencni_list",
							"/reports/rekapitulacija_total",
							"/reports/rekapitulacija",
							"/reports/osnovna_neodvoz",
							"/reports/vozniki_sumarno",
							"/reports/rekapitulacija_total_neodvoz",
							"/reports/evidencni_list_prodaja",
							//20
							"/reports/vozniki_planirane_dobavnice",
							"/reports/rekapitulacija_prodaja_skupaj",
							"/reports/kupci_izpis",
							"/reports/dobavnice_km_ure",
							"/reports/sistem_embalaza_nova",
							"/reports/embalaznina_racuni",
							"/reports/embalaznina_porocila",
							"/reports/embalaznina_rekapitulacija",
							"/reports/embalaznina_racuni_new",
							"/reports/embalaznina_porocila_new",
							//30
							"/reports/embalaznina_rekapitulacija_new",
							"/reports/rekapitulacija_total_2",
							"/reports/rekapitulacija_skupaj_2"
						};
	
	int reportID = (new Integer(request.getParameter("report"))).intValue();
	String report = reportsList[reportID];
	
	StringBuffer zavezanci_interval = new StringBuffer();
	
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

	
	//preberem vse kupce iz baze
	StringBuffer x_sif_kupcaList = null;
	
	if ((reportID == 4) || (reportID == 7) || (reportID == 8) || (reportID == 12) || (reportID == 13) || (reportID == 19) || (reportID == 15) || (reportID == 31))
	{
		x_sif_kupcaList = new StringBuffer("<select name=\"x_sif_kupca\" id=\"x_sif_kupca\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_sif_kupca = "SELECT distinct sif_kupca, naziv " +
									"FROM kupci " +
									"WHERE ((potnik = " +userID + ") || (" + stranke + " = 1)) and " +
									(reportID == 7 ? "prodaja = 1 and " : "") +
									"	   ((kupci.sif_enote = " + enotaID + ") || (" + enote + " = 1))  " +
									"ORDER BY `naziv` ASC";
		
		Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
		
		int rowcntwrk_x_sif_kupca = 0;
		while (rswrk_x_sif_kupca.next()) {
			String tmpSifra = rswrk_x_sif_kupca.getString("sif_kupca");
			x_sif_kupcaList.append("<option value=\"").append(tmpSifra).append("\"");
			String tmpValue_x_sif_kupca = "";
			String tmpNaziv = rswrk_x_sif_kupca.getString("naziv");
			if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
			x_sif_kupcaList.append(">").append(tmpValue_x_sif_kupca).append("</option>");
			rowcntwrk_x_sif_kupca++;
		}
		rswrk_x_sif_kupca.close();
		rswrk_x_sif_kupca = null;
		stmtwrk_x_sif_kupca.close();
		stmtwrk_x_sif_kupca = null;
		x_sif_kupcaList.append("</select>");
	}

	if ((reportID == 32))
	{
		x_sif_kupcaList = new StringBuffer("<select onchange = \"updateDropDowns(this);\" name=\"x_sif_kupca\" id=\"x_sif_kupca\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_sif_kupca = "SELECT distinct sif_kupca, naziv " +
									"FROM kupci " +
									"ORDER BY `naziv` ASC";
		
		Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
		
		int rowcntwrk_x_sif_kupca = 0;
		while (rswrk_x_sif_kupca.next()) {
			String tmpSifra = rswrk_x_sif_kupca.getString("sif_kupca");
			x_sif_kupcaList.append("<option value=\"").append(tmpSifra).append("\"");
			String tmpValue_x_sif_kupca = "";
			String tmpNaziv = rswrk_x_sif_kupca.getString("naziv");
			
			sif_kupac.append("sif_kupac2[").append(rowcntwrk_x_sif_kupca).append("]=").append("'"+rswrk_x_sif_kupca.getString("sif_kupca")+"'").append(";");

			
			if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
			x_sif_kupcaList.append(">").append(tmpValue_x_sif_kupca).append("</option>");
			rowcntwrk_x_sif_kupca++;
		}
		rswrk_x_sif_kupca.close();
		rswrk_x_sif_kupca = null;
		stmtwrk_x_sif_kupca.close();
		stmtwrk_x_sif_kupca = null;
		x_sif_kupcaList.append("</select>");
		
		x_sif_strList = new StringBuffer("<select name=\"x_sif_str\" STYLE=\"font-family : monospace;  font-size : medium\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_sif_str = "SELECT sif_str, naziv, sif_kupca " +
			"FROM stranke " +
			" ORDER BY naziv ASC";

		Statement stmtwrk_x_sif_str = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_str = stmtwrk_x_sif_str.executeQuery(sqlwrk_x_sif_str);
			int rowcntwrk_x_sif_str = 0;
			while (rswrk_x_sif_str.next()) {
				//x_sif_strList += "<option value=\"" + HTMLEncode(rswrk_x_sif_str.getString("sif_str")) + "\"";
				String tmpSif = rswrk_x_sif_str.getString("sif_str");
				x_sif_strList.append("<option value=\"").append(tmpSif).append("\"");
				String tmpValue_x_sif_str = "";
				String tmpNaziv = rswrk_x_sif_str.getString("naziv");
				
				sif_kupac.append("sif_kupac[").append(tmpSif).append("]=").append("'"+rswrk_x_sif_str.getString("sif_kupca")+"'").append(";");

				if (tmpNaziv!= null) tmpValue_x_sif_str = tmpNaziv;
				x_sif_strList.append(">").append(tmpValue_x_sif_str).append("</option>");
				rowcntwrk_x_sif_str++;
			}
		rswrk_x_sif_str.close();
		rswrk_x_sif_str = null;
		stmtwrk_x_sif_str.close();
		stmtwrk_x_sif_str = null;
		x_sif_strList.append("</select>");
		
	}

	
	StringBuffer x_sif_zavezanciList = null;
	
	if ((reportID == 25) || (reportID == 28))
	{
		x_sif_zavezanciList = new StringBuffer("<select name=\"x_sif_zavezanca\" onchange = \"updateKoda(this);\"><option value=\"-1\">Izberi</option>");
	}
	if ((reportID == 26) || (reportID == 27) || (reportID == 29) || (reportID == 30))
	{
		x_sif_zavezanciList = new StringBuffer("<select name=\"x_sif_zavezanca\" ><option value=\"-1\">Izberi</option>");
	}
	
	if ((reportID == 25) || (reportID == 26) || (reportID == 27) || (reportID == 28) || (reportID == 29) || (reportID == 30))
	{
		String sqlwrk_x_sif_kupca = "SELECT distinct id, st_pogodbe, naziv, interval_pavsala " +
									"FROM recikel_zavezanci" + session.getAttribute("leto") + " " +
									"ORDER BY naziv ASC";
		
		Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
		
		int rowcntwrk_x_sif_kupca = 0;
		while (rswrk_x_sif_kupca.next()) {
			String tmpSifra = rswrk_x_sif_kupca.getString("id");
			x_sif_zavezanciList.append("<option value=\"").append(tmpSifra).append("\"");
			String tmpValue_x_sif_kupca = "";
			String tmpNaziv = rswrk_x_sif_kupca.getString("naziv");
			if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
			x_sif_zavezanciList.append(">").append(tmpValue_x_sif_kupca).append("</option>");
			
			zavezanci_interval.append("zavezanci_interval[").append(rowcntwrk_x_sif_kupca).append("]='").append(String.valueOf(rswrk_x_sif_kupca.getString("interval_pavsala"))).append("';");

			rowcntwrk_x_sif_kupca++;
		}
		rswrk_x_sif_kupca.close();
		rswrk_x_sif_kupca = null;
		stmtwrk_x_sif_kupca.close();
		stmtwrk_x_sif_kupca = null;
		x_sif_zavezanciList.append("</select>");
	}

	
	//preberem vse nadenote iz baze
	StringBuffer x_sif_nadenoteList = null;

	if ((reportID == 2) || (reportID == 4) || (reportID == 12) || (reportID == 14) || (reportID == 15) || (reportID == 18) || (reportID == 22) || (reportID == 24) || (reportID == 31))  
	{
		x_sif_nadenoteList = new StringBuffer("<select name=\"x_sif_nadenote\" id=\"x_sif_nadenote\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_nadenota = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'enote' AND TABLE_SCHEMA='salomon' AND COLUMN_NAME = 'nadenota'";
		Statement stmtwrk_x_nadenota = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_nadenota = stmtwrk_x_nadenota.executeQuery(sqlwrk_x_nadenota);
			if (rswrk_x_nadenota.next()) {
				String x_nadenota_listEnum = HTMLEncode(rswrk_x_nadenota.getString("COLUMN_TYPE"));
				x_nadenota_listEnum = x_nadenota_listEnum.substring(5, x_nadenota_listEnum.length()-1);
				String[] x_nadenota_list = x_nadenota_listEnum.split(",");
				for (int i=0; i<x_nadenota_list.length; i++) {
					String x_arso_listOption = "<option value=\"" + HTMLEncode(x_nadenota_list[i].replaceAll("'", "")) + "\"";
					x_arso_listOption += ">" + HTMLEncode(x_nadenota_list[i].replaceAll("'", "")) + "</option>";
					x_sif_nadenoteList.append(x_arso_listOption);
				}
			}
		rswrk_x_nadenota.close();
		rswrk_x_nadenota = null;
		stmtwrk_x_nadenota.close();
		stmtwrk_x_nadenota = null;
		x_sif_nadenoteList.append("</select>");
		

		
	}
	
	//preberem vse enote iz baze
	StringBuffer x_sif_enoteList = null;
	
	if ((reportID == 2) || (reportID == 4) || (reportID == 6) || (reportID == 7) || (reportID == 11) || 
		 (reportID == 12) || (reportID == 13) || (reportID == 19) || (reportID == 14) || (reportID == 15) || (reportID == 18) || 
		 (reportID == 21) || (reportID == 22) || (reportID == 24) || (reportID == 31) || (reportID == 32))
	{
		x_sif_enoteList = new StringBuffer("<select name=\"x_sif_enote\" id=\"x_sif_enote\"><option value=\"\">Izberi</option>");
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
	}

	//preberem vse skupine iz baze
	StringBuffer x_sif_skupineList = null;

	if ((reportID == 2) || (reportID == 4) || (reportID == 11) || (reportID == 12) || 
		 (reportID == 13) || (reportID == 19) || (reportID == 14) || (reportID == 15) || (reportID == 18) || 
		 (reportID == 22) || (reportID == 24) || (reportID == 31) || (reportID == 32))
	{ 
		x_sif_skupineList = new StringBuffer("<select name=\"x_sif_skupine\" id=\"x_sif_skupine\"><option value=\"\">Izberi</option>");
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
	}

	
	
	//preberem vse dobavnice iz baze
	StringBuffer x_sif_dobList = null;
	if ((reportID == 0) || (reportID == 5))
	{
		String table = session.getAttribute("letoTabela") + " dob";
		String where = " WHERE sif_kam IS NULL ";
		if (reportID == 5) 
		{
			table = session.getAttribute("letoTabelaProdaja") + " prodaja";
			where = "";
		}
		
		String cbo_x_sif_dob_js = "";
		x_sif_dobList = new StringBuffer("<select name=\"x_sif_dob\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_sif_dob = "SELECT distinct `st_dob` FROM " + table + where + " ORDER BY `st_dob` DESC";
		Statement stmtwrk_x_sif_dob = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_dob = stmtwrk_x_sif_dob.executeQuery(sqlwrk_x_sif_dob);
		
		int rowcntwrk_x_sif_dob = 0;
		while (rswrk_x_sif_dob.next()) {
			String tmpSifra = rswrk_x_sif_dob.getString("st_dob");
			x_sif_dobList.append("<option value=\"").append(tmpSifra).append("\"");
			x_sif_dobList.append(">").append(tmpSifra).append("</option>");
			rowcntwrk_x_sif_dob++;
		}
		rswrk_x_sif_dob.close();
		rswrk_x_sif_dob = null;
		stmtwrk_x_sif_dob.close();
		stmtwrk_x_sif_dob = null;
		x_sif_dobList.append("</select>");
	}
	
	//preberem osnovna iz baze
	StringBuffer x_sif_osnovnaList = null;

	if ((reportID == 10) || (reportID == 16))
	{
		x_sif_osnovnaList = new StringBuffer("<select name=\"x_sif_osnovna\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_sif_osnovna = "SELECT * FROM osnovna ORDER BY `osnovna` ASC";
		Statement stmtwrk_x_sif_osnovna = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_osnovna = stmtwrk_x_sif_osnovna.executeQuery(sqlwrk_x_sif_osnovna);
		
		int rowcntwrk_x_sif_osnovna = 0;
		while (rswrk_x_sif_osnovna.next()) {
			String tmpSifra = rswrk_x_sif_osnovna.getString("sif_os");
			x_sif_osnovnaList.append("<option value=\"").append(tmpSifra).append("\"");
			String tmpValue_x_sif_osnovna = "";
			String tmpNaziv = rswrk_x_sif_osnovna.getString("osnovna");
			if (tmpNaziv!= null) tmpValue_x_sif_osnovna = tmpNaziv;
			x_sif_osnovnaList.append(">").append(tmpValue_x_sif_osnovna).append("</option>");
			rowcntwrk_x_sif_osnovna++;
		}
		rswrk_x_sif_osnovna.close();
		rswrk_x_sif_osnovna = null;
		stmtwrk_x_sif_osnovna.close();
		stmtwrk_x_sif_osnovna = null;
		x_sif_osnovnaList.append("</select>");
	}

	
	//preberem potnik iz baze
	StringBuffer x_sif_potnikList = null;

	if ((reportID == 10) || (reportID == 14) || (reportID == 18) || (reportID == 22) || (reportID == 31))
	{
		x_sif_potnikList = new StringBuffer("<select name=\"x_sif_potnik\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_sif_potnik = "SELECT `sif_upor`, `ime_in_priimek` FROM `uporabniki` where aktiven=1 order by `ime_in_priimek`";
		Statement stmtwrk_x_sif_potnik = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_potnik = stmtwrk_x_sif_potnik.executeQuery(sqlwrk_x_sif_potnik);
		
		int rowcntwrk_x_sif_potnik = 0;
		while (rswrk_x_sif_potnik.next()) {
			String tmpSifra = rswrk_x_sif_potnik.getString("sif_upor");
			x_sif_potnikList.append("<option value=\"").append(tmpSifra).append("\"");
			String tmpValue_x_sif_potnik = "";
			String tmpNaziv = rswrk_x_sif_potnik.getString("ime_in_priimek");
			if (tmpNaziv!= null) tmpValue_x_sif_potnik = tmpNaziv;
			x_sif_potnikList.append(">").append(tmpValue_x_sif_potnik).append("</option>");
			rowcntwrk_x_sif_potnik++;
		}
		rswrk_x_sif_potnik.close();
		rswrk_x_sif_potnik = null;
		stmtwrk_x_sif_potnik.close();
		stmtwrk_x_sif_potnik = null;
		x_sif_potnikList.append("</select>");
	}

	
	//preberem vse kamione iz baze
	StringBuffer x_sif_kamioniList = null;

	if ((reportID == 20) || (reportID == 23))
	{
		x_sif_kamioniList = new StringBuffer("<select name=\"x_sif_kamioni\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_sif_kamioni = "SELECT kamion.* "+
											"FROM kamion, (SELECT sif_kam, max(zacetek) datum FROM kamion group by sif_kam ) zadnji "+
											"WHERE kamion.sif_kam = zadnji.sif_kam and "+
											"      kamion.zacetek = zadnji.datum "+
											"      ORDER BY kamion ASC";
		Statement stmtwrk_x_sif_kamioni = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_kamioni = stmtwrk_x_sif_kamioni.executeQuery(sqlwrk_x_sif_kamioni);
		
		int rowcntwrk_x_sif_kamioni = 0;
		while (rswrk_x_sif_kamioni.next()) {
			String tmpSifra = rswrk_x_sif_kamioni.getString("sif_kam");
			x_sif_kamioniList.append("<option value=\"").append(tmpSifra).append("\"");
			String tmpValue_x_sif_kamioni = "";
			String tmpNaziv = rswrk_x_sif_kamioni.getString("kamion");
			if (tmpNaziv!= null) tmpValue_x_sif_kamioni = tmpNaziv;
			x_sif_kamioniList.append(">").append(tmpValue_x_sif_kamioni).append("</option>");
			rowcntwrk_x_sif_kamioni++;
		}
		rswrk_x_sif_kamioni.close();
		rswrk_x_sif_kamioni = null;
		stmtwrk_x_sif_kamioni.close();
		stmtwrk_x_sif_kamioni = null;
		x_sif_kamioniList.append("</select>");
	}
	
	
	//preberem vse voznike iz baze
	StringBuffer x_sif_voznikiList = null;

	if ((reportID == 20) || (reportID == 23))
	{
		x_sif_voznikiList = new StringBuffer("<select name=\"x_sif_vozniki\"><option value=\"\">Izberi</option>");
		String sqlwrk_x_sif_vozniki = "SELECT * FROM sofer ORDER BY sofer ASC";
		Statement stmtwrk_x_sif_vozniki = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswrk_x_sif_vozniki = stmtwrk_x_sif_vozniki.executeQuery(sqlwrk_x_sif_vozniki);
		
		int rowcntwrk_x_sif_vozniki = 0;
		while (rswrk_x_sif_vozniki.next()) {
			String tmpSifra = rswrk_x_sif_vozniki.getString("sif_sof");
			x_sif_voznikiList.append("<option value=\"").append(tmpSifra).append("\"");
			String tmpValue_x_sif_vozniki = "";
			String tmpNaziv = rswrk_x_sif_vozniki.getString("sofer");
			if (tmpNaziv!= null) tmpValue_x_sif_vozniki = tmpNaziv;
			x_sif_voznikiList.append(">").append(tmpValue_x_sif_vozniki).append("</option>");
			rowcntwrk_x_sif_vozniki++;
		}
		rswrk_x_sif_vozniki.close();
		rswrk_x_sif_vozniki = null;
		stmtwrk_x_sif_vozniki.close();
		stmtwrk_x_sif_vozniki = null;
		x_sif_voznikiList.append("</select>");
	}
%>
	
<script language="JavaScript">		

	var sif_kupac2 = new Array();
	<%=sif_kupac2%>

	var sif_kupac = new Array();
	<%=sif_kupac%>

	var zavezanci_interval = new Array();
	<%=zavezanci_interval%>
	
	function updateDropDowns(EW_this){
		document.porocila.x_sif_str[0].selected = true;
		
		for (i=1; i<document.porocila.x_sif_str.length; i++) {
			if (sif_kupac[document.porocila.x_sif_str[i].value] != sif_kupac2[document.porocila.x_sif_kupca.selectedIndex-1]) {
				document.porocila.x_sif_str[i].style.display = "none";
			}
			else {
				document.porocila.x_sif_str[i].style.display = "block";
			}
		
		}
		
		
	}	
	
</script>

<p><span class="jspmaker">Poro&#269;ila: izbor parametrov</span></p>
<form onSubmit="return EW_checkMyForm(this);" action="printDelovniNalog.jsp" name="porocila" id="porocila" method="post">

<input type="hidden" name="report" value=<%=report%>>
<input type="hidden" name="reportID" value=<%=reportID%>>
<input type="hidden" name="nacin_obracuna" value="MP">

<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Izberite parametre za izdelavo poro&#269;ila</span></td>
	</tr>
	<%if (reportID == 1) {%>
	<tr>
		<td class="ewTableHeader">&#352;tevilo dobavnic&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_bianco" size="3" maxlength="3" value="1">&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 0) || (reportID == 5)) {%>
	<tr>
		<td class="ewTableHeader">&#352;ifra dobavnice&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_dobList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 4) || (reportID == 7) || (reportID == 8) || (reportID == 12) || (reportID == 13) || (reportID == 19) || (reportID == 15) || (reportID == 31) || (reportID == 32)) {%>
	<tr>
		<td class="ewTableHeader">&#352;ifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 32)) {%>
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_strList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 25) || (reportID == 26) || (reportID == 27) || (reportID == 28) || (reportID == 29) || (reportID == 30)) {%>
	<tr>
		<td class="ewTableHeader">&#352;ifra zavezanca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_zavezanciList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%	if ((reportID == 2) || (reportID == 4) || (reportID == 12) || (reportID == 14) || (reportID == 15) || (reportID == 18) || (reportID == 22) || (reportID == 24) || (reportID == 31))  {%>
	<tr>
		<td class="ewTableHeader">Nadenota&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_nadenoteList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 2) || (reportID == 4) || (reportID == 6) || (reportID == 7) || (reportID == 11) || 
			(reportID == 12) || (reportID == 13) || (reportID == 19) || (reportID == 14) || (reportID == 15) || (reportID == 18)
			 || (reportID == 21) || (reportID == 22) || (reportID == 24) || (reportID == 31) || (reportID == 32)) {%>
	<tr>
		<td class="ewTableHeader">Enota&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_enoteList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 2) || (reportID == 4) || (reportID == 11) || (reportID == 12) || 
			(reportID == 13) || (reportID == 19) || (reportID == 14) || (reportID == 15) || (reportID == 18)
			 || (reportID == 22) || (reportID == 24) || (reportID == 31) || (reportID == 32)) {%>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_skupineList);%>&nbsp;
			<%if (reportID == 24) { %>
					<br>OPOZORILO: Ravnanje dela samo če je izbrana skupina.
			<%}%>
		</td>
	</tr>
	<%}%>
	<%if ((reportID == 10) || (reportID == 14) || (reportID == 18) || (reportID == 22)) {%>
	<tr>
		<td class="ewTableHeader">Potnik&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_potnikList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 10) || (reportID == 16)) {%>
	<tr>
		<td class="ewTableHeader">Osnovna&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_osnovnaList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 20) || (reportID == 23)) {%>
	<tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kamioniList);%>&nbsp;</td>
	</tr>
	<%}%>
	<%if ((reportID == 20) || (reportID == 23)) {%>
	<tr>
		<td class="ewTableHeader">Vozniki&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_voznikiList);%>&nbsp;</td>
	</tr>
	<%}%>
	
	<%if ((reportID != 0) && (reportID != 1) && (reportID != 3) && (reportID != 5) && (reportID != 10) && (reportID != 22) && (reportID != 26) && (reportID != 27) && (reportID != 29) && (reportID != 30)) {%>
	<tr>
		<td class="ewTableHeader">Datum od:&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="text" name="od_datum" id="od_datum"  value="<%= EW_FormatDateTime(od_datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum od" onClick="popUpCalendar(this, this.form.od_datum,'dd.mm.yyyy');return false;">&nbsp;
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum do:&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="text" name="do_datum" id="do_datum" value="<%= EW_FormatDateTime(do_datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum do" onClick="popUpCalendar(this, this.form.do_datum,'dd.mm.yyyy');return false;">&nbsp;
		</td>
	</tr>
	<%}%>

	<%if ((reportID == 25) || (reportID == 28)) {%>
	<tr>
		<td class="ewTableHeader">Datum opravljene storitve:&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="text" name="opravljena_storitva" value="<%= EW_FormatDateTime(od_datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum opravljene storitve" onClick="popUpCalendar(this, this.form.opravljena_storitva,'dd.mm.yyyy');return false;">&nbsp;
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum računa:&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="text" name="datum_racuna" value="<%= EW_FormatDateTime(do_datum,7, locale) %>">&nbsp;
			<input type="image" src="images/ew_calendar.gif" alt="Izberi datum računa" onClick="popUpCalendar(this, this.form.datum_racuna,'dd.mm.yyyy');return false;">&nbsp;
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stroškovno mesto:&nbsp;</td>
		<td class="ewTableAltRow">
			<input type="text" name="stroskovno_mesto" value="1001">&nbsp;
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Način obračuna:&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="nacin_obracuna_list" onchange="updateNacin();" style="width:100px">
				<option value="MP">MP</option>
				<option value="MD">MD</option>
				<option value="QP">QP</option>
				<option value="QD">QD</option>
				<option value="LP">LP</option>
				<option value="LD">LD</option>
			</select>&nbsp;
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Tip računa:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="racun" id="pavsal" value="2" checked><label id="lPavsal">Pavšal</label>
    		<INPUT type="radio" name="racun" id="obracun" value="0"><label id="lObracun">Obračun</label>
    		<INPUT type="radio" name="racun" id="poracun" value="1"><label id="lPoracun">Poračun</label>
		</td>
	</tr>
	<%}%>

	<%if ((reportID == 26)  || (reportID == 27)  || (reportID == 29)  || (reportID == 30)) {%>
	<tr>
		<td class="ewTableHeader">Način obračuna:&nbsp;</td>
		<td class="ewTableAltRow">
			<select name="nacin_obracuna_list" style="width:150px">
				<option value="VSI">Vsi obračuni</option>
				<option value="LN">Letna napoved</option>
				<option value="Q1">1. kvartal</option>
				<option value="Q2">2. kvartal</option>
				<option value="Q3">3. kvartal</option>
				<option value="Q4">4. kvartal</option>
				<option value="LD">Letna dejansko</option>
			</select>&nbsp;
		</td>
	</tr>
	<%}%>

	<%if ((reportID == 26)  || (reportID == 29)) {%>
	<tr>
		<td class="ewTableHeader">Kumulativa:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="kumulativa" value="da" checked>Da
    		<INPUT type="radio" name="kumulativa" value="ne">Ne
		</td>
	</tr>
	<%}%>
	
	<%if ((reportID == 14) || (reportID == 18) || (reportID == 31)) {%>
	<!-- tr>
		<td class="ewTableHeader">Sortiranje:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="sort" value="1" checked>Naziv
    		<INPUT type="radio" name="sort" value="2">Dobi&#269;ek
		</td>
	</tr-->
	<%}%>
	<%if ((reportID == 20)) {%>
	<tr>
		<td class="ewTableHeader">Delovni nalogi:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="obdelana" value="0" checked>Odprti
    		<INPUT type="radio" name="obdelana" value="2">Vsi
		</td>
	</tr>
	<%}%>
	<%if ((reportID == 22)) {%>
	<tr>
		<td class="ewTableHeader">Blokada:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="blokada" value="0" checked>Ne
    		<INPUT type="radio" name="blokada" value="1">Da
		</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Razred:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="razred" value="A" checked>A
    		<INPUT type="radio" name="razred" value="B">B
    		<INPUT type="radio" name="razred" value="C">C
		</td>
	</tr>
	<%}%>
	<%if ((reportID == 23)) {%>
	<tr>
		<td class="ewTableHeader">Sortiranje:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="sort" value="st_dob" checked>Št. dobavnice
    		<INPUT type="radio" name="sort" value="delta">Delta
		</td>
	</tr>
	<%}%>

	<%if ((reportID == 24)) {%>
	<tr>
		<td class="ewTableHeader">Brez table KODA:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="brezKoda" value="0" checked>Ne
    		<INPUT type="radio" name="brezKoda" value="1">Da
		</td>
	</tr>
	<%}%>
			
	<tr>
		<td class="ewTableHeader">Tip poro&#269;ila:&nbsp;</td>
		<td class="ewTableAltRow">
    		<INPUT type="radio" name="type" value="1" checked>PDF
	<%if ((reportID != 27) && (reportID != 30)) {%>
    		<INPUT type="radio" name="type" value="2">HTML
	<%}%>
	<%if ((reportID == 13) || (reportID == 19)) {%>
    		<INPUT type="radio" name="type" value="3">DOC
	<%}%>
	<%if ((reportID == 26) || (reportID == 27) || (reportID == 29) || (reportID == 30)) {%>
    		<INPUT type="radio" name="type" value="4">XLS
	<%}%>
	<%if ((reportID == 12)) {%>
		<input type="button" name="btnExport" value="Izvoz v XLS" onClick="xls_create_storitve('<%=session.getAttribute("leto")%>')";>
	<%}%>
	
		</td>
	</tr>
	
	
	<tr>
		<td><span class="jspmaker">
			<input type="Submit" name="Submit" value="Potrdi">
		</span></td>
	</tr>
	
</table>
</form>

<script language="JavaScript" >
	updateNacin()
</script>

<%@ include file="footer.jsp" %>
