CLASS zcl_ale_log_connector_tcp_gelf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apc_wsp_event_handler.
    INTERFACES if_apc_wsp_event_handler_base.
    INTERFACES zif_ale_log_connector.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA terminator TYPE string VALUE `0A`.

    METHODS create
      IMPORTING host               TYPE string
                port               TYPE string
      RETURNING VALUE(gelf_client) TYPE REF TO if_apc_wsp_client.


ENDCLASS.



CLASS zcl_ale_log_connector_tcp_gelf IMPLEMENTATION.
  METHOD zif_ale_log_connector~connect.


*    DATA(gelf_url) = customizing->get_connector_url(  ).


*    DATA(msg) = `{ "version": "1.1", "host": "example.org", "short_message": "Abap schickt mich", "level": 5, "_some_info": "foo" }`.

    DATA(client) = me->create( host = '192.168.0.165'
                                   port = '12201' ).


    TRY.
        "Send mesasage from client
        DATA(message_manager) = CAST if_apc_wsp_message_manager(
          client->get_message_manager( ) ).


        DATA(i) = 0.
        DO 10 TIMES.

          DATA(msg) = |\{| &&
                    |"version": "1.1",| &&
                    |"host": "{ sy-host }",| &&
                    |"short_message": "asd { i }",| &&
                    |"full_message": "asd",| &&
                    |"level": 5,| &&
                    |\}|.

          DATA(message) = CAST if_apc_wsp_message( message_manager->create_message( ) ).

          DATA(binary_msg) = cl_abap_codepage=>convert_to( msg ).
          binary_msg = cl_abap_codepage=>convert_to( msg ).
          DATA(binary_terminator) = CONV xstring( terminator ).
          CONCATENATE binary_msg binary_terminator
                   INTO binary_msg IN BYTE MODE.
          message->set_binary( binary_msg ).
          message_manager->send( message ).


          i = i + 1.
        ENDDO.

      CATCH cx_apc_error INTO DATA(error). " APC framework: Error handling class for ABAP Push Channel
        cl_demo_output=>display( error->get_text(  ) ).
    ENDTRY.



  ENDMETHOD.

  METHOD create.

    DATA(event_handler) = NEW zcl_ale_gelf_tcp_handler( ).

    TRY.
        gelf_client = cl_apc_tcp_client_manager=>create(
*                         i_protocol      = 1
                         i_host          = host
                         i_port          = port
                         i_frame         = VALUE apc_tcp_frame( frame_type = if_apc_tcp_frame_types=>co_frame_type_terminator
                                                                terminator = terminator )
                         i_event_handler = event_handler
*                     i_ssl_id        = 'ANONYM'
        ).

        gelf_client->connect( ).

      CATCH cx_apc_error INTO DATA(error). " APC framework: Error handling class for ABAP Push Channel
        cl_demo_output=>display( error->get_text(  ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_apc_wsp_event_handler~on_close.
    WRITE / 'asd'.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_error.
    WRITE / 'asd'.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_message.
    WRITE / 'asd'.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_open.
    WRITE / 'asd'.
  ENDMETHOD.

ENDCLASS.
