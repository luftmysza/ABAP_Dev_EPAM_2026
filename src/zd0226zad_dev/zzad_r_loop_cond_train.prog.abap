*&---------------------------------------------------------------------*
*& Report ZZAD_R_LOOP_COND_TRAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_loop_cond_train.
* ===============================================================================
* TASK 4.3
* ===============================================================================

*2. Authors by country
*
*    Select from your tables the names and last names of all the authors in English and their country key to the internal table.
*    Select all the countries and the names of the authors from each, as well as the number of authors, in another internal table (or create an internal table with this information).
*    For each country, first print the name of the country and the number of authors from it, and then list the authors.

SELECT
  author_first_name,
  author_last_name,
  country
FROM zzad_d_author
LEFT JOIN zzad_d_author_t
  ON zzad_d_author~author_id = zzad_d_author_t~author_id
WHERE langu = 'E'
INTO TABLE @DATA(gt_author).

SELECT country,
       COUNT( author_id ) AS cnt
FROM zzad_d_author
GROUP BY country
INTO TABLE @DATA(gt_country).

LOOP AT gt_country ASSIGNING FIELD-SYMBOL(<gs_country>).
  IF <gs_country>-country IS INITIAL.
    <gs_country>-country = '??'.
  ENDIF.
  WRITE:/ |Country { <gs_country>-country } has { <gs_country>-cnt } authors:|.
  LOOP AT gt_author ASSIGNING FIELD-SYMBOL(<gs_author>).
    IF <gs_author>-country IS INITIAL.
      <gs_author>-country = '??'.
    ENDIF.
    IF <gs_country>-country = <gs_author>-country.
      WRITE:/ | - { <gs_author>-author_first_name } { <gs_author>-author_last_name }|.
    ENDIF.
  ENDLOOP.
ENDLOOP.

*3. Books from the BOOKING table by BOOKING_STATUS
*
*    Select all the books from the BOOKING table with their titles (join BOOK) and status, sorted by status.
*    Write "Now reading:" and in the next line, type the list of books with status 2.
*    Write "Already returned:" and in the next line, type the list of books with status 1.
ULINE.

SELECT
  b~book_id,
  booking_status,
  book_name
FROM zzad_d_booking AS bg
RIGHT JOIN zzad_d_book AS b
  ON bg~book_id = b~book_id
ORDER BY booking_status
INTO TABLE @DATA(gt_book).

WRITE: / 'Now Reading:'.
LOOP AT gt_book ASSIGNING FIELD-SYMBOL(<gs_book>).
  IF <gs_book>-booking_status = 2.
    WRITE: / <gs_book>-book_name.
  ENDIF.
ENDLOOP.

SKIP.

WRITE: / 'Already returned:'.
LOOP AT gt_book ASSIGNING <gs_book>.
  IF <gs_book>-booking_status = 1.
    WRITE: / <gs_book>-book_name.
  ENDIF.
ENDLOOP.
ULINE.

* ===============================================================================
* TASK 4.4
* ===============================================================================

TYPES:
  BEGIN OF gty_s_author2,
    author_id         TYPE  zzad_d_author-author_id,
    birth_date        TYPE  zzad_d_author-birth_date,
    country           TYPE   zzad_d_author-country,
    author_first_name TYPE zzad_d_author_t-author_first_name,
    author_last_name  TYPE zzad_d_author_t-author_last_name,
  END OF gty_s_author2.

DATA: gt_author2 TYPE TABLE OF gty_s_author2.
DATA wa_author TYPE gty_s_author2.

SELECT a~author_id, birth_date, country, author_first_name, author_last_name
FROM zzad_d_author AS a
LEFT JOIN zzad_d_author_t
  ON a~author_id = zzad_d_author_t~author_id
WHERE langu = 'E'
INTO TABLE @gt_author2.

