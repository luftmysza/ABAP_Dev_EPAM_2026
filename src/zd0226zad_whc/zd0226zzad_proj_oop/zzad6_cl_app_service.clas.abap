CLASS zzad6_cl_app_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        io_masterdata_repository TYPE REF TO zzad6_if_masterdata_repository
        io_inventory_repository  TYPE REF TO zzad6_if_inventory_repository
        io_shipment_repository   TYPE REF TO zzad6_if_shipment_repository.

    METHODS get_inventory_overview
      IMPORTING
        !iv_warehouse_id    TYPE zzad6_wh_id
      RETURNING
        VALUE(rt_inventory) TYPE zzad6_if_view_structures=>tt_inventory
      RAISING
        zzad6_cx_persistence.

    METHODS get_shipment_overview
      IMPORTING
        iv_warehouse_id     TYPE zzad6_wh_id
        iv_shipment_mode    TYPE zzad6_if_shipment_modes=>code
      RETURNING
        VALUE(rt_shipments) TYPE zzad6_if_view_structures=>tt_shipments
      RAISING
        zzad6_cx_persistence.

    METHODS get_shipment_item_object
      IMPORTING
        iv_line_no              TYPE zzad6_d_ship_itm-line_no OPTIONAL
        io_shipment             TYPE REF TO zzad6_cl_shipment
      RETURNING
        VALUE(ro_shipment_item) TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_validation
        zzad6_cx_not_found
        zzad6_cx_persistence.

    METHODS get_shipment_object
      IMPORTING
        iv_shipment_id     TYPE zzad6_ship_id  OPTIONAL
      RETURNING
        VALUE(ro_shipment) TYPE REF TO zzad6_cl_shipment
      RAISING
        zzad6_cx_validation
        zzad6_cx_not_found
        zzad6_cx_persistence.

    METHODS enrich_warehouse
      IMPORTING
        iv_warehouse_id     TYPE zzad6_wh_id
      RETURNING
        VALUE(rs_warehouse) TYPE zzad6_d_wareh
      RAISING
        zzad6_cx_not_found
        zzad6_cx_persistence.

    METHODS enrich_shipment_draft
      IMPORTING
        io_shipment       TYPE REF TO zzad6_cl_shipment
      RETURNING
        VALUE(rs_partner) TYPE zzad6_d_partner
      RAISING
        zzad6_cx_validation
        zzad6_cx_not_found
        zzad6_cx_persistence.

    METHODS enrich_partner
      IMPORTING
        iv_partner_id     TYPE zzad6_bp_id
      RETURNING
        VALUE(rs_partner) TYPE zzad6_d_partner
      RAISING
        zzad6_cx_not_found
        zzad6_cx_persistence.

    METHODS enrich_material
      IMPORTING
        iv_material_id     TYPE zzad6_mat_id
      RETURNING
        VALUE(rs_material) TYPE zzad6_if_masterdata_repository=>ty_material
      RAISING
        zzad6_cx_not_found
        zzad6_cx_persistence.

    METHODS enrich_location
      IMPORTING
        iv_location_id     TYPE zzad6_loc_id
      RETURNING
        VALUE(rs_location) TYPE zzad6_d_location
      RAISING
        zzad6_cx_not_found
        zzad6_cx_persistence.

    METHODS delete_shipment
      IMPORTING
        iv_shipment_id TYPE zzad6_ship_id
      RAISING
        zzad6_cx_lock
        zzad6_cx_persistence.

    METHODS suggest_item_data
      IMPORTING
        iv_warehouse_id      TYPE zzad6_wh_id
        io_shipment_item     TYPE REF TO zzad6_cl_shipment_item
        io_shipment          TYPE REF TO zzad6_cl_shipment
      RETURNING
        VALUE(rs_suggestion) TYPE zzad6_if_view_structures=>ty_inventory
      RAISING
        zzad6_cx_not_found
        zzad6_cx_persistence
        zzad6_cx_validation.

    METHODS get_shipment_items_overview
      IMPORTING
        it_shipment_items        TYPE zzad6_if_shipment_repository=>tt_d_shipment_item
      RETURNING
        VALUE(rt_shipment_items) TYPE zzad6_if_view_structures=>tt_shipment_items
      RAISING
        zzad6_cx_persistence.

    METHODS save_shipment_draft
      IMPORTING
        io_shipment TYPE REF TO zzad6_cl_shipment
      RAISING
        zzad6_cx_not_found
        zzad6_cx_persistence
        zzad6_cx_validation
        zzad6_cx_lock.

    METHODS insert_item_into_shipment
      IMPORTING
        io_shipment TYPE REF TO zzad6_cl_shipment
        io_item     TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_validation
        zzad6_cx_persistence
        zzad6_cx_not_found.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mo_masterdata_repository TYPE REF TO zzad6_if_masterdata_repository,
      mo_inventory_repository  TYPE REF TO zzad6_if_inventory_repository,
      mo_shipment_repository   TYPE REF TO zzad6_if_shipment_repository.

    METHODS lock_shipment
      IMPORTING
        iv_shipment_id TYPE zzad6_ship_id
      RAISING
        zzad6_cx_lock.

    METHODS unlock_shipment
      IMPORTING
        iv_shipment_id TYPE zzad6_ship_id.

    METHODS get_available_quantity
      IMPORTING
        iv_material_id          TYPE zzad6_d_ship_itm-material_id
        iv_location_id          TYPE zzad6_d_ship_itm-loc_id
