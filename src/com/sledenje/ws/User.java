/**
 * User.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class User  implements java.io.Serializable {
    private int company_id;

    private java.lang.String descr;

    private java.lang.String e_mail;

    private int id;

    private java.lang.String name;

    private int status_id;

    private int user_group_id;

    public User() {
    }

    public User(
           int company_id,
           java.lang.String descr,
           java.lang.String e_mail,
           int id,
           java.lang.String name,
           int status_id,
           int user_group_id) {
           this.company_id = company_id;
           this.descr = descr;
           this.e_mail = e_mail;
           this.id = id;
           this.name = name;
           this.status_id = status_id;
           this.user_group_id = user_group_id;
    }


    /**
     * Gets the company_id value for this User.
     * 
     * @return company_id
     */
    public int getCompany_id() {
        return company_id;
    }


    /**
     * Sets the company_id value for this User.
     * 
     * @param company_id
     */
    public void setCompany_id(int company_id) {
        this.company_id = company_id;
    }


    /**
     * Gets the descr value for this User.
     * 
     * @return descr
     */
    public java.lang.String getDescr() {
        return descr;
    }


    /**
     * Sets the descr value for this User.
     * 
     * @param descr
     */
    public void setDescr(java.lang.String descr) {
        this.descr = descr;
    }


    /**
     * Gets the e_mail value for this User.
     * 
     * @return e_mail
     */
    public java.lang.String getE_mail() {
        return e_mail;
    }


    /**
     * Sets the e_mail value for this User.
     * 
     * @param e_mail
     */
    public void setE_mail(java.lang.String e_mail) {
        this.e_mail = e_mail;
    }


    /**
     * Gets the id value for this User.
     * 
     * @return id
     */
    public int getId() {
        return id;
    }


    /**
     * Sets the id value for this User.
     * 
     * @param id
     */
    public void setId(int id) {
        this.id = id;
    }


    /**
     * Gets the name value for this User.
     * 
     * @return name
     */
    public java.lang.String getName() {
        return name;
    }


    /**
     * Sets the name value for this User.
     * 
     * @param name
     */
    public void setName(java.lang.String name) {
        this.name = name;
    }


    /**
     * Gets the status_id value for this User.
     * 
     * @return status_id
     */
    public int getStatus_id() {
        return status_id;
    }


    /**
     * Sets the status_id value for this User.
     * 
     * @param status_id
     */
    public void setStatus_id(int status_id) {
        this.status_id = status_id;
    }


    /**
     * Gets the user_group_id value for this User.
     * 
     * @return user_group_id
     */
    public int getUser_group_id() {
        return user_group_id;
    }


    /**
     * Sets the user_group_id value for this User.
     * 
     * @param user_group_id
     */
    public void setUser_group_id(int user_group_id) {
        this.user_group_id = user_group_id;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof User)) return false;
        User other = (User) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.company_id == other.getCompany_id() &&
            ((this.descr==null && other.getDescr()==null) || 
             (this.descr!=null &&
              this.descr.equals(other.getDescr()))) &&
            ((this.e_mail==null && other.getE_mail()==null) || 
             (this.e_mail!=null &&
              this.e_mail.equals(other.getE_mail()))) &&
            this.id == other.getId() &&
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
            this.status_id == other.getStatus_id() &&
            this.user_group_id == other.getUser_group_id();
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
        _hashCode += getCompany_id();
        if (getDescr() != null) {
            _hashCode += getDescr().hashCode();
        }
        if (getE_mail() != null) {
            _hashCode += getE_mail().hashCode();
        }
        _hashCode += getId();
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
        _hashCode += getStatus_id();
        _hashCode += getUser_group_id();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(User.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "user"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("company_id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "company_id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
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
        elemField.setFieldName("e_mail");
        elemField.setXmlName(new javax.xml.namespace.QName("", "e_mail"));
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
        elemField.setFieldName("name");
        elemField.setXmlName(new javax.xml.namespace.QName("", "name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("status_id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "status_id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("user_group_id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "user_group_id"));
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
