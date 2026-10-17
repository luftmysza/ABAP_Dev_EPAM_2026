*&---------------------------------------------------------------------*
*& Include          ZZAD_R_LIBRARY_INFO_TOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_data,
         author_id     TYPE zzad_d_author-author_id,
         first_name    TYPE zzad_d_author_t-author_first_name,
         last_name     TYPE zzad_d_author_t-author_last_name,
         date_of_birth TYPE zzad_d_author-birth_date,
         country_code  TYPE zzad_d_author-country,
         country_name  TYPE t005T-landx,
         book_id       TYPE zzad_d_book-book_id,
         book_name     TYPE  zzad_d_book-book_name,
       END OF ty_data.

DATA: lt_data TYPE TABLE OF ty_data,
      ls_data TYPE ty_data.
