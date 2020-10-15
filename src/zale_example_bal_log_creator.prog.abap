*&---------------------------------------------------------------------*
*& Report zale_example_bal_log_creator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zale_example_bal_log_creator.

PARAMETERS object   TYPE balhdr-object OBLIGATORY.
PARAMETERS suobject TYPE balhdr-subobject OBLIGATORY.
PARAMETERS message  TYPE char40 OBLIGATORY.

START-OF-SELECTION.

  "log to BAL
  DATA log_handle         TYPE balloghndl.
  DATA log_entry_header   TYPE bal_s_log.

  log_entry_header-extnumber  = 'BAL export example'.
  log_entry_header-object     = object.
  log_entry_header-subobject  = suobject.
  log_entry_header-aldate     = sy-datum.
  log_entry_header-altime     = sy-uzeit.
  log_entry_header-aluser     = sy-uname.
  log_entry_header-alprog     = sy-repid.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = log_entry_header
    IMPORTING
      e_log_handle            = log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.

  IF sy-subrc = 0.

    CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
      EXPORTING
        i_log_handle     = log_handle
        i_msgty          = 'I'
        i_text           = message
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_save_all       = 'X'
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


  ELSE.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
