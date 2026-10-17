*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZZAD6_D_PARTNER.................................*
DATA:  BEGIN OF STATUS_ZZAD6_D_PARTNER               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZAD6_D_PARTNER               .
CONTROLS: TCTRL_ZZAD6_D_PARTNER
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZZAD6_D_PARTNER               .
TABLES: ZZAD6_D_PARTNER                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
