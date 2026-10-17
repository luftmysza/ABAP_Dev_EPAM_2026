CLASS zzad6_cl_shipment DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES tt_item_refs
      TYPE STANDARD TABLE OF REF TO zzad6_cl_shipment_item
      WITH EMPTY KEY.

    CLASS-METHODS reconstitute
      IMPORTING
        is_header          TYPE zzad6_d_shipment
        it_items           TYPE zzad6_if_shipment_repository=>tt_d_shipment_item
      RETURNING
        VALUE(ro_shipment) TYPE REF TO zzad6_cl_shipment.

    CLASS-METHODS create_new
      IMPORTING
        iv_shipment_id     TYPE zzad6_ship_id
        iv_ship_date       TYPE sydatum
      RETURNING
        VALUE(ro_shipment) TYPE REF TO zzad6_cl_shipment
      RAISING
        zzad6_cx_validation.

    METHODS put_item
      IMPORTING
        io_item TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_validation.

    METHODS get_header_flat
      RETURNING
        VALUE(rs_header) TYPE zzad6_d_shipment.

    METHODS get_items_flat
      RETURNING
        VALUE(rt_items) TYPE zzad6_if_shipment_repository=>tt_d_shipment_item.

    METHODS get_items
      RETURNING
        VALUE(rt_items) TYPE tt_item_refs
      RAISING
        zzad6_cx_not_found.

    METHODS get_item
      IMPORTING
        iv_line_no     TYPE zzad6_d_ship_itm-line_no
      RETURNING
        VALUE(ro_item) TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_not_found.

    METHODS get_next_line_no
      RETURNING
        VALUE(rv_line_no) TYPE zzad6_d_ship_itm-line_no.

    METHODS set_partner
      IMPORTING
        iv_bp_id TYPE zzad6_bp_id.

    METHODS get_partner
      RETURNING
        VALUE(rv_bp_id) TYPE zzad6_bp_id.

    METHODS set_ship_date
      IMPORTING
        iv_ship_date TYPE sydatum
      RAISING
        zzad6_cx_validation.

    METHODS get_ship_date
      RETURNING
        VALUE(rv_ship_date) TYPE sydatum.

    METHODS add_item
      IMPORTING
        io_item TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_validation.

    METHODS remove_item
      IMPORTING
        iv_line_no TYPE zzad6_d_ship_itm-line_no
      RAISING
        zzad6_cx_not_found.


  PRIVATE SECTION.
    DATA ms_header TYPE zzad6_d_shipment.
    DATA mt_items  TYPE tt_item_refs.



ENDCLASS.



CLASS ZZAD6_CL_SHIPMENT IMPLEMENTATION.


  METHOD add_item.
    IF io_item IS NOT BOUND.
      RAISE EXCEPTION TYPE zzad6_cx_validation.
    ENDIF.

    DATA(lv_new_line_no) = io_item->get_line_no( ).

    LOOP AT mt_items INTO DATA(lo_existing_item).
      IF lo_existing_item->get_line_no( ) = lv_new_line_no.
        RAISE EXCEPTION TYPE zzad6_cx_validation.
      ENDIF.

    ENDLOOP.

    APPEND io_item TO mt_items.

  ENDMETHOD.


  METHOD create_new.
    IF iv_shipment_id IS INITIAL
       OR iv_ship_date IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_validation.
    ENDIF.

    IF iv_ship_date < sy-datum.
      RAISE EXCEPTION TYPE zzad6_cx_validation.
    ENDIF.

    ro_shipment = NEW #( ).

    ro_shipment->ms_header-ship_id   = iv_shipment_id.
    ro_shipment->ms_header-ship_date = iv_ship_date.

  ENDMETHOD.


  METHOD get_header_flat.
    rs_header = ms_header.
  ENDMETHOD.


  METHOD get_item.
    LOOP AT mt_items INTO DATA(lo_item).
      IF lo_item->get_line_no( ) = iv_line_no.
        ro_item = lo_item.
        RETURN.
      ENDIF.

    ENDLOOP.

    RAISE EXCEPTION TYPE zzad6_cx_not_found
      EXPORTING
        textid     = zzad6_cx_not_found=>shipment_item
        entity_id  = CONV symsgv( iv_line_no )
        entity_id2 = CONV symsgv( get_header_flat( )-ship_id ).

  ENDMETHOD.


  METHOD get_items.
    rt_items = mt_items .
  ENDMETHOD.


  METHOD get_items_flat.
    LOOP AT mt_items INTO DATA(lo_item).
      APPEND lo_item->get_data( ) TO rt_items.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_next_line_no.
    rv_line_no = 10.

    LOOP AT mt_items INTO DATA(lo_item).
      DATA(lv_existing_line_no) =
        lo_item->get_line_no( ).

      IF lv_existing_line_no >= rv_line_no.
        rv_line_no = lv_existing_line_no + 10.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_partner.
    rv_bp_id = ms_header-bp_id.
  ENDMETHOD.


  METHOD get_ship_date.
    rv_ship_date = ms_header-ship_date.
  ENDMETHOD.


  METHOD put_item.
    DATA(lv_line_no) = io_item->get_line_no( ).

    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<lo_item>).
      IF <lo_item>->get_line_no( ) = lv_line_no.
        <lo_item> = io_item.
        RETURN.
      ENDIF.
    ENDLOOP.

    APPEND io_item TO mt_items.

  ENDMETHOD.


  METHOD reconstitute.
    ro_shipment = NEW #( ).
    ro_shipment->ms_header = is_header.

    LOOP AT it_items INTO DATA(ls_item).
      APPEND zzad6_cl_shipment_item=>reconstitute( is_item = ls_item )
          TO ro_shipment->mt_items.

    ENDLOOP.

  ENDMETHOD.


  METHOD remove_item.
    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<lo_item>) FROM 1.
      IF <lo_item>->get_line_no( ) = iv_line_no.
        DELETE mt_items INDEX sy-tabix.
        RETURN.
      ENDIF.

    ENDLOOP.

    RAISE EXCEPTION TYPE zzad6_cx_not_found
      EXPORTING
        textid     = zzad6_cx_not_found=>shipment_item
        entity_id  = CONV symsgv( iv_line_no )
        entity_id2 = CONV symsgv( get_header_flat( )-ship_id ).

  ENDMETHOD.


  METHOD set_partner.
    ms_header-bp_id = iv_bp_id.
  ENDMETHOD.


  METHOD set_ship_date.
    IF iv_ship_date IS INITIAL
       OR iv_ship_date <= sy-datum .

      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>date_not_in_future
          date   = sy-datum.
    ENDIF.

    ms_header-ship_date = iv_ship_date.

  ENDMETHOD.
ENDCLASS.
