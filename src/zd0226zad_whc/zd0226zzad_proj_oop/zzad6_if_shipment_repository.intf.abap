INTERFACE zzad6_if_shipment_repository
  PUBLIC .

  TYPES:
    BEGIN OF ty_item_count,
      ship_id    TYPE zzad6_d_shipment-ship_id,
      item_count TYPE i,
    END OF ty_item_count.
  TYPES tt_item_count TYPE STANDARD TABLE OF ty_item_count WITH KEY ship_id.

  TYPES tt_d_shipment TYPE STANDARD TABLE OF zzad6_d_shipment WITH DEFAULT KEY.
  TYPES tt_d_shipment_item TYPE STANDARD TABLE OF zzad6_d_ship_itm WITH DEFAULT KEY.

  METHODS read_shipments
    IMPORTING
      iv_warehouse_id    TYPE zzad6_wh_id OPTIONAL
      iv_date_from       TYPE sy-datum OPTIONAL
      iv_date_to         TYPE sy-datum OPTIONAL
    RETURNING
      VALUE(rt_shipment) TYPE tt_d_shipment
    RAISING
      zzad6_cx_persistence.
  METHODS read_item_counts
    RETURNING
      VALUE(rt_item_count) TYPE tt_item_count
    RAISING
      zzad6_cx_persistence.

  METHODS find_shipment_by_id
    IMPORTING
      iv_shipment_id     TYPE zzad6_ship_id
    RETURNING
      VALUE(rs_shipment) TYPE zzad6_d_shipment
    RAISING
      zzad6_cx_not_found
      zzad6_cx_persistence.

  METHODS find_items_by_shipment_id
    IMPORTING
      iv_shipment_id          TYPE zzad6_ship_id
    RETURNING
      VALUE(rt_shipment_item) TYPE tt_d_shipment_item
    RAISING
      zzad6_cx_not_found
      zzad6_cx_persistence.

  METHODS delete_shipment
    IMPORTING
      iv_shipment_id TYPE zzad6_ship_id
    RAISING
      zzad6_cx_persistence.

  METHODS get_reserved_quantity
    IMPORTING
      iv_material_id         TYPE zzad6_d_ship_itm-material_id
      iv_loc_id              TYPE zzad6_d_ship_itm-loc_id
      iv_date_from           TYPE zzad6_d_shipment-ship_date
      iv_excl_ship_id        TYPE zzad6_d_shipment-ship_id OPTIONAL
    RETURNING
      VALUE(rv_reserved_qty) TYPE zzad6_d_ship_itm-qty
    RAISING
      zzad6_cx_persistence.

  METHODS save_shipment
    IMPORTING
      is_shipment TYPE  zzad6_d_shipment
      it_items    TYPE tt_d_shipment_item
    RAISING
      zzad6_cx_persistence.

ENDINTERFACE.
