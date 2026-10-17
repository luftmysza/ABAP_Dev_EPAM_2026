*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:
    p_whid TYPE zzad6_d_wareh-wh_id OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS:
    p_open RADIOBUTTON GROUP mode DEFAULT 'X',
    p_due  RADIOBUTTON GROUP mode,
    p_all  RADIOBUTTON GROUP mode.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN PUSHBUTTON /1(25) btn_inv  USER-COMMAND inv.
  SELECTION-SCREEN PUSHBUTTON /1(25) btn_ship USER-COMMAND ship.
SELECTION-SCREEN END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT.
  btn_inv  = 'Show Inventory'.
  btn_ship = 'Show Shipments'.
