/**
 * VehicleOdo.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class VehicleOdo  implements java.io.Serializable {
    private int dist_gps;

    private int id;

    private java.lang.String ident;

    private java.lang.String odo_date;

    private int odo_km;

    private int vehicle_id;

    public VehicleOdo() {
    }

    public VehicleOdo(
           int dist_gps,
           int id,
           java.lang.String ident,
           java.lang.String odo_date,
           int odo_km,
           int vehicle_id) {
           this.dist_gps = dist_gps;
           this.id = id;
           this.ident = ident;
           this.odo_date = odo_date;
           this.odo_km = odo_km;
           this.vehicle_id = vehicle_id;
    }


    /**
     * Gets the dist_gps value for this VehicleOdo.
     * 
     * @return dist_gps
     */
    public int getDist_gps() {
        return dist_gps;
    }


    /**
     * Sets the dist_gps value for this VehicleOdo.
     * 
     * @param dist_gps
     */
    public void setDist_gps(int dist_gps) {
        this.dist_gps = dist_gps;
    }


    /**
     * Gets the id value for this VehicleOdo.
     * 
     * @return id
     */
    public int getId() {
        return id;
    }


    /**
     * Sets the id value for this VehicleOdo.
     * 
     * @param id
     */
    public void setId(int id) {
        this.id = id;
    }


    /**
     * Gets the ident value for this VehicleOdo.
     * 
     * @return ident
     */
    public java.lang.String getIdent() {
        return ident;
    }


    /**
     * Sets the ident value for this VehicleOdo.
     * 
     * @param ident
     */
    public void setIdent(java.lang.String ident) {
        this.ident = ident;
    }


    /**
     * Gets the odo_date value for this VehicleOdo.
     * 
     * @return odo_date
     */
    public java.lang.String getOdo_date() {
        return odo_date;
    }


    /**
     * Sets the odo_date value for this VehicleOdo.
     * 
     * @param odo_date
     */
    public void setOdo_date(java.lang.String odo_date) {
        this.odo_date = odo_date;
    }


    /**
     * Gets the odo_km value for this VehicleOdo.
     * 
     * @return odo_km
     */
    public int getOdo_km() {
        return odo_km;
    }


    /**
     * Sets the odo_km value for this VehicleOdo.
     * 
     * @param odo_km
     */
    public void setOdo_km(int odo_km) {
        this.odo_km = odo_km;
    }


    /**
     * Gets the vehicle_id value for this VehicleOdo.
     * 
     * @return vehicle_id
     */
    public int getVehicle_id() {
        return vehicle_id;
    }


    /**
     * Sets the vehicle_id value for this VehicleOdo.
     * 
     * @param vehicle_id
     */
    public void setVehicle_id(int vehicle_id) {
        this.vehicle_id = vehicle_id;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof VehicleOdo)) return false;
        VehicleOdo other = (VehicleOdo) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.dist_gps == other.getDist_gps() &&
            this.id == other.getId() &&
            ((this.ident==null && other.getIdent()==null) || 
             (this.ident!=null &&
              this.ident.equals(other.getIdent()))) &&
            ((this.odo_date==null && other.getOdo_date()==null) || 
             (this.odo_date!=null &&
              this.odo_date.equals(other.getOdo_date()))) &&
            this.odo_km == other.getOdo_km() &&
            this.vehicle_id == other.getVehicle_id();
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
        _hashCode += getDist_gps();
        _hashCode += getId();
        if (getIdent() != null) {
            _hashCode += getIdent().hashCode();
        }
        if (getOdo_date() != null) {
            _hashCode += getOdo_date().hashCode();
        }
        _hashCode += getOdo_km();
        _hashCode += getVehicle_id();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(VehicleOdo.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleOdo"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dist_gps");
        elemField.setXmlName(new javax.xml.namespace.QName("", "dist_gps"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ident");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ident"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("odo_date");
        elemField.setXmlName(new javax.xml.namespace.QName("", "odo_date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("odo_km");
        elemField.setXmlName(new javax.xml.namespace.QName("", "odo_km"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("vehicle_id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "vehicle_id"));
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
