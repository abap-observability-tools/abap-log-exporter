INTERFACE zif_ale_log_reader
  PUBLIC .

  CONSTANTS: BEGIN OF con_log_level,
               info    TYPE c LENGTH 1 VALUE 'I',
               warning TYPE c LENGTH 1 VALUE 'W',
               error   TYPE c LENGTH 1 VALUE 'E',
             END OF con_log_level.

  TYPES: BEGIN OF ty_filter_value,
           key   TYPE string,
           value TYPE string,
         END OF ty_filter_value.

  TYPES ty_filter_values TYPE STANDARD TABLE OF ty_filter_value.

  TYPES: BEGIN OF ty_log,
           level       TYPE c LENGTH 1,
           header_text TYPE string,
           item_text   TYPE string,
         END OF ty_log.

  TYPES ty_logs TYPE STANDARD TABLE OF ty_log WITH DEFAULT KEY.

  METHODS read
    IMPORTING filter_values TYPE ty_filter_values
              customizing   TYPE REF TO zif_ale_customizing
    RETURNING VALUE(logs)   TYPE ty_logs.

ENDINTERFACE.
