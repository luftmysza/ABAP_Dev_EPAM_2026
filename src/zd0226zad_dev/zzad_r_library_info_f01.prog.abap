*&---------------------------------------------------------------------*
*& Include          ZZAD_R_LIBRARY_INFO_F01
*&---------------------------------------------------------------------*

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM show_data.

FORM get_data.
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

ENDFORM.

FORM show_data.
  cl_salv_table=>factory( IMPORTING r_salv_table = DATA(go_salv) CHANGING t_table = lt_data ).
  go_salv->display( ).

ENDFORM.
