*&---------------------------------------------------------------------*
*& Include          ZZAD_R_LIBRARY_INFO_SEL
*&---------------------------------------------------------------------*

TABLES: zzad_d_author, zzad_d_author_t, zzad_d_book.
TABLES: sscrfields.

SELECTION-SCREEN PUSHBUTTON 1(11) TEXT-002 USER-COMMAND trz VISIBLE LENGTH 11.

SELECT-OPTIONS: s_auth FOR zzad_d_author-author_id,
                s_book FOR zzad_d_book-book_id.

PARAMETERS: p_langu TYPE sy-langu DEFAULT sy-langu.

SELECTION-SCREEN SKIP.
PARAMETERS: p_extra AS CHECKBOX DEFAULT ' ' USER-COMMAND uc.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_fname TYPE zzad_d_author_t-author_first_name MODIF ID add,
              p_lname TYPE zzad_d_author_t-author_last_name  MODIF ID add,
              p_dob   TYPE zzad_d_author-birth_date MODIF ID add,
              p_cocd  TYPE zzad_d_author-country MODIF ID add,
              p_conm  TYPE t005T-landx MODIF ID add,
              p_titl  TYPE zzad_d_book-book_name MODIF ID add.

SELECTION-SCREEN END OF BLOCK b1.

*When: Process before output
AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF screen-group1 = 'ADD'.
      IF p_extra = 'X'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

* When: Process after input / After user input data /
* Popuse of using: Check what user press, filled
AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'TRZ'.
    CALL TRANSACTION 'ZZAD_ADD_INFO'.
  ENDIF.
