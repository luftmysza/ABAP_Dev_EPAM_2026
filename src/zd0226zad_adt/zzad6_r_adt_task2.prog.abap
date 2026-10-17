*&---------------------------------------------------------------------*
*& Report ZZAD6_R_ADT_TASK2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad6_r_adt_task2.

SELECT sprsl, arbgb, msgnr, text
FROM t100                "#EC CI_GENBUFF can't be resolved in this case
WHERE text LIKE '%ABAP%'
INTO TABLE @DATA(gt_msg).

DATA lt_error TYPE TABLE OF t100.

LOOP AT gt_msg INTO DATA(ls_msg).
  IF ls_msg-text CS 'Error' OR ls_msg-text CS 'error'.
    APPEND ls_msg TO lt_error.
  ENDIF.
ENDLOOP.


cl_salv_table=>factory( IMPORTING r_salv_table = DATA(go_salv) CHANGING t_table = lt_error ).
go_salv->display( ).
