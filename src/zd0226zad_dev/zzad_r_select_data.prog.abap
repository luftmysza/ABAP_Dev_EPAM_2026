*&---------------------------------------------------------------------*
*& Report ZZAD_R_SELECT_DATA
*&---------------------------------------------------------------------*

REPORT zzad_r_select_data.

*Show on the screen the first and last names of the authors
*whose last names start with the Latin letter H. (AUTHOR_T, langu='E')
SELECT
  author_first_name, author_last_name
  FROM zzad_d_author_t
  INTO TABLE @DATA(gt_author)
  WHERE author_last_name LIKE 'H%'
  AND langu = 'E'.

WRITE:/ 'Authors whose last names start with the letter ''H'':' .
LOOP AT gt_author ASSIGNING FIELD-SYMBOL(<wa_author>).
  WRITE:/ <wa_author>-author_first_name, <wa_author>-author_last_name .
ENDLOOP.

SKIP.
*Show on the screen the full name and phone number
*of the youngest reader. (READER, READER_T langu='E')
SELECT
  person_first_name, person_last_name, phone_number
  FROM zzad_d_reader AS r
  INNER JOIN zzad_d_reader_t AS rt
    ON r~person_id = rt~person_id
  WHERE langu = 'E'
  ORDER BY birth_date DESCENDING
  INTO @DATA(gs_reader)
  UP TO 1 ROWS.

  WRITE:/
  |Youngest author is { gs_reader-person_first_name } { gs_reader-person_last_name }, { gs_reader-phone_number }.|.
ENDSELECT.

SKIP.
*Show on the screen the first and last names
*of all authors under 50*. (AUTHOR, AUTHOR_T, langu='E' Sy-datum)

CLEAR gt_author.

DATA(lv_date_cutoff) = sy-datum - 50 * 365.

SELECT
  author_first_name, author_last_name
  FROM zzad_d_author AS a
  INNER JOIN zzad_d_author_t AS at
    ON a~author_id = at~author_id
  WHERE langu = 'E' AND birth_date <= @lv_date_cutoff
  INTO TABLE @gt_author.

WRITE:/ 'Authors under 50:' .
LOOP AT gt_author ASSIGNING <wa_author>.
  WRITE:/ <wa_author>-author_first_name, <wa_author>-author_last_name .
ENDLOOP.

SKIP.
*Show on the screen the first and last names of the readers
*who currently have books and the count of these books. (READER_T langu='E', BOOKING, BOOKING_STATUS = 2)
SELECT
  person_first_name, person_last_name, COUNT( b~booking_id ) AS no_bookings
  FROM zzad_d_reader_t AS rt
  INNER JOIN zzad_d_booking AS b
    ON b~person_id = rt~person_id
  WHERE b~booking_status = 2 AND rt~langu = 'E'
  GROUP BY person_first_name, person_last_name
  INTO TABLE @DATA(gt_reader_name).

WRITE:/ 'Readers with active bookings:' .
LOOP AT gt_reader_name ASSIGNING FIELD-SYMBOL(<wa_reader_name>).
  WRITE:/ |{ <wa_reader_name>-person_first_name } { <wa_reader_name>-person_last_name } - { <wa_reader_name>-no_bookings }|.
ENDLOOP.

SKIP.
*Show on the screen the names of the authors' home countries in alphabetical order,
*as well as the number of authors from each country. (AUTHOR, T005)
SELECT
  a~country, COUNT( author_id ) AS no_authors
  FROM zzad_d_author AS a
  LEFT JOIN t005
  ON a~country = t005~land1
  GROUP BY country
  ORDER BY country ASCENDING
  INTO TABLE @DATA(gt_country_author_count).


WRITE:/ 'Authors'' countries and author count pro country:' .
LOOP AT gt_country_author_count ASSIGNING FIELD-SYMBOL(<wa_cac>).
  IF <wa_cac>-country is initial.
    <wa_cac>-country = '???'.
  ENDIF.
  WRITE:/ |{ <wa_cac>-country } - { <wa_cac>-no_authors }|.
ENDLOOP.


