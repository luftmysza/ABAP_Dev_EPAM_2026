*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_0300
*&---------------------------------------------------------------------*

INCLUDE zzad6_warehouse_cockpit_f04.

MODULE status_0300 OUTPUT.
  SET PF-STATUS 'S0300'.
ENDMODULE.

MODULE pbo_0300 OUTPUT.
ENDMODULE.

MODULE pai_0300 INPUT.
  CASE gv_0300_ucomm.
    WHEN 'CHECK'.
      PERFORM check_0300_item.
    WHEN 'ACCEPT'.
      PERFORM check_0300_item.
      PERFORM append_0300_item.
      LEAVE TO SCREEN 0.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'PULL'.
      PERFORM validate_material USING gv_0300_mat_id.
      PERFORM fill_material_text USING gv_0300_mat_id CHANGING gv_0300_mat_txt.
      MODIFY SCREEN.
    WHEN 'SUGGEST'.
      MESSAGE 'Has not been implementation yet..' TYPE 'I'.
  ENDCASE.
  CLEAR gv_0300_ucomm.
ENDMODULE.
