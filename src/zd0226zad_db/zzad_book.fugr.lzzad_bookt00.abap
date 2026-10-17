*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZZAD_D_BOOK.....................................*
DATA:  BEGIN OF STATUS_ZZAD_D_BOOK                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZAD_D_BOOK                   .
CONTROLS: TCTRL_ZZAD_D_BOOK
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZZAD_D_BOOK                   .
TABLES: ZZAD_D_BOOK                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
