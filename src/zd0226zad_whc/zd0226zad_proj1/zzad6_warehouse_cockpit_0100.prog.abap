*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_0100
*&---------------------------------------------------------------------*

INCLUDE zzad6_warehouse_cockpit_f02.

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
* SET TITLEBAR 'T0100'.
ENDMODULE.


MODULE pbo_0100 OUTPUT.
  CLEAR gt_inv.
  PERFORM load_inventory.

  IF go_cont_inv IS INITIAL.

    CREATE OBJECT go_cont_inv
      EXPORTING
        container_name = 'CC_INV'.

    CREATE OBJECT go_alv_inv
      EXPORTING
        i_parent = go_cont_inv.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZZAD6_S_INV_ALV'
      CHANGING
        ct_fieldcat      = lt_fcat_inv.

    LOOP AT lt_fcat_inv ASSIGNING <ls_fcat>.
      CASE <ls_fcat>-fieldname.
        WHEN 'MATERIAL_ID'.
          <ls_fcat>-coltext   = 'Material ID'.
        WHEN 'MAT_DESC'.
          <ls_fcat>-coltext   = 'Material Description'.
        WHEN 'WH_ID'.
          <ls_fcat>-coltext   = 'Warehouse ID'.
        WHEN 'LOC_ID'.
          <ls_fcat>-coltext   = 'Location ID'.
        WHEN 'STOCK_QTY'.
          <ls_fcat>-coltext    = 'Stock Quantity'.
        WHEN 'RESERVED_QTY'.
          <ls_fcat>-coltext    = 'Reserved Quantity'.
        WHEN 'AVAIL_QTY'.
          <ls_fcat>-coltext    = 'Available Quantity'.
        WHEN 'UOM'.
          <ls_fcat>-coltext   = 'Unit'.
      ENDCASE.
    ENDLOOP.

    CALL METHOD go_alv_inv->set_table_for_first_display
      EXPORTING
        i_structure_name = 'ZZAD6_S_INV_ALV'
      CHANGING
        it_outtab        = gt_inv
        it_fieldcatalog  = lt_fcat_inv.
  ELSE.
    CALL METHOD go_alv_inv->refresh_table_display.
  ENDIF.

ENDMODULE.

MODULE pai_0100 INPUT.
  CASE gv_0100_ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.

  CLEAR gv_0100_ucomm.
ENDMODULE.
