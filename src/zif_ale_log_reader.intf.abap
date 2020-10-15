interface ZIF_ALE_LOG_READER
  public .

endinterface.
           key   TYPE string,
           value TYPE string,
         END OF ty_filter_value.

  TYPES ty_filter_values TYPE STANDARD TABLE OF ty_filter_value.

  TYPES: BEGIN OF ty_log,
           text TYPE string,
         END OF ty_log.

  TYPES ty_logs TYPE STANDARD TABLE OF ty_log WITH DEFAULT KEY.

  METHODS read
    IMPORTING filter_values TYPE ty_filter_values
    RETURNING VALUE(logs)   TYPE ty_logs.

ENDINTERFACE.
