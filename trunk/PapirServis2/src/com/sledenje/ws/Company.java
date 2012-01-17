/**
 * Company.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class Company  implements java.io.Serializable {
    private java.lang.String address;

    private java.lang.String descr;

    private java.lang.String e_mail;

    private int id;

    private java.lang.String is_active;

    private java.lang.String name;

    private java.lang.String phone;

    private java.lang.String respons_person;

    private java.lang.String subscr_date;

    public Company() {
    }

    public Company(
           java.lang.String address,
           java.lang.String descr,
           java.lang.String e_mail,
           int id,
           java.lang.String is_active,
           java.lang.String name,
           java.lang.String phone,
           java.lang.String respons_person,
           java.lang.String subscr_date) {
           this.address = address;
           this.descr = descr;
           this.e_mail = e_mail;
           this.id = id;
           this.is_active = is_active;
           this.name = name;
           this.phone = phone;
           this.respons_person = respons_person;
           this.subscr_date = subscr_date;
    }


    /**
     * Gets the address value for this Company.
     * 
     * @return address
     */
    public java.lang.String getAddress() {
        return address;
    }


    /**
     * Sets the address value for this Company.
     * 
     * @param address
     */
    public void setAddress(java.lang.String address) {
        this.address = address;
    }


    /**
     * Gets the descr value for this Company.
     * 
     * @return descr
     */
    public java.lang.String getDescr() {
        return descr;
    }


    /**
     * Sets the descr value for this Company.
     * 
     * @param descr
     */
    public void setDescr(java.lang.String descr) {
        this.descr = descr;
    }


    /**
     * Gets the e_mail value for this Company.
     * 
     * @return e_mail
     */
    public java.lang.String getE_mail() {
        return e_mail;
    }


    /**
     * Sets the e_mail value for this Company.
     * 
     * @param e_mail
     */
    public void setE_mail(java.lang.String e_mail) {
        this.e_mail = e_mail;
    }


    /**
     * Gets the id value for this Company.
     * 
     * @return id
     */
    public int getId() {
        return id;
    }


    /**
     * Sets the id value for this Company.
     * 
     * @param id
     */
    public void setId(int id) {
        this.id = id;
    }


    /**
     * Gets the is_active value for this Company.
     * 
     * @return is_active
     */
    public java.lang.String getIs_active() {
        return is_active;
    }


    /**
     * Sets the is_active value for this Company.
     * 
     * @param is_active
     */
    public void setIs_active(java.lang.String is_active) {
        this.is_active = is_active;
    }


    /**
     * Gets the name value for this Company.
     * 
     * @return name
     */
    public java.lang.String getName() {
        return name;
    }


    /**
     * Sets the name value for this Company.
     * 
     * @param name
     */
    public void setName(java.lang.String name) {
        this.name = name;
    }


    /**
     * Gets the phone value for this Company.
     * 
     * @return phone
     */
    public java.lang.String getPhone() {
        return phone;
    }


    /**
     * Sets the phone value for this Company.
     * 
     * @param phone
     */
    public void setPhone(java.lang.String phone) {
        this.phone = phone;
    }


    /**
     * Gets the respons_person value for this Company.
     * 
     * @return respons_person
     */
    public java.lang.String getRespons_person() {
        return respons_person;
    }


    /**
     * Sets the respons_person value for this Company.
     * 
     * @param respons_person
     */
    public void setRespons_person(java.lang.String respons_person) {
        this.respons_person = respons_person;
    }


    /**
     * Gets the subscr_date value for this Company.
     * 
     * @return subscr_date
     */
    public java.lang.String getSubscr_date() {
        return subscr_date;
    }


    /**
     * Sets the subscr_date value for this Company.
     * 
     * @param subscr_date
     */
    public void setSubscr_date(java.lang.String subscr_date) {
        this.subscr_date = subscr_date;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Company)) return false;
        Company other = (Company) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.address==null && other.getAddress()==null) || 
             (this.address!=null &&
              this.address.equals(other.getAddress()))) &&
            ((this.descr==null && other.getDescr()==null) || 
             (this.descr!=null &&
              this.descr.equals(other.getDescr()))) &&
            ((this.e_mail==null && other.getE_mail()==null) || 
             (this.e_mail!=null &&
              this.e_mail.equals(other.getE_mail()))) &&
            this.id == other.getId() &&
            ((this.is_active==null && other.getIs_active()==null) || 
             (this.is_active!=null &&
              this.is_active.equals(other.getIs_active()))) &&
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
            ((this.phone==null && other.getPhone()==null) || 
             (this.phone!=null &&
              this.phone.equals(other.getPhone()))) &&
            ((this.respons_person==null && other.getRespons_person()==null) || 
             (this.respons_person!=null &&
              this.respons_person.equals(other.getRespons_person()))) &&
            ((this.subscr_date==null && other.getSubscr_date()==null) || 
             (this.subscr_date!=null &&
              this.subscr_date.equals(other.getSubscr_date())));
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
        if (getAddress() != null) {
            _hashCode += getAddress().hashCode();
        }
        if (getDescr() != null) {
            _hashCode += getDescr().hashCode();
        }
        if (getE_mail() != null) {
            _hashCode += getE_mail().hashCode();
        }
        _hashCode += getId();
        if (getIs_active() != null) {
            _hashCode += getIs_active().hashCode();
        }
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
        if (getPhone() != null) {
            _hashCode += getPhone().hashCode();
        }
        if (getRespons_person() != null) {
            _hashCode += getRespons_person().hashCode();
        }
        if (getSubscr_date() != null) {
            _hashCode += getSubscr_date().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Company.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "company"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("address");
        elemField.setXmlName(new javax.xml.namespace.QName("", "address"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
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
        elemField.setFieldName("is_active");
        elemField.setXmlName(new javax.xml.namespace.QName("", "is_active"));
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
        elemField.setFieldName("phone");
        elemField.setXmlName(new javax.xml.namespace.QName("", "phone"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("respons_person");
        elemField.setXmlName(new javax.xml.namespace.QName("", "respons_person"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("subscr_date");
        elemField.setXmlName(new javax.xml.namespace.QName("", "subscr_date"));
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
