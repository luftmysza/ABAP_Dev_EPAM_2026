*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZZAD6_D_MATERIAL................................*
DATA:  BEGIN OF STATUS_ZZAD6_D_MATERIAL              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZAD6_D_MATERIAL              .
CONTROLS: TCTRL_ZZAD6_D_MATERIAL
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZZAD6_D_MAT_T...................................*
DATA:  BEGIN OF STATUS_ZZAD6_D_MAT_T                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZAD6_D_MAT_T                 .
CONTROLS: TCTRL_ZZAD6_D_MAT_T
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZZAD6_V_MATERIAL................................*
TABLES: ZZAD6_V_MATERIAL, *ZZAD6_V_MATERIAL. "view work areas
CONTROLS: TCTRL_ZZAD6_V_MATERIAL
TYPE TABLEVIEW USING SCREEN '0003'.
DATA: BEGIN OF STATUS_ZZAD6_V_MATERIAL. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZZAD6_V_MATERIAL.
* Table for entries selected to show on screen
DATA: BEGIN OF ZZAD6_V_MATERIAL_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZZAD6_V_MATERIAL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZZAD6_V_MATERIAL_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZZAD6_V_MATERIAL_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZZAD6_V_MATERIAL.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZZAD6_V_MATERIAL_TOTAL.

*.........table declarations:.................................*
TABLES: *ZZAD6_D_MATERIAL              .
TABLES: *ZZAD6_D_MAT_T                 .
TABLES: ZZAD6_D_MATERIAL               .
TABLES: ZZAD6_D_MAT_T                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
