*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_F03
*&---------------------------------------------------------------------*

FORM save_shipment_draft.
  DATA:
    ls_shipment TYPE zzad6_d_shipment,
    lt_items    TYPE STANDARD TABLE OF zzad6_d_ship_itm,
    ls_item     TYPE zzad6_d_ship_itm.

  PERFORM validate_partner USING zzad6_d_partner-bp_id.

  IF gv_0200_ship_date IS INITIAL.
    MESSAGE 'Enter shipment date' TYPE 'E'.
  ENDIF.

  IF gv_0200_ship_date <= sy-datum.
    MESSAGE 'Shipping date must be in future' TYPE 'E'.
  ENDIF.

  IF gt_ship_items IS INITIAL.
    MESSAGE 'Add at least one item' TYPE 'E'.
  ENDIF.

  ls_shipment-ship_id   = gv_0200_ship_id.
  ls_shipment-bp_id     = zzad6_d_partner-bp_id.
  ls_shipment-ship_date = gv_0200_ship_date.

  LOOP AT gt_ship_items INTO DATA(ls_ui).
    CLEAR ls_item.

    ls_item-ship_id     = gv_0200_ship_id.
    ls_item-line_no     = ls_ui-item_no.
    ls_item-material_id = ls_ui-material_id.
    ls_item-loc_id      = ls_ui-source_loc.
    ls_item-qty         = ls_ui-qty.

    APPEND ls_item TO lt_items.
  ENDLOOP.

  CALL FUNCTION 'ZZAD6_FM_SAVE_SHIPMENT'
    IN UPDATE TASK
    EXPORTING
      is_shipment = ls_shipment
    TABLES
      it_items    = lt_items.

  COMMIT WORK AND WAIT.

  MESSAGE |Shipment { gv_0200_ship_id } saved| TYPE 'S'.
ENDFORM.

*&---------------------------------------------------------------------*

FORM remove_selected_item .
  DATA:
    lt_rows TYPE lvc_t_row,
    ls_row  TYPE lvc_s_row.

  IF go_alv_items IS NOT BOUND.
    RETURN.
  ENDIF.

  CALL METHOD go_alv_items->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  READ TABLE lt_rows INTO ls_row INDEX 1.
  IF sy-subrc <> 0.
    MESSAGE 'Select an item first' TYPE 'I'.
    RETURN.
  ENDIF.

  DELETE gt_ship_items INDEX ls_row-index.

  CALL METHOD go_alv_items->refresh_table_display.
ENDFORM.

*&---------------------------------------------------------------------*

FORM init_shipment_create.
  CLEAR:
    gv_0200_ship_id,
    gv_0200_bp_txt,
    gv_0200_ship_date,
    gt_ship_items,
    gs_ship_item,
    zzad6_d_partner.

  gv_0200_ship_date = sy-datum + 1.
  PERFORM generate_ship_id CHANGING gv_0200_ship_id.

  PERFORM lock_shipment USING gv_0200_ship_id.

  PERFORM fill_partner_text USING zzad6_d_partner-bp_id CHANGING gv_0200_bp_txt.
ENDFORM.

*&---------------------------------------------------------------------*

FORM init_shipment_edit.
  CLEAR:
    gv_0200_ship_id,
    gv_0200_bp_txt,
    gv_0200_ship_date,
    gt_ship_items,
    gs_ship_item,
    zzad6_d_partner.

  gv_0200_ship_id = gs_ship-ship_id.
  PERFORM lock_shipment USING gv_0200_ship_id.
  PERFORM load_shipment_for_edit.
  PERFORM fill_partner_text USING zzad6_d_partner-bp_id CHANGING gv_0200_bp_txt.
ENDFORM.

*&---------------------------------------------------------------------*

FORM load_shipment_for_edit.
  CLEAR zzad6_d_partner.

  SELECT SINGLE
      ship_id,
      bp_id,
      ship_date
    FROM zzad6_d_shipment
    WHERE ship_id = @gv_0200_ship_id
    INTO ( @gv_0200_ship_id,
           @zzad6_d_partner-bp_id,
           @gv_0200_ship_date ).

  IF sy-subrc <> 0.
    MESSAGE 'Shipment not found' TYPE 'E'.
  ENDIF.

  SELECT
      item~line_no     AS item_no,
      item~material_id AS material_id,
      txt~description  AS mat_desc,
      item~loc_id      AS source_loc,
      item~qty         AS qty,
      mat~uom          AS uom
    FROM zzad6_d_ship_itm AS item
    LEFT JOIN zzad6_d_mat_t AS txt
      ON txt~material_id = item~material_id
     AND txt~langu = @sy-langu
    LEFT JOIN zzad6_d_material AS mat
      ON mat~material_id = item~material_id
    WHERE item~ship_id = @gv_0200_ship_id
    INTO CORRESPONDING FIELDS OF TABLE @gt_ship_items.
ENDFORM.

*&---------------------------------------------------------------------*

FORM generate_ship_id CHANGING cv_ship_id.
  SELECT MAX( ship_id )
    FROM zzad6_d_shipment
    INTO @DATA(lv_max_id).

  IF lv_max_id IS INITIAL.
    cv_ship_id = 1.
  ELSE.
    cv_ship_id = lv_max_id + 1.
  ENDIF.
ENDFORM.
