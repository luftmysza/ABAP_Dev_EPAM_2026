*&---------------------------------------------------------------------*
*& Report ZZAD_R_ADD_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_add_info.

*A. How many books are on hand
SELECT COUNT( book_id )
FROM zzad_d_booking
WHERE booking_status = 1
INTO @DATA(lv_books_on_hands).

WRITE:/ |How many books are on hand - { lv_books_on_hands } |.

ULINE.

*B. How many books are in the library (free)
SELECT COUNT( book_id )
FROM zzad_d_booking
WHERE booking_status = 2
INTO @DATA(lv_books_in_library).

WRITE:/ |How many books are in the library (free) - { lv_books_in_library } |.

ULINE.

*C. The most-read author
SELECT
  b~author_id,
  at~author_first_name,
  at~author_last_name,
  COUNT( bk~booking_id ) AS booking_count
FROM zzad_d_booking AS bk
INNER JOIN zzad_d_book AS b
  ON bk~book_id = b~book_id
INNER JOIN zzad_d_author_t AS at
  ON b~author_id = at~author_id
  AND at~langu = 'E'
GROUP BY
  b~author_id,
  at~author_first_name,
  at~author_last_name
ORDER BY booking_count DESCENDING
INTO @DATA(ls_booking)
UP TO 1 ROWS.
ENDSELECT.

WRITE:/ |The most-read author - { ls_booking-author_first_name } { ls_booking-author_last_name }| .

ULINE.

*D. The reader who read the most books
TYPES:
  BEGIN OF ty_reader_book,
    reader_id TYPE zzad_d_booking-person_id,
    book_id   TYPE zzad_d_booking-book_id,
  END OF ty_reader_book,

  BEGIN OF ty_reader_count,
    reader_id TYPE zzad_d_booking-person_id,
    count     TYPE i,
  END OF ty_reader_count.

DATA:
  lt_reader_book  TYPE HASHED TABLE OF ty_reader_book WITH UNIQUE KEY reader_id book_id,
  lt_reader_count TYPE TABLE OF ty_reader_count.

SELECT person_id, person_first_name, person_last_name
FROM zzad_d_reader_t
WHERE langu = 'E'
INTO TABLE @DATA(lt_reader).

SELECT *
FROM zzad_d_booking
WHERE booking_status EQ 2
INTO TABLE @DATA(lt_booking).

LOOP AT lt_booking INTO DATA(wa_booking).
  READ TABLE lt_reader_book WITH KEY
                        reader_id = wa_booking-person_id
                        book_id = wa_booking-book_id
  TRANSPORTING NO FIELDS.

  IF sy-subrc NE 0.
    INSERT VALUE #(
      reader_id = wa_booking-person_id
      book_id   = wa_booking-book_id
    ) INTO TABLE lt_reader_book.
  ENDIF.

ENDLOOP.

LOOP AT lt_reader_book INTO DATA(wa_reader_book).
  READ TABLE lt_reader_count WITH KEY
                        reader_id = wa_reader_book-reader_id
  INTO DATA(ls_reader_count).

  IF sy-subrc NE 0.
    ls_reader_count = VALUE #(
      reader_id = wa_reader_book-reader_id
      count     = 1
    ).
    INSERT ls_reader_count INTO TABLE lt_reader_count.
  ELSE.
    ls_reader_count-count = ls_reader_count-count + 1.
    MODIFY TABLE lt_reader_count FROM ls_reader_count.
  ENDIF.

  CLEAR ls_reader_count.
ENDLOOP.

SORT lt_reader_count BY count DESCENDING.

READ TABLE lt_reader_count INDEX 1 INTO ls_reader_count.
READ TABLE lt_reader WITH KEY person_id = ls_reader_count-reader_id INTO DATA(lv_result).

WRITE:/ |The reader who read the most books - { lv_result-person_first_name } { lv_result-person_last_name }| .

