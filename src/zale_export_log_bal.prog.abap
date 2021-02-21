*&---------------------------------------------------------------------*
*& Report ZALE_EXPORT_LOG_BAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zale_export_log_bal.

PARAMETERS scenario TYPE zale_config-ale_scenario OBLIGATORY.
PARAMETERS object   TYPE balhdr-object OBLIGATORY.
PARAMETERS suobject TYPE balhdr-subobject OBLIGATORY.
PARAMETERS fromdat TYPE dats OBLIGATORY.
PARAMETERS fromtim TYPE tims OBLIGATORY.
PARAMETERS todat TYPE dats OBLIGATORY.
PARAMETERS totim TYPE tims OBLIGATORY.
PARAMETERS test TYPE flag DEFAULT 'X'.

INITIALIZATION.

  fromdat = sy-datum.
  fromtim = sy-uzeit - 900. " 15 minutes
  todat = sy-datum.
  totim = sy-uzeit.

START-OF-SELECTION.

  DATA filter_values TYPE zif_ale_log_reader=>ty_filter_values.

  filter_values = VALUE #( ( key = 'OBJECT' value = object )
                           ( key = 'SUBOBJECT' value = suobject )
                           ( key = 'DATE_FROM' value = fromdat )
                           ( key = 'TIME_FROM' value = fromtim )
                           ( key = 'DATE_TO' value = todat )
                           ( key = 'TIME_TO' value = totim ) ).

  "set customzing
  DATA(customizing) = NEW zcl_ale_customizing_base( scenario ).

  "read
  DATA(logs) = customizing->get_reader_class( )->read( filter_values = filter_values
                                                       customizing   = customizing ).

  "convert
  DATA(converted_logs) = customizing->get_converter_class( )->convert( logs        = logs
                                                                       customizing = customizing ).

  "connect
  IF test = abap_true.
    cl_demo_output=>display( converted_logs ).
  ELSE.
    customizing->get_connector_class( )->connect( converted_logs = converted_logs
                                                  customizing    = customizing ).
    DATA(log_lines) = lines( converted_logs ).
    WRITE |Number of logs sent: { log_lines }|.
  ENDIF.
