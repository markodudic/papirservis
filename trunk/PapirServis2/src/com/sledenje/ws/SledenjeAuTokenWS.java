/**
 * SledenjeAuTokenWS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public interface SledenjeAuTokenWS extends java.rmi.Remote {
    public int setAuToken(java.lang.Integer vozilo_id, java.lang.String name, java.lang.String pwd, java.lang.String expire) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException, com.sledenje.ws.WSUniqueConstraintException;
    public com.sledenje.ws.AuToken[] getAuTokens(java.lang.Integer vehgr_id, java.lang.Integer usergr_id, java.lang.Integer voz_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.AuToken isAuToken(java.lang.String name, java.lang.String pwd) throws java.rmi.RemoteException, com.sledenje.ws.WSException;
    public com.sledenje.ws.GpsDevicesList getLastPosition(java.lang.String ident) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public java.lang.Integer login(java.lang.String user, java.lang.String psw) throws java.rmi.RemoteException, com.sledenje.ws.WSInvalidAuthenticationException, com.sledenje.ws.WSDatabaseErrorException;
    public void logout() throws java.rmi.RemoteException, com.sledenje.ws.WSException;
    public com.sledenje.ws.Company[] getCompanyLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.User[] getUserLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.User[] getCompanyUsersLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.VehicleGroup[] getCompanyVehicleGroupsLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public com.sledenje.ws.Driver[] getCompanyDriversLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException;
    public java.lang.Integer getCompanyID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException;
    public java.lang.Integer getUserID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException;
}
