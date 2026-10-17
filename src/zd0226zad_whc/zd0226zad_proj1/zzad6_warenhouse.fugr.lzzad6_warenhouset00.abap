*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZZAD6_D_WAREH...................................*
DATA:  BEGIN OF STATUS_ZZAD6_D_WAREH                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZAD6_D_WAREH                 .
CONTROLS: TCTRL_ZZAD6_D_WAREH
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZZAD6_D_WAREH                 .
TABLES: ZZAD6_D_WAREH                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
