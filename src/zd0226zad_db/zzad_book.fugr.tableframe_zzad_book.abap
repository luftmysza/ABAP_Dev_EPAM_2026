*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZZAD_BOOK
*   generation date: 27.03.2026 at 00:07:03
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZZAD_BOOK          .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
