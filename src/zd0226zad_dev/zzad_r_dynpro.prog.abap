*&---------------------------------------------------------------------*
*& Report ZZAD_R_DYNPRO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_dynpro.

DATA:
  gv_ucomm_0100 TYPE sy-ucomm,
  gv_ucomm_0200 TYPE sy-ucomm.

TABLES: zzad_s_dynpro.

CALL SCREEN 0100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'ZZAD_S_DYNPRO-PERSON_FIRST_NAME'
        OR 'ZZAD_S_DYNPRO-PERSON_LAST_NAME'.
        IF zzad_s_dynpro-show_name = abap_true.
          screen-active = 1.
        ELSE.
          screen-active = 0.
        ENDIF.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE gv_ucomm_0100.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'PRESS'.
      CALL SCREEN 0200
        STARTING AT 5 5
        ENDING AT 50 10.
    WHEN 'HELLO'.
      MESSAGE 'Hello button!' TYPE 'S'.
    WHEN 'DONOTPRESS'.
      MESSAGE 'Do not press this button!!!'
      TYPE 'I'
      DISPLAY LIKE 'E'.
    WHEN 'READ'.
      SELECT SINGLE r~person_id, birth_date, phone_number, person_first_name, person_last_name
      FROM zzad_d_reader AS r
 INNER JOIN zzad_d_reader_t AS rt
        ON r~person_id = rt~person_id
      INTO CORRESPONDING FIELDS OF @zzad_s_dynpro
      WHERE r~person_id = @zzad_s_dynpro-person_id
      AND langu = 'E'.

      IF sy-subrc <> 0.
        MESSAGE 'Reader Not Found' TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
  ENDCASE.

  CLEAR gv_ucomm_0100.
ENDMODULE.

INCLUDE zzad_r_dynpro_status_0200o01.

INCLUDE zzad_r_dynpro_user_command_i01.
