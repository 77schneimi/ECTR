FUNCTION ZRFC_ECTR_RESUBMIT_TASK
  IMPORTING
    VALUE(I_TASK_GUID) TYPE /CENITAPM/TASK_AGENT_GUID
    VALUE(I_DATE) TYPE DATS
  EXPORTING
    VALUE(ET_RETURN) TYPE BAPIRETTAB.



  TRY.
      DATA(logger) = /cenitapm/cl_logger_fact_ap=>get_instance( )->get_root_logger( ).
      DATA(task) = /cenitapm/cl_tsk_factory_ap=>get_instance( )->get_task( i_task_guid ).
      DATA(status_api) = CAST /cenitapm/cl_tsk_status_resub( /cenitapm/cl_tsk_status_fact=>get_instance( )->get_status( /cenitapm/if_tsk_status_ap=>c_status_ids-resubmission ) ).

      status_api->/cenitapm/if_tsk_stat_resub_ap~set_resubmission_date( i_date ).
      task->set_status( status_api ).

      status_api->/cenitapm/if_saveable~save( ).
      task->/cenitapm/if_saveable~save( ).

      /cenitapm/cl_db=>get_instance( )->/cenitapm/if_commit_db~commit( ).

    CATCH /cenitapm/cx_task_api
          /cenitapm/cx_tsk_status_ap
          /cenitapm/cx_commit_db
          /cenitapm/cx_api INTO DATA(cx).
      APPEND VALUE bapiret2( message = cx->get_text( ) ) TO et_return.
      logger->error( cx ).
  ENDTRY.


ENDFUNCTION.