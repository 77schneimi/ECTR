CLASS zcc_cl_obj_details_dmref DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES /dscsag/if_plm_obj_details .
    INTERFACES if_badi_interface .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCC_CL_OBJ_DETAILS_DMREF IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCC_CL_OBJ_DETAILS_DMREF->/DSCSAG/IF_PLM_OBJ_DETAILS~GENERIC_DROPHANDLER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_TARGET_OBJECT               TYPE        /DSCSAG/OBJECT(optional)
* | [--->] IV_MODE                        TYPE        /DSCSAG/LINK_TYPE(optional)
* | [<-->] IT_OBJECTS_LINK_DEL            TYPE        /DSCSAG/OBJECT_T(optional)
* | [<-->] ET_RETURN_ADD                  TYPE        BAPIRET2_T(optional)
* | [<-->] ET_RETURN_DEL                  TYPE        BAPIRET2_T(optional)
* | [<-->] RETURN                         TYPE        BAPIRET2(optional)
* | [<-->] IT_OBJECTS_LINK_ADD            TYPE        /DSCSAG/OBJECT_T(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /dscsag/if_plm_obj_details~generic_drophandler.

    IF sy-uname = 'HPURPER'.
      BREAK-POINT.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCC_CL_OBJ_DETAILS_DMREF->/DSCSAG/IF_PLM_OBJ_DETAILS~GET_OBJ_CONFIG
* +-------------------------------------------------------------------------------------------------+
* | [<-->] ET_STRUCT_MAPPING              TYPE        /DSCSAG/OBJ_TYPE_STRUCT_T(optional)
* | [<-->] ET_DSCOBJECT2BOR               TYPE        /DSCSAG/BOR_OBJ_2_DSC_T(optional)
* | [<-->] ET_CONFIGURATION               TYPE        /DSCSAG/NAME_VALUE_DOKOB2_T(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /dscsag/if_plm_obj_details~get_obj_config.

    FIELD-SYMBOLS: <ls_struct_mapping>    TYPE /dscsag/obj_type_struct_s.

    READ TABLE et_struct_mapping  TRANSPORTING NO FIELDS WITH KEY object_type = 'DMREF'.

    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO et_struct_mapping  ASSIGNING <ls_struct_mapping>.
      <ls_struct_mapping>-object_type      = 'DMREF'.
      <ls_struct_mapping>-object_structure = 'ZZCC_S_DREF'.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCC_CL_OBJ_DETAILS_DMREF->/DSCSAG/IF_PLM_OBJ_DETAILS~GET_OBJ_DETAILS_GEN
* +-------------------------------------------------------------------------------------------------+
* | [<-->] IT_OBJECTS                     TYPE        /DSCSAG/OBJECT_T(optional)
* | [<-->] ET_OBJECT_DATA                 TYPE        /DSCSAG/OBJ_DATA_T(optional)
* | [<-->] ET_OBJ_SYSTEM_STATUS           TYPE        /DSCSAG/OBJ_SYST_STATUS_T(optional)
* | [<-->] ET_OBJECT_RETURN               TYPE        /DSCSAG/OBJ_RETURN_T(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /dscsag/if_plm_obj_details~get_obj_details_gen.

    IF NOT line_exists( it_objects[ dokob = 'DMREF' ] ).
      RETURN.
    ENDIF.

    DATA lt_tab TYPE TABLE OF zzcc_s_dref.
    DATA(logic) = zcc_cl_dmref_fac=>get_instance( )->get_logic( ).

    LOOP AT it_objects ASSIGNING FIELD-SYMBOL(<s_object>) WHERE dokob = 'DMREF'.

      DATA(mat_reference_no) = logic->get( CONV #( <s_object>-objky ) )-material.
      DATA(material) = zcc_cl_dmref_fac=>get_instance( )->get_material( mat_reference_no ).

      APPEND VALUE zzcc_s_dref( g_dsc_key   = <s_object>
                                material    = material->get_material_no( )
                                type        = material->get_type( )
                                description = material->get_description( )
                              ) TO lt_tab.
    ENDLOOP.

    CHECK lt_tab IS NOT INITIAL.

    /dscsag/cl_obj_details=>map_object_details( EXPORTING iv_object_type   = 'DMREF'
                                                         iv_structure_name = 'ZZCC_S_DREF'
                                                         it_data           = lt_tab
                                               CHANGING  et_object_data    = et_object_data[] ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCC_CL_OBJ_DETAILS_DMREF->/DSCSAG/IF_PLM_OBJ_DETAILS~GET_OBJ_DETAILS_GEN2
* +-------------------------------------------------------------------------------------------------+
* | [<-->] IT_OBJECTS                     TYPE        /DSCSAG/OBJECT_T(optional)
* | [<-->] ET_OBJECT_DATA_LONG            TYPE        /DSCSAG/OBJ_DATA_T_LONG(optional)
* | [<-->] ET_OBJ_SYSTEM_STATUS           TYPE        /DSCSAG/OBJ_SYST_STATUS_T(optional)
* | [<-->] ET_OBJECT_RETURN               TYPE        /DSCSAG/OBJ_RETURN_T(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /dscsag/if_plm_obj_details~get_obj_details_gen2.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCC_CL_OBJ_DETAILS_DMREF->/DSCSAG/IF_PLM_OBJ_DETAILS~GET_OBJ_LONGTEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-->] IT_OBJECTS                     TYPE        /DSCSAG/OBJECT_T(optional)
* | [<-->] ET_LONGTEXT                    TYPE        /DSCSAG/GO_OBJ_LONGTEXT_T(optional)
* | [<-->] ET_CATEGORY                    TYPE        /DSCSAG/GO_CATEGORY_LABEL_T(optional)
* | [<-->] ET_RETURN                      TYPE        BAPIRET2_T(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /dscsag/if_plm_obj_details~get_obj_longtext.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCC_CL_OBJ_DETAILS_DMREF->/DSCSAG/IF_PLM_OBJ_DETAILS~GET_OBJ_PREVIEW_DOC
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_OBJECTS                     TYPE        /DSCSAG/OBJECT_T(optional)
* | [<-->] CT_DOCTYPEPRIOLIST             TYPE        /DSCSAG/NAME_VALUE_T(optional)
* | [<-->] CT_PREVIEW_DIR                 TYPE        /DSCSAG/DOC_ID_KEY_T(optional)
* | [<-->] CS_RETURN                      TYPE        BAPIRET2(optional)
* | [<-->] CT_RETURN                      TYPE        BAPIRET2_T(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /dscsag/if_plm_obj_details~get_obj_preview_doc.

  ENDMETHOD.
ENDCLASS.