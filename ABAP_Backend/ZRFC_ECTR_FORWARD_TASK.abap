FUNCTION ZRFC_ECTR_FORWARD_TASK
  IMPORTING
    VALUE(I_TASK_GUID) TYPE /CENITAPM/TASK_AGENT_GUID
    VALUE(I_TO_USER) TYPE UNAME
  EXPORTING
    VALUE(ET_RETURN) TYPE BAPIRETTAB.



  DATA(logger) = /cenitapm/cl_logger_fact_ap=>get_instance( )->get_root_logger( ).

  IF i_to_user IS INITIAL.
    APPEND VALUE bapiret2( message = |'No User has been defined!| type = 'E' ) TO et_return.
    logger->error( |'No User has been defined!| ).
    COMMIT WORK. "to store logging
    RETURN.
  ENDIF.

  TRY.
      DATA(task) = /cenitapm/cl_tsk_factory_ap=>get_instance( )->get_task( i_task_guid ).

      logger->debug( |validate task and status| ).
      PERFORM is_status_valid USING task logger
                           CHANGING et_return .

      CHECK et_return IS INITIAL.

      DATA(status_ap) = /cenitapm/cl_tsk_status_fact=>get_instance( )->get_status( /cenitapm/if_tsk_status_ap=>c_status_ids-forwarded ).
      DATA(forwarded_status) = CAST /cenitapm/cl_tsk_status_forwar( status_ap ).

      forwarded_status->/cenitapm/if_tsk_stat_fwd_ap~set_forward_user( /cenitapm/cl_utilities=>get_at_sapuser_api( i_to_user ) ).
      task->set_status( forwarded_status ).

      forwarded_status->/cenitapm/if_saveable~save( ).
      task->/cenitapm/if_saveable~save( ).
      /cenitapm/cl_db=>get_instance( )->/cenitapm/if_commit_db~commit( ).

      logger->debug( |task was sucessfully forwarded to user { i_to_user }| ).
      APPEND VALUE bapiret2( message = |task was sucessfully forwarded to user { i_to_user }| type = 'S' ) TO et_return.

    CATCH /cenitapm/cx_task_api
          /cenitapm/cx_commit_db
          /cenitapm/cx_tsk_factory_api
          /cenitapm/cx_at_db
          /cenitapm/cx_api INTO DATA(cx).
      APPEND VALUE bapiret2( message = cx->get_text( ) type = 'E' ) TO et_return.
      logger->error( cx ).
  ENDTRY.

ENDFUNCTION.

FORM is_status_valid USING i_task    TYPE REF TO /cenitapm/if_task_api
                           i_logger  TYPE REF TO /cenit/cl_su_logger
                  CHANGING et_return TYPE bapirettab.

  DATA msg TYPE bapi_msg  .
  TRY.
      DATA(possible_status) = /cenitapm/cl_tsk_status_fact=>get_instance( )->get_possible_status( i_task->get_status( ) ).

      LOOP AT possible_status ASSIGNING FIELD-SYMBOL(<status>).
        IF to_upper( <status>->get_name( ) ) = /cenitapm/if_tsk_status_ap=>c_status_ids-forwarded.
          DATA(valid_status) = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF i_task->get_status( )->is_change_allowed( ) = abap_false.
        msg = |task allows no changes|.
        i_logger->error( msg ).
        APPEND VALUE bapiret2( message = msg type = 'E' ) TO et_return.
      ENDIF.

      IF valid_status = abap_false.
        msg = |invalid task status to forward|.
        i_logger->error( msg ).
        APPEND VALUE bapiret2( message = msg type = 'E' ) TO et_return.
      ENDIF.

    CATCH /cenitapm/cx_task_api /cenitapm/cx_tsk_stat_no_valid INTO DATA(cx).
      i_logger->error( cx ).
  ENDTRY.
ENDFORM.