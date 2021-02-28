*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZALE_CONFIG_MP
*   generation date: 27.02.2021 at 08:52:17
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZALE_CONFIG_MP     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
