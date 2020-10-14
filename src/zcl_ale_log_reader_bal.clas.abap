class ZCL_ALE_LOG_READER_BAL definition
  public
  final
  create public .

public section.

    "! read BAL
  methods READ
    importing
      !OBJECT type BALOBJ_D
      !SUBOBJECT type BALSUBOBJ .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ALE_LOG_READER_BAL IMPLEMENTATION.


  METHOD READ.

    DATA header_data          TYPE STANDARD TABLE OF balhdr.
    DATA header_parameters    TYPE STANDARD TABLE OF balhdrp.
    DATA messages             TYPE STANDARD TABLE OF balm.
    DATA message_parameters   TYPE STANDARD TABLE OF balmp.
    DATA contexts             TYPE STANDARD TABLE OF balc.
    DATA exceptions           TYPE STANDARD TABLE OF bal_s_exception.


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

  ENDMETHOD.
ENDCLASS.