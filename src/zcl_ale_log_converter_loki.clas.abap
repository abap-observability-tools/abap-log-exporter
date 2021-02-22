CLASS zcl_ale_log_converter_loki DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_log_converter.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ale_log_converter_loki IMPLEMENTATION.
  METHOD zif_ale_log_converter~convert.
    sy-subrc = sy-subrc. "placeholder
  ENDMETHOD.

ENDCLASS.
