/**
 * DailyAllowance.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class DailyAllowance  implements java.io.Serializable {
    private double da_calc;

    private double da_max;

    private double da_med;

    private double da_min;

    private java.lang.String descr;

    private int id;

    private java.lang.String type;

    public DailyAllowance() {
    }

    public DailyAllowance(
           double da_calc,
           double da_max,
           double da_med,
           double da_min,
           java.lang.String descr,
           int id,
           java.lang.String type) {
           this.da_calc = da_calc;
           this.da_max = da_max;
           this.da_med = da_med;
           this.da_min = da_min;
           this.descr = descr;
           this.id = id;
           this.type = type;
    }


    /**
     * Gets the da_calc value for this DailyAllowance.
     * 
     * @return da_calc
     */
    public double getDa_calc() {
        return da_calc;
    }


    /**
     * Sets the da_calc value for this DailyAllowance.
     * 
     * @param da_calc
     */
    public void setDa_calc(double da_calc) {
        this.da_calc = da_calc;
    }


    /**
     * Gets the da_max value for this DailyAllowance.
     * 
     * @return da_max
     */
    public double getDa_max() {
        return da_max;
    }


    /**
     * Sets the da_max value for this DailyAllowance.
     * 
     * @param da_max
     */
    public void setDa_max(double da_max) {
        this.da_max = da_max;
    }


    /**
     * Gets the da_med value for this DailyAllowance.
     * 
     * @return da_med
     */
    public double getDa_med() {
        return da_med;
    }


    /**
     * Sets the da_med value for this DailyAllowance.
     * 
     * @param da_med
     */
    public void setDa_med(double da_med) {
        this.da_med = da_med;
    }


    /**
     * Gets the da_min value for this DailyAllowance.
     * 
     * @return da_min
     */
    public double getDa_min() {
        return da_min;
    }


    /**
     * Sets the da_min value for this DailyAllowance.
     * 
     * @param da_min
     */
    public void setDa_min(double da_min) {
        this.da_min = da_min;
    }


    /**
     * Gets the descr value for this DailyAllowance.
     * 
     * @return descr
     */
    public java.lang.String getDescr() {
        return descr;
    }


    /**
     * Sets the descr value for this DailyAllowance.
     * 
     * @param descr
     */
    public void setDescr(java.lang.String descr) {
        this.descr = descr;
    }


    /**
     * Gets the id value for this DailyAllowance.
     * 
     * @return id
     */
    public int getId() {
        return id;
    }


    /**
     * Sets the id value for this DailyAllowance.
     * 
     * @param id
     */
    public void setId(int id) {
        this.id = id;
    }


    /**
     * Gets the type value for this DailyAllowance.
     * 
     * @return type
     */
    public java.lang.String getType() {
        return type;
    }


    /**
     * Sets the type value for this DailyAllowance.
     * 
     * @param type
     */
    public void setType(java.lang.String type) {
        this.type = type;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DailyAllowance)) return false;
        DailyAllowance other = (DailyAllowance) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.da_calc == other.getDa_calc() &&
            this.da_max == other.getDa_max() &&
            this.da_med == other.getDa_med() &&
            this.da_min == other.getDa_min() &&
            ((this.descr==null && other.getDescr()==null) || 
             (this.descr!=null &&
              this.descr.equals(other.getDescr()))) &&
            this.id == other.getId() &&
            ((this.type==null && other.getType()==null) || 
             (this.type!=null &&
              this.type.equals(other.getType())));
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
        _hashCode += new Double(getDa_calc()).hashCode();
        _hashCode += new Double(getDa_max()).hashCode();
        _hashCode += new Double(getDa_med()).hashCode();
        _hashCode += new Double(getDa_min()).hashCode();
        if (getDescr() != null) {
            _hashCode += getDescr().hashCode();
        }
        _hashCode += getId();
        if (getType() != null) {
            _hashCode += getType().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DailyAllowance.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "dailyAllowance"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("da_calc");
        elemField.setXmlName(new javax.xml.namespace.QName("", "da_calc"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("da_max");
        elemField.setXmlName(new javax.xml.namespace.QName("", "da_max"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("da_med");
        elemField.setXmlName(new javax.xml.namespace.QName("", "da_med"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("da_min");
        elemField.setXmlName(new javax.xml.namespace.QName("", "da_min"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("descr");
        elemField.setXmlName(new javax.xml.namespace.QName("", "descr"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("type");
        elemField.setXmlName(new javax.xml.namespace.QName("", "type"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
