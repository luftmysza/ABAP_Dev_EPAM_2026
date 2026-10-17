CLASS zzad6_cl_inventory_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zzad6_if_inventory_repository .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZZAD6_CL_INVENTORY_REPOSITORY IMPLEMENTATION.


  METHOD zzad6_if_inventory_repository~get_stock_quantity.

    SELECT SINGLE stock_qty
      FROM zzad6_d_inventor
      WHERE material_id = @iv_material_id
        AND loc_id      = @iv_loc_id
      INTO @rv_stock_qty.

    IF sy-subrc <> 0.
      rv_stock_qty = 0.
    ENDIF.

  ENDMETHOD.


  METHOD zzad6_if_inventory_repository~read_reservations.

    TRY.
        SELECT
          item~material_id,
          loc~wh_id,
          item~loc_id,
          SUM( item~qty ) AS reserved_qty
        FROM zzad6_d_ship_itm AS item
        INNER JOIN zzad6_d_shipment AS ship
          ON ship~ship_id = item~ship_id
        INNER JOIN zzad6_d_location AS loc
          ON item~loc_id = loc~loc_id
        WHERE loc~wh_id     = @iv_warehouse_id
          AND ship~ship_date > @sy-datum
        GROUP BY
          item~material_id,
          loc~wh_id,
          item~loc_id
        INTO TABLE @rt_reservation.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_inventory_repository~read_stock.

    TRY.
        SELECT
          inv~material_id,
          txt~description AS mat_desc,
          loc~wh_id,
          inv~loc_id,
          inv~stock_qty,
          mat~uom
        FROM zzad6_d_inventor AS inv
        INNER JOIN zzad6_d_location AS loc
          ON loc~loc_id = inv~loc_id
        INNER JOIN zzad6_d_material AS mat
          ON mat~material_id = inv~material_id
        LEFT JOIN zzad6_d_mat_t AS txt
          ON txt~material_id = inv~material_id
         AND txt~langu = @sy-langu
        WHERE loc~wh_id = @iv_warehouse_id
        INTO TABLE @rt_stock.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
