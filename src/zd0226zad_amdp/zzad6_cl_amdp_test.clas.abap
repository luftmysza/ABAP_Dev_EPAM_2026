CLASS zzad6_cl_amdp_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
      IMPORTING
        VALUE(iv_carrid) TYPE s_carr_id
        VALUE(iv_connid) TYPE s_conn_ID
      EXPORTING
        VALUE(et_result) TYPE flighttab.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzad6_cl_amdp_test IMPLEMENTATION.

  METHOD get_data
  BY DATABASE PROCEDURE FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING sflight.

    et_result =
        SELECT *
        FROM sflight
        WHERE mandt = session_context('CLIENT')
          AND carrid = :iv_carrid
          AND connid = :iv_connid;

  ENDMETHOD.

ENDCLASS.
