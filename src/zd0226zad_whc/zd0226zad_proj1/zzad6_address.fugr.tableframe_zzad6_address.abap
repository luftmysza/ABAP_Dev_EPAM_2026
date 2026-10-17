*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZZAD6_ADDRESS
*   generation date: 16.05.2026 at 20:33:21
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZZAD6_ADDRESS      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
