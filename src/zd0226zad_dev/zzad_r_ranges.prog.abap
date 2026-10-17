*&---------------------------------------------------------------------*
*& Report ZZAD_R_RANGES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_ranges.

TABLES zzad_d_book.

SELECT-OPTIONS:
so_book FOR zzad_d_book-book_id,
so_auth FOR zzad_d_book-author_id.

*Types definition
TYPES:
  BEGIN OF gty_book,
    book_id           TYPE   zzad_book_id,
    book_name         TYPE	zzad_book_name,
    author_first_name TYPE	zzad_first_name,
    author_last_name  TYPE	zzad_last_name,
    copy_qty          TYPE	zzad_copy_qty,
    booked_qty        TYPE	INT2,
    in_stock_qty      TYPE	INT2,
  END OF gty_book.

*Data definition
DATA:
  gt_book1 TYPE TABLE OF gty_book,
  gt_book2 TYPE TABLE OF gty_book.

FIELD-SYMBOLS:  <gs_book> TYPE gty_book.

*Select all books for defined ids and authors

SELECT book_id, book_name, author_first_name, author_last_name
  FROM zzad_d_book AS b
    JOIN zzad_d_author_t AS a
      ON b~author_id = a~author_id
  INTO TABLE @gt_book1
  WHERE b~book_id IN @so_book
    AND a~author_id IN @so_auth
*    AND a~langu = sy-langu.
    AND a~langu = 'E'.

*Write data

LOOP AT gt_book1 ASSIGNING <gs_book>.
  WRITE: / <gs_book>-book_id,
           <gs_book>-book_name,
           <gs_book>-author_first_name,
           <gs_book>-author_last_name.
ENDLOOP.

SKIP.
ULINE.
SKIP.

*Select all books for defined ids and authors and their total and booked quantity

SELECT
  b~book_id,
  b~book_name,
  a~author_first_name,
  a~author_last_name,
  b~copy_qty,
  COUNT( bk~booking_status ) as booked_qty
  FROM zzad_d_book AS b
    JOIN zzad_d_author_t AS a
      ON b~author_id = a~author_id
    LEFT JOIN zzad_d_booking AS bk
     ON bk~book_id = b~book_id
     AND bk~booking_status = 2
  WHERE b~book_id IN @so_book
    AND a~author_id IN @so_auth
    AND a~langu = 'E'
  GROUP BY
     b~book_id,
     b~book_name,
     a~author_first_name,
     a~author_last_name,
     b~copy_qty
  INTO TABLE @gt_book2.

*Write data
LOOP AT gt_book2 ASSIGNING <gs_book>.
  <gs_book>-in_stock_qty = <gs_book>-copy_qty - <gs_book>-booked_qty.
  WRITE: / <gs_book>-book_id,
           <gs_book>-book_name,
           <gs_book>-author_first_name,
           <gs_book>-author_last_name,
           <gs_book>-in_stock_qty.
ENDLOOP.

