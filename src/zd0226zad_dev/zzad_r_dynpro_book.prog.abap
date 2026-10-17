*&---------------------------------------------------------------------*
*& Report ZZAD_R_DYNPRO_BOOK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_dynpro_book.

TABLES: zzad_s_dynpro_book.

DATA:
  gv_ucomm_0100 TYPE sy-ucomm,
  gs_book       TYPE zzad_d_book.

PARAMETERS: p_bookid TYPE zzad_s_dynpro_book-book_id.

START-OF-SELECTION.
  SELECT SINGLE *
  FROM zzad_d_book
  INTO CORRESPONDING FIELDS OF zzad_s_dynpro_book
  WHERE book_id = p_bookid.
  IF sy-subrc <> 0.
    zzad_s_dynpro_book-book_id = p_bookid.
  ENDIF.

  CALL SCREEN 0100.

MODULE status_s100 OUTPUT.

ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE gv_ucomm_0100.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'SAVE'.
      gs_book = CORRESPONDING #( zzad_s_dynpro_book ).
      MODIFY zzad_d_book FROM gs_book.
      IF sy-subrc = 0.
        MESSAGE 'OK' TYPE 'S'.
      ENDIF.
      CLEAR gs_book.
  ENDCASE.

  CLEAR gv_ucomm_0100.
ENDMODULE.
