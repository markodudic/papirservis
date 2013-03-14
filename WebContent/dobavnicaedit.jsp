<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"  %>
<%@ page contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
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

if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("dobavnicalist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("UTF-8");
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("dobavnicalist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_id = null;
Object x_st_dob = null;
Object x_pozicija = null;
Object x_datum = null;
Object x_sif_str = null;
Object x_stranka = null;
Object x_sif_kupca = null;
Object x_sif_sof = null;
Object x_sofer = null;
Object x_sif_kam = null;
Object x_kamion = null;
String[] x_koda = {"","","",""};
String[] x_ewc = {"","","",""};
Object x_skupina = null;
Object x_skupina_text = null;
Object x_opomba = null;
Object x_zacetek = null;
Object x_uporabnik = null;
Object x_cena = null;
Object x_stev_km_norm = null;
Object x_stev_ur_norm = null;
Object x_cena_km = null;
Object x_cena_ura = null;
Object x_c_km = null;
Object x_c_ura = null;


StringBuffer x_sif_strList = null;
StringBuffer x_sif_kupcaList = null;
StringBuffer[] x_koda_List = new StringBuffer[4];;
StringBuffer[] x_ewc_List = new StringBuffer[4];;
StringBuffer x_sif_sofList = null;
StringBuffer x_sif_kamList = null;
StringBuffer x_skupinaList = null;

StringBuffer sif_kupac = new StringBuffer();
StringBuffer sif_skupina = new StringBuffer();
StringBuffer sif_kupec_enota = new StringBuffer();
StringBuffer kupac = new StringBuffer();
StringBuffer skupina = new StringBuffer();
StringBuffer stranka_cena = new StringBuffer();
StringBuffer stranka_stev_km_norm = new StringBuffer();
StringBuffer stranka_stev_ur_norm = new StringBuffer();
StringBuffer sif_ewc = new StringBuffer();
StringBuffer cena_km = new StringBuffer();
StringBuffer cena_ura = new StringBuffer();
StringBuffer c_km = new StringBuffer();
StringBuffer c_ura = new StringBuffer();

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM " + session.getAttribute("letoTabela") + " dob WHERE st_dob=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			//conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("dobavnicalist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			x_id = String.valueOf(rs.getLong("id"));
			x_st_dob = String.valueOf(rs.getLong("st_dob"));
			x_pozicija = String.valueOf(rs.getLong("pozicija"));
			if (rs.getTimestamp("datum") != null){
				x_datum = rs.getTimestamp("datum");
			}else{
				x_datum = null;
			}
			x_sif_str = String.valueOf(rs.getLong("sif_str"));
			if (rs.getString("stranka") != null){
				x_stranka = rs.getString("stranka");
			}else{
				x_stranka = "";
			}
			if (rs.getString("sif_kupca") != null){
				x_sif_kupca = rs.getString("sif_kupca");
			}else{
				x_sif_kupca = "";
			}
			if (rs.getString("sif_sof") != null){
				x_sif_sof = rs.getString("sif_sof");
			}else{
				x_sif_sof = "";
			}
			if (rs.getString("sofer") != null){
				x_sofer = rs.getString("sofer");
			}else{
				x_sofer = "";
			}
			if (rs.getString("sif_kam") != null){
				x_sif_kam = rs.getString("sif_kam");
			}else{
				x_sif_kam = "";
			}
			if (rs.getString("kamion") != null){
				x_kamion = rs.getString("kamion");
			}else{
				x_kamion = "";
			}
			if (rs.getString("koda") != null){
				x_koda[0] = rs.getString("koda");
			}else{
				x_koda[0] = "";
			}
			if (rs.getString("ewc") != null){
				x_ewc[0] = rs.getString("ewc");
			}else{
				x_ewc[0] = "";
			}
			x_cena = String.valueOf(rs.getDouble("cena"));
			x_cena_km = String.valueOf(rs.getDouble("cena_km"));
			x_cena_ura = String.valueOf(rs.getDouble("cena_ura"));
			x_c_km = String.valueOf(rs.getDouble("c_km"));
			x_c_ura = String.valueOf(rs.getDouble("c_ura"));

			x_skupina = String.valueOf(rs.getLong("skupina"));
			if (rs.getString("skupina_text") != null){
				x_skupina_text = rs.getString("skupina_text");
			}else{
				x_skupina_text = "";
			}
			if (rs.getString("opomba") != null){
				x_opomba = rs.getString("opomba");
			}else{
				x_opomba = "";
			}
			if (rs.getTimestamp("zacetek") != null){
				x_zacetek = rs.getTimestamp("zacetek");
			}else{
				x_zacetek = null;
			}
			x_uporabnik = String.valueOf(rs.getLong("uporabnik"));

			x_stev_km_norm = String.valueOf(rs.getDouble("stev_km_norm"));
			x_stev_ur_norm = String.valueOf(rs.getDouble("stev_ur_norm"));

			int cnt=1;
			while (rs.next()) {
				// koda
				if (rs.getString("koda") != null){
					x_koda[cnt] = rs.getString("koda");
				}else{
					x_koda[cnt] = "";
				}
				if (rs.getString("ewc") != null){
					x_ewc[cnt] = rs.getString("ewc");
				}else{
					x_ewc[cnt] = "";
				}
				cnt++;
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_st_dob") != null){
			x_st_dob = (String) request.getParameter("x_st_dob");
		}else{
			x_st_dob = "";
		}
		if (request.getParameter("x_pozicija") != null){
			x_pozicija = (String) request.getParameter("x_pozicija");
		}else{
			x_pozicija = "";
		}
		if (request.getParameter("x_datum") != null){
			x_datum = (String) request.getParameter("x_datum");
		}else{
			x_datum = "";
		}
		if (request.getParameter("x_sif_str") != null){
			x_sif_str = request.getParameter("x_sif_str");
		}
		if (request.getParameter("x_stranka") != null){
			x_stranka = (String) request.getParameter("x_stranka");
		}else{
			x_stranka = "";
		}
		if (request.getParameter("x_sif_kupca") != null){
			x_sif_kupca = request.getParameter("x_sif_kupca");
		}
		if (request.getParameter("x_sif_sof") != null){
			x_sif_sof = request.getParameter("x_sif_sof");
		}
		if (request.getParameter("x_sofer") != null){
			x_sofer = (String) request.getParameter("x_sofer");
		}else{
			x_sofer = "";
		}
		if (request.getParameter("x_sif_kam") != null){
			x_sif_kam = (String) request.getParameter("x_sif_kam");
		}else{
			x_sif_kam = "";
		}
		if (request.getParameter("x_kamion") != null){
			x_kamion = (String) request.getParameter("x_kamion");
		}else{
			x_kamion = "";
		}
		if (request.getParameter("x_cena_km") != null){
			x_cena_km = (String) request.getParameter("x_cena_km");
		}else{
			x_cena_km = "";
		}
		if (request.getParameter("x_cena_ura") != null){
			x_cena_ura = (String) request.getParameter("x_cena_ura");
		}else{
			x_cena_ura = "";
		}
		if (request.getParameter("x_c_km") != null){
			x_c_km = (String) request.getParameter("x_c_km");
		}else{
			x_c_km = "";
		}
		if (request.getParameter("x_c_ura") != null){
			x_c_ura = (String) request.getParameter("x_c_ura");
		}else{
			x_c_ura = "";
		}
		if (request.getParameter("x_cena") != null){
			x_cena = (String) request.getParameter("x_cena");
		}else{
			x_cena = "";
		}
		int koda_cnt = 0;
		int ewc_cnt = 0;
		for (int i=0; i<x_koda.length; i++) {
			if ((request.getParameter("x_koda_"+(i+1)) != null) && (!request.getParameter("x_koda_"+(i+1)).equals(""))){
				x_koda[i] = request.getParameter("x_koda_"+(i+1));
				koda_cnt = (i+1);
			}
			if ((request.getParameter("x_ewc_"+(i+1)) != null) && (!request.getParameter("x_ewc_"+(i+1)).equals(""))){
				x_ewc[i] = request.getParameter("x_ewc_"+(i+1));
				ewc_cnt = (i+1);
			}
		}
		if (request.getParameter("x_skupina") != null){
			x_skupina = request.getParameter("x_skupina");
		}
		if (request.getParameter("x_skupina_text") != null){
			x_skupina_text = (String) request.getParameter("x_skupina_text");
		}else{
			x_skupina_text = "";
		}
		if (request.getParameter("x_opomba") != null){
			x_opomba = (String) request.getParameter("x_opomba");
		}else{
			x_opomba = "";
		}
		if (request.getParameter("x_stev_km_norm") != null){
			x_stev_km_norm = (String) request.getParameter("x_stev_km_norm");
		}else{
			x_stev_km_norm = "";
		}
		if (request.getParameter("x_stev_ur_norm") != null){
			x_stev_ur_norm = (String) request.getParameter("x_stev_ur_norm");
		}else{
			x_stev_ur_norm = "";
		}

		// select count records
		int rec_cnt = 0;
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql1 = "SELECT count(*) FROM " + session.getAttribute("letoTabela") + " dob WHERE st_dob=" + tkey;
		rs = stmt.executeQuery(strsql1);
		if (rs.next()) {
			rec_cnt = rs.getInt(1);
			
			rs.close();
			rs = null;
		}

		//pobrisem vse odvecne pozicije
		if (rec_cnt > koda_cnt){ // Delete
			String strsql = "DELETE FROM " + session.getAttribute("letoTabela") + " WHERE st_dob=" + tkey + " AND pozicija > 1 AND pozicija > " + koda_cnt ;
			stmt.executeUpdate(strsql);
		}	
		
		//ce je nova pozicija je insertam
		if (rec_cnt < koda_cnt){ // Add
			//vpišem tolk rekordov kolk imam kod
			for (int i=rec_cnt; i<koda_cnt; i++) {
				String strsql = "insert into " + session.getAttribute("letoTabela") + " (st_dob, pozicija, sif_sof, sif_kam, cena_km, cena_ura, c_km, c_ura, sif_str, sif_kupca, skupina, cena, opomba, uporabnik, datum, koda, ewc, stev_km_norm, stev_ur_norm) values (";
				
				// Field st_dob
				tmpfld = ((String) x_st_dob).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = "0";}
				if (tmpfld == null) {
					//rs.updateNull("sif_str");
				} else {
					strsql += tmpfld + ", " + (i+1) + ", ";
				}
		
		
				// Field sif_sof
				tmpfld = ((String) x_sif_sof);
				if (tmpfld == null || tmpfld.trim().length() == 0) {
					tmpfld = null;
				}
				if (tmpfld == null) {
					//rs.updateNull("sif_sof");
				}else{
					strsql += tmpfld + ",";
				}
		
				// Field sif_kam
				tmpfld = ((String) x_sif_kam).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				if (tmpfld == null) {
					//rs.updateNull("sif_str");
				} else {
					strsql += tmpfld + ",";
				}

				// Field cena_km
				tmpfld = ((String) x_cena_km).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				strsql += tmpfld + ", ";

				// Field cena_ura
				tmpfld = ((String) x_cena_ura).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				strsql += tmpfld + ", ";

				// Field c_km
				tmpfld = ((String) x_c_km).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				strsql += tmpfld + ", ";

				// Field c_ura
				tmpfld = ((String) x_c_ura).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				strsql += tmpfld + ", ";

				// Field sif_str
				tmpfld = ((String) x_sif_str).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				if (tmpfld == null) {
					//rs.updateNull("sif_str");
				} else {
					strsql += tmpfld + ",";
				}
		
				// Field sif_kupca
				tmpfld = ((String) x_sif_kupca).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				if (tmpfld == null) {
					//rs.updateNull("sif_str");
				} else {
					strsql += tmpfld + ",";
				}
		
				// Field skupina
				tmpfld = ((String) x_skupina).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				if (tmpfld == null) {
					//rs.updateNull("sif_str");
				} else {
					strsql += tmpfld + ",";
				}
		
		
				// Field skupina
				tmpfld = ((String) x_cena).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				strsql += tmpfld + ",";
				
				// Field opomba
				tmpfld = ((String) x_opomba);
				if (tmpfld == null || tmpfld.trim().length() == 0) {
					tmpfld = "";
				}
				strsql += "'" + tmpfld + "'," + (String) session.getAttribute("papirservis1_status_UserID") + ", '" + (EW_UnFormatDateTime((String) x_datum ,"EURODATE", locale)).toString() + "',";
		
		
				// Field koda
				tmpfld = ((String) x_koda[i]);
				if (tmpfld == null || tmpfld.trim().length() == 0) {
					tmpfld = null;
				}
				if(tmpfld != null)
					strsql += "'" + tmpfld + "', ";
				else
					strsql += tmpfld + ", ";
		
				// Field ewc
				tmpfld = ((String) x_ewc[i]);
				if (tmpfld == null || tmpfld.trim().length() == 0) {
					tmpfld = null;
				}
				if(tmpfld != null)
					strsql += "'" + tmpfld + "', ";
				else
					strsql += tmpfld + ", ";

				// Field stev_km_norm
				tmpfld = ((String) x_stev_km_norm).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				strsql += tmpfld + ", ";
		
				// Field stev_ur_norm
				tmpfld = ((String) x_stev_ur_norm).trim();
				if (!IsNumeric(tmpfld)) { tmpfld = null;}
				strsql += tmpfld + ") ";
		
				Statement stmt1 = conn.createStatement();
				stmt1.executeUpdate(strsql);
				stmt1.close();
				stmt1 = null;
			}
		
		}
		
		// Spremenim vse obstojece ali vsaj resetiram prvo pozicijo
		int koda_cnt_vse = 1;
		if (koda_cnt>0) koda_cnt_vse = koda_cnt;
		for (int i=0; i<koda_cnt_vse; i++) {
			//String strsql = "SELECT * FROM " + session.getAttribute("letoTabela") + " dob WHERE st_dob=" + tkey;
			String strsql = "SELECT * FROM " + session.getAttribute("letoTabela") + " dob WHERE st_dob=" + tkey + " AND pozicija = " + (i+1);
			rs = stmt.executeQuery(strsql);
			if (!rs.next()) {
				rs.close();
				rs = null;
				stmt.close();
				stmt = null;
				conn = null;
				response.sendRedirect("dobavnicalist.jsp");
				response.flushBuffer();
				return;
			}
	
			// Field datum
			if (IsDate((String) x_datum,"EURODATE", locale)) {
				rs.updateTimestamp("datum", EW_UnFormatDateTime((String)x_datum,"EURODATE", locale));
			}else{
				rs.updateNull("datum");
			}
	
			// Field sif_str
			tmpfld = ((String) x_sif_str).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("sif_str");
			} else {
				rs.updateInt("sif_str",Integer.parseInt(tmpfld));
			}
	
			// Field sif_kupca
			tmpfld = ((String) x_sif_kupca);
			if (tmpfld == null || tmpfld.trim().length() == 0) {
				tmpfld = null;
			}
			if (tmpfld == null) {
				rs.updateNull("sif_kupca");
			}else{
				rs.updateString("sif_kupca", tmpfld);
			}
	
			// Field sif_sof
			tmpfld = ((String) x_sif_sof);
			if (tmpfld == null || tmpfld.trim().length() == 0) {
				tmpfld = null;
			}
			if (tmpfld == null) {
				rs.updateNull("sif_sof");
			}else{
				rs.updateString("sif_sof", tmpfld);
			}
	
			// Field sif_kam
			tmpfld = ((String) x_sif_kam);
			if (tmpfld == null || tmpfld.trim().length() == 0) {
				tmpfld = null;
			}
			if (tmpfld == null) {
				rs.updateNull("sif_kam");
			}else{
				rs.updateString("sif_kam", tmpfld);
			}

			// Field cena_km
			tmpfld = ((String) x_cena_km).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("cena_km");
			} else {
				rs.updateDouble("cena_km",Double.parseDouble(tmpfld));
			}
	
			// Field cena_ura
			tmpfld = ((String) x_cena_ura).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("cena_ura");
			} else {
				rs.updateDouble("cena_ura",Double.parseDouble(tmpfld));
			}
	
			// Field c_km
			tmpfld = ((String) x_c_km).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("c_km");
			} else {
				rs.updateDouble("c_km",Double.parseDouble(tmpfld));
			}
	
			// Field c_ura
			tmpfld = ((String) x_c_ura).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("c_ura");
			} else {
				rs.updateDouble("c_ura",Double.parseDouble(tmpfld));
			}
	

			if (tmpfld == null) {
				rs.updateNull("stev_ur");
			} else {
				rs.updateDouble("stev_ur",Double.parseDouble(tmpfld));
			}

			// Field cena
			tmpfld = ((String) x_cena).trim();
			if (!IsNumeric(tmpfld) || i>0) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("cena");
			} else {
				rs.updateDouble("cena",Double.parseDouble(tmpfld));
			}
	
			// Field skupina
			tmpfld = ((String) x_skupina).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("skupina");
			} else {
				rs.updateInt("skupina",Integer.parseInt(tmpfld));
			}
	
			// Field opomba
			tmpfld = ((String) x_opomba);
			if (tmpfld == null || tmpfld.trim().length() == 0) {
				tmpfld = null;
			}
			if (tmpfld == null) {
				rs.updateNull("opomba");
			}else{
				rs.updateString("opomba", tmpfld);
			}
			
			rs.updateInt("uporabnik",Integer.parseInt((String) session.getAttribute("papirservis1_status_UserID")));
		
			// Field koda
			tmpfld = ((String) x_koda[i]);
			if (tmpfld == null || tmpfld.trim().length() == 0) {
				tmpfld = null;
			}
			if (tmpfld == null) {
				rs.updateNull("koda");
			}else{
				rs.updateString("koda", tmpfld);
			}

			tmpfld = ((String) x_ewc[i]);
			if (tmpfld == null || tmpfld.trim().length() == 0) {
				tmpfld = null;
			}
			if (tmpfld == null) {
				rs.updateNull("ewc");
			}else{
				rs.updateString("ewc", tmpfld);
			}


			// Field stev_km_norm
			tmpfld = ((String) x_stev_km_norm).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("stev_km_norm");
			} else {
				rs.updateDouble("stev_km_norm",Double.parseDouble(tmpfld));
			}

			// Field stev_ur_norm
			tmpfld = ((String) x_stev_ur_norm).trim();
			if (!IsNumeric(tmpfld)) { tmpfld = null;}
			if (tmpfld == null) {
				rs.updateNull("stev_ur_norm");
			} else {
				rs.updateDouble("stev_ur_norm",Double.parseDouble(tmpfld));
			}
			
			rs.updateRow();
			rs.close();
			rs = null;
		}
		
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("dobavnicalist.jsp");
		response.flushBuffer();
		return;
	}


