*&---------------------------------------------------------------------*
*& Report ZZAD6_R_ADT_TASK4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad6_r_adt_task4.

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

LOOP AT lt_error ASSIGNING FIELD-SYMBOL(<wa_error>).
  REPLACE ALL OCCURRENCES OF 'Error' IN <wa_error> WITH 'success' IGNORING CASE.
ENDLOOP.

CLEAR <wa_error>.

TYPES: BEGIN OF ty_result,
         sprsl      TYPE t100-sprsl,
         arbgb      TYPE t100-arbgb,
         msgnr      TYPE t100-msgnr,
         text       TYPE t100-text,
         linked     TYPE abap_bool,
         objectname TYPE t100o-objectname,
         objecttype TYPE t100o-objecttype,
         name       TYPE t100u-name,
         datum      TYPE t100u-datum,
       END OF ty_result.

DATA lt_result TYPE STANDARD TABLE OF ty_result.

LOOP AT lt_error ASSIGNING <wa_error>.

  DATA(ls_result) = VALUE ty_result(
    sprsl = <wa_error>-sprsl
    arbgb = <wa_error>-arbgb
    msgnr  = <wa_error>-msgnr
    text   = <wa_error>-text
    linked = abap_false
  ).

  SELECT SINGLE objectname, objecttype
    FROM t100o
    WHERE arbgb = @<wa_error>-arbgb
    AND msgnr = @<wa_error>-msgnr
    INTO ( @ls_result-objectname, @ls_result-objecttype ). "#ec ci_genbuff

  IF sy-subrc = 0.
    ls_result-linked = abap_true.
  ELSE.
    SELECT SINGLE name, datum
      FROM t100u
       WHERE arbgb = @<wa_error>-arbgb
      AND msgnr = @<wa_error>-msgnr
      INTO ( @ls_result-name, @ls_result-datum ).
  ENDIF.

  APPEND ls_result TO lt_result.

ENDLOOP.
CLEAR ls_result.

LOOP AT lt_result INTO ls_result.
  IF ls_result-linked = abap_true.
    WRITE:/ |Object name:{ ls_result-objectname } - Object type:{ ls_result-objecttype }|.
  ELSE.
    WRITE:/ |Changed by:{ ls_result-name } - Changed on:{ ls_result-datum }|.
  ENDIF.

ENDLOOP.



