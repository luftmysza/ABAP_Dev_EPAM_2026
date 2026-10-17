*&---------------------------------------------------------------------*
*& Report ZZAD_R_SANDBOX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZZAD_R_SANDBOX.

SELECT COUNT( msgnr )
FROM t100
WHERE text LIKE '%text%'
INTO @DATA(lv_count).

WRITE:/ lv_count.

CLEAR lv_count.

SELECT COUNT( msgnr )
FROM t100
WHERE SPRSL = 'R'
INTO @lv_count.

WRITE:/ lv_count.