if(request.getParameter("prikaz_stranke")!= null){
	session.setAttribute("dobavnica_stranke_show",  request.getParameter("prikaz_stranke"));
}

if(request.getParameter("prikaz_kupca")!= null){
	session.setAttribute("dobavnica_kupci_show",  request.getParameter("prikaz_kupca"));
}

if(request.getParameter("prikaz_kamion")!= null){
 	session.setAttribute("dobavnica_kamion_show", request.getParameter("prikaz_kamion"));
}

if(request.getParameter("prikaz_sofer")!= null){
 	session.setAttribute("dobavnica_sofer_show", request.getParameter("prikaz_sofer"));
}
for (int i=0; i<x_koda.length; i++) {
	if(request.getParameter("prikaz_material_"+(i+1))!= null){
	 	session.setAttribute("dob_prikaz_material_"+(i+1), request.getParameter("prikaz_material_"+(i+1)));
	}
	if(request.getParameter("prikaz_okolje_"+(i+1))!= null){
	 	session.setAttribute("dob_prikaz_okolje_"+(i+1), request.getParameter("prikaz_okolje_"+(i+1)));
	}
}

String cbo_x_sif_kupca_js = "";
x_sif_kupcaList = new StringBuffer("<select name=\"x_sif_kupca_ll\"><option value=\"\">Izberi</option>");
//String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci`  where blokada = 0 and potnik = " + session.getAttribute("papirservis1_status_UserID")  + " ORDER BY `naziv` ASC";
String sqlwrk_x_sif_kupca = "SELECT `sif_kupca`, `naziv`, `naslov` FROM `kupci`  where blokada = 0 ORDER BY `naziv` ASC";

Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
	int rowcntwrk_x_sif_kupca = 0;
	while (rswrk_x_sif_kupca.next()) {
		//x_sif_kupcaList += "<option value=\"" + HTMLEncode(rswrk_x_sif_kupca.getString("naziv")) + "\"";
		String tmpSifra = rswrk_x_sif_kupca.getString("sif_kupca");
		x_sif_kupcaList.append("<option value=\"").append(tmpSifra).append("\"");
		if (tmpSifra.equals(x_sif_kupca)) {
			x_sif_kupcaList.append(" selected");
		}
		String tmpValue_x_sif_kupca = "";
		String tmpNaziv = null;
		if (!((String)session.getAttribute("dob_kupci_show")).equals("vse"))
			tmpNaziv = rswrk_x_sif_kupca.getString((String)session.getAttribute("dob_kupci_show"));
		else{
			tmpNaziv = rswrk_x_sif_kupca.getString("sif_kupca") + " " + rswrk_x_sif_kupca.getString("naziv") + " " + rswrk_x_sif_kupca.getString("naslov");
		}
		
		kupac.append("kupac[").append(rswrk_x_sif_kupca.getString("sif_kupca")).append("]=").append(String.valueOf(rowcntwrk_x_sif_kupca)).append(";");




		if (tmpNaziv!= null) tmpValue_x_sif_kupca = tmpNaziv;
		x_sif_kupcaList.append(">").append(tmpValue_x_sif_kupca).append("</option>");
		rowcntwrk_x_sif_kupca++;
	}
