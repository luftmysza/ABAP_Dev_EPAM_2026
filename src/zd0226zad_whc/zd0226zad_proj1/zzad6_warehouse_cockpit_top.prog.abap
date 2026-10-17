*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_TOP
*&---------------------------------------------------------------------*

TABLES:
  zzad6_d_location,
  zzad6_d_partner.
DATA lv_ucomm TYPE sy-ucomm.
DATA gv_app_mode TYPE char10. " INV / SHIP

FIELD-SYMBOLS: <ls_fcat> TYPE lvc_s_fcat.

*&---------------------------------------------------------------------*
*&  Screen 0110
*&---------------------------------------------------------------------*
DATA gv_0110_ucomm TYPE sy-ucomm.

DATA lt_fcat_ship TYPE lvc_t_fcat.

DATA:
  gv_0110_wh_id    TYPE zzad6_d_wareh-wh_id,
  gv_0110_wh_txt   TYPE zzad6_d_wareh-name,
  gv_0110_mode_txt TYPE c LENGTH '50'.

TYPES:
  BEGIN OF ty_ship,
    ship_id      TYPE zzad6_d_shipment-ship_id,
    bp_id        TYPE zzad6_d_partner-bp_id,
    partner_name TYPE char100,
    ship_date    TYPE zzad6_d_shipment-ship_date,
    item_count   TYPE i,
  END OF ty_ship.

DATA:
  gt_ship TYPE STANDARD TABLE OF ty_ship,
  gs_ship TYPE ty_ship.

DATA:
  go_alv_inv  TYPE REF TO cl_gui_alv_grid,
  go_alv_ship TYPE REF TO cl_gui_alv_grid.

DATA go_cont_ship TYPE REF TO cl_gui_custom_container.


*&---------------------------------------------------------------------*
*&  Screen 0100
*&---------------------------------------------------------------------*

DATA gv_0100_ucomm TYPE sy-ucomm.

DATA lt_fcat_inv  TYPE lvc_t_fcat.

DATA:
  gv_0100_wh_id  TYPE zzad6_d_wareh-wh_id,
  gv_0100_wh_txt TYPE zzad6_d_wareh-name.

TYPES:
  BEGIN OF ty_inv,
    material_id  TYPE zzad6_d_material-material_id,
    mat_desc     TYPE zzad6_d_mat_t-description,
    wh_id        TYPE zzad6_d_wareh-wh_id,
    loc_id       TYPE zzad6_d_location-loc_id,
    stock_qty    TYPE zzad6_d_inventor-stock_qty,
    reserved_qty TYPE zzad6_d_inventor-stock_qty,
    avail_qty    TYPE zzad6_d_inventor-stock_qty,
    uom          TYPE zzad6_d_material-uom,
  END OF ty_inv.

DATA:
  gt_inv TYPE STANDARD TABLE OF ty_inv,
  gs_inv TYPE ty_inv.

DATA go_cont_inv  TYPE REF TO cl_gui_custom_container.


*&---------------------------------------------------------------------*
*&  Screen 0200
*&---------------------------------------------------------------------*

DATA gv_0200_ucomm TYPE sy-ucomm.

DATA lt_fcat_itm TYPE lvc_t_fcat.

DATA:
  gv_0200_mode      TYPE char10,
  gv_0200_ship_id   TYPE zzad6_d_shipment-ship_id,
  gv_0200_bp_txt    TYPE char100,
  gv_0200_ship_date TYPE zzad6_d_shipment-ship_date.

DATA:
  gv_ship_id   TYPE zzad6_d_shipment-ship_id,
  gv_bp_id     TYPE zzad6_d_partner-bp_id,
  gv_ship_date TYPE zzad6_d_shipment-ship_date.

DATA:
  go_cont_items TYPE REF TO cl_gui_custom_container,
  go_alv_items  TYPE REF TO cl_gui_alv_grid.

TYPES:
  BEGIN OF ty_ship_item_ui,
    item_no     TYPE zzad6_d_ship_itm-line_no,
    material_id TYPE zzad6_d_ship_itm-material_id,
    mat_desc    TYPE zzad6_d_mat_t-description,
    source_loc  TYPE zzad6_d_ship_itm-loc_id,
    qty         TYPE zzad6_d_ship_itm-qty,
    uom         TYPE zzad6_d_material-uom,
  END OF ty_ship_item_ui.

DATA:
  gt_ship_items TYPE STANDARD TABLE OF ty_ship_item_ui,
  gs_ship_item  TYPE ty_ship_item_ui.

*&---------------------------------------------------------------------*
*&  Screen 0300
*&---------------------------------------------------------------------*

DATA gv_0300_ucomm TYPE sy-ucomm.
DATA:
  gv_0300_mat_id    TYPE zzad6_d_material-material_id,
  gv_0300_mat_txt   TYPE zzad6_d_mat_t-description,
  gv_0300_loc_id    TYPE zzad6_d_location-loc_id,
  gv_0300_qty       TYPE zzad6_d_ship_itm-qty,
  gv_0300_uom       TYPE zzad6_d_material-uom,
  gv_0300_avail_qty TYPE zzad6_d_inventor-stock_qty.