TYPES:
  BEGIN OF gty_s_reader2,
    person_id         TYPE zzad_d_reader-person_id,
    birth_date        TYPE zzad_d_reader-birth_date,
    phone_number      TYPE zzad_d_reader-phone_number,
    person_first_name TYPE zzad_d_reader_t-person_first_name,
    person_last_name  TYPE zzad_d_reader_t-person_last_name,
  END OF gty_s_reader2.

DATA: gt_reader2 TYPE TABLE OF gty_s_reader2.
DATA wa_reader TYPE gty_s_reader2.

SELECT r~person_id, birth_date, person_first_name, person_last_name
FROM zzad_d_reader AS r
LEFT JOIN zzad_d_reader_t
  ON r~person_id = zzad_d_reader_t~person_id
WHERE langu = 'E'
INTO TABLE @gt_reader2.


*2. Find the youngest and oldest author.
DATA gs_youngest_author LIKE LINE OF gt_author2.
DATA gs_oldest_author   LIKE LINE OF gt_author2.

LOOP AT gt_author2 INTO wa_author.
  IF gs_youngest_author IS INITIAL OR gs_youngest_author-birth_date < wa_author-birth_date.
    MOVE wa_author TO gs_youngest_author.
  ENDIF.
  IF gs_oldest_author IS INITIAL OR gs_oldest_author-birth_date > wa_author-birth_date.
    MOVE wa_author TO gs_oldest_author.
  ENDIF.
ENDLOOP.

WRITE:/ |Youngest author { gs_youngest_author-author_first_name } { gs_youngest_author-author_last_name }|.
WRITE:/ |Oldest author { gs_oldest_author-author_first_name } { gs_oldest_author-author_last_name }|.
ULINE.

*3. Find the average year of birth of the authors.
DATA:
  lv_year_sum   TYPE i,
  lv_year_count TYPE i,
  lv_year_avg   TYPE i,
  lv_year       TYPE i.

LOOP AT gt_author2 INTO wa_author.
  lv_year = wa_author-birth_date(4).
  lv_year_sum = lv_year_sum + lv_year.
  lv_year_count = lv_year_count + 1.
ENDLOOP.

IF lv_year_count > 0.
  lv_year_avg = lv_year_sum / lv_year_count.
ENDIF.

WRITE:/ |Average year of birth: { lv_year_avg }|.	
ULINE.

*4. *Find the average date of birth.
DATA:
  lv_sum   TYPE i,
  lv_count TYPE i,
  lv_avg   TYPE i,
  lv_avg_d TYPE d.

LOOP AT gt_author2 INTO wa_author.
  lv_sum = lv_sum + wa_author-birth_date.
  lv_count = lv_count + 1.
ENDLOOP.

IF lv_count > 0.
  lv_avg = lv_sum / lv_count.
ENDIF.

lv_avg_d = lv_avg.

WRITE:/ |Average birth date (YYYY-MM-DD): { lv_avg_d+0(4) }-{ lv_avg_d+4(2) }-{ lv_avg_d+6(2) } |.
ULINE.

*5. Display the names of authors and their dates of birth by date of birth.
SORT gt_author2 BY birth_date ASCENDING.

LOOP AT gt_author2 INTO wa_author.
  WRITE:/ |{ wa_author-birth_date } { wa_author-author_first_name } { wa_author-author_last_name }|.
ENDLOOP.
ULINE.

*6. Display readers' names and dates of birth by date of birth.

SORT gt_reader2 BY birth_date ASCENDING.

LOOP AT gt_reader2 INTO wa_reader.
  WRITE:/ |{ wa_reader-birth_date+0(4) }-{ wa_reader-birth_date+4(2) }-{ wa_reader-birth_date+6(2) } { wa_reader-person_first_name } { wa_reader-person_last_name }|.
ENDLOOP.
ULINE.


*7. Display the reader who read the most books.
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

WRITE:/ |The person who's read most books is { lv_result-person_first_name } { lv_result-person_last_name }| .


