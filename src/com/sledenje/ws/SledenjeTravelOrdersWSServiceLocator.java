/**
 * SledenjeTravelOrdersWSServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class SledenjeTravelOrdersWSServiceLocator extends org.apache.axis.client.Service implements com.sledenje.ws.SledenjeTravelOrdersWSService {

    public SledenjeTravelOrdersWSServiceLocator() {
    }


    public SledenjeTravelOrdersWSServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public SledenjeTravelOrdersWSServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for SledenjeTravelOrdersWSPort
    private java.lang.String SledenjeTravelOrdersWSPort_address = "http://apps.sledenje.com:80/SledenjeWSS/SledenjeTravelOrdersWS";

    public java.lang.String getSledenjeTravelOrdersWSPortAddress() {
        return SledenjeTravelOrdersWSPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String SledenjeTravelOrdersWSPortWSDDServiceName = "SledenjeTravelOrdersWSPort";

    public java.lang.String getSledenjeTravelOrdersWSPortWSDDServiceName() {
        return SledenjeTravelOrdersWSPortWSDDServiceName;
    }

    public void setSledenjeTravelOrdersWSPortWSDDServiceName(java.lang.String name) {
        SledenjeTravelOrdersWSPortWSDDServiceName = name;
    }

    public com.sledenje.ws.SledenjeTravelOrdersWS getSledenjeTravelOrdersWSPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(SledenjeTravelOrdersWSPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getSledenjeTravelOrdersWSPort(endpoint);
    }

    public com.sledenje.ws.SledenjeTravelOrdersWS getSledenjeTravelOrdersWSPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.sledenje.ws.SledenjeTravelOrdersWSPortBindingStub _stub = new com.sledenje.ws.SledenjeTravelOrdersWSPortBindingStub(portAddress, this);
            _stub.setPortName(getSledenjeTravelOrdersWSPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setSledenjeTravelOrdersWSPortEndpointAddress(java.lang.String address) {
        SledenjeTravelOrdersWSPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.sledenje.ws.SledenjeTravelOrdersWS.class.isAssignableFrom(serviceEndpointInterface)) {
                com.sledenje.ws.SledenjeTravelOrdersWSPortBindingStub _stub = new com.sledenje.ws.SledenjeTravelOrdersWSPortBindingStub(new java.net.URL(SledenjeTravelOrdersWSPort_address), this);
                _stub.setPortName(getSledenjeTravelOrdersWSPortWSDDServiceName());
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
        if ("SledenjeTravelOrdersWSPort".equals(inputPortName)) {
            return getSledenjeTravelOrdersWSPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://ws.sledenje.com/", "SledenjeTravelOrdersWSService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://ws.sledenje.com/", "SledenjeTravelOrdersWSPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("SledenjeTravelOrdersWSPort".equals(portName)) {
            setSledenjeTravelOrdersWSPortEndpointAddress(address);
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
