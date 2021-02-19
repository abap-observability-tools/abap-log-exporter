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

    METHODS create
      IMPORTING host TYPE string
                port TYPE string.


ENDCLASS.



CLASS zcl_ale_log_connector_tcp_gelf IMPLEMENTATION.
  METHOD zif_ale_log_connector~connect.

    me->create( host = ''
                port = '1337' ).


  ENDMETHOD.

  METHOD create.
    DATA(terminator) = `0A`.
    DATA(msg)        = `Ich ABAP, du TCP, answer me!`.
    DATA(event_handler) = NEW zcl_ale_gelf_tcp_handler( ).

    TRY.
        DATA(client) = cl_apc_tcp_client_manager=>create(
*                         i_protocol      = 1
                         i_host          = host
                         i_port          = port
                         i_frame         = VALUE apc_tcp_frame( frame_type = if_apc_tcp_frame_types=>co_frame_type_terminator
                                                                terminator = terminator )
                         i_event_handler = event_handler
*                     i_ssl_id        = 'ANONYM'
        ).

        client->connect( ).

        "Send mesasage from client
        DATA(message_manager) = CAST if_apc_wsp_message_manager(
          client->get_message_manager( ) ).
        DATA(message) = CAST if_apc_wsp_message(
          message_manager->create_message( ) ).
        DATA(binary_terminator) = CONV xstring( terminator ).
        DATA(binary_msg) = cl_abap_codepage=>convert_to( msg ).
        CONCATENATE binary_msg binary_terminator
               INTO binary_msg IN BYTE MODE.
        message->set_binary( binary_msg ).

        DO 1000000 TIMES.
          message_manager->send( message ).
        ENDDO.

      CATCH cx_apc_error INTO DATA(error). " APC framework: Error handling class for ABAP Push Channel
        cl_demo_output=>display( error->get_text(  ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_apc_wsp_event_handler~on_close.

  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_error.

  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_message.

  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_open.

  ENDMETHOD.

ENDCLASS.