rswrk_x_sif_kupca.close();
rswrk_x_sif_kupca = null;
stmtwrk_x_sif_kupca.close();
stmtwrk_x_sif_kupca = null;
x_sif_kupcaList.append("</select>");


String stranke = (String) session.getAttribute("vse");
String strankeQueryFilter = "";
if(stranke.equals("0")){
	strankeQueryFilter = " k.potnik = " + session.getAttribute("papirservis1_status_UserID");
}

String enote = (String) session.getAttribute("enote");
String enoteQueryFilter = "";
if(enote.equals("0")){
	enoteQueryFilter = "k.sif_enote = " + session.getAttribute("papirservis1_status_Enota");
}

String subQuery ="";

if(strankeQueryFilter.length() > 0 || enoteQueryFilter.length() > 0){
	subQuery += " and " + strankeQueryFilter;
	if(strankeQueryFilter.length() > 0 && enoteQueryFilter.length() > 0){
		subQuery += " AND " + enoteQueryFilter;
	}else{
		subQuery += enoteQueryFilter;
	}
}


String cbo_x_sif_str_js = "";
String fiftyBlanks ="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
x_sif_strList = new StringBuffer("<select onchange = \"updateDropDowns(this);\" name=\"x_sif_str\" STYLE=\"font-family : monospace;  font-size : 12pt\"><option value=\"\">Izberi</option>");
//String sqlwrk_x_sif_str = "SELECT `sif_str`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina FROM `stranke` s, `osnovna` o, `kupci` k, `skup` sk where s.sif_os = o.sif_os and k.sif_kupca = s.sif_kupca and k.skupina = sk.skupina  and k.blokada = 0 " + subQuery   + " ORDER BY `" + session.getAttribute("dobavnica_stranke_show") + "` ASC";
String sqlwrk_x_sif_str = "SELECT `sif_str`, `cena`, s.`naziv`, s.`naslov`, `osnovna`, `kol_os`, s.sif_kupca, k.skupina, s.stev_km_norm, s.stev_ur_norm, enote.naziv as enota_naziv  "+
	"FROM (SELECT stranke.* "+
	"	FROM stranke, (SELECT sif_str, max(zacetek) datum FROM stranke group by sif_str ) zadnji "+
	"	WHERE stranke.sif_str = zadnji.sif_str and "+
	"      	stranke.zacetek = zadnji.datum) s,  "+
	"	(SELECT osnovna.* "+
	"		FROM osnovna, (SELECT sif_os, max(zacetek) datum FROM osnovna group by sif_os ) zadnji1 "+
	"		WHERE osnovna.sif_os = zadnji1.sif_os and "+
	"		      osnovna.zacetek = zadnji1.datum) o, "+
	"	`kupci` k, `skup` sk, enote  "+
	"where s.sif_os = o.sif_os and k.sif_kupca = s.sif_kupca and k.sif_enote = enote.sif_enote and "+ 
	"k.skupina = sk.skupina  and k.blokada = 0 " + subQuery  + 
	" ORDER BY `" + session.getAttribute("dobavnica_stranke_show") + "` ASC";

