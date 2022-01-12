FUNCTION ZRFC_ECTR_SET_PROC_STATUS
  EXPORTING
    VALUE(ET_RETURN) TYPE BAPIRETTAB
  TABLES
    IT_PARAMETERS TYPE /DSCSAG/SET_NAME_VALUE_T OPTIONAL
    IT_CONTAINER_OBJECTS TYPE /DSCSAG/OBJECT_T
    ET_CONTAINER_OBJECTS TYPE /DSCSAG/OBJECT_T.



  DATA(logger) = /cenitapm/cl_logger_fact_ap=>get_instance( )->get_root_logger( ).
  logger->debug( |ECTR Macro Call: kill Process| ).

  TRY.
      DATA(new_status) = it_parameters[ name = |status| ]-value.
    CATCH cx_sy_itab_line_not_found .
      logger->debug( |no status found use canceled| ).
      new_status = /cenitapm/if_proc_status=>status_ids-canceled.
      APPEND VALUE bapiret2( message = 'No Process status was submitted'
                             type    = 'I' ) TO et_return.
  ENDTRY.

  TRY.
      DATA(objky) = it_container_objects[ 1 ]-objky.
      DATA proc_guid TYPE /cenitapm/process_guid.
      proc_guid = objky.
    CATCH cx_sy_itab_line_not_found .
      logger->error( |process guid found| ).
      APPEND VALUE bapiret2( message = 'No Process GUID found'
                             type    = 'E' ) TO et_return.
      RETURN.
  ENDTRY.

  PERFORM cancel_direct USING proc_guid
                              logger.

  APPEND VALUE bapiret2( message = 'Status was change to '
                         type    = 'S' ) TO et_return.

ENDFUNCTION.


FORM cancel_direct USING i_process_guid TYPE /cenitapm/process_guid
                         i_logger TYPE REF TO /cenit/cl_su_logger.

  BREAK-POINT.

  DATA proc_hdr TYPE /cenitapm/hdr.
  DATA proc_hdr_st TYPE /cenitapm/hdr_st.

  SELECT SINGLE * FROM /cenitapm/hdr INTO proc_hdr WHERE process_guid = i_process_guid.

  SELECT SINGLE * FROM /cenitapm/hdr_st INTO proc_hdr_st WHERE process_guid = i_process_guid
                                                           AND sequence_id  = ( SELECT MAX( sequence_id ) FROM /cenitapm/hdr_st
                                                                                      WHERE process_guid = i_process_guid ).
  proc_hdr-status = '05'.
  UPDATE /cenitapm/hdr FROM proc_hdr.

  proc_hdr_st-status = '05'.
  UPDATE /cenitapm/hdr_st FROM proc_hdr_st.


  DATA pwtsk TYPE STANDARD TABLE OF /cenitapm/pwtsk.

  SELECT * FROM /cenitapm/pwtsk INTO TABLE pwtsk WHERE process_guid = i_process_guid
                                                   AND status <> 'COMPLETED'.

  LOOP AT pwtsk INTO DATA(tsk).
    tsk-status = 'ON_HOLD'.
    UPDATE /cenitapm/pwtsk FROM tsk.
    SELECT SINGLE * FROM /cenitapm/pwstat INTO @DATA(pwstat) WHERE task_guid = @tsk-task_guid
                                                               AND sequence  = ( SELECT MAX( sequence ) FROM /cenitapm/pwstat
                                                                                      WHERE task_guid = @tsk-task_guid ).
    pwstat-status = 'ON_HOLD'.
    UPDATE /cenitapm/pwstat FROM pwstat.
  ENDLOOP.

  COMMIT WORK.

ENDFORM.