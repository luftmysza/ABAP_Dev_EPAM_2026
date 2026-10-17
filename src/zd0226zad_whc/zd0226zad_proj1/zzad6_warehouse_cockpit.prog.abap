*&---------------------------------------------------------------------*
*& Report ZZAD6_WAREHOUSE_COCKPIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzad6_warehouse_cockpit.

INCLUDE zzad6_warehouse_cockpit_top.
INCLUDE zzad6_warehouse_cockpit_sel.
INCLUDE zzad6_warehouse_cockpit_f01.

AT SELECTION-SCREEN.
  PERFORM validate_warehouse USING p_whid.

  CASE sy-ucomm.
    WHEN 'INV'.
      PERFORM prepare_0100_context.
      CALL SCREEN 0100.

    WHEN 'SHIP'.
      PERFORM prepare_0110_context.
      CALL SCREEN 0110.
  ENDCASE.

INCLUDE zzad6_warehouse_cockpit_0100.
INCLUDE zzad6_warehouse_cockpit_0110.
INCLUDE zzad6_warehouse_cockpit_0200.
INCLUDE zzad6_warehouse_cockpit_0300.
