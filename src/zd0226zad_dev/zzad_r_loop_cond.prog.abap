*&---------------------------------------------------------------------*
*& Report ZZAD_R_LOOP_COND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad_r_loop_cond.

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

