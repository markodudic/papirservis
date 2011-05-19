<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*,java.net.*" errorPage="dobavnicalist.jsp"%>
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

if ((ewCurSec & ewAllowSearch) != ewAllowSearch) {
	response.sendRedirect("doblist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id =  "";
	String x_st_dob =  "";
	String x_pozicija =  "";
	String x_datum =  "";
	String x_sif_str =  "";
	String x_stranka =  "";
	String x_sif_kupca =  "";
	String x_sif_sof =  "";
	String x_sofer =  "";
	String x_sif_kam =  "";
	String x_kamion =  "";
	String x_cena_km =  "";
	String x_cena_ura =  "";
	String x_c_km =  "";
	String x_c_ura =  "";
	String x_stev_km =  "";
	String x_stev_ur =  "";
	String x_stroski =  "";
	String x_koda =  "";
	String x_kolicina =  "";
	String x_cena =  "";
	String x_kg_zaup =  "";
	String x_sit_zaup =  "";
	String x_kg_sort =  "";
	String x_sit_sort =  "";
	String x_sit_smet =  "";
	String x_skupina =  "";
	String x_skupina_text =  "";
	String x_opomba =  "";
	String x_stev_km_sled =  "";
	String x_stev_ur_sled =  "";
	String x_zacetek =  "";
	
	String x_uporabnik =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// st_dob
	if (request.getParameter("x_st_dob") != null){
		x_st_dob = request.getParameter("x_st_dob");
	}
	String z_st_dob = "";
	if (request.getParameterValues("z_st_dob") != null){
		String [] ary_z_st_dob = request.getParameterValues("z_st_dob");
		for (int i =0; i < ary_z_st_dob.length; i++){
			z_st_dob += ary_z_st_dob[i] + ",";
		}
		z_st_dob = z_st_dob.substring(0,z_st_dob.length()-1);
	}
	this_search_criteria = "";
	if (x_st_dob.length() > 0) {
		String srchFld = x_st_dob;
		this_search_criteria = "x_st_dob=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_st_dob=" + URLEncoder.encode(z_st_dob,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// pozicija
	if (request.getParameter("x_pozicija") != null){
		x_pozicija = request.getParameter("x_pozicija");
	}
	String z_pozicija = "";
	if (request.getParameterValues("z_pozicija") != null){
		String [] ary_z_pozicija = request.getParameterValues("z_pozicija");
		for (int i =0; i < ary_z_pozicija.length; i++){
			z_pozicija += ary_z_pozicija[i] + ",";
		}
		z_pozicija = z_pozicija.substring(0,z_pozicija.length()-1);
	}
	this_search_criteria = "";
	if (x_pozicija.length() > 0) {
		String srchFld = x_pozicija;
		this_search_criteria = "x_pozicija=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_pozicija=" + URLEncoder.encode(z_pozicija,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// datum
	if (request.getParameter("x_datum") != null){
		x_datum = request.getParameter("x_datum");
	}
	String z_datum = "";
	if (request.getParameterValues("z_datum") != null){
		String [] ary_z_datum = request.getParameterValues("z_datum");
		for (int i =0; i < ary_z_datum.length; i++){
			z_datum += ary_z_datum[i] + ",";
		}
		z_datum = z_datum.substring(0,z_datum.length()-1);
	}
	this_search_criteria = "";
	if (x_datum.length() > 0) {
		String srchFld = x_datum;

		//srchFld = EW_UnFormatDateTime(srchFld,"EURODATE", locale).toString();
		this_search_criteria = "x_datum=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_datum=" + URLEncoder.encode(z_datum,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// sif_str
	if (request.getParameter("x_sif_str") != null){
		x_sif_str = request.getParameter("x_sif_str");
	}
	String z_sif_str = "";
	if (request.getParameterValues("z_sif_str") != null){
		String [] ary_z_sif_str = request.getParameterValues("z_sif_str");
		for (int i =0; i < ary_z_sif_str.length; i++){
			z_sif_str += ary_z_sif_str[i] + ",";
		}
		z_sif_str = z_sif_str.substring(0,z_sif_str.length()-1);
	}
	this_search_criteria = "";
	if (x_sif_str.length() > 0) {
		String srchFld = x_sif_str;
		this_search_criteria = "x_sif_str=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_sif_str=" + URLEncoder.encode(z_sif_str,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// stranka
	if (request.getParameter("x_stranka") != null){
		x_stranka = request.getParameter("x_stranka");
	}
	String z_stranka = "";
	if (request.getParameterValues("z_stranka") != null){
		String [] ary_z_stranka = request.getParameterValues("z_stranka");
		for (int i =0; i < ary_z_stranka.length; i++){
			z_stranka += ary_z_stranka[i] + ",";
		}
		z_stranka = z_stranka.substring(0,z_stranka.length()-1);
	}
	this_search_criteria = "";
	if (x_stranka.length() > 0) {
		String srchFld = x_stranka;
		this_search_criteria = "x_stranka=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_stranka=" + URLEncoder.encode(z_stranka,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// sif_kupca
	if (request.getParameter("x_sif_kupca") != null){
		x_sif_kupca = request.getParameter("x_sif_kupca");
	}
	String z_sif_kupca = "";
	if (request.getParameterValues("z_sif_kupca") != null){
		String [] ary_z_sif_kupca = request.getParameterValues("z_sif_kupca");
		for (int i =0; i < ary_z_sif_kupca.length; i++){
			z_sif_kupca += ary_z_sif_kupca[i] + ",";
		}
		z_sif_kupca = z_sif_kupca.substring(0,z_sif_kupca.length()-1);
	}
	this_search_criteria = "";
	if (x_sif_kupca.length() > 0) {
		String srchFld = x_sif_kupca;
		this_search_criteria = "x_sif_kupca=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_sif_kupca=" + URLEncoder.encode(z_sif_kupca,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// sif_sof
	if (request.getParameter("x_sif_sof") != null){
		x_sif_sof = request.getParameter("x_sif_sof");
	}
	String z_sif_sof = "";
	if (request.getParameterValues("z_sif_sof") != null){
		String [] ary_z_sif_sof = request.getParameterValues("z_sif_sof");
		for (int i =0; i < ary_z_sif_sof.length; i++){
			z_sif_sof += ary_z_sif_sof[i] + ",";
		}
		z_sif_sof = z_sif_sof.substring(0,z_sif_sof.length()-1);
	}
	this_search_criteria = "";
	if (x_sif_sof.length() > 0) {
		String srchFld = x_sif_sof;
		this_search_criteria = "x_sif_sof=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_sif_sof=" + URLEncoder.encode(z_sif_sof,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// sofer
	if (request.getParameter("x_sofer") != null){
		x_sofer = request.getParameter("x_sofer");
	}
	String z_sofer = "";
	if (request.getParameterValues("z_sofer") != null){
		String [] ary_z_sofer = request.getParameterValues("z_sofer");
		for (int i =0; i < ary_z_sofer.length; i++){
			z_sofer += ary_z_sofer[i] + ",";
		}
		z_sofer = z_sofer.substring(0,z_sofer.length()-1);
	}
	this_search_criteria = "";
	if (x_sofer.length() > 0) {
		String srchFld = x_sofer;
		this_search_criteria = "x_sofer=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_sofer=" + URLEncoder.encode(z_sofer,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// sif_kam
	if (request.getParameter("x_sif_kam") != null){
		x_sif_kam = request.getParameter("x_sif_kam");
	}
	String z_sif_kam = "";
	if (request.getParameterValues("z_sif_kam") != null){
		String [] ary_z_sif_kam = request.getParameterValues("z_sif_kam");
		for (int i =0; i < ary_z_sif_kam.length; i++){
			z_sif_kam += ary_z_sif_kam[i] + ",";
		}
		z_sif_kam = z_sif_kam.substring(0,z_sif_kam.length()-1);
	}
	this_search_criteria = "";
	if (x_sif_kam.length() > 0) {
		String srchFld = x_sif_kam;
		this_search_criteria = "x_sif_kam=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_sif_kam=" + URLEncoder.encode(z_sif_kam,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// kamion
	if (request.getParameter("x_kamion") != null){
		x_kamion = request.getParameter("x_kamion");
	}
	String z_kamion = "";
	if (request.getParameterValues("z_kamion") != null){
		String [] ary_z_kamion = request.getParameterValues("z_kamion");
		for (int i =0; i < ary_z_kamion.length; i++){
			z_kamion += ary_z_kamion[i] + ",";
		}
		z_kamion = z_kamion.substring(0,z_kamion.length()-1);
	}
	this_search_criteria = "";
	if (x_kamion.length() > 0) {
		String srchFld = x_kamion;
		this_search_criteria = "x_kamion=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_kamion=" + URLEncoder.encode(z_kamion,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// cena_km
	if (request.getParameter("x_cena_km") != null){
		x_cena_km = request.getParameter("x_cena_km");
	}
	String z_cena_km = "";
	if (request.getParameterValues("z_cena_km") != null){
		String [] ary_z_cena_km = request.getParameterValues("z_cena_km");
		for (int i =0; i < ary_z_cena_km.length; i++){
			z_cena_km += ary_z_cena_km[i] + ",";
		}
		z_cena_km = z_cena_km.substring(0,z_cena_km.length()-1);
	}
	this_search_criteria = "";
	if (x_cena_km.length() > 0) {
		String srchFld = x_cena_km;
		this_search_criteria = "x_cena_km=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_cena_km=" + URLEncoder.encode(z_cena_km,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// cena_ura
	if (request.getParameter("x_cena_ura") != null){
		x_cena_ura = request.getParameter("x_cena_ura");
	}
	String z_cena_ura = "";
	if (request.getParameterValues("z_cena_ura") != null){
		String [] ary_z_cena_ura = request.getParameterValues("z_cena_ura");
		for (int i =0; i < ary_z_cena_ura.length; i++){
			z_cena_ura += ary_z_cena_ura[i] + ",";
		}
		z_cena_ura = z_cena_ura.substring(0,z_cena_ura.length()-1);
	}
	this_search_criteria = "";
	if (x_cena_ura.length() > 0) {
		String srchFld = x_cena_ura;
		this_search_criteria = "x_cena_ura=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_cena_ura=" + URLEncoder.encode(z_cena_ura,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// c_km
	if (request.getParameter("x_c_km") != null){
		x_c_km = request.getParameter("x_c_km");
	}
	String z_c_km = "";
	if (request.getParameterValues("z_c_km") != null){
		String [] ary_z_c_km = request.getParameterValues("z_c_km");
		for (int i =0; i < ary_z_c_km.length; i++){
			z_c_km += ary_z_c_km[i] + ",";
		}
		z_c_km = z_c_km.substring(0,z_c_km.length()-1);
	}
	this_search_criteria = "";
	if (x_c_km.length() > 0) {
		String srchFld = x_c_km;
		this_search_criteria = "x_c_km=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_c_km=" + URLEncoder.encode(z_c_km,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// c_ura
	if (request.getParameter("x_c_ura") != null){
		x_c_ura = request.getParameter("x_c_ura");
	}
	String z_c_ura = "";
	if (request.getParameterValues("z_c_ura") != null){
		String [] ary_z_c_ura = request.getParameterValues("z_c_ura");
		for (int i =0; i < ary_z_c_ura.length; i++){
			z_c_ura += ary_z_c_ura[i] + ",";
		}
		z_c_ura = z_c_ura.substring(0,z_c_ura.length()-1);
	}
	this_search_criteria = "";
	if (x_c_ura.length() > 0) {
		String srchFld = x_c_ura;
		this_search_criteria = "x_c_ura=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_c_ura=" + URLEncoder.encode(z_c_ura,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// stev_km
	if (request.getParameter("x_stev_km") != null){
		x_stev_km = request.getParameter("x_stev_km");
	}
	String z_stev_km = "";
	if (request.getParameterValues("z_stev_km") != null){
		String [] ary_z_stev_km = request.getParameterValues("z_stev_km");
		for (int i =0; i < ary_z_stev_km.length; i++){
			z_stev_km += ary_z_stev_km[i] + ",";
		}
		z_stev_km = z_stev_km.substring(0,z_stev_km.length()-1);
	}
	this_search_criteria = "";
	if (x_stev_km.length() > 0) {
		String srchFld = x_stev_km;
		this_search_criteria = "x_stev_km=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_stev_km=" + URLEncoder.encode(z_stev_km,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// stev_ur
	if (request.getParameter("x_stev_ur") != null){
		x_stev_ur = request.getParameter("x_stev_ur");
	}
	String z_stev_ur = "";
	if (request.getParameterValues("z_stev_ur") != null){
		String [] ary_z_stev_ur = request.getParameterValues("z_stev_ur");
		for (int i =0; i < ary_z_stev_ur.length; i++){
			z_stev_ur += ary_z_stev_ur[i] + ",";
		}
		z_stev_ur = z_stev_ur.substring(0,z_stev_ur.length()-1);
	}
	this_search_criteria = "";
	if (x_stev_ur.length() > 0) {
		String srchFld = x_stev_ur;
		this_search_criteria = "x_stev_ur=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_stev_ur=" + URLEncoder.encode(z_stev_ur,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// stroski
	if (request.getParameter("x_stroski") != null){
		x_stroski = request.getParameter("x_stroski");
	}
	String z_stroski = "";
	if (request.getParameterValues("z_stroski") != null){
		String [] ary_z_stroski = request.getParameterValues("z_stroski");
		for (int i =0; i < ary_z_stroski.length; i++){
			z_stroski += ary_z_stroski[i] + ",";
		}
		z_stroski = z_stroski.substring(0,z_stroski.length()-1);
	}
	this_search_criteria = "";
	if (x_stroski.length() > 0) {
		String srchFld = x_stroski;
		this_search_criteria = "x_stroski=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_stroski=" + URLEncoder.encode(z_stroski,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// koda
	if (request.getParameter("x_koda") != null){
		x_koda = request.getParameter("x_koda");
	}
	String z_koda = "";
	if (request.getParameterValues("z_koda") != null){
		String [] ary_z_koda = request.getParameterValues("z_koda");
		for (int i =0; i < ary_z_koda.length; i++){
			z_koda += ary_z_koda[i] + ",";
		}
		z_koda = z_koda.substring(0,z_koda.length()-1);
	}
	this_search_criteria = "";
	if (x_koda.length() > 0) {
		String srchFld = x_koda;
		this_search_criteria = "x_koda=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_koda=" + URLEncoder.encode(z_koda,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// kolicina
	if (request.getParameter("x_kolicina") != null){
		x_kolicina = request.getParameter("x_kolicina");
	}
	String z_kolicina = "";
	if (request.getParameterValues("z_kolicina") != null){
		String [] ary_z_kolicina = request.getParameterValues("z_kolicina");
		for (int i =0; i < ary_z_kolicina.length; i++){
			z_kolicina += ary_z_kolicina[i] + ",";
		}
		z_kolicina = z_kolicina.substring(0,z_kolicina.length()-1);
	}
	this_search_criteria = "";
	if (x_kolicina.length() > 0) {
		String srchFld = x_kolicina;
		this_search_criteria = "x_kolicina=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_kolicina=" + URLEncoder.encode(z_kolicina,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// cena
	if (request.getParameter("x_cena") != null){
		x_cena = request.getParameter("x_cena");
	}
	String z_cena = "";
	if (request.getParameterValues("z_cena") != null){
		String [] ary_z_cena = request.getParameterValues("z_cena");
		for (int i =0; i < ary_z_cena.length; i++){
			z_cena += ary_z_cena[i] + ",";
		}
		z_cena = z_cena.substring(0,z_cena.length()-1);
	}
	this_search_criteria = "";
	if (x_cena.length() > 0) {
		String srchFld = x_cena;
		this_search_criteria = "x_cena=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_cena=" + URLEncoder.encode(z_cena,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// kg_zaup
	if (request.getParameter("x_kg_zaup") != null){
		x_kg_zaup = request.getParameter("x_kg_zaup");
	}
	String z_kg_zaup = "";
	if (request.getParameterValues("z_kg_zaup") != null){
		String [] ary_z_kg_zaup = request.getParameterValues("z_kg_zaup");
		for (int i =0; i < ary_z_kg_zaup.length; i++){
			z_kg_zaup += ary_z_kg_zaup[i] + ",";
		}
		z_kg_zaup = z_kg_zaup.substring(0,z_kg_zaup.length()-1);
	}
	this_search_criteria = "";
	if (x_kg_zaup.length() > 0) {
		String srchFld = x_kg_zaup;
		this_search_criteria = "x_kg_zaup=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_kg_zaup=" + URLEncoder.encode(z_kg_zaup,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// sit_zaup
	if (request.getParameter("x_sit_zaup") != null){
		x_sit_zaup = request.getParameter("x_sit_zaup");
	}
	String z_sit_zaup = "";
	if (request.getParameterValues("z_sit_zaup") != null){
		String [] ary_z_sit_zaup = request.getParameterValues("z_sit_zaup");
		for (int i =0; i < ary_z_sit_zaup.length; i++){
			z_sit_zaup += ary_z_sit_zaup[i] + ",";
		}
		z_sit_zaup = z_sit_zaup.substring(0,z_sit_zaup.length()-1);
	}
	this_search_criteria = "";
	if (x_sit_zaup.length() > 0) {
		String srchFld = x_sit_zaup;
		this_search_criteria = "x_sit_zaup=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_sit_zaup=" + URLEncoder.encode(z_sit_zaup,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// kg_sort
	if (request.getParameter("x_kg_sort") != null){
		x_kg_sort = request.getParameter("x_kg_sort");
	}
	String z_kg_sort = "";
	if (request.getParameterValues("z_kg_sort") != null){
		String [] ary_z_kg_sort = request.getParameterValues("z_kg_sort");
		for (int i =0; i < ary_z_kg_sort.length; i++){
			z_kg_sort += ary_z_kg_sort[i] + ",";
		}
		z_kg_sort = z_kg_sort.substring(0,z_kg_sort.length()-1);
	}
	this_search_criteria = "";
	if (x_kg_sort.length() > 0) {
		String srchFld = x_kg_sort;
		this_search_criteria = "x_kg_sort=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_kg_sort=" + URLEncoder.encode(z_kg_sort,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// sit_sort
	if (request.getParameter("x_sit_sort") != null){
		x_sit_sort = request.getParameter("x_sit_sort");
	}
	String z_sit_sort = "";
	if (request.getParameterValues("z_sit_sort") != null){
		String [] ary_z_sit_sort = request.getParameterValues("z_sit_sort");
		for (int i =0; i < ary_z_sit_sort.length; i++){
			z_sit_sort += ary_z_sit_sort[i] + ",";
		}
		z_sit_sort = z_sit_sort.substring(0,z_sit_sort.length()-1);
	}
	this_search_criteria = "";
	if (x_sit_sort.length() > 0) {
		String srchFld = x_sit_sort;
		this_search_criteria = "x_sit_sort=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_sit_sort=" + URLEncoder.encode(z_sit_sort,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// sit_smet
	if (request.getParameter("x_sit_smet") != null){
		x_sit_smet = request.getParameter("x_sit_smet");
	}
	String z_sit_smet = "";
	if (request.getParameterValues("z_sit_smet") != null){
		String [] ary_z_sit_smet = request.getParameterValues("z_sit_smet");
		for (int i =0; i < ary_z_sit_smet.length; i++){
			z_sit_smet += ary_z_sit_smet[i] + ",";
		}
		z_sit_smet = z_sit_smet.substring(0,z_sit_smet.length()-1);
	}
	this_search_criteria = "";
	if (x_sit_smet.length() > 0) {
		String srchFld = x_sit_smet;
		this_search_criteria = "x_sit_smet=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_sit_smet=" + URLEncoder.encode(z_sit_smet,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// skupina
	if (request.getParameter("x_skupina") != null){
		x_skupina = request.getParameter("x_skupina");
	}
	String z_skupina = "";
	if (request.getParameterValues("z_skupina") != null){
		String [] ary_z_skupina = request.getParameterValues("z_skupina");
		for (int i =0; i < ary_z_skupina.length; i++){
			z_skupina += ary_z_skupina[i] + ",";
		}
		z_skupina = z_skupina.substring(0,z_skupina.length()-1);
	}
	this_search_criteria = "";
	if (x_skupina.length() > 0) {
		String srchFld = x_skupina;
		this_search_criteria = "x_skupina=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_skupina=" + URLEncoder.encode(z_skupina,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// skupina_text
	if (request.getParameter("x_skupina_text") != null){
		x_skupina_text = request.getParameter("x_skupina_text");
	}
	String z_skupina_text = "";
	if (request.getParameterValues("z_skupina_text") != null){
		String [] ary_z_skupina_text = request.getParameterValues("z_skupina_text");
		for (int i =0; i < ary_z_skupina_text.length; i++){
			z_skupina_text += ary_z_skupina_text[i] + ",";
		}
		z_skupina_text = z_skupina_text.substring(0,z_skupina_text.length()-1);
	}
	this_search_criteria = "";
	if (x_skupina_text.length() > 0) {
		String srchFld = x_skupina_text;
		this_search_criteria = "x_skupina_text=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_skupina_text=" + URLEncoder.encode(z_skupina_text,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// opomba
	if (request.getParameter("x_opomba") != null){
		x_opomba = request.getParameter("x_opomba");
	}
	String z_opomba = "";
	if (request.getParameterValues("z_opomba") != null){
		String [] ary_z_opomba = request.getParameterValues("z_opomba");
		for (int i =0; i < ary_z_opomba.length; i++){
			z_opomba += ary_z_opomba[i] + ",";
		}
		z_opomba = z_opomba.substring(0,z_opomba.length()-1);
	}
	this_search_criteria = "";
	if (x_opomba.length() > 0) {
		String srchFld = x_opomba;
		this_search_criteria = "x_opomba=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_opomba=" + URLEncoder.encode(z_opomba,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// stev_km_sled
	if (request.getParameter("x_stev_km_sled") != null){
		x_stev_km_sled = request.getParameter("x_stev_km_sled");
	}
	String z_stev_km_sled = "";
	if (request.getParameterValues("z_stev_km_sled") != null){
		String [] ary_z_stev_km_sled = request.getParameterValues("z_stev_km_sled");
		for (int i =0; i < ary_z_stev_km_sled.length; i++){
			z_stev_km_sled += ary_z_stev_km_sled[i] + ",";
		}
		z_stev_km_sled = z_stev_km_sled.substring(0,z_stev_km_sled.length()-1);
	}
	this_search_criteria = "";
	if (x_stev_km_sled.length() > 0) {
		String srchFld = x_stev_km_sled;
		this_search_criteria = "x_stev_km_sled=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_stev_km_sled=" + URLEncoder.encode(z_stev_km_sled,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// stev_ur_sled
	if (request.getParameter("x_stev_ur_sled") != null){
		x_stev_ur_sled = request.getParameter("x_stev_ur_sled");
	}
	String z_stev_ur_sled = "";
	if (request.getParameterValues("z_stev_ur_sled") != null){
		String [] ary_z_stev_ur_sled = request.getParameterValues("z_stev_ur_sled");
		for (int i =0; i < ary_z_stev_ur_sled.length; i++){
			z_stev_ur_sled += ary_z_stev_ur_sled[i] + ",";
		}
		z_stev_ur_sled = z_stev_ur_sled.substring(0,z_stev_ur_sled.length()-1);
	}
	this_search_criteria = "";
	if (x_stev_ur_sled.length() > 0) {
		String srchFld = x_stev_ur_sled;
		this_search_criteria = "x_stev_ur_sled=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_stev_ur_sled=" + URLEncoder.encode(z_stev_ur_sled,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}
	if (search_criteria.length() > 0) {
		out.clear();
		response.sendRedirect("doblist.jsp" + "?" + search_criteria);
		response.flushBuffer();
		return;
	}
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Search >Pregled: dob<br><br><a href="doblist.jsp">Nazaj na pregled</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_st_dob && !EW_checkinteger(EW_this.x_st_dob.value)) {
        if (!EW_onError(EW_this, EW_this.x_st_dob, "TEXT", "Napačna številka - st dob"))
            return false; 
        }
if (EW_this.x_pozicija && !EW_checkinteger(EW_this.x_pozicija.value)) {
        if (!EW_onError(EW_this, EW_this.x_pozicija, "TEXT", "Napačna številka - pozicija"))
            return false; 
        }
if (EW_this.x_datum && !EW_checkeurodate(EW_this.x_datum.value)) {
        if (!EW_onError(EW_this, EW_this.x_datum, "TEXT", "Napačen datum (dd.mm.yyyy) - datum"))
            return false; 
        }
if (EW_this.x_cena_km && !EW_checkinteger(EW_this.x_cena_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_km, "TEXT", "Napačna številka - cena km"))
            return false; 
        }
if (EW_this.x_cena_ura && !EW_checkinteger(EW_this.x_cena_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena_ura, "TEXT", "Napačna številka - cena ura"))
            return false; 
        }
if (EW_this.x_c_km && !EW_checkinteger(EW_this.x_c_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_km, "TEXT", "Napačna številka - c km"))
            return false; 
        }
if (EW_this.x_c_ura && !EW_checkinteger(EW_this.x_c_ura.value)) {
        if (!EW_onError(EW_this, EW_this.x_c_ura, "TEXT", "Napačna številka - c ura"))
            return false; 
        }
if (EW_this.x_stev_km && !EW_checkinteger(EW_this.x_stev_km.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_km, "TEXT", "Napačna številka - stev km"))
            return false; 
        }
if (EW_this.x_stev_ur && !EW_checkinteger(EW_this.x_stev_ur.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_ur, "TEXT", "Napačna številka - stev ur"))
            return false; 
        }
if (EW_this.x_stroski && !EW_checkinteger(EW_this.x_stroski.value)) {
        if (!EW_onError(EW_this, EW_this.x_stroski, "TEXT", "Napačna številka - stroski"))
            return false; 
        }
if (EW_this.x_kolicina && !EW_checkinteger(EW_this.x_kolicina.value)) {
        if (!EW_onError(EW_this, EW_this.x_kolicina, "TEXT", "Napačna številka - kolicina"))
            return false; 
        }
if (EW_this.x_cena && !EW_checkinteger(EW_this.x_cena.value)) {
        if (!EW_onError(EW_this, EW_this.x_cena, "TEXT", "Napačna številka - cena"))
            return false; 
        }
if (EW_this.x_kg_zaup && !EW_checkinteger(EW_this.x_kg_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_kg_zaup, "TEXT", "Napačna številka - kg zaup"))
            return false; 
        }
if (EW_this.x_sit_zaup && !EW_checkinteger(EW_this.x_sit_zaup.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_zaup, "TEXT", "Napačna številka - sit zaup"))
            return false; 
        }
if (EW_this.x_kg_sort && !EW_checkinteger(EW_this.x_kg_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_kg_sort, "TEXT", "Napačna številka - kg sort"))
            return false; 
        }
if (EW_this.x_sit_sort && !EW_checkinteger(EW_this.x_sit_sort.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_sort, "TEXT", "Napačna številka - sit sort"))
            return false; 
        }
if (EW_this.x_sit_smet && !EW_checkinteger(EW_this.x_sit_smet.value)) {
        if (!EW_onError(EW_this, EW_this.x_sit_smet, "TEXT", "Napačna številka - sit smet"))
            return false; 
        }
if (EW_this.x_stev_km_sled && !EW_checkinteger(EW_this.x_stev_km_sled.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_km_sled, "TEXT", "Napačna številka - stev km sled"))
            return false; 
        }
if (EW_this.x_stev_ur_sled && !EW_checkinteger(EW_this.x_stev_ur_sled.value)) {
        if (!EW_onError(EW_this, EW_this.x_stev_ur_sled, "TEXT", "Napačna številka - stev ur sled"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="dobsrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table class="ewTable">
	<tr>
		<td class="ewTableHeader">Številka dobavnice&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_st_dob" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_st_dob" size="30" value="<%= HTMLEncode((String)x_st_dob) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Pozicija&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_pozicija" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_pozicija" size="30" value="<%= HTMLEncode((String)x_pozicija) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Datum&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_datum" value="=, ','">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_datum" value="<%= EW_FormatDateTime(x_datum,7, locale) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra stranke&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_sif_str" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_sif_str_js = "";
String x_sif_strList = "<select name=\"x_sif_str\"><option value=\"\">Izberi</option>";
String sqlwrk_x_sif_str = "SELECT `sif_str`, `naziv` FROM `stranke`" + " ORDER BY `naziv` ASC";
Statement stmtwrk_x_sif_str = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_str = stmtwrk_x_sif_str.executeQuery(sqlwrk_x_sif_str);
	int rowcntwrk_x_sif_str = 0;
	while (rswrk_x_sif_str.next()) {
		x_sif_strList += "<option value=\"" + HTMLEncode(rswrk_x_sif_str.getString("sif_str")) + "\"";
		if (rswrk_x_sif_str.getString("sif_str").equals(x_sif_str)) {
			x_sif_strList += " selected";
		}
		String tmpValue_x_sif_str = "";
		if (rswrk_x_sif_str.getString("naziv")!= null) tmpValue_x_sif_str = rswrk_x_sif_str.getString("naziv");
		x_sif_strList += ">" + tmpValue_x_sif_str
 + "</option>";
		rowcntwrk_x_sif_str++;
	}
rswrk_x_sif_str.close();
rswrk_x_sif_str = null;
stmtwrk_x_sif_str.close();
stmtwrk_x_sif_str = null;
x_sif_strList += "</select>";
out.println(x_sif_strList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stranka&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_stranka" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stranka" size="30" maxlength="255" value="<%= HTMLEncode((String)x_stranka) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kupca&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_sif_kupca" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_sif_kupca_js = "";
String x_sif_kupcaList = "<select name=\"x_sif_kupca\"><option value=\"\">Izberi</option>";
String sqlwrk_x_sif_kupca = "SELECT `naziv` FROM `kupci`" + " ORDER BY `naziv` ASC";
Statement stmtwrk_x_sif_kupca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_kupca = stmtwrk_x_sif_kupca.executeQuery(sqlwrk_x_sif_kupca);
	int rowcntwrk_x_sif_kupca = 0;
	while (rswrk_x_sif_kupca.next()) {
		x_sif_kupcaList += "<option value=\"" + HTMLEncode(rswrk_x_sif_kupca.getString("naziv")) + "\"";
		if (rswrk_x_sif_kupca.getString("naziv").equals(x_sif_kupca)) {
			x_sif_kupcaList += " selected";
		}
		String tmpValue_x_sif_kupca = "";
		if (rswrk_x_sif_kupca.getString("naziv")!= null) tmpValue_x_sif_kupca = rswrk_x_sif_kupca.getString("naziv");
		x_sif_kupcaList += ">" + tmpValue_x_sif_kupca
 + "</option>";
		rowcntwrk_x_sif_kupca++;
	}
rswrk_x_sif_kupca.close();
rswrk_x_sif_kupca = null;
stmtwrk_x_sif_kupca.close();
stmtwrk_x_sif_kupca = null;
x_sif_kupcaList += "</select>";
out.println(x_sif_kupcaList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra šoferja&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_sif_sof" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_sif_sof_js = "";
String x_sif_sofList = "<select name=\"x_sif_sof\"><option value=\"\">Izberi</option>";
String sqlwrk_x_sif_sof = "SELECT `sif_sof`, `sofer` FROM `sofer`";
Statement stmtwrk_x_sif_sof = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_sof = stmtwrk_x_sif_sof.executeQuery(sqlwrk_x_sif_sof);
	int rowcntwrk_x_sif_sof = 0;
	while (rswrk_x_sif_sof.next()) {
		x_sif_sofList += "<option value=\"" + HTMLEncode(rswrk_x_sif_sof.getString("sif_sof")) + "\"";
		if (rswrk_x_sif_sof.getString("sif_sof").equals(x_sif_sof)) {
			x_sif_sofList += " selected";
		}
		String tmpValue_x_sif_sof = "";
		if (rswrk_x_sif_sof.getString("sofer")!= null) tmpValue_x_sif_sof = rswrk_x_sif_sof.getString("sofer");
		x_sif_sofList += ">" + tmpValue_x_sif_sof
 + "</option>";
		rowcntwrk_x_sif_sof++;
	}
rswrk_x_sif_sof.close();
rswrk_x_sif_sof = null;
stmtwrk_x_sif_sof.close();
stmtwrk_x_sif_sof = null;
x_sif_sofList += "</select>";
out.println(x_sif_sofList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šofer&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_sofer" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sofer" size="30" maxlength="255" value="<%= HTMLEncode((String)x_sofer) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Šifra kamiona&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_sif_kam" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_sif_kam_js = "";
String x_sif_kamList = "<select name=\"x_sif_kam\"><option value=\"\">Izberi</option>";
String sqlwrk_x_sif_kam = "SELECT `sif_kam`, `kamion` FROM `kamion`" + " ORDER BY `cena_km` DESC";
Statement stmtwrk_x_sif_kam = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_sif_kam = stmtwrk_x_sif_kam.executeQuery(sqlwrk_x_sif_kam);
	int rowcntwrk_x_sif_kam = 0;
	while (rswrk_x_sif_kam.next()) {
		x_sif_kamList += "<option value=\"" + HTMLEncode(rswrk_x_sif_kam.getString("sif_kam")) + "\"";
		if (rswrk_x_sif_kam.getString("sif_kam").equals(x_sif_kam)) {
			x_sif_kamList += " selected";
		}
		String tmpValue_x_sif_kam = "";
		if (rswrk_x_sif_kam.getString("kamion")!= null) tmpValue_x_sif_kam = rswrk_x_sif_kam.getString("kamion");
		x_sif_kamList += ">" + tmpValue_x_sif_kam
 + "</option>";
		rowcntwrk_x_sif_kam++;
	}
rswrk_x_sif_kam.close();
rswrk_x_sif_kam = null;
stmtwrk_x_sif_kam.close();
stmtwrk_x_sif_kam = null;
x_sif_kamList += "</select>";
out.println(x_sif_kamList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Kamion&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_kamion" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kamion" size="30" maxlength="255" value="<%= HTMLEncode((String)x_kamion) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na km&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_cena_km" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_km" size="30" value="<%= HTMLEncode((String)x_cena_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena na uro&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_cena_ura" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena_ura" size="30" value="<%= HTMLEncode((String)x_cena_ura) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">c km&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_c_km" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_c_km" size="30" value="<%= HTMLEncode((String)x_c_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">c ura&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_c_ura" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_c_ura" size="30" value="<%= HTMLEncode((String)x_c_ura) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število kilometrov&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_stev_km" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_km" size="30" value="<%= HTMLEncode((String)x_stev_km) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_stev_ur" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_ur" size="30" value="<%= HTMLEncode((String)x_stev_ur) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Stroški&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_stroski" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stroski" size="30" value="<%= HTMLEncode((String)x_stroski) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Koda&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_koda" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_koda_js = "";
String x_kodaList = "<select name=\"x_koda\"><option value=\"\">Izberi</option>";
String sqlwrk_x_koda = "SELECT `koda`, `material` FROM `materiali`" + " ORDER BY `material` ASC";
Statement stmtwrk_x_koda = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_koda = stmtwrk_x_koda.executeQuery(sqlwrk_x_koda);
	int rowcntwrk_x_koda = 0;
	while (rswrk_x_koda.next()) {
		x_kodaList += "<option value=\"" + HTMLEncode(rswrk_x_koda.getString("koda")) + "\"";
		if (rswrk_x_koda.getString("koda").equals(x_koda)) {
			x_kodaList += " selected";
		}
		String tmpValue_x_koda = "";
		if (rswrk_x_koda.getString("material")!= null) tmpValue_x_koda = rswrk_x_koda.getString("material");
		x_kodaList += ">" + tmpValue_x_koda
 + "</option>";
		rowcntwrk_x_koda++;
	}
rswrk_x_koda.close();
rswrk_x_koda = null;
stmtwrk_x_koda.close();
stmtwrk_x_koda = null;
x_kodaList += "</select>";
out.println(x_kodaList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Količina&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_kolicina" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kolicina" size="30" value="<%= HTMLEncode((String)x_kolicina) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Cena&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_cena" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_cena" size="30" value="<%= HTMLEncode((String)x_cena) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">kg zaup&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_kg_zaup" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kg_zaup" size="30" value="<%= HTMLEncode((String)x_kg_zaup) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit zaup&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_sit_zaup" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_zaup" size="30" value="<%= HTMLEncode((String)x_sit_zaup) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">kg sort&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_kg_sort" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_kg_sort" size="30" value="<%= HTMLEncode((String)x_kg_sort) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit sort&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_sit_sort" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_sort" size="30" value="<%= HTMLEncode((String)x_sit_sort) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">sit smet&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_sit_smet" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_sit_smet" size="30" value="<%= HTMLEncode((String)x_sit_smet) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_skupina" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><%
String cbo_x_skupina_js = "";
String x_skupinaList = "<select name=\"x_skupina\"><option value=\"\">Izberi</option>";
String sqlwrk_x_skupina = "SELECT `skupina` FROM `skup`";
Statement stmtwrk_x_skupina = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_skupina = stmtwrk_x_skupina.executeQuery(sqlwrk_x_skupina);
	int rowcntwrk_x_skupina = 0;
	while (rswrk_x_skupina.next()) {
		x_skupinaList += "<option value=\"" + HTMLEncode(rswrk_x_skupina.getString("skupina")) + "\"";
		if (rswrk_x_skupina.getString("skupina").equals(x_skupina)) {
			x_skupinaList += " selected";
		}
		String tmpValue_x_skupina = "";
		if (rswrk_x_skupina.getString("skupina")!= null) tmpValue_x_skupina = rswrk_x_skupina.getString("skupina");
		x_skupinaList += ">" + tmpValue_x_skupina
 + "</option>";
		rowcntwrk_x_skupina++;
	}
rswrk_x_skupina.close();
rswrk_x_skupina = null;
stmtwrk_x_skupina.close();
stmtwrk_x_skupina = null;
x_skupinaList += "</select>";
out.println(x_skupinaList);
%>
&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Skupina&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_skupina_text" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_skupina_text" size="30" maxlength="255" value="<%= HTMLEncode((String)x_skupina_text) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Opomba&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_opomba" value="LIKE, '%,%'">LIKE
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_opomba" size="30" maxlength="255" value="<%= HTMLEncode((String)x_opomba) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število kilometrov sled&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_stev_km_sled" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_km_sled" size="30" value="<%= HTMLEncode((String)x_stev_km_sled) %>">&nbsp;</td>
	</tr>
	<tr>
		<td class="ewTableHeader">Število ur sledenja&nbsp;</td>
		<td class="ewTableAltRow">
<input type="hidden" name="z_stev_ur_sled" value="=, , ">=
&nbsp;</td>
		<td class="ewTableAltRow"><input type="text" name="x_stev_ur_sled" size="30" value="<%= HTMLEncode((String)x_stev_ur_sled) %>">&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Search">
</form>
<%@ include file="footer.jsp" %>
<%
	//conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
