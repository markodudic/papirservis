/**
 * SledenjeAuTokenWSServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class SledenjeAuTokenWSServiceLocator extends org.apache.axis.client.Service implements com.sledenje.ws.SledenjeAuTokenWSService {

    public SledenjeAuTokenWSServiceLocator() {
    }


    public SledenjeAuTokenWSServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public SledenjeAuTokenWSServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for SledenjeAuTokenWSPort
    private java.lang.String SledenjeAuTokenWSPort_address = "http://apps.sledenje.com:80/SledenjeWSS/SledenjeAuTokenWS";

    public java.lang.String getSledenjeAuTokenWSPortAddress() {
        return SledenjeAuTokenWSPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String SledenjeAuTokenWSPortWSDDServiceName = "SledenjeAuTokenWSPort";

    public java.lang.String getSledenjeAuTokenWSPortWSDDServiceName() {
        return SledenjeAuTokenWSPortWSDDServiceName;
    }

    public void setSledenjeAuTokenWSPortWSDDServiceName(java.lang.String name) {
        SledenjeAuTokenWSPortWSDDServiceName = name;
    }

    public com.sledenje.ws.SledenjeAuTokenWS getSledenjeAuTokenWSPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(SledenjeAuTokenWSPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getSledenjeAuTokenWSPort(endpoint);
    }

    public com.sledenje.ws.SledenjeAuTokenWS getSledenjeAuTokenWSPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.sledenje.ws.SledenjeAuTokenWSPortBindingStub _stub = new com.sledenje.ws.SledenjeAuTokenWSPortBindingStub(portAddress, this);
            _stub.setPortName(getSledenjeAuTokenWSPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setSledenjeAuTokenWSPortEndpointAddress(java.lang.String address) {
        SledenjeAuTokenWSPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.sledenje.ws.SledenjeAuTokenWS.class.isAssignableFrom(serviceEndpointInterface)) {
                com.sledenje.ws.SledenjeAuTokenWSPortBindingStub _stub = new com.sledenje.ws.SledenjeAuTokenWSPortBindingStub(new java.net.URL(SledenjeAuTokenWSPort_address), this);
                _stub.setPortName(getSledenjeAuTokenWSPortWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("SledenjeAuTokenWSPort".equals(inputPortName)) {
            return getSledenjeAuTokenWSPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://ws.sledenje.com/", "SledenjeAuTokenWSService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://ws.sledenje.com/", "SledenjeAuTokenWSPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("SledenjeAuTokenWSPort".equals(portName)) {
            setSledenjeAuTokenWSPortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
