*&---------------------------------------------------------------------*
*& Include          ZZAD6_WH_COCKPIT_OOP_O01
*&---------------------------------------------------------------------*



MODULE pbo_0110 OUTPUT.
  SET PF-STATUS 'S0110'.
  SET TITLEBAR 'T0110'.

  TRY.
      go_app->show_inventory(
        IMPORTING
          es_data = gs_0110_data ).

    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'W' DISPLAY LIKE 'E'.
      CLEAR lx_error.
  ENDTRY.

ENDMODULE.


MODULE pbo_0210 OUTPUT.
  SET PF-STATUS 'S0210'.
  SET TITLEBAR 'T0210'.

  TRY.
      go_app->show_shipments(
        IMPORTING
          es_data = gs_0210_data ).

    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'W' DISPLAY LIKE 'E'.
      CLEAR lx_error.
  ENDTRY.

ENDMODULE.


MODULE pbo_0220 OUTPUT.
  SET PF-STATUS 'S0220'.
  SET TITLEBAR 'T0220'.

  TRY.
      go_app->show_shipment_details(
        IMPORTING
          es_data = gs_0220_data ).

    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'W' DISPLAY LIKE 'E'.
      CLEAR lx_error.
  ENDTRY.

ENDMODULE.

MODULE pbo_0230 OUTPUT.
  SET PF-STATUS 'S0230'.
  SET TITLEBAR 'T0230'.

  TRY.
      go_app->show_item_editor(
        IMPORTING
          es_data = gs_0230_data ).

    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'W' DISPLAY LIKE 'E'.
      CLEAR lx_error.
  ENDTRY.

ENDMODULE.
