INTERFACE zzad6_if_masterdata_repository
  PUBLIC .

  TYPES tt_partners TYPE STANDARD TABLE OF zzad6_d_partner WITH DEFAULT KEY.

  TYPES tt_locations TYPE STANDARD TABLE OF zzad6_d_location WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ty_material,
      material_id TYPE zzad6_d_material-material_id,
      uom         TYPE zzad6_d_material-uom,
      title       TYPE zzad6_d_mat_t-title,
      description TYPE zzad6_d_mat_t-description,
    END OF ty_material,

    tt_materials TYPE STANDARD TABLE OF ty_material
      WITH EMPTY KEY.

  METHODS find_warehouse_by_id
    IMPORTING
      !iv_warehouse_id    TYPE zzad6_wh_id
    RETURNING
      VALUE(rs_warehouse) TYPE zzad6_d_wareh
    RAISING
      zzad6_cx_persistence
      zzad6_cx_not_found .

  METHODS find_partner_by_id
    IMPORTING
      !iv_bp_id         TYPE zzad6_bp_id
    RETURNING
      VALUE(rs_partner) TYPE zzad6_d_partner
    RAISING
      zzad6_cx_persistence
      zzad6_cx_not_found .

  METHODS find_location_by_id
    IMPORTING
      iv_location_id     TYPE zzad6_loc_id
    RETURNING
      VALUE(rs_location) TYPE zzad6_d_location
    RAISING
      zzad6_cx_persistence
      zzad6_cx_not_found .

  METHODS find_material_by_id
    IMPORTING
      iv_material_id     TYPE zzad6_mat_id
    RETURNING
      VALUE(rs_material) TYPE ty_material
    RAISING
      zzad6_cx_persistence
      zzad6_cx_not_found .

   METHODS read_materials
    RETURNING
      VALUE(rt_materials) TYPE tt_materials
    RAISING
      zzad6_cx_persistence.

  METHODS read_partners
    RETURNING
      VALUE(rt_partners) TYPE tt_partners
    RAISING
      zzad6_cx_persistence.

  METHODS read_locations
    RETURNING
      VALUE(rt_locations) TYPE tt_locations
    RAISING
      zzad6_cx_persistence.

ENDINTERFACE.
