<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*" isErrorPage="true"%>
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

// get current table security
int ewCurSec = 0; // initialise
ewCurSec = ((Integer) session.getAttribute("papirservis1_status_UserLevel")).intValue();

%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
int displayRecs = 20;
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
			b_search = b_search + "`dob`.`stranka` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`st_dob` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`datum` = STR_TO_DATE('" + kw + "', '%d.%m.%Y') OR ";
			b_search = b_search + "`dob`.`sif_sof` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`sofer` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`sif_kam` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`kamion` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`koda` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`skupina_text` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`dob`.`opomba` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`dob`.`stranka` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`st_dob` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`datum` = STR_TO_DATE('" + pSearch + "', '%d.%m.%Y') OR ";
		b_search = b_search + "`dob`.`sif_sof` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`sofer` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`sif_kam` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`kamion` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`koda` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`skupina_text` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`dob`.`opomba` LIKE '%" + pSearch + "%' OR ";
	}
}
if (b_search.length() > 4 && b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) {b_search = b_search.substring(0, b_search.length()-4);}
if (b_search.length() > 5 && b_search.substring(b_search.length()-5,b_search.length()).equals(" AND ")) {b_search = b_search.substring(0, b_search.length()-5);}
%>
<%

// Get search criteria for advanced search
// st_dob

