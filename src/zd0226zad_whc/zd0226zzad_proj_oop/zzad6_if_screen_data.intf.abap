INTERFACE zzad6_if_screen_data
  PUBLIC .
  TYPES:
    BEGIN OF inventory_list,
      warehouse_id   TYPE zzad6_wh_id,
      warehouse_text TYPE c LENGTH 30,
    END OF inventory_list,

    BEGIN OF shipments_list,
      warehouse_id       TYPE zzad6_wh_id,
      warehouse_text     TYPE c LENGTH 30,
      shipment_mode_text TYPE c LENGTH 30,
    END OF shipments_list,

    BEGIN OF shipment_details,
      ship_id   TYPE zzad6_ship_id,
      bp_id     TYPE zzad6_bp_id,
      bp_text   TYPE c LENGTH 30,
      ship_date TYPE sy-datum,
    END OF shipment_details,

    BEGIN OF shipment_item_details,
      ship_id       TYPE zzad6_d_ship_itm-ship_id,
      line_no       TYPE zzad6_d_ship_itm-line_no,
      material_id   TYPE zzad6_d_ship_itm-material_id,
      material_text TYPE zzad6_d_mat_t-title,
      location_id   TYPE zzad6_d_ship_itm-loc_id,
      location_text TYPE zzad6_d_location-code,
      qty           TYPE zzad6_d_ship_itm-qty,
      available_qty TYPE zzad6_d_ship_itm-qty,
      uom           TYPE zzad6_d_material-uom,
    END OF shipment_item_details.

ENDINTERFACE.
