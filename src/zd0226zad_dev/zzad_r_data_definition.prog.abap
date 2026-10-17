*&---------------------------------------------------------------------*
*& Report ZZAD_R_DATA_DEFINITION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_data_definition.

* ==== START Data & Type declarations
* -- Task1
TYPES:
  BEGIN OF gty_s_author,
    author_first_name TYPE zzad_d_author_t-author_first_name,
    author_last_name  TYPE zzad_d_author_t-author_last_name,
  END OF gty_s_author.

DATA: gt_author TYPE TABLE OF gty_s_author.
FIELD-SYMBOLS: <gs_author> TYPE gty_s_author.

DATA gv_date TYPE datum.
DATA gv_year TYPE int4.
* -- Task2
TYPES:
  BEGIN OF gty_s_reader,
    birth_date        TYPE zzad_d_reader-birth_date,
    person_first_name TYPE zzad_d_reader_t-person_first_name,
    person_last_name  TYPE zzad_d_reader_t-person_last_name,
    phone_number      TYPE zzad_d_reader-phone_number,
  END OF gty_s_reader.

DATA: gt_reader TYPE TABLE OF gty_s_reader.
FIELD-SYMBOLS: <gs_reader> TYPE gty_s_reader.
* -- Task3
TYPES:
  BEGIN OF gty_s_author2,
    author_first_name TYPE zzad_d_author_t-author_first_name,
    author_last_name  TYPE zzad_d_author_t-author_last_name,
    birth_date        TYPE zzad_d_author-birth_date,
  END OF gty_s_author2.

DATA: gt_author2 TYPE TABLE OF gty_s_author2.
FIELD-SYMBOLS: <gs_author2> TYPE gty_s_author2.
* -- Task4
TYPES:
  BEGIN OF gty_s_reader2,
    person_id         TYPE zzad_d_booking-person_id,
    person_first_name TYPE zzad_d_reader_t-person_first_name,
    person_last_name  TYPE zzad_d_reader_t-person_last_name,
    book_cnt          TYPE i,
  END OF gty_s_reader2.

DATA: gt_reader2 TYPE TABLE OF gty_s_reader2.
FIELD-SYMBOLS: <gs_reader2> TYPE gty_s_reader2.
* -- Task5
TYPES:
  BEGIN OF gty_s_country,
    country TYPE  zzad_d_author-country,
    country_name TYPE t005-xland,
    author_cnt   TYPE i,
  END OF gty_s_country.

DATA: gt_country TYPE TABLE OF gty_s_country.
FIELD-SYMBOLS: <gs_country> TYPE gty_s_country.
* ==== END Data & Type declarations

*Task 1

SELECT author_first_name, author_last_name
  FROM zzad_d_author_t
  INTO TABLE @gt_author
  WHERE author_last_name LIKE 'H%'
  AND langu = 'E'.

WRITE: 'Task 1'.
SKIP.

LOOP AT gt_author ASSIGNING <gs_author>.
  WRITE: / <gs_author>-author_first_name, <gs_author>-author_last_name.
ENDLOOP.

ULINE.

*Task 2
SELECT
  birth_date  AS birth_date,
  person_first_name  AS person_first_name,
  person_last_name  AS person_last_name,
  phone_number  AS phone_number
  FROM zzad_d_reader INNER JOIN zzad_d_reader_t ON
   zzad_d_reader~person_id = zzad_d_reader_t~person_id
  WHERE langu = 'E'
  AND birth_date IN ( SELECT  MAX( birth_date ) AS birth_date FROM zzad_d_reader )
  INTO TABLE @gt_reader.


WRITE: 'Task 2'.
SKIP.

LOOP AT gt_reader ASSIGNING <gs_reader>.
  WRITE: / <gs_reader>-person_first_name, <gs_reader>-person_last_name, <gs_reader>-phone_number.
ENDLOOP.

ULINE.

*Task 3
gv_date = sy-datum.
gv_year = gv_date+0(4).
gv_year = gv_year - 50.
gv_date+0(4) = gv_year.

SELECT author_first_name, author_last_name, birth_date
  FROM zzad_d_author INNER JOIN zzad_d_author_t ON
  zzad_d_author~author_id = zzad_d_author_t~author_id
  WHERE langu = 'E'
  AND birth_date > @gv_date
  INTO TABLE @gt_author2.

WRITE: 'Task 3'.
SKIP.

LOOP AT gt_author2 ASSIGNING <gs_author2>.
  WRITE: / <gs_author2>-author_first_name, <gs_author2>-author_last_name.
ENDLOOP.

ULINE.

*Task4
SELECT
  zzad_d_booking~person_id AS person_id,
  MIN( person_first_name )  AS person_first_name,
  MIN( person_last_name )  AS person_last_name,
  COUNT( * ) AS book_cnt
  FROM zzad_d_booking INNER JOIN zzad_d_reader_t ON
   zzad_d_booking~person_id = zzad_d_reader_t~person_id
  WHERE langu = 'E'
  AND booking_status = 2
  GROUP BY zzad_d_booking~person_id
  INTO TABLE @gt_reader2.

WRITE: 'Task 4'.
SKIP.

LOOP AT gt_reader2 ASSIGNING <gs_reader2>.
  WRITE: / <gs_reader2>-person_first_name, <gs_reader2>-person_last_name, <gs_reader2>-book_cnt.
ENDLOOP.

ULINE.

*Task 5
SELECT
  country,
  landx AS country_name,
  COUNT( * ) AS author_cnt
  FROM zzad_d_author INNER JOIN t005t ON
  zzad_d_author~country = t005t~land1
  WHERE spras = 'E'
  GROUP BY country, landx
  ORDER BY landx
  INTO TABLE @gt_country.

WRITE: 'Task 5'.
SKIP.

LOOP AT gt_country ASSIGNING <gs_country>.
  WRITE: / <gs_country>-country_name, <gs_country>-author_cnt.
ENDLOOP.

ULINE.
