/**
 * AuToken.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class AuToken  implements java.io.Serializable {
    private java.lang.String expire;

    private java.lang.String ident_naprave;

    private java.lang.String name;

    private java.lang.String pwd;

    private int vozilo_id;

    private java.lang.String vozilo_ime;

    private java.lang.String vozilo_sifra;

    public AuToken() {
    }

    public AuToken(
           java.lang.String expire,
           java.lang.String ident_naprave,
           java.lang.String name,
           java.lang.String pwd,
           int vozilo_id,
           java.lang.String vozilo_ime,
           java.lang.String vozilo_sifra) {
           this.expire = expire;
           this.ident_naprave = ident_naprave;
           this.name = name;
           this.pwd = pwd;
           this.vozilo_id = vozilo_id;
           this.vozilo_ime = vozilo_ime;
           this.vozilo_sifra = vozilo_sifra;
    }


    /**
     * Gets the expire value for this AuToken.
     * 
     * @return expire
     */
    public java.lang.String getExpire() {
        return expire;
    }


    /**
     * Sets the expire value for this AuToken.
     * 
     * @param expire
     */
    public void setExpire(java.lang.String expire) {
        this.expire = expire;
    }


    /**
     * Gets the ident_naprave value for this AuToken.
     * 
     * @return ident_naprave
     */
    public java.lang.String getIdent_naprave() {
        return ident_naprave;
    }


    /**
     * Sets the ident_naprave value for this AuToken.
     * 
     * @param ident_naprave
     */
    public void setIdent_naprave(java.lang.String ident_naprave) {
        this.ident_naprave = ident_naprave;
    }


    /**
     * Gets the name value for this AuToken.
     * 
     * @return name
     */
    public java.lang.String getName() {
        return name;
    }


    /**
     * Sets the name value for this AuToken.
     * 
     * @param name
     */
    public void setName(java.lang.String name) {
        this.name = name;
    }


    /**
     * Gets the pwd value for this AuToken.
     * 
     * @return pwd
     */
    public java.lang.String getPwd() {
        return pwd;
    }


    /**
     * Sets the pwd value for this AuToken.
     * 
     * @param pwd
     */
    public void setPwd(java.lang.String pwd) {
        this.pwd = pwd;
    }


    /**
     * Gets the vozilo_id value for this AuToken.
     * 
     * @return vozilo_id
     */
    public int getVozilo_id() {
        return vozilo_id;
    }


    /**
     * Sets the vozilo_id value for this AuToken.
     * 
     * @param vozilo_id
     */
    public void setVozilo_id(int vozilo_id) {
        this.vozilo_id = vozilo_id;
    }


    /**
     * Gets the vozilo_ime value for this AuToken.
     * 
     * @return vozilo_ime
     */
    public java.lang.String getVozilo_ime() {
        return vozilo_ime;
    }


    /**
     * Sets the vozilo_ime value for this AuToken.
     * 
     * @param vozilo_ime
     */
    public void setVozilo_ime(java.lang.String vozilo_ime) {
        this.vozilo_ime = vozilo_ime;
    }


    /**
     * Gets the vozilo_sifra value for this AuToken.
     * 
     * @return vozilo_sifra
     */
    public java.lang.String getVozilo_sifra() {
        return vozilo_sifra;
    }


    /**
     * Sets the vozilo_sifra value for this AuToken.
     * 
     * @param vozilo_sifra
     */
    public void setVozilo_sifra(java.lang.String vozilo_sifra) {
        this.vozilo_sifra = vozilo_sifra;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AuToken)) return false;
        AuToken other = (AuToken) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.expire==null && other.getExpire()==null) || 
             (this.expire!=null &&
              this.expire.equals(other.getExpire()))) &&
            ((this.ident_naprave==null && other.getIdent_naprave()==null) || 
             (this.ident_naprave!=null &&
              this.ident_naprave.equals(other.getIdent_naprave()))) &&
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
            ((this.pwd==null && other.getPwd()==null) || 
             (this.pwd!=null &&
              this.pwd.equals(other.getPwd()))) &&
            this.vozilo_id == other.getVozilo_id() &&
            ((this.vozilo_ime==null && other.getVozilo_ime()==null) || 
             (this.vozilo_ime!=null &&
              this.vozilo_ime.equals(other.getVozilo_ime()))) &&
            ((this.vozilo_sifra==null && other.getVozilo_sifra()==null) || 
             (this.vozilo_sifra!=null &&
              this.vozilo_sifra.equals(other.getVozilo_sifra())));
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
        if (getExpire() != null) {
            _hashCode += getExpire().hashCode();
        }
        if (getIdent_naprave() != null) {
            _hashCode += getIdent_naprave().hashCode();
        }
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
        if (getPwd() != null) {
            _hashCode += getPwd().hashCode();
        }
        _hashCode += getVozilo_id();
        if (getVozilo_ime() != null) {
            _hashCode += getVozilo_ime().hashCode();
        }
        if (getVozilo_sifra() != null) {
            _hashCode += getVozilo_sifra().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AuToken.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "auToken"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("expire");
        elemField.setXmlName(new javax.xml.namespace.QName("", "expire"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ident_naprave");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ident_naprave"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("name");
        elemField.setXmlName(new javax.xml.namespace.QName("", "name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("pwd");
        elemField.setXmlName(new javax.xml.namespace.QName("", "pwd"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("vozilo_id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "vozilo_id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("vozilo_ime");
        elemField.setXmlName(new javax.xml.namespace.QName("", "vozilo_ime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("vozilo_sifra");
        elemField.setXmlName(new javax.xml.namespace.QName("", "vozilo_sifra"));
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