*        io_shipment             TYPE REF TO zzad6_cl_shipment OPTIONAL
      RETURNING
        VALUE(rv_available_qty) TYPE zzad6_d_ship_itm-qty
      RAISING
        zzad6_cx_persistence
        zzad6_cx_not_found.

    METHODS generate_next_shipment_id
      RETURNING
        VALUE(rv_next_shipment_id) TYPE zzad6_ship_id
      RAISING
        zzad6_cx_persistence.

    METHODS validate_shipment
      IMPORTING
        io_shipment TYPE REF TO zzad6_cl_shipment
      RAISING
        zzad6_cx_validation
        zzad6_cx_persistence
        zzad6_cx_not_found.

    METHODS validate_shipment_item
      IMPORTING
        io_shipment TYPE REF TO zzad6_cl_shipment
        io_item     TYPE REF TO zzad6_cl_shipment_item
      RAISING
        zzad6_cx_validation
        zzad6_cx_persistence
        zzad6_cx_not_found.


ENDCLASS.



CLASS ZZAD6_CL_APP_SERVICE IMPLEMENTATION.


  METHOD constructor.
    mo_inventory_repository  = io_inventory_repository.
    mo_masterdata_repository = io_masterdata_repository.
    mo_shipment_repository   = io_shipment_repository.

  ENDMETHOD.


  METHOD delete_shipment.
    lock_shipment( iv_shipment_id ).

    TRY.
        mo_shipment_repository->delete_shipment( iv_shipment_id ).

        COMMIT WORK AND WAIT.
        unlock_shipment( iv_shipment_id ).

      CATCH zzad6_cx_error INTO DATA(lx_error).
        ROLLBACK WORK.

        unlock_shipment( iv_shipment_id ).

        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid    = zzad6_cx_persistence=>shipment_not_deleted
            entity_id = CONV symsgv( iv_shipment_id ).
    ENDTRY.

  ENDMETHOD.


  METHOD enrich_location.
    rs_location = mo_masterdata_repository->find_location_by_id( iv_location_id ).

  ENDMETHOD.


  METHOD enrich_material.
    rs_material = mo_masterdata_repository->find_material_by_id( iv_material_id ).

  ENDMETHOD.


  METHOD enrich_partner.
    rs_partner = mo_masterdata_repository->find_partner_by_id( iv_partner_id ).

  ENDMETHOD.


  METHOD enrich_shipment_draft.
    validate_shipment( io_shipment ).

    rs_partner = enrich_partner( io_shipment->get_partner( ) ).

  ENDMETHOD.


  METHOD enrich_warehouse.
    rs_warehouse = mo_masterdata_repository->find_warehouse_by_id( iv_warehouse_id ).

  ENDMETHOD.


  METHOD generate_next_shipment_id.
    DATA(lt_shipments) = mo_shipment_repository->read_shipments( ).
    SORT lt_shipments BY ship_id DESCENDING.
    DATA(lv_top_id) = lt_shipments[ 1 ]-ship_id.
    rv_next_shipment_id = lv_top_id + 1.

  ENDMETHOD.


  METHOD get_available_quantity.

    DATA(lv_stock_qty) =
      mo_inventory_repository->get_stock_quantity(
      iv_material_id = iv_material_id
      iv_loc_id      = iv_location_id ).

    DATA(lv_reserved_qty) =
      mo_shipment_repository->get_reserved_quantity(
      iv_material_id = iv_material_id
      iv_loc_id      = iv_location_id
      iv_date_from   = CONV #( sy-datum + 1 ) ).

    rv_available_qty = lv_stock_qty - lv_reserved_qty.

    IF rv_available_qty < 0.
      rv_available_qty = 0.
    ENDIF.

  ENDMETHOD.


  METHOD get_inventory_overview.
    DATA(lt_stock) = mo_inventory_repository->read_stock( iv_warehouse_id ).

    DATA(lt_reservations) = mo_inventory_repository->read_reservations( iv_warehouse_id ).

    DATA ls_inventory TYPE zzad6_if_view_structures=>ty_inventory.
    DATA lt_inventory TYPE zzad6_if_view_structures=>tt_inventory.
    DATA ls_reservation LIKE LINE OF lt_reservations.

    LOOP AT lt_stock INTO DATA(ls_stock).
      ls_reservation = VALUE #( lt_reservations[
        material_id = ls_stock-material_id
        wh_id = ls_stock-wh_id
        loc_id = ls_stock-loc_id
      ] OPTIONAL ).

      INSERT VALUE #(
        material_id  = ls_stock-material_id
        mat_desc     = ls_stock-mat_desc
        wh_id        = ls_stock-wh_id
        loc_id       = ls_stock-loc_id
        stock_qty    = ls_stock-stock_qty
        reserved_qty = ls_reservation-reserved_qty
        available_qty    = ls_stock-stock_qty - ls_reservation-reserved_qty
        uom          = ls_stock-uom
      ) INTO TABLE lt_inventory.

    ENDLOOP.

    rt_inventory = lt_inventory.

  ENDMETHOD.


  METHOD get_shipment_items_overview.

    DATA(lt_materials) = mo_masterdata_repository->read_materials( ).
    DATA(lt_locations) = mo_masterdata_repository->read_locations( ).

    LOOP AT it_shipment_items INTO DATA(ls_item).

      DATA(ls_material) = VALUE #(
        lt_materials[ material_id = ls_item-material_id ] OPTIONAL ).

      DATA(ls_location) = VALUE #(
        lt_locations[ loc_id = ls_item-loc_id ] OPTIONAL ).

      APPEND VALUE zzad6_if_view_structures=>ty_shipment_item(
        line_no       = ls_item-line_no
*        material_id   = ls_item-material_id
        material_text = ls_material-title
        location_id   = ls_location-loc_id
        location_text = ls_location-code
        qty           = ls_item-qty
        uom           = ls_material-uom
      ) TO rt_shipment_items.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_shipment_item_object.

    IF iv_line_no IS INITIAL.
      DATA(lv_next_line_no) = io_shipment->get_next_line_no( ).

      ro_shipment_item = zzad6_cl_shipment_item=>create_template(
        iv_ship_id = io_shipment->get_header_flat( )-ship_id
        iv_line_no = lv_next_line_no ).

      RETURN.
    ENDIF.

    ro_shipment_item = io_shipment->get_item( iv_line_no ).

  ENDMETHOD.


  METHOD get_shipment_object.
    IF iv_shipment_id IS INITIAL.
      DATA(lv_shipment_id) = generate_next_shipment_id( ).

      ro_shipment = zzad6_cl_shipment=>create_new(
        iv_shipment_id = lv_shipment_id
        iv_ship_date   = CONV #( sy-datum + 1 ) ).

      RETURN.
    ENDIF.

    DATA(ls_header) = mo_shipment_repository->find_shipment_by_id( iv_shipment_id ).
    DATA(lt_items) = mo_shipment_repository->find_items_by_shipment_id( iv_shipment_id ).

    ro_shipment =
      zzad6_cl_shipment=>reconstitute(
      is_header = ls_header
      it_items  = lt_items ).

  ENDMETHOD.


  METHOD get_shipment_overview.
    DATA(lv_warehouse_id)  = iv_warehouse_id.
    DATA(lv_shipment_mode) = iv_shipment_mode.

    DATA:
      lv_date_from TYPE sy-datum,
      lv_date_to   TYPE sy-datum.

    CASE lv_shipment_mode.
      WHEN zzad6_if_shipment_modes=>open.
        lv_date_from = sy-datum + 1.
      WHEN zzad6_if_shipment_modes=>due.
        lv_date_to = sy-datum.
        lv_date_from = sy-datum.
      WHEN zzad6_if_shipment_modes=>all.
        CLEAR lv_date_to.
        CLEAR lv_date_from.
    ENDCASE.

    DATA(lt_shipment) =
      mo_shipment_repository->read_shipments(
      iv_warehouse_id = lv_warehouse_id
      iv_date_from    = lv_date_from
      iv_date_to      = lv_date_to
    ).

    DATA(lt_partners) =
      mo_masterdata_repository->read_partners( ).

    DATA(lt_item_count) =
      mo_shipment_repository->read_item_counts( ).

    LOOP AT lt_shipment INTO DATA(ls_shipment).
      DATA(ls_partner) = VALUE zzad6_d_partner(
        lt_partners[ bp_id = ls_shipment-bp_id ] OPTIONAL ).

      DATA(lv_partner_name) = |{ ls_partner-first_name } { ls_partner-last_name }|.

      INSERT VALUE #(
        ship_id      = ls_shipment-ship_id
        bp_id        = ls_shipment-bp_id
        partner_name = lv_partner_name
        ship_date    = ls_shipment-ship_date
        item_count   = lt_item_count[ ls_shipment-ship_id ]-item_count
      ) INTO TABLE rt_shipments.

    ENDLOOP.

  ENDMETHOD.


  METHOD insert_item_into_shipment.
    validate_shipment_item(
      io_shipment = io_shipment
      io_item     = io_item ).

    io_shipment->put_item( io_item ).

  ENDMETHOD.


  METHOD lock_shipment.
    CALL FUNCTION 'ENQUEUE_EZAD6_SHIPMENT'
      EXPORTING
        mode_zzad6_d_shipment = 'E'
        mandt                 = sy-mandt
        ship_id               = iv_shipment_id
      EXCEPTIONS
        foreign_lock          = 1
        system_failure        = 2
        OTHERS                = 3.

    CASE sy-subrc.
      WHEN 0.
        RETURN.

      WHEN 1.
        RAISE EXCEPTION TYPE zzad6_cx_lock
          EXPORTING
            textid      = zzad6_cx_lock=>shipment_locked
            shipment_id = iv_shipment_id
            locked_by   = CONV syuname( sy-msgv1 ).

      WHEN 2.
        RAISE EXCEPTION TYPE zzad6_cx_lock
          EXPORTING
            textid      = zzad6_cx_lock=>lock_system_failure
            shipment_id = iv_shipment_id.

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zzad6_cx_lock
          EXPORTING
            textid      = zzad6_cx_lock=>lock_failed
            shipment_id = iv_shipment_id.
    ENDCASE.
  ENDMETHOD.


  METHOD save_shipment_draft.
    validate_shipment( io_shipment ).

    DATA(to_items) = io_shipment->get_items( ).

    LOOP AT to_items INTO DATA(lo_item).
      validate_shipment_item(
        io_shipment = io_shipment
        io_item     = lo_item ).
    ENDLOOP.

    DATA(ls_header) = io_shipment->get_header_flat( ).
    DATA(lt_items) = io_shipment->get_items_flat( ).

    lock_shipment( ls_header-ship_id ).

    TRY.
        mo_shipment_repository->save_shipment(
          is_shipment = ls_header
          it_items    = lt_items ).

        COMMIT WORK AND WAIT.

        unlock_shipment( ls_header-ship_id ).
      CATCH zzad6_cx_error INTO DATA(lx_error).
        ROLLBACK WORK.

        unlock_shipment( ls_header-ship_id  ).

        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid    = zzad6_cx_persistence=>shipment_not_saved
            entity_id = CONV symsgv( ls_header-ship_id ).
    ENDTRY.
  ENDMETHOD.


  METHOD suggest_item_data.
    DATA(ls_item_data) = io_shipment_item->get_data( ).
    DATA(ls_material) = enrich_material( ls_item_data-material_id ).
    DATA(lt_inventory) = get_inventory_overview( iv_warehouse_id ).

    SORT lt_inventory BY available_qty DESCENDING.

    TRY.
        rs_suggestion = lt_inventory[ material_id = ls_material-material_id ].

        DATA(to_items) = io_shipment->get_items( ).

        LOOP AT to_items INTO DATA(lo_item).

          DATA(ls_item) = lo_item->get_data( ).

          IF ls_item-line_no = ls_item_data-line_no.
            CONTINUE.
          ENDIF.

          IF  ls_item-loc_id = rs_suggestion-loc_id
          AND ls_item-material_id = rs_suggestion-material_id.

            rs_suggestion-available_qty = rs_suggestion-available_qty - ls_item-qty.

          ENDIF.

        ENDLOOP.

      CATCH cx_sy_itab_line_not_found.
        RAISE EXCEPTION TYPE zzad6_cx_validation
          EXPORTING
            textid    = zzad6_cx_validation=>out_of_stock
            entity_id = CONV symsgv( ls_item_data-material_id ).
    ENDTRY.

    IF rs_suggestion-available_qty <= 0.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid    = zzad6_cx_validation=>out_of_stock
          entity_id = CONV symsgv( ls_item_data-material_id ).
    ENDIF.

    ls_item_data-loc_id      = rs_suggestion-loc_id.
    ls_item_data-material_id = rs_suggestion-material_id.
    ls_item_data-qty         = 1.

    io_shipment_item->set_data( ls_item_data ).

  ENDMETHOD.


  METHOD unlock_shipment.
    CALL FUNCTION 'DEQUEUE_EZAD6_SHIPMENT'
      EXPORTING
        mode_zzad6_d_shipment = 'E'
        mandt                 = sy-mandt
        ship_id               = iv_shipment_id.

  ENDMETHOD.


  METHOD validate_shipment.
    DATA(ls_shipment) = io_shipment->get_header_flat( ).

    IF ls_shipment-bp_id IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>partner_empty.
    ENDIF.

    mo_masterdata_repository->find_partner_by_id( ls_shipment-bp_id ).

    IF ls_shipment-ship_date <= sy-datum .
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>date_not_in_future
          date   = sy-datum.
    ENDIF.

    IF lines( io_shipment->get_items_flat( ) ) = 0.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>no_items.
    ENDIF.


  ENDMETHOD.


  METHOD validate_shipment_item.
    DATA(ls_item) = io_item->get_data( ).

    IF ls_item-material_id IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>material_empty.
    ENDIF.

    IF ls_item-qty IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>quantity_empty.
    ENDIF.

    IF ls_item-loc_id IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>location_empty.
    ENDIF.

    enrich_location( ls_item-loc_id ).
    DATA(ls_material) = enrich_material( ls_item-material_id ).

    DATA(lv_available_qty) = get_available_quantity(
      iv_material_id = ls_item-material_id
      iv_location_id = ls_item-loc_id
    ).

    DATA(to_items) = io_shipment->get_items( ).
    LOOP AT to_items INTO DATA(lo_item).
      DATA(ls_item_loop) = lo_item->get_data( ).

      IF ls_item_loop-line_no = ls_item-line_no.
        CONTINUE.
      ENDIF.

      IF  ls_item_loop-loc_id      = ls_item-loc_id
      AND ls_item_loop-material_id = ls_item-material_id.
        lv_available_qty = lv_available_qty - ls_item_loop-qty.
      ENDIF.

    ENDLOOP.

    IF lv_available_qty < 0.
      lv_available_qty = 0.
    ENDIF.

    IF lv_available_qty < ls_item-qty.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid        = zzad6_cx_validation=>quantity_insufficient
          requested_qty = ls_item-qty
          uom           = ls_material-uom
          available_qty = lv_available_qty.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
