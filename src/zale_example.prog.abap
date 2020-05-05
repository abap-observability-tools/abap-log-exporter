REPORT zale_example.

PARAMETERS loki AS CHECKBOX.
PARAMETERS gelf AS CHECKBOX.


CONSTANTS object_abe_example    TYPE balobj_d   VALUE 'ZALE'.
CONSTANTS subobject_abe_example TYPE balsubobj  VALUE 'ZALE_EXAMPLE'.

CONSTANTS gelf_url TYPE zale_config-ale_key VALUE 'GELF_URL'.
CONSTANTS loki_url TYPE zale_config-ale_key VALUE 'LOKI_URL'.

START-OF-SELECTION.

  "load config
  SELECT *
    FROM zale_config
    INTO TABLE @DATA(configurations).


  "log to BAL
  DATA log_handle         TYPE balloghndl.
  DATA log_entry_header   TYPE bal_s_log.

  log_entry_header-extnumber  = 'BAL export example'.
  log_entry_header-object     = object_abe_example.
  log_entry_header-subobject  = subobject_abe_example.
  log_entry_header-aldate     = sy-datum.
  log_entry_header-altime     = sy-uzeit.
  log_entry_header-aluser     = sy-uname.
  log_entry_header-alprog     = sy-repid.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = log_entry_header
    IMPORTING
      e_log_handle            = log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.

  IF sy-subrc = 0.

    CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
      EXPORTING
        i_log_handle     = log_handle
        i_msgty          = 'I'        
        i_text           = 'example warning'   
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
      EXPORTING
        i_log_handle     = log_handle
        i_msgty          = 'I'        
        i_text           = 'example error'  
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_save_all       = 'X'
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


  ELSE.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "read from BAL

  DATA header_data          TYPE STANDARD TABLE OF balhdr.
  DATA header_parameters    TYPE STANDARD TABLE OF balhdrp.
  DATA messages             TYPE STANDARD TABLE OF balm.
  DATA message_parameters   TYPE STANDARD TABLE OF balmp.
  DATA contexts             TYPE STANDARD TABLE OF balc.
  DATA exceptions           TYPE STANDARD TABLE OF bal_s_exception.


  CALL FUNCTION 'APPL_LOG_READ_DB'
    EXPORTING
      object             = object_abe_example
      subobject          = subobject_abe_example
      date_from          = sy-datum
      date_to            = sy-datum
    TABLES
      header_data        = header_data
      header_parameters  = header_parameters
      messages           = messages
      message_parameters = message_parameters
      contexts           = contexts
      t_exceptions       = exceptions.

  LOOP AT header_data INTO DATA(header_data_wa).

    LOOP AT messages INTO DATA(message) WHERE lognumber = header_data_wa-lognumber.

      "convert to GELF and Loki

      DATA(gelf_json) = |\{| &&
                      |"version": "1.1",| &&
                      |"host": "{ sy-host }",| &&
                      |"short_message": "{ header_data_wa-extnumber }",| &&
                      |"full_message": "{ message-msgv1 }",| &&
                      |"level": 1,| &&
                      |"_user_id": "{ header_data_wa-aluser }",| &&
                      |"_some_info": "foo",| &&
                      |"_some_env_var": "bar"| &&
                      |\}|.


      DATA time TYPE c LENGTH 8.
      DATA timestamp TYPE timestamp.
      "rework necessary
      CONVERT DATE header_data_wa-aldate TIME header_data_wa-altime INTO TIME STAMP timestamp TIME ZONE 'CST'.
      CONVERT TIME STAMP timestamp TIME ZONE 'CST' INTO DATE header_data_wa-aldate TIME header_data_wa-altime.

      WRITE header_data_wa-altime TO time USING EDIT MASK '__:__:__'.

      DATA(date) = |{ header_data_wa-aldate DATE = ISO }|.

*      data(label)

      DATA(loki_json) =  |\{"streams": [| &&
                         |\{ "labels": "\{BALexport=\\"{ header_data_wa-extnumber }\\"\}",| &&
                         | "entries": [\{ "ts": "{ date }T{ time }.801064",| &&
                         | "line": "{ message-msgv1 }" \}] \}]\}|.


      TYPES: BEGIN OF export_target,
               url  TYPE string,
               json TYPE string,
             END OF export_target.

      DATA export_targets TYPE STANDARD TABLE OF export_target.
      DATA export_target LIKE LINE OF export_targets.

      "export to GELF and Loki
      IF gelf = abap_true.
        export_target-url  = configurations[ ale_key = gelf_url ]-ale_value.
        export_target-json = gelf_json.
        APPEND export_target TO export_targets.
      ENDIF.

      IF loki = abap_true.
        export_target-url  = configurations[ ale_key = loki_url ]-ale_value.
        export_target-json = loki_json.
        APPEND export_target TO export_targets.
      ENDIF.

      LOOP AT export_targets INTO export_target.


        cl_http_client=>create_by_url(
          EXPORTING
            url                = export_target-url
          IMPORTING
            client             = DATA(client)
          EXCEPTIONS
            argument_not_found = 1
            plugin_not_active  = 2
            internal_error     = 3
            OTHERS             = 4 ).
        IF sy-subrc <> 0.
          ASSERT 1 = 2.
        ENDIF.

        client->request->set_method( 'POST' ).
        client->request->set_content_type( 'application/json' ).

        DATA xjson TYPE xstring.

        CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
          EXPORTING
            text   = export_target-json
*           mimetype = SPACE
*           encoding =
          IMPORTING
            buffer = xjson
          EXCEPTIONS
            failed = 1
            OTHERS = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        client->request->set_data( xjson ).

        client->send(
          EXCEPTIONS
            http_communication_failure = 1
            http_invalid_state         = 2
            http_processing_failed     = 3
            http_invalid_timeout       = 4
            OTHERS                     = 5 ).
        IF sy-subrc <> 0.
          ASSERT 1 = 2.
        ENDIF.

        client->receive(
          EXCEPTIONS
            http_communication_failure = 1
            http_invalid_state         = 2
            http_processing_failed     = 3
            OTHERS                     = 4 ).
        IF sy-subrc <> 0.
          ASSERT 1 = 2.
        ENDIF.

        client->response->get_status( IMPORTING
                                          code   = DATA(http_code)
                                          reason = DATA(reason) ).

      ENDLOOP.

    ENDLOOP.
  ENDLOOP.

  sy-subrc = sy-subrc.