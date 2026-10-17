*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZZAD6_LOCATION
*   generation date: 17.05.2026 at 15:46:39
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZZAD6_LOCATION     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
