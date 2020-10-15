INTERFACE zif_ale_log_connector
  PUBLIC .

  METHODS connect
    IMPORTING converted_logs TYPE zif_ale_log_converter=>ty_converted_logs.

ENDINTERFACE.
