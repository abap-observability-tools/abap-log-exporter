*&---------------------------------------------------------------------*
*& Report ZALE_EXPORT_LOG_BAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zale_export_log_bal.

PARAMETERS scenario TYPE zale_config-ale_scenario OBLIGATORY.
PARAMETERS object   TYPE balhdr-object OBLIGATORY.
PARAMETERS suobject TYPE balhdr-subobject OBLIGATORY.
PARAMETERS test TYPE flag DEFAULT 'X'.

START-OF-SELECTION.

  DATA filter_values TYPE zif_ale_log_reader=>ty_filter_values.

  filter_values = VALUE #( ( key = 'OBJECT' value = object )
                           ( key = 'SUBOBJECT' value = suobject ) ).

  "set customzing
  DATA(customizing) = NEW zcl_ale_customizing( ).
  customizing->zif_ale_customizing~set_scenario( scenario ).

  "read
  DATA(logs) = customizing->zif_ale_customizing~get_reader_class( )->read( filter_values = filter_values
                                                                           customizing = customizing ).

  "convert
  DATA(converted_logs) = customizing->zif_ale_customizing~get_converter_class( )->convert( logs = logs
                                                                                           customizing = customizing ).

  "connect
  IF test = abap_true.
    cl_demo_output=>display( converted_logs ).
  ELSE.
    customizing->zif_ale_customizing~get_connector_class( )->connect( converted_logs = converted_logs
                                                                      customizing = customizing ).
    DATA(log_lines) = lines( converted_logs ).
    WRITE |Number of logs sent: { log_lines }|.
  ENDIF.
