*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZZAD6_D_LOCATION................................*
DATA:  BEGIN OF STATUS_ZZAD6_D_LOCATION              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZAD6_D_LOCATION              .
CONTROLS: TCTRL_ZZAD6_D_LOCATION
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZZAD6_D_LOCATION              .
TABLES: ZZAD6_D_LOCATION               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
