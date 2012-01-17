/**
 * SledenjeAuTokenWSPortBindingStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class SledenjeAuTokenWSPortBindingStub extends org.apache.axis.client.Stub implements com.sledenje.ws.SledenjeAuTokenWS {
    private java.util.Vector cachedSerClasses = new java.util.Vector();
    private java.util.Vector cachedSerQNames = new java.util.Vector();
    private java.util.Vector cachedSerFactories = new java.util.Vector();
    private java.util.Vector cachedDeserFactories = new java.util.Vector();

    static org.apache.axis.description.OperationDesc [] _operations;

    static {
        _operations = new org.apache.axis.description.OperationDesc[13];
        _initOperationDesc1();
        _initOperationDesc2();
    }

    private static void _initOperationDesc1(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("setAuToken");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vozilo_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "name"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "pwd"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "expire"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUniqueConstraintException"),
                      "com.sledenje.ws.WSUniqueConstraintException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUniqueConstraintException"), 
                      true
                     ));
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getAuTokens");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vehgr_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "usergr_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "voz_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "auTokensList"));
        oper.setReturnClass(com.sledenje.ws.AuToken[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "auTokensList"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[1] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("isAuToken");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "name"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "pwd"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "auToken"));
        oper.setReturnClass(com.sledenje.ws.AuToken.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[2] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getLastPosition");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "ident"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "gpsDevicesList"));
        oper.setReturnClass(com.sledenje.ws.GpsDevicesList.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[3] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("login");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "user"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "psw"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(java.lang.Integer.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSInvalidAuthenticationException"),
                      "com.sledenje.ws.WSInvalidAuthenticationException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSInvalidAuthenticationException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSDatabaseErrorException"),
                      "com.sledenje.ws.WSDatabaseErrorException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSDatabaseErrorException"), 
                      true
                     ));
        _operations[4] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("logout");
        oper.setReturnType(org.apache.axis.encoding.XMLType.AXIS_VOID);
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[5] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getCompanyLogin");
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "companiesList"));
        oper.setReturnClass(com.sledenje.ws.Company[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "companiesList"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[6] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getUserLogin");
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "usersList"));
        oper.setReturnClass(com.sledenje.ws.User[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "usersList"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[7] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getCompanyUsersLogin");
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "usersList"));
        oper.setReturnClass(com.sledenje.ws.User[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "usersList"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[8] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getCompanyVehicleGroupsLogin");
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleGroupsList"));
        oper.setReturnClass(com.sledenje.ws.VehicleGroup[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "vehicleGroupsList"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[9] = oper;

    }

    private static void _initOperationDesc2(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getCompanyDriversLogin");
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "driversList"));
        oper.setReturnClass(com.sledenje.ws.Driver[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "driversList"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"),
                      "com.sledenje.ws.WSException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException"), 
                      true
                     ));
        _operations[10] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getCompanyID");
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(java.lang.Integer.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        _operations[11] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getUserID");
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(java.lang.Integer.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"),
                      "com.sledenje.ws.WSMissingLoginException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException"), 
                      true
                     ));
        _operations[12] = oper;

    }

    public SledenjeAuTokenWSPortBindingStub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public SledenjeAuTokenWSPortBindingStub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    public SledenjeAuTokenWSPortBindingStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
        if (service == null) {
            super.service = new org.apache.axis.client.Service();
        } else {
            super.service = service;
        }
        ((org.apache.axis.client.Service)super.service).setTypeMappingVersion("1.2");
            java.lang.Class cls;
            javax.xml.namespace.QName qName;
            javax.xml.namespace.QName qName2;
            java.lang.Class beansf = org.apache.axis.encoding.ser.BeanSerializerFactory.class;
            java.lang.Class beandf = org.apache.axis.encoding.ser.BeanDeserializerFactory.class;
            java.lang.Class enumsf = org.apache.axis.encoding.ser.EnumSerializerFactory.class;
            java.lang.Class enumdf = org.apache.axis.encoding.ser.EnumDeserializerFactory.class;
            java.lang.Class arraysf = org.apache.axis.encoding.ser.ArraySerializerFactory.class;
            java.lang.Class arraydf = org.apache.axis.encoding.ser.ArrayDeserializerFactory.class;
            java.lang.Class simplesf = org.apache.axis.encoding.ser.SimpleSerializerFactory.class;
            java.lang.Class simpledf = org.apache.axis.encoding.ser.SimpleDeserializerFactory.class;
            java.lang.Class simplelistsf = org.apache.axis.encoding.ser.SimpleListSerializerFactory.class;
            java.lang.Class simplelistdf = org.apache.axis.encoding.ser.SimpleListDeserializerFactory.class;
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "auToken");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.AuToken.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "auTokensList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.AuToken[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "auToken");
            qName2 = new javax.xml.namespace.QName("", "auTokensList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "companiesList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.Company[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "company");
            qName2 = new javax.xml.namespace.QName("", "companiesList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "company");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.Company.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "driver");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.Driver.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "driversList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.Driver[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "driver");
            qName2 = new javax.xml.namespace.QName("", "driversList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "gpsDevice");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.GpsDevice.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "gpsDevicesList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.GpsDevicesList.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "user");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.User.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "usersList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.User[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "user");
            qName2 = new javax.xml.namespace.QName("", "usersList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleGroup");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.VehicleGroup.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleGroupsList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.VehicleGroup[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleGroup");
            qName2 = new javax.xml.namespace.QName("", "vehicleGroupsList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSDatabaseErrorException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSDatabaseErrorException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSInvalidAuthenticationException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSInvalidAuthenticationException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSMissingLoginException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSMissingLoginException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUniqueConstraintException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSUniqueConstraintException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

    }

    protected org.apache.axis.client.Call createCall() throws java.rmi.RemoteException {
        try {
            org.apache.axis.client.Call _call = super._createCall();
            if (super.maintainSessionSet) {
                _call.setMaintainSession(super.maintainSession);
            }
            if (super.cachedUsername != null) {
                _call.setUsername(super.cachedUsername);
            }
            if (super.cachedPassword != null) {
                _call.setPassword(super.cachedPassword);
            }
            if (super.cachedEndpoint != null) {
                _call.setTargetEndpointAddress(super.cachedEndpoint);
            }
            if (super.cachedTimeout != null) {
                _call.setTimeout(super.cachedTimeout);
            }
            if (super.cachedPortName != null) {
                _call.setPortName(super.cachedPortName);
            }
            java.util.Enumeration keys = super.cachedProperties.keys();
            while (keys.hasMoreElements()) {
                java.lang.String key = (java.lang.String) keys.nextElement();
                _call.setProperty(key, super.cachedProperties.get(key));
            }
            // All the type mapping information is registered
            // when the first call is made.
            // The type mapping information is actually registered in
            // the TypeMappingRegistry of the service, which
            // is the reason why registration is only needed for the first call.
            synchronized (this) {
                if (firstCall()) {
                    // must set encoding style before registering serializers
                    _call.setEncodingStyle(null);
                    for (int i = 0; i < cachedSerFactories.size(); ++i) {
                        java.lang.Class cls = (java.lang.Class) cachedSerClasses.get(i);
                        javax.xml.namespace.QName qName =
                                (javax.xml.namespace.QName) cachedSerQNames.get(i);
                        java.lang.Object x = cachedSerFactories.get(i);
                        if (x instanceof Class) {
                            java.lang.Class sf = (java.lang.Class)
                                 cachedSerFactories.get(i);
                            java.lang.Class df = (java.lang.Class)
                                 cachedDeserFactories.get(i);
                            _call.registerTypeMapping(cls, qName, sf, df, false);
                        }
                        else if (x instanceof javax.xml.rpc.encoding.SerializerFactory) {
                            org.apache.axis.encoding.SerializerFactory sf = (org.apache.axis.encoding.SerializerFactory)
                                 cachedSerFactories.get(i);
                            org.apache.axis.encoding.DeserializerFactory df = (org.apache.axis.encoding.DeserializerFactory)
                                 cachedDeserFactories.get(i);
                            _call.registerTypeMapping(cls, qName, sf, df, false);
                        }
                    }
                }
            }
            return _call;
        }
        catch (java.lang.Throwable _t) {
            throw new org.apache.axis.AxisFault("Failure trying to get the Call object", _t);
        }
    }

    public int setAuToken(java.lang.Integer vozilo_id, java.lang.String name, java.lang.String pwd, java.lang.String expire) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException, com.sledenje.ws.WSUniqueConstraintException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[0]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "setAuToken"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {vozilo_id, name, pwd, expire});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return ((java.lang.Integer) _resp).intValue();
            } catch (java.lang.Exception _exception) {
                return ((java.lang.Integer) org.apache.axis.utils.JavaUtils.convert(_resp, int.class)).intValue();
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSUniqueConstraintException) {
              throw (com.sledenje.ws.WSUniqueConstraintException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public com.sledenje.ws.AuToken[] getAuTokens(java.lang.Integer vehgr_id, java.lang.Integer usergr_id, java.lang.Integer voz_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[1]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getAuTokens"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {vehgr_id, usergr_id, voz_id});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.AuToken[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.AuToken[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.AuToken[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public com.sledenje.ws.AuToken isAuToken(java.lang.String name, java.lang.String pwd) throws java.rmi.RemoteException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[2]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "isAuToken"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {name, pwd});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.AuToken) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.AuToken) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.AuToken.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public com.sledenje.ws.GpsDevicesList getLastPosition(java.lang.String ident) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[3]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getLastPosition"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {ident});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.GpsDevicesList) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.GpsDevicesList) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.GpsDevicesList.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public java.lang.Integer login(java.lang.String user, java.lang.String psw) throws java.rmi.RemoteException, com.sledenje.ws.WSInvalidAuthenticationException, com.sledenje.ws.WSDatabaseErrorException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[4]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "login"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {user, psw});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (java.lang.Integer) _resp;
            } catch (java.lang.Exception _exception) {
                return (java.lang.Integer) org.apache.axis.utils.JavaUtils.convert(_resp, java.lang.Integer.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSInvalidAuthenticationException) {
              throw (com.sledenje.ws.WSInvalidAuthenticationException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSDatabaseErrorException) {
              throw (com.sledenje.ws.WSDatabaseErrorException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public void logout() throws java.rmi.RemoteException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[5]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "logout"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        extractAttachments(_call);
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public com.sledenje.ws.Company[] getCompanyLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[6]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getCompanyLogin"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.Company[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.Company[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.Company[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public com.sledenje.ws.User[] getUserLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[7]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getUserLogin"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.User[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.User[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.User[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public com.sledenje.ws.User[] getCompanyUsersLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[8]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getCompanyUsersLogin"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.User[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.User[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.User[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public com.sledenje.ws.VehicleGroup[] getCompanyVehicleGroupsLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[9]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getCompanyVehicleGroupsLogin"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.VehicleGroup[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.VehicleGroup[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.VehicleGroup[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public com.sledenje.ws.Driver[] getCompanyDriversLogin() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[10]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getCompanyDriversLogin"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.Driver[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.Driver[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.Driver[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public java.lang.Integer getCompanyID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[11]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getCompanyID"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (java.lang.Integer) _resp;
            } catch (java.lang.Exception _exception) {
                return (java.lang.Integer) org.apache.axis.utils.JavaUtils.convert(_resp, java.lang.Integer.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public java.lang.Integer getUserID() throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[12]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getUserID"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (java.lang.Integer) _resp;
            } catch (java.lang.Exception _exception) {
                return (java.lang.Integer) org.apache.axis.utils.JavaUtils.convert(_resp, java.lang.Integer.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

}
