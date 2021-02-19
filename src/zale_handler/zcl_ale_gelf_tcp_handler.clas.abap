CLASS zcl_ale_gelf_tcp_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apc_wsp_event_handler.
    DATA       message TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ale_gelf_tcp_handler IMPLEMENTATION.
  METHOD if_apc_wsp_event_handler~on_open.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_message.
    TRY.
        message = i_message->get_text( ).
      CATCH cx_apc_error INTO DATA(apc_error).
        message = apc_error->get_text( ).
    ENDTRY.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_close.
    message = 'Connection closed!'.
  ENDMETHOD.

  METHOD if_apc_wsp_event_handler~on_error.
  ENDMETHOD.
ENDCLASS.
