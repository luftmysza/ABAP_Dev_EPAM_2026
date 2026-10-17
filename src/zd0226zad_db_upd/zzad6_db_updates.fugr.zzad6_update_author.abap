FUNCTION zzad6_update_author.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_AUTHOR) TYPE  ZZAD_D_AUTHOR
*"  TABLES
*"      IT_AUTHOR_T STRUCTURE  ZZAD_D_AUTHOR_T
*"----------------------------------------------------------------------

  DATA:
    wa_author_t LIKE LINE OF it_author_t.
*    lt_author_t TYPE TABLE OF zzad_d_author_t.

  MODIFY zzad_d_author FROM is_author.
  IF sy-subrc <> 0.
    MESSAGE 'An error has occured during database update' TYPE 'A'.
  ENDIF.

  SELECT *
  FROM zzad_d_author_t
  WHERE author_id = @is_author-author_id
  INTO @wa_author_t.

    READ TABLE it_author_t
      WITH KEY author_id = wa_author_t-author_id
               langu     = wa_author_t-langu
      TRANSPORTING NO FIELDS.

    IF sy-subrc <> 0.
      DELETE FROM zzad_d_author_t
      WHERE author_id = @wa_author_t-author_id AND
            langu     = @wa_author_t-langu.
    ENDIF.
  ENDSELECT.

  LOOP AT it_author_t INTO wa_author_t.
    MODIFY zzad_d_author_t FROM wa_author_t.
    IF sy-subrc <> 0.
      MESSAGE 'An error has occured during database update' TYPE 'A'.
    ENDIF.
  ENDLOOP.

  ENDFUNCTION.
