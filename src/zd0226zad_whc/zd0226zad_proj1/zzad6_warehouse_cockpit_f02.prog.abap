*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_F02
*&---------------------------------------------------------------------*

FORM load_inventory.
  CLEAR gt_inv.

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
    WHERE loc~wh_id = @p_whid

    INTO CORRESPONDING FIELDS OF TABLE @gt_inv.

  LOOP AT gt_inv ASSIGNING FIELD-SYMBOL(<ls_inv>).
    SELECT SUM( item~qty )
      FROM zzad6_d_ship_itm AS item
      INNER JOIN zzad6_d_shipment AS ship
        ON ship~ship_id = item~ship_id
      WHERE item~material_id = @<ls_inv>-material_id
        AND item~loc_id = @<ls_inv>-loc_id
      INTO @<ls_inv>-reserved_qty.

    <ls_inv>-avail_qty = <ls_inv>-stock_qty - <ls_inv>-reserved_qty.
  ENDLOOP.
ENDFORM.


FORM load_shipments.
  CLEAR gt_ship.

  IF p_open = abap_true.
    SELECT ship~ship_id, ship~bp_id, ship~ship_date
      FROM zzad6_d_shipment AS ship
      WHERE ship~ship_date > @sy-datum
      INTO CORRESPONDING FIELDS OF TABLE @gt_ship.
  ELSEIF p_due = abap_true.
    SELECT ship~ship_id, ship~bp_id, ship~ship_date
      FROM zzad6_d_shipment AS ship
      WHERE ship~ship_date = @sy-datum
      INTO CORRESPONDING FIELDS OF TABLE @gt_ship.
  ELSE.
    SELECT ship~ship_id, ship~bp_id, ship~ship_date
      FROM zzad6_d_shipment AS ship
      INTO CORRESPONDING FIELDS OF TABLE @gt_ship.
  ENDIF.

  LOOP AT gt_ship ASSIGNING FIELD-SYMBOL(<ls_ship>).
    SELECT SINGLE first_name, last_name
      FROM zzad6_d_partner
      WHERE bp_id = @<ls_ship>-bp_id
      INTO @DATA(ls_partner).

    IF sy-subrc = 0.
      CONCATENATE ls_partner-first_name ls_partner-last_name
        INTO <ls_ship>-partner_name
        SEPARATED BY space.
    ENDIF.

    SELECT COUNT(*)
      FROM zzad6_d_ship_itm
      WHERE ship_id = @<ls_ship>-ship_id
      INTO @<ls_ship>-item_count.
  ENDLOOP.
ENDFORM.


FORM get_selected_shipment.
  CLEAR gs_ship.

  DATA lt_rows TYPE lvc_t_row.
  DATA ls_row  TYPE lvc_s_row.

  CALL METHOD go_alv_ship->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  READ TABLE lt_rows INTO ls_row INDEX 1.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  READ TABLE gt_ship INTO gs_ship INDEX ls_row-index.
ENDFORM.

FORM prepare_0100_context .
  CLEAR:
     gv_0100_wh_id,
     gv_0100_wh_txt.

  gv_0100_wh_id = p_whid.

  IF gv_0100_wh_id IS INITIAL.
    gv_0100_wh_txt = 'All warehouses'.
   ELSE.
    SELECT SINGLE name
     FROM zzad6_d_wareh
     WHERE wh_id = @p_whid
     INTO @gv_0100_wh_txt.
  ENDIF.

ENDFORM.

FORM prepare_0110_context .
  CLEAR:
     gv_0110_wh_id,
     gv_0110_wh_txt.

  gv_0110_wh_id = p_whid.

  SELECT SINGLE name
    FROM zzad6_d_wareh
    WHERE wh_id = @p_whid
    INTO @gv_0110_wh_txt.

  IF p_open EQ abap_true.
    gv_0110_mode_txt = 'Open shipments'.
  ELSEIF p_due EQ abap_true.
    gv_0110_mode_txt = 'Shipments due today'.
  ELSE.
    gv_0110_mode_txt = 'All shipments'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*

FORM delete_selected_shipment .

  DELETE FROM zzad6_d_ship_itm
    WHERE ship_id = @gv_0200_ship_id.

  IF sy-subrc <> 0.
    "No items is not fatal
  ENDIF.

  DELETE FROM zzad6_d_shipment
    WHERE ship_id = @gv_0200_ship_id.

  IF sy-subrc <> 0.
    MESSAGE 'Shipment header could not be deleted' TYPE 'E'.
  ENDIF.

  COMMIT WORK AND WAIT.

  CLEAR:
    gs_ship,
    gv_0200_ship_id.

  MESSAGE 'Shipment deleted' TYPE 'S'.
ENDFORM.
