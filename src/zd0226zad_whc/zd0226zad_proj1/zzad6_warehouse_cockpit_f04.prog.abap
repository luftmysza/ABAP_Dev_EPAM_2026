*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_F04
*&---------------------------------------------------------------------*

FORM check_0300_item.

  CLEAR: gv_0300_mat_txt, gv_0300_uom, gv_0300_avail_qty.

  IF gv_0300_mat_id IS INITIAL.
    MESSAGE 'Enter material' TYPE 'E'.
  ENDIF.
  PERFORM validate_material USING gv_0300_mat_id.

  SELECT SINGLE description
  FROM zzad6_d_mat_t
  WHERE material_id = @gv_0300_mat_id
    AND langu = @sy-langu
  INTO @gv_0300_mat_txt.

  SELECT SINGLE uom
  FROM zzad6_d_material
  WHERE material_id = @gv_0300_mat_id
  INTO @gv_0300_uom.

  IF gv_0300_loc_id IS INITIAL.
    MESSAGE 'Enter location' TYPE 'E'.
  ENDIF.
  PERFORM validate_location USING gv_0300_loc_id.

  SELECT SINGLE stock_qty
   FROM zzad6_d_inventor
   WHERE material_id = @gv_0300_mat_id
     AND loc_id      = @gv_0300_loc_id
   INTO @DATA(lv_stock_qty).

  SELECT SUM( item~qty )
  FROM zzad6_d_ship_itm AS item
  INNER JOIN zzad6_d_shipment AS ship
    ON ship~ship_id = item~ship_id
  WHERE item~material_id = @gv_0300_mat_id
    AND item~loc_id      = @gv_0300_loc_id
    AND ship~ship_date   > @sy-datum
  INTO @DATA(lv_reserved_qty).

  IF lv_reserved_qty IS INITIAL.
    lv_reserved_qty = 0.
  ENDIF.

  gv_0300_avail_qty = lv_stock_qty - lv_reserved_qty.

  IF gv_0300_avail_qty EQ 0.
    MESSAGE 'No inventory found for material/location' TYPE 'E'.
  ENDIF.


  IF gv_0300_qty IS INITIAL.
    MESSAGE 'Provide needed quantity' TYPE 'I'.
    RETURN.
  ENDIF.

  IF gv_0300_qty IS INITIAL OR gv_0300_qty <= 0.
    MESSAGE 'Enter positive quantity' TYPE 'E'.
  ENDIF.


  IF gv_0300_qty > gv_0300_avail_qty.
    MESSAGE 'Quantity exceeds available stock' TYPE 'E'.
  ENDIF.

  MESSAGE 'Item is valid' TYPE 'S'.

ENDFORM.


FORM append_0300_item.
  DATA lv_next_item TYPE zzad6_d_ship_itm-line_no.

  DESCRIBE TABLE gt_ship_items LINES DATA(lv_lines).
  lv_next_item = ( lv_lines + 1 ) * 10.

  CLEAR gs_ship_item.

  gs_ship_item-item_no     = lv_next_item.
  gs_ship_item-material_id = gv_0300_mat_id.
  gs_ship_item-mat_desc    = gv_0300_mat_txt.
  gs_ship_item-source_loc  = gv_0300_loc_id.
  gs_ship_item-qty         = gv_0300_qty.
  gs_ship_item-uom         = gv_0300_uom.

  APPEND gs_ship_item TO gt_ship_items.
ENDFORM.
