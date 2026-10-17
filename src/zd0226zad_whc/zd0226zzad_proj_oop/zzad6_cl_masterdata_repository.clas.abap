CLASS zzad6_cl_masterdata_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zzad6_if_masterdata_repository .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZZAD6_CL_MASTERDATA_REPOSITORY IMPLEMENTATION.


  METHOD zzad6_if_masterdata_repository~find_location_by_id.

    TRY.
        SELECT SINGLE *
        FROM zzad6_d_location AS loc
        WHERE loc~loc_id = @iv_location_id
        INTO @rs_location.

        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zzad6_cx_not_found
            EXPORTING
              textid    = zzad6_cx_not_found=>location
              entity_id = CONV symsgv( iv_location_id ).
        ENDIF.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_masterdata_repository~find_material_by_id.
    TRY.
        SELECT SINGLE
          mat~material_id,
          mat~uom,
          txt~title,
          txt~description
        FROM zzad6_d_material AS mat
        INNER JOIN zzad6_d_mat_t AS txt
          ON mat~material_id = txt~material_id
        WHERE mat~material_id = @iv_material_id
          AND txt~langu = @sy-langu
        INTO @rs_material.

        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zzad6_cx_not_found
            EXPORTING
              textid    = zzad6_cx_not_found=>material
              entity_id = CONV symsgv( iv_material_id ).
        ENDIF.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.
  ENDMETHOD.


  METHOD zzad6_if_masterdata_repository~find_partner_by_id.

    TRY.
        SELECT SINGLE *
        FROM zzad6_d_partner AS bp
        WHERE bp~bp_id = @iv_bp_id
        INTO @rs_partner.

        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zzad6_cx_not_found
            EXPORTING
              textid    = zzad6_cx_not_found=>partner
              entity_id = CONV symsgv( iv_bp_id ).
        ENDIF.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_masterdata_repository~find_warehouse_by_id.
    TRY.
        SELECT SINGLE *
        FROM zzad6_d_wareh AS w
        WHERE w~wh_id = @iv_warehouse_id
        INTO @rs_warehouse.

        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zzad6_cx_not_found
            EXPORTING
              textid    = zzad6_cx_not_found=>warehouse
              entity_id = CONV symsgv( iv_warehouse_id ).
        ENDIF.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_masterdata_repository~read_locations.
    TRY.
        SELECT *
        FROM zzad6_d_location
        INTO TABLE @rt_locations.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_masterdata_repository~read_materials.
    TRY.
        SELECT
          mat~material_id,
          mat~uom,
          txt~title,
          txt~description
        FROM zzad6_d_material AS mat
        INNER JOIN zzad6_d_mat_t AS txt
          ON mat~material_id = txt~material_id
        WHERE txt~langu = @sy-langu
        INTO TABLE @rt_materials.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.
  ENDMETHOD.


  METHOD zzad6_if_masterdata_repository~read_partners.
    TRY.
        SELECT *
        FROM zzad6_d_partner
        INTO TABLE @rt_partners.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
