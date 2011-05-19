<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
response.setDateHeader("Expires", 0); // date in the past
response.addHeader("Cache-Control", "no-store, no-cache, must-revalidate"); // HTTP/1.1 
response.addHeader("Cache-Control", "post-check=0, pre-check=0"); 
response.addHeader("Pragma", "no-cache"); // HTTP/1.0 
%>
<% Locale locale = Locale.getDefault();
response.setLocale(locale);%>
<% session.setMaxInactiveInterval(30*60); %>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("UTF-8");

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
Object x_koda = null;
Object x_papir = null;
Object x_papir2 = null;
Object x_pc_nizka = null;
Object x_koda_st = null;
Object x_str_dv = null;
Object x_skp0 = null;
Object x_skp1 = null;
Object x_skp2 = null;
Object x_skp3 = null;
Object x_skp4 = null;
Object x_skp5 = null;
Object x_skp6 = null;
Object x_skp7 = null;
Object x_skp8 = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `papir` WHERE `koda`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("papirlist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}
	if (rs.getString("papir") != null){
		x_papir = rs.getString("papir");
	}else{
		x_papir = "";
	}
	if (rs.getString("papir2") != null){
		x_papir2 = rs.getString("papir2");
	}else{
		x_papir2 = "";
	}
	x_pc_nizka = String.valueOf(rs.getLong("pc_nizka"));
	if (rs.getString("koda_st") != null){
		x_koda_st = rs.getString("koda_st");
	}else{
		x_koda_st = "";
	}
	x_str_dv = String.valueOf(rs.getLong("str_dv"));
	x_skp0 = String.valueOf(rs.getLong("skp0"));
	x_skp1 = String.valueOf(rs.getLong("skp1"));
	x_skp2 = String.valueOf(rs.getLong("skp2"));
	x_skp3 = String.valueOf(rs.getLong("skp3"));
	x_skp4 = String.valueOf(rs.getLong("skp4"));
	x_skp5 = String.valueOf(rs.getLong("skp5"));
	x_skp6 = String.valueOf(rs.getLong("skp6"));
	x_skp7 = String.valueOf(rs.getLong("skp7"));
	x_skp8 = String.valueOf(rs.getLong("skp8"));
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_koda") != null){
			x_koda = (String) request.getParameter("x_koda");
		}else{
			x_koda = "";
		}
		if (request.getParameter("x_papir") != null){
			x_papir = (String) request.getParameter("x_papir");
		}else{
			x_papir = "";
		}
		if (request.getParameter("x_papir2") != null){
			x_papir2 = (String) request.getParameter("x_papir2");
		}else{
			x_papir2 = "";
		}
		if (request.getParameter("x_pc_nizka") != null){
			x_pc_nizka = (String) request.getParameter("x_pc_nizka");
		}else{
			x_pc_nizka = "";
		}
		if (request.getParameter("x_koda_st") != null){
			x_koda_st = (String) request.getParameter("x_koda_st");
		}else{
			x_koda_st = "";
		}
		if (request.getParameter("x_str_dv") != null){
			x_str_dv = (String) request.getParameter("x_str_dv");
		}else{
			x_str_dv = "";
		}
		if (request.getParameter("x_skp0") != null){
			x_skp0 = (String) request.getParameter("x_skp0");
		}else{
			x_skp0 = "";
		}
		if (request.getParameter("x_skp1") != null){
			x_skp1 = (String) request.getParameter("x_skp1");
		}else{
			x_skp1 = "";
		}
		if (request.getParameter("x_skp2") != null){
			x_skp2 = (String) request.getParameter("x_skp2");
		}else{
			x_skp2 = "";
		}
		if (request.getParameter("x_skp3") != null){
			x_skp3 = (String) request.getParameter("x_skp3");
		}else{
			x_skp3 = "";
		}
		if (request.getParameter("x_skp4") != null){
			x_skp4 = (String) request.getParameter("x_skp4");
		}else{
			x_skp4 = "";
		}
		if (request.getParameter("x_skp5") != null){
			x_skp5 = (String) request.getParameter("x_skp5");
		}else{
			x_skp5 = "";
		}
		if (request.getParameter("x_skp6") != null){
			x_skp6 = (String) request.getParameter("x_skp6");
		}else{
			x_skp6 = "";
		}
		if (request.getParameter("x_skp7") != null){
			x_skp7 = (String) request.getParameter("x_skp7");
		}else{
			x_skp7 = "";
		}
		if (request.getParameter("x_skp8") != null){
			x_skp8 = (String) request.getParameter("x_skp8");
		}else{
			x_skp8 = "";
		}

		// Open record
		String strsql = "SELECT * FROM `papir` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field koda
		tmpfld = ((String) x_koda);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("koda");
		}else{
		String srchfld = "'" + tmpfld + "'";
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM `papir` WHERE `koda` = '" + srchfld +"'";
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				out.print("Duplicate key for koda, value = " + tmpfld + "<br>");
				out.print("Press [Previous Page] key to continue!");
				return;
			}
			rschk.close();
			rschk = null;
			rs.updateString("koda", tmpfld);
		}

		// Field papir
		tmpfld = ((String) x_papir);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("papir");
		}else{
			rs.updateString("papir", tmpfld);
		}

		// Field papir2
		tmpfld = ((String) x_papir2);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("papir2");
		}else{
			rs.updateString("papir2", tmpfld);
		}

		// Field pc_nizka
		tmpfld = ((String) x_pc_nizka).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("pc_nizka");
		} else {
			rs.updateInt("pc_nizka",Integer.parseInt(tmpfld));
		}

		// Field koda_st
		tmpfld = ((String) x_koda_st);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("koda_st");
		}else{
			rs.updateString("koda_st", tmpfld);
		}

		// Field str_dv
		tmpfld = ((String) x_str_dv).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("str_dv");
		} else {
			rs.updateInt("str_dv",Integer.parseInt(tmpfld));
		}

		// Field skp0
		tmpfld = ((String) x_skp0).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp0");
		} else {
			rs.updateInt("skp0",Integer.parseInt(tmpfld));
		}

		// Field skp1
		tmpfld = ((String) x_skp1).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp1");
		} else {
			rs.updateInt("skp1",Integer.parseInt(tmpfld));
		}

		// Field skp2
		tmpfld = ((String) x_skp2).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp2");
		} else {
			rs.updateInt("skp2",Integer.parseInt(tmpfld));
		}

		// Field skp3
		tmpfld = ((String) x_skp3).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp3");
		} else {
			rs.updateInt("skp3",Integer.parseInt(tmpfld));
		}

		// Field skp4
		tmpfld = ((String) x_skp4).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp4");
		} else {
			rs.updateInt("skp4",Integer.parseInt(tmpfld));
		}

		// Field skp5
		tmpfld = ((String) x_skp5).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp5");
		} else {
			rs.updateInt("skp5",Integer.parseInt(tmpfld));
		}

		// Field skp6
		tmpfld = ((String) x_skp6).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp6");
		} else {
			rs.updateInt("skp6",Integer.parseInt(tmpfld));
		}

		// Field skp7
		tmpfld = ((String) x_skp7).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp7");
		} else {
			rs.updateInt("skp7",Integer.parseInt(tmpfld));
		}

		// Field skp8
		tmpfld = ((String) x_skp8).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("skp8");
		} else {
			rs.updateInt("skp8",Integer.parseInt(tmpfld));
		}
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("papirlist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Add to TABLE: papir<br><br><a href="papirlist.jsp">Back to List</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_koda && !EW_hasValue(EW_this.x_koda, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_koda, "TEXT", "Invalid Field - koda"))
                return false; 
        }
