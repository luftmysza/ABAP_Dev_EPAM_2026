*&---------------------------------------------------------------------*
*& Report ZZAD_R_SEL_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_sel_screen.

* 2. The program should have a selection screen whose fields appear when you chek the box.

* Main fields:
*
*    Author ID
*    Book ID
*    Search language (parameter)
*
* Additional fields:
*
*    Author's first name
*    Author's last name
*    Date of birth
*    Country of birth (code)
*    Country of birth (name)
*    Book title

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

*Data definition
TYPES: BEGIN OF ty_data,
         author_id     TYPE zzad_d_author-author_id,
         first_name    TYPE zzad_d_author_t-author_first_name,
         last_name     TYPE zzad_d_author_t-author_last_name,
         date_of_birth TYPE zzad_d_author-birth_date,
         country_code  TYPE zzad_d_author-country,
         country_name  TYPE t005T-landx,
         book_id       TYPE zzad_d_book-book_id,
         book_name     TYPE  zzad_d_book-book_name,
       END OF ty_data.

DATA: lt_data TYPE TABLE OF ty_data,
      ls_data TYPE ty_data.

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

START-OF-SELECTION.
*Select all books for defined selection criteria
  SELECT a~author_id,
         at~author_first_name,
         at~author_last_name,
         a~birth_date,
         a~country,
         ct~landx AS country_name,
         b~book_id,
         b~book_name

    FROM zzad_d_author AS a

    LEFT OUTER JOIN zzad_d_author_t AS at
      ON a~author_id = at~author_id
     AND at~langu    = @p_langu
     AND ( at~author_first_name = @p_fname OR @p_fname IS INITIAL )
     AND ( at~author_last_name  = @p_lname OR @p_lname IS INITIAL )

    LEFT OUTER JOIN zzad_d_book AS b
      ON a~author_id = b~author_id
     AND ( b~book_name = @p_titl OR @p_titl IS INITIAL )

    LEFT OUTER JOIN t005t AS ct
      ON a~country = ct~land1
     AND ct~spras  = @p_langu

    WHERE a~author_id IN @s_auth
      AND b~book_id   IN @s_book
      AND ( a~birth_date = @p_dob  OR @p_dob  IS INITIAL )
      AND ( a~country    = @p_cocd OR @p_cocd IS INITIAL )
      AND ( ct~landx     = @p_conm OR @p_conm IS INITIAL )

    INTO TABLE @lt_data.


END-OF-SELECTION.
*Write data
  cl_salv_table=>factory( IMPORTING r_salv_table = DATA(go_salv) CHANGING t_table = lt_data ).
  go_salv->display( ).