Statement stmtwrk_x_sif_str = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_str = stmtwrk_x_sif_str.executeQuery(sqlwrk_x_sif_str);
	int rowcntwrk_x_sif_str = 0;
	while (rswrk_x_sif_str.next()) {
		//x_sif_strList += "<option value=\"" + HTMLEncode(rswrk_x_sif_str.getString("sif_str")) + "\"";
		String tmpSif = rswrk_x_sif_str.getString("sif_str");
		x_sif_strList.append("<option value=\"").append(tmpSif).append("\"");
		if (tmpSif.equals(x_sif_str)) {
			x_sif_strList.append(" selected");
		}
		
		sif_kupec_enota.append("sif_kupec_enota[").append(tmpSif).append("]='").append(rswrk_x_sif_str.getString("enota_naziv")).append("';");
		sif_kupac.append("sif_kupac[").append(tmpSif).append("]=").append(rswrk_x_sif_str.getString("sif_kupca")).append(";");
		sif_skupina.append("sif_skupina[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_str.getLong("skupina"))).append(";");
		stranka_cena.append("stranka_cena[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_str.getDouble("cena"))).append(";");
		stranka_stev_km_norm.append("stranka_stev_km_norm[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_str.getDouble("stev_km_norm"))).append(";");
		stranka_stev_ur_norm.append("stranka_stev_ur_norm[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_str.getDouble("stev_ur_norm"))).append(";");


		String tmpValue_x_sif_str = "";
		String find = (String)session.getAttribute("dob_stranke_show");
		//String tmpNaziv = tmpNaziv = rswrk_x_sif_str.getString("naziv") + ", " + rswrk_x_sif_str.getString("sif_str") + ", " + rswrk_x_sif_str.getString("naslov") + ", " + rswrk_x_sif_str.getString("osnovna")  + ", " + rswrk_x_sif_str.getString("kol_os");

			String tmpNaziv = rswrk_x_sif_str.getString("naziv").trim() + fiftyBlanks.substring(0, rswrk_x_sif_str.getString("naziv").trim().length() > 30 ? 0 : (30 - rswrk_x_sif_str.getString("naziv").trim().length())*6)
			+ rswrk_x_sif_str.getString("sif_str").trim() + fiftyBlanks.substring(0, rswrk_x_sif_str.getString("sif_str").trim().length() > 6 ? 0 : (6 - rswrk_x_sif_str.getString("sif_str").trim().length())*6)
			+ (rswrk_x_sif_str.getString("naslov") == null ? "" : rswrk_x_sif_str.getString("naslov").trim())
			+ "&nbsp;&nbsp;" + (rswrk_x_sif_str.getString("osnovna") == null ? "" : rswrk_x_sif_str.getString("osnovna").trim()) + "&nbsp;&nbsp;"
			+ (rswrk_x_sif_str.getString("kol_os") == null ? "" : rswrk_x_sif_str.getString("kol_os").trim());

		if (tmpNaziv!= null) tmpValue_x_sif_str = tmpNaziv;
		x_sif_strList.append(">").append(tmpValue_x_sif_str).append("</option>");
		rowcntwrk_x_sif_str++;
	}
rswrk_x_sif_str.close();
rswrk_x_sif_str = null;
stmtwrk_x_sif_str.close();
stmtwrk_x_sif_str = null;
x_sif_strList.append("</select>");

String cbo_x_skupina_js = "";
x_skupinaList = new StringBuffer("<select disabled name=\"x_skupina_ll\"><option value=\"\">Izberi</option>");

String sqlwrk_x_skupina = "SELECT `skupina`, `tekst` FROM `skup`";
Statement stmtwrk_x_skupina = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_skupina = stmtwrk_x_skupina.executeQuery(sqlwrk_x_skupina);
	int rowcntwrk_x_skupina = 0;
	while (rswrk_x_skupina.next()) {
		x_skupinaList.append("<option value=\"").append(HTMLEncode(rswrk_x_skupina.getString("skupina"))).append("\"");
		if (rswrk_x_skupina.getString("skupina").equals(x_skupina)) {
			x_skupinaList.append(" selected");
		}


		skupina.append("skupina[").append(rswrk_x_skupina.getString("skupina")).append("]=").append(String.valueOf(rowcntwrk_x_skupina)).append(";");

		String tmpValue_x_skupina = "";
		if (rswrk_x_skupina.getString("tekst")!= null) tmpValue_x_skupina = rswrk_x_skupina.getString("tekst");
		x_skupinaList.append(">").append(tmpValue_x_skupina).append("</option>");
		rowcntwrk_x_skupina++;
	}
rswrk_x_skupina.close();
rswrk_x_skupina = null;
stmtwrk_x_skupina.close();
stmtwrk_x_skupina = null;
x_skupinaList.append("</select>");

String cbo_x_sif_sof_js = "";
x_sif_sofList = new StringBuffer("<select name=\"x_sif_sof\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_sof = "SELECT `sif_sof`, `sofer` FROM `sofer` order by " + session.getAttribute("dobavnica_sofer_show") + " asc";
Statement stmtwrk_x_sif_sof = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_sof = stmtwrk_x_sif_sof.executeQuery(sqlwrk_x_sif_sof);
	int rowcntwrk_x_sif_sof = 0;
	while (rswrk_x_sif_sof.next()) {
		x_sif_sofList.append("<option value=\"").append(rswrk_x_sif_sof.getString("sif_sof")).append("\"");
		if (rswrk_x_sif_sof.getString("sif_sof").equals(x_sif_sof)) {
			x_sif_sofList.append(" selected");
		}
		String tmpValue_x_sif_sof = "";
		String tmpSofer = rswrk_x_sif_sof.getString((String)session.getAttribute("dobavnica_sofer_show"));
		
		if (tmpSofer!= null) tmpValue_x_sif_sof = tmpSofer;
		x_sif_sofList.append(">").append(tmpValue_x_sif_sof).append("</option>");
		rowcntwrk_x_sif_sof++;
	}
rswrk_x_sif_sof.close();
rswrk_x_sif_sof = null;
stmtwrk_x_sif_sof.close();
stmtwrk_x_sif_sof = null;
x_sif_sofList.append("</select>");

x_sif_kamList = new StringBuffer("<select onchange = \"updateSubfileds(this);\" name=\"x_sif_kam\"><option value=\"\">Izberi</option>");
String sqlwrk_x_sif_kam = "SELECT `kamion`.`sif_kam`, `kamion`, `cena_km`, `cena_ura`, `cena_kg`, `c_km`, `c_ura` "+
	"FROM `kamion`, (select sif_kam, max(zacetek) as zacetek from kamion group by sif_kam) as k "+
	"where kamion.sif_kam = k.sif_kam and kamion.zacetek = k.zacetek "+
//	"order by `kamion`.kamion asc";
	"order by " + session.getAttribute("dob_kamion_show") + " asc";

Statement stmtwrk_x_sif_kam = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_kam = stmtwrk_x_sif_kam.executeQuery(sqlwrk_x_sif_kam);
	int rowcntwrk_x_sif_kam = 0;
	while (rswrk_x_sif_kam.next()) {
		String tmpSif = rswrk_x_sif_kam.getString("sif_kam");
		x_sif_kamList.append("<option value=\"").append(tmpSif).append("\"");
		if (tmpSif.equals(x_sif_kam)) {
			x_sif_kamList.append(" selected");
		}
		String tmpKamion = rswrk_x_sif_kam.getString((String)session.getAttribute("dob_kamion_show"));
		String tmpValue_x_sif_kam = "";
		if (tmpKamion!= null) tmpValue_x_sif_kam = tmpKamion;
		x_sif_kamList.append(">").append(tmpValue_x_sif_kam).append("</option>");
		
		cena_km.append("cena_km[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("cena_km"))).append(";");
		cena_ura.append("cena_ura[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("cena_ura"))).append(";");
		c_km.append("c_km[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("c_km"))).append(";");
		c_ura.append("c_ura[").append(tmpSif).append("]=").append(String.valueOf(rswrk_x_sif_kam.getDouble("c_ura"))).append(";");

		rowcntwrk_x_sif_kam++;
	}
rswrk_x_sif_kam.close();
rswrk_x_sif_kam = null;
stmtwrk_x_sif_kam.close();
stmtwrk_x_sif_kam = null;
x_sif_kamList.append("</select>");


for (int i=0; i<x_koda.length; i++) {
	String sqlwrk_x_koda = "SELECT `materiali`.`koda`, `material`  , `sit_sort`, `sit_zaup`, `sit_smet`, material_okolje.okolje_koda " +
			"FROM `materiali` " +
			"		left join material_okolje on (materiali.koda = material_okolje.material_koda), " +
			"		(select koda, max(zacetek) as zacetek from materiali group by koda) as m " +
			"WHERE materiali.koda = m.koda and materiali.zacetek = m.zacetek "+
			"ORDER BY `" + session.getAttribute("dob_prikaz_material_"+(i+1)) + "` ASC";
	
	StringBuffer x_koda_List_ALL = new StringBuffer();
	
	Statement stmtwrk_x_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk_x_koda = stmtwrk_x_koda.executeQuery(sqlwrk_x_koda);
		int rowcntwrk_x_koda = 0;
		while (rswrk_x_koda.next()) {
			x_koda_List_ALL.append("<option value=\"").append(rswrk_x_koda.getString("koda")).append("\"");
			if (rswrk_x_koda.getString("koda").equals(x_koda[i])) {
				x_koda_List_ALL.append(" selected");
			}
			String tmpValue_x_koda = "";
			if (rswrk_x_koda.getString("material")!= null) tmpValue_x_koda = rswrk_x_koda.getString("material");
			x_koda_List_ALL.append(">").append(rswrk_x_koda.getString("koda") + "   ").append(tmpValue_x_koda).append("</option>");
	
			sif_ewc.append("sif_ewc[").append(rowcntwrk_x_koda).append("]='").append(String.valueOf(rswrk_x_koda.getString("okolje_koda"))).append("';");

			rowcntwrk_x_koda++;
		}
	rswrk_x_koda.close();
	rswrk_x_koda = null;
	stmtwrk_x_koda.close();
	stmtwrk_x_koda = null;
	x_koda_List_ALL.append("</select>");
	
	String s = "<select name=\"x_koda_"+(i+1)+"\" onchange = \"updateKoda(this);\"><option value=\"\">Izberi</option>";
	x_koda_List[i] = new StringBuffer(s);
	x_koda_List[i].append(x_koda_List_ALL);
}


for (int i=0; i<x_ewc.length; i++) {
	String sqlwrk_x_ewc = "SELECT `koda`, `material` " +
			"FROM `okolje` "+
			"ORDER BY `" + session.getAttribute("dob_prikaz_okolje_"+(i+1)) + "` ASC";

	StringBuffer x_ewc_List_ALL = new StringBuffer();

	Statement stmtwrk_x_ewc = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk_x_ewc = stmtwrk_x_ewc.executeQuery(sqlwrk_x_ewc);
		int rowcntwrk_x_ewc = 0;
		while (rswrk_x_ewc.next()) {
			x_ewc_List_ALL.append("<option value=\"").append(rswrk_x_ewc.getString("koda")).append("\"");
			if (rswrk_x_ewc.getString("koda").equals(x_ewc[i])) {
				x_ewc_List_ALL.append(" selected");
			}
			String tmpValue_x_ewc = "";
			if (rswrk_x_ewc.getString("material")!= null) tmpValue_x_ewc = rswrk_x_ewc.getString("material");
			x_ewc_List_ALL.append(">").append(rswrk_x_ewc.getString("koda") + "   ").append(tmpValue_x_ewc).append("</option>");
	
			rowcntwrk_x_ewc++;
		}
	rswrk_x_ewc.close();
	rswrk_x_ewc = null;
	stmtwrk_x_ewc.close();
	stmtwrk_x_ewc = null;
	x_ewc_List_ALL.append("</select>");
	
	String s = "<select name=\"x_ewc_"+(i+1)+"\" ><option value=\"\">Izberi</option>";
	x_ewc_List[i] = new StringBuffer(s);
	x_ewc_List[i].append(x_ewc_List_ALL);
}


}catch (com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException ex){
//Constraint violation se javi �e se n� ne spremeni
		response.sendRedirect("dobavnicalist.jsp");
		response.flushBuffer();
}catch (SQLException ex){
		out.println(ex.toString());
}

%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Spremeni : Delovni nalog<br><br><a href="dobavnicalist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">



function disableSome(EW_this){
}



function  EW_checkMyForm(EW_this) {
if (EW_this.x_st_dob && !EW_hasValue(EW_this.x_st_dob, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "Napačna številka - st dob"))
                return false; 
        }
if (EW_this.x_st_dob && !EW_checkinteger(EW_this.x_st_dob.value)) {
        if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "Napačna številka - st dob"))
            return false; 
        }
if (EW_this.x_pozicija && !EW_hasValue(EW_this.x_pozicija, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "Napačna številka - pozicija"))
                return false; 
        }
if (EW_this.x_pozicija && !EW_checkinteger(EW_this.x_pozicija.value)) {
        if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "Napačna številka - pozicija"))
            return false; 
        }
if(EW_this.x_datum.value.length == 0 ){
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum"))
            return false; 
}

if (EW_this.x_datum && !EW_checkeurodate(EW_this.x_datum.value)) {
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum"))
            return false; 
        }
if (EW_this.x_sif_str && !EW_hasValue(EW_this.x_sif_str, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_str, "SELECT", "Napačna številka - sif str"))
                return false; 
        }
if (EW_this.x_sif_kupca && !EW_hasValue(EW_this.x_sif_kupca, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_sif_kupca, "SELECT", "Napačan vnos - sif kupca"))
                return false; 
        }
