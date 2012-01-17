/**
 * GpsDevicesList.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class GpsDevicesList  implements java.io.Serializable {
    private com.sledenje.ws.GpsDevice[] devicelist;

    private byte[] image;

    public GpsDevicesList() {
    }

    public GpsDevicesList(
           com.sledenje.ws.GpsDevice[] devicelist,
           byte[] image) {
           this.devicelist = devicelist;
           this.image = image;
    }


    /**
     * Gets the devicelist value for this GpsDevicesList.
     * 
     * @return devicelist
     */
    public com.sledenje.ws.GpsDevice[] getDevicelist() {
        return devicelist;
    }


    /**
     * Sets the devicelist value for this GpsDevicesList.
     * 
     * @param devicelist
     */
    public void setDevicelist(com.sledenje.ws.GpsDevice[] devicelist) {
        this.devicelist = devicelist;
    }

    public com.sledenje.ws.GpsDevice getDevicelist(int i) {
        return this.devicelist[i];
    }

    public void setDevicelist(int i, com.sledenje.ws.GpsDevice _value) {
        this.devicelist[i] = _value;
    }


    /**
     * Gets the image value for this GpsDevicesList.
     * 
     * @return image
     */
    public byte[] getImage() {
        return image;
    }


    /**
     * Sets the image value for this GpsDevicesList.
     * 
     * @param image
     */
    public void setImage(byte[] image) {
        this.image = image;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GpsDevicesList)) return false;
        GpsDevicesList other = (GpsDevicesList) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.devicelist==null && other.getDevicelist()==null) || 
             (this.devicelist!=null &&
              java.util.Arrays.equals(this.devicelist, other.getDevicelist()))) &&
            ((this.image==null && other.getImage()==null) || 
             (this.image!=null &&
              java.util.Arrays.equals(this.image, other.getImage())));
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
        if (getDevicelist() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getDevicelist());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getDevicelist(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getImage() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getImage());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getImage(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GpsDevicesList.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "gpsDevicesList"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("devicelist");
        elemField.setXmlName(new javax.xml.namespace.QName("", "devicelist"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "gpsDevice"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("image");
        elemField.setXmlName(new javax.xml.namespace.QName("", "image"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
        elemField.setMinOccurs(0);
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
