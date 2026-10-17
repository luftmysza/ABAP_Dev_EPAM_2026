*&---------------------------------------------------------------------*
*& Report ZZAD6_R_ADT_TASK1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad6_r_adt_task1.

SELECT sprsl, arbgb, msgnr, text
FROM t100                "#EC CI_GENBUFF can't be resolved in this case
WHERE text LIKE '%ABAP%'
INTO TABLE @DATA(gt_msg).

*cl_salv_table=>factory( IMPORTING r_salv_table = DATA(go_salv) CHANGING t_table = gt_msg ).
*go_salv->display( ).
