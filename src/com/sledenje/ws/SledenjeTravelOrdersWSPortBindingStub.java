/**
 * SledenjeTravelOrdersWSPortBindingStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sledenje.ws;

public class SledenjeTravelOrdersWSPortBindingStub extends org.apache.axis.client.Stub implements com.sledenje.ws.SledenjeTravelOrdersWS {
    private java.util.Vector cachedSerClasses = new java.util.Vector();
    private java.util.Vector cachedSerQNames = new java.util.Vector();
    private java.util.Vector cachedSerFactories = new java.util.Vector();
    private java.util.Vector cachedDeserFactories = new java.util.Vector();

    static org.apache.axis.description.OperationDesc [] _operations;

    static {
        _operations = new org.apache.axis.description.OperationDesc[24];
        _initOperationDesc1();
        _initOperationDesc2();
        _initOperationDesc3();
    }

    private static void _initOperationDesc1(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getTravelOrders");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "fromDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "toDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vehgr_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "to_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "veh_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrdersList"));
        oper.setReturnClass(com.sledenje.ws.TravelOrder[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "travelOrdersList"));
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
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("addTravelOrder");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vehicle_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "to_ident"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "to_from"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "to_to"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "route"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "to_user"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "driver"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "km_start"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "km_end"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "descr"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "advan_expen"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"), java.lang.Double.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "mileage_expen"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"), java.lang.Double.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "report"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "km_diff"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "km_diff_s"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "km_diff_p"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSVehicleOdoIntersectedByTravelOrderException"),
                      "com.sledenje.ws.WSVehicleOdoIntersectedByTravelOrderException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSVehicleOdoIntersectedByTravelOrderException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedVehicleException"),
                      "com.sledenje.ws.WSUnauthorisedVehicleException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedVehicleException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSTravelOrderAlreadyExistsException"),
                      "com.sledenje.ws.WSTravelOrderAlreadyExistsException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSTravelOrderAlreadyExistsException"), 
                      true
                     ));
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
        oper.setName("deleteTravelOrder");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedTravelOrderException"),
                      "com.sledenje.ws.WSUnauthorisedTravelOrderException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedTravelOrderException"), 
                      true
                     ));
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
        _operations[2] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getMileageTypes");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "miletype_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "mileageTypesList"));
        oper.setReturnClass(com.sledenje.ws.MileageType[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "mileageTypesList"));
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
        oper.setName("getTravelOrderRelations");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "fromDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "toDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vehgr_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "to_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "veh_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "to_rel_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderRelationsList"));
        oper.setReturnClass(com.sledenje.ws.TravelOrderRelation[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "travelOrderRelationsList"));
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
        _operations[4] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("addTravelOrderRelation");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "order_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "time_from"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "time_to"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "dist_km"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "travel_type"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "descr"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "point_start"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "point_end"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "load_amount"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"), java.lang.Double.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "load_km"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "daily_allow"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"), java.lang.Double.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "daily_allow_reduced"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"), java.lang.Double.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "daily_allow_descr"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "daily_allow_reduced_descr"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "daily_allow_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSTravelOrderAlreadyExistsException"),
                      "com.sledenje.ws.WSTravelOrderAlreadyExistsException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSTravelOrderAlreadyExistsException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedTravelOrderException"),
                      "com.sledenje.ws.WSUnauthorisedTravelOrderException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedTravelOrderException"), 
                      true
                     ));
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
        _operations[5] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("deleteTravelOrderRelation");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedTravelOrderRelationException"),
                      "com.sledenje.ws.WSUnauthorisedTravelOrderRelationException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedTravelOrderRelationException"), 
                      true
                     ));
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
        oper.setName("getDailyAllowances");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "fromDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "toDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "dailyallow_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "dailyAllowancesList"));
        oper.setReturnClass(com.sledenje.ws.DailyAllowance[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "dailyAllowancesList"));
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
        oper.setName("getTravelOrderPrints");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "fromDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "toDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vehgr_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "to_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "veh_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderPrintsList"));
        oper.setReturnClass(com.sledenje.ws.TravelOrderPrint[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "travelOrderPrintsList"));
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
        oper.setName("getDailyAllowanceRelations");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "fromDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "toDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "veh_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "includeSLO"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), java.lang.Boolean.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderRelationsList"));
        oper.setReturnClass(com.sledenje.ws.TravelOrderRelation[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "travelOrderRelationsList"));
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
        oper.setName("getTravelOrderStops");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "fromDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "toDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "veh_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderRelationsList"));
        oper.setReturnClass(com.sledenje.ws.TravelOrderRelation[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "travelOrderRelationsList"));
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
        oper.setName("getTravelOrderStopsIdent");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "fromDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "toDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "p_ident_naprave"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "p_voznje"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "p_razlika"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "p_hitrost"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "p_obdobje"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "p_obdelava_polnoci"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderRelationsList"));
        oper.setReturnClass(com.sledenje.ws.TravelOrderRelation[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "travelOrderRelationsList"));
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
        _operations[11] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getVehicleOdos");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "fromDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "toDate"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vehgr_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vo_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "veh_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleOdosList"));
        oper.setReturnClass(com.sledenje.ws.VehicleOdo[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        param = oper.getReturnParamDesc();
        param.setItemQName(new javax.xml.namespace.QName("", "vehicleOdosList"));
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
        _operations[12] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("addVehicleOdo");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "vehicle_id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "odo_date"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "odo_km"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), java.lang.Integer.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedVehicleException"),
                      "com.sledenje.ws.WSUnauthorisedVehicleException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedVehicleException"), 
                      true
                     ));
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSTravelOrderIntersectedByVehicleOdoException"),
                      "com.sledenje.ws.WSTravelOrderIntersectedByVehicleOdoException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSTravelOrderIntersectedByVehicleOdoException"), 
                      true
                     ));
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
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSVehicleOdoDecreasingKmException"),
                      "com.sledenje.ws.WSVehicleOdoDecreasingKmException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSVehicleOdoDecreasingKmException"), 
                      true
                     ));
        _operations[13] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("deleteVehicleOdo");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedVehicleOdoException"),
                      "com.sledenje.ws.WSUnauthorisedVehicleOdoException",
                      new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedVehicleOdoException"), 
                      true
                     ));
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
        _operations[14] = oper;

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
        _operations[15] = oper;

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
        _operations[16] = oper;

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
        _operations[17] = oper;

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
        _operations[18] = oper;

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
        _operations[19] = oper;

    }

    private static void _initOperationDesc3(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
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
        _operations[20] = oper;

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
        _operations[21] = oper;

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
        _operations[22] = oper;

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
        _operations[23] = oper;

    }

    public SledenjeTravelOrdersWSPortBindingStub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public SledenjeTravelOrdersWSPortBindingStub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    public SledenjeTravelOrdersWSPortBindingStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
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

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "dailyAllowance");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.DailyAllowance.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "dailyAllowancesList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.DailyAllowance[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "dailyAllowance");
            qName2 = new javax.xml.namespace.QName("", "dailyAllowancesList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

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

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "mileageType");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.MileageType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "mileageTypesList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.MileageType[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "mileageType");
            qName2 = new javax.xml.namespace.QName("", "mileageTypesList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrder");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.TravelOrder.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderPrint");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.TravelOrderPrint.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderPrintsList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.TravelOrderPrint[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderPrint");
            qName2 = new javax.xml.namespace.QName("", "travelOrderPrintsList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderRelation");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.TravelOrderRelation.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderRelationsList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.TravelOrderRelation[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrderRelation");
            qName2 = new javax.xml.namespace.QName("", "travelOrderRelationsList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrdersList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.TravelOrder[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "travelOrder");
            qName2 = new javax.xml.namespace.QName("", "travelOrdersList");
            cachedSerFactories.add(new org.apache.axis.encoding.ser.ArraySerializerFactory(qName, qName2));
            cachedDeserFactories.add(new org.apache.axis.encoding.ser.ArrayDeserializerFactory());

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

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleOdo");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.VehicleOdo.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleOdosList");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.VehicleOdo[].class;
            cachedSerClasses.add(cls);
            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "vehicleOdo");
            qName2 = new javax.xml.namespace.QName("", "vehicleOdosList");
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

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSTravelOrderAlreadyExistsException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSTravelOrderAlreadyExistsException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSTravelOrderIntersectedByVehicleOdoException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSTravelOrderIntersectedByVehicleOdoException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedTravelOrderException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSUnauthorisedTravelOrderException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedTravelOrderRelationException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSUnauthorisedTravelOrderRelationException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedVehicleException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSUnauthorisedVehicleException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSUnauthorisedVehicleOdoException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSUnauthorisedVehicleOdoException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSVehicleOdoDecreasingKmException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSVehicleOdoDecreasingKmException.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://ws.sledenje.com/", "WSVehicleOdoIntersectedByTravelOrderException");
            cachedSerQNames.add(qName);
            cls = com.sledenje.ws.WSVehicleOdoIntersectedByTravelOrderException.class;
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

    public com.sledenje.ws.TravelOrder[] getTravelOrders(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getTravelOrders"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {fromDate, toDate, vehgr_id, to_id, veh_id});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.TravelOrder[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.TravelOrder[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.TravelOrder[].class);
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

    public int addTravelOrder(java.lang.Integer id, java.lang.Integer vehicle_id, java.lang.String to_ident, java.lang.String to_from, java.lang.String to_to, java.lang.String route, java.lang.String to_user, java.lang.String driver, java.lang.Integer km_start, java.lang.Integer km_end, java.lang.String descr, java.lang.Double advan_expen, java.lang.Double mileage_expen, java.lang.String report, java.lang.Integer km_diff, java.lang.Integer km_diff_s, java.lang.Integer km_diff_p) throws java.rmi.RemoteException, com.sledenje.ws.WSVehicleOdoIntersectedByTravelOrderException, com.sledenje.ws.WSUnauthorisedVehicleException, com.sledenje.ws.WSTravelOrderAlreadyExistsException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "addTravelOrder"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {id, vehicle_id, to_ident, to_from, to_to, route, to_user, driver, km_start, km_end, descr, advan_expen, mileage_expen, report, km_diff, km_diff_s, km_diff_p});

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
        if (axisFaultException.detail instanceof com.sledenje.ws.WSVehicleOdoIntersectedByTravelOrderException) {
              throw (com.sledenje.ws.WSVehicleOdoIntersectedByTravelOrderException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSUnauthorisedVehicleException) {
              throw (com.sledenje.ws.WSUnauthorisedVehicleException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSTravelOrderAlreadyExistsException) {
              throw (com.sledenje.ws.WSTravelOrderAlreadyExistsException) axisFaultException.detail;
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

    public int deleteTravelOrder(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedTravelOrderException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "deleteTravelOrder"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {new java.lang.Integer(id)});

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
        if (axisFaultException.detail instanceof com.sledenje.ws.WSUnauthorisedTravelOrderException) {
              throw (com.sledenje.ws.WSUnauthorisedTravelOrderException) axisFaultException.detail;
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

    public com.sledenje.ws.MileageType[] getMileageTypes(java.lang.Integer miletype_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getMileageTypes"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {miletype_id});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.MileageType[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.MileageType[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.MileageType[].class);
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

    public com.sledenje.ws.TravelOrderRelation[] getTravelOrderRelations(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id, java.lang.Integer to_rel_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getTravelOrderRelations"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {fromDate, toDate, vehgr_id, to_id, veh_id, to_rel_id});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.TravelOrderRelation[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.TravelOrderRelation[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.TravelOrderRelation[].class);
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

    public int addTravelOrderRelation(java.lang.Integer id, java.lang.Integer order_id, java.lang.String time_from, java.lang.String time_to, java.lang.Integer dist_km, java.lang.String travel_type, java.lang.String descr, java.lang.String point_start, java.lang.String point_end, java.lang.Double load_amount, java.lang.Integer load_km, java.lang.Double daily_allow, java.lang.Double daily_allow_reduced, java.lang.String daily_allow_descr, java.lang.String daily_allow_reduced_descr, java.lang.Integer daily_allow_id) throws java.rmi.RemoteException, com.sledenje.ws.WSTravelOrderAlreadyExistsException, com.sledenje.ws.WSUnauthorisedTravelOrderException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "addTravelOrderRelation"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {id, order_id, time_from, time_to, dist_km, travel_type, descr, point_start, point_end, load_amount, load_km, daily_allow, daily_allow_reduced, daily_allow_descr, daily_allow_reduced_descr, daily_allow_id});

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
        if (axisFaultException.detail instanceof com.sledenje.ws.WSTravelOrderAlreadyExistsException) {
              throw (com.sledenje.ws.WSTravelOrderAlreadyExistsException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSUnauthorisedTravelOrderException) {
              throw (com.sledenje.ws.WSUnauthorisedTravelOrderException) axisFaultException.detail;
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

    public int deleteTravelOrderRelation(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedTravelOrderRelationException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "deleteTravelOrderRelation"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {new java.lang.Integer(id)});

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
        if (axisFaultException.detail instanceof com.sledenje.ws.WSUnauthorisedTravelOrderRelationException) {
              throw (com.sledenje.ws.WSUnauthorisedTravelOrderRelationException) axisFaultException.detail;
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

    public com.sledenje.ws.DailyAllowance[] getDailyAllowances(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer dailyallow_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getDailyAllowances"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {fromDate, toDate, dailyallow_id});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.DailyAllowance[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.DailyAllowance[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.DailyAllowance[].class);
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

    public com.sledenje.ws.TravelOrderPrint[] getTravelOrderPrints(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer to_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getTravelOrderPrints"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {fromDate, toDate, vehgr_id, to_id, veh_id});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.TravelOrderPrint[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.TravelOrderPrint[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.TravelOrderPrint[].class);
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

    public com.sledenje.ws.TravelOrderRelation[] getDailyAllowanceRelations(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer veh_id, java.lang.Boolean includeSLO) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getDailyAllowanceRelations"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {fromDate, toDate, veh_id, includeSLO});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.TravelOrderRelation[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.TravelOrderRelation[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.TravelOrderRelation[].class);
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

    public com.sledenje.ws.TravelOrderRelation[] getTravelOrderStops(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getTravelOrderStops"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {fromDate, toDate, veh_id});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.TravelOrderRelation[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.TravelOrderRelation[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.TravelOrderRelation[].class);
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

    public com.sledenje.ws.TravelOrderRelation[] getTravelOrderStopsIdent(java.lang.String fromDate, java.lang.String toDate, java.lang.String p_ident_naprave, java.lang.Integer p_voznje, java.lang.Integer p_razlika, java.lang.Integer p_hitrost, java.lang.Integer p_obdobje, java.lang.Integer p_obdelava_polnoci) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getTravelOrderStopsIdent"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {fromDate, toDate, p_ident_naprave, p_voznje, p_razlika, p_hitrost, p_obdobje, p_obdelava_polnoci});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.TravelOrderRelation[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.TravelOrderRelation[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.TravelOrderRelation[].class);
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

    public com.sledenje.ws.VehicleOdo[] getVehicleOdos(java.lang.String fromDate, java.lang.String toDate, java.lang.Integer vehgr_id, java.lang.Integer vo_id, java.lang.Integer veh_id) throws java.rmi.RemoteException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
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
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "getVehicleOdos"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {fromDate, toDate, vehgr_id, vo_id, veh_id});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (com.sledenje.ws.VehicleOdo[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (com.sledenje.ws.VehicleOdo[]) org.apache.axis.utils.JavaUtils.convert(_resp, com.sledenje.ws.VehicleOdo[].class);
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

    public int addVehicleOdo(java.lang.Integer id, java.lang.Integer vehicle_id, java.lang.String odo_date, java.lang.Integer odo_km) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedVehicleException, com.sledenje.ws.WSTravelOrderIntersectedByVehicleOdoException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException, com.sledenje.ws.WSVehicleOdoDecreasingKmException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[13]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "addVehicleOdo"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {id, vehicle_id, odo_date, odo_km});

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
        if (axisFaultException.detail instanceof com.sledenje.ws.WSUnauthorisedVehicleException) {
              throw (com.sledenje.ws.WSUnauthorisedVehicleException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSTravelOrderIntersectedByVehicleOdoException) {
              throw (com.sledenje.ws.WSTravelOrderIntersectedByVehicleOdoException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSMissingLoginException) {
              throw (com.sledenje.ws.WSMissingLoginException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSException) {
              throw (com.sledenje.ws.WSException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof com.sledenje.ws.WSVehicleOdoDecreasingKmException) {
              throw (com.sledenje.ws.WSVehicleOdoDecreasingKmException) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public int deleteVehicleOdo(int id) throws java.rmi.RemoteException, com.sledenje.ws.WSUnauthorisedVehicleOdoException, com.sledenje.ws.WSMissingLoginException, com.sledenje.ws.WSException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[14]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://ws.sledenje.com/", "deleteVehicleOdo"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {new java.lang.Integer(id)});

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
        if (axisFaultException.detail instanceof com.sledenje.ws.WSUnauthorisedVehicleOdoException) {
              throw (com.sledenje.ws.WSUnauthorisedVehicleOdoException) axisFaultException.detail;
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
        _call.setOperation(_operations[15]);
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
        _call.setOperation(_operations[16]);
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
        _call.setOperation(_operations[17]);
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
        _call.setOperation(_operations[18]);
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
        _call.setOperation(_operations[19]);
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
        _call.setOperation(_operations[20]);
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
        _call.setOperation(_operations[21]);
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
        _call.setOperation(_operations[22]);
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
        _call.setOperation(_operations[23]);
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
