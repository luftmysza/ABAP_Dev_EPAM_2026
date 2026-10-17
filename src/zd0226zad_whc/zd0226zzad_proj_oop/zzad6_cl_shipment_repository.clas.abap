CLASS zzad6_cl_shipment_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zzad6_if_shipment_repository .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZZAD6_CL_SHIPMENT_REPOSITORY IMPLEMENTATION.


  METHOD zzad6_if_shipment_repository~delete_shipment.
    TRY.
        DELETE FROM zzad6_d_ship_itm
        WHERE ship_id = @iv_shipment_id.

        DELETE FROM zzad6_d_shipment
        WHERE ship_id = @iv_shipment_id.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_shipment_repository~find_items_by_shipment_id.
    TRY.
        SELECT *
        FROM zzad6_d_ship_itm
        WHERE ship_id = @iv_shipment_id
        ORDER BY line_no
        INTO TABLE @rt_shipment_item.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_shipment_repository~find_shipment_by_id.
    TRY.
        SELECT SINGLE
          ship~*
        FROM zzad6_d_shipment AS ship
        WHERE ship_id = @iv_shipment_id
        INTO @rs_shipment.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

    IF rs_shipment IS INITIAL.
      RAISE EXCEPTION TYPE zzad6_cx_not_found
        EXPORTING
          textid    = zzad6_cx_not_found=>shipment
          entity_id = CONV symsgv( iv_shipment_id ).
    ENDIF.

  ENDMETHOD.


  METHOD zzad6_if_shipment_repository~get_reserved_quantity.

    SELECT SUM( item~qty )
      FROM zzad6_d_ship_itm AS item
      INNER JOIN zzad6_d_shipment AS ship
        ON ship~ship_id = item~ship_id
      WHERE item~material_id = @iv_material_id
        AND item~loc_id      = @iv_loc_id
        AND ship~ship_date   >= @iv_date_from
      INTO @rv_reserved_qty.

    IF rv_reserved_qty IS INITIAL.
      rv_reserved_qty = 0.
    ENDIF.

  ENDMETHOD.


  METHOD zzad6_if_shipment_repository~read_item_counts.
    TRY.
        SELECT
          ship~ship_id,
          COUNT( item~line_no ) AS item_count
        FROM zzad6_d_ship_itm AS item
        INNER JOIN zzad6_d_shipment AS ship
          ON item~ship_id = ship~ship_id
        GROUP BY ship~ship_id
        INTO TABLE @rt_item_count.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_shipment_repository~read_shipments.
    TRY.
        SELECT DISTINCT
          ship~*
        FROM zzad6_d_ship_itm AS item
        INNER JOIN zzad6_d_shipment AS ship
          ON ship~ship_id = item~ship_id
        INNER JOIN zzad6_d_location AS loc
          ON item~loc_id = loc~loc_id
        INNER JOIN zzad6_d_wareh AS wareh
          ON loc~wh_id = wareh~wh_id
        WHERE ( @iv_warehouse_id IS INITIAL
          OR wareh~wh_id = @iv_warehouse_id )
        AND
          ( @iv_date_from IS INITIAL
          OR ship~ship_date >= @iv_date_from )
        AND
          ( @iv_date_to IS INITIAL
          OR ship~ship_date <= @iv_date_to )
        INTO TABLE @rt_shipment.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        RAISE EXCEPTION TYPE zzad6_cx_persistence
          EXPORTING
            textid   = zzad6_cx_persistence=>database_error
            previous = lx_sql.
    ENDTRY.

  ENDMETHOD.


  METHOD zzad6_if_shipment_repository~save_shipment.
    CALL FUNCTION 'ZZAD6_FM_SAVE_SHIPMENT'
      IN UPDATE TASK
      EXPORTING
        is_shipment = is_shipment
      TABLES
        it_items    = it_items.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zzad6_cx_persistence
        EXPORTING
          textid    = zzad6_cx_persistence=>shipment_not_updated
          entity_id = CONV symsgv( is_shipment-ship_id ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