if (EW_this.x_pc_nizka && !EW_checkinteger(EW_this.x_pc_nizka.value)) {
        if (!EW_onError(EW_this, EW_this.x_pc_nizka, "TEXT", "Incorrect integer - pc nizka"))
            return false; 
        }
if (EW_this.x_str_dv && !EW_checkinteger(EW_this.x_str_dv.value)) {
        if (!EW_onError(EW_this, EW_this.x_str_dv, "TEXT", "Incorrect integer - str dv"))
            return false; 
        }
if (EW_this.x_skp0 && !EW_checkinteger(EW_this.x_skp0.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp0, "TEXT", "Incorrect integer - skp 0"))
            return false; 
        }
if (EW_this.x_skp1 && !EW_checkinteger(EW_this.x_skp1.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp1, "TEXT", "Incorrect integer - skp 1"))
            return false; 
        }
if (EW_this.x_skp2 && !EW_checkinteger(EW_this.x_skp2.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp2, "TEXT", "Incorrect integer - skp 2"))
            return false; 
        }
if (EW_this.x_skp3 && !EW_checkinteger(EW_this.x_skp3.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp3, "TEXT", "Incorrect integer - skp 3"))
            return false; 
        }
if (EW_this.x_skp4 && !EW_checkinteger(EW_this.x_skp4.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp4, "TEXT", "Incorrect integer - skp 4"))
            return false; 
        }
if (EW_this.x_skp5 && !EW_checkinteger(EW_this.x_skp5.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp5, "TEXT", "Incorrect integer - skp 5"))
            return false; 
        }
if (EW_this.x_skp6 && !EW_checkinteger(EW_this.x_skp6.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp6, "TEXT", "Incorrect integer - skp 6"))
            return false; 
        }
if (EW_this.x_skp7 && !EW_checkinteger(EW_this.x_skp7.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp7, "TEXT", "Incorrect integer - skp 7"))
            return false; 
        }
if (EW_this.x_skp8 && !EW_checkinteger(EW_this.x_skp8.value)) {
        if (!EW_onError(EW_this, EW_this.x_skp8, "TEXT", "Incorrect integer - skp 8"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="papiradd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">koda</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_koda" size="30" maxlength="255" value="<%= HTMLEncode((String)x_koda) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">papir</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_papir" size="30" maxlength="255" value="<%= HTMLEncode((String)x_papir) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">papir 2</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_papir2" size="30" maxlength="255" value="<%= HTMLEncode((String)x_papir2) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">pc nizka</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_pc_nizka" size="30" value="<%= HTMLEncode((String)x_pc_nizka) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">koda st</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_koda_st" size="30" maxlength="255" value="<%= HTMLEncode((String)x_koda_st) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">str dv</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_str_dv" size="30" value="<%= HTMLEncode((String)x_str_dv) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 0</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp0" size="30" value="<%= HTMLEncode((String)x_skp0) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 1</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp1" size="30" value="<%= HTMLEncode((String)x_skp1) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 2</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp2" size="30" value="<%= HTMLEncode((String)x_skp2) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 3</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp3" size="30" value="<%= HTMLEncode((String)x_skp3) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 4</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp4" size="30" value="<%= HTMLEncode((String)x_skp4) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 5</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp5" size="30" value="<%= HTMLEncode((String)x_skp5) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 6</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp6" size="30" value="<%= HTMLEncode((String)x_skp6) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 7</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp7" size="30" value="<%= HTMLEncode((String)x_skp7) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">skp 8</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_skp8" size="30" value="<%= HTMLEncode((String)x_skp8) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="ADD">
</form>
<%@ include file="footer.jsp" %>
