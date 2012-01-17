/**
 * GpsDevice.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class GpsDevice  implements java.io.Serializable {
    private int devicedistance;

    private java.lang.String deviceehis;

    private int devicegid;

    private java.lang.String deviceident;

    private java.lang.String devicelpdate;

    private java.lang.String devicename;

    private int devicespeed;

    private double devicex;

    private double devicey;

    private int senzor;

    public GpsDevice() {
    }

    public GpsDevice(
           int devicedistance,
           java.lang.String deviceehis,
           int devicegid,
           java.lang.String deviceident,
           java.lang.String devicelpdate,
           java.lang.String devicename,
           int devicespeed,
           double devicex,
           double devicey,
           int senzor) {
           this.devicedistance = devicedistance;
           this.deviceehis = deviceehis;
           this.devicegid = devicegid;
           this.deviceident = deviceident;
           this.devicelpdate = devicelpdate;
           this.devicename = devicename;
           this.devicespeed = devicespeed;
           this.devicex = devicex;
           this.devicey = devicey;
           this.senzor = senzor;
    }


    /**
     * Gets the devicedistance value for this GpsDevice.
     * 
     * @return devicedistance
     */
    public int getDevicedistance() {
        return devicedistance;
    }


    /**
     * Sets the devicedistance value for this GpsDevice.
     * 
     * @param devicedistance
     */
    public void setDevicedistance(int devicedistance) {
        this.devicedistance = devicedistance;
    }


    /**
     * Gets the deviceehis value for this GpsDevice.
     * 
     * @return deviceehis
     */
    public java.lang.String getDeviceehis() {
        return deviceehis;
    }


    /**
     * Sets the deviceehis value for this GpsDevice.
     * 
     * @param deviceehis
     */
    public void setDeviceehis(java.lang.String deviceehis) {
        this.deviceehis = deviceehis;
    }


    /**
     * Gets the devicegid value for this GpsDevice.
     * 
     * @return devicegid
     */
    public int getDevicegid() {
        return devicegid;
    }


    /**
     * Sets the devicegid value for this GpsDevice.
     * 
     * @param devicegid
     */
    public void setDevicegid(int devicegid) {
        this.devicegid = devicegid;
    }


    /**
     * Gets the deviceident value for this GpsDevice.
     * 
     * @return deviceident
     */
    public java.lang.String getDeviceident() {
        return deviceident;
    }


    /**
     * Sets the deviceident value for this GpsDevice.
     * 
     * @param deviceident
     */
    public void setDeviceident(java.lang.String deviceident) {
        this.deviceident = deviceident;
    }


    /**
     * Gets the devicelpdate value for this GpsDevice.
     * 
     * @return devicelpdate
     */
    public java.lang.String getDevicelpdate() {
        return devicelpdate;
    }


    /**
     * Sets the devicelpdate value for this GpsDevice.
     * 
     * @param devicelpdate
     */
    public void setDevicelpdate(java.lang.String devicelpdate) {
        this.devicelpdate = devicelpdate;
    }


    /**
     * Gets the devicename value for this GpsDevice.
     * 
     * @return devicename
     */
    public java.lang.String getDevicename() {
        return devicename;
    }


    /**
     * Sets the devicename value for this GpsDevice.
     * 
     * @param devicename
     */
    public void setDevicename(java.lang.String devicename) {
        this.devicename = devicename;
    }


    /**
     * Gets the devicespeed value for this GpsDevice.
     * 
     * @return devicespeed
     */
    public int getDevicespeed() {
        return devicespeed;
    }


    /**
     * Sets the devicespeed value for this GpsDevice.
     * 
     * @param devicespeed
     */
    public void setDevicespeed(int devicespeed) {
        this.devicespeed = devicespeed;
    }


    /**
     * Gets the devicex value for this GpsDevice.
     * 
     * @return devicex
     */
    public double getDevicex() {
        return devicex;
    }


    /**
     * Sets the devicex value for this GpsDevice.
     * 
     * @param devicex
     */
    public void setDevicex(double devicex) {
        this.devicex = devicex;
    }


    /**
     * Gets the devicey value for this GpsDevice.
     * 
     * @return devicey
     */
    public double getDevicey() {
        return devicey;
    }


    /**
     * Sets the devicey value for this GpsDevice.
     * 
     * @param devicey
     */
    public void setDevicey(double devicey) {
        this.devicey = devicey;
    }


    /**
     * Gets the senzor value for this GpsDevice.
     * 
     * @return senzor
     */
    public int getSenzor() {
        return senzor;
    }


    /**
     * Sets the senzor value for this GpsDevice.
     * 
     * @param senzor
     */
    public void setSenzor(int senzor) {
        this.senzor = senzor;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GpsDevice)) return false;
        GpsDevice other = (GpsDevice) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.devicedistance == other.getDevicedistance() &&
            ((this.deviceehis==null && other.getDeviceehis()==null) || 
             (this.deviceehis!=null &&
              this.deviceehis.equals(other.getDeviceehis()))) &&
            this.devicegid == other.getDevicegid() &&
            ((this.deviceident==null && other.getDeviceident()==null) || 
             (this.deviceident!=null &&
              this.deviceident.equals(other.getDeviceident()))) &&
            ((this.devicelpdate==null && other.getDevicelpdate()==null) || 
             (this.devicelpdate!=null &&
              this.devicelpdate.equals(other.getDevicelpdate()))) &&
            ((this.devicename==null && other.getDevicename()==null) || 
             (this.devicename!=null &&
              this.devicename.equals(other.getDevicename()))) &&
            this.devicespeed == other.getDevicespeed() &&
            this.devicex == other.getDevicex() &&
            this.devicey == other.getDevicey() &&
            this.senzor == other.getSenzor();
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        _hashCode += getDevicedistance();
        if (getDeviceehis() != null) {
            _hashCode += getDeviceehis().hashCode();
        }
        _hashCode += getDevicegid();
        if (getDeviceident() != null) {
            _hashCode += getDeviceident().hashCode();
        }
        if (getDevicelpdate() != null) {
            _hashCode += getDevicelpdate().hashCode();
        }
        if (getDevicename() != null) {
            _hashCode += getDevicename().hashCode();
        }
        _hashCode += getDevicespeed();
        _hashCode += new Double(getDevicex()).hashCode();
        _hashCode += new Double(getDevicey()).hashCode();
        _hashCode += getSenzor();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GpsDevice.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "gpsDevice"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("devicedistance");
        elemField.setXmlName(new javax.xml.namespace.QName("", "devicedistance"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("deviceehis");
        elemField.setXmlName(new javax.xml.namespace.QName("", "deviceehis"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("devicegid");
        elemField.setXmlName(new javax.xml.namespace.QName("", "devicegid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("deviceident");
        elemField.setXmlName(new javax.xml.namespace.QName("", "deviceident"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("devicelpdate");
        elemField.setXmlName(new javax.xml.namespace.QName("", "devicelpdate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("devicename");
        elemField.setXmlName(new javax.xml.namespace.QName("", "devicename"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("devicespeed");
        elemField.setXmlName(new javax.xml.namespace.QName("", "devicespeed"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("devicex");
        elemField.setXmlName(new javax.xml.namespace.QName("", "devicex"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("devicey");
        elemField.setXmlName(new javax.xml.namespace.QName("", "devicey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("senzor");
        elemField.setXmlName(new javax.xml.namespace.QName("", "senzor"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
