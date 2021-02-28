*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 27.02.2021 at 08:52:17
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZALE_CONFIG.....................................*
DATA:  BEGIN OF STATUS_ZALE_CONFIG                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZALE_CONFIG                   .
CONTROLS: TCTRL_ZALE_CONFIG
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZALE_CONFIG                   .
TABLES: ZALE_CONFIG                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
