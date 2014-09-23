<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
<% Locale locale = Locale.getDefault();
/*response.setLocale(locale);*/%>
<%
Calendar dat = Calendar.getInstance(TimeZone.getDefault()); 
String year 	= String.valueOf(dat.get(Calendar.YEAR));

try{
	Class.forName("com.mysql.jdbc.Driver").newInstance();
}catch (Exception ex){
	out.println(ex.toString());
}

boolean validpwd = false;
String escapeString = "\\\\'";
if (request.getParameter("submit") != null && ((String) request.getParameter("submit")).length() > 0) {

	// Setup variables
	String userid = request.getParameter("userid") + "";
	String passwd = request.getParameter("passwd") + "";
    if (!validpwd) {
    		Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = null;
			rs = stmt.executeQuery("SELECT * FROM `uporabniki` WHERE aktiven=1 and `uporabnisko_ime` = '" + userid.replaceAll("'",escapeString) + "'");
			if (rs.next()) {
				if (rs.getString("geslo").toUpperCase().equals(passwd.toUpperCase())) {
					session.setAttribute("papirservis1_status_Name", rs.getString("ime_in_priimek"));
					session.setAttribute("papirservis1_status_User", rs.getString("uporabnisko_ime"));
					session.setAttribute("papirservis1_status_Mail", rs.getString("email"));
				 	session.setAttribute("papirservis1_status_UserID", rs.getString("sif_upor"));
				 	session.setAttribute("papirservis1_status_UserLevel", new Integer(rs.getInt("tip")));
				 	session.setAttribute("papirservis1_status_Reports", rs.getString("porocila"));
				 	session.setAttribute("papirservis1_status_Enota", rs.getString("sif_enote"));
				 	session.setAttribute("papirservis1_status_Narocila", rs.getString("narocila_potrjevanje"));
				 	session.setAttribute("papirservis1_status_Arso", rs.getString("arso"));
				 	session.setAttribute("papirservis1_status_Arso_popravljanje", new Integer(rs.getInt("arso_popravljanje")));

				 	session.setAttribute("meni", new Integer(rs.getString("meni")));

				 	session.setAttribute("dob_kupci_show", "naziv");
				 	session.setAttribute("dob_stranke_show", "naziv");
				 	session.setAttribute("dob_kamion_show", "kamion");
				 	session.setAttribute("dob_sofer_show", "sofer");
					session.setAttribute("dob_prikaz_material_1","koda");
					session.setAttribute("dob_prikaz_material_2","koda");
					session.setAttribute("dob_prikaz_material_3","koda");
					session.setAttribute("dob_prikaz_material_4","koda");
					session.setAttribute("dob_prikaz_okolje_1","koda");
					session.setAttribute("dob_prikaz_okolje_2","koda");
					session.setAttribute("dob_prikaz_okolje_3","koda");
					session.setAttribute("dob_prikaz_okolje_4","koda");

				 	session.setAttribute("stranke_kupci_show", "naziv");
					session.setAttribute("stranke_osnovna_show",  "osnovna");


				 	session.setAttribute("dobavnica_kupci_show", "naziv");
				 	session.setAttribute("dobavnica_stranke_show", "naziv");
				 	session.setAttribute("dobavnica_kamion_show", "kamion");
				 	session.setAttribute("dobavnica_sofer_show", "sofer");

				 	session.setAttribute("prodaja_kupci_show", "naziv");
					session.setAttribute("prodaja_prikaz_material","koda");
					session.setAttribute("prodaja_prikaz_okolje","koda");


				 	session.setAttribute("cenastr_material_koda",  "material");
				 	session.setAttribute("cenastr_kupac",  "naziv");
					session.setAttribute("osnovna_show",  "osnovna");

					session.setAttribute("material_okolje_prikaz_material","koda");
					session.setAttribute("material_okolje_prikaz_okolje","koda");

					session.setAttribute("vse",  rs.getString("vse"));
					session.setAttribute("enote",  rs.getString("enote"));

					validpwd = true;
				}
			}
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
	}
	if (validpwd) {
		// Write cookies
		if (request.getParameter("rememberme") != null && ((String)request.getParameter("rememberme")).length() > 0) {
			Cookie cookie = new Cookie("papirservis1_userid", new String(userid));
			cookie.setMaxAge(365*24*60*60);
			response.addCookie(cookie);
		}
		session.setAttribute("papirservis1_status", "login");

		session.setAttribute("leto",  request.getParameter("leto"));
		if (request.getParameter("leto").equals("2008"))
			session.setAttribute("letoTabela",  "dob");
		else
			session.setAttribute("letoTabela",  "dob"+request.getParameter("leto"));			

		if (request.getParameter("leto").equals("2008"))
			session.setAttribute("letoTabelaProdaja",  "prodaja");
		else
			session.setAttribute("letoTabelaProdaja",  "prodaja"+request.getParameter("leto"));			

		response.sendRedirect("index.jsp");
	}
}else{
	validpwd = true;
}


