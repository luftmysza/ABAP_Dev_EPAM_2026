*&---------------------------------------------------------------------*
*& Include          ZZAD6_R_UPDATE_LOCAL_TOP
*&---------------------------------------------------------------------*
TABLES: sscrfields.

TYPES:
  BEGIN OF ty_s_author_name,
    langu      TYPE zzad_d_author_t-langu,
    first_name TYPE zzad_d_author_t-author_first_name,
    last_name  TYPE zzad_d_author_t-author_last_name,
  END OF ty_s_author_name,

  ty_t_author_name TYPE STANDARD TABLE OF ty_s_author_name WITH KEY langu,

  BEGIN OF ty_s_author,
    author_id  TYPE zzad_d_author-author_id,
    birth_date TYPE zzad_d_author-birth_date,
    country    TYPE zzad_d_author-country,
    names      TYPE ty_t_author_name,
  END OF ty_s_author.

*  ty_t_author TYPE STANDARD TABLE OF ty_s_author WITH KEY author_id.

DATA:
  gs_author              TYPE ty_s_author,
  gs_name                TYPE ty_s_author_name,
  lv_counter             TYPE i,
  lv_author              TYPE zzad_d_author,
  lt_author_t            TYPE TABLE OF zzad_d_author_t,
  lv_author_name_wrapper TYPE ty_s_author_name.

SET UPDATE TASK LOCAL.