if (EW_this.x_skupina && !EW_hasValue(EW_this.x_skupina, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_skupina, "SELECT", "Napačna številka - skupina"))
                return false; 
        }
return true;
}


var sif_kupac = new Array();
<%=sif_kupac%>
var sif_skupina = new Array();
<%=sif_skupina%>
var sif_kupec_enota = new Array();
<%=sif_kupec_enota%>
var kupac = new Array();
<%=kupac%>
var skupina = new Array();
<%=skupina%>
var stranka_cena = new Array();
<%=stranka_cena%>
var stranka_stev_ur_norm = new Array();
<%=stranka_stev_ur_norm%>
var stranka_stev_km_norm = new Array();
<%=stranka_stev_km_norm%>
var sif_ewc = new Array();
<%=sif_ewc%>
var cena_km = new Array();
<%=cena_km%>
var cena_ura = new Array();
<%=cena_ura%>
var c_km = new Array();
<%=c_km%>
var c_ura = new Array();
<%=c_ura%>

function updateSubfileds(EW_this){
	document.dobedit.x_c_km.value = c_km[document.dobedit.x_sif_kam.value];
	document.dobedit.x_c_ura.value = c_ura[document.dobedit.x_sif_kam.value];
	document.dobedit.x_cena_km.value = cena_km[document.dobedit.x_sif_kam.value];
	document.dobedit.x_cena_ura.value = cena_ura[document.dobedit.x_sif_kam.value];
}

