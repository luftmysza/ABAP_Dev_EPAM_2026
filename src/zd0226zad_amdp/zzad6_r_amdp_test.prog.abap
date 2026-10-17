*&---------------------------------------------------------------------*
*& Report zzad6_r_amdp_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad6_r_amdp_test.

DATA lt_sflight TYPE flighttab.
DATA lo_alv TYPE REF TO cl_salv_table.

zzad6_cl_amdp_test=>get_data(
    EXPORTING
        iv_carrid = 'AA'
        iv_connid = '017'
    IMPORTING
        et_result = lt_sflight ).

TRY.

    CALL METHOD cl_salv_table=>factory
      EXPORTING
        list_display   = if_salv_c_bool_sap=>false
      IMPORTING
        r_salv_table   = lo_alv
      CHANGING
        t_table        = lt_sflight.

    CATCH cx_salv_msg.

ENDTRY.

CALL METHOD lo_alv->display.
