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
    sy-subrc = sy-subrc. "placeholder
  ENDMETHOD.

ENDCLASS.
