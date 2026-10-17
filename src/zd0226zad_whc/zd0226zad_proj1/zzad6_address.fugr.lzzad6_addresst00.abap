*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZZAD6_D_ADDRESS.................................*
DATA:  BEGIN OF STATUS_ZZAD6_D_ADDRESS               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZAD6_D_ADDRESS               .
CONTROLS: TCTRL_ZZAD6_D_ADDRESS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZZAD6_D_ADDRESS               .
TABLES: ZZAD6_D_ADDRESS                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
