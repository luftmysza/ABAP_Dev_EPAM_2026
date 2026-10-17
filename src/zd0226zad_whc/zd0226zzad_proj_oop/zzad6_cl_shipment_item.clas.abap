CLASS zzad6_cl_shipment_item DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create_template
      IMPORTING
        iv_ship_id     TYPE zzad6_d_ship_itm-ship_id
        iv_line_no     TYPE zzad6_d_ship_itm-line_no
        iv_material_id TYPE zzad6_d_ship_itm-material_id OPTIONAL
        iv_loc_id      TYPE zzad6_d_ship_itm-loc_id OPTIONAL
        iv_qty         TYPE zzad6_d_ship_itm-qty OPTIONAL
      RETURNING
        VALUE(ro_item) TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_validation.

    CLASS-METHODS reconstitute
      IMPORTING
        is_item        TYPE zzad6_d_ship_itm
      RETURNING
        VALUE(ro_item) TYPE REF TO zzad6_cl_shipment_item.

    METHODS get_data
      RETURNING
        VALUE(rs_item) TYPE zzad6_d_ship_itm.

    METHODS get_line_no
      RETURNING
        VALUE(rv_line_no) TYPE zzad6_d_ship_itm-line_no.

    METHODS set_data
      IMPORTING
        is_item TYPE zzad6_d_ship_itm
      RAISING
        zzad6_cx_validation.

  PRIVATE SECTION.
    DATA ms_item TYPE zzad6_d_ship_itm.

ENDCLASS.



CLASS ZZAD6_CL_SHIPMENT_ITEM IMPLEMENTATION.


  METHOD create_template.

    IF iv_ship_id IS INITIAL
       OR iv_line_no IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_validation.
    ENDIF.

    ro_item = NEW #( ).

    ro_item->ms_item-ship_id     = iv_ship_id.
    ro_item->ms_item-line_no     = iv_line_no.
    ro_item->ms_item-material_id = iv_material_id.
    ro_item->ms_item-loc_id      = iv_loc_id.
    ro_item->ms_item-qty         = iv_qty.

  ENDMETHOD.


  METHOD get_data.
    rs_item = ms_item.
  ENDMETHOD.


  METHOD get_line_no.
    rv_line_no = ms_item-line_no.
  ENDMETHOD.


  METHOD reconstitute.
    ro_item = NEW #( ).
    ro_item->ms_item = is_item.

  ENDMETHOD.


  METHOD set_data.
    ms_item-material_id = is_item-material_id.
    ms_item-loc_id      = is_item-loc_id.
    ms_item-qty         = is_item-qty.

  ENDMETHOD.
ENDCLASS.
