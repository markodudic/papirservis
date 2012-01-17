/**
 * TravelOrder.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class TravelOrder  implements java.io.Serializable {
    private double advan_expen;

    private java.lang.String descr;

    private java.lang.String driver;

    private int id;

    private java.lang.String ident;

    private int km_diff;

    private int km_diff_p;

    private int km_diff_s;

    private int km_end;

    private int km_start;

    private double mileage_expen;

    private java.lang.String report;

    private java.lang.String route;

    private java.lang.String to_from;

    private java.lang.String to_ident;

    private java.lang.String to_to;

    private java.lang.String to_user;

    private int vehicle_id;

    public TravelOrder() {
    }

    public TravelOrder(
           double advan_expen,
           java.lang.String descr,
           java.lang.String driver,
           int id,
           java.lang.String ident,
           int km_diff,
           int km_diff_p,
           int km_diff_s,
           int km_end,
           int km_start,
           double mileage_expen,
           java.lang.String report,
           java.lang.String route,
           java.lang.String to_from,
           java.lang.String to_ident,
           java.lang.String to_to,
           java.lang.String to_user,
           int vehicle_id) {
           this.advan_expen = advan_expen;
           this.descr = descr;
           this.driver = driver;
           this.id = id;
           this.ident = ident;
           this.km_diff = km_diff;
           this.km_diff_p = km_diff_p;
           this.km_diff_s = km_diff_s;
           this.km_end = km_end;
           this.km_start = km_start;
           this.mileage_expen = mileage_expen;
           this.report = report;
           this.route = route;
           this.to_from = to_from;
           this.to_ident = to_ident;
           this.to_to = to_to;
           this.to_user = to_user;
           this.vehicle_id = vehicle_id;
    }


    /**
     * Gets the advan_expen value for this TravelOrder.
     * 
     * @return advan_expen
     */
    public double getAdvan_expen() {
        return advan_expen;
    }


    /**
     * Sets the advan_expen value for this TravelOrder.
     * 
     * @param advan_expen
     */
    public void setAdvan_expen(double advan_expen) {
        this.advan_expen = advan_expen;
    }


    /**
     * Gets the descr value for this TravelOrder.
     * 
     * @return descr
     */
    public java.lang.String getDescr() {
        return descr;
    }


    /**
     * Sets the descr value for this TravelOrder.
     * 
     * @param descr
     */
    public void setDescr(java.lang.String descr) {
        this.descr = descr;
    }


    /**
     * Gets the driver value for this TravelOrder.
     * 
     * @return driver
     */
    public java.lang.String getDriver() {
        return driver;
    }


    /**
     * Sets the driver value for this TravelOrder.
     * 
     * @param driver
     */
    public void setDriver(java.lang.String driver) {
        this.driver = driver;
    }


    /**
     * Gets the id value for this TravelOrder.
     * 
     * @return id
     */
    public int getId() {
        return id;
    }


    /**
     * Sets the id value for this TravelOrder.
     * 
     * @param id
     */
    public void setId(int id) {
        this.id = id;
    }


    /**
     * Gets the ident value for this TravelOrder.
     * 
     * @return ident
     */
    public java.lang.String getIdent() {
        return ident;
    }


    /**
     * Sets the ident value for this TravelOrder.
     * 
     * @param ident
     */
    public void setIdent(java.lang.String ident) {
        this.ident = ident;
    }


    /**
     * Gets the km_diff value for this TravelOrder.
     * 
     * @return km_diff
     */
    public int getKm_diff() {
        return km_diff;
    }


    /**
     * Sets the km_diff value for this TravelOrder.
     * 
     * @param km_diff
     */
    public void setKm_diff(int km_diff) {
        this.km_diff = km_diff;
    }


    /**
     * Gets the km_diff_p value for this TravelOrder.
     * 
     * @return km_diff_p
     */
    public int getKm_diff_p() {
        return km_diff_p;
    }


    /**
     * Sets the km_diff_p value for this TravelOrder.
     * 
     * @param km_diff_p
     */
    public void setKm_diff_p(int km_diff_p) {
        this.km_diff_p = km_diff_p;
    }


    /**
     * Gets the km_diff_s value for this TravelOrder.
     * 
     * @return km_diff_s
     */
    public int getKm_diff_s() {
        return km_diff_s;
    }


    /**
     * Sets the km_diff_s value for this TravelOrder.
     * 
     * @param km_diff_s
     */
    public void setKm_diff_s(int km_diff_s) {
        this.km_diff_s = km_diff_s;
    }


    /**
     * Gets the km_end value for this TravelOrder.
     * 
     * @return km_end
     */
    public int getKm_end() {
        return km_end;
    }


    /**
     * Sets the km_end value for this TravelOrder.
     * 
     * @param km_end
     */
    public void setKm_end(int km_end) {
        this.km_end = km_end;
    }


    /**
     * Gets the km_start value for this TravelOrder.
     * 
     * @return km_start
     */
    public int getKm_start() {
        return km_start;
    }


    /**
     * Sets the km_start value for this TravelOrder.
     * 
     * @param km_start
     */
    public void setKm_start(int km_start) {
        this.km_start = km_start;
    }


    /**
     * Gets the mileage_expen value for this TravelOrder.
     * 
     * @return mileage_expen
     */
    public double getMileage_expen() {
        return mileage_expen;
    }


    /**
     * Sets the mileage_expen value for this TravelOrder.
     * 
     * @param mileage_expen
     */
    public void setMileage_expen(double mileage_expen) {
        this.mileage_expen = mileage_expen;
    }


    /**
     * Gets the report value for this TravelOrder.
     * 
     * @return report
     */
    public java.lang.String getReport() {
        return report;
    }


    /**
     * Sets the report value for this TravelOrder.
     * 
     * @param report
     */
    public void setReport(java.lang.String report) {
        this.report = report;
    }


    /**
     * Gets the route value for this TravelOrder.
     * 
     * @return route
     */
    public java.lang.String getRoute() {
        return route;
    }


    /**
     * Sets the route value for this TravelOrder.
     * 
     * @param route
     */
    public void setRoute(java.lang.String route) {
        this.route = route;
    }


    /**
     * Gets the to_from value for this TravelOrder.
     * 
     * @return to_from
     */
    public java.lang.String getTo_from() {
        return to_from;
    }


    /**
     * Sets the to_from value for this TravelOrder.
     * 
     * @param to_from
     */
    public void setTo_from(java.lang.String to_from) {
        this.to_from = to_from;
    }


    /**
     * Gets the to_ident value for this TravelOrder.
     * 
     * @return to_ident
     */
    public java.lang.String getTo_ident() {
        return to_ident;
    }


    /**
     * Sets the to_ident value for this TravelOrder.
     * 
     * @param to_ident
     */
    public void setTo_ident(java.lang.String to_ident) {
        this.to_ident = to_ident;
    }


    /**
     * Gets the to_to value for this TravelOrder.
     * 
     * @return to_to
     */
    public java.lang.String getTo_to() {
        return to_to;
    }


    /**
     * Sets the to_to value for this TravelOrder.
     * 
     * @param to_to
     */
    public void setTo_to(java.lang.String to_to) {
        this.to_to = to_to;
    }


    /**
     * Gets the to_user value for this TravelOrder.
     * 
     * @return to_user
     */
    public java.lang.String getTo_user() {
        return to_user;
    }


    /**
     * Sets the to_user value for this TravelOrder.
     * 
     * @param to_user
     */
    public void setTo_user(java.lang.String to_user) {
        this.to_user = to_user;
    }


    /**
     * Gets the vehicle_id value for this TravelOrder.
     * 
     * @return vehicle_id
     */
    public int getVehicle_id() {
        return vehicle_id;
    }


    /**
     * Sets the vehicle_id value for this TravelOrder.
     * 
     * @param vehicle_id
     */
    public void setVehicle_id(int vehicle_id) {
        this.vehicle_id = vehicle_id;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof TravelOrder)) return false;
        TravelOrder other = (TravelOrder) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.advan_expen == other.getAdvan_expen() &&
            ((this.descr==null && other.getDescr()==null) || 
             (this.descr!=null &&
              this.descr.equals(other.getDescr()))) &&
            ((this.driver==null && other.getDriver()==null) || 
             (this.driver!=null &&
              this.driver.equals(other.getDriver()))) &&
            this.id == other.getId() &&
            ((this.ident==null && other.getIdent()==null) || 
             (this.ident!=null &&
              this.ident.equals(other.getIdent()))) &&
            this.km_diff == other.getKm_diff() &&
            this.km_diff_p == other.getKm_diff_p() &&
            this.km_diff_s == other.getKm_diff_s() &&
            this.km_end == other.getKm_end() &&
            this.km_start == other.getKm_start() &&
            this.mileage_expen == other.getMileage_expen() &&
            ((this.report==null && other.getReport()==null) || 
             (this.report!=null &&
              this.report.equals(other.getReport()))) &&
            ((this.route==null && other.getRoute()==null) || 
             (this.route!=null &&
              this.route.equals(other.getRoute()))) &&
            ((this.to_from==null && other.getTo_from()==null) || 
             (this.to_from!=null &&
              this.to_from.equals(other.getTo_from()))) &&
            ((this.to_ident==null && other.getTo_ident()==null) || 
             (this.to_ident!=null &&
              this.to_ident.equals(other.getTo_ident()))) &&
            ((this.to_to==null && other.getTo_to()==null) || 
             (this.to_to!=null &&
              this.to_to.equals(other.getTo_to()))) &&
            ((this.to_user==null && other.getTo_user()==null) || 
             (this.to_user!=null &&
              this.to_user.equals(other.getTo_user()))) &&
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
        _hashCode += new Double(getAdvan_expen()).hashCode();
        if (getDescr() != null) {
            _hashCode += getDescr().hashCode();
        }
        if (getDriver() != null) {
            _hashCode += getDriver().hashCode();
        }
        _hashCode += getId();
        if (getIdent() != null) {
            _hashCode += getIdent().hashCode();
        }
        _hashCode += getKm_diff();
        _hashCode += getKm_diff_p();
        _hashCode += getKm_diff_s();
        _hashCode += getKm_end();
        _hashCode += getKm_start();
        _hashCode += new Double(getMileage_expen()).hashCode();
        if (getReport() != null) {
            _hashCode += getReport().hashCode();
        }
        if (getRoute() != null) {
            _hashCode += getRoute().hashCode();
        }
        if (getTo_from() != null) {
            _hashCode += getTo_from().hashCode();
        }
        if (getTo_ident() != null) {
            _hashCode += getTo_ident().hashCode();
        }
        if (getTo_to() != null) {
            _hashCode += getTo_to().hashCode();
        }
        if (getTo_user() != null) {
            _hashCode += getTo_user().hashCode();
        }
        _hashCode += getVehicle_id();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(TravelOrder.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrder"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("advan_expen");
        elemField.setXmlName(new javax.xml.namespace.QName("", "advan_expen"));
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
        elemField.setFieldName("driver");
        elemField.setXmlName(new javax.xml.namespace.QName("", "driver"));
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
        elemField.setFieldName("ident");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ident"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("km_diff");
        elemField.setXmlName(new javax.xml.namespace.QName("", "km_diff"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("km_diff_p");
        elemField.setXmlName(new javax.xml.namespace.QName("", "km_diff_p"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("km_diff_s");
        elemField.setXmlName(new javax.xml.namespace.QName("", "km_diff_s"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("km_end");
        elemField.setXmlName(new javax.xml.namespace.QName("", "km_end"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("km_start");
        elemField.setXmlName(new javax.xml.namespace.QName("", "km_start"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("mileage_expen");
        elemField.setXmlName(new javax.xml.namespace.QName("", "mileage_expen"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("report");
        elemField.setXmlName(new javax.xml.namespace.QName("", "report"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("route");
        elemField.setXmlName(new javax.xml.namespace.QName("", "route"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("to_from");
        elemField.setXmlName(new javax.xml.namespace.QName("", "to_from"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("to_ident");
        elemField.setXmlName(new javax.xml.namespace.QName("", "to_ident"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("to_to");
        elemField.setXmlName(new javax.xml.namespace.QName("", "to_to"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("to_user");
        elemField.setXmlName(new javax.xml.namespace.QName("", "to_user"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
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
