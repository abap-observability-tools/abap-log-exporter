CLASS zcl_ale_log_reader_bal DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_log_reader.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS zcl_ale_log_reader_bal IMPLEMENTATION.

  METHOD zif_ale_log_reader~read.

    DATA header_data          TYPE STANDARD TABLE OF balhdr.
    DATA header_parameters    TYPE STANDARD TABLE OF balhdrp.
    DATA messages             TYPE STANDARD TABLE OF balm.
    DATA message_parameters   TYPE STANDARD TABLE OF balmp.
    DATA contexts             TYPE STANDARD TABLE OF balc.
    DATA exceptions           TYPE STANDARD TABLE OF bal_s_exception.
    DATA log_entry            TYPE string.

    FIELD-SYMBOLS <object_range> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <subobject_range> TYPE STANDARD TABLE.

    DATA(object_ref) = filter_values[ key = 'OBJECT' ]-value.
    ASSIGN object_ref->* TO <object_range>.

    DATA(subobject_ref) = filter_values[ key = 'SUBOBJECT' ]-value.
    ASSIGN subobject_ref->* TO <subobject_range>.

    SELECT
      object,
      subobject
      FROM balsub
      INTO TABLE @DATA(objects)
      WHERE object IN @<object_range>
      AND subobject IN @<subobject_range>.


    DATA(date_from_ref) = filter_values[ key = 'DATE_FROM' ]-value.
    ASSIGN date_from_ref->* TO FIELD-SYMBOL(<date_from>).

    DATA(time_from_ref) = filter_values[ key = 'TIME_FROM' ]-value.
    ASSIGN time_from_ref->* TO FIELD-SYMBOL(<time_from>).

    DATA(date_to_ref) = filter_values[ key = 'DATE_TO' ]-value.
    ASSIGN date_to_ref->* TO FIELD-SYMBOL(<date_to>).

    DATA(time_to_ref) = filter_values[ key = 'TIME_TO' ]-value.
    ASSIGN time_to_ref->* TO FIELD-SYMBOL(<time_to>).


    LOOP AT objects ASSIGNING FIELD-SYMBOL(<object>).

      CLEAR header_data.
      CLEAR header_parameters.
      CLEAR messages.
      CLEAR message_parameters.
      CLEAR contexts.
      CLEAR exceptions.

      CALL FUNCTION 'APPL_LOG_READ_DB'
        EXPORTING
          object             = <object>-object
          subobject          = <object>-subobject
*         external_number    = space            " external number
          date_from          = CONV baldate( <date_from> )
          date_to            = CONV baldate( <date_to> )
          time_from          = CONV baltime( <time_from> )
          time_to            = CONV baltime( <time_to> )
*         log_class          = '4'              " Problem class
*         program_name       = '*'              " Program name
*         transaction_code   = '*'              " Transaction name
*         user_id            = space            " User name
*         mode               = '+'              " Operating mode
*         put_into_memory    = space
*  IMPORTING
*         number_of_logs     =                  " Number of logs read
        TABLES
          header_data        = header_data
          header_parameters  = header_parameters
          messages           = messages
          message_parameters = message_parameters
          contexts           = contexts
          t_exceptions       = exceptions.

      LOOP AT header_data ASSIGNING FIELD-SYMBOL(<header_data>).
        LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>) WHERE lognumber = <header_data>-lognumber.

          MESSAGE ID <message>-msgid TYPE <message>-msgty NUMBER <message>-msgno
            WITH <message>-msgv1 <message>-msgv2 <message>-msgv3 <message>-msgv4
            INTO log_entry.

          DATA(additional_fields) = VALUE zif_ale_log_reader=>ty_additional_fields( ( field = 'object' value = <header_data>-object )
                                                                                    ( field = 'subobject' value = <header_data>-subobject ) ).


          logs = VALUE #( BASE logs ( level = <message>-msgty
                                      header_text = |{ <header_data>-extnumber } / { <header_data>-object } / { <header_data>-subobject }|
                                      item_text = log_entry
                                      timestamp = <header_data>-tim_stmp
                                      additional_fields = additional_fields ) ).

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
