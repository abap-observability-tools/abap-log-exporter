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


    DATA(object)    = VALUE balobj_d( filter_values[ key = 'OBJECT' ]-value ).
    DATA(subobject) =  VALUE balsubobj( filter_values[ key = 'SUBOBJECT' ]-value ).


    CALL FUNCTION 'APPL_LOG_READ_DB'
      EXPORTING
        object             = object
        subobject          = subobject
*       external_number    = space            " external number
*       date_from          = '00000000'       " Read-from date
*       date_to            = SY-DATUM         " Read-by date
*       time_from          = '000000'         " Read-from time
*       time_to            = SY-UZEIT         " Read-by time
*       log_class          = '4'              " Problem class
*       program_name       = '*'              " Program name
*       transaction_code   = '*'              " Transaction name
*       user_id            = space            " User name
*       mode               = '+'              " Operating mode
*       put_into_memory    = space
*  IMPORTING
*       number_of_logs     =                  " Number of logs read
      TABLES
        header_data        = header_data
        header_parameters  = header_parameters
        messages           = messages
        message_parameters = message_parameters
        contexts           = contexts
        t_exceptions       = exceptions.

    DATA log_entry TYPE string.
    LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>).

      MESSAGE ID <message>-msgid TYPE <message>-msgty NUMBER <message>-msgno
      WITH <message>-msgv1 <message>-msgv2 <message>-msgv3 <message>-msgv4
      INTO log_entry.

      logs = VALUE #( BASE logs ( text = log_entry ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
