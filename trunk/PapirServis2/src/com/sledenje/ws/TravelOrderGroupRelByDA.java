/**
 * TravelOrderGroupRelByDA.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class TravelOrderGroupRelByDA  implements java.io.Serializable {
    private java.lang.String daily_allow_descr;

    private int daily_allow_id;

    private java.math.BigDecimal daily_allow_total;

    private int order_id;

    private long time_diff_total;

    public TravelOrderGroupRelByDA() {
    }

    public TravelOrderGroupRelByDA(
           java.lang.String daily_allow_descr,
           int daily_allow_id,
           java.math.BigDecimal daily_allow_total,
           int order_id,
           long time_diff_total) {
           this.daily_allow_descr = daily_allow_descr;
           this.daily_allow_id = daily_allow_id;
           this.daily_allow_total = daily_allow_total;
           this.order_id = order_id;
           this.time_diff_total = time_diff_total;
    }


    /**
     * Gets the daily_allow_descr value for this TravelOrderGroupRelByDA.
     * 
     * @return daily_allow_descr
     */
    public java.lang.String getDaily_allow_descr() {
        return daily_allow_descr;
    }


    /**
     * Sets the daily_allow_descr value for this TravelOrderGroupRelByDA.
     * 
     * @param daily_allow_descr
     */
    public void setDaily_allow_descr(java.lang.String daily_allow_descr) {
        this.daily_allow_descr = daily_allow_descr;
    }


    /**
     * Gets the daily_allow_id value for this TravelOrderGroupRelByDA.
     * 
     * @return daily_allow_id
     */
    public int getDaily_allow_id() {
        return daily_allow_id;
    }


    /**
     * Sets the daily_allow_id value for this TravelOrderGroupRelByDA.
     * 
     * @param daily_allow_id
     */
    public void setDaily_allow_id(int daily_allow_id) {
        this.daily_allow_id = daily_allow_id;
    }


    /**
     * Gets the daily_allow_total value for this TravelOrderGroupRelByDA.
     * 
     * @return daily_allow_total
     */
    public java.math.BigDecimal getDaily_allow_total() {
        return daily_allow_total;
    }


    /**
     * Sets the daily_allow_total value for this TravelOrderGroupRelByDA.
     * 
     * @param daily_allow_total
     */
    public void setDaily_allow_total(java.math.BigDecimal daily_allow_total) {
        this.daily_allow_total = daily_allow_total;
    }


    /**
     * Gets the order_id value for this TravelOrderGroupRelByDA.
     * 
     * @return order_id
     */
    public int getOrder_id() {
        return order_id;
    }


    /**
     * Sets the order_id value for this TravelOrderGroupRelByDA.
     * 
     * @param order_id
     */
    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }


    /**
     * Gets the time_diff_total value for this TravelOrderGroupRelByDA.
     * 
     * @return time_diff_total
     */
    public long getTime_diff_total() {
        return time_diff_total;
    }


    /**
     * Sets the time_diff_total value for this TravelOrderGroupRelByDA.
     * 
     * @param time_diff_total
     */
    public void setTime_diff_total(long time_diff_total) {
        this.time_diff_total = time_diff_total;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof TravelOrderGroupRelByDA)) return false;
        TravelOrderGroupRelByDA other = (TravelOrderGroupRelByDA) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.daily_allow_descr==null && other.getDaily_allow_descr()==null) || 
             (this.daily_allow_descr!=null &&
              this.daily_allow_descr.equals(other.getDaily_allow_descr()))) &&
            this.daily_allow_id == other.getDaily_allow_id() &&
            ((this.daily_allow_total==null && other.getDaily_allow_total()==null) || 
             (this.daily_allow_total!=null &&
              this.daily_allow_total.equals(other.getDaily_allow_total()))) &&
            this.order_id == other.getOrder_id() &&
            this.time_diff_total == other.getTime_diff_total();
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
        if (getDaily_allow_descr() != null) {
            _hashCode += getDaily_allow_descr().hashCode();
        }
        _hashCode += getDaily_allow_id();
        if (getDaily_allow_total() != null) {
            _hashCode += getDaily_allow_total().hashCode();
        }
        _hashCode += getOrder_id();
        _hashCode += new Long(getTime_diff_total()).hashCode();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(TravelOrderGroupRelByDA.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderGroupRelByDA"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("daily_allow_descr");
        elemField.setXmlName(new javax.xml.namespace.QName("", "daily_allow_descr"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("daily_allow_id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "daily_allow_id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("daily_allow_total");
        elemField.setXmlName(new javax.xml.namespace.QName("", "daily_allow_total"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "decimal"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("order_id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "order_id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("time_diff_total");
        elemField.setXmlName(new javax.xml.namespace.QName("", "time_diff_total"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "long"));
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
