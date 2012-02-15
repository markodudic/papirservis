package com.sledenje.ws;

public class SledenjeTravelOrdersWSProxy implements com.sledenje.ws.SledenjeTravelOrdersWS {
  private String _endpoint = null;
  private com.sledenje.ws.SledenjeTravelOrdersWS sledenjeTravelOrdersWS = null;
  
  public SledenjeTravelOrdersWSProxy() {
    _initSledenjeTravelOrdersWSProxy();
  }
  
  public SledenjeTravelOrdersWSProxy(String endpoint) {
    _endpoint = endpoint;
    _initSledenjeTravelOrdersWSProxy();
  }
  
  private void _initSledenjeTravelOrdersWSProxy() {
    try {
      sledenjeTravelOrdersWS = (new com.sledenje.ws.SledenjeTravelOrdersWSServiceLocator()).getSledenjeTravelOrdersWSPort();
      if (sledenjeTravelOrdersWS != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sledenjeTravelOrdersWS)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sledenjeTravelOrdersWS)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sledenjeTravelOrdersWS != null)
      ((javax.xml.rpc.Stub)sledenjeTravelOrdersWS)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.sledenje.ws.SledenjeTravelOrdersWS getSledenjeTravelOrdersWS() {
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS;
  }
  
  public com.sledenje.ws.TravelOrder[] getTravelOrders(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getTravelOrders(fromDate, toDate, vehgr_id, to_id, veh_id);
  }
  
  public int addTravelOrder(java.lang.Integer id, java.lang.Integer vehicle_id, java.lang.String to_ident, java.lang.String to_from, java.lang.String to_to, java.lang.String route, java.lang.String to_user, java.lang.String driver, java.lang.Integer km_start, java.lang.Integer km_end, java.lang.String descr, java.lang.Double advan_expen, java.lang.Double mileage_expen, java.lang.String report, java.lang.Integer km_diff, java.lang.Integer km_diff_s, java.lang.Integer km_diff_p) throws java.rmi.RemoteException, com.sledenje.ws.WSVehicleOdoIntersectedByTravelOrderException, com.sledenje.ws.WSUnauthorisedVehicleException, com.sledenje.ws.WSTravelOrderAlreadyExistsException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.addTravelOrder(id, vehicle_id, to_ident, to_from, to_to, route, to_user, driver, km_start, km_end, descr, advan_expen, mileage_expen, report, km_diff, km_diff_s, km_diff_p);
  }
  
  public int deleteTravelOrder(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedTravelOrderException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.deleteTravelOrder(id);
  }
  
  public com.sledenje.ws.MileageType[] getMileageTypes(java.lang.Integer miletype_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getMileageTypes(miletype_id);
  }
  
  public com.sledenje.ws.TravelOrderRelation[] getTravelOrderRelations(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id, java.lang.Integer to_rel_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getTravelOrderRelations(fromDate, toDate, vehgr_id, to_id, veh_id, to_rel_id);
  }
  
  public int addTravelOrderRelation(java.lang.Integer id, java.lang.Integer order_id, java.lang.String time_from, java.lang.String time_to, java.lang.Integer dist_km, java.lang.String travel_type, java.lang.String descr, java.lang.String point_start, java.lang.String point_end, java.lang.Double load_amount, java.lang.Integer load_km, java.lang.Double daily_allow, java.lang.Double daily_allow_reduced, java.lang.String daily_allow_descr, java.lang.String daily_allow_reduced_descr, java.lang.Integer daily_allow_id) throws java.rmi.RemoteException, com.sledenje.ws.WSTravelOrderAlreadyExistsException, com.sledenje.ws.WSUnauthorisedTravelOrderException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.addTravelOrderRelation(id, order_id, time_from, time_to, dist_km, travel_type, descr, point_start, point_end, load_amount, load_km, daily_allow, daily_allow_reduced, daily_allow_descr, daily_allow_reduced_descr, daily_allow_id);
  }
  
  public int deleteTravelOrderRelation(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedTravelOrderRelationException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.deleteTravelOrderRelation(id);
  }
  
  public com.sledenje.ws.DailyAllowance[] getDailyAllowances(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer dailyallow_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getDailyAllowances(fromDate, toDate, dailyallow_id);
  }
  
  public com.sledenje.ws.TravelOrderPrint[] getTravelOrderPrints(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getTravelOrderPrints(fromDate, toDate, vehgr_id, to_id, veh_id);
  }
  
  public com.sledenje.ws.TravelOrderRelation[] getDailyAllowanceRelations(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer veh_id, java.lang.Boolean includeSLO) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getDailyAllowanceRelations(fromDate, toDate, veh_id, includeSLO);
  }
  
  public com.sledenje.ws.TravelOrderRelation[] getTravelOrderStops(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getTravelOrderStops(fromDate, toDate, veh_id);
  }
  
  public com.sledenje.ws.TravelOrderRelation[] getTravelOrderStopsIdent(java.lang.String fromDate, java.lang.String toDate, java.lang.String p_ident_naprave, java.lang.Integer p_voznje, java.lang.Integer p_razlika, java.lang.Integer p_hitrost, java.lang.Integer p_obdobje, java.lang.Integer p_obdelava_polnoci) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getTravelOrderStopsIdent(fromDate, toDate, p_ident_naprave, p_voznje, p_razlika, p_hitrost, p_obdobje, p_obdelava_polnoci);
  }
  
  public com.sledenje.ws.VehicleOdo[] getVehicleOdos(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer vo_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getVehicleOdos(fromDate, toDate, vehgr_id, vo_id, veh_id);
  }
  
  public int addVehicleOdo(java.lang.Integer id, java.lang.Integer vehicle_id, java.lang.String odo_date, java.lang.Integer odo_km) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedVehicleException, com.sledenje.ws.WSTravelOrderIntersectedByVehicleOdoException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException, com.sledenje.ws.WSVehicleOdoDecreasingKmException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.addVehicleOdo(id, vehicle_id, odo_date, odo_km);
  }
  
  public int deleteVehicleOdo(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedVehicleOdoException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.deleteVehicleOdo(id);
  }
  
  public java.lang.Integer login(java.lang.String user, java.lang.String psw) throws java.rmi.RemoteException, com.sledenje.ws.WSInvalidAuthenticationException, com.sledenje.ws.WSDatabaseErrorException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.login(user, psw);
  }
  
  public void logout() throws java.rmi.RemoteException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    sledenjeTravelOrdersWS.logout();
  }
  
  public com.sledenje.ws.Company[] getCompanyLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getCompanyLogin();
  }
  
  public com.sledenje.ws.User[] getUserLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getUserLogin();
  }
  
  public com.sledenje.ws.User[] getCompanyUsersLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getCompanyUsersLogin();
  }
  
  public com.sledenje.ws.VehicleGroup[] getCompanyVehicleGroupsLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getCompanyVehicleGroupsLogin();
  }
  
  public com.sledenje.ws.Driver[] getCompanyDriversLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getCompanyDriversLogin();
  }
  
  public java.lang.Integer getCompanyID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getCompanyID();
  }
  
  public java.lang.Integer getUserID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.getUserID();
  }
  
  public java.lang.String appBuildDate() throws java.rmi.RemoteException{
    if (sledenjeTravelOrdersWS == null)
      _initSledenjeTravelOrdersWSProxy();
    return sledenjeTravelOrdersWS.appBuildDate();
  }
  
  
}