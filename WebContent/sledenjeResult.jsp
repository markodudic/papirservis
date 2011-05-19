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
}
</script>

<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%@ include file="header.jsp" %>
<%
	Vector data = (Vector) session.getAttribute("data");
	Vector result = (Vector) session.getAttribute("result");

	String commit = (String) request.getParameter("commit");
	if ((commit != null) && commit.equals("true"))
	{
		//vpisem podatke iz result v bazo
		try
		{
			Statement stmt = conn.createStatement();

			for (int i=0; i<result.size(); i++)
			{		
				Vector resultRecord = (Vector) result.get(i);
				
				int pot = ((Integer) resultRecord.get(1)).intValue()/1000;
				String cas = ((Integer) resultRecord.get(2)).toString();
				int ura = Integer.parseInt(cas) / 3600;	
				int min = (Integer.parseInt(cas) / 60) % 60;
				if (min <= 30) cas = Integer.toString(ura);
				else cas = Integer.toString(ura) + ".5";
				
				String sql = "update dob set " +
							 "	stev_km_sled = " + pot + 
							 ", stev_ur_sled = " + cas +
							 " where st_dob = " + (Integer) resultRecord.get(0);
				System.out.println("UPDATE SLEDENJE="+sql);
				stmt.executeUpdate(sql);
			}
			
			stmt.close();
			stmt = null;		
		}
		catch (Exception e)
		{
			System.out.println("NAPAKA="+e);
		}
	
		response.sendRedirect("sledenje.jsp"); 
		response.flushBuffer(); 
		return;
	}
	

	
%>




<p><span class="jspmaker">Rezultat poizvedbe iz sistema sledenja<br><br><a href="sledenje.jsp">Nazaj na sledenje</a></span></p>

<form onSubmit="return EW_checkMyForm(this);" action="sledenjeResult.jsp?commit=true" name="porocila" method="post">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker"></span></td>
	</tr>
	
<table class="ewTable">
	<tr class="ewTableHeader">
		<td>Dobavnica&nbsp;</td>
		<td>Sifra stranke&nbsp;</td>
		<td>Naziv stranke&nbsp;</td>
		<td>Pot (km)&nbsp;</td>
		<td>Cas (h)&nbsp;</td>
	</tr>
	
<%
int recCount = 0;
for (int i=0; i<data.size(); i++)
{
	Vector dataRecord = (Vector) data.get(i);
	Vector resultRecord = new Vector();
	for (int ii=0; ii<result.size(); ii++)
	{	
		resultRecord = (Vector) result.get(ii);
		if (((String) dataRecord.get(0)).equals(((Integer) resultRecord.get(0)).toString()))
			break;
	}
		
	recCount ++;
	String rowclass = "ewTableRow"; // Set row color

	if (recCount%2 != 0 ) { // Display alternate color for rows
		rowclass = "ewTableAltRow";
	}
	
	String pot = "";
	String cas = "";
	
	if (resultRecord.size()>0) 
	{
		pot = ((Integer) resultRecord.get(1)).toString();
		NumberFormat formatter = new DecimalFormat("#,###,##0");
		pot = formatter.format(new Integer(Integer.parseInt(pot)/1000));
		    
		    
		cas = ((Integer) resultRecord.get(2)).toString();
		int ura = Integer.parseInt(cas) / 3600;	
		int min = (Integer.parseInt(cas) / 60) % 60;
		if (min <= 30) cas = Integer.toString(ura);
		else cas = Integer.toString(ura) + ".5";
	}
%>
	<tr class="<%= rowclass %>">
		<td class="<%= rowclass %>"><% out.print(dataRecord.get(0)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(dataRecord.get(1)); %>&nbsp;</td>
		<td class="<%= rowclass %>"><% out.print(dataRecord.get(2)); %>&nbsp;</td>
		<td class="<%= rowclass %>" align="right"><% out.print(pot); %>&nbsp;</td>
		<td class="<%= rowclass %>" align="right"><% out.print(cas); %>&nbsp;</td>
    </tr>
	
<%
}
%>	
	
	<tr>
		<td><span class="jspmaker">
			<input type="Submit" name="Submit" value="Potrdi">
		</span></td>
	</tr>
	
</table>
</form>

<%@ include file="footer.jsp" %>
