# Call Convert FM

## Description

Call a Function Modul by a Macro.

>Note: It is also possible to Call a Class-Method.

### Documentation Syntay in offical ECTR Guide

In the official DSCSAG documentation there is a possibility to call a conversion function module by macro. Described as:

```js
    <setId> = CALL_CONVERT_FM( <fmName>, <setId>, <[parameters]> )
```

This macro allow us to call each function modules or class-methods.

> The root RFC call by the macro is `/DSCSAG/SMST_SET_CONVERT`

## Excamples

### Call Funktion Module

```js
    list = KEYLIST_FROM_CONTEXT("active", "selected");
    if (list.length == 0) {
        alert("Please, select first ... in SAP ECTR");
        return;
    }

    sID = CREATE_SET(list);
    // notice that the FM is in uppercase and has a Prefix
    result = CALL_CONVERT_FM("FM:ZRFC_TEST", sID);
    kl2 = KEYLIST_FROM_SET(result);
    alert('done');
```

### Call Class-Method

```js
    // notice that the Class- and Method-Name are in uppercase
    // Class.Method.SortOrder
    result = CALL_CONVERT_FM("ZCL_ECTR_CALL.DOSOMETHING.001", sID);
```

### SAP Backend

#### Function Module

Excample of an (Remote) Function Module with Parameters.

```abap
FUNCTION ZRFC_TEST
  EXPORTING
    VALUE(ET_RETURN) TYPE BAPIRETTAB
  TABLES
    IT_PARAMETERS TYPE /DSCSAG/SET_NAME_VALUE_T OPTIONAL
    IT_CONTAINER_OBJECTS TYPE /DSCSAG/OBJECT_T
    ET_CONTAINER_OBJECTS TYPE /DSCSAG/OBJECT_T.

```

#### Class

Excample of a Class.

```abap
CLASS zcl_ectr_call DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS dosomething EXPORTING es_return TYPE bapiret2
                         CHANGING ct_set    TYPE /dscsag/obj_set_t.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_ectr_call IMPLEMENTATION.

  METHOD dosomething.
    BREAK-POINT. "call works
  ENDMETHOD.

ENDCLASS.
```