%>
<html>
<head>
	<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="papirservis1.css" rel="stylesheet" type="text/css" />
<link href="master.css" rel="stylesheet" type="text/css" />
<meta name="generator" content="JSPMaker v1.0.0.0" />
</head>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start JavaScript
function disableSome(EW_this){
}
function  EW_checkMyForm(EW_this) {
if  (!EW_hasValue(EW_this.userid, "TEXT" )) {
            if  (!EW_onError(EW_this, EW_this.userid, "TEXT", "Vnesite uporabnisko ime"))
                return false;
        }
if  (!EW_hasValue(EW_this.passwd, "PASSWORD" )) {
            if  (!EW_onError(EW_this, EW_this.passwd, "PASSWORD", "Vnesite geslo"))
                return false;
        }
return true;
}

// end JavaScript -->
</script>
<body>
<table border="0" cellspacing="0" cellpadding="2" align="center">
	<tr>
		<td><span class="jspmaker"></span></td>
	</tr>
</table>
<% if (!validpwd) { %>
<p align="center"><span class="jspmaker" style="color: Red;">Napa&#269;no uporabni&#353;ko ime in/ali geslo</span></p>
<% } %>
<%
Cookie cookie = null;
Cookie [] ar_cookie = request.getCookies();
String userid = "";
for (int i = 0; i < ar_cookie.length; i++){
	cookie = ar_cookie[i];
	if (cookie.getName().equals("papirservis1_userid")){
		userid = (String) cookie.getValue();
	}
}
%>
<br><br><br>
<form action="login.jsp" method="post" onSubmit="return EW_checkMyForm(this);">
<table border="0" cellspacing="0" cellpadding="4" align="center">
	<tr>
		<td colspan=2>
			<img src="./images/kovine.jpg" width="300">
		</td>
	</tr>
	<tr>
		<td><span class="jspmaker">Uporabni&#353;ko ime</span></td>
		<td><span class="jspmaker"><input type="text" name="userid" size="20" value="<%= userid %>"></span></td>
	</tr>
	<tr>
		<td><span class="jspmaker">Geslo</span></td>
		<td><span class="jspmaker"><input type="password" name="passwd" size="20"></span></td>
	</tr>
	<tr>
		<td><span class="jspmaker">Leto</span></td>
		<td><span class="jspmaker">
			<select style="width: 100px" name="leto">
				<option value="2014" <%= year.equals("2014") ? "selected=\"selected\"" : "" %>>2014</option>
				<option value="2015" <%= year.equals("2015") ? "selected=\"selected\"" : "" %>>2015</option>
			</select>
		</span></td>
	</tr>
	<tr>
		<td></td>
		<td><span class="jspmaker"><input type="submit" name="submit" value="Prijava v sistem"></span></td>
	</tr>
</table>
</form>
<br>
</body>
</html>
