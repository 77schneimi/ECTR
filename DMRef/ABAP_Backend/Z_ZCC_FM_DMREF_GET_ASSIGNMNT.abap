FUNCTION Z_ZCC_FM_DMREF_GET_ASSIGNMNT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_DSC_CONV_ID) TYPE  /DSCSAG/CONV_ID OPTIONAL
*"  EXPORTING
*"     VALUE(EV_FOLDER) TYPE  BAPI_DOC_KEYS
*"     VALUE(RUNTIME) TYPE  /DSCSAG/RUNTIME
*"     VALUE(VERSION_ID) TYPE  /DSCSAG/VERSION_ID
*"  TABLES
*"      IT_PARAMETERS STRUCTURE  /DSCSAG/SET_NAME_VALUE OPTIONAL
*"      IT_CONTAINER_OBJECTS STRUCTURE  /DSCSAG/OBJECT OPTIONAL
*"      ET_CONTAINER_OBJECTS STRUCTURE  /DSCSAG/OBJECT OPTIONAL
*"----------------------------------------------------------------------




  version_id = 'V 1.0.0'.

  DATA: lv_start TYPE p.
  GET RUN TIME FIELD lv_start.

  DATA(logic) = zcc_cl_dmref_fac=>get_instance( )->get_logic( ).

  LOOP AT it_container_objects ASSIGNING FIELD-SYMBOL(<ls_container>).

    DATA(doc_key) = /dscsag/utils=>objkytodockey( <ls_container>-objky ).
    DATA(mat_allocations) = logic->get_allocations( doc_key ).

    LOOP AT mat_allocations ASSIGNING FIELD-SYMBOL(<mat_alloc>).
      APPEND VALUE /dscsag/object( dokob     = 'DMREF'
                                   objky     = <mat_alloc>-guid
                                   tab_index = sy-tabix ) TO et_container_objects.
    ENDLOOP.

  ENDLOOP.

  runtime = /dscsag/utils=>get_runtime( lv_start ).

ENDFUNCTION.