function updateKoda(EW_this){
	<%for (int i=0; i<x_ewc.length; i++) {%>
		if (sif_ewc[document.dobedit.x_koda_<%=i+1%>.selectedIndex-1] != "null")
			document.dobedit.x_ewc_<%=i+1%>.value = sif_ewc[document.dobedit.x_koda_<%=i+1%>.selectedIndex-1];
		else
			document.dobedit.x_ewc_<%=i+1%>.selectedIndex = 0;
	<%}%>
}

function updateDropDowns(EW_this){
	document.dobedit.x_sif_kupca_ll.selectedIndex = 1 + kupac[sif_kupac[document.dobedit.x_sif_str.value]];
	document.dobedit.x_sif_kupca.value = sif_kupac[document.dobedit.x_sif_str.value];
	document.dobedit.x_skupina_ll.selectedIndex = 1 + skupina[sif_skupina[document.dobedit.x_sif_str.value]];
	document.dobedit.x_skupina.value = sif_skupina[document.dobedit.x_sif_str.value];
	
	document.dobedit.kupec_enota.value = sif_kupec_enota[document.dobedit.x_sif_str.value];

	document.dobedit.x_cena.value = stranka_cena[document.dobedit.x_sif_str.value];

	document.dobedit.x_stev_km_norm.value = stranka_stev_km_norm[document.dobedit.x_sif_str.value];
	document.dobedit.x_stev_ur_norm.value = stranka_stev_ur_norm[document.dobedit.x_sif_str.value];
}


