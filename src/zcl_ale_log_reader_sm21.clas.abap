CLASS zcl_ale_log_reader_sm21 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_log_reader.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ale_log_reader_sm21 IMPLEMENTATION.
  METHOD zif_ale_log_reader~read.

    DATA syslog_filter TYPE REF TO cl_syslog_filter.
    DATA datetime_from TYPE rslgtime.
    DATA datetime_to TYPE rslgtime.
    DATA syslogs_total TYPE rslgentr_new_tab.

    datetime_from = sy-datum + '000000'.
    datetime_to   = sy-datum + '235959'.

    syslog_filter = NEW #( ).

    syslog_filter->set_filter_datetime( im_datetime_from = datetime_from
                                        im_datetime_to   = datetime_to ).

    DATA(syslog_client) = NEW cl_syslog_sapcontrol_client( ).

    TRY.
        DATA(servers) = syslog_client->get_server_names( ).
      CATCH cx_server_list. " Exception in creating a server list.
        ASSERT 1 = 2.
    ENDTRY.

    LOOP AT servers ASSIGNING FIELD-SYMBOL(<server>).
      TRY.
          DATA(syslogs_server) = syslog_client->read_syslog( iv_hostname = <server>-name ).
          syslogs_total = VALUE #( BASE syslogs_total ( LINES OF syslogs_server ) ).
        CATCH cx_ai_system_fault. " Application Integration: Technical Error
          ASSERT 1 = 2.
      ENDTRY.
    ENDLOOP.

    LOOP AT syslogs_total ASSIGNING FIELD-SYMBOL(<syslog>).

      logs = VALUE #( BASE logs ( level = '1'
                                  header_text = <syslog>-slgtype
                                  item_text = <syslog>-slgdata ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
