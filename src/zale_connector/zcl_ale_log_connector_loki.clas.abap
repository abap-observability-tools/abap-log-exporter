CLASS zcl_ale_log_connector_loki DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_log_connector.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ale_log_connector_loki IMPLEMENTATION.
  METHOD zif_ale_log_connector~connect.

    DATA(loki_url) = customizing->get_connector_url( ).

    LOOP AT converted_logs ASSIGNING FIELD-SYMBOL(<converted_log>).

      cl_http_client=>create_by_url(
            EXPORTING
              url                = CONV #( loki_url )
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

      TRY.
          DATA(xjson) = cl_binary_convert=>string_to_xstring_utf8( iv_string = <converted_log>-json ).
        CATCH cx_sy_conversion_error.
          ASSERT 1 = 2.
      ENDTRY.

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
        client->response->get_status( IMPORTING
                                          code   = DATA(http_code)
                                          reason = DATA(reason) ).
        ASSERT 1 = 2.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
