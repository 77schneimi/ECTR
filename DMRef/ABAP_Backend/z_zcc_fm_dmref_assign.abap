FUNCTION z_zcc_fm_dmref_assign.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRETTAB
*"  TABLES
*"      IT_PARAMETERS TYPE  /DSCSAG/SET_NAME_VALUE_T
*"      IT_CONTAINER_OBJECTS TYPE  /DSCSAG/OBJECT_T
*"      ET_CONTAINER_OBJECTS TYPE  /DSCSAG/OBJECT_T
*"----------------------------------------------------------------------


** Assing a Material to DIS
** This function is only available in the ECTR


  " the material no must be given
  IF NOT line_exists( it_parameters[ name = 'i_matnr' ] ).
    APPEND VALUE bapiret2( message = 'Missing Material No' type = 'E' ) TO et_return.
    RETURN.
  ENDIF.

  DATA(input) = it_parameters[ name = 'i_matnr' ]-value.
  DATA(mat_no) = zcc_cl_dmref_fac=>get_instance(
                                                )->get_util(
                                                )->convert_mat_to_int( CONV #( input )
                                                ).

  IF zcc_cl_dmref_fac=>get_instance(
                                    )->get_validator(
                                    )->is_valid_material( mat_no
                                    ) = abap_false.
    APPEND VALUE bapiret2( message = |Material { input } is no a valid Material No| type = 'S' ) TO et_return.
    RETURN.
  ENDIF.

  " get the Document key
  IF line_exists( it_container_objects[ dokob = 'DRAW' ] ).
    DATA(doc_key) = /dscsag/utils=>objkytodockey( it_container_objects[ dokob = 'DRAW' ]-objky ).
  ELSE.
    APPEND VALUE bapiret2( message = 'Missing Document' type = 'E' ) TO et_return.
    RETURN.
  ENDIF.

  DATA(logic) = zcc_cl_dmref_fac=>get_instance( )->get_logic( ).
  logic->add( i_doc_key = doc_key
              i_matnr   = mat_no
            ).

  COMMIT WORK.

  APPEND VALUE bapiret2( message = |Material { input } was asssinged to { doc_key-documentnumber }| type = 'S' ) TO et_return.

ENDFUNCTION.