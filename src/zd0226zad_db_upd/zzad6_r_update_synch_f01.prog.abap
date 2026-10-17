*&---------------------------------------------------------------------*
*& Include          ZZAD6_R_UPDATE_SYNCH_F01
*&---------------------------------------------------------------------*

FORM gen.
  IF gs_author IS NOT INITIAL.
    PERFORM release_lock USING gs_author-author_id ''.
  ENDIF.
  CLEAR gs_author.

  SELECT COUNT(*)
  FROM zzad_d_author
  INTO @lv_counter.

  lv_counter = lv_counter + 1.

  p_author = lv_counter.
  p_bday = sy-datum.
  p_ctr = 'US'.

  CLEAR lv_counter.

  gs_author-author_id = p_author.
  gs_author-birth_date = p_bday.
  gs_author-country = p_ctr.

  PERFORM set_lock USING gs_author-author_id '' .
ENDFORM.

FORM pull.
  IF gs_author IS NOT INITIAL.
    PERFORM release_lock USING gs_author-author_id ''.
  ENDIF.
  CLEAR gs_author.

  SELECT SINGLE *
  FROM zzad_d_author
  WHERE author_id EQ @p_author
  INTO CORRESPONDING FIELDS OF @gs_author.

  IF sy-subrc <> 0.
    MESSAGE 'Author not found' TYPE 'E'.
    RETURN.
  ENDIF.

  SELECT langu, author_first_name, author_last_name
  FROM zzad_d_author_t
  WHERE author_id EQ @p_author
  INTO TABLE @gs_author-names.

  p_author = gs_author-author_id.
  p_bday = gs_author-birth_date.
  p_ctr = gs_author-country.

  PERFORM set_lock USING gs_author-author_id '' .
ENDFORM.


FORM save .
  lv_author_name_wrapper = VALUE #(
    langu      = p_langu
    first_name = p_fname
    last_name  = p_lname
  ).
  MODIFY TABLE gs_author-names FROM lv_author_name_wrapper.

  IF sy-subrc <> 0.
    MESSAGE 'Something went wrong..' TYPE 'E'.
  ELSE.
    MESSAGE 'Changes have been buffered - dont forget to commit!' TYPE 'I'.
  ENDIF.

  CLEAR lv_author_name_wrapper.
ENDFORM.

FORM del .
  lv_author_name_wrapper = VALUE #(
     langu      = p_langu
     first_name = p_fname
     last_name  = p_lname
   ).
  DELETE gs_author-names WHERE langu EQ lv_author_name_wrapper-langu.

  IF sy-subrc <> 0.
    MESSAGE 'Something went wrong..' TYPE 'E'.
  ELSE.
    MESSAGE 'Deletion has been buffered - dont forget to commit!' TYPE 'I'.
  ENDIF.

  CLEAR lv_author_name_wrapper.
ENDFORM.

FORM pull_names .
  READ TABLE gs_author-names INTO gs_name WITH KEY langu = p_langu.

  IF sy-subrc <> 0.
    MESSAGE 'No data for selected language code' TYPE 'W'.
  ELSE.
    p_fname = gs_name-first_name.
    p_lname = gs_name-last_name.
  ENDIF.
ENDFORM.

FORM cancel .
  IF gs_author IS NOT INITIAL.
    PERFORM release_lock USING gs_author-author_id ''.
  ENDIF.
  CLEAR: p_author,
         p_bday,
         p_ctr,
         p_langu,
         p_fname,
         p_lname,
         gs_author,
         lv_counter,
         gs_name.

  MESSAGE 'All changes have been cancelled' TYPE 'I'.
ENDFORM.

FORM commit_to_db .
  lv_author-author_id = gs_author-author_id.
  lv_author-birth_date = gs_author-birth_date.
  lv_author-country = gs_author-country.

  LOOP AT gs_author-names ASSIGNING FIELD-SYMBOL(<wa_name>).
    APPEND VALUE zzad_d_author_t( author_id = lv_author-author_id langu = <wa_name>-langu author_first_name = <wa_name>-first_name author_last_name = <wa_name>-last_name ) TO lt_author_t.
  ENDLOOP.

  CALL FUNCTION 'ZZAD6_UPDATE_AUTHOR' IN UPDATE TASK
    EXPORTING
      is_author   = lv_author
      it_author_t = lt_author_t.

  COMMIT WORK AND WAIT.

  PERFORM release_lock USING gs_author-author_id ''.

  MESSAGE 'The changes have been commited to the database' TYPE 'I'.

  CLEAR: lv_author, lt_author_t.
ENDFORM.

FORM set_lock USING k1 TYPE zzad_author_id k2 TYPE langu.
  CALL FUNCTION 'ENQUEUE_EZZAD6_AUTHOR'
    EXPORTING
      mode_zzad_d_author   = 'E'
      mode_zzad_d_author_t = 'E'
      mandt                = sy-mandt
      author_id            = k1
      langu                = k2
      x_author_id          = ' '
      x_langu              = ' '
      _scope               = '1'
      _wait                = ' '
      _collect             = ' '
    EXCEPTIONS
      foreign_lock         = 1
      system_failure       = 2
      OTHERS               = 3.
  .
  IF sy-subrc <> 0.
    MESSAGE 'The record is already locked!' TYPE 'W'.
  ENDIF.
ENDFORM.

FORM release_lock USING k1 TYPE zzad_author_id k2 TYPE langu.
  CALL FUNCTION 'DEQUEUE_EZZAD6_AUTHOR'
    EXPORTING
      mode_zzad_d_author   = 'E'
      mode_zzad_d_author_t = 'E'
      mandt                = sy-mandt
      author_id            = k1
      langu                = k2
      x_author_id          = ' '
      x_langu              = ' '
      _scope               = '1'
      _synchron            = ' '
      _collect             = ' '.
ENDFORM.
