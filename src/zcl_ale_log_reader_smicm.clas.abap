CLASS zcl_ale_log_reader_smicm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_log_reader.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ale_log_reader_smicm IMPLEMENTATION.
  METHOD zif_ale_log_reader~read.
    sy-subrc = sy-subrc. "placeholder
  ENDMETHOD.

ENDCLASS.
