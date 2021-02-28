*&---------------------------------------------------------------------*
*& Report ZALE_EXPORT_LOG_BAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zale_export_log_bal.

TABLES balhdr.

PARAMETERS scenario TYPE zale_config-log_scenario OBLIGATORY.
SELECT-OPTIONS object FOR balhdr-object.
SELECT-OPTIONS suobject FOR balhdr-subobject.
PARAMETERS lastsec TYPE i.
PARAMETERS fromdat TYPE dats.
PARAMETERS fromtim TYPE tims.
PARAMETERS todat TYPE dats.
PARAMETERS totim TYPE tims.
PARAMETERS test TYPE flag DEFAULT 'X'.

INITIALIZATION.

  fromdat = sy-datum.
  fromtim = sy-uzeit - 900. " 15 minutes
  todat = sy-datum.
  totim = sy-uzeit.

START-OF-SELECTION.

  DATA filter_values TYPE zif_ale_log_reader=>ty_filter_values.


  IF lastsec IS NOT INITIAL.
    fromdat = sy-datum.
    fromtim = sy-uzeit - lastsec.
    todat = sy-datum.
    totim = sy-uzeit.
  ENDIF.


  filter_values = VALUE #( ( key = 'OBJECT' value = REF #( object[] ) )
                           ( key = 'SUBOBJECT' value = REF #( suobject[] ) )
                           ( key = 'LAST_SECONDS' value = REF #( lastsec ) )
                           ( key = 'DATE_FROM' value = REF #( fromdat ) )
                           ( key = 'TIME_FROM' value = REF #( fromtim ) )
                           ( key = 'DATE_TO' value = REF #( todat ) )
                           ( key = 'TIME_TO' value = REF #( totim ) ) ).

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
