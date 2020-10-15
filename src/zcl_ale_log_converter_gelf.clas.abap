CLASS zcl_ale_log_converter_gelf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_log_converter.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ale_log_converter_gelf IMPLEMENTATION.

  METHOD zif_ale_log_converter~convert.

    LOOP AT logs ASSIGNING FIELD-SYMBOL(<log>).

      DATA(gelf_json) =   |\{| &&
                          |"version": "1.1",| &&
                          |"host": "{ sy-host }",| &&
                          |"short_message": "{ 'dummy' }",| &&
                          |"full_message": "{ <log>-text }",| &&
                          |"level": 1,| &&
                          |"_user_id": "{ sy-uname }",| &&
                          |"_some_info": "foo",| &&
                          |"_some_env_var": "bar"| &&
                          |\}|.

      converted_logs = VALUE #( BASE converted_logs ( json = gelf_json ) ).

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
