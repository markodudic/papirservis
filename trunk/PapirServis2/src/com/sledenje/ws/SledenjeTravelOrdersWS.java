/**
 * SledenjeTravelOrdersWS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public interface SledenjeTravelOrdersWS extends java.rmi.Remote {
    public com.sledenje.ws.TravelOrder[] getTravelOrders(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public int addTravelOrder(java.lang.Integer id, java.lang.Integer vehicle_id, java.lang.String to_ident, java.lang.String to_from, java.lang.String to_to, java.lang.String route, java.lang.String to_user, java.lang.String driver, java.lang.Integer km_start, java.lang.Integer km_end, java.lang.String descr, java.lang.Double advan_expen, java.lang.Double mileage_expen, java.lang.String report, java.lang.Integer km_diff, java.lang.Integer km_diff_s, java.lang.Integer km_diff_p) throws java.rmi.RemoteException, com.sledenje.ws.WSVehicleOdoIntersectedByTravelOrderException, com.sledenje.ws.WSUnauthorisedVehicleException, com.sledenje.ws.WSTravelOrderAlreadyExistsException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public int deleteTravelOrder(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedTravelOrderException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.MileageType[] getMileageTypes(java.lang.Integer miletype_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.TravelOrderRelation[] getTravelOrderRelations(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id, java.lang.Integer to_rel_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public int addTravelOrderRelation(java.lang.Integer id, java.lang.Integer order_id, java.lang.String time_from, java.lang.String time_to, java.lang.Integer dist_km, java.lang.String travel_type, java.lang.String descr, java.lang.String point_start, java.lang.String point_end, java.lang.Double load_amount, java.lang.Integer load_km, java.lang.Double daily_allow, java.lang.Double daily_allow_reduced, java.lang.String daily_allow_descr, java.lang.String daily_allow_reduced_descr, java.lang.Integer daily_allow_id) throws java.rmi.RemoteException, com.sledenje.ws.WSTravelOrderAlreadyExistsException, com.sledenje.ws.WSUnauthorisedTravelOrderException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public int deleteTravelOrderRelation(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedTravelOrderRelationException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.DailyAllowance[] getDailyAllowances(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer dailyallow_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.TravelOrderPrint[] getTravelOrderPrints(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.TravelOrderGroupRelByDA[] getTravelOrderGroupRelByDAs(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.TravelOrderRelation[] getDailyAllowanceRelations(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer veh_id, java.lang.Boolean includeSLO) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.TravelOrderRelation[] getTravelOrderStops(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.TravelOrderRelation[] getTravelOrderStopsIdent(java.lang.String fromDate, java.lang.String toDate, java.lang.String p_ident_naprave, java.lang.Integer p_voznje, java.lang.Integer p_razlika, java.lang.Integer p_hitrost, java.lang.Integer p_obdobje, java.lang.Integer p_obdelava_polnoci) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.VehicleOdo[] getVehicleOdos(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer vo_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public int addVehicleOdo(java.lang.Integer id, java.lang.Integer vehicle_id, java.lang.String odo_date, java.lang.Integer odo_km) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedVehicleException, com.sledenje.ws.WSTravelOrderIntersectedByVehicleOdoException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException, com.sledenje.ws.WSVehicleOdoDecreasingKmException;
    public int deleteVehicleOdo(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedVehicleOdoException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public java.lang.Integer login(java.lang.String user, java.lang.String psw) throws java.rmi.RemoteException, com.sledenje.ws.WSInvalidAuthenticationException, com.sledenje.ws.WSDatabaseErrorException;
    public void logout() throws java.rmi.RemoteException, com.sledenje.ws.WSException;
    public com.sledenje.ws.Company[] getCompanyLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.User[] getUserLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.User[] getCompanyUsersLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.VehicleGroup[] getCompanyVehicleGroupsLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.Driver[] getCompanyDriversLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.Driver[] getCompanyDriversLoginByVehicle(java.lang.Integer voz_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public java.lang.Integer getCompanyID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException;
    public java.lang.Integer getUserID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException;
    public java.lang.String appBuildDate() throws java.rmi.RemoteException;
}
