*&---------------------------------------------------------------------*
*& Include          ZZAD6_WAREHOUSE_COCKPIT_F01
*&---------------------------------------------------------------------*

FORM validate_warehouse USING iv_wh_id.

  SELECT SINGLE wh_id
    FROM zzad6_d_wareh
    WHERE wh_id = @iv_wh_id
    INTO @DATA(lv_wh_id).

  IF sy-subrc <> 0.
    MESSAGE 'Warehouse does not exist' TYPE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*

FORM validate_material USING iv_mat_id.
  SELECT SINGLE material_id
    FROM zzad6_d_material
    WHERE material_id = @iv_mat_id
    INTO @DATA(lv_material_id).

  IF sy-subrc <> 0.
    MESSAGE 'Material does not exist' TYPE 'E'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*

FORM fill_material_text USING iv_mat_id CHANGING cv_mat_txt.
  IF iv_mat_id IS INITIAL.
    RETURN.
  ENDIF.

  SELECT SINGLE title
    FROM zzad6_d_mat_t
    WHERE material_id = @iv_mat_id
      AND langu = @sy-langu
    INTO @cv_mat_txt.
ENDFORM.

*&---------------------------------------------------------------------*

FORM validate_partner USING iv_bp_id.
  SELECT SINGLE bp_id
    FROM zzad6_d_partner
    WHERE bp_id = @iv_bp_id
    INTO @DATA(lv_bp_id).

  IF sy-subrc <> 0.
    MESSAGE 'Partner does not exist' TYPE 'E'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*

FORM fill_partner_text USING iv_bp_id CHANGING cv_bp_txt.
  IF iv_bp_id IS INITIAL.
    RETURN.
  ENDIF.

  SELECT SINGLE first_name, last_name
    FROM zzad6_d_partner
    WHERE bp_id = @iv_bp_id
    INTO @DATA(ls_partner).

  IF sy-subrc = 0.
    CONCATENATE ls_partner-first_name ls_partner-last_name
      INTO cv_bp_txt
      SEPARATED BY space.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*

FORM validate_location  USING iv_loc_id.
  SELECT SINGLE loc_id
   FROM zzad6_d_location
   WHERE loc_id = @iv_loc_id
   INTO @DATA(lv_loc_id).

  IF sy-subrc <> 0.
    MESSAGE 'Location does not exist' TYPE 'E'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*

FORM lock_shipment USING iv_ship_id.

  CALL FUNCTION 'ENQUEUE_EZAD6_SHIPMENT'
    EXPORTING
      mode_zzad6_d_shipment = 'E'
      mandt                 = sy-mandt
      ship_id               = iv_ship_id
    EXCEPTIONS
      foreign_lock          = 1
      system_failure        = 2
      OTHERS                = 3.

  IF sy-subrc <> 0.
    MESSAGE 'Shipment is locked by another user' TYPE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*

FORM unlock_shipment USING iv_ship_id.

  IF iv_ship_id IS INITIAL.
    RETURN.
  ENDIF.

  CALL FUNCTION 'DEQUEUE_EZAD6_SHIPMENT'
    EXPORTING
      mode_zzad6_d_shipment = 'E'
      mandt                 = sy-mandt
      ship_id               = iv_ship_id.

ENDFORM.
