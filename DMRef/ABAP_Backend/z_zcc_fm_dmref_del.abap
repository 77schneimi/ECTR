FUNCTION z_zcc_fm_dmref_del.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRETTAB
*"  TABLES
*"      IT_PARAMETERS TYPE  /DSCSAG/SET_NAME_VALUE_T
*"      IT_CONTAINER_OBJECTS TYPE  /DSCSAG/OBJECT_T
*"      ET_CONTAINER_OBJECTS TYPE  /DSCSAG/OBJECT_T
*"----------------------------------------------------------------------


  IF line_exists( it_parameters[ name = 'GUID' ] ).
    DATA(guid) = CONV sysuuid_c( it_parameters[ name = 'GUID' ] ).
  ELSE.
    APPEND VALUE bapiret2( message = 'no GUID was given' type = 'E' ) TO et_return.
    RETURN.
  ENDIF.

  DATA(logic) = zcc_cl_dmref_fac=>get_instance( )->get_logic( ).
  logic->delete( guid ).
  COMMIT WORK.

  APPEND VALUE bapiret2( message = 'Allocation was removed' type = 'S' ) TO et_return.

ENDFUNCTION.