function disableSome(){
	document.dobedit.x_sif_kupca_ll.disabled=true;
	document.dobedit.x_skupina_ll.disabled=true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="dobedit" action="dobavnicaedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">

<input type="hidden" name="x_st_dob" size="30" value="<%= HTMLEncode((String)x_st_dob) %>">
<input type="hidden" name="x_pozicija" size="30" value="<%= HTMLEncode((String)x_pozicija) %>">
<input type="hidden" name="x_sif_kupca" size="30" value="<%= HTMLEncode((String)x_sif_kupca) %>">
<input type="hidden" name="x_skupina" size="30" value="<%= HTMLEncode((String)x_skupina) %>">
<input type="hidden" name="x_cena" size="30" value="<%= HTMLEncode((String)x_cena) %>">
<input type="hidden" name="x_cena_km" size="30" value="<%= HTMLEncode((String)x_cena_km) %>">
<input type="hidden" name="x_cena_ura" size="30" value="<%= HTMLEncode((String)x_cena_ura) %>">
<input type="hidden" name="x_c_km" size="30" value="<%= HTMLEncode((String)x_c_km) %>">
<input type="hidden" name="x_c_ura" size="30" value="<%= HTMLEncode((String)x_c_ura) %>">
<input type="hidden" name="x_stev_km_norm" size="30" value="<%= HTMLEncode((String)x_stev_km_norm) %>">
<input type="hidden" name="x_stev_ur_norm" size="30" value="<%= HTMLEncode((String)x_stev_ur_norm) %>">

<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Številka dobavnice&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_st_dob" size="30" value="<%= HTMLEncode((String)x_st_dob) %>" disabled>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_datum" value="<%= EW_FormatDateTime(x_datum,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Izberi datum" onClick="popUpCalendar(this, this.form.x_datum,'dd.mm.yyyy');return false;">&nbsp;</td>	
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_strList);%><span class="jspmaker"><a href="<%out.print("dobavnicaedit.jsp?key=" + x_id + "&prikaz_stranke=sif_str");%>">šifra</a>&nbsp;<a href="<%out.print("dobavnicaedit.jsp?key=" + x_id + "&prikaz_stranke=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("dobavnicaedit.jsp?key=" + x_id + "&prikaz_stranke=naslov");%>">naslov</a></span>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Enota&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" id="kupec_enota" name="kupec_enota" value="" readonly></td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kupcaList);%><span class="jspmaker"><!--a href="<%out.print("dobavnicaedit.jsp?key=" + x_id + "&prikaz_kupca=sif_kupca");%>">šifra</a>&nbsp;<a href="<%out.print("dobavnicaedit.jsp?key=" + x_id + "&prikaz_kupca=naziv");%>">naziv</a>&nbsp;<a href="<%out.print("dobavnicaedit.jsp?key=" + x_id + "&prikaz_kupca=naslov");%>">naslov</a></span-->&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_sofList);%><a href="<%out.print("dobavnicaedit.jsp?key=" + x_id + "&prikaz_sofer=sif_sof");%>">šifra</a>&nbsp;<a href="<%out.print("dobavnicaedit.jsp?key=" + x_id + "&prikaz_sofer=sofer");%>">šofer</a>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_sif_kamList);%><a href="<%out.print("dobavnicaadd.jsp?prikaz_kamion=sif_kam&a=D&st_dob=" + x_st_dob);%>">šifra</a>&nbsp;<a href="<%out.print("dobavnicaadd.jsp?prikaz_sofer=kamion&a=D&st_dob=" + x_st_dob);%>">kamion</a>&nbsp;</td>
	</tr>
	<%for (int i=0; i<x_koda.length; i++) {%>
		<tr>
			<td class="ewTableHeader">Koda&nbsp;<%out.print(i+1);%></td>
			<td class="ewTableAltRow"><%out.println(x_koda_List[i]);%>&nbsp;
			<a href="<%out.print("dobavnicaedit.jsp?key=" + x_st_dob + "&prikaz_material_"+(i+1)+"=koda");%>">koda</a>&nbsp;<a href="<%out.print("dobavnicaedit.jsp?key=" + x_st_dob + "&prikaz_material_"+(i+1)+"=material");%>">material</a></td>
		</tr>
		<tr>
			<td class="ewTableHeader">EWC&nbsp;<%out.print(i+1);%></td>
			<td class="ewTableAltRow"><%out.println(x_ewc_List[i]);%>&nbsp;
			<a href="<%out.print("dobavnicaedit.jsp?key=" + x_st_dob + "&prikaz_okolje_"+(i+1)+"=koda");%>">koda</a>&nbsp;<a href="<%out.print("dobavnicaedit.jsp?key=" + x_st_dob + "&prikaz_okolje_"+(i+1)+"=material");%>">material</a></td>
		</tr>
	<%}%>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow"><%out.println(x_skupinaList);%>&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba" size="30" maxlength="255" value="<%= HTMLEncode((String)x_opomba) %>">&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Potrdi">
</form>
<%@ include file="footer.jsp" %>
<script language="JavaScript">
document.dobedit.kupec_enota.value = sif_kupec_enota[document.dobedit.x_sif_str.value];
</script>
