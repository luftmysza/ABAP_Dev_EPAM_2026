CLASS zzad6_cl_app_controller DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zzad6_if_shipment_modes.

    TYPES:
      BEGIN OF ty_selection,
        warehouse_id  TYPE zzad6_wh_id,
        shipment_mode TYPE zzad6_if_shipment_modes=>code,
        view_mode     TYPE sscrfields-ucomm,
      END OF ty_selection.

    METHODS dispatch
      IMPORTING
        !iv_ucomm                TYPE sscrfields-ucomm
        is_inventory_list_data   TYPE zzad6_if_screen_data=>inventory_list OPTIONAL
        is_shipments_list        TYPE zzad6_if_screen_data=>shipments_list OPTIONAL
        is_shipment_details      TYPE zzad6_if_screen_data=>shipment_details OPTIONAL
        is_shipment_item_details TYPE zzad6_if_screen_data=>shipment_item_details OPTIONAL
      RETURNING
        VALUE(rv_navigation)     TYPE zzad6_if_navigation_codes=>ty_navigation
      RAISING
        zzad6_cx_validation
        zzad6_cx_not_found
        zzad6_cx_persistence
        zzad6_cx_ui
        zzad6_cx_lock.

    METHODS constructor
      IMPORTING
        !io_app_service          TYPE REF TO zzad6_cl_app_service
        !io_inventory_list_view  TYPE REF TO zzad6_cl_inventory_list_view
        !io_shipment_list_view   TYPE REF TO zzad6_cl_shipment_list_view
        !io_shipment_editor_view TYPE REF TO zzad6_cl_shipment_editor_view
        !io_shipment_item_editor TYPE REF TO zzad6_cl_shipment_item_editor.

    METHODS show_inventory
      EXPORTING
        es_data TYPE zzad6_if_screen_data=>inventory_list
      RAISING
        zzad6_cx_validation
        zzad6_cx_not_found
        zzad6_cx_persistence
        zzad6_cx_ui.

    METHODS show_shipments
      EXPORTING
        es_data TYPE zzad6_if_screen_data=>shipments_list
      RAISING
        zzad6_cx_validation
        zzad6_cx_not_found
        zzad6_cx_persistence
        zzad6_cx_ui.

    METHODS show_shipment_details
      EXPORTING
        es_data TYPE zzad6_if_screen_data=>shipment_details
      RAISING
        zzad6_cx_validation
        zzad6_cx_not_found
        zzad6_cx_persistence
        zzad6_cx_ui.

    METHODS show_item_editor
      EXPORTING
        es_data TYPE zzad6_if_screen_data=>shipment_item_details
      RAISING
        zzad6_cx_validation
        zzad6_cx_not_found
        zzad6_cx_persistence.

    METHODS set_selection
      IMPORTING
        !is_selection TYPE ty_selection.

    METHODS get_selection
      RETURNING
        VALUE(rs_selection) TYPE ty_selection.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mo_app_service TYPE REF TO zzad6_cl_app_service.
    DATA mo_inventory_list_view TYPE REF TO zzad6_cl_inventory_list_view .
    DATA mo_shipment_list_view TYPE REF TO zzad6_cl_shipment_list_view .
    DATA mo_shipment_editor_view TYPE REF TO zzad6_cl_shipment_editor_view .
    DATA mo_shipment_item_editor TYPE REF TO zzad6_cl_shipment_item_editor.

    DATA ms_selection TYPE ty_selection.
    DATA ms_suggestion TYPE zzad6_if_view_structures=>ty_inventory.

    DATA mv_selected_shipment_id TYPE zzad6_ship_id.
    DATA mv_selected_shipment_item_id TYPE zzad6_d_ship_itm-line_no.
    DATA mo_current_shipment TYPE REF TO zzad6_cl_shipment.
    DATA mo_current_shipment_item TYPE REF TO zzad6_cl_shipment_item.

    METHODS check_edit_allowed
      RAISING
        zzad6_cx_ui.

    METHODS check_shipment_is_bound
      RAISING
        zzad6_cx_validation.

    METHODS check_shipment_item_is_bound
      RAISING
        zzad6_cx_validation.

    METHODS get_selected_shipment
      RETURNING
        VALUE(rv_shipment_id) TYPE zzad6_ship_id
      RAISING
        zzad6_cx_validation
        zzad6_cx_ui.

    METHODS get_selected_shipment_item
      RETURNING
        VALUE(rv_line_no) TYPE zzad6_d_ship_itm-line_no
      RAISING
        zzad6_cx_validation
        zzad6_cx_ui.


ENDCLASS.



