INTERFACE zzad6_if_view_structures
  PUBLIC .

  TYPES:
    BEGIN OF ty_inventory,
      material_id   TYPE zzad6_d_inventor-material_id,
      mat_desc      TYPE zzad6_d_mat_t-description,
      wh_id         TYPE zzad6_d_location-wh_id,
      loc_id        TYPE zzad6_d_inventor-loc_id,
      stock_qty     TYPE zzad6_d_inventor-stock_qty,
      reserved_qty  TYPE zzad6_d_ship_itm-qty,
      available_qty TYPE zzad6_d_inventor-stock_qty,
      uom           TYPE zzad6_d_material-uom,
    END OF ty_inventory .
  TYPES:
    tt_inventory TYPE STANDARD TABLE OF ty_inventory WITH KEY material_id loc_id .
  TYPES:
    BEGIN OF ty_shipment,
      ship_id      TYPE zzad6_d_shipment-ship_id,
      bp_id        TYPE zzad6_d_partner-bp_id,
      partner_name TYPE char10,
      ship_date    TYPE zzad6_d_shipment-ship_date,
      item_count   TYPE i,
    END OF ty_shipment .
  TYPES:
    tt_shipments TYPE STANDARD TABLE OF ty_shipment WITH KEY ship_id .
  TYPES:
    BEGIN OF ty_shipment_item,
      line_no       TYPE zzad6_d_ship_itm-line_no,
      material_text TYPE zzad6_d_mat_t-title,
      location_id   TYPE zzad6_d_location-loc_id,
      location_text TYPE zzad6_d_location-code,
      qty           TYPE zzad6_d_ship_itm-qty,
      uom           TYPE zzad6_d_material-uom,
    END OF ty_shipment_item .
  TYPES:
    tt_shipment_items TYPE STANDARD TABLE OF ty_shipment_item WITH KEY line_no .
ENDINTERFACE.