String ascrh_x_st_dob = request.getParameter("x_st_dob");
String z_st_dob = request.getParameter("z_st_dob");
	if (z_st_dob != null && z_st_dob.length() > 0 ) {
		String [] arrfieldopr_x_st_dob = z_st_dob.split(",");
		if (ascrh_x_st_dob != null && ascrh_x_st_dob.length() > 0) {
			ascrh_x_st_dob = ascrh_x_st_dob.replaceAll("'",escapeString);
			ascrh_x_st_dob = ascrh_x_st_dob.replaceAll("\\[","[[]");
			a_search += "`st_dob` "; // Add field
			a_search += arrfieldopr_x_st_dob[0].trim() + " "; // Add operator
			if (arrfieldopr_x_st_dob.length >= 2) {
				a_search += arrfieldopr_x_st_dob[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_st_dob; // Add input parameter
			if (arrfieldopr_x_st_dob.length >= 3) {
				a_search += arrfieldopr_x_st_dob[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// pozicija
String ascrh_x_pozicija = request.getParameter("x_pozicija");
String z_pozicija = request.getParameter("z_pozicija");
	if (z_pozicija != null && z_pozicija.length() > 0 ) {
		String [] arrfieldopr_x_pozicija = z_pozicija.split(",");
		if (ascrh_x_pozicija != null && ascrh_x_pozicija.length() > 0) {
			ascrh_x_pozicija = ascrh_x_pozicija.replaceAll("'",escapeString);
			ascrh_x_pozicija = ascrh_x_pozicija.replaceAll("\\[","[[]");
			a_search += "`pozicija` "; // Add field
			a_search += arrfieldopr_x_pozicija[0].trim() + " "; // Add operator
			if (arrfieldopr_x_pozicija.length >= 2) {
				a_search += arrfieldopr_x_pozicija[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_pozicija; // Add input parameter
			if (arrfieldopr_x_pozicija.length >= 3) {
				a_search += arrfieldopr_x_pozicija[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// datum
String ascrh_x_datum = request.getParameter("x_datum");
String z_datum = request.getParameter("z_datum");
	if (z_datum != null && z_datum.length() > 0 ) {
		String [] arrfieldopr_x_datum = z_datum.split(",");
		if (ascrh_x_datum != null && ascrh_x_datum.length() > 0) {
			ascrh_x_datum = ascrh_x_datum.replaceAll("'",escapeString);
			ascrh_x_datum = ascrh_x_datum.replaceAll("\\[","[[]");
			a_search += "`datum` "; // Add field
			a_search += arrfieldopr_x_datum[0].trim() + " "; // Add operator
			if (arrfieldopr_x_datum.length >= 2) {
				a_search += arrfieldopr_x_datum[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_datum; // Add input parameter
			if (arrfieldopr_x_datum.length >= 3) {
				a_search += arrfieldopr_x_datum[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// sif_str
String ascrh_x_sif_str = request.getParameter("x_sif_str");
String z_sif_str = request.getParameter("z_sif_str");
	if (z_sif_str != null && z_sif_str.length() > 0 ) {
		String [] arrfieldopr_x_sif_str = z_sif_str.split(",");
		if (ascrh_x_sif_str != null && ascrh_x_sif_str.length() > 0) {
			ascrh_x_sif_str = ascrh_x_sif_str.replaceAll("'",escapeString);
			ascrh_x_sif_str = ascrh_x_sif_str.replaceAll("\\[","[[]");
			a_search += "`sif_str` "; // Add field
			a_search += arrfieldopr_x_sif_str[0].trim() + " "; // Add operator
			if (arrfieldopr_x_sif_str.length >= 2) {
				a_search += arrfieldopr_x_sif_str[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_sif_str; // Add input parameter
			if (arrfieldopr_x_sif_str.length >= 3) {
				a_search += arrfieldopr_x_sif_str[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// stranka
String ascrh_x_stranka = request.getParameter("x_stranka");
String z_stranka = request.getParameter("z_stranka");
	if (z_stranka != null && z_stranka.length() > 0 ) {
		String [] arrfieldopr_x_stranka = z_stranka.split(",");
		if (ascrh_x_stranka != null && ascrh_x_stranka.length() > 0) {
			ascrh_x_stranka = ascrh_x_stranka.replaceAll("'",escapeString);
			ascrh_x_stranka = ascrh_x_stranka.replaceAll("\\[","[[]");
			a_search += "`stranka` "; // Add field
			a_search += arrfieldopr_x_stranka[0].trim() + " "; // Add operator
			if (arrfieldopr_x_stranka.length >= 2) {
				a_search += arrfieldopr_x_stranka[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_stranka; // Add input parameter
			if (arrfieldopr_x_stranka.length >= 3) {
				a_search += arrfieldopr_x_stranka[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// sif_kupca
String ascrh_x_sif_kupca = request.getParameter("x_sif_kupca");
String z_sif_kupca = request.getParameter("z_sif_kupca");
	if (z_sif_kupca != null && z_sif_kupca.length() > 0 ) {
		String [] arrfieldopr_x_sif_kupca = z_sif_kupca.split(",");
		if (ascrh_x_sif_kupca != null && ascrh_x_sif_kupca.length() > 0) {
			ascrh_x_sif_kupca = ascrh_x_sif_kupca.replaceAll("'",escapeString);
			ascrh_x_sif_kupca = ascrh_x_sif_kupca.replaceAll("\\[","[[]");
			a_search += "`sif_kupca` "; // Add field
			a_search += arrfieldopr_x_sif_kupca[0].trim() + " "; // Add operator
			if (arrfieldopr_x_sif_kupca.length >= 2) {
				a_search += arrfieldopr_x_sif_kupca[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_sif_kupca; // Add input parameter
			if (arrfieldopr_x_sif_kupca.length >= 3) {
				a_search += arrfieldopr_x_sif_kupca[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// sif_sof
String ascrh_x_sif_sof = request.getParameter("x_sif_sof");
String z_sif_sof = request.getParameter("z_sif_sof");
	if (z_sif_sof != null && z_sif_sof.length() > 0 ) {
		String [] arrfieldopr_x_sif_sof = z_sif_sof.split(",");
		if (ascrh_x_sif_sof != null && ascrh_x_sif_sof.length() > 0) {
			ascrh_x_sif_sof = ascrh_x_sif_sof.replaceAll("'",escapeString);
			ascrh_x_sif_sof = ascrh_x_sif_sof.replaceAll("\\[","[[]");
			a_search += "`sif_sof` "; // Add field
			a_search += arrfieldopr_x_sif_sof[0].trim() + " "; // Add operator
			if (arrfieldopr_x_sif_sof.length >= 2) {
				a_search += arrfieldopr_x_sif_sof[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_sif_sof; // Add input parameter
			if (arrfieldopr_x_sif_sof.length >= 3) {
				a_search += arrfieldopr_x_sif_sof[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// sofer
String ascrh_x_sofer = request.getParameter("x_sofer");
String z_sofer = request.getParameter("z_sofer");
	if (z_sofer != null && z_sofer.length() > 0 ) {
		String [] arrfieldopr_x_sofer = z_sofer.split(",");
		if (ascrh_x_sofer != null && ascrh_x_sofer.length() > 0) {
			ascrh_x_sofer = ascrh_x_sofer.replaceAll("'",escapeString);
			ascrh_x_sofer = ascrh_x_sofer.replaceAll("\\[","[[]");
			a_search += "`sofer` "; // Add field
			a_search += arrfieldopr_x_sofer[0].trim() + " "; // Add operator
			if (arrfieldopr_x_sofer.length >= 2) {
				a_search += arrfieldopr_x_sofer[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_sofer; // Add input parameter
			if (arrfieldopr_x_sofer.length >= 3) {
				a_search += arrfieldopr_x_sofer[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// sif_kam
String ascrh_x_sif_kam = request.getParameter("x_sif_kam");
String z_sif_kam = request.getParameter("z_sif_kam");
	if (z_sif_kam != null && z_sif_kam.length() > 0 ) {
		String [] arrfieldopr_x_sif_kam = z_sif_kam.split(",");
		if (ascrh_x_sif_kam != null && ascrh_x_sif_kam.length() > 0) {
			ascrh_x_sif_kam = ascrh_x_sif_kam.replaceAll("'",escapeString);
			ascrh_x_sif_kam = ascrh_x_sif_kam.replaceAll("\\[","[[]");
			a_search += "`sif_kam` "; // Add field
			a_search += arrfieldopr_x_sif_kam[0].trim() + " "; // Add operator
			if (arrfieldopr_x_sif_kam.length >= 2) {
				a_search += arrfieldopr_x_sif_kam[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_sif_kam; // Add input parameter
			if (arrfieldopr_x_sif_kam.length >= 3) {
				a_search += arrfieldopr_x_sif_kam[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// kamion
String ascrh_x_kamion = request.getParameter("x_kamion");
String z_kamion = request.getParameter("z_kamion");
	if (z_kamion != null && z_kamion.length() > 0 ) {
		String [] arrfieldopr_x_kamion = z_kamion.split(",");
		if (ascrh_x_kamion != null && ascrh_x_kamion.length() > 0) {
			ascrh_x_kamion = ascrh_x_kamion.replaceAll("'",escapeString);
			ascrh_x_kamion = ascrh_x_kamion.replaceAll("\\[","[[]");
			a_search += "`kamion` "; // Add field
			a_search += arrfieldopr_x_kamion[0].trim() + " "; // Add operator
			if (arrfieldopr_x_kamion.length >= 2) {
				a_search += arrfieldopr_x_kamion[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_kamion; // Add input parameter
			if (arrfieldopr_x_kamion.length >= 3) {
				a_search += arrfieldopr_x_kamion[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// koda
String ascrh_x_koda = request.getParameter("x_koda");
String z_koda = request.getParameter("z_koda");
	if (z_koda != null && z_koda.length() > 0 ) {
		String [] arrfieldopr_x_koda = z_koda.split(",");
		if (ascrh_x_koda != null && ascrh_x_koda.length() > 0) {
			ascrh_x_koda = ascrh_x_koda.replaceAll("'",escapeString);
			ascrh_x_koda = ascrh_x_koda.replaceAll("\\[","[[]");
			a_search += "`koda` "; // Add field
			a_search += arrfieldopr_x_koda[0].trim() + " "; // Add operator
			if (arrfieldopr_x_koda.length >= 2) {
				a_search += arrfieldopr_x_koda[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_koda; // Add input parameter
			if (arrfieldopr_x_koda.length >= 3) {
				a_search += arrfieldopr_x_koda[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}


// skupina
String ascrh_x_skupina = request.getParameter("x_skupina");
String z_skupina = request.getParameter("z_skupina");
	if (z_skupina != null && z_skupina.length() > 0 ) {
		String [] arrfieldopr_x_skupina = z_skupina.split(",");
		if (ascrh_x_skupina != null && ascrh_x_skupina.length() > 0) {
			ascrh_x_skupina = ascrh_x_skupina.replaceAll("'",escapeString);
			ascrh_x_skupina = ascrh_x_skupina.replaceAll("\\[","[[]");
			a_search += "`skupina` "; // Add field
			a_search += arrfieldopr_x_skupina[0].trim() + " "; // Add operator
			if (arrfieldopr_x_skupina.length >= 2) {
				a_search += arrfieldopr_x_skupina[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_skupina; // Add input parameter
			if (arrfieldopr_x_skupina.length >= 3) {
				a_search += arrfieldopr_x_skupina[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

		
// skupina_text
String ascrh_x_skupina_text = request.getParameter("x_skupina_text");
String z_skupina_text = request.getParameter("z_skupina_text");
	if (z_skupina_text != null && z_skupina_text.length() > 0 ) {
		String [] arrfieldopr_x_skupina_text = z_skupina_text.split(",");
		if (ascrh_x_skupina_text != null && ascrh_x_skupina_text.length() > 0) {
			ascrh_x_skupina_text = ascrh_x_skupina_text.replaceAll("'",escapeString);
			ascrh_x_skupina_text = ascrh_x_skupina_text.replaceAll("\\[","[[]");
			a_search += "`skupina_text` "; // Add field
			a_search += arrfieldopr_x_skupina_text[0].trim() + " "; // Add operator
			if (arrfieldopr_x_skupina_text.length >= 2) {
				a_search += arrfieldopr_x_skupina_text[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_skupina_text; // Add input parameter
			if (arrfieldopr_x_skupina_text.length >= 3) {
				a_search += arrfieldopr_x_skupina_text[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// opomba
String ascrh_x_opomba = request.getParameter("x_opomba");
String z_opomba = request.getParameter("z_opomba");
	if (z_opomba != null && z_opomba.length() > 0 ) {
		String [] arrfieldopr_x_opomba = z_opomba.split(",");
		if (ascrh_x_opomba != null && ascrh_x_opomba.length() > 0) {
			ascrh_x_opomba = ascrh_x_opomba.replaceAll("'",escapeString);
			ascrh_x_opomba = ascrh_x_opomba.replaceAll("\\[","[[]");
			a_search += "`opomba` "; // Add field
			a_search += arrfieldopr_x_opomba[0].trim() + " "; // Add operator
			if (arrfieldopr_x_opomba.length >= 2) {
				a_search += arrfieldopr_x_opomba[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_opomba; // Add input parameter
			if (arrfieldopr_x_opomba.length >= 3) {
				a_search += arrfieldopr_x_opomba[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

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
	session.setAttribute("dobavnica_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("dobavnica_REC", new Integer(startRec));
}else{
	if (session.getAttribute("dobavnica_searchwhere") != null)
		searchwhere = (String) session.getAttribute("dobavnica_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("dobavnica_searchwhere", searchwhere);
		session.removeAttribute("dobavnica_OB");
		session.removeAttribute("dobavnica_searchwhere1");
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("dobavnica_searchwhere", searchwhere);		
		session.removeAttribute("dobavnica_searchwhere1");
	}else if (cmd.toUpperCase().equals("TOP")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("dobavnica_searchwhere1", "dob.st_dob = zadnji.sd and dob.pozicija = zadnji.pozicija and dob.zacetek = zadnji.datum");
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("dobavnica_REC", new Integer(startRec));
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
String DefaultOrder = "st_dob";
String DefaultOrderType = "DESC";

// No Default Filter
String DefaultFilter = "";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("dobavnica_OB") != null &&
		((String) session.getAttribute("dobavnica_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) {
			session.setAttribute("dobavnica_OT", "DESC");
		}else{
			session.setAttribute("dobavnica_OT", "ASC");
		}
	}else{
		session.setAttribute("dobavnica_OT", "ASC");
	}
	session.setAttribute("dobavnica_OB", OrderBy);
	session.setAttribute("dobavnica_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("dobavnica_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("dobavnica_OB", OrderBy);
		session.setAttribute("dobavnica_OT", DefaultOrderType);
	}
}

startRec = 0;
int pageno = 0;

if (session.getAttribute("dobavnica_REC") != null)
	startRec = ((Integer) session.getAttribute("dobavnica_REC")).intValue();
if (startRec==0) {
	startRec = 1; //Reset start record counter
}

// Check for a START parameter
if (request.getParameter("start") != null && Integer.parseInt(request.getParameter("start")) > 0) {
	startRec = Integer.parseInt(request.getParameter("start"));
	session.setAttribute("dobavnica_REC", new Integer(startRec));

}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
	}else {
		startRec = ((Integer) session.getAttribute("dobavnica_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
		}
	}
}else{
	if (session.getAttribute("dobavnica_REC") != null)
		startRec = ((Integer) session.getAttribute("dobavnica_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
	}
}


// Open Connection to the database
try{
String searchwhere1 = (String) session.getAttribute("dobavnica_searchwhere1");

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

String stranke = (String) session.getAttribute("vse");
String strankeQueryFilter = "";
if(stranke.equals("0")){
	strankeQueryFilter = "potnik = " + session.getAttribute("papirservis1_status_UserID");
}

String enote = (String) session.getAttribute("enote");
String enoteQueryFilter = "";
if(enote.equals("0")){
	enoteQueryFilter = "sif_enote = " + session.getAttribute("papirservis1_status_Enota");
}

String subQuery ="";

if(strankeQueryFilter.length() > 0 || enoteQueryFilter.length() > 0){
	subQuery += " WHERE " + strankeQueryFilter;
	if(strankeQueryFilter.length() > 0 && enoteQueryFilter.length() > 0){
		subQuery += " AND " + enoteQueryFilter;
	}else{
		subQuery += enoteQueryFilter;
	}
}


// Build SQL
//StringBuffer strsql = new StringBuffer("SELECT dob.*, st.naziv, k.naziv, so.sofer, kam.kamion, u.ime_in_priimek, m.material, sk.tekst FROM `dob` left join stranke st on dob.sif_str = st.sif_str left join kupci k on dob.sif_kupca = k.sif_kupca left join sofer so on dob.sif_sof = so.sif_sof left join kamion kam on dob.sif_kam = kam.sif_kam left join uporabniki u on dob.uporabnik = u.sif_upor left join materiali m on dob.koda = m.koda left join skup sk on dob.skupina = sk.skupina"); //, (select sif_str from stranke, (select sif_kupca from kupci " + subQuery  + " ) kupci WHERE stranke.sif_kupca = kupci.sif_kupca) stranke ");
StringBuffer strsql = new StringBuffer("SELECT dob.*, k.naziv, u.ime_in_priimek " +
		"FROM " + session.getAttribute("letoTabela") + " dob left join kupci k on dob.sif_kupca = k.sif_kupca " +
		"	left join uporabniki u on dob.uporabnik = u.sif_upor "); 

//StringBuffer countQuery = new StringBuffer("SELECT dob.* FROM `dob`  left join stranke st on dob.sif_str = st.sif_str left join kupci k on dob.sif_kupca = k.sif_kupca left join sofer so on dob.sif_sof = so.sif_sof left join kamion kam on dob.sif_kam = kam.sif_kam left join uporabniki u on dob.uporabnik = u.sif_upor left join materiali m on dob.koda = m.koda left join skup sk on dob.skupina = sk.skupina ");//, (select sif_str from stranke, (select sif_kupca from kupci " + subQuery  + " ) kupci WHERE stranke.sif_kupca = kupci.sif_kupca) stranke ");
StringBuffer countQuery = new StringBuffer("SELECT dob.* FROM " + session.getAttribute("letoTabela") + " dob left join kupci k on dob.sif_kupca = k.sif_kupca ");

whereClause = "obdelana = 0 and dob.pozicija = 1 ";

if (searchwhere1 != null && searchwhere1.length() > 0){
	strsql.append(" , (SELECT st_dob sd, pozicija, max(zacetek) datum FROM " + session.getAttribute("letoTabela") + " dob group by st_dob, pozicija) zadnji ");
	countQuery.append(" , (SELECT st_dob sd, pozicija, max(zacetek) datum FROM " + session.getAttribute("letoTabela") + " dob group by st_dob, pozicija) zadnji ");
}
if (DefaultFilter.length() > 0) {
	whereClause = whereClause + " AND (" + DefaultFilter + ") AND ";
}
if (dbwhere.length() > 0) {
	whereClause = whereClause + " AND (" + dbwhere + ") AND ";
}
if ((ewCurSec & ewAllowList) != ewAllowList) {
	whereClause = whereClause + " AND (0=1) AND ";
}
if (whereClause.length() > 5 && whereClause.substring(whereClause.length()-5, whereClause.length()).equals(" AND ")) {
	whereClause = whereClause.substring(0, whereClause.length()-5);
}
if (whereClause.length() > 0) {
	strsql.append(" WHERE ").append(whereClause);
	countQuery.append(" WHERE ").append(whereClause);
}

if (whereClause.length() > 0) {
	if(searchwhere1 != null && searchwhere1.length() > 0){
		strsql.append(" AND (dob.st_dob = zadnji.sd and dob.pozicija = zadnji.pozicija and dob.zacetek = zadnji.datum)");
		countQuery.append(" AND (dob.st_dob = zadnji.sd and dob.pozicija = zadnji.pozicija and dob.zacetek = zadnji.datum)");
	}
}
else{
	if(searchwhere1 != null && searchwhere1.length() > 0){
		strsql.append(" WHERE (dob.st_dob = zadnji.sd and dob.pozicija = zadnji.pozicija and dob.zacetek = zadnji.datum)");
		countQuery.append(" WHERE (dob.st_dob = zadnji.sd and dob.pozicija = zadnji.pozicija and dob.zacetek = zadnji.datum)");
	}
}



String strankeTip = (String) session.getAttribute("vse");
if(strankeTip.equals("0")){
	strsql.append(" and potnik = " + session.getAttribute("papirservis1_status_UserID"));
	countQuery.append(" and potnik = " + session.getAttribute("papirservis1_status_UserID"));
}

String enoteTip = (String) session.getAttribute("enote");
if(enoteTip.equals("0")){
	strsql.append(" and k.sif_enote = " + session.getAttribute("papirservis1_status_Enota"));
	countQuery.append(" and k.sif_enote = " + session.getAttribute("papirservis1_status_Enota"));
}

//strsql += " AND ";

//countQuery = countQuery.replace("dob.*", "count(dob.id)");


if (OrderBy != null && OrderBy.length() > 0) {
	strsql.append(" ORDER BY `").append(OrderBy).append("` ").append((String) session.getAttribute("dobavnica_OT"));
}
strsql.append(" LIMIT ").append(startRec - 1).append(", ").append(displayRecs);
rs = stmt.executeQuery(strsql.toString());
{
Statement stmtCount = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rsCount = null;
rsCount = stmtCount.executeQuery(countQuery.toString().replace("dob.*", "count(dob.id)"));
rsCount.next();

totalRecs = rsCount.getInt(1);
rsCount = null;
stmtCount.close();
stmtCount = null;
}
rs.beforeFirst();
%>
<%@ include file="header.jsp" %>
<script language="JavaScript" src="papirservis.js"></script>
<script language="JavaScript">
function disableSome(EW_this){
}
</script>
<p><span class="jspmaker">Pregled: Delovni nalog</span></p>
<form action="dobavnicalist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Iskanje po poljih označenih z (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="Išči">
		&nbsp;&nbsp;<a href="dobavnicalist.jsp?cmd=reset">Prikaži vse</a>
		&nbsp;&nbsp;<a href="dobavnicalist.jsp?cmd=top">Prikaži zadnje</a>
		</span></td>
	</tr>
</table>
</form>



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
	<td><a href="dobavnicalist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobavnicalist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobavnicalist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobavnicalist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
	<td><span class="jspmaker">&nbsp;od <%=(totalRecs-1)/displayRecs+1%></span></td>
	</tr></table>
</form>
	<% if (startRec > totalRecs) { startRec = totalRecs;}
	stopRec = startRec + displayRecs - 1; 
	recCount = totalRecs - 1;
	if (rsEof) { recCount = totalRecs;}
	if (stopRec > recCount) { stopRec = recCount;} 
	
	%>
	<span class="jspmaker">Zapisi <%= startRec %> do <%= stopRec %> od <%= totalRecs %></span>
<% }else{ %>
	<% if ((ewCurSec & ewAllowList) == ewAllowList) { %>
	<span class="jspmaker">Ni vstreznih zapisov</span>
	<% }else{ %>
	<span class="jspmaker">Nimate vstreznih pravic</span>
	<% } %>
<p>
</p>
<% } %>
</td></tr></table>




<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
<table class="ewTable">
	<tr></tr>
	<tr><td><a href="dobavnicaadd.jsp">Dodaj nov zapis</a></td></tr>
	<tr></tr>
</table>
<% } %>
<form method="post"  id="dobavnicalistform">
<table class="ewTable">
	<tr class="ewTableHeader">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td>&nbsp;</td>
<% } %>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("st_dob")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("st_dob","UTF-8") %>">Številka dobavnice(*)&nbsp;<% if (OrderBy != null && OrderBy.equals("st_dob")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("st_dob")) ? "</b>" : ""%>
		</td>
		<!--td>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("pozicija","UTF-8") %>">Pozicija&nbsp;<% if (OrderBy != null && OrderBy.equals("pozicija")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
		</td-->
		<td>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("datum","UTF-8") %>">Datum(*)&nbsp;<% if (OrderBy != null && OrderBy.equals("datum")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("datum","UTF-8") %>">Šifra stranke&nbsp;<% if (OrderBy != null && OrderBy.equals("datum")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("datum")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_str")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("sif_str","UTF-8") %>">Naziv stranke&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_str")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_str")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("sif_kupca","UTF-8") %>">Šifra kupca&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_kupca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kupca")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_sof")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("sif_sof","UTF-8") %>">Naziv kupca&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_sof")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_sof")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_sof")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("sif_sof","UTF-8") %>">Šifra šoferja&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_sof")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_sof")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_sof")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("sofer","UTF-8") %>">Šofer&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("sofer")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_sof")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kam")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("sif_kam","UTF-8") %>">Šifra kamiona&nbsp;<% if (OrderBy != null && OrderBy.equals("sif_kam")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kam")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("sif_kam")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("sofer","UTF-8") %>">Kamion&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("kamion")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("sif_kam")) ? "</b>" : ""%>
		</td>
		<td>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("koda","UTF-8") %>">Koda&nbsp;<% if (OrderBy != null && OrderBy.equals("koda")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
		</td>
		<td>Koda&nbsp;
		</td>
		<td>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("skupina","UTF-8") %>">Skupina&nbsp;<% if (OrderBy != null && OrderBy.equals("skupina")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
		</td>
		<td>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("skupina_text","UTF-8") %>">Skupina&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("skupina_text")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
		</td>
		<td>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("sif_enote","UTF-8") %>">Enota&nbsp;<% if (OrderBy != null && OrderBy.equals("skupina")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
		</td>
		<td>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("naziv_enote","UTF-8") %>">Enota&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("skupina_text")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("opomba")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("opomba","UTF-8") %>">Opomba&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("opomba")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("opomba")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("zacetek","UTF-8") %>">Začetek&nbsp;<% if (OrderBy != null && OrderBy.equals("zacetek")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("zacetek")) ? "</b>" : ""%>
		</td>
		<td>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "<b>" : ""%>
<a href="dobavnicalist.jsp?order=<%= java.net.URLEncoder.encode("uporabnik","UTF-8") %>">Uporabnik&nbsp;<% if (OrderBy != null && OrderBy.equals("uporabnik")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("dobavnica_OT")).equals("ASC")) { %>(^)<% }else if (((String) session.getAttribute("dobavnica_OT")).equals("DESC")) { %>(v)<% } %></span><% } %></a>
<%=(OrderBy != null && OrderBy.equals("uporabnik")) ? "</b>" : ""%>
		</td>		
</tr>
<%
// Avoid starting record > total records
if (startRec > totalRecs) {
	startRec = totalRecs;
}

// Set the last record to display
//stopRec = startRec + displayRecs - 1;
stopRec = displayRecs - 1;

// Move to first record directly for performance reason
//recCount = startRec - 1;
recCount =  - 1;
if (rs.next()) {
	rs.first();
	rs.relative(startRec - 1);

}
long recActual = 0;
if (startRec == 1)
   rs.beforeFirst();
else
   rs.previous();
   
   rs.beforeFirst();
while (rs.next() ){//&& recCount < stopRec) {
	recCount++;
	{
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
	String x_st_dob = "";
	String x_pozicija = "";
	Object x_datum = null;
	String x_sif_str = "";
	String x_stranka = "";
	String x_sif_kupca = "";
	String x_sif_sof = "";
	String x_sofer = "";
	String x_sif_kam = "";
	String x_kamion = "";
	String x_koda = "";
	String x_koda_text = "";
	String x_skupina = "";
	String x_skupina_text = "";
	String x_sif_enote = "";
	String x_naziv_enote = "";
	String x_opomba = "";
	Object x_zacetek = null;
	String x_uporabnik = "";

	// Load Key for record
	String key = "";
	key = String.valueOf(rs.getLong("id"));

	// id
	x_id = String.valueOf(rs.getLong("id"));

	// st_dob
	x_st_dob = String.valueOf(rs.getLong("st_dob"));

	// pozicija
	x_pozicija = String.valueOf(rs.getLong("pozicija"));

	// datum
	if (rs.getTimestamp("datum") != null){
		x_datum = rs.getTimestamp("datum");
	}else{
		x_datum = "";
	}

	// sif_str
	x_sif_str = String.valueOf(rs.getLong("sif_str"));

	// stranka
	if (rs.getString("stranka") != null){
		x_stranka = rs.getString("stranka");
	}else{
		x_stranka = "";
	}

	// sif_kupca
	if (rs.getString("sif_kupca") != null){
		x_sif_kupca = rs.getString("sif_kupca");
	}else{
		x_sif_kupca = "";
	}

	// sif_sof
	if (rs.getString("sif_sof") != null){
		x_sif_sof = rs.getString("sif_sof");
	}else{
		x_sif_sof = "";
	}

	// sofer
	if (rs.getString("sofer") != null){
		x_sofer = rs.getString("sofer");
	}else{
		x_sofer = "";
	}

	// sif_kam
	if (rs.getString("sif_kam") != null){
		x_sif_kam = rs.getString("sif_kam");
	}else{
		x_sif_kam = "";
	}

	// kamion
	if (rs.getString("kamion") != null){
		x_kamion = rs.getString("kamion");
	}else{
		x_kamion = "";
	}

	// koda
	if (rs.getString("koda") != null){
		x_koda = rs.getString("koda");
	}else{
		x_koda = "";
	}

	
	// skupina
	x_skupina = String.valueOf(rs.getLong("skupina"));

	// skupina_text
	if (rs.getString("skupina_text") != null){
		x_skupina_text = rs.getString("skupina_text");
	}else{
		x_skupina_text = "";
	}

	// enota
	x_sif_enote = String.valueOf(rs.getLong("sif_enote"));

	// naziv enote
	if (rs.getString("naziv_enote") != null){
		x_naziv_enote = rs.getString("naziv_enote");
	}else{
		x_naziv_enote = "";
	}


	// opomba
	if (rs.getString("opomba") != null){
		x_opomba = rs.getString("opomba");
	}else{
		x_opomba = "";
	}

	// zacetek
	if (rs.getTimestamp("zacetek") != null){
		x_zacetek = rs.getTimestamp("zacetek");
	}else{
		x_zacetek = "";
	}

	// uporabnik
	x_uporabnik = String.valueOf(rs.getLong("uporabnik"));
%>
	<tr class="<%= rowclass %>">
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("dobavnicaview.jsp?key=" + java.net.URLEncoder.encode(x_st_dob,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>"><img width="16" height="16" border="0" alt="Pregled" title="Pregled" src="images/browse.gif"></a></span></td>
<% } %>

<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("dobavnicaedit.jsp?key=" + java.net.URLEncoder.encode(x_st_dob,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>"><img width="16" height="16" border="0" alt="Spremeni" title="Spremeni" src="images/edit.gif"></a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id"); 
if (key != null && key.length() > 0) { 
	out.print("dobavnicaadd.jsp?key=" + java.net.URLEncoder.encode(x_st_dob,"UTF-8"));
}else{
	out.print("javascript:alert('Invalid Record! Key is null');");
} %>"><img width="16" height="16" border="0" alt="Kopiraj" title="Kopiraj" src="images/copy.gif"></a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=x_st_dob %>" class="jspmaker"><img width="16" height="16" border="0" alt="Zbriši" title="Zbriši" src="images/delete.gif"></span></td>
<% } %>
<td><span class="jspmaker"><input type="checkbox" name="key" value="<%=x_st_dob %>" class="jspmaker"><img width="16" height="16" border="0" alt="Mail" title="Mail" src="images/mail.gif"></span></td>
<td><span class="jspmaker"><a href="printDelovniNalog.jsp?type=1&reportID=0&report=<%="/"%>reports<%="/"%>dobavnica&x_sif_dob=<%=x_st_dob%>"><img width="20" height="20" border="0" alt="Tiskaj" title="Tiskaj" src="images/print.gif"></a></span></td>
		<td><% out.print(x_st_dob); %>&nbsp;</td>
		<!--td><% out.print(x_pozicija); %>&nbsp;</td-->
		<td><% out.print(EW_FormatDateTime(x_datum,7,locale)); %>&nbsp;</td>
		<td><% out.print(x_sif_str); %></td>
		<td><%out.print(rs.getString("stranka"));%>&nbsp;</td>
		<td><% out.print(x_sif_kupca); %>&nbsp;</td>
		<td><%out.print(rs.getString("k.naziv"));%>&nbsp;</td>
		<td><% out.print(x_sif_sof); %>&nbsp;</td>
		<td><%out.print(rs.getString("sofer"));%>&nbsp;</td>
		<td><% out.print(x_sif_kam); %>&nbsp;</td>
		<td><%out.print(rs.getString("kamion"));%>&nbsp;</td>
		<td><% out.print(x_koda); %>&nbsp;</td>
		<td><%

if (x_koda!=null && ((String)x_koda).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_koda;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`koda` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `koda`, `material` FROM `materiali`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("material"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}

%>
&nbsp;</td>
		<td><% out.print(x_skupina); %>&nbsp;</td>
		<td><%out.print(rs.getString("skupina_text"));%>&nbsp;</td>
		<td><% out.print(x_sif_enote); %>&nbsp;</td>
		<td><%out.print(rs.getString("naziv_enote"));%>&nbsp;</td>
		<td><% out.print(x_opomba); %>&nbsp;</td>
		<td><% out.print(EW_FormatDateTime(x_zacetek,7,locale)); %>&nbsp;</td>
		<td><%out.print(rs.getString("u.ime_in_priimek"));%>&nbsp;</td>
	</tr>
<%

//	}
}
}
%>
</table>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete) { %>
<% if (recActual > 0) { %>
<p><input type="button" name="btndelete" value="Izbriši izbrane" onClick="this.form.action='dobavnicadelete.jsp';this.form.submit();"></p>
<% } %>
<% } %>
<% if (recActual > 0) { %>
<p>
Prejemnik:<input type="text" name="receiver"><br>
Obvestilo:<input type="text" name="msg" size="150" maxlength="255"><br>
<input type="button" name="btnmail" value="Pošlji izbrane" onClick='mail(this.form.key, this.form.receiver.value, this.form.msg.value, "<%out.print(session.getAttribute("letoTabela")); %>", "<%out.print(session.getAttribute("papirservis1_status_Name")); %>", "<%out.print(session.getAttribute("papirservis1_status_Mail")); %>")'></p>
<% } %>
</form>
<%

// Close recordset and connection
rs.close();
rs = null;
stmt.close();
stmt = null;
//conn.close();
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
	<td><a href="dobavnicalist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobavnicalist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobavnicalist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="dobavnicalist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
	<td><span class="jspmaker">&nbsp;od <%=(totalRecs-1)/displayRecs+1%></span></td>
	</tr></table>
</form>
	<% if (startRec > totalRecs) { startRec = totalRecs;}
	stopRec = startRec + displayRecs - 1; 
	recCount = totalRecs - 1;
	if (rsEof) { recCount = totalRecs;}
	if (stopRec > recCount) { stopRec = recCount;} 
	
	%>
	<span class="jspmaker">Zapisi <%= startRec %> do <%= stopRec %> od <%= totalRecs %></span>
<% }else{ %>
	<% if ((ewCurSec & ewAllowList) == ewAllowList) { %>
	<span class="jspmaker">Ni vstreznih zapisov</span>
	<% }else{ %>
	<span class="jspmaker">Nimate vstreznih pravic</span>
	<% } %>
<p>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>