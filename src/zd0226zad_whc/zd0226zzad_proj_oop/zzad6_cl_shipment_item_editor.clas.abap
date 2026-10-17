CLASS zzad6_cl_shipment_item_editor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES ty_mode TYPE c LENGTH 1.
    CONSTANTS:
      gc_mode_create TYPE ty_mode VALUE 'C',
      gc_mode_edit   TYPE ty_mode VALUE 'E'.

    METHODS start_create
      IMPORTING
        iv_ship_id TYPE zzad6_d_ship_itm-ship_id
        iv_line_no TYPE zzad6_d_ship_itm-line_no.

    METHODS start_edit
      IMPORTING
        io_item TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_validation.

    METHODS confirm
      RETURNING
        VALUE(ro_item) TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_validation.

    METHODS is_create_mode
      RETURNING
        VALUE(rv_create) TYPE abap_bool.

    METHODS cancel.

  PRIVATE SECTION.
    DATA mv_mode TYPE ty_mode.
    DATA ms_data TYPE zzad6_if_screen_data=>shipment_item_details.

ENDCLASS.



CLASS ZZAD6_CL_SHIPMENT_ITEM_EDITOR IMPLEMENTATION.


  METHOD cancel.
    CLEAR:
      mv_mode,
      ms_data.


  ENDMETHOD.


  METHOD confirm.
*    IF mv_mode IS INITIAL.
*      RAISE EXCEPTION TYPE zzad6_cx_validation.
*    ENDIF.
*
*    IF is_data-ship_id <> ms_data-ship_id
*    OR is_data-line_no <> ms_data-line_no.
*      RAISE EXCEPTION TYPE zzad6_cx_validation.
*    ENDIF.
*
*    ro_item = zzad6_cl_shipment_item=>create(
*      iv_ship_id     = ms_data-ship_id
*      iv_line_no     = ms_data-line_no
*      iv_material_id = is_data-material_id
*      iv_loc_id      = is_data-loc_id
*      iv_qty         = is_data-qty ).

  ENDMETHOD.


  METHOD is_create_mode.
    rv_create = xsdbool( mv_mode = gc_mode_create ).
  ENDMETHOD.


  METHOD start_create.
    CLEAR ms_data.

    ms_data-ship_id = iv_ship_id.
    ms_data-line_no = iv_line_no.

    mv_mode = gc_mode_create.

  ENDMETHOD.


  METHOD start_edit.
    IF io_item IS NOT BOUND.
      RAISE EXCEPTION TYPE zzad6_cx_validation.
    ENDIF.

    DATA(ls_item) = io_item->get_data( ).

    ms_data = CORRESPONDING #( ls_item ).
    mv_mode = gc_mode_edit.

  ENDMETHOD.
ENDCLASS.
