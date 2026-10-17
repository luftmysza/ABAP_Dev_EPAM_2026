*&---------------------------------------------------------------------*
*& Include          ZZAD6_WH_COCKPIT_OOP_TOP
*&---------------------------------------------------------------------*

TABLES sscrfields.

*TYPES ty_shipment_mode TYPE c LENGTH 1.
TYPES gty_navigation TYPE zzad6_if_navigation_codes=>ty_navigation.
TYPES gty_selection TYPE zzad6_cl_app_controller=>ty_selection.

DATA:
  gv_0110_ucomm TYPE syucomm,
  gv_0210_ucomm TYPE syucomm,
  gv_0220_ucomm TYPE syucomm,
  gv_0230_ucomm TYPE syucomm.

DATA go_app TYPE REF TO zzad6_cl_app_controller.

DATA lx_error TYPE REF TO zzad6_cx_error.
DATA lv_navigation TYPE gty_navigation.
DATA ls_selection TYPE gty_selection.
DATA lv_ucomm TYPE syucomm.

DATA gs_0110_data TYPE zzad6_if_screen_data=>inventory_list.
DATA gs_0210_data TYPE zzad6_if_screen_data=>shipments_list.
DATA gs_0220_data TYPE zzad6_if_screen_data=>shipment_details.
DATA gs_0230_data TYPE zzad6_if_screen_data=>shipment_item_details.
