package com.sledenje.ws;

public class SledenjeAuTokenWSProxy implements com.sledenje.ws.SledenjeAuTokenWS {
  private String _endpoint = null;
  private com.sledenje.ws.SledenjeAuTokenWS sledenjeAuTokenWS = null;
  
  public SledenjeAuTokenWSProxy() {
    _initSledenjeAuTokenWSProxy();
  }
  
  public SledenjeAuTokenWSProxy(String endpoint) {
    _endpoint = endpoint;
    _initSledenjeAuTokenWSProxy();
  }
  
  private void _initSledenjeAuTokenWSProxy() {
    try {
      sledenjeAuTokenWS = (new com.sledenje.ws.SledenjeAuTokenWSServiceLocator()).getSledenjeAuTokenWSPort();
      if (sledenjeAuTokenWS != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sledenjeAuTokenWS)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sledenjeAuTokenWS)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sledenjeAuTokenWS != null)
      ((javax.xml.rpc.Stub)sledenjeAuTokenWS)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.sledenje.ws.SledenjeAuTokenWS getSledenjeAuTokenWS() {
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS;
  }
  
  public int setAuToken(java.lang.Integer vozilo_id, java.lang.String name, java.lang.String pwd, java.lang.String expire) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException, com.sledenje.ws.WSUniqueConstraintException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.setAuToken(vozilo_id, name, pwd, expire);
  }
  
  public com.sledenje.ws.AuToken[] getAuTokens(java.lang.Integer vehgr_id, java.lang.Integer usergr_id, java.lang.Integer voz_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getAuTokens(vehgr_id, usergr_id, voz_id);
  }
  
  public com.sledenje.ws.AuToken isAuToken(java.lang.String name, java.lang.String pwd) throws java.rmi.RemoteException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.isAuToken(name, pwd);
  }
  
  public com.sledenje.ws.GpsDevicesList getLastPosition(java.lang.String ident) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getLastPosition(ident);
  }
  
  public java.lang.Integer login(java.lang.String user, java.lang.String psw) throws java.rmi.RemoteException, com.sledenje.ws.WSInvalidAuthenticationException, com.sledenje.ws.WSDatabaseErrorException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.login(user, psw);
  }
  
  public void logout() throws java.rmi.RemoteException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    sledenjeAuTokenWS.logout();
  }
  
  public com.sledenje.ws.Company[] getCompanyLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getCompanyLogin();
  }
  
  public com.sledenje.ws.User[] getUserLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getUserLogin();
  }
  
  public com.sledenje.ws.User[] getCompanyUsersLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getCompanyUsersLogin();
  }
  
  public com.sledenje.ws.VehicleGroup[] getCompanyVehicleGroupsLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getCompanyVehicleGroupsLogin();
  }
  
  public com.sledenje.ws.Driver[] getCompanyDriversLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getCompanyDriversLogin();
  }
  
  public java.lang.Integer getCompanyID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getCompanyID();
  }
  
  public java.lang.Integer getUserID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException{
    if (sledenjeAuTokenWS == null)
      _initSledenjeAuTokenWSProxy();
    return sledenjeAuTokenWS.getUserID();
  }
  
  
}