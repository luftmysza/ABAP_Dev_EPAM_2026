*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_0200
*&---------------------------------------------------------------------*
INCLUDE zzad6_warehouse_cockpit_f03.

MODULE status_0200 OUTPUT.
  SET PF-STATUS 'S0200'.
*   SET TITLEBAR 'T0200'.
ENDMODULE.

MODULE pbo_0200 OUTPUT.
  IF go_cont_items IS INITIAL.
    CREATE OBJECT go_cont_items
      EXPORTING
        container_name = 'CC_ITEMS'.

    CREATE OBJECT go_alv_items
      EXPORTING
        i_parent = go_cont_items.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZZAD6_S_SHIP_ITEM_ALV'
      CHANGING
        ct_fieldcat      = lt_fcat_itm.

    LOOP AT lt_fcat_itm ASSIGNING <ls_fcat>.
      CASE <ls_fcat>-fieldname.
        WHEN 'MAT_DESC'.
          <ls_fcat>-coltext   = 'Material Description'.
        WHEN 'QTY'.
          <ls_fcat>-coltext   = 'Quantity'.
        WHEN 'ITEM_NO'.
          <ls_fcat>-coltext   = 'Item Number'.
      ENDCASE.
    ENDLOOP.

    CALL METHOD go_alv_items->set_table_for_first_display
      EXPORTING
        i_structure_name = 'ZZAD6_S_SHIP_ITEM_ALV'
      CHANGING
        it_outtab        = gt_ship_items
        it_fieldcatalog  = lt_fcat_itm.
  ELSE.
    CALL METHOD go_alv_items->refresh_table_display.
  ENDIF.
ENDMODULE.

MODULE pai_0200 INPUT.
  CASE gv_0200_ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      PERFORM unlock_shipment USING gv_0200_ship_id.
      LEAVE TO SCREEN 0110.
    WHEN 'PULL'.
      PERFORM validate_partner USING zzad6_d_partner-bp_id.
      PERFORM fill_partner_text USING zzad6_d_partner-bp_id CHANGING gv_0200_bp_txt.
      MODIFY SCREEN.
    WHEN 'ADDITEM'.
      CLEAR:
        gv_0300_mat_id,
        gv_0300_mat_txt,
        gv_0300_loc_id,
        gv_0300_qty,
        gv_0300_uom,
        gv_0300_avail_qty.

      CALL SCREEN 0300.
    WHEN 'DELETE'.
      PERFORM lock_shipment USING gv_0200_ship_id.
      PERFORM remove_selected_item.
      PERFORM unlock_shipment USING gv_0200_ship_id.
    WHEN 'SAVE'.
      PERFORM save_shipment_draft.
      PERFORM unlock_shipment USING gv_0200_ship_id.
      LEAVE TO SCREEN 0110.
  ENDCASE.

  CLEAR gv_0200_ucomm.
ENDMODULE.
