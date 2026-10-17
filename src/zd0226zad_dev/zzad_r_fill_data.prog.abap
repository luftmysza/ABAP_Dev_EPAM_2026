*&---------------------------------------------------------------------*
*& Report ZZAD_R_FILL_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZZAD_R_FILL_DATA.

DATA gv_count TYPE int4.

*&---------------------------------------------------------------------*
*& Select data from the XXX table READER
*&---------------------------------------------------------------------*
SELECT *
  FROM ZXXX_D_READER
  INTO TABLE @DATA(gt_reader).
*&---------------------------------------------------------------------*
*& Insert data into your own table READER
*&---------------------------------------------------------------------*
MODIFY ZZAD_D_READER FROM TABLE gt_reader.

*&---------------------------------------------------------------------*
*& Check number of entries in your own table READER
*&---------------------------------------------------------------------*
CLEAR gv_count.
SELECT COUNT(*) FROM ZZAD_D_READER INTO gv_count.
WRITE: 'Number of entries in READER: ', gv_count.

*&---------------------------------------------------------------------*
*& Select data from the XXX table READER_T
*&---------------------------------------------------------------------*
*Write your code:
SELECT * FROM ZXXX_D_READER_T INTO TABLE @DATA(gt_reader_t).
MODIFY ZZAD_D_READER_T FROM TABLE gt_reader_t.

*&---------------------------------------------------------------------*
*& Insert data into your own table READER_T
*&---------------------------------------------------------------------*
*Write your code:
CLEAR gv_count.
SELECT COUNT(*) FROM ZZAD_D_READER_T INTO gv_count.
WRITE: / 'Number of entries in READER_T: ', gv_count.
*Check number of entries:

*&---------------------------------------------------------------------*
*& Select data from the XXX table AUTHOR
*&---------------------------------------------------------------------*
*Write your code:
SELECT * FROM ZXXX_D_AUTHOR INTO TABLE @DATA(gt_author).
MODIFY ZZAD_D_AUTHOR FROM TABLE gt_author.

*&---------------------------------------------------------------------*
*& Insert data into your own table AUTHOR
*&---------------------------------------------------------------------*
*Write your code:
CLEAR gv_count.
SELECT COUNT(*) FROM ZZAD_D_AUTHOR INTO gv_count.
WRITE: / 'Number of entries in AUTHOR: ', gv_count.
*Check number of entries:

*&---------------------------------------------------------------------*
*& Select data from the XXX table AUTHOR_T
*&---------------------------------------------------------------------*
*Write your code:
SELECT * FROM ZXXX_D_AUTHOR_T INTO TABLE @DATA(gt_author_t).
MODIFY ZZAD_D_AUTHOR_T FROM TABLE gt_author_t.
*&---------------------------------------------------------------------*
*& Insert data into your own table AUTHOR_T
*&---------------------------------------------------------------------*
*Write your code:
CLEAR gv_count.
SELECT COUNT(*) FROM ZZAD_D_AUTHOR_T INTO gv_count.
WRITE: / 'Number of entries in AUTHOR_T: ', gv_count.
*Check number of entries:

*&---------------------------------------------------------------------*
*& Select data from the XXX table BOOK
*&---------------------------------------------------------------------*
*Write your code:
SELECT * FROM ZXXX_D_BOOK INTO TABLE @DATA(gt_book).
MODIFY ZZAD_D_BOOK FROM TABLE gt_book.

*&---------------------------------------------------------------------*
*& Insert data into your own table BOOK
*&---------------------------------------------------------------------*
*Write your code:
CLEAR gv_count.
SELECT COUNT(*) FROM ZZAD_D_BOOK INTO gv_count.
WRITE: / 'Number of entries in BOOK: ', gv_count.
*Check number of entries:

*&---------------------------------------------------------------------*
*& Select data from the XXX table BOOKING
*&---------------------------------------------------------------------*
*Write your code:
SELECT * FROM ZXXX_D_BOOKING INTO TABLE @DATA(gt_booking).
MODIFY ZZAD_D_BOOKING FROM TABLE gt_booking.

*&---------------------------------------------------------------------*
*& Insert data into your own table BOOKING
*&---------------------------------------------------------------------*
*Write your code:
CLEAR gv_count.
SELECT COUNT(*) FROM ZZAD_D_BOOKING INTO gv_count.
WRITE: / 'Number of entries in BOOKING: ', gv_count.
*Check number of entries:
