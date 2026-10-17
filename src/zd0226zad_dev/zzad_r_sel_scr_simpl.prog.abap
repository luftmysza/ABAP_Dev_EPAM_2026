*&---------------------------------------------------------------------*
*& Report ZZAD_R_SEL_SCR_SIMPL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_sel_scr_simpl.
TABLES: t100.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS:
    p_en RADIOBUTTON GROUP gr1 DEFAULT 'X',
    p_de RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK bl1.
SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02.
  PARAMETERS:
    p_no TYPE int2.
SELECTION-SCREEN END OF BLOCK bl2.

INITIALIZATION.
  p_no = 1.


START-OF-SELECTION.
  DATA: gt_data TYPE TABLE OF t001.

  CASE abap_true.

    WHEN p_en.
      SELECT *
      FROM t100
      WHERE sprsl = 'E'
      INTO TABLE @gt_data
      UP TO @p_no ROWS.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = DATA(go_salv)
        CHANGING
          t_table      = gt_data
      ).
      go_salv->display( ).

    WHEN p_de.
      SELECT *
      FROM t100
      WHERE sprsl = 'D'
      INTO TABLE @gt_data
      UP TO @p_no ROWS.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_salv
        CHANGING
          t_table      = gt_data
      ).
      go_salv->display( ).
  ENDCASE.
