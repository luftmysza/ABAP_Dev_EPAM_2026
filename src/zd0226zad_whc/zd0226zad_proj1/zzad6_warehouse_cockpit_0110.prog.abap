*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_0110
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  SET PF-STATUS 'S0110'.
* SET TITLEBAR 'xxx'.
ENDMODULE.

MODULE pbo_0110 OUTPUT.
  CLEAR gt_ship.
  PERFORM load_shipments.

  IF go_cont_ship IS INITIAL.

    CREATE OBJECT go_cont_ship
      EXPORTING
        container_name = 'CC_SHIP'.

    CREATE OBJECT go_alv_ship
      EXPORTING
        i_parent = go_cont_ship.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZZAD6_S_SHIP_ALV'
      CHANGING
        ct_fieldcat      = lt_fcat_ship.

    LOOP AT lt_fcat_ship ASSIGNING <ls_fcat>.
      CASE <ls_fcat>-fieldname.
        WHEN 'SHIP_DATE'.
          <ls_fcat>-coltext   = 'Shipping date'.
        WHEN 'ITEM_COUNT'.
          <ls_fcat>-coltext   = 'Item Count'.
      ENDCASE.
    ENDLOOP.

    CALL METHOD go_alv_ship->set_table_for_first_display
      EXPORTING
        i_structure_name = 'ZZAD6_S_SHIP_ALV'
      CHANGING
        it_outtab        = gt_ship
        it_fieldcatalog  = lt_fcat_ship.

  ELSE.
    CALL METHOD go_alv_ship->refresh_table_display.
  ENDIF.


ENDMODULE.

MODULE pai_0110 INPUT.
  CASE gv_0110_ucomm.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.

    WHEN 'CREATE'.
      IF p_open IS INITIAL.
        MESSAGE 'Editing allowed only in OPEN mode' TYPE 'I'.
        RETURN.
      ENDIF.
      PERFORM init_shipment_create.
      CALL SCREEN 0200.

    WHEN 'EDIT'.
      IF p_open IS INITIAL.
        MESSAGE 'Editing allowed only in OPEN mode' TYPE 'I'.
        RETURN.
      ENDIF.

      PERFORM get_selected_shipment.
      IF gs_ship-ship_id IS INITIAL.
        MESSAGE 'Select a shipment first' TYPE 'I'.
      ELSE.
        PERFORM init_shipment_edit.
        CALL SCREEN 0200.
      ENDIF.

    WHEN 'DELETE'.
      IF p_open IS INITIAL.
        MESSAGE 'Editing allowed only in OPEN mode' TYPE 'I'.
        RETURN.
      ENDIF.

      PERFORM get_selected_shipment.

      IF gs_ship-ship_id IS INITIAL.
        MESSAGE 'Select a shipment first' TYPE 'I'.
        RETURN.
      ENDIF.

      gv_0200_ship_id = gs_ship-ship_id.

      PERFORM lock_shipment USING gv_0200_ship_id.
      PERFORM delete_selected_shipment.
      PERFORM unlock_shipment USING gv_0200_ship_id.

      PERFORM load_shipments.
      CALL METHOD go_alv_ship->refresh_table_display.

  ENDCASE.
  CLEAR gv_0110_ucomm.
ENDMODULE.
