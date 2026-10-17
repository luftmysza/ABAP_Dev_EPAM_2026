*&---------------------------------------------------------------------*
*& Include          ZZAD6_WH_COCKPIT_OOP_I01
*&---------------------------------------------------------------------*


MODULE pai_0110 INPUT.
  lv_ucomm = gv_0110_ucomm.
  CLEAR gv_0110_ucomm.

  TRY.
      lv_navigation = go_app->dispatch( lv_ucomm ).

      CLEAR gs_0110_data.

      PERFORM navigate USING lv_navigation.

    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'W' DISPLAY LIKE 'E'.
      CLEAR lx_error.
  ENDTRY.

ENDMODULE.

MODULE pai_0210 INPUT.
  lv_ucomm = gv_0210_ucomm.
  CLEAR gv_0210_ucomm.

  TRY.
      lv_navigation = go_app->dispatch( lv_ucomm ).

      CLEAR gs_0210_data.

      PERFORM navigate USING lv_navigation.

    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'W' DISPLAY LIKE 'E'.
      CLEAR lx_error.
  ENDTRY.

ENDMODULE.

MODULE pai_0220 INPUT.
  lv_ucomm = gv_0220_ucomm.
  CLEAR gv_0220_ucomm.

  TRY.
      lv_navigation = go_app->dispatch(
        iv_ucomm            = lv_ucomm
        is_shipment_details = gs_0220_data ).

      CLEAR gs_0220_data.

      PERFORM navigate USING lv_navigation.

    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'W' DISPLAY LIKE 'E'.
      CLEAR lx_error.
  ENDTRY.

ENDMODULE.

MODULE pai_0230 INPUT.
  lv_ucomm = gv_0230_ucomm.
  CLEAR gv_0230_ucomm.

  TRY.
      lv_navigation = go_app->dispatch(
        iv_ucomm                 = lv_ucomm
        is_shipment_item_details = gs_0230_data ).

      CLEAR gs_0230_data.

      PERFORM navigate USING lv_navigation.

    CATCH zzad6_cx_error INTO lx_error.
      MESSAGE lx_error->get_text( ) TYPE 'W' DISPLAY LIKE 'E'.
      CLEAR lx_error.
  ENDTRY.

ENDMODULE.