CLASS ZZAD6_CL_APP_CONTROLLER IMPLEMENTATION.


  METHOD constructor.
    mo_app_service           = io_app_service.
    mo_inventory_list_view   = io_inventory_list_view.
    mo_shipment_list_view    = io_shipment_list_view.
    mo_shipment_editor_view  = io_shipment_editor_view.
    mo_shipment_item_editor  = io_shipment_item_editor.

  ENDMETHOD.


  METHOD dispatch.
    DATA lv_shipment_id TYPE zzad6_ship_id.
    DATA lv_line_no TYPE zzad6_d_ship_itm-line_no.

    rv_navigation = zzad6_if_navigation_codes=>none.

    ms_selection-view_mode = iv_ucomm.

    CASE ms_selection-view_mode .
      WHEN 'INV'.
        rv_navigation = zzad6_if_navigation_codes=>inventory.

      WHEN 'SHIP'.
        rv_navigation = zzad6_if_navigation_codes=>shipments.

      WHEN 'ADDSHIP'.
        mo_current_shipment = mo_app_service->get_shipment_object( ).

        rv_navigation = zzad6_if_navigation_codes=>editor.

      WHEN 'DELSHIP'.
        lv_shipment_id = get_selected_shipment( ).
        mo_current_shipment = mo_app_service->get_shipment_object( lv_shipment_id ).

        check_edit_allowed( ).

        mo_app_service->delete_shipment( lv_shipment_id ).

      WHEN 'EDITSHIP'.
        lv_shipment_id = get_selected_shipment( ).
        mo_current_shipment = mo_app_service->get_shipment_object( lv_shipment_id ).

        check_edit_allowed( ).

        rv_navigation = zzad6_if_navigation_codes=>editor.

      WHEN 'PULLSHIP'.
        check_shipment_is_bound( ).

        mo_current_shipment->set_partner( is_shipment_details-bp_id ).
        mo_current_shipment->set_ship_date( is_shipment_details-ship_date ).

        mo_app_service->enrich_shipment_draft( mo_current_shipment ).

      WHEN 'SAVESHIP'.
        check_shipment_is_bound( ).

        mo_current_shipment->set_partner( is_shipment_details-bp_id ).
        mo_current_shipment->set_ship_date( is_shipment_details-ship_date  ).

        mo_app_service->save_shipment_draft( mo_current_shipment ).

        FREE mo_current_shipment.

        rv_navigation = zzad6_if_navigation_codes=>back.

      WHEN 'ADDITEM'.
        mo_current_shipment_item = mo_app_service->get_shipment_item_object(
          io_shipment = mo_current_shipment ).

        rv_navigation = zzad6_if_navigation_codes=>item_editor.

      WHEN 'TAKEITEM'.
        check_shipment_item_is_bound( ).

        mo_current_shipment_item->set_data(
          VALUE #(
            loc_id      = is_shipment_item_details-location_id
            material_id = is_shipment_item_details-material_id
            qty         = is_shipment_item_details-qty ) ).

        mo_app_service->insert_item_into_shipment(
          io_shipment = mo_current_shipment
          io_item     = mo_current_shipment_item ).

        FREE mo_current_shipment_item.

        rv_navigation = zzad6_if_navigation_codes=>back.

      WHEN 'PULLITEM'.
        check_shipment_item_is_bound( ).

        mo_current_shipment_item->set_data(
          VALUE #(
            loc_id      = is_shipment_item_details-location_id
            material_id = is_shipment_item_details-material_id
            qty         = is_shipment_item_details-qty ) ).

        ms_suggestion = mo_app_service->suggest_item_data(
          iv_warehouse_id  = ms_selection-warehouse_id
          io_shipment_item = mo_current_shipment_item
          io_shipment      = mo_current_shipment ).

      WHEN 'DELITEM'.
        lv_line_no = get_selected_shipment_item( ).

        mo_current_shipment->remove_item( lv_line_no ).

      WHEN 'CANCELITEM'.
        FREE mo_current_shipment_item.

        rv_navigation = zzad6_if_navigation_codes=>back.

      WHEN 'CANCEL'
        OR 'BACK'
        OR 'EXITSHIP'.

        FREE:
          mo_current_shipment,
          mo_current_shipment_item.

        rv_navigation = zzad6_if_navigation_codes=>back.

      WHEN 'EXIT'.
        FREE:
          mo_current_shipment,
          mo_current_shipment_item.

        rv_navigation = zzad6_if_navigation_codes=>exit.

    ENDCASE.

  ENDMETHOD.


  METHOD get_selection.
    rs_selection = ms_selection.
  ENDMETHOD.


  METHOD set_selection.
    ms_selection = is_selection.
  ENDMETHOD.


  METHOD show_inventory.
    DATA(ls_warehouse) = mo_app_service->enrich_warehouse( ms_selection-warehouse_id ).

    es_data-warehouse_id = ls_warehouse-wh_id.
    es_data-warehouse_text = ls_warehouse-name.

    DATA(lt_inventory) =
      mo_app_service->get_inventory_overview( ms_selection-warehouse_id ).

    mo_inventory_list_view->set_container_items( lt_inventory ).
    mo_inventory_list_view->display( ).

  ENDMETHOD.


  METHOD show_shipments.
    DATA(ls_warehouse) = mo_app_service->enrich_warehouse( ms_selection-warehouse_id ).

    es_data-warehouse_id = ls_warehouse-wh_id.
    es_data-warehouse_text = ls_warehouse-name.
    es_data-shipment_mode_text = zzad6_if_shipment_modes~determine_shipment_mode_text( ms_selection-shipment_mode ).

    DATA(lt_shipments) =
      mo_app_service->get_shipment_overview(
      iv_warehouse_id  = ms_selection-warehouse_id
      iv_shipment_mode = ms_selection-shipment_mode ).

    mo_shipment_list_view->set_container_items( lt_shipments ).
    mo_shipment_list_view->display( ).

  ENDMETHOD.


  METHOD show_item_editor.
    DATA(ls_shipment_item) = mo_current_shipment_item->get_data( ).

    es_data-ship_id     = ls_shipment_item-ship_id.
    es_data-line_no     = ls_shipment_item-line_no.
    es_data-material_id = ls_shipment_item-material_id.
    es_data-location_id = ls_shipment_item-loc_id.
    es_data-qty         = ls_shipment_item-qty.

    IF ms_suggestion IS NOT INITIAL.
      es_data-material_id   = ms_suggestion-material_id.
      es_data-material_text = mo_app_service->enrich_material( es_data-material_id )-title.
      es_data-location_id   = ms_suggestion-loc_id.
      es_data-location_text = mo_app_service->enrich_location( es_data-location_id )-code.
      es_data-available_qty = ms_suggestion-available_qty.
      es_data-uom           = ms_suggestion-uom.
    ENDIF.

    CLEAR ms_suggestion.

  ENDMETHOD.


  METHOD show_shipment_details.
    IF mo_current_shipment IS NOT BOUND.
      RAISE EXCEPTION TYPE zzad6_cx_validation.
    ENDIF.

    DATA(ls_header) = mo_current_shipment->get_header_flat( ).

    es_data-ship_id   = ls_header-ship_id.
    es_data-bp_id     = ls_header-bp_id.
    es_data-ship_date = ls_header-ship_date.

    IF ls_header-bp_id IS NOT INITIAL.
      DATA(ls_partner) = mo_app_service->enrich_partner( ls_header-bp_id ).

      es_data-bp_text = |{ ls_partner-first_name } { ls_partner-last_name }|.
    ENDIF.

    DATA(lt_items) =
      mo_app_service->get_shipment_items_overview(  mo_current_shipment->get_items_flat( ) ).

    mo_shipment_editor_view->set_container_items( lt_items ).
    mo_shipment_editor_view->display( ).

  ENDMETHOD.


  METHOD check_edit_allowed.
    IF mo_current_shipment->get_ship_date( ) <= sy-datum.
      CLEAR mo_current_shipment.

      RAISE EXCEPTION TYPE zzad6_cx_ui
        EXPORTING
          textid = zzad6_cx_ui=>shipment_read_only.
    ENDIF.
  ENDMETHOD.


  METHOD check_shipment_is_bound.

    IF mo_current_shipment IS NOT BOUND.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>no_shipment.
    ENDIF.

  ENDMETHOD.


  METHOD check_shipment_item_is_bound.

    IF mo_current_shipment_item IS NOT BOUND.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_ui=>no_shipment_item_selected.
    ENDIF.

  ENDMETHOD.


  METHOD get_selected_shipment.
    rv_shipment_id = mo_shipment_list_view->get_selected_shipment_id( ).

    IF rv_shipment_id IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_ui
        EXPORTING
          textid = zzad6_cx_ui=>no_shipment_selected.
    ENDIF.

  ENDMETHOD.


  METHOD get_selected_shipment_item.
    rv_line_no = mo_shipment_editor_view->get_selected_line_no( ).

    IF rv_line_no IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_validation
        EXPORTING
          textid = zzad6_cx_validation=>no_shipment_item.
    ENDIF.

  ENDMETHOD.


  METHOD zzad6_if_shipment_modes~determine_shipment_mode_text.

    CASE iv_shipment_mode.
      WHEN zzad6_if_shipment_modes=>open.
        rv_shipment_mode_text = 'Open shipments'.

      WHEN zzad6_if_shipment_modes=>due.
        rv_shipment_mode_text = 'Shipments due today'.

      WHEN zzad6_if_shipment_modes=>all.
        rv_shipment_mode_text = 'All shipments'.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
