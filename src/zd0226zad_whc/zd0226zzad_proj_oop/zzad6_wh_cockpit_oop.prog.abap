*&---------------------------------------------------------------------*
*& Report ZZAD6_WH_COCKPIT_OOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad6_wh_cockpit_oop.


INCLUDE zzad6_wh_cockpit_oop_top.
INCLUDE zzad6_wh_cockpit_oop_sel.
INCLUDE zzad6_wh_cockpit_oop_o01.
INCLUDE zzad6_wh_cockpit_oop_i01.

INITIALIZATION.
  DATA:
    lo_masterdata_repository TYPE REF TO zzad6_if_masterdata_repository,
    lo_inventory_repository  TYPE REF TO zzad6_if_inventory_repository,
    lo_shipment_repository   TYPE REF TO zzad6_if_shipment_repository.

  lo_masterdata_repository = NEW zzad6_cl_masterdata_repository( ).
  lo_inventory_repository = NEW zzad6_cl_inventory_repository( ).
  lo_shipment_repository = NEW zzad6_cl_shipment_repository( ).

  DATA(lo_app_service) = NEW zzad6_cl_app_service(
    io_inventory_repository  = lo_inventory_repository
    io_masterdata_repository = lo_masterdata_repository
    io_shipment_repository   = lo_shipment_repository ).

  go_app = NEW zzad6_cl_app_controller(
    io_app_service          = lo_app_service
    io_inventory_list_view  = NEW zzad6_cl_inventory_list_view( 'CC_INV' )
    io_shipment_list_view   = NEW zzad6_cl_shipment_list_view( 'CC_SHIP' )
    io_shipment_editor_view = NEW zzad6_cl_shipment_editor_view( 'CC_ITEMS' )
    io_shipment_item_editor = NEW zzad6_cl_shipment_item_editor( ) ).

AT SELECTION-SCREEN.
  TRY.
      ls_selection = VALUE zzad6_cl_app_controller=>ty_selection(
        warehouse_id = p_whid

        view_mode = sscrfields-ucomm

        shipment_mode = COND #(
          WHEN p_open = abap_true THEN zzad6_if_shipment_modes=>open
          WHEN p_due = abap_true  THEN zzad6_if_shipment_modes=>due
          ELSE                         zzad6_if_shipment_modes=>all )
      ).

      go_app->set_selection( ls_selection ).

      lv_navigation = go_app->dispatch( ls_selection-view_mode ).

      PERFORM navigate USING lv_navigation.
    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'E'.
      CLEAR lx_error.
  ENDTRY.


FORM navigate USING iv_navigation TYPE zzad6_if_navigation_codes=>ty_navigation.
  CASE iv_navigation.
    WHEN zzad6_if_navigation_codes=>inventory.
      CALL SCREEN 0110.

    WHEN zzad6_if_navigation_codes=>shipments.
      CALL SCREEN 0210.

    WHEN zzad6_if_navigation_codes=>editor.
      CALL SCREEN 0220.

    WHEN zzad6_if_navigation_codes=>item_editor.
      CALL SCREEN 0230
        STARTING AT 10 5
        ENDING AT 70 18.

    WHEN zzad6_if_navigation_codes=>back.
      LEAVE TO SCREEN 0.

    WHEN zzad6_if_navigation_codes=>exit.
      LEAVE PROGRAM.

  ENDCASE.

ENDFORM.
