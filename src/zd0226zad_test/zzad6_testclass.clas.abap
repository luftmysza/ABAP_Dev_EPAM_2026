CLASS zzad6_testclass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
        INTERFACES
            IF_OO_ADT_CLASSRUN.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzad6_testclass IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(today) = cl_abap_context_info=>get_system_date( ).
    out->write( today ).
    out->write( sy-datum ).
  ENDMETHOD.

ENDCLASS.
