INTERFACE zzad6_if_inventory_repository
  PUBLIC .

  TYPES:
    BEGIN OF ty_stock_row,
      material_id TYPE zzad6_d_inventor-material_id,
      mat_desc    TYPE zzad6_d_mat_t-description,
      wh_id       TYPE zzad6_d_location-wh_id,
      loc_id      TYPE zzad6_d_inventor-loc_id,
      stock_qty   TYPE zzad6_d_inventor-stock_qty,
      uom         TYPE zzad6_d_material-uom,
    END OF ty_stock_row .
  TYPES:
    tt_stock TYPE STANDARD TABLE OF ty_stock_row WITH KEY material_id loc_id .
  TYPES:
    BEGIN OF ty_reservation_row,
      material_id  TYPE zzad6_d_ship_itm-material_id,
      wh_id        TYPE zzad6_d_location-wh_id,
      loc_id       TYPE zzad6_d_ship_itm-loc_id,
      reserved_qty TYPE zzad6_d_ship_itm-qty,
    END OF ty_reservation_row .
  TYPES:
    tt_reservation TYPE STANDARD TABLE OF ty_reservation_row WITH KEY material_id wh_id loc_id .

  METHODS read_stock
    IMPORTING
      !iv_warehouse_id TYPE zzad6_wh_id
    RETURNING
      VALUE(rt_stock)  TYPE tt_stock
    RAISING
      zzad6_cx_persistence.

  METHODS read_reservations
    IMPORTING
      !iv_warehouse_id      TYPE zzad6_wh_id
    RETURNING
      VALUE(rt_reservation) TYPE tt_reservation
    RAISING
      zzad6_cx_persistence.

  METHODS get_stock_quantity
    IMPORTING
      iv_material_id      TYPE zzad6_d_inventor-material_id
      iv_loc_id           TYPE zzad6_d_inventor-loc_id
    RETURNING
      VALUE(rv_stock_qty) TYPE zzad6_d_inventor-stock_qty
    RAISING
      zzad6_cx_persistence.


ENDINTERFACE.
