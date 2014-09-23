<html>
<head>
	<title>PAPIR SERVIS - Podpora logistiki odvoza surovin</title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="papirservis1.css" rel="stylesheet" type="text/css" />
<link href="master.css" rel="stylesheet" type="text/css" />
<meta name="generator" content="JSPMaker v1.0.0.0" />
</head>
<body onload="disableSome();">

<% 
String reports = (String)session.getAttribute("papirservis1_status_Reports");
String narocila = (String)session.getAttribute("papirservis1_status_Narocila");
String arso = (String)session.getAttribute("papirservis1_status_Arso");

int meni = 	((Integer) session.getAttribute("meni")).intValue();

// user menues
final int ewSifers = 1;
final int ewDriveOut = 2;
final int ewSell = 4;
final int ewProcess = 8;
final int ewCalculations = 16;

final int ewAdmin = 16;

int ewCurAdmin  = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();


%>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<!-- left column -->
	<td width="10%" height="100%" valign="top">
		<table width="100%" border="1" cellspacing="0" cellpadding="0">
			<tr class="ewTableHeader2"><td nowrap align="center"><span class="jspmaker2"><%= session.getAttribute("leto") %></span></td></tr>
<%
if ((meni & ewSifers) ==  ewSifers){
%>
			<tr class="ewTableHeaderMeni"><td nowrap><span class="jspmaker">&#352;IFRANTI</span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="cenastrlist.jsp?cmd=top">Cene stranke</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="enotelist.jsp?cmd=resetall">Enote</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="kamionlist.jsp?cmd=top">Kamion</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="kupcilist.jsp?cmd=resetall">Kupci</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="material_okoljelist.jsp?cmd=resetall">Material okolje</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="materialilist.jsp?cmd=top">Materiali</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="okoljelist.jsp?cmd=resetall">Okolje</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="osnovnalist.jsp?cmd=top">Osnovna</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="postelist.jsp?cmd=resetall">Po&#353;te</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="skuplist.jsp?cmd=resetall">Skupine</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="soferlist.jsp?cmd=resetall">&#352;oferji</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="strankelist.jsp?cmd=top">Stranke (Lokacije)</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker">&nbsp;</span></td></tr>
<%}%>

<%
if ((meni & ewDriveOut) == ewDriveOut){
%>
			<tr class="ewTableHeaderMeni"><td nowrap><span class="jspmaker">ODVOZI</span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="doblist.jsp?cmd=top">Dobavnice</a></span></td></tr>
			<% if (Integer.parseInt(narocila) == 1) { %>
				<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="dobnarlist.jsp?cmd=top">Dobavnice naro&#269;ila</a></span></td></tr>
			<% } %>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="dobavnicalist.jsp?cmd=top">Delovni nalog - VNOS</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="delovniNalogPriprava.jsp">Delovni nalog - PERIODA</a></span></td></tr>
			<% if (Integer.parseInt(reports) == 1) { %>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=9">Delovni nalog (Izpis)</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=1">Delovni nalog bianko (Izpis)</a></span></td></tr>
			<% } %>
			<% if (Integer.parseInt(arso) == 1) { %>
				<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="arsopaketilist.jsp?cmd=resetall">Arso poro&#269;anje</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="arsopaketirocnolist.jsp?cmd=resetall">Arso poro&#269;anje ro&#269;no</a></span></td></tr>
			<% } %>
			<!-- tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="sledenje.jsp">Sledenje (Uvoz podatkov)</a></span></td></tr-->
			<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=17">Sumarno vozniki</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=20">Vozniki planirane dobavnice</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=23">Dobavnice ure in kilometri</a></span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker">&nbsp;</span></td></tr>
<%}%>

<%
if ((meni & ewSell) == ewSell){
%>
			<tr class="ewTableHeaderMeni"><td nowrap><span class="jspmaker">PRODAJA</span></td></tr>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="prodajalist.jsp?cmd=resetall">Prodaja</a></span></td></tr>
			<% if (Integer.parseInt(reports) == 1) { %>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=5">Dobavnice</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=6">Materiali</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=7">Rekapitulacija kupec</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=21">Rekapitulacija</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=19">Eviden&#269;ni list</a></span></td></tr>
			<% } %>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker">&nbsp;</span></td></tr>
<%}%>

<%
if ((meni & ewProcess) == ewProcess){
%>		
			<% if (Integer.parseInt(reports) == 1) { %>	
				<tr class="ewTableHeaderMeni"><td nowrap><span class="jspmaker">OBRA&#268;UNI</span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=2">Meteriali</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=3">Osnovna</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=10">Osnovna vse stranke</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=16">Osnovna neodvoz</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=11">Sistem embalaza</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=24">Sistem embalaza nova</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=4">Rekapitulacija</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=15">Rekapitulacija brez cen</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=12">Zara&#269;unavamo storitve</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=13">Eviden&#269;ni list</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport">&nbsp;</span></td></tr>
			<% } %>
<%}%>

<%
if ((meni & ewCalculations) == ewCalculations){
%>
			<% if (Integer.parseInt(reports) == 1) { %>	
				<tr class="ewTableHeaderMeni"><td nowrap><span class="jspmaker">KALKULACIJE</span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=8">Rekapitulacija</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=14">Rekapitulacija skupaj</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=18">Rekapitulacija neodvoz</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport"><a href="porocila.jsp?report=22">Kupci izpis</a></span></td></tr>
				<tr class="ewTableHeader"><td nowrap><span class="jspmakerReport">&nbsp;</span></td></tr>
			<% } %>
<%}%>

<%
if ((ewCurAdmin & ewAdmin) == ewAdmin) {
%>
			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="uporabnikilist.jsp?cmd=resetall">Uporabniki</a></span></td></tr>
<%}%>

			<tr class="ewTableHeader"><td nowrap><span class="jspmaker"><a href="logout.jsp">Odjava</a></span></td></tr>
		</table>
	</td>
	<td>&nbsp;</td>
	<!-- right column -->
	<td valign="top">
