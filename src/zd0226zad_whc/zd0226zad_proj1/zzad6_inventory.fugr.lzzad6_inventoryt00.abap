*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZZAD6_D_INVENTOR................................*
DATA:  BEGIN OF STATUS_ZZAD6_D_INVENTOR              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZAD6_D_INVENTOR              .
CONTROLS: TCTRL_ZZAD6_D_INVENTOR
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZZAD6_D_INVENTOR              .
TABLES: ZZAD6_D_INVENTOR               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
