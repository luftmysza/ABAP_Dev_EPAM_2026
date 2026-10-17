*&---------------------------------------------------------------------*
*& Report ZZAD6_R_UPDATE_ASYNCH
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZZAD6_R_UPDATE_ASYNCH.

INCLUDE zzad6_r_update_asynch_top.
INCLUDE zzad6_r_update_asynch_sel.
INCLUDE zzad6_r_update_asynch_f01.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 EQ 'TXT'.
      IF p_txt EQ 'X'.
*        MESSAGE 'Provide a language code' TYPE 'I'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'GEN'.
      PERFORM gen.
    WHEN 'PL1'.
      IF p_author IS INITIAL.
        MESSAGE 'Provide an author ID' TYPE 'E'.
      ENDIF.
      PERFORM pull.
    WHEN 'SAV'.
      IF p_author IS INITIAL.
        MESSAGE 'No author selected' TYPE 'E'.
      ENDIF.
      IF p_langu IS INITIAL.
        MESSAGE 'Provide a language code' TYPE 'E'.
      ENDIF.
      PERFORM save.
    WHEN 'PL2'.
      IF p_author IS INITIAL.
        MESSAGE 'No author selected' TYPE 'E'.
      ENDIF.
      IF p_langu IS INITIAL.
        MESSAGE 'Provide a language code' TYPE 'E'.
      ENDIF.
      PERFORM pull_names.
    WHEN 'DEL'.
      IF p_author IS INITIAL.
        MESSAGE 'No author selected' TYPE 'E'.
      ENDIF.
      IF p_langu IS INITIAL.
        MESSAGE 'Provide a language code' TYPE 'E'.
      ENDIF.
      PERFORM del.
    WHEN 'CAN'.
      PERFORM cancel.
    WHEN 'COM'.
      PERFORM commit_to_db.
  ENDCASE.

