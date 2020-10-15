INTERFACE zif_ale_log_converter
  PUBLIC .

  TYPES: BEGIN OF ty_converted_log,
           json TYPE string,
         END OF ty_converted_log.

  TYPES ty_converted_logs TYPE STANDARD TABLE OF ty_converted_log WITH DEFAULT KEY.

  METHODS convert
    IMPORTING logs                  TYPE zif_ale_log_reader=>ty_logs
    RETURNING VALUE(converted_logs) TYPE ty_converted_logs.

ENDINTERFACE